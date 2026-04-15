#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "sleep.h"

#include "xaxidma.h"

#include "lwip/init.h"
#include "lwip/udp.h"
#include "lwip/ip_addr.h"
#include "lwip/pbuf.h"
#include "lwip/netif.h"

#include "netif/xadapter.h"

#include <string.h>
#include <stdint.h>

#define USE_GEM_BASEADDR    XPAR_XEMACPS_1_BASEADDR
#define DMA_BASEADDR        XPAR_XAXIDMA_0_BASEADDR

#define FFT_SIZE            1024
#define UDP_CHUNK_WORDS     256
#define DEST_PORT           5001
typedef struct {
    uint32_t frame_id;
    uint16_t packet_id;
    uint16_t packet_count;
} udp_header_t;

static uint32_t frame_counter = 0;
static struct netif server_netif;
static XAxiDma AxiDma;

/* Bufor odbiorczy DMA w DDR */
static uint32_t fft_buffer[FFT_SIZE] __attribute__((aligned(64)));

int main(void)
{
    ip_addr_t ipaddr, netmask, gw;
    ip_addr_t dest_ip;
    struct udp_pcb *pcb;
    struct pbuf *p;
    err_t err;
    XAxiDma_Config *DmaCfg;
    int status;
    int offset;

    xil_printf("UDP + DMA app start\r\n");

    /* -------------------- Ethernet / lwIP -------------------- */

    IP4_ADDR(&ipaddr, 192, 168, 1, 10);
    IP4_ADDR(&netmask, 255, 255, 255, 0);
    IP4_ADDR(&gw, 192, 168, 1, 1);

    lwip_init();
    xil_printf("lwip_init done\r\n");

    if (!xemac_add(&server_netif, &ipaddr, &netmask, &gw,
                   NULL, USE_GEM_BASEADDR)) {
        xil_printf("ERROR: xemac_add failed\r\n");
        while (1) { ; }
    }

    netif_set_default(&server_netif);
    netif_set_up(&server_netif);

    xil_printf("Network interface up\r\n");
    xil_printf("Local IP: 192.168.1.10\r\n");

    pcb = udp_new();
    if (pcb == NULL) {
        xil_printf("ERROR: udp_new failed\r\n");
        while (1) { ; }
    }

    IP4_ADDR(&dest_ip, 192, 168, 1, 100);

    err = udp_connect(pcb, &dest_ip, DEST_PORT);
    if (err != ERR_OK) {
        xil_printf("ERROR: udp_connect failed: %d\r\n", err);
        while (1) { ; }
    }

    xil_printf("UDP connected\r\n");

    /* -------------------- DMA init -------------------- */

    DmaCfg = XAxiDma_LookupConfig(DMA_BASEADDR);
    if (DmaCfg == NULL) {
        xil_printf("ERROR: XAxiDma_LookupConfig failed\r\n");
        while (1) { ; }
    }

    status = XAxiDma_CfgInitialize(&AxiDma, DmaCfg);
    if (status != XST_SUCCESS) {
        xil_printf("ERROR: XAxiDma_CfgInitialize failed: %d\r\n", status);
        while (1) { ; }
    }

    if (XAxiDma_HasSg(&AxiDma)) {
        xil_printf("ERROR: DMA is in SG mode, expected Simple mode\r\n");
        while (1) { ; }
    }

    xil_printf("DMA init done\r\n");

    /* Wypełnienie testowe - tylko po to, żeby było widać zmianę,
       jeśli DMA nie nadpisze danych */
    for (int i = 0; i < FFT_SIZE; i++) {
        fft_buffer[i] = 0xDEADBEEF;
    }

    /* -------------------- DMA transfer -------------------- */

    Xil_DCacheFlushRange((UINTPTR)fft_buffer, FFT_SIZE * sizeof(uint32_t));

    status = XAxiDma_SimpleTransfer(&AxiDma,
                                    (UINTPTR)fft_buffer,
                                    FFT_SIZE * sizeof(uint32_t),
                                    XAXIDMA_DEVICE_TO_DMA);

    if (status != XST_SUCCESS) {
        xil_printf("ERROR: XAxiDma_SimpleTransfer failed: %d\r\n", status);
        while (1) { ; }
    }

    xil_printf("DMA transfer started\r\n");

    while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)) {
        xemacif_input(&server_netif);
    }

    Xil_DCacheInvalidateRange((UINTPTR)fft_buffer, FFT_SIZE * sizeof(uint32_t));

    xil_printf("DMA transfer done\r\n");

    /* -------------------- UDP send in chunks -------------------- */

    offset = 0;

    uint16_t total_packets =
    (FFT_SIZE + UDP_CHUNK_WORDS - 1) / UDP_CHUNK_WORDS;

offset = 0;
uint16_t packet_id = 0;

while (offset < FFT_SIZE) {

    int chunk = UDP_CHUNK_WORDS;
    if (offset + chunk > FFT_SIZE) {
        chunk = FFT_SIZE - offset;
    }

    int payload_size = sizeof(udp_header_t) + chunk * sizeof(uint32_t);

    p = pbuf_alloc(PBUF_TRANSPORT, payload_size, PBUF_RAM);
    if (p == NULL) {
        xil_printf("ERROR: pbuf_alloc failed\r\n");
        break;
    }

    udp_header_t header;
    header.frame_id = frame_counter;
    header.packet_id = packet_id;
    header.packet_count = total_packets;

    /* kopiuj header */
    memcpy(p->payload, &header, sizeof(header));

    /* kopiuj dane FFT za headerem */
    memcpy((uint8_t*)p->payload + sizeof(header),
           &fft_buffer[offset],
           chunk * sizeof(uint32_t));

    err = udp_send(pcb, p);
    if (err != ERR_OK) {
        xil_printf("ERROR: udp_send failed: %d\r\n", err);
    }

    pbuf_free(p);

    offset += chunk;
    packet_id++;
}

frame_counter++;

    xil_printf("UDP FFT send done\r\n");

    udp_disconnect(pcb);
    udp_remove(pcb);

    while (1) {
        xemacif_input(&server_netif);
        usleep(1000);
    }

    return 0;
}