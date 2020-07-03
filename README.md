# TSSOO-taller1

##### Fernando Del Pino Machuca - fernando.delpino@alumnos.uv.cl

###### Universidad de Valparaíso

---

> Como nota, antes de comenzar se debe tener los archivos de simulacion necesarios para este Taller01.

## 1. Introducción

El siguiente repositorio se basa en el desarrollo de la actividad del taller 1 de la asignatura taller de sistemas operativos. El objetivo y proposito de este, no es mas que el calculo de datos estadisticos con respecto a informacion sobre una simulacion de evacuacion de personas frente a una catastrofe.
La resolucion de este taller esta basado en el lenguaje de comandos [Bash](https://es.wikipedia.org/wiki/Bash) y ademas, todo el proceso resolutivo y de pruebas se ejecuto en una maquiuna virtual con sistema operativo Ubuntu-server.

## 2. Diseño de Solución

Este Taller presenta 3 tareas, las cuales deben ser resolvidas mediante un solo archivo Script, el cual debe entregar 3 archivos de salida por cada tarea realizada, disponiendo informacion de calculos estadisticos referente a cada archivo de lectura.

El orden y la estructura de la solucion propuesta se basa a grandes rasgos en el siguiente diseño.

![Imgur](https://i.imgur.com/Kitkxbp.png)

Al momento de ejecutar el Script, el programa debe ser capaz de buscar los archivos de la simulacion dentro del directorio especificado, junto con esto, una vez escogido entre uno de los 3 posibles archivos(executionSummary-NNN.txt, summary-NNN.txt y usePhone-NNN.txt), el programa debe ser capaz de leer y recabar la informacion necesaria para cada tarea de calculo estadistico, esto es, de forma general,calcular promedio, minimo, maximo de ciertos parametros de cada documento, entre otros datos. Una vez realizado el proceso de calculo de los requerimientos por cada tarea, se debe almacenar el contenido de la solucion de manera estructurada en cada archivo de salida exigido (metrics.txt, evacuation.txt y usePhone-stats.txt).

## 3. Estructura del Código

### 3.1 Apertura del Directorio

Lo primero es lograr la apertura de archivos existentes, en base a esto, el argumento de ejecucion del programa tambien debe tener ciertos parametros restrictivos en caso de haber sido ingresado mal. Debido a esto ultimo, lo primero fue instanciar que los argumentos ingresados estaban correctos, para esto fue necesario limitar que no se ingresara mas de 1 argumento junto a la ejecucion del programa, pero no menos que 1, donde en el caso que esto ocurriese, el programa mostraria en pantalla que el se ingreso mal el directorio de busqueda, ofreciendo al usuario una sugerencia de como se utiliza el programa. Tras realizar esta delimitacion se instancio tambien que una vez se ingresara el argumento del directorio a buscar, este sea capaz de verificar si el elemento existe y luego si el directorio existe, donde en caso de existir, este busque los archivos que se especificaran mas adelante. En caso de que no exista el elemento se advertira por pantalla de esto, y, en caso de que no exista el directorio, tambien se mostrara un aviso por pantalla de que el directorio no existe. Una vez realizado esto se entiende que el programa es capaz de abrir los archivos una vez encuentre el directorio en cuestion.

### 3.2 Tarea 1.

Tras lograr que el programa sea capaz de verificar que existe un directorio, se instancio en cada tarea, cual es el archivo buscado para cada una de estas. Para esto se busca con el comando `find` dentro de los archivos del directorio ingresado, con el nombre de "executionSummary.txt", para esto se buscará asignar la ruta de cada archivo a una variable para luego recorrer el contenido de esa variable y a su vez, el contenido de cada archivo. Filtraremos los archivos con el siguiente comando:

```
executionSummary=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)`
```

Una vez encontrado cada archivo por cada carpeta de la simulacion se crearon archivos temporales para su posterior almacenamiento de datos, donde estos seran utilizados para calcular informacion mas adelante.

Para calcular la suma del tiempo y memoria total utilizada, se creo un bucle para recorrer los archivos almacenados en `executionSummary[*]`, para luego asignar correspondientemente los valores de suma del tiempo a la variable `tsimTotal` y memoria total utilizada a `memUsed`, donde posteriormente se almacenan dentro de los archivos temporales `tmpFile1` y `tmpFile2`. El primer archivo temporal sera utilizado por el siguiente comando:

```
tsimTotal_Stats=$(cat $tmpFile1 | awk 'BEGIN{ min=2**63-1; max=0}{if($tmpFile1<min){min=$tmpFile1};\
    if($tmpFile1>max){max=$tmpFile1};\
        total+=$tmpFile1; count+=1;\
            } \
            END{ print total, total/count, min, max }')
```

y el segundo (`tmpFile2`) sera utilizado por el siguiente:

```
memUsed_stats=$(cat $tmpFile2 | awk 'BEGIN{ min=2**63-1; max=0}{if($tmpFile2<min){min=$tmpFile2};\
    if($tmpFile2>max){max=$tmpFile2};\
        total+=$tmpFile2; count+=1;\
            } \
            END{print total, total/count, min, max}')
```

Comandos similares con diferencias en los elementos que toma cada uno. El comando `cat` es principalmente utilizado para concatenar el contenido del archivo temporal, para que luego el comando `awk` pueda procesar los comandos repesctivos a al calculo estadistico de los datos, tanto para sacar minimo y maximo, como para calcular el promedio.

Una vez realizado este bucle, se almacenan los resultados obtenidos dentro del archivo de salida "metrics.txt" y se procede a eliminar los archivos temporales para continuar con la siguiente tarea.

### 3.3 Tarea 2.

Para esta tarea se filtrarán los archivos "`summary.txt`".

Una vez encontrado cada archivo por cada carpeta de la simulacion se crearon nuevamente archivos temporales para su posterior almacenamiento de datos, donde estos seran utilizados para calcular informacion mas adelante.

Tambien se realizo un bucle que recorriera el contenido de cada archivo simulado. Principalmente en este punto solo se calculo el total de personas de la simulacion, realizando la correspondiente suma de cada persona simulada, para luego calcular el promedio, min y maximo de cada archivo donde se almacenará en un archivo temporal "`tmpFile3`". Este proceso se ve en las siguiente lineas de codigo:

```
all=$( cat $i| tail -n+2 | cut -d ':' -f 8 | awk 'BEGIN{ sumEvacT_All=$i; min=2**63-1; max=0 }{if($i<min){min=$i};\
    if($i>max){max=$i};\
        total+=$i; count+=1;\
            } \
            END{ print total,total/count,min,max }')
```

Asignando a la variable "`all`" el contenido de la concatenacion del contenido de cada archivo "`summary.txt`", donde mediante el comando `tail` se tomará todo el contenido por debajo de la primera linea de los archivos de lectura, y, `cut`, se encargará de tomar el octavo item de cada columna (items separados por ":").

Tras esto, se procedera a tomar el archivo temporal actual, para calcular de forma total, el promedio de los promedios, el maximo de los maximos y el minimo de los minimos de todas las personas simuladas, almacenando este total dentro del archivo de salida "`evacuation.txt`", para luego hacer algo similar a la hora de filtrar cada tipo de persona considerando tambien el grupo etario..

> Como nota: La completacion de esta tarea se realizo correctamente, pero se entiende que pudo haberse logrado en muchas menos lineas de codigo si se utilizara de mejor manera los comandos de concatenacion y filtrado de datos..

### 3.4 Tarea 3.

Para realizar esta ultima tarea se realizo el mismo proceso de toma de archivos, creacion de archivos temporales y inicio de un bucle capaz de recorrer cada elemento de los archivos.

El proceso en este punto fue distinto ya que se almaceno dentro de una variable "`UsoCelular`" la cantidad de personas que utilizaban celulares durante la ejecucion de la simulacion, para luego instanciar otro bucle que recorriera esta variable y se almacenara dentro de un archivo temporal de forma que se almacenara una sola columna llena de datos. Este archivo temporal se tomaria cada vez para calcular el promedio, minimo y maximo de personas que utilizaban el tefolono movil durante la ejecucion de la evacuacion simulada. Este proceso se ve articulado en el siguiente comando:

```
usePhone_stats=$(cat $tmpFile4 | cut -d ':' -f 1 | awk 'BEGIN{ min=2**63-1; max=0}{if($j<min){min=$j}};{if($j>max){max=$j}};{total+=$j; count+=1}; END { print total/count, min, max}')

```

Donde se tomaria la primera columna del archivo temporal para realizar los calculos. Cada vez que se cierre este segundo bucle, se almacenaran las estadisticas de cada archivo de entrada dentro del archivo de salida "`usePhone-stats.txt`"

Tras completar el primer bucle se elimina el archivo temporal actual de la tarea y se finaliza todo el proceso de ejecucion del programa.

## 4. Conclusión.

Todo este programa esta basado en su implementacion dentro de un sistema operativo basado en Linux, es muy posible que ciertas caracteristicas no sean del todo correctas para otros sistemas operativos y ciertas funcionalidades del programa no sean eficazmente logradas.

Como observacion, no se busco implementar el mejor desempeño de cada linea codificada, pero se entendia que algunas estructuras pudieron escribirse de distinta manera quizas mas acortada, correspondiente al uso de buenas practicas.

Se puede apreciar que el cumplimiento del taller no abarco por completo ciertos aspectos:

```diff
- Optimización de lineas de codigo
- Cierto entendimiento del formato de salida de algunos archivos
```

Aunque tambien es cierto que el proceso de aprendizaje fue logrado para la completacion de los siguientes aspectos:

```diff
+ Finalización Tarea 1
+ Finalización Tarea 2
+ Finalización Tarea 3
+ Manejo de Directorios y archivos
+ Uso de comandos para filtrado de información
+ Entendimiento en menor grado del manejo del sistema operativo
```

El proposito del taller se da por logrado, correspondiendo al proceso de aprendizaje y control de archivos en un lenguaje de comandos como Bash, dentro de un sistema operativo Ubuntu-server.
