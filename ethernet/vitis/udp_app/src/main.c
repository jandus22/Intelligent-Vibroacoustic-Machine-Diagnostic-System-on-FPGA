#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "sleep.h"
#include "platform.h"

#ifdef SDT
#include "xiltimer.h"
#else
#include "xtime_l.h"
#endif

#include "xaxidma.h"
#include "xaxidma_hw.h"

#include "lwip/init.h"
#include "lwip/udp.h"
#include "lwip/ip_addr.h"
#include "lwip/pbuf.h"
#include "lwip/netif.h"
#include "lwip/sys.h"

#include "netif/xadapter.h"

#include "udp_protocol.h"

#include <stddef.h>
#include <stdint.h>

/* -------------------- Hardware configuration -------------------- */

#define USE_GEM_BASEADDR       XPAR_XEMACPS_1_BASEADDR
#define DMA_BASEADDR           XPAR_XAXIDMA_0_BASEADDR

/* -------------------- DMA frame configuration -------------------- */

#define FFT_SIZE               4096U
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

/* -------------------- UDP/protocol configuration -------------------- */

#define DEST_PORT              5001U
#define UDP_CHUNK_WORDS        VIBR_ELEMENTS_PER_PACKET

/*
 * Obecny axis_test_gen wysyła 4096 wartości 0..4095 reprezentujących
 * testową ramkę próbek czasowych. GUI wykonuje z nich 4096-punktową FFT.
 *
 * Po podłączeniu gotowego modułu FFT przed DMA typ wiadomości należy
 * odpowiednio zmienić na VIBR_DATA_FFT_MAGNITUDE albo
 * VIBR_DATA_FFT_COMPLEX.
 */
#define MEASUREMENT_DATA_KIND  VIBR_DATA_TIME_SAMPLES
#define MEASUREMENT_CHANNEL    0U

/*
 * Po pierwszym pakiecie UDP stos może najpierw wysłać zapytanie ARP.
 * W tym czasie musimy przetwarzać ramki wejściowe, aby odebrać odpowiedź.
 */
#define ARP_WAIT_TIME_MS       250U
#define BETWEEN_PACKETS_MS     2U
#define AFTER_SEND_WAIT_MS     2U
#define AFTER_CONTROL_MSG_MS   1U

#define BOARD_STATUS_PERIOD_MS 1000U
#define STATUS_PRINT_PERIOD    100U
#define VERBOSE_FRAME_COUNT    3U

/* Testowy model: zdrowe / uszkodzenie pierścienia wewnętrznego / zewnętrznego. */
#define TEST_MODEL_VERSION     1U
#define TEST_INFERENCE_US      4200U
#define TEST_CONFIDENCE        900U
#define TEST_OTHER_SCORE       50U

/*
 * Testowa klasa zmienia się co dwie sekundy, niezależnie od liczby
 * przesyłanych ramek na sekundę.
 */
#define TEST_CLASS_HOLD_MS      2000U

/* Kody aplikacji przekazywane w polu last_error pakietu 0x03. */
#define APP_ERROR_NONE                 0U
#define APP_ERROR_DMA                  1U
#define APP_ERROR_INVALID_FRAME        2U
#define APP_ERROR_MEASUREMENT_UDP      3U
#define APP_ERROR_CLASSIFICATION_UDP   4U
#define APP_ERROR_STATUS_UDP           5U

/* -------------------- Global objects -------------------- */

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

/* -------------------- Application time -------------------- */

static uint32_t app_now_ms(void)
{
    XTime current_time;
    uint64_t timer_frequency;

    XTime_GetTime(&current_time);

#ifdef SDT
    timer_frequency = (uint64_t)XSLEEPTIMER_FREQ;
#else
    timer_frequency = (uint64_t)COUNTS_PER_SECOND;
#endif

    if (timer_frequency == 0ULL) {
        return 0U;
    }

    return (uint32_t)(
        ((uint64_t)current_time * 1000ULL) / timer_frequency
    );
}

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

    /* Usunięcie brudnych linii cache przed zapisaniem danych przez DMA. */
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

        /* Podczas oczekiwania na DMA nadal obsługujemy Ethernet. */
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

    /* Unieważnienie cache po zapisaniu bufora przez DMA. */
    Xil_DCacheInvalidateRange(
        (UINTPTR)fft_buffer,
        DMA_BUFFER_BYTES
    );

    return XST_SUCCESS;
}

/* -------------------- Common UDP send helper -------------------- */

static int send_udp_datagram(
    struct udp_pcb *pcb,
    const uint8_t *data,
    uint16_t data_length
)
{
    struct pbuf *p;
    err_t err;

    if ((pcb == NULL) || (data == NULL) || (data_length == 0U)) {
        return XST_FAILURE;
    }

    p = pbuf_alloc(
        PBUF_TRANSPORT,
        data_length,
        PBUF_RAM
    );

    if (p == NULL) {
        xil_printf(
            "ERROR: pbuf_alloc failed for %u-byte datagram\r\n",
            (unsigned int)data_length
        );

        return XST_FAILURE;
    }

    err = pbuf_take(p, data, data_length);

    if (err == ERR_OK) {
        err = udp_send(pcb, p);
    }

    /*
     * Po udp_send() stos zachowuje własną referencję, jeśli datagram czeka
     * jeszcze na rozwiązanie ARP. Referencję aplikacji można zwolnić.
     */
    pbuf_free(p);

    if (err != ERR_OK) {
        xil_printf(
            "ERROR: UDP datagram send failed: %d\r\n",
            (int)err
        );

        return XST_FAILURE;
    }

    return XST_SUCCESS;
}

/* -------------------- Message 0x01: FFT data -------------------- */

static int send_fft_frame_udp(
    struct udp_pcb *pcb,
    uint32_t frame_id,
    uint64_t timestamp_us
)
{
    uint8_t datagram[VIBR_MEAS_INT32_DATAGRAM_SIZE];
    uint32_t sample_offset = 0U;
    uint16_t packet_id = 0U;

    const uint16_t total_packets =
        (uint16_t)(
            (FFT_SIZE + UDP_CHUNK_WORDS - 1U) /
            UDP_CHUNK_WORDS
        );

    while (sample_offset < FFT_SIZE) {
        uint32_t chunk = UDP_CHUNK_WORDS;
        uint16_t payload_size;
        uint16_t datagram_size;
        uint32_t i;
        size_t wire_offset;

        vibr_header_t header;
        vibr_measurement_meta_t meta;

        if ((sample_offset + chunk) > FFT_SIZE) {
            chunk = FFT_SIZE - sample_offset;
        }

        payload_size = (uint16_t)(
            VIBR_MEAS_META_SIZE +
            chunk * sizeof(uint32_t)
        );

        datagram_size = (uint16_t)(
            VIBR_HEADER_SIZE + payload_size
        );

        header.message_type = VIBR_MSG_MEASUREMENT;
        header.flags = 0U;
        header.frame_id = frame_id;
        header.packet_id = packet_id;
        header.packet_count = total_packets;
        header.payload_length = payload_size;
        header.timestamp_us = timestamp_us;

        meta.data_kind = MEASUREMENT_DATA_KIND;
        meta.element_format = VIBR_FORMAT_INT32;
        meta.channel = MEASUREMENT_CHANNEL;
        meta.first_index = (uint16_t)sample_offset;
        meta.element_count = (uint16_t)chunk;

        wire_offset = vibr_pack_header(
            datagram,
            sizeof(datagram),
            &header
        );

        if (wire_offset != VIBR_HEADER_SIZE) {
            xil_printf("ERROR: VIBR header packing failed\r\n");
            return XST_FAILURE;
        }

        wire_offset += vibr_pack_measurement_meta(
            datagram + wire_offset,
            sizeof(datagram) - wire_offset,
            &meta
        );

        if (wire_offset != (VIBR_HEADER_SIZE + VIBR_MEAS_META_SIZE)) {
            xil_printf("ERROR: VIBR measurement metadata packing failed\r\n");
            return XST_FAILURE;
        }

        /*
         * Na przewodzie wartości int32 są przesyłane w big-endian.
         * Użycie funkcji zapisującej uint32 zachowuje również reprezentację
         * liczb ujemnych w kodzie uzupełnień do dwóch.
         */
        for (i = 0U; i < chunk; i++) {
            vibr_write_u32_be(
                datagram + wire_offset + i * sizeof(uint32_t),
                fft_buffer[FRAME_HEADER_WORDS + sample_offset + i]
            );
        }

        if (send_udp_datagram(
                pcb,
                datagram,
                datagram_size
            ) != XST_SUCCESS) {

            xil_printf(
                "ERROR: measurement frame %lu packet %u failed\r\n",
                (unsigned long)frame_id,
                (unsigned int)packet_id
            );

            return XST_FAILURE;
        }

        if (frame_id < VERBOSE_FRAME_COUNT) {
            xil_printf(
                "Frame %lu: VIBR 0x01 packet %u/%u, bins %lu-%lu\r\n",
                (unsigned long)frame_id,
                (unsigned int)(packet_id + 1U),
                (unsigned int)total_packets,
                (unsigned long)sample_offset,
                (unsigned long)(sample_offset + chunk - 1U)
            );
        }

        /* Zachowujemy działającą obsługę pierwszego ARP. */
        if ((frame_id == 0U) && (packet_id == 0U)) {
            xil_printf("Waiting for initial ARP response...\r\n");
            service_ethernet_ms(ARP_WAIT_TIME_MS, 1);
        } else {
            service_ethernet_ms(BETWEEN_PACKETS_MS, 0);
        }

        sample_offset += chunk;
        packet_id++;
    }

    service_ethernet_ms(AFTER_SEND_WAIT_MS, 1);
    return XST_SUCCESS;
}

/* -------------------- Message 0x02: model result -------------------- */

static void make_test_classification(
    uint32_t frame_id,
    vibr_classification_t *result
)
{
    uint8_t selected_class;

    if (result == NULL) {
        return;
    }

    (void)frame_id;

    selected_class = (uint8_t)(
        (app_now_ms() / TEST_CLASS_HOLD_MS) % 3U
    );

    result->class_id = selected_class;
    result->class_count = 3U;
    result->confidence_permille = TEST_CONFIDENCE;

    result->score_healthy =
        selected_class == VIBR_CLASS_HEALTHY
            ? TEST_CONFIDENCE
            : TEST_OTHER_SCORE;

    result->score_inner =
        selected_class == VIBR_CLASS_INNER_FAULT
            ? TEST_CONFIDENCE
            : TEST_OTHER_SCORE;

    result->score_outer =
        selected_class == VIBR_CLASS_OUTER_FAULT
            ? TEST_CONFIDENCE
            : TEST_OTHER_SCORE;

    result->inference_time_us = TEST_INFERENCE_US;
    result->model_version = TEST_MODEL_VERSION;
}

static int send_test_classification_udp(
    struct udp_pcb *pcb,
    uint32_t frame_id,
    uint64_t timestamp_us
)
{
    uint8_t datagram[VIBR_HEADER_SIZE + VIBR_CLASS_PAYLOAD_SIZE];
    vibr_header_t header;
    vibr_classification_t result;
    size_t wire_offset;

    make_test_classification(frame_id, &result);

    header.message_type = VIBR_MSG_CLASSIFICATION;
    header.flags = 0U;
    header.frame_id = frame_id;
    header.packet_id = 0U;
    header.packet_count = 1U;
    header.payload_length = VIBR_CLASS_PAYLOAD_SIZE;
    header.timestamp_us = timestamp_us;

    wire_offset = vibr_pack_header(
        datagram,
        sizeof(datagram),
        &header
    );

    if (wire_offset != VIBR_HEADER_SIZE) {
        return XST_FAILURE;
    }

    if (vibr_pack_classification(
            datagram + wire_offset,
            sizeof(datagram) - wire_offset,
            &result
        ) != VIBR_CLASS_PAYLOAD_SIZE) {

        return XST_FAILURE;
    }

    if (send_udp_datagram(
            pcb,
            datagram,
            (uint16_t)sizeof(datagram)
        ) != XST_SUCCESS) {

        return XST_FAILURE;
    }

    service_ethernet_ms(AFTER_CONTROL_MSG_MS, 0);

    if (frame_id < VERBOSE_FRAME_COUNT) {
        xil_printf(
            "Frame %lu: VIBR 0x02 class=%u confidence=%u.%u%%\r\n",
            (unsigned long)frame_id,
            (unsigned int)result.class_id,
            (unsigned int)(result.confidence_permille / 10U),
            (unsigned int)(result.confidence_permille % 10U)
        );
    }

    return XST_SUCCESS;
}

/* -------------------- Message 0x03: board status -------------------- */

static int send_board_status_udp(
    struct udp_pcb *pcb,
    uint32_t last_frame_id,
    uint32_t dropped_frames,
    uint32_t last_error
)
{
    uint8_t datagram[VIBR_HEADER_SIZE + VIBR_STATUS_PAYLOAD_SIZE];
    vibr_header_t header;
    vibr_board_status_t board_status;
    uint32_t now_ms;
    size_t wire_offset;

    now_ms = app_now_ms();

    board_status.board_state = VIBR_STATE_RUNNING;
    board_status.dma_state = VIBR_STATE_RUNNING;
    board_status.model_state = VIBR_STATE_RUNNING; /* model testowy */
    board_status.ethernet_state = VIBR_STATE_RUNNING;
    board_status.last_frame_id = last_frame_id;
    board_status.dropped_frames = dropped_frames;
    board_status.uptime_ms = now_ms;
    board_status.last_error = last_error;

    header.message_type = VIBR_MSG_BOARD_STATUS;
    header.flags = 0U;
    header.frame_id = last_frame_id;
    header.packet_id = 0U;
    header.packet_count = 1U;
    header.payload_length = VIBR_STATUS_PAYLOAD_SIZE;
    header.timestamp_us = (uint64_t)now_ms * 1000ULL;

    wire_offset = vibr_pack_header(
        datagram,
        sizeof(datagram),
        &header
    );

    if (wire_offset != VIBR_HEADER_SIZE) {
        return XST_FAILURE;
    }

    if (vibr_pack_board_status(
            datagram + wire_offset,
            sizeof(datagram) - wire_offset,
            &board_status
        ) != VIBR_STATUS_PAYLOAD_SIZE) {

        return XST_FAILURE;
    }

    if (send_udp_datagram(
            pcb,
            datagram,
            (uint16_t)sizeof(datagram)
        ) != XST_SUCCESS) {

        return XST_FAILURE;
    }

    service_ethernet_ms(AFTER_CONTROL_MSG_MS, 0);
    return XST_SUCCESS;
}

static int validate_test_frame(
    uint32_t *invalid_sample,
    uint32_t *received_value
)
{
    uint32_t i;

    for (i = 0U; i < FFT_SIZE; i++) {
        uint32_t value = fft_buffer[FRAME_HEADER_WORDS + i];

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

    xil_printf("\r\nDEBUG: init_platform returned\r\n");
    xil_printf("UDP + DMA + VIBR protocol app start\r\n");

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
    platform_enable_interrupts();
    xil_printf("platform_enable_interrupts done\r\n");
#else
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
    xil_printf(
        "Measurement frame: %u samples, %u UDP packets, %lu DMA bytes\r\n",
        (unsigned int)FFT_SIZE,
        (unsigned int)(
            (FFT_SIZE + UDP_CHUNK_WORDS - 1U) /
            UDP_CHUNK_WORDS
        ),
        (unsigned long)DMA_FRAME_BYTES
    );
    xil_printf("VIBR protocol version: %u\r\n", VIBR_PROTOCOL_VERSION);

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

    xil_printf(
        "DEBUG: DMA lookup, base=0x%08lx\r\n",
        (unsigned long)DMA_BASEADDR
    );

    DmaCfg = XAxiDma_LookupConfig(DMA_BASEADDR);

    xil_printf(
        "DEBUG: DMA lookup returned 0x%08lx\r\n",
        (unsigned long)(UINTPTR)DmaCfg
    );

    if (DmaCfg == NULL) {
        xil_printf(
            "ERROR: XAxiDma_LookupConfig failed for 0x%08lx\r\n",
            (unsigned long)DMA_BASEADDR
        );

        service_ethernet_forever();
    }

    xil_printf(
        "DEBUG: DMA config base=0x%08lx\r\n",
        (unsigned long)DmaCfg->BaseAddr
    );

    xil_printf("DEBUG: DMA CfgInitialize begin\r\n");
    
    xil_printf(
    "DMA CFG: MM2S=%d S2MM=%d SG=%d ADDR=%d LEN=%d\r\n",
    DmaCfg->HasMm2S,
    DmaCfg->HasS2Mm,
    DmaCfg->HasSg,
    DmaCfg->AddrWidth,
    DmaCfg->SgLengthWidth
    );

    status = XAxiDma_CfgInitialize(
        &AxiDma,
        DmaCfg
    );

    xil_printf(
        "DEBUG: DMA CfgInitialize returned %d\r\n",
        status
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

    xil_printf("Discarding first DMA frame...\r\n");

    if (receive_dma_frame() != XST_SUCCESS) {
        xil_printf("ERROR: first DMA frame reception failed\r\n");
        service_ethernet_forever();
    }

    /* -------------------- Continuous DMA to UDP loop -------------------- */

    {
        uint32_t next_frame_id = 0U;
        uint32_t last_frame_id = 0U;
        uint32_t last_status_ms = app_now_ms();
        uint32_t last_error = APP_ERROR_NONE;

        uint32_t dma_frames_received = 0U;
        uint32_t measurement_frames_sent = 0U;
        uint32_t classifications_sent = 0U;
        uint32_t status_messages_sent = 0U;

        uint32_t invalid_frames = 0U;
        uint32_t dma_errors = 0U;
        uint32_t measurement_udp_errors = 0U;
        uint32_t classification_udp_errors = 0U;
        uint32_t status_udp_errors = 0U;

        xil_printf(
            "Starting continuous DMA to VIBR UDP transmission\r\n"
        );

        while (1) {
            uint32_t frame_id;
            uint32_t invalid_sample = 0U;
            uint32_t received_value = 0U;
            uint32_t now_ms;
            uint32_t dropped_frames;
            uint64_t frame_timestamp_us;

            status = receive_dma_frame();

            if (status != XST_SUCCESS) {
                dma_errors++;
                last_error = APP_ERROR_DMA;

                xil_printf(
                    "ERROR: DMA reception stopped, "
                    "received=%lu dma_errors=%lu\r\n",
                    (unsigned long)dma_frames_received,
                    (unsigned long)dma_errors
                );

                break;
            }

            dma_frames_received++;

            status = validate_test_frame(
                &invalid_sample,
                &received_value
            );

            if (status != XST_SUCCESS) {
                invalid_frames++;
                last_error = APP_ERROR_INVALID_FRAME;

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

                continue;
            }

            frame_id = next_frame_id;
            next_frame_id++;
            last_frame_id = frame_id;
            frame_timestamp_us = (uint64_t)app_now_ms() * 1000ULL;

            /* 0x01: szesnaście pakietów danych z tym samym frame_id. */
            status = send_fft_frame_udp(
                pcb,
                frame_id,
                frame_timestamp_us
            );

            if (status != XST_SUCCESS) {
                measurement_udp_errors++;
                last_error = APP_ERROR_MEASUREMENT_UDP;

                xil_printf(
                    "ERROR: VIBR 0x01 frame %lu failed, "
                    "measurement_udp_errors=%lu\r\n",
                    (unsigned long)frame_id,
                    (unsigned long)measurement_udp_errors
                );
            } else {
                measurement_frames_sent++;
            }

            /*
             * 0x02: na razie wynik testowy. Pakiet ma dokładnie ten sam
             * frame_id, więc odbiornik może zsynchronizować go z FFT.
             */
            status = send_test_classification_udp(
                pcb,
                frame_id,
                frame_timestamp_us
            );

            if (status != XST_SUCCESS) {
                classification_udp_errors++;
                last_error = APP_ERROR_CLASSIFICATION_UDP;

                xil_printf(
                    "ERROR: VIBR 0x02 frame %lu failed, "
                    "classification_udp_errors=%lu\r\n",
                    (unsigned long)frame_id,
                    (unsigned long)classification_udp_errors
                );
            } else {
                classifications_sent++;
            }

            /* 0x03: niezależny status płytki wysyłany raz na sekundę. */
            now_ms = app_now_ms();

            if ((uint32_t)(now_ms - last_status_ms) >=
                BOARD_STATUS_PERIOD_MS) {

                dropped_frames =
                    invalid_frames + measurement_udp_errors;

                status = send_board_status_udp(
                    pcb,
                    last_frame_id,
                    dropped_frames,
                    last_error
                );

                if (status != XST_SUCCESS) {
                    status_udp_errors++;
                    last_error = APP_ERROR_STATUS_UDP;

                    xil_printf(
                        "ERROR: VIBR 0x03 failed, "
                        "status_udp_errors=%lu\r\n",
                        (unsigned long)status_udp_errors
                    );
                } else {
                    status_messages_sent++;
                }

                last_status_ms = now_ms;
            }

            if (frame_id < VERBOSE_FRAME_COUNT) {
                xil_printf(
                    "Frame %lu protocol transmission completed\r\n",
                    (unsigned long)frame_id
                );
            }

            if ((dma_frames_received % STATUS_PRINT_PERIOD) == 0U) {
                xil_printf(
                    "STATS: dma_received=%lu "
                    "measurement_sent=%lu "
                    "classification_sent=%lu "
                    "status_sent=%lu "
                    "invalid=%lu "
                    "dma_errors=%lu "
                    "measurement_udp_errors=%lu "
                    "classification_udp_errors=%lu "
                    "status_udp_errors=%lu "
                    "next_frame_id=%lu\r\n",
                    (unsigned long)dma_frames_received,
                    (unsigned long)measurement_frames_sent,
                    (unsigned long)classifications_sent,
                    (unsigned long)status_messages_sent,
                    (unsigned long)invalid_frames,
                    (unsigned long)dma_errors,
                    (unsigned long)measurement_udp_errors,
                    (unsigned long)classification_udp_errors,
                    (unsigned long)status_udp_errors,
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
