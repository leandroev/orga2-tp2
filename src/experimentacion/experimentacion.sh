#!/bin/bash
#ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
file_location1=resultados/$1_print_tp2.cvs
file_location2=resultados/$1_print_tp2_exp.cvs
file_location3=resultados/$1_ciclos.cvs
file_location4=resultados/$1_sec.cvs
file_location5=resultados/$1_microsec.cvs

if [ -e  $file_location1 ]; then
	rm $file_location1
	rm $file_location2
fi

if [  ! -d  resultados ]; then
	mkdir resultados
fi

if [ $# -lt 3 ];	then
	echo "Faltan argumentos: 
	Parametro 1: Sugerencias - Si el filtro es ImagenFantasma ingresar ''
							   Si es ImagenFantasma_enteros escribir 'enteros'
							   Si es ImagenFantasma_x4 escribir: 'x4'
	
	Parametro 2: El tipo de implementación asm o c
	Parametro 3: Directorio de la imagen. 
	
	Parametros opcionales:
		Parametro 4: cantidad de iteraciones
		Parametro 5: offsetx
		Parametro 6: offsety"
else
	if [ $# -eq 3 ];	then
	echo "Cantidad de iteraciones 1!"
		../build/tp2 ImagenFantasma -i $2 $3 0 0 >> $file_location1
		./tp2_exp ImagenFantasma -i $2 $3 0 0 >> $file_location2
	else
		echo "Cantidad de iteraciones $4!"
		if [ $# -eq 4 ];	then
			for (( i = 0; i < $4; i++ )); do
				../build/tp2 ImagenFantasma -i $2 $3 0 0 >> $file_location1
				./tp2_exp ImagenFantasma -i $2 $3 0 0 >> $file_location2
			done
		fi	

		if [ $# -eq 5 ];	then
			for (( i = 0; i < $4; i++ )); do
				../build/tp2 ImagenFantasma -i $2 $3 $5 0 >> $file_location1
				./tp2_exp ImagenFantasma -i $2 $3 $5 0 >> $file_location2
			done
		fi	

		if [ $# -gt 5 ]; then
			for (( i = 0; i < $4; i++ )); do
				../build/tp2 ImagenFantasma -i $2 $3 $5 $6 >> $file_location1
				./tp2_exp ImagenFantasma -i $2 $3 $5 $6 >> $file_location2
			done
		fi
	fi
	
	echo "Creando archivos de datos"
	grep  -w "totales" $file_location1 | grep  -oP '[0-9.]*' | cat > $file_location3
	grep  -w "segundos" $file_location2 | grep  -oP '[0-9.]*' | cat > $file_location4
	grep  -w "microsegundos" $file_location2 | grep  -oP '[0-9.]*' | cat > $file_location5
		
	echo "Fin del programa"
fi	

