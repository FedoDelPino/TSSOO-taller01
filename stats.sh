#!/bin/bash 

# La variable # pero el contenido $# es equivalente a argc de c y c++ y python
# Entonces eso quiere decir que el contenido necesita mas argumentos, por eso
# Comprobamos si tiene mas de 1 argumento, para ubicar el directorio de busqueda

if [ $# != 1 ]; then
	echo "Uso: $0 <directorio de busqueda>"
	exit
fi

searchDir=$1

#Falta verificar si $1 es un director, porque buscamos directores, y -e solo comprueba existencia
#Ahora vemos si el directorio de busqueda existe o no
if [ ! -e  $searchDir ]; then
	echo "Elemento $1 no existe"
	exit
fi

#Comprobar si existe el directorio
if [ ! -d $searchDir ]; then
	echo "$1 Es un elemento pero no un Directorio"
	exit
fi

printf "Directorio busqueda: %s\n" $1

#Idea de Jorge Rodriguez

usePhoneFiles=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)



#Buscar como hacer archivos temporales en Bash para este tipo, como tambien hacer archivos
#en memoria ram, es una estrucutra que se trabaja y accede mas rapido

tmpFile="fracaso.txt"
rm -f $tmpFile

for i in ${usePhoneFiles[*]};
do
	printf '> %s\n' $i
	tiempos=(`cat $i | tail -n+3 | cut -d ':' -f 3`)

	for j in ${tiempos[*]};
	do
		printf "%d:" $j >> $tmpFile
		AvgUsePhone=$(cat $tmpFile | cut -d ':' -f 1 | \awk 'BEGIN{total=0; count=0} {total+=$j; count+=1} END{print total/count}')
	done
	printf "El promedio del archivo %s es : $AvgUsePhone \n" $i

	printf "\n" >> $tmpFile
done
