#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <libgen.h>

#include "tp2_exp.h"
#include "../helper/tiempo.h"
#include "../helper/libbmp.h"
#include "../helper/utils.h"
#include "../helper/imagenes.h"

// ~~~ seteo de los filtros ~~~

extern filtro_t ColorBordes;
extern filtro_t ImagenFantasma;
extern filtro_t PixeladoDiferencial;
extern filtro_t ReforzarBrillo;

filtro_t filtros[4];

// ~~~ fin de seteo de filtros ~~~

int main( int argc, char** argv ) {

    filtros[0] = ColorBordes; 
    filtros[1] = ImagenFantasma;
    filtros[2] = PixeladoDiferencial;
    filtros[3] = ReforzarBrillo;

    configuracion_t config;
    config.dst.width = 0;
    config.bits_src = 32;
    config.bits_dst = 32;

    procesar_opciones(argc, argv, &config);
    
    // Imprimo info
    if (!config.nombre) {
        printf ( "\nProcesando...\n");
        printf ( "  Filtro             : %s\n", config.nombre_filtro);
        printf ( "  Implementación     : %s\n", C_ASM( (&config) ) );
        printf ( "  Archivo de entrada : %s\n", config.archivo_entrada);
    }

    snprintf(config.archivo_salida, sizeof  (config.archivo_salida), "%s/%s.%s.EXP.%s%s.bmp",
            config.carpeta_salida, basename(config.archivo_entrada),
            config.nombre_filtro,  C_ASM( (&config) ), config.extra_archivo_salida );

    if (config.nombre) {
        printf("%s\n", basename(config.archivo_salida));
        return 0;
    }

    filtro_t *filtro = detectar_filtro(&config);

    filtro->leer_params(&config, argc, argv);
    correr_filtro_imagen(&config, filtro->aplicador);
    filtro->liberar(&config);

    return 0;
}

filtro_t* detectar_filtro(configuracion_t *config) {
    for (int i = 0; filtros[i].nombre != 0; i++) {
        if (strcmp(config->nombre_filtro, filtros[i].nombre) == 0)
            return &filtros[i];
    }
    fprintf(stderr, "Filtro '%s' desconocido\n", config->nombre_filtro);
    exit(EXIT_FAILURE);
    return NULL;
}

void imprimir_tiempos_ejecucion(struct timespec start, struct timespec end, int cant_iteraciones) {
    long cant_nanos = end.tv_nsec - start.tv_nsec;
    double cant_segundos = end.tv_sec - start.tv_sec;

    double cant_micros = ((double) cant_nanos / 1000) + (cant_segundos * 1000000);  // convierto a microsegundos
   
    cant_segundos = cant_segundos + (double) (cant_nanos / 1000000000); // convierto a segundos
   
    printf("Tiempo de ejecución:\n");
    printf("  # microsegundos totales: %.3f\n", cant_micros);
    printf("  # segundos totales: %.3f\n", (double)cant_segundos);
}

void correr_filtro_imagen(configuracion_t *config, aplicador_fn_t aplicador) {
    imagenes_abrir(config);
    struct timespec start, end;

    imagenes_flipVertical(&config->src, src_img);
    imagenes_flipVertical(&config->dst, dst_img);
    if(config->archivo_entrada_2 != 0) {
        imagenes_flipVertical(&config->src_2, src_img2);
    }

    clock_gettime(CLOCK_MONOTONIC_RAW, &start);
    for (int i = 0; i < config->cant_iteraciones; i++) {
            aplicador(config);
    }
    clock_gettime(CLOCK_MONOTONIC_RAW, &end);

    imagenes_flipVertical(&config->dst, dst_img);
    imagenes_guardar(config);
    imagenes_liberar(config);
    imprimir_tiempos_ejecucion(start, end, config->cant_iteraciones);
}
