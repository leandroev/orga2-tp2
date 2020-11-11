#!/bin/bash
#ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

file_location1=experimentacion/$1_microsec.txt
file_location2=experimentacion/$1_sec.txt

if [ ! -e $1.txt ]; then
	echo "Creando archivos"
	cat > $file_location1 <<EOF
EOF
	cat > $file_location2 <<EOF
EOF
else
	echo "Los archivos ya existen!"
fi

if [ -e resultados.txt ]; then
	rm resultados.txt
fi

if [ $# -lt 3 ];	then
	echo "Faltan argumentos: nombre de archivo, el tipo de implementación asm o c y una imagen. Es opcional se puede agregar de forma ordenada cantidad de iteraciones, un offsetx y un offsety"
else
	echo "Ejecución del filtro $4 veces!"
	if [ $# -eq 3 ];	then
		./build/tp2 ImagenFantasma -i $2 $3 0 0 > resultados.txt
	fi	
	if [ $# -eq 4 ];	then
		for (( i = 0; i < $4; i++ )); do
			./build/tp2 ImagenFantasma -i $2 $3 0 0 >> resultados.txt
		done
	fi	
	if [ $# -eq 5 ];	then
		for (( i = 0; i < $4; i++ )); do
			./build/tp2 ImagenFantasma -i $2 $3 $5 0 >> resultados.txt
		done
	fi	
	if [ $# -gt 5 ]; then
		for (( i = 0; i < $4; i++ )); do
			./build/tp2 ImagenFantasma -i $2 $3 $5 $6 >> resultados.txt
		done
	fi
	grep  -w "segundos" resultados.txt | grep  -oP '[0-9.]*' | cat > $file_location2
	grep  -w "microsegundos" resultados.txt | grep  -oP '[0-9.]*' | cat > $file_location1
	
	echo "Fin del programa"
fi	
