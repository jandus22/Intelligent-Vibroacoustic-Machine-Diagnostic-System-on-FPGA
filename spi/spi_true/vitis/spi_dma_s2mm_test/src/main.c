#include "xparameters.h"
#include "xaxidma.h"
#include "xaxidma_hw.h"
#include "xil_cache.h"
#include "xstatus.h"
#include "xil_types.h"
#include "sleep.h"

#include <string.h>

/* ================================================================
 * FRAME
 *
 * 4096 kompletnych próbek XYZ
 * X,Y,Z = 3 x int16
 *
 * 4096 * 3 * 2 B = 24576 B = 0x6000
 * ================================================================ */

#define XYZ_SAMPLE_COUNT       4096U
#define WORDS_PER_XYZ_SAMPLE   3U
#define BYTES_PER_WORD         2U

#define FRAME_WORD_COUNT \
    (XYZ_SAMPLE_COUNT * WORDS_PER_XYZ_SAMPLE)

#define FRAME_BYTE_COUNT \
    (FRAME_WORD_COUNT * BYTES_PER_WORD)

/* ================================================================
 * TIMEOUT
 * ================================================================ */

#define POLL_DELAY_US          10U
#define TRANSFER_TIMEOUT_US    2000000U

#define POLL_LIMIT \
    (TRANSFER_TIMEOUT_US / POLL_DELAY_US)

/* ================================================================
 * BUFFERS
 * ================================================================ */

/*
 * Pierwszy transfer S2MM:
 * tylko synchronizacja do najbliższego TLAST.
 */
static u8 SyncBuffer[FRAME_BYTE_COUNT]
    __attribute__((aligned(64)));

/*
 * Drugi transfer S2MM:
 * pełna ramka 24576 B.
 *
 * Ten sam bufor zostanie potem odczytany przez MM2S.
 */
static u8 RxBuffer[FRAME_BYTE_COUNT]
    __attribute__((aligned(64)));

static XAxiDma AxiDma;

/* ================================================================
 * DEBUG / WATCH
 * ================================================================ */

/*
 * Stage:
 *
 * 0 = start
 * 1 = S2MM sync
 * 2 = S2MM full frame
 * 3 = przed startem MM2S
 * 4 = MM2S zakończony
 * 5 = cały test zakończony
 */
volatile u32 g_stage = 0U;

/* ---------- S2MM SYNC ---------- */

volatile u32 g_sync_status     = 0U;
volatile u32 g_sync_bytes      = 0U;
volatile u32 g_sync_poll_count = 0U;

/* ---------- S2MM FULL FRAME ---------- */

volatile u32 g_frame_status     = 0U;
volatile u32 g_frame_bytes      = 0U;
volatile u32 g_frame_poll_count = 0U;

/* ---------- MM2S ---------- */

volatile u32 g_mm2s_status     = 0U;
volatile u32 g_mm2s_poll_count = 0U;

/*
 * 0  = test trwa
 * 1  = PASS całego S2MM + DDR + MM2S
 *
 * -1 = DMA config/init error
 * -2 = DMA w SG mode
 * -3 = start S2MM sync error
 * -4 = S2MM sync timeout
 * -5 = start pełnego S2MM error
 * -6 = pełny S2MM timeout
 * -7 = S2MM frame != 24576 B
 * -8 = start MM2S error
 * -9 = MM2S timeout
 */
volatile int g_test_result = 0;

/* ---------- próbki z DDR ---------- */

volatile s16 g_x0 = 0;
volatile s16 g_y0 = 0;
volatile s16 g_z0 = 0;

volatile s16 g_x1 = 0;
volatile s16 g_y1 = 0;
volatile s16 g_z1 = 0;

volatile s16 g_x4095 = 0;
volatile s16 g_y4095 = 0;
volatile s16 g_z4095 = 0;


/* ================================================================
 * DMA REGISTER HELPERS
 * ================================================================ */

static u32 read_s2mm_status(void)
{
    return XAxiDma_ReadReg(
        AxiDma.RegBase,
        XAXIDMA_RX_OFFSET + XAXIDMA_SR_OFFSET
    );
}

static u32 read_s2mm_length(void)
{
    return XAxiDma_ReadReg(
        AxiDma.RegBase,
        XAXIDMA_RX_OFFSET + XAXIDMA_BUFFLEN_OFFSET
    );
}

static u32 read_mm2s_status(void)
{
    /*
     * MM2S rejestry zaczynają się od offsetu 0x00,
     * więc NIE dodajemy XAXIDMA_RX_OFFSET.
     */
    return XAxiDma_ReadReg(
        AxiDma.RegBase,
        XAXIDMA_SR_OFFSET
    );
}


/* ================================================================
 * WAIT FOR DMA CHANNEL
 * ================================================================ */

static int wait_for_dma(
    int direction,
    volatile u32 *poll_count
)
{
    u32 count = 0U;

    while (XAxiDma_Busy(
        &AxiDma,
        direction
    )) {

        if (count >= POLL_LIMIT) {
            *poll_count = count;
            return XST_FAILURE;
        }

        ++count;
        usleep(POLL_DELAY_US);
    }

    *poll_count = count;

    return XST_SUCCESS;
}


/* ================================================================
 * SAVE SOME SAMPLES FROM DDR
 * ================================================================ */

static void save_debug_samples(void)
{
    const s16 *words = (const s16 *)RxBuffer;

    /* X0 Y0 Z0 */
    g_x0 = words[0];
    g_y0 = words[1];
    g_z0 = words[2];

    /* X1 Y1 Z1 */
    g_x1 = words[3];
    g_y1 = words[4];
    g_z1 = words[5];

    /*
     * Ostatnia próbka:
     *
     * X4095 = word 12285
     * Y4095 = word 12286
     * Z4095 = word 12287
     */
    g_x4095 = words[12285];
    g_y4095 = words[12286];
    g_z4095 = words[12287];
}


/* ================================================================
 * MAIN
 * ================================================================ */

int main(void)
{
    XAxiDma_Config *DmaConfig;
    int status;

    g_stage = 0U;
    g_test_result = 0;

    /* ============================================================
     * DMA INITIALIZATION
     * ============================================================ */

#ifdef SDT

    DmaConfig = XAxiDma_LookupConfig(
        XPAR_XAXIDMA_0_BASEADDR
    );

#else

    DmaConfig = XAxiDma_LookupConfig(
        XPAR_AXIDMA_0_DEVICE_ID
    );

#endif

    if (DmaConfig == NULL) {
        g_test_result = -1;
        goto test_finished;
    }

    status = XAxiDma_CfgInitialize(
        &AxiDma,
        DmaConfig
    );

    if (status != XST_SUCCESS) {
        g_test_result = -1;
        goto test_finished;
    }

    /*
     * Projekt ma pracować w Simple Mode.
     */
    if (XAxiDma_HasSg(&AxiDma)) {
        g_test_result = -2;
        goto test_finished;
    }

    /*
     * Polling, więc nie używamy przerwań.
     */
    XAxiDma_IntrDisable(
        &AxiDma,
        XAXIDMA_IRQ_ALL_MASK,
        XAXIDMA_DEVICE_TO_DMA
    );

    XAxiDma_IntrDisable(
        &AxiDma,
        XAXIDMA_IRQ_ALL_MASK,
        XAXIDMA_DMA_TO_DEVICE
    );


    /* ============================================================
     * STAGE 1
     *
     * S2MM SYNC / DISCARD
     *
     * Łapiemy aktualnie trwającą ramkę do najbliższego TLAST.
     * ============================================================ */

    g_stage = 1U;

    memset(
        SyncBuffer,
        0xA5,
        FRAME_BYTE_COUNT
    );

    Xil_DCacheFlushRange(
        (UINTPTR)SyncBuffer,
        FRAME_BYTE_COUNT
    );

    status = XAxiDma_SimpleTransfer(
        &AxiDma,
        (UINTPTR)SyncBuffer,
        FRAME_BYTE_COUNT,
        XAXIDMA_DEVICE_TO_DMA
    );

    if (status != XST_SUCCESS) {
        g_sync_status = read_s2mm_status();
        g_test_result = -3;
        goto test_finished;
    }

    status = wait_for_dma(
        XAXIDMA_DEVICE_TO_DMA,
        &g_sync_poll_count
    );

    g_sync_status = read_s2mm_status();
    g_sync_bytes  = read_s2mm_length();

    if (status != XST_SUCCESS) {
        g_test_result = -4;
        goto test_finished;
    }


    /* ============================================================
     * STAGE 2
     *
     * S2MM FULL FRAME
     *
     * Po poprzednim TLAST pobieramy pełne:
     *
     * X0,Y0,Z0 ... X4095,Y4095,Z4095
     *
     * 24576 B
     * ============================================================ */

    g_stage = 2U;

    memset(
        RxBuffer,
        0xA5,
        FRAME_BYTE_COUNT
    );

    Xil_DCacheFlushRange(
        (UINTPTR)RxBuffer,
        FRAME_BYTE_COUNT
    );

    status = XAxiDma_SimpleTransfer(
        &AxiDma,
        (UINTPTR)RxBuffer,
        FRAME_BYTE_COUNT,
        XAXIDMA_DEVICE_TO_DMA
    );

    if (status != XST_SUCCESS) {
        g_frame_status = read_s2mm_status();
        g_test_result = -5;
        goto test_finished;
    }

    status = wait_for_dma(
        XAXIDMA_DEVICE_TO_DMA,
        &g_frame_poll_count
    );

    g_frame_status = read_s2mm_status();
    g_frame_bytes  = read_s2mm_length();

    if (status != XST_SUCCESS) {
        g_test_result = -6;
        goto test_finished;
    }

    /*
     * DMA zapisał DDR.
     *
     * CPU musi wyrzucić stare cache lines przed odczytem.
     */
    Xil_DCacheInvalidateRange(
        (UINTPTR)RxBuffer,
        FRAME_BYTE_COUNT
    );

    /*
     * Kontrola zawartości DDR.
     */
    save_debug_samples();

    /*
     * Pełna ramka musi mieć dokładnie:
     *
     * 0x6000 = 24576 B.
     */
    if (g_frame_bytes != FRAME_BYTE_COUNT) {
        g_test_result = -7;
        goto test_finished;
    }


    /* ============================================================
     * STAGE 3
     *
     * DDR -> DMA MM2S -> AXI4-STREAM
     *
     * To jest miejsce, na którym możesz ustawić breakpoint,
     * uzbroić ILA w Vivado Hardware Manager i dopiero Continue.
     * ============================================================ */

    g_stage = 3U;

    /*
     * MM2S będzie CZYTAŁ ten bufor z DDR.
     *
     * Flush gwarantuje, że DMA zobaczy aktualną zawartość pamięci.
     */
    Xil_DCacheFlushRange(
        (UINTPTR)RxBuffer,
        FRAME_BYTE_COUNT
    );

    /*
     * Uruchamiamy:
     *
     * DDR
     *  |
     *  v
     * DMA MM2S
     *  |
     *  v
     * M_AXIS_MM2S
     *
     * 24576 B
     */
    status = XAxiDma_SimpleTransfer(
        &AxiDma,
        (UINTPTR)RxBuffer,
        FRAME_BYTE_COUNT,
        XAXIDMA_DMA_TO_DEVICE
    );

    if (status != XST_SUCCESS) {
        g_mm2s_status = read_mm2s_status();
        g_test_result = -8;
        goto test_finished;
    }

    status = wait_for_dma(
        XAXIDMA_DMA_TO_DEVICE,
        &g_mm2s_poll_count
    );

    g_mm2s_status = read_mm2s_status();

    if (status != XST_SUCCESS) {
        g_test_result = -9;
        goto test_finished;
    }

    /*
     * Jeżeli doszliśmy tutaj:
     *
     * - S2MM odebrał pełne 24576 B,
     * - dane są w DDR,
     * - MM2S przeczytał bufor,
     * - cały stream został zaakceptowany przez TREADY=1.
     */
    g_stage = 4U;

    g_test_result = 1;


test_finished:

    g_stage = 5U;

    /*
     * Zatrzymujemy aplikację tutaj, aby wszystkie globalne
     * zmienne pozostały stabilne w WATCH.
     */
    while (1) {
        __asm__ volatile ("nop");
    }

    return 0;
}