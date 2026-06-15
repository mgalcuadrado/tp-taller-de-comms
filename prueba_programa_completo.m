

function prueba_programa_completo(nombre_archivo_in_codificacion, nombre_archivo_out)
    [arreglo_salida_cod_fuente, diccionario, cant_distintos, longitud_minima, longitud_promedio, eficiencia] = cod_fuente(nombre_archivo_in_codificacion);
    [k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion] = parametros();
    arreglo_salida_cod_canal = cod_canal(arreglo_salida_cod_fuente, k, n, G);
    %[energiaSimbolo, energiaBit, simbolosModulados, simbolosOriginales, constelacion]=modulador(arreglo_salida_cod_canal, entradaM, mapeoTipo,modulacionTipo);
    %[simbolosModulados]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo);
    %[bitsDetectados, simbolosDetectados]=demodulador(entrada,simbolosOriginales,simbolosModulados,entradaM,mapeoTipo,modulacionTipo, constelacion);
    %[arreglo_salida_decod_canal, dmin, e, t] = decod_canal(bitsDetectados, k, n, G);
    [arreglo_salida_decod_canal, dmin, e, t] = decod_canal(arreglo_salida_cod_canal, k, n, G); %momentáneo hasta poder agregar la modulación
    nombre_archivo_out = decod_fuente(arreglo_salida_decod_canal, nombre_archivo_out, diccionario, cant_distintos);  
end