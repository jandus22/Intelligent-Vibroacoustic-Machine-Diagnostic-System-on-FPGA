#ifndef UDP_PROTOCOL_H
#define UDP_PROTOCOL_H

#include <stddef.h>
#include <stdint.h>

/*
 * VIBR UDP protocol, version 1
 *
 * All multibyte fields are serialized in network byte order (big-endian).
 * Do not send C structures directly over UDP. Use the packing functions below.
 */

#define VIBR_PROTOCOL_VERSION        1u

#define VIBR_MAGIC_0                 ((uint8_t)'V')
#define VIBR_MAGIC_1                 ((uint8_t)'I')
#define VIBR_MAGIC_2                 ((uint8_t)'B')
#define VIBR_MAGIC_3                 ((uint8_t)'R')

#define VIBR_HEADER_SIZE             28u
#define VIBR_MEAS_META_SIZE           8u
#define VIBR_CLASS_PAYLOAD_SIZE      20u
#define VIBR_STATUS_PAYLOAD_SIZE     20u

/* Ethernet MTU 1500 B - IPv4 header 20 B - UDP header 8 B. */
#define VIBR_MAX_UDP_DATAGRAM       1472u

/* Current transport setting: 256 x int32 = 1024 B. */
#define VIBR_ELEMENTS_PER_PACKET     256u
#define VIBR_MEAS_INT32_DATAGRAM_SIZE \
    (VIBR_HEADER_SIZE + VIBR_MEAS_META_SIZE + \
     VIBR_ELEMENTS_PER_PACKET * sizeof(int32_t))

typedef enum {
    VIBR_MSG_MEASUREMENT    = 0x01,
    VIBR_MSG_CLASSIFICATION = 0x02,
    VIBR_MSG_BOARD_STATUS   = 0x03
} vibr_message_type_t;

typedef enum {
    VIBR_DATA_TIME_SAMPLES = 0,
    VIBR_DATA_FFT_MAGNITUDE = 1,
    VIBR_DATA_FFT_COMPLEX = 2
} vibr_data_kind_t;

typedef enum {
    VIBR_FORMAT_INT32   = 0,
    VIBR_FORMAT_FLOAT32 = 1,
    VIBR_FORMAT_INT16   = 2
} vibr_element_format_t;

typedef enum {
    VIBR_CLASS_HEALTHY     = 0,
    VIBR_CLASS_INNER_FAULT = 1,
    VIBR_CLASS_OUTER_FAULT = 2,
    VIBR_CLASS_UNKNOWN     = 255
} vibr_class_id_t;

typedef enum {
    VIBR_STATE_BOOTING = 0,
    VIBR_STATE_READY   = 1,
    VIBR_STATE_RUNNING = 2,
    VIBR_STATE_ERROR   = 3
} vibr_state_t;

/*
 * Host-side descriptions. These structures are not wire-format structures.
 */
typedef struct {
    uint8_t  message_type;
    uint16_t flags;
    uint32_t frame_id;
    uint16_t packet_id;
    uint16_t packet_count;
    uint16_t payload_length;
    uint64_t timestamp_us;
} vibr_header_t;

typedef struct {
    uint8_t  data_kind;
    uint8_t  element_format;
    uint8_t  channel;
    uint16_t first_index;
    uint16_t element_count;
} vibr_measurement_meta_t;

typedef struct {
    uint8_t  class_id;
    uint8_t  class_count;
    uint16_t confidence_permille;
    uint16_t score_healthy;
    uint16_t score_inner;
    uint16_t score_outer;
    uint32_t inference_time_us;
    uint32_t model_version;
} vibr_classification_t;

typedef struct {
    uint8_t  board_state;
    uint8_t  dma_state;
    uint8_t  model_state;
    uint8_t  ethernet_state;
    uint32_t last_frame_id;
    uint32_t dropped_frames;
    uint32_t uptime_ms;
    uint32_t last_error;
} vibr_board_status_t;

static inline void vibr_write_u16_be(uint8_t *dst, uint16_t value)
{
    dst[0] = (uint8_t)(value >> 8);
    dst[1] = (uint8_t)value;
}

static inline void vibr_write_u32_be(uint8_t *dst, uint32_t value)
{
    dst[0] = (uint8_t)(value >> 24);
    dst[1] = (uint8_t)(value >> 16);
    dst[2] = (uint8_t)(value >> 8);
    dst[3] = (uint8_t)value;
}

static inline void vibr_write_u64_be(uint8_t *dst, uint64_t value)
{
    vibr_write_u32_be(dst,     (uint32_t)(value >> 32));
    vibr_write_u32_be(dst + 4, (uint32_t)value);
}

static inline uint16_t vibr_read_u16_be(const uint8_t *src)
{
    return (uint16_t)(((uint16_t)src[0] << 8) |
                      ((uint16_t)src[1]));
}

static inline uint32_t vibr_read_u32_be(const uint8_t *src)
{
    return ((uint32_t)src[0] << 24) |
           ((uint32_t)src[1] << 16) |
           ((uint32_t)src[2] << 8)  |
           ((uint32_t)src[3]);
}

static inline uint64_t vibr_read_u64_be(const uint8_t *src)
{
    return ((uint64_t)vibr_read_u32_be(src) << 32) |
           ((uint64_t)vibr_read_u32_be(src + 4));
}

static inline size_t vibr_pack_header(
    uint8_t *dst,
    size_t dst_size,
    const vibr_header_t *header)
{
    if ((dst == NULL) || (header == NULL) || (dst_size < VIBR_HEADER_SIZE)) {
        return 0u;
    }

    dst[0] = VIBR_MAGIC_0;
    dst[1] = VIBR_MAGIC_1;
    dst[2] = VIBR_MAGIC_2;
    dst[3] = VIBR_MAGIC_3;
    dst[4] = VIBR_PROTOCOL_VERSION;
    dst[5] = header->message_type;

    vibr_write_u16_be(dst + 6,  header->flags);
    vibr_write_u32_be(dst + 8,  header->frame_id);
    vibr_write_u16_be(dst + 12, header->packet_id);
    vibr_write_u16_be(dst + 14, header->packet_count);
    vibr_write_u16_be(dst + 16, header->payload_length);
    vibr_write_u16_be(dst + 18, 0u);
    vibr_write_u64_be(dst + 20, header->timestamp_us);

    return VIBR_HEADER_SIZE;
}

static inline int vibr_unpack_header(
    vibr_header_t *header,
    const uint8_t *src,
    size_t src_size)
{
    if ((header == NULL) || (src == NULL) || (src_size < VIBR_HEADER_SIZE)) {
        return -1;
    }

    if ((src[0] != VIBR_MAGIC_0) ||
        (src[1] != VIBR_MAGIC_1) ||
        (src[2] != VIBR_MAGIC_2) ||
        (src[3] != VIBR_MAGIC_3)) {
        return -2;
    }

    if (src[4] != VIBR_PROTOCOL_VERSION) {
        return -3;
    }

    header->message_type  = src[5];
    header->flags         = vibr_read_u16_be(src + 6);
    header->frame_id      = vibr_read_u32_be(src + 8);
    header->packet_id     = vibr_read_u16_be(src + 12);
    header->packet_count  = vibr_read_u16_be(src + 14);
    header->payload_length = vibr_read_u16_be(src + 16);
    header->timestamp_us  = vibr_read_u64_be(src + 20);

    if (src_size != (size_t)VIBR_HEADER_SIZE + header->payload_length) {
        return -4;
    }

    return 0;
}

static inline size_t vibr_pack_measurement_meta(
    uint8_t *dst,
    size_t dst_size,
    const vibr_measurement_meta_t *meta)
{
    if ((dst == NULL) || (meta == NULL) ||
        (dst_size < VIBR_MEAS_META_SIZE)) {
        return 0u;
    }

    dst[0] = meta->data_kind;
    dst[1] = meta->element_format;
    dst[2] = meta->channel;
    dst[3] = 0u;
    vibr_write_u16_be(dst + 4, meta->first_index);
    vibr_write_u16_be(dst + 6, meta->element_count);

    return VIBR_MEAS_META_SIZE;
}

static inline size_t vibr_pack_classification(
    uint8_t *dst,
    size_t dst_size,
    const vibr_classification_t *result)
{
    if ((dst == NULL) || (result == NULL) ||
        (dst_size < VIBR_CLASS_PAYLOAD_SIZE)) {
        return 0u;
    }

    dst[0] = result->class_id;
    dst[1] = result->class_count;
    vibr_write_u16_be(dst + 2,  result->confidence_permille);
    vibr_write_u16_be(dst + 4,  result->score_healthy);
    vibr_write_u16_be(dst + 6,  result->score_inner);
    vibr_write_u16_be(dst + 8,  result->score_outer);
    vibr_write_u16_be(dst + 10, 0u);
    vibr_write_u32_be(dst + 12, result->inference_time_us);
    vibr_write_u32_be(dst + 16, result->model_version);

    return VIBR_CLASS_PAYLOAD_SIZE;
}

static inline size_t vibr_pack_board_status(
    uint8_t *dst,
    size_t dst_size,
    const vibr_board_status_t *status)
{
    if ((dst == NULL) || (status == NULL) ||
        (dst_size < VIBR_STATUS_PAYLOAD_SIZE)) {
        return 0u;
    }

    dst[0] = status->board_state;
    dst[1] = status->dma_state;
    dst[2] = status->model_state;
    dst[3] = status->ethernet_state;
    vibr_write_u32_be(dst + 4,  status->last_frame_id);
    vibr_write_u32_be(dst + 8,  status->dropped_frames);
    vibr_write_u32_be(dst + 12, status->uptime_ms);
    vibr_write_u32_be(dst + 16, status->last_error);

    return VIBR_STATUS_PAYLOAD_SIZE;
}

static inline size_t vibr_pack_i32_array_be(
    uint8_t *dst,
    size_t dst_size,
    const int32_t *values,
    size_t count)
{
    size_t required = count * sizeof(int32_t);
    size_t i;

    if ((dst == NULL) || (values == NULL) || (dst_size < required)) {
        return 0u;
    }

    for (i = 0u; i < count; ++i) {
        vibr_write_u32_be(dst + i * sizeof(int32_t),
                          (uint32_t)values[i]);
    }

    return required;
}

#endif /* UDP_PROTOCOL_H */
