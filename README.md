
June 9th

Buena noticia Alex. Tenemos entonces bastante libertad en el formato del artículo. No es necesario que leas tanto Jasper, solo dale una mirada rápida a su Annual Review o al artículo orginal de 1998 donde empezó la discusión de emociones y protesta. En la versión v3 ya escribí una sección sobre protestas y emociones, principalmente en base a su literatura. Pero te comento 3 cosas en que te podrías enfocar en vez de Jasper. Puedes hacerlo en inglés o en español, como prefieras. Si no tienes tiempo, basta con que te enfoques en una y yo avanzo con las otras.

1. El terreno se suspendió el 18O y se retomó 18 días después. Entonces, no es que estemos midiendo el impácto exacto del 18O, sino que más bien de todo lo que pasó desde ese día hasta que se retomó el terreno. Eso incluye protestas masivas, abusos a los derechos humanos, saqueos, etc. Esa es la principal crítica que nos pueden hacer, porque no hay claridad del treatment. Aun cuando en Socious parecen ser más relajados con esas cosas. Es más, luego del 18vo día, el grupo de tratados sigue siendo tratado porque las protestas no pararon. Pero es un grupo que se está viendo afectado por el movimiento a diferencia del 27,6% de la muestra encuestada antes. Para poder dar mayor claridad de nuestro "tratamiento" sería muy bueno si puedes hacer una **tabla con lo que pasó por día entre el 18O y cuando se retomó el terreno**. La mencionaremos en la sección de método y la pondríamos en el material suplementario. Me imagino una tabla con 18 filas (una por día), y tres columnas: fecha, descripción de eventos, y links de fuente (idealmente medios gringos o en su defecto británicos). Puede que la BBC tenga los hechos descritos día por día en su sección de Chile. Si tienen otra idea para darle más claridad al tratamiento, sería genial.      
2. Ya hay algunos papers sobre el estallido social. En la versión actualizada (v3) en el github los incluyo dos. Es el de Somma y uno publicado en el International Journal of Sociology. Sería bueno si le puedes dar una **mirada a esos artículos u otros que ya se hayan publicado en inglés sobre el estallido social**. Qué podríamos decir? Un párrafo para la introducción estaría bueno. No se si digan algo relacionado con las emociones, pero también se podría poner ahí. Ojalá puedas ver cómo están llamando a las protestas... social outbreak?
3. La más latera. Podrías ayudarme a **recodificar la variable comuna en regiones? Hacemos 751 casos cada uno**. Usaron un código no estandarizado y hay incluso algunos missing. Cuéntame si lo puedes hacer y nos organizamos. Es super importante para saber si el antes y después está balanceados geográficamente. Si es que no, debemos corregir por eso en los resultados.   

Me parece muy buena idea de hacerlo 100% reproducible. Creo que es un valor agregado para el artículo y un desafío. Nunca lo he hecho 100%. El problema es que ya llevamos escritas 3500 palabras y he usado mendeley en word. Habría que cambiar todas las referencias manualmente a bibtex, pero creo que vale la pena hacerlo una vez ya tengamos un primer draft en word. Por ahora terminémoslo en word y luego lo transformamos a un Rmarkdown. Solo la preparación de variables me gustaría aun poder hacerlo en Stata.



_______________________________________________________________________

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

> FCO: Fuerte que? Voy entonces a agregar esa variable también en el análisis. Estoy de acuerdo en que podemos sugerir algo así. Voy a investigar un poco para ver cuál es la distinción teórica que podríamos hacer con las dos. Aunque para la contraparte bastará decir que no hay efecto y en las otras sí.

Creo que eso es un buen resultado y se lo podemos plantear a la contraparte como desafíos para el país, pero oportunidades para revalorizar y resignificar lo que significa ser chileno. Me imagino un gráfico con cada variable compuesto por tres estimaciones dentro del mismo gráfico (binaria, + cov, + ebalance). Prepararé eso para agregarlo antes de enviarlo a la contraparte.

> CA: Crees que parte del análisis pueda indicar que ya se han resignificado conceptos tradicionales de ser chileno. Pienso en que antes _esforzado_ era reconstruir después de un terremoto (ambito global) o ducharse con agua helada luego de trabajar en la construcción (ámbito personal). Ahora ese concepto se amplia y moderniza. 

>FCO: De todas formas podemos decir algo así! hay que ver si hay otros estudios que digan algo así para sostener que hubo un cambio en ese sentido. Voy a investigar, pero a mi me hace sentido. Si es que no encontramos nada, es algo que siempre podemos sugerir en la conclusión. Te todas formas es una variable que debemos examinar. Es una variable categórica y deberiamos analizarla como multinomial, yo solo la dicotomicé. Pero si es así, tenemos que ver que pasa con la categoría 6 de la P14. 


### Pregunta/comentarios

1. La P14 está correcta en el cuestionario? Me parece extraña la opción 6 que no refiere a los chilenos; 

> CA: No se la respuesta. Con tan poco caso de respuestas en la opción 6 en esa pregunta puede haber pasado algo en la programación. Pregunta para Alex.

2. La variable ingreso no la entendí, pero con trabajo y educación hay bastante de estatus controlado

> CA: La variable NSE (ingreso) se construye según [AIM](https://www.aimchile.cl/wp-content/uploads/2020/02/Actualización-y-Manual-GSE-AIM-2019.pdf) 

3. Los resultados deberían cambiar ligeramente con la inclusión de la región en el análisis.

> CA: Veamos.
