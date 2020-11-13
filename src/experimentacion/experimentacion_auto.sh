#!/bin/bash
#ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
base=resultados/

datosBase=_print_tp2_exp.csv
datos1=_microseg.csv
datos2=_seg.csv
datos3=_ciclos.csv

filtro1=''
filtro2=_enteros
filtro3=_x4

cant_filtros=3


if [ -e  $base$filtro1$datosBase ]; then
	rm -f $base$filtro1$datosBase
	rm -f $base$filtro2$datosBase
	rm -f $base$filtro3$datosBase
fi

if [  ! -d  resultados ]; then
	mkdir -p resultados
fi

if [ $# -lt 2 ] || [ $# -gt 5 ];	then
	echo "Faltan argumentos:
	Parametro 1: Tipo de implementación asm o c
	Parametro 2: Ruta de la imagen
	
	Parametros opcionales:
		Parametro 3: cantidad de iteraciones
		Parametro 4: offsetx
		Parametro 5: offsety"
else
	if [ $# -eq 2 ];	then
		echo "Cantidad de iteraciones 1!"
		#../build/tp2 ImagenFantasma$1 -i $2 $3 0 0 >> $file_location1
		./tp2_exp ImagenFantasma$filtro1 -i $1 $2 0 0 
		./tp2_exp ImagenFantasma$filtro2 -i $1 $2 0 0 
		./tp2_exp ImagenFantasma$filtro3 -i $1 $2 0 0 
	else
		echo "Cantidad de iteraciones $3!"
		if [ $# -eq 3 ];	then
			#../build/tp2 ImagenFantasma$1 -i $2 $3 0 0 >> $file_location1
			./tp2_exp ImagenFantasma$filtro1 -i $1 -t $3 $2 0 0 
			./tp2_exp ImagenFantasma$filtro2 -i $1 -t $3 $2 0 0 
			./tp2_exp ImagenFantasma$filtro3 -i $1 -t $3 $2 0 0 
		fi	

		if [ $# -eq 4 ];	then
			#../build/tp2 ImagenFantasma$1 -i $2 $3 $5 0 >> $file_location1
			./tp2_exp ImagenFantasma$filtro1 -i $1 -t $3 $2 $4 0 
			./tp2_exp ImagenFantasma$filtro2 -i $1 -t $3 $2 $4 0 
			./tp2_exp ImagenFantasma$filtro3 -i $1 -t $3 $2 $4 0 
		fi	

		if [ $# -gt 4 ]; then
			#../build/tp2 ImagenFantasma$1 -i $2 $3 $5 $6 >> $file_location1
			./tp2_exp ImagenFantasma$filtro1 -i $1 -t $3 $2 $4 $5 
			./tp2_exp ImagenFantasma$filtro2 -i $1 -t $3 $2 $4 $5 
			./tp2_exp ImagenFantasma$filtro3 -i $1 -t $3 $2 $4 $5 
		fi
	fi
	
	#for (( i = 0; i < $cant_filtros; i++ )); do
	#	grep  -w "microsegundos" $basearrayfiltro[$i]$datosBase | grep  -oP '[0-9.]*' | cat > $base$filtro$i$datos$i
	#	grep  -w "por llamada" $basearrayfiltro[$i]$datosBase | grep  -oP '[0-9.]*' | cat > $base$filtro$i$datos$i
	#	grep  -w "segundos" $basearrayfiltro[$i]$datosBase | grep  -oP '[0-9.]*' | cat > $base$filtro$i$datos$i
	#done
	echo "Fin del programa"
fi	

