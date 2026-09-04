Paso 1: Configurar el modelo de relaciones

Para configurar el modelo, primero identificamos cuál será la tabla de hechos, porque la tabla de hechos es la que registra los eventos que vamos a analizar. En nuestro caso, el evento es una “venta”, por lo tanto, esta será nuestra tabla de hechos principal. 

Como segundo paso, se identificaron las “dimensiones”, que son las tablas que describen esas “ventas”. En nuestro caso, las tablas de dimensiones son “productos” y “clientes”, posteriormente también agregaremos” calendario” como lo demanda el ejercicio. 
Como un cliente puede aparecer en muchas ventas y un producto puede aparecer en muchas ventas, la relación entre estas dos tablas con nuestra tabla de hecho será de (1) a muchos (N); donde (1) será asignado a las tablas “productos” y “clientes”, y (N) será asignada a nuestra tabla de hechos “venta”. 

También, antes de armar el modelo aparece algo muy importante; la tabla “productos” no tiene “id_categoria”, tiene categoría como un texto que ya forma parte de la tabla, adicionalmente, tiene “subcategoría”, por lo tanto, la idea no es inventar relaciones que no son idóneas para nuestro análisis, por lo que descarté el uso de la tabla “categorias” para esta entrega. 

En conclusión, el modelo será “estrella” y procedemos a modelarlo en Power BI usando la vista modelo. Tener en cuenta que más adelante agregaremos la tabla calendario que solicita el ejercicio. 

Ver evidencia (1)
 
---------------------------------------
---------------------------------------

Paso 2: Crear la tabla calendario

Sobre la vista de tabla, creamos una nueva tabla “Dim_Fechas” siguiendo las instrucciones demandadas por el ejercicio. 

A continuación, agregamos las columnas calculadas una por una, sobre la tabla creada recientemente “Dim_Fechas”:

Finalmente, para culminar con la consigna, marcamos nuestra nueva tabla como “tabla de fechas”.

Ver evidencia (2)

---------------------------------------
---------------------------------------

Paso 3: Crear la tabla de medidas

Para que el modelo estrella creado en el “Paso 1” funcione con éxito, primero conectamos las tablas de dimensiones con la tabla de hechos, que en nuestro caso es “venta”.

Ver evidencia (3)
 
Continuamos con la creación de la tabla de medidas, cuyo objetivo será tener un lugar dedicado únicamente a almacenar las fórmulas DAX.

Ver evidencia (4)

---------------------------------------
---------------------------------------

Paso 4: Crear las cinco medidas DAX

Para culminar el proceso de transformación de la tabla “métricas” a una tabla contenedora de medidas, procedo a ocultar de la lista de informes la primer columna y posteriormente a crear la primera medida demandada por el ejercicio: 

1era medida- SUM para total ventas:
2da medida – CALCULATE para ventas online:
3era medida - acumulado temporal con TOTALYTD:
4ta medida - Comparativa anual con SAMEPERIODLASTYEAR:
5ta medida – Cálculo optimizado con VAR: formateando la medida como porcentaje como lo demanda el ejercicio.

Ver evidencia (5)

---------------------------------------
---------------------------------------

Paso 5: Validación con Matriz

Crear esta página nos permitirá validar que nuestras medidas estén funcionando como lo esperado. 

Ver evidencia (6)
 

