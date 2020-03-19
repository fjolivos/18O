- `Pride and protest_SP.docx`: Archivo para aprobación inicial de contraparte. 

	Es algo que podría ser la introducción del artículo. Traté de escribir algo neutro, aunque siempre es difícil. Ustedes conocen más a la contraparte que yo y siéntanse en la libertad de modificarlo. 
	
	No incluye referencias. Son solo 5000 palabras. 

### Marco teórico

- `Jasper 2011.pdf`: La revista Socious es americana, así que hay que usar un marco teórico más americano. 

	Estuve leyendo y lo que más nos sirve es tratar de enmarcarlo en la literatura de **emociones** y **mov sociales**. 

	Jasper 2011 es un review que describe la literatura. Si bien hablan de emociones como causas, ends and means. Podemos nosotros usarlo para ver emotions como consecuencias. El orgullo por el país, por el desarrollo económico y por los chilenos son emociones que se ven afectadas por un shock moral (18O). No he podido leer más, pero por ahí se me ocurre que puede ir la cosa. Propuestas son bienvenidas. 

### Scripts

- `exportImage.R`: El script es para exportar el doc a Stata, crear la fecha y definir 88 y 99 como missing. 

- `image.do`: dofile está el análisis. En algún momento le pondré más info para que sea autoexplicativo. 

### Resultados

- `180.xml`. Los resultados. 

	Pueden ver en el dofile a qué equivale cada análisis. 

	Finalmente no usé `rdrobust` porque el terreno partió mucho después del estallido, así que no es posible usar una regresión discontinua. Sin embargo, podemos hacer tres estimaciones por cada variable: Una *binaria*, luego *variables de control* y luego algo que se llama *entropy balancing* que igual es bastante cool. 

	Lo central va a ser **mostrar que la muestra de antes y después están balanceadas**. Y estoy convencido que es así. 

	* Problema con variable comuna que tiene problemas de codificación y habría que agregarla a nivel de región, voy a coordinarme con Alex para que nos dividamos eso. 

Como ya me adelantaron, los principales resultados son que el orgullo hacia le país baja, igual que sobre el desarrollo económico. Sin embargo, el orgullo sobre algunas características de los chilenos sube (lástima que en la P2 no hay efecto). 

> CA: Creo que es interesante el que no haya efecto en esa variable. Me da la impresión de que tiene algo identitario más fuerte que 

Creo que eso es un buen resultado y se lo podemos plantear a la contraparte como desafíos para el país, pero oportunidades para revalorizar y resignificar lo que significa ser chileno. Me imagino un gráfico con cada variable compuesto por tres estimaciones dentro del mismo gráfico (binaria, + cov, + ebalance). Prepararé eso para agregarlo antes de enviarlo a la contraparte.

> CA: Crees que parte del análisis pueda indicar que ya se han resignificado conceptos tradicionales de ser chileno. Pienso en que antes _esforzado_ era reconstruir después de un terremoto (ambito global) o ducharse con agua helada luego de trabajar en la construcción (ámbito personal). Ahora ese concepto se amplia y moderniza.

### Pregunta/comentarios

1. La P14 está correcta en el cuestionario? Me parece extraña la opción 6 que no refiere a los chilenos; 

> CA: No se la respuesta. Con tan poco caso de respuestas en la opción 6 en esa pregunta puede haber pasado algo en la programación. Pregunta para Alex.

2. La variable ingreso no la entendí, pero con trabajo y educación hay bastante de estatus controlado

> CA: La variable NSE (ingreso) se construye según [AIM](https://www.aimchile.cl/wp-content/uploads/2020/02/Actualización-y-Manual-GSE-AIM-2019.pdf) 

3. Los resultados deberían cambiar ligeramente con la inclusión de la región en el análisis.

> CA: Veamos.