#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include "../tp2_exp.h"

void ImagenFantasma_x4_asm (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size, int offsetx, int offsety);

void ImagenFantasma_x4_c   (uint8_t *src, uint8_t *dst, int width, int height,
                      int src_row_size, int dst_row_size, int offsetx, int offsety);

typedef void (ImagenFantasma_x4_fn_t) (uint8_t*, uint8_t*, int, int, int, int, int, int);

typedef struct s_imagen_fantasma_params {
	int offsetx, offsety;
} imagen_fantasma_params_t;

static imagen_fantasma_params_t extra;

void leer_params_ImagenFantasma_x4(configuracion_t *config, int argc, char *argv[]) {
	config->extra_config = &extra;
    extra.offsetx = atoi(argv[argc - 2]);
    extra.offsety = atoi(argv[argc - 1]);
}

void aplicar_ImagenFantasma_x4(configuracion_t *config)
{
    ImagenFantasma_x4_fn_t *ImagenFantasma_x4 = SWITCH_C_ASM( config, ImagenFantasma_x4_c, ImagenFantasma_x4_asm );
    buffer_info_t info = config->src;
    int offsetx = extra.offsetx;
    int offsety = extra.offsety;
    if( offsetx < 0 ) offsetx = 0;
    if( offsety < 0 ) offsety = 0;
    if( offsetx > info.width/2 + 1) offsetx = info.width/2 + 1;
    if( offsety > info.height/2 + 1) offsety = info.height/2 + 1;
    ImagenFantasma_x4(info.bytes, config->dst.bytes, info.width, info.height, 
              info.row_size, config->dst.row_size, offsetx, offsety);
}

void liberar_ImagenFantasma_x4(configuracion_t *config) {

}

void ayuda_ImagenFantasma_x4()
{
    printf ( "       * ImagenFantasma_x4\n" );
    printf ( "           Ejemplo de uso : \n"
             "                         ImagenFantasma_x4 -i c facil.bmp <offsetX> <offsetY>\n" );
}

DEFINIR_FILTRO(ImagenFantasma_x4,1)


