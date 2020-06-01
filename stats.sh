#!/bin/bash 

# La variable # pero el contenido $# es equivalente a argc de c y c++ y python
# Entonces eso quiere decir que el contenido necesita mas argumentos, por eso
# Comprobamos si tiene mas de 1 argumento, para ubicar el directorio de busqueda

if [ $# != 1 ]; then
	echo "Uso: $0 <directorio de busqueda>"
	exit
fi

searchDir=$1

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

#Punto 1)

executionSummary=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)

OutFileSummaryStats="metrics.txt"
tmpFile1="TiempoSimulado.txt"
tmpFile2="MemoriaUsada.txt"
rm -f $OutFileSummaryStats
rm -f $tmpFile1
rm -f $tmpFile2

printf "tsimTotal:promedio:min:max \n memUsed:promedio:min:max \n" >> $OutFileSummaryStats
for i in ${executionSummary[*]};
do
	printf '> %s\n' $i
	tsimTotal=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumaTiempo=0}{sumaTiempo=$6+$7+$8} END{print sumaTiempo}')
	printf "$tsimTotal \n" >>$tmpFile1
	tsimTotal_Stats=$(cat $tmpFile1 | awk 'BEGIN{ min=2**63-1; max=0}{if($tmpFile1<min){min=$tmpFile1};\
												if($tmpFile1>max){max=$tmpFile1};\
													total+=$tmpFile1; count+=1;\
													} \
													END{ print total, total/count, min, max }')

	memUsed=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumamemoria=0}{sumamemoria=$10;} END{print sumamemoria}')
	printf "$memUsed \n" >>$tmpFile2
	memUsed_stats=$(cat $tmpFile2 | awk 'BEGIN{ min=2**53-1; max=0}{if($tmpFile2<min){min=$tmpFile2};\
													if($tmpFile2>max){max=$tmpFile2};\
														total+=$tmpFile2; count+=1;\
														} \
														 END{print total, total/count, min, max}')
done
printf "%i:%i:%i:%i \n %i:%.2f:%i:%i \n" $tsimTotal_Stats $memUsed_stats >> $OutFileSummaryStats

#Punto 3)

usePhoneFiles=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)

tmpFile3="DatosTelefonos.txt"
OutFilePhone="usePhone-stats.txt"
rm -f $tmpFile3
rm -f $OutFilePhone
printf "timestamp:promedio:min:max \n" >> $OutFilePhone

for i in ${usePhoneFiles[*]};
do
	printf '> %s\n' $i
	UsoCelular=(`cat $i | tail -n+3 | cut -d ':' -f 3`)

	for j in ${UsoCelular[*]};
	do
		printf "%d:\n" $j >> $tmpFile3
		#Calculamos el promedio, min, max de cada archivo usePhone.txt, solo faltaria timestamp que no me queda claro
		usePhone_stats=$(cat $tmpFile3 | cut -d ':' -f 1 | awk 'BEGIN{ min=2**63-1; max=0}{if($j<min){min=$j}};{if($j>max){max=$j}};{total+=$j; count+=1}; END { print total/count, min, max}')
	done
	printf "$usePhone_stats \n" 
	printf "0:%.2f:%i:%i \n" $usePhone_stats >> $OutFilePhone
	rm -f $tmpFile 
done
less $tmpFile1
less metrics.txt
less usePhone-stats.txt
rm -f $tmpFile1
rm -f $tmpFile2
rm -f $tmpFile3
