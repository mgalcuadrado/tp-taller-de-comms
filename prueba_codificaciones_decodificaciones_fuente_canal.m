function prueba_codificaciones_decodificaciones_fuente_canal(nombre_archivo_entrada, nombre_archivo_salida)
    fprintf("Realizando la prueba de codificación y decodificación de fuente y canal para el archivo %s\n", nombre_archivo_entrada)
    [arreglo_salida_cod_fuente, diccionario, cant_distintos, longitud_minima, longitud_promedio, eficiencia] = cod_fuente(nombre_archivo_entrada);
    fprintf("La longitud mínima de codificación de Huffman es de %d, la promedio es de %d y la eficiencia se encuentra en %.2f\n", longitud_minima, longitud_promedio, eficiencia)
    [k,n,G, ~] = parametros();
    arreglo_salida_cod_canal = cod_canal(arreglo_salida_cod_fuente, k, n, G);
    [arreglo_salida_decod_canal, dmin, e, t] = decod_canal(arreglo_salida_cod_canal, k, n, G); 
    fprintf("La distancia mínima es de %d, la cantidad de errores detectables es de %d y la cantidad de errores corregibles es de %d\n", dmin, e, t)
    decod_fuente(arreglo_salida_decod_canal, nombre_archivo_salida, diccionario, cant_distintos);  
    comparar_entrada_y_salida(nombre_archivo_entrada, nombre_archivo_salida);
end