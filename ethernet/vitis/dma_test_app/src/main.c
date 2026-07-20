#include <stdio.h>
#include <stdint.h>
#include "xaxidma.h"
#include "xparameters.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "xaxidma_hw.h"

#define DMA_DEV_ID      XPAR_XAXIDMA_0_BASEADDR
#define RX_WORDS        1027
#define RX_BYTES        (RX_WORDS * sizeof(uint32_t))

static XAxiDma AxiDma;
static uint32_t RxBuffer[RX_WORDS] __attribute__((aligned(64)));

int main()
{
    int status;
    XAxiDma_Config *cfg;
    int i;

    xil_printf("DMA test start\r\n");

    cfg = XAxiDma_LookupConfig(DMA_DEV_ID);
    if (cfg == NULL) {
        xil_printf("ERROR: XAxiDma_LookupConfig failed\r\n");
        return -1;
    }

    status = XAxiDma_CfgInitialize(&AxiDma, cfg);
    if (status != XST_SUCCESS) {
        xil_printf("ERROR: XAxiDma_CfgInitialize failed: %d\r\n", status);
        return -1;
    }

    if (XAxiDma_HasSg(&AxiDma)) {
        xil_printf("ERROR: DMA is in SG mode, expected Simple mode\r\n");
        return -1;
    }

    for (i = 0; i < RX_WORDS; i++) {
        RxBuffer[i] = 0xDEADBEEF;
    }

    Xil_DCacheFlushRange((UINTPTR)RxBuffer, RX_BYTES);

    status = XAxiDma_SimpleTransfer(&AxiDma,
                                    (UINTPTR)RxBuffer,
                                    RX_BYTES,
                                    XAXIDMA_DEVICE_TO_DMA);

    if (status != XST_SUCCESS) {
        xil_printf("ERROR: XAxiDma_SimpleTransfer failed: %d\r\n", status);
        return -1;
    }

    xil_printf("DMA transfer started, waiting for data...\r\n");

    uint32_t timeout = 100000000U;

    while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA) &&
           timeout > 0U) {
        timeout--;
    }

    if (timeout == 0U) {
    uint32_t dma_status = XAxiDma_ReadReg(
        AxiDma.RegBase,
        XAXIDMA_RX_OFFSET + XAXIDMA_SR_OFFSET
    );

    uint32_t rx_length = XAxiDma_ReadReg(
        AxiDma.RegBase,
        XAXIDMA_RX_OFFSET + XAXIDMA_BUFFLEN_OFFSET
    );

    Xil_DCacheInvalidateRange((UINTPTR)RxBuffer, RX_BYTES);

    xil_printf("ERROR: DMA transfer timeout\r\n");
    xil_printf("S2MM status register: 0x%08lx\r\n",
               (unsigned long)dma_status);

    xil_printf("S2MM length register: %lu bytes (0x%08lx)\r\n",
               (unsigned long)rx_length,
               (unsigned long)rx_length);

    xil_printf("First received words:\r\n");

    for (i = 0; i < 16; i++) {
        xil_printf("RxBuffer[%d] = 0x%08lx\r\n",
                   i,
                   (unsigned long)RxBuffer[i]);
    }

    return -1;
}

    Xil_DCacheInvalidateRange((UINTPTR)RxBuffer, RX_BYTES);

    xil_printf("DMA transfer done\r\n");
    xil_printf("Received words:\r\n");

    for (i = 0; i < RX_WORDS; i++) {
        xil_printf("RxBuffer[%d] = 0x%08lx\r\n", i, (unsigned long)RxBuffer[i]);
    }

    xil_printf("Starting second DMA transfer...\r\n");

/* Ponowne przygotowanie bufora */
for (i = 0; i < RX_WORDS; i++) {
    RxBuffer[i] = 0xDEADBEEF;
}

Xil_DCacheFlushRange((UINTPTR)RxBuffer, RX_BYTES);

/* Drugi transfer powinien rozpocząć się od początku nowej ramki */
status = XAxiDma_SimpleTransfer(
    &AxiDma,
    (UINTPTR)RxBuffer,
    RX_BYTES,
    XAXIDMA_DEVICE_TO_DMA
);

if (status != XST_SUCCESS) {
    xil_printf("ERROR: second XAxiDma_SimpleTransfer failed: %d\r\n",
               status);
    return -1;
}

uint32_t timeout2 = 100000000U;

while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA) &&
       timeout2 > 0U) {
    timeout2--;
}

if (timeout2 == 0U) {
    xil_printf("ERROR: second DMA transfer timeout\r\n");
    return -1;
}

Xil_DCacheInvalidateRange((UINTPTR)RxBuffer, RX_BYTES);

xil_printf("Second DMA transfer done\r\n");
xil_printf("Second received frame:\r\n");

for (i = 0; i < RX_WORDS; i++) {
    xil_printf("RxBuffer2[%d] = 0x%08lx\r\n",
               i,
               (unsigned long)RxBuffer[i]);
} 

    xil_printf("End of test\r\n");

    while (1) {
        ;
    }

    return 0;
}