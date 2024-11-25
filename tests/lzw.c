#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* ----------- LZW stuff -------------- */
typedef uint8_t byte;
typedef uint16_t ushort;

#define M_CLR 256 /* clear table marker */
#define M_EOD 257 /* end-of-data marker */
#define M_NEW 258 /* new code index */

/* Encode and decode dictionary structures */
typedef struct {
    ushort next[256];
} lzw_enc_t;

typedef struct {
    ushort prev, back;
    byte c;
} lzw_dec_t;

byte* lzw_encode(byte *in, int len, int max_bits, int *out_len) {
    int bits = 9;
    int next_shift = 512;

    ushort code, c, nc, next_code = M_NEW;

    if (max_bits > 15) max_bits = 15;
    if (max_bits < 9 ) max_bits = 12;

    /* Initialize encoding dictionary */
    int dict_size = 512;
    lzw_enc_t *d = calloc(dict_size, sizeof(lzw_enc_t));
    if (!d) {
        fprintf(stderr, "Failed to allocate encoding dictionary\n");
        return NULL;
    }

    /* Initialize output buffer */
    int out_size = 512;
    byte *out = malloc(out_size * sizeof(byte));
    if (!out) {
        fprintf(stderr, "Failed to allocate output buffer\n");
        free(d);
        return NULL;
    }
    int out_len_internal = 0, o_bits = 0;
    uint32_t tmp = 0;

    void write_bits(ushort x) {
        tmp = (tmp << bits) | x;
        o_bits += bits;
        while (o_bits >= 8) {
            o_bits -= 8;
            if (out_len_internal >= out_size) {
                out_size *= 2;
                out = realloc(out, out_size * sizeof(byte));
                if (!out) {
                    fprintf(stderr, "Failed to reallocate output buffer\n");
                    free(d);
                    exit(1);
                }
            }
            out[out_len_internal++] = (tmp >> o_bits) & 0xFF;
            tmp &= (1 << o_bits) - 1;
        }
    }

    /* Start LZW encoding */
    code = *(in++);
    len--;

    while (len--) {
        c = *(in++);
        if ((nc = d[code].next[c])) {
            code = nc;
        } else {
            write_bits(code);
            nc = d[code].next[c] = next_code++;
            code = c;
        }

        if (next_code == next_shift) {
            if (++bits > max_bits) {
                write_bits(M_CLR);

                bits = 9;
                next_shift = 512;
                next_code = M_NEW;
                memset(d, 0, dict_size * sizeof(lzw_enc_t));
            } else {
                next_shift *= 2;
                dict_size = next_shift;
                d = realloc(d, dict_size * sizeof(lzw_enc_t));
                if (!d) {
                    fprintf(stderr, "Failed to reallocate encoding dictionary\n");
                    free(out);
                    return NULL;
                }
                memset(d + (dict_size / 2), 0, (dict_size / 2) * sizeof(lzw_enc_t));
            }
        }
    }

    write_bits(code);
    write_bits(M_EOD);

    if (o_bits > 0) {
        if (out_len_internal >= out_size) {
            out_size *= 2;
            out = realloc(out, out_size * sizeof(byte));
            if (!out) {
                fprintf(stderr, "Failed to reallocate output buffer\n");
                free(d);
                return NULL;
            }
        }
        out[out_len_internal++] = (tmp << (8 - o_bits)) & 0xFF;
    }

    free(d);

    out = realloc(out, out_len_internal * sizeof(byte));
    if (!out) {
        fprintf(stderr, "Failed to reallocate output buffer to final size\n");
        return NULL;
    }

    *out_len = out_len_internal;
    return out;
}

byte* lzw_decode(byte *in, int len, int *out_len) {
    byte *out = malloc(256 * sizeof(byte));
    if (!out) {
        fprintf(stderr, "Failed to allocate output buffer\n");
        return NULL;
    }
    int out_size = 256;
    int out_len_internal = 0;

    void write_out(byte c) {
        if (out_len_internal >= out_size) {
            out_size *= 2;
            out = realloc(out, out_size * sizeof(byte));
            if (!out) {
                fprintf(stderr, "Failed to reallocate output buffer\n");
                exit(1);
            }
        }
        out[out_len_internal++] = c;
    }

    int dict_size = 512;
    lzw_dec_t *d = malloc(dict_size * sizeof(lzw_dec_t));
    if (!d) {
        fprintf(stderr, "Failed to allocate decoding dictionary\n");
        free(out);
        return NULL;
    }

    int j, next_shift = 512, bits = 9, n_bits = 0;
    ushort code, c, t, next_code = M_NEW;

    uint32_t tmp = 0;
    void get_code() {
        while(n_bits < bits) {
            if (len > 0) {
                len--;
                tmp = (tmp << 8) | *(in++);
                n_bits += 8;
            } else {
                tmp = tmp << (bits - n_bits);
                n_bits = bits;
            }
        }
        n_bits -= bits;
        code = tmp >> n_bits;
        tmp &= (1 << n_bits) -1;
    }

    void clear_table() {
        memset(d, 0, dict_size * sizeof(lzw_dec_t));
        for (j = 0; j < 256; j++)
            d[j].c = j;
        next_code = M_NEW;
        next_shift = 512;
        bits = 9;
    };

    clear_table();
    while (len > 0 || n_bits >= bits) {
        get_code();
        if (code == M_EOD) break;
        if (code == M_CLR) {
            clear_table();
            continue;
        }

        if (code >= next_code) {
            fprintf(stderr, "Bad sequence\n");
            free(out);
            free(d);
            return NULL;
        }

        d[next_code].prev = c = code;
        while (c > 255) {
            t = d[c].prev; d[t].back = c; c = t;
        }

        d[next_code - 1].c = c;

        while (d[c].back) {
            write_out(d[c].c);
            t = d[c].back; d[c].back = 0; c = t;
        }
        write_out(d[c].c);

        if (++next_code >= next_shift) {
            if (++bits > 16) {
                fprintf(stderr, "Too many bits\n");
                free(out);
                free(d);
                return NULL;
            }
            next_shift *= 2;
            dict_size = next_shift;
            d = realloc(d, dict_size * sizeof(lzw_dec_t));
            if (!d) {
                fprintf(stderr, "Failed to reallocate decoding dictionary\n");
                free(out);
                return NULL;
            }
            memset(d + (dict_size / 2), 0, (dict_size / 2) * sizeof(lzw_dec_t));
        }
    }

    if (code != M_EOD)
        fputs("Bits did not end in EOD\n", stderr);

    out = realloc(out, out_len_internal * sizeof(byte));
    if (!out) {
        fprintf(stderr, "Failed to reallocate output buffer to final size\n");
        free(d);
        return NULL;
    }

    *out_len = out_len_internal;
    free(d);
    return out;
}

int main() {
    size_t i;
	char *input = "LZW319274";
    int in_len = strlen(input);
    byte *in = malloc(in_len * sizeof(byte));
    memcpy(in, input, in_len);

    printf("input: %s\n", in);
    printf("input size:   %d\n", in_len);

    int enc_len;
    byte *enc = lzw_encode(in, in_len, 9, &enc_len);
    if (!enc) {
        fprintf(stderr, "Encoding failed\n");
        free(in);
        return 1;
    }
    printf("encoded size: %d\n", enc_len);
	printf("encoded string: %s\n", enc);

    int dec_len;
    byte *dec = lzw_decode(enc, enc_len, &dec_len);
    if (!dec) {
        fprintf(stderr, "Decoding failed\n");
        free(in);
        free(enc);
        return 1;
    }
    printf("decoded size: %d\n", dec_len);

    for (i = 0; i < dec_len; i++)
        if (dec[i] != in[i]) {
            printf("bad decode at %zu\n", i);
            break;
        }

    if (i == dec_len) {
        printf("Decoded ok\n");
        printf("decoded string: %.*s\n", dec_len, dec);
    }

    free(in);
    free(enc);
    free(dec);

    return 0;
}
