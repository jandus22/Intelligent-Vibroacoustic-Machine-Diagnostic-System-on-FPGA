#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "sleep.h"
#include "platform.h"

#include "xaxidma.h"
#include "xaxidma_hw.h"

#include "lwip/init.h"
#include "lwip/udp.h"
#include "lwip/ip_addr.h"
#include "lwip/pbuf.h"
#include "lwip/netif.h"

#include "netif/xadapter.h"

#include <string.h>
#include <stdint.h>

/* -------------------- Hardware configuration -------------------- */

#define USE_GEM_BASEADDR       XPAR_XEMACPS_1_BASEADDR
#define DMA_BASEADDR           XPAR_XAXIDMA_0_BASEADDR

/* -------------------- DMA frame configuration -------------------- */

#define FFT_SIZE               1024U
#define FRAME_HEADER_WORDS     3U

#define DMA_FRAME_WORDS        (FRAME_HEADER_WORDS + FFT_SIZE)
#define DMA_FRAME_BYTES        (DMA_FRAME_WORDS * sizeof(uint32_t))

#define CACHE_LINE_BYTES       64U
#define DMA_BUFFER_BYTES       \
    ((DMA_FRAME_BYTES + CACHE_LINE_BYTES - 1U) & \
     ~(CACHE_LINE_BYTES - 1U))

#define DMA_BUFFER_WORDS       \
    (DMA_BUFFER_BYTES / sizeof(uint32_t))

#define DMA_TIMEOUT            100000000U

/* -------------------- UDP configuration -------------------- */

#define UDP_CHUNK_WORDS        256U
#define DEST_PORT              5001U

/*
 * Po pierwszym pakiecie UDP stos może najpierw wysłać zapytanie ARP.
 * W tym czasie musimy przetwarzać ramki wejściowe, aby odebrać odpowiedź.
 */
#define ARP_WAIT_TIME_MS       250U
#define BETWEEN_PACKETS_MS     2U
#define AFTER_SEND_WAIT_MS     2U

#define STATUS_PRINT_PERIOD    100U
#define VERBOSE_FRAME_COUNT    3U

typedef struct {
    uint32_t frame_id;
    uint16_t packet_id;
    uint16_t packet_count;
} __attribute__((packed)) udp_header_t;

/* -------------------- Global objects -------------------- */

static uint32_t frame_counter = 0U;
static struct netif server_netif;
struct netif *echo_netif;

static XAxiDma AxiDma;

/*
 * Rozmiar bufora jest zaokrąglony do pełnej linii pamięci podręcznej.
 * Sam transfer DMA nadal ma dokładnie DMA_FRAME_BYTES.
 */
static uint32_t fft_buffer[DMA_BUFFER_WORDS]
    __attribute__((aligned(CACHE_LINE_BYTES)));

static unsigned char mac_ethernet_address[] = {
    0x00, 0x0A, 0x35, 0x00, 0x01, 0x02
};

/* -------------------- Ethernet service -------------------- */

static void service_ethernet_ms(uint32_t duration_ms, int print_received)
{
    uint32_t i;

    for (i = 0U; i < duration_ms; i++) {
        int rx_result = xemacif_input(&server_netif);

        if ((print_received != 0) && (rx_result != 0)) {
            xil_printf(
                "DEBUG: xemacif_input returned %d\r\n",
                rx_result
            );
        }

        usleep(1000U);
    }
}

static void service_ethernet_forever(void)
{
    xil_printf("Entering Ethernet service loop\r\n");

    while (1) {
        int rx_result = xemacif_input(&server_netif);

        if (rx_result != 0) {
            xil_printf(
                "DEBUG: Ethernet input processed: %d\r\n",
                rx_result
            );
        }
    }
}

/* -------------------- DMA reception -------------------- */

static int receive_dma_frame(void)
{
    int status;
    uint32_t timeout;
    uint32_t i;

    for (i = 0U; i < DMA_BUFFER_WORDS; i++) {
        fft_buffer[i] = 0xDEADBEEFU;
    }

    /*
     * Usunięcie brudnych linii cache przed zapisaniem danych przez DMA.
     */
    Xil_DCacheFlushRange(
        (UINTPTR)fft_buffer,
        DMA_BUFFER_BYTES
    );

    status = XAxiDma_SimpleTransfer(
        &AxiDma,
        (UINTPTR)fft_buffer,
        DMA_FRAME_BYTES,
        XAXIDMA_DEVICE_TO_DMA
    );

    if (status != XST_SUCCESS) {
        xil_printf(
            "ERROR: XAxiDma_SimpleTransfer failed: %d\r\n",
            status
        );

        return XST_FAILURE;
    }

    timeout = DMA_TIMEOUT;

    while ((XAxiDma_Busy(
                &AxiDma,
                XAXIDMA_DEVICE_TO_DMA
            ) != 0) &&
           (timeout > 0U)) {

        /*
         * Nawet podczas oczekiwania na DMA obsługujemy Ethernet.
         * Dzięki temu lwIP może odpowiadać na ARP oraz ICMP.
         */
        xemacif_input(&server_netif);

        timeout--;
    }

    if (timeout == 0U) {
        uint32_t dma_status = XAxiDma_ReadReg(
            AxiDma.RegBase,
            XAXIDMA_RX_OFFSET + XAXIDMA_SR_OFFSET
        );

        xil_printf(
            "ERROR: DMA timeout, status: 0x%08lx\r\n",
            (unsigned long)dma_status
        );

        return XST_FAILURE;
    }

    /*
     * Unieważnienie cache po zapisaniu bufora przez DMA.
     */
    Xil_DCacheInvalidateRange(
        (UINTPTR)fft_buffer,
        DMA_BUFFER_BYTES
    );

    return XST_SUCCESS;
}

/* -------------------- UDP transmission -------------------- */

static int send_fft_frame_udp(
    struct udp_pcb *pcb,
    uint32_t frame_id
)
{
    uint32_t offset = 0U;
    uint16_t packet_id = 0U;

    const uint16_t total_packets =
        (uint16_t)(
            (FFT_SIZE + UDP_CHUNK_WORDS - 1U) /
            UDP_CHUNK_WORDS
        );

    while (offset < FFT_SIZE) {
        uint32_t chunk = UDP_CHUNK_WORDS;
        uint16_t payload_size;

        struct pbuf *p;
        udp_header_t header;
        err_t err;

        if ((offset + chunk) > FFT_SIZE) {
            chunk = FFT_SIZE - offset;
        }

        payload_size = (uint16_t)(
            sizeof(udp_header_t) +
            chunk * sizeof(uint32_t)
        );

        p = pbuf_alloc(
            PBUF_TRANSPORT,
            payload_size,
            PBUF_RAM
        );

        if (p == NULL) {
            xil_printf(
                "ERROR: pbuf_alloc failed for packet %u\r\n",
                (unsigned int)packet_id
            );

            return XST_FAILURE;
        }

        header.frame_id = frame_id;
        header.packet_id = packet_id;
        header.packet_count = total_packets;

        memcpy(
            p->payload,
            &header,
            sizeof(header)
        );

        memcpy(
            (uint8_t *)p->payload + sizeof(header),
            &fft_buffer[FRAME_HEADER_WORDS + offset],
            chunk * sizeof(uint32_t)
        );

        err = udp_send(pcb, p);

        /*
         * udp_send() kończy korzystanie z referencji należącej
         * do aplikacji. Jeżeli pakiet jest chwilowo kolejkowany
         * przez ARP, stos utrzymuje własną referencję.
         */
        pbuf_free(p);

        if (err != ERR_OK) {
            xil_printf(
                "ERROR: udp_send failed for packet %u: %d\r\n",
                (unsigned int)packet_id,
                (int)err
            );

            return XST_FAILURE;
        }

        if (frame_id < VERBOSE_FRAME_COUNT) {
            xil_printf(
                "Frame %lu: UDP packet %u/%u, samples %lu-%lu\r\n",
                (unsigned long)frame_id,
                (unsigned int)(packet_id + 1U),
                (unsigned int)total_packets,
                (unsigned long)offset,
                (unsigned long)(offset + chunk - 1U)
            );
        }

        /*
         * Pierwsze udp_send() może jedynie wysłać zapytanie ARP.
         * Dajemy stosowi czas na odebranie odpowiedzi ARP od PC.
         */
        if ((frame_id == 0U) && (packet_id == 0U)) {
            xil_printf(
                "Waiting for initial ARP response...\r\n"
            );
        
            service_ethernet_ms(
                ARP_WAIT_TIME_MS,
                1
            );
        } else {
            service_ethernet_ms(
                BETWEEN_PACKETS_MS,
                0
            );
        }

        offset += chunk;
        packet_id++;
    }

    

    /*
     * Przetwarzamy jeszcze ewentualną odpowiedź ARP
     * i dane oczekujące w kolejce sterownika.
     */
    service_ethernet_ms(
        AFTER_SEND_WAIT_MS,
        1
    );

    return XST_SUCCESS;
}

static int validate_test_frame(
    uint32_t *invalid_sample,
    uint32_t *received_value
)
{
    uint32_t i;

    for (i = 0U; i < FFT_SIZE; i++) {
        uint32_t value =
            fft_buffer[FRAME_HEADER_WORDS + i];

        if (value != i) {
            if (invalid_sample != NULL) {
                *invalid_sample = i;
            }

            if (received_value != NULL) {
                *received_value = value;
            }

            return XST_FAILURE;
        }
    }

    return XST_SUCCESS;
}

/* -------------------- Main -------------------- */

int main(void)
{
    ip_addr_t ipaddr;
    ip_addr_t netmask;
    ip_addr_t gw;
    ip_addr_t dest_ip;

    struct udp_pcb *pcb;

    XAxiDma_Config *DmaCfg;

    err_t err;
    int status;

    echo_netif = &server_netif;

    init_platform();

    /*
     * Ten komunikat potwierdza, że init_platform() zakończyło działanie.
     * Nie wymaga modyfikowania platform_zynqmp.c.
     */
    xil_printf("\r\nDEBUG: init_platform returned\r\n");
    xil_printf("UDP + DMA app start\r\n");

    /* -------------------- Static IPv4 configuration -------------------- */

    IP4_ADDR(&ipaddr, 192, 168, 1, 10);
    IP4_ADDR(&netmask, 255, 255, 255, 0);
    IP4_ADDR(&gw, 192, 168, 1, 1);

    lwip_init();

    xil_printf("lwip_init done\r\n");

    if (xemac_add(
            &server_netif,
            &ipaddr,
            &netmask,
            &gw,
            mac_ethernet_address,
            USE_GEM_BASEADDR
        ) == NULL) {

        xil_printf("ERROR: xemac_add failed\r\n");
        service_ethernet_forever();
    }

    netif_set_default(&server_netif);

#ifndef SDT
    /*
     * Dla klasycznego BSP przerwania są włączane jawnie.
     */
    platform_enable_interrupts();
    xil_printf("platform_enable_interrupts done\r\n");
#else
    /*
     * W przepływie SDT pomijamy jawne wywołanie,
     * zgodnie z przykładami AMD.
     */
    xil_printf(
        "SDT build: explicit platform_enable_interrupts skipped\r\n"
    );
#endif

    netif_set_up(&server_netif);

    xil_printf("Network interface up\r\n");
    xil_printf("Local IP: 192.168.1.10\r\n");
    xil_printf("Netmask: 255.255.255.0\r\n");
    xil_printf("Destination IP: 192.168.1.100\r\n");
    xil_printf("Destination UDP port: %u\r\n", DEST_PORT);

    /*
     * Krótki okres obsługi wejścia przed rozpoczęciem DMA.
     * Płytka może już w tym czasie odpowiedzieć na ARP lub ping.
     */
    service_ethernet_ms(100U, 1);

    /* -------------------- UDP initialization -------------------- */

    pcb = udp_new();

    if (pcb == NULL) {
        xil_printf("ERROR: udp_new failed\r\n");
        service_ethernet_forever();
    }

    IP4_ADDR(&dest_ip, 192, 168, 1, 100);

    err = udp_connect(
        pcb,
        &dest_ip,
        DEST_PORT
    );

    if (err != ERR_OK) {
        xil_printf(
            "ERROR: udp_connect failed: %d\r\n",
            (int)err
        );

        udp_remove(pcb);
        service_ethernet_forever();
    }

    xil_printf("UDP PCB configured\r\n");

    /* -------------------- DMA initialization -------------------- */

    DmaCfg = XAxiDma_LookupConfig(DMA_BASEADDR);

    if (DmaCfg == NULL) {
        xil_printf(
            "ERROR: XAxiDma_LookupConfig failed for 0x%08lx\r\n",
            (unsigned long)DMA_BASEADDR
        );

        service_ethernet_forever();
    }

    status = XAxiDma_CfgInitialize(
        &AxiDma,
        DmaCfg
    );

    if (status != XST_SUCCESS) {
        xil_printf(
            "ERROR: XAxiDma_CfgInitialize failed: %d\r\n",
            status
        );

        service_ethernet_forever();
    }

    if (XAxiDma_HasSg(&AxiDma) != 0) {
        xil_printf(
            "ERROR: DMA is in SG mode, expected Simple mode\r\n"
        );

        service_ethernet_forever();
    }

    xil_printf("DMA init done\r\n");

    /* -------------------- DMA synchronization -------------------- */

    /*
     * Generator działa niezależnie od aplikacji.
     * Pierwszy transfer może rozpocząć się w środku ramki,
     * dlatego pierwszą odebraną ramkę odrzucamy.
     */
    xil_printf("Discarding first DMA frame...\r\n");

    if (receive_dma_frame() != XST_SUCCESS) {
        xil_printf("ERROR: first DMA frame reception failed\r\n");
        service_ethernet_forever();
    }

    /*
     * Drugi transfer powinien rozpocząć się od granicy
     * kolejnej pełnej ramki.
     */
    /* -------------------- Continuous DMA to UDP loop -------------------- */

    {
        uint32_t next_frame_id = 0U;
    
        uint32_t dma_frames_received = 0U;
        uint32_t udp_frames_sent = 0U;
    
        uint32_t invalid_frames = 0U;
        uint32_t dma_errors = 0U;
        uint32_t udp_errors = 0U;
    
        xil_printf("Starting continuous DMA to UDP transmission\r\n");
    
        while (1) {
            uint32_t frame_id;
            uint32_t invalid_sample = 0U;
            uint32_t received_value = 0U;
    
            /* Odbiór dokładnie jednej ramki z AXI DMA. */
            status = receive_dma_frame();
    
            if (status != XST_SUCCESS) {
                dma_errors++;
    
                xil_printf(
                    "ERROR: DMA reception stopped, "
                    "received=%lu dma_errors=%lu\r\n",
                    (unsigned long)dma_frames_received,
                    (unsigned long)dma_errors
                );
    
                /*
                 * Bez resetu i ponownej synchronizacji nie próbujemy
                 * kontynuować pracy z potencjalnie zablokowanym DMA.
                 */
                break;
            }
    
            dma_frames_received++;
    
            /*
             * Kontrola wzorca generowanego obecnie przez axis_test_gen.
             */
            status = validate_test_frame(
                &invalid_sample,
                &received_value
            );
    
            if (status != XST_SUCCESS) {
                invalid_frames++;
    
                xil_printf(
                    "ERROR: Invalid frame %lu, "
                    "sample=%lu expected=0x%08lx received=0x%08lx, "
                    "header=%08lx %08lx %08lx\r\n",
                    (unsigned long)dma_frames_received,
                    (unsigned long)invalid_sample,
                    (unsigned long)invalid_sample,
                    (unsigned long)received_value,
                    (unsigned long)fft_buffer[0],
                    (unsigned long)fft_buffer[1],
                    (unsigned long)fft_buffer[2]
                );
    
                /*
                 * DMA odebrało całą ramkę zakończoną TLAST,
                 * więc próbujemy odebrać następną.
                 */
                continue;
            }
    
            /*
             * Numer jest pobierany przed wywołaniem udp_send().
             * Jeżeli wysłanie części ramki się nie powiedzie,
             * następna ramka otrzyma kolejny numer. Python wykryje lukę.
             */
            frame_id = next_frame_id;
            next_frame_id++;
    
            status = send_fft_frame_udp(
                pcb,
                frame_id
            );
    
            if (status != XST_SUCCESS) {
                udp_errors++;
    
                xil_printf(
                    "ERROR: UDP frame %lu failed, "
                    "udp_errors=%lu\r\n",
                    (unsigned long)frame_id,
                    (unsigned long)udp_errors
                );
            } else {
                udp_frames_sent++;
    
                if (frame_id < VERBOSE_FRAME_COUNT) {
                    xil_printf(
                        "Frame %lu sent successfully\r\n",
                        (unsigned long)frame_id
                    );
                }
            }
    
            if ((dma_frames_received % STATUS_PRINT_PERIOD) == 0U) {
                xil_printf(
                    "STATS: dma_received=%lu "
                    "udp_sent=%lu "
                    "invalid=%lu "
                    "dma_errors=%lu "
                    "udp_errors=%lu "
                    "next_frame_id=%lu\r\n",
                    (unsigned long)dma_frames_received,
                    (unsigned long)udp_frames_sent,
                    (unsigned long)invalid_frames,
                    (unsigned long)dma_errors,
                    (unsigned long)udp_errors,
                    (unsigned long)next_frame_id
                );
            }
        }
    }
    
    xil_printf(
        "Continuous transmission stopped; "
        "entering Ethernet service loop\r\n"
    );
    
    service_ethernet_forever();
    

    udp_disconnect(pcb);
    udp_remove(pcb);

    cleanup_platform();

    return 0;
}