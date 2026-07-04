# PROYECTO INTEGRADOR TA137: Taller de Comunicaciones Digitales
##### 1C2026 - Hirchoren, Hochman
### Integrantes del Grupo 2:
- Barrionuevo, Juan Bautista 
- Gamberale, María de las Mercedes
- León, Martín Fernando
- Ochoa, Amalia

El informe se encuentra en el archivo ```"Informe_TA137_G2_v2.pdf"```.

En el archivo main.m se encuentran las pruebas realizadas para la verificación y el análisis del sistema. Las pruebas se realizan en el siguiente orden:
**1. Pruebas entre transmisor y receptor de la misma etapa**
* Codificación de fuente directamente a decodificador de fuente
* Modulación y demodulación (sin y con efectos de canal)
* Codificación de canal directamente a decodificador de canal

**2. Pruebas combinando etapas**
* Codificación/decodificación de fuente a modulador/demodulador
* Prueba del sistema completo

**3. Verificaciones de valores o resultados**
* Verificación de la tabla de síndromes del decodificador de canal
* Verificación de la energía de bit, energía de símbolo y la distancia d en la modulación

**4. Prueba de análisis de sistema**
* Sin la codificación de canal
* Con y sin la codificación de canal

Están ideadas para ir corriendo cada sección individualmente, pero se puede correr el programa completo directamente sin problema. 

Cada uno de los módulos o bloques tiene su propio archivo, indicándose con _"cod"_ bloques codificadores y _"decod"_ bloques decodificadores. 

También hay archivos adicionales de entradas utilizadas para las pruebas, todos éstos archivos de texto (```.txt```). En particular, se utilizan los siguientes:
- ```"entrada.txt"``` (entrada para la codificación de fuente)
- ```"sherlock_holmes.txt"``` (entrada para la codificación de fuente)
- ```"entrada_pruebas_codificado_fuente.txt"``` (entrada para la codificación de canal o para el modulador)
- ```"entrada_deco_pruebas.txt"```(archivo de texto realizado por el alumnado para verificar el correcto funcionamiento de la tabla de síndromes)
