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

#Punto 3)
#Idea de Jorge Rodriguez

usePhoneFiles=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)



#Buscar como hacer archivos temporales en Bash para este tipo, como tambien hacer archivos
#en memoria ram, es una estrucutra que se trabaja y accede mas rapido

tmpFile="DatosTelefonos.txt"
OutFilePhone="usePhone-stats.txt"
rm -f $tmpFile
rm -f $OutFilePhone
printf "timestamp:promedio:min:max \n" >> $OutFilePhone

for i in ${usePhoneFiles[*]};
do
	printf '> %s\n' $i
	UsoCelular=(`cat $i | tail -n+3 | cut -d ':' -f 3`)

	for j in ${UsoCelular[*]};
	do
		printf "%d:\n" $j >> $tmpFile
		#Calculamos el promedio, min, max de cada archivo usePhone.txt, solo faltaria timestamp que no me queda claro
		usePhone_stats=$(cat $tmpFile | cut -d ':' -f 1 | awk 'BEGIN{ min=2**63-1; max=0}{if($j<min){min=$j}};{if($j>max){max=$j}};{total+=$j; count+=1}; END { print total/count, min, max}')
	done
	printf "$usePhone_stats \n" 
	printf "0:%.2f:%i:%i \n" $usePhone_stats >> $OutFilePhone
	rm -f $tmpFile 
done

less usePhone-stats.txt

