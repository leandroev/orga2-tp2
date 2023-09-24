# orga2-tp2

Este trabajo práctico consiste en implementar filtros gráficos utilizando el modelo de procesamiento SIMD.  

Incluye herramientas de test y tiempo. Además de un informe como resultado de experimentaciones.

## Compilación
Ejecutar make desde la carpeta src. Cada directorio tiene su propio Makefile.

## Uso
El uso del programa principal es el siguiente:
$ ./tp2 <nombre_filtro> <opciones> <nombre_archivo_entrada> [parámetros...]

Los filtros que se pueden aplicar y sus parámetros son ImagenFantasma_asm y ColorBordes_asm.
Las opciones que acepta el programa son las siguientes:  
		-h, --help  (Imprime la ayuda).  
    -i, --implementacion NOMBRE_MODO (Implementación sobre la que se ejecutará el proceso seleccionado, las implementaciones 
    disponibles son: c, asm).  
    -t, --tiempo CANT_ITERACIONES (Mide el tiempo que tarda en ejecutar el filtro sobre la imagen de entrada una cantidad
    de veces igual a CANT_ITERACIONES).  
    -o, --output DIRECTORIO (Genera el resultado en DIRECTORIO. De no incluirse, el resultado se guarda en el mismo
    directorio que el archivo fuente).  
    -v, --verbose (Imprime información adicional).  

### Para más info leer el enunciado 
