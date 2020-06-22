#!/bin/bash 


# Comprobamos los parametros ingresados al momento de ejecutar el programa

if [[ $# != 1 ]] && [[ $2 != "-h" ]]; then
	echo "Usted Ingreso el siguiente elemento: ($2), por favor ejecute el programa de la forma siguiente: $0 <directorio de busqueda> [-h]"
	exit
fi

if [[ $# != 1 ]] && [[ $2 == "-h" ]]; then
	echo "Si desea realizar la busqueda de archivos en: $1, ejecute el script con el directorio nuevamente sin el parametro [-h]"
	exit
fi

if [[ $# != 1 ]] && [[ $2 == " " ]]; then
	echo "No es un comando valido, vuelva a ingresar el directorio para realizar la busqueda de los documentos"
	exit
fi
searchDir=$1

if [ $1 == "-h" ]; then
	echo "Uso del Script: $0 <directorio de busqueda> [-h]"
	exit
fi

if [ ! -e  $searchDir ]; then
	echo "Elemento $1 no existe"
	exit
fi

if [ ! -d $searchDir ]; then
	echo "$1 Es un elemento pero no un Directorio"
	exit
fi

set -x

#Punto 1)===============================================================================================================================================

executionSummary=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)

OutFileSummaryStats="metrics.txt"
tmpFile1="TiempoSimulado.txt"
tmpFile2="MemoriaUsada.txt"
rm -f $OutFileSummaryStats
rm -f $tmpFile1
rm -f $tmpFile2

printf "tsimTotal : promedio : min : max \n memUsed: promedio : min : max \n" >> $OutFileSummaryStats
for i in ${executionSummary[*]};
do
	tsimTotal=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumaTiempo=0}{sumaTiempo=$6+$7+$8} END{print sumaTiempo}')
	printf "$tsimTotal \n" >>$tmpFile1
	tsimTotal_Stats=$(cat $tmpFile1 | awk 'BEGIN{ min=2**63-1; max=0}{if($tmpFile1<min){min=$tmpFile1};\
												if($tmpFile1>max){max=$tmpFile1};\
													total+=$tmpFile1; count+=1;\
													} \
													END{ print total, total/count, min, max }')

	memUsed=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sumamemoria=0}{sumamemoria=$10;} END{print sumamemoria}')
	printf "$memUsed \n" >>$tmpFile2
	memUsed_stats=$(cat $tmpFile2 | awk 'BEGIN{ min=2**63-1; max=0}{if($tmpFile2<min){min=$tmpFile2};\
													if($tmpFile2>max){max=$tmpFile2};\
														total+=$tmpFile2; count+=1;\
														} \
														 END{print total, total/count, min, max}')
done
printf "%i : %i : %i : %i \n%i : %.2f : %i: %i \n" $tsimTotal_Stats $memUsed_stats >> $OutFileSummaryStats
rm -f $tmpFile1 $tmpFile2

#Punto 2) ==============================================================================================================================================

summaryFiles=(`find $searchDir -name '*.txt' -print | sort | grep summary | grep -v '._'`)

tmpFile3="tmpSummary.txt"
tmpFile4="tmpSummary2.txt"
tmpFile4G0="tmpSummary2G0.txt"
tmpFile4G1="tmpSummary2G1.txt"
tmpFile4G2="tmpSummary2G2.txt"
tmpFile4G3="tmpSummary2G3.txt"
tmpFile5="tmpSummary3.txt"
tmpFile5G0="tmpSummary3G0.txt"
tmpFile5G1="tmpSummary3G1.txt"
tmpFile5G2="tmpSummary3G2.txt"
tmpFile5G3="tmpSummary3G3.txt"
OutFileSummary="evacuation.txt"
rm -f $tmpFile3
rm -f $tmpFile4
rm -f $tmpFile4G0
rm -f $tmpFile4G1
rm -f $tmpFile4G2
rm -f $tmpFile4G3
rm -f $tmpFile5
rm -f $tmpFile5G0
rm -f $tmpFile5G1
rm -f $tmpFile5G2
rm -f $tmpFile5G3
rm -f $OutFileSummary
printf "Tipo de la Muestra : Promedio Tiempo Evacuacion : Min : Max \n" >> $OutFileSummary

for i in ${summaryFiles[*]};
do
#-----------------------------Calculo de todas las personas-------------------------------------------------------
	all=$( cat $i| tail -n+2 | awk -F ':' 'BEGIN{ minT=2**63-1; maxT=0 }{if($8<minT){minT=$8};\
											if($8>maxT){maxT=$8};\
											totalT+=$8; countT+=1;\
											} \
											END{ print totalT,totalT/countT,minT,maxT }')
	printf "%f:%f:%f:%f\n" $all >> $tmpFile3
	all_Stats=$( cat $tmpFile3 | awk -F ':' 'BEGIN{ minTs=2**63-1; maxTs=0 }{if($3<minTs){minTs=$3};\
											 if($4>maxTs){maxTs=$4};\
											 totalTs+=$1; countTs+=1;\
											} \
										 	END{ print totalTs/countTs,minTs,maxTs}')
#-----------------------------Calculo de todos los residentes separados por grupo etario--------------------------
	residents=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==0){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $residents >> $tmpFile4
	residents_Stats=$( cat $tmpFile4 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
	residentsG0=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==0 && $4 == 0){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $residentsG0 >> $tmpFile4G0
	residentsG0_Stats=$( cat $tmpFile4G0 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
	residentsG1=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==0 && $4 == 1){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $residentsG1 >> $tmpFile4G1
	residentsG1_Stats=$( cat $tmpFile4G1 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
	residentsG2=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==0 && $4 == 2){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $residentsG2 >> $tmpFile4G2
	residentsG2_Stats=$( cat $tmpFile4G2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
	residentsG3=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==0 && $4 == 3){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $residentsG3 >> $tmpFile4G3
	residentsG3_Stats=$( cat $tmpFile4G3 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
#--------------------------Calculo de todos los visitantesI separados por grupo etario-----------------------------
	VisitorsI=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minV=2**63-1; maxV=0 }{if($3==1){if($8<minV){minV=$8};\
											if($8>maxV){maxV=$8};\
											totalV+=$8; countV+=1;\
											}} \
											END{ print totalV,totalV/countV,minV,maxV }')
	printf "%f:%f:%f:%f\n" $VisitorsI >> $tmpFile5
	VisitorsI_Stats=$( cat $tmpFile5 | awk -F ':' 'BEGIN{ minV=2**63-1; maxV=0 }{if($3<minV){minV=$3};\
											 if($4>maxV){maxV=$4};\
											 totalV+=$1; countV+=1;\
											} \
										 	END{ print totalV/countV,minV,maxV}')
	VisitorsIG0=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==1 && $4 == 0){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $VisitorsIG0 >> $tmpFile5G0
	VisitorsIG0_Stats=$( cat $tmpFile5G0 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
	VisitorsIG1=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==1 && $4 == 1){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $VisitorsIG1 >> $tmpFile5G1
	VisitorsIG1_Stats=$( cat $tmpFile5G1 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
	VisitorsIG2=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==1 && $4 == 2){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $VisitorsIG2 >> $tmpFile5G2
	VisitorsIG2_Stats=$( cat $tmpFile4G2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
	VisitorsIG3=$( cat $i | tail -n+2 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3==1 && $4 == 3){if($8<minR){minR=$8};\
											if($8>maxR){maxR=$8};\
											totalR+=$8; countR+=1;\
											}} \
											END{ print totalR,totalR/countR,minR,maxR }')
	printf "%f:%f:%f:%f\n" $VisitorsIG3 >> $tmpFile5G3
	VisitorsIG3_Stats=$( cat $tmpFile5G3 | awk -F ':' 'BEGIN{ minR=2**63-1; maxR=0 }{if($3<minR){minR=$3};\
											 if($4>maxR){maxR=$4};\
											 totalR+=$1; countR+=1;\
											} \
										 	END{ print totalR/countR,minR,maxR}')
done
printf "Todas las personas : %f : %f : %f \n" $all_Stats >> $OutFileSummary
printf "residents : %f : %f : %f \n" $residents_Stats >> $OutFileSummary
printf "visitorsI : %f : %f : %f \n" $VisitorsI_Stats >> $OutFileSummary

printf "residents-G0 : %f : %f : %f \n" $residentsG0_Stats >> $OutFileSummary
printf "residents-G1 : %f : %f : %f \n" $residentsG1_Stats >> $OutFileSummary
printf "residents-G2 : %f : %f : %f \n" $residentsG2_Stats >> $OutFileSummary
printf "residents-G3 : %f : %f : %f \n" $residentsG3_Stats >> $OutFileSummary

printf "visitorsI-G0 : %f : %f : %f \n" $VisitorsIG0_Stats >> $OutFileSummary
printf "visitorsI-G1 : %f : %f : %f \n" $VisitorsIG1_Stats >> $OutFileSummary
printf "visitorsI-G2 : %f : %f : %f \n" $VisitorsIG2_Stats >> $OutFileSummary
printf "visitorsI-G3 : %f : %f : %f \n" $VisitorsIG3_Stats >> $OutFileSummary

rm -f $tmpFile3
rm -f $tmpFile4
rm -f $tmpFile4G0
rm -f $tmpFile4G1
rm -f $tmpFile4G2
rm -f $tmpFile4G3
rm -f $tmpFile5
rm -f $tmpFile5G0
rm -f $tmpFile5G1
rm -f $tmpFile5G2
rm -f $tmpFile5G3
#Punto 3) ==============================================================================================================================================

usePhoneFiles=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)

tmpFile6="DatosTelefonos.txt"
tmpFile7="DatosTimeStamp.txt"
OutFilePhone="usePhone-stats.txt"
rm -f $tmpFile6
rm -f $tmpFile7
rm -f $OutFilePhone
printf "timestamp:promedio:min:max \n" >> $OutFilePhone

for i in ${usePhoneFiles[*]};
do
	TimeStampCel=(`cat $i | tail -n+3 | cut -d ':' -f 2`)
	UsoCelular=(`cat $i | tail -n+3 | cut -d ':' -f 3`)

	for j in ${UsoCelular[*]};
	do
		printf "%d:\n" $j >> $tmpFile6
		usePhone_stats=$(cat $tmpFile6 | cut -d ':' -f 1 | awk 'BEGIN{ min=2**63-1; max=0}{if($j<min){min=$j}};{if($j>max){max=$j}};{total+=$j; count+=1}; END { print total/count, min, max}')
	done

	for j in ${TimeStampCel[*]};
	do
		printf "%d:\n" $j >> $tmpFile7
		TimeStampCel_stats=$(cat $tmpFile7 | awk -F ':' 'BEGIN{ totalT; countT}{totalT+=$1; countT+=1 }; END { print totalT/countT }')
	done
	printf "%i : %.2f : %i : %i \n" $TimeStampCel_stats $usePhone_stats >> $OutFilePhone
	rm -f $tmpFile6 
	rm -f $tmpFile7
done
rm -f $tmpFile6 
rm -f $tmpFile7

set +x
printf "Correcta Finalizacion, visualice archivos de salida\n"