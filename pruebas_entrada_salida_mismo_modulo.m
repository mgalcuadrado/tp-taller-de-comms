%nombre_archivo_in_cod_fuente = ;
%nombre_archivo_out_decod_fuente = "salida_decodificacion.txt";
%nombre_archivo_in_cod_canal = 
%nombre_archivo_out_decod_canal = 
%nombre_archivo_in_mod = 
%nombre_archivo_out_demod =

function pruebas_entrada_salida_mismo_modulo(nombre_archivo_in_cod_fuente, nombre_archivo_out_decod_fuente, nombre_archivo_in_cod_canal, nombre_archivo_out_decod_canal)
    [longitud_minima, longitud_promedio, eficiencia] = prueba_cod_fuente_directo_decod_fuente(nombre_archivo_in_cod_fuente, nombre_archivo_out_decod_fuente);
    fprintf("PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE FUENTE\n");
    fprintf("Longitud mínima: %d.\n Longitud promedio = %d.\n Eficiencia= %.2f\n", longitud_minima, longitud_promedio, eficiencia);
    comparar_entrada_y_salida(nombre_archivo_in_cod_fuente, nombre_archivo_out_decod_fuente);
    %prueba_cod_canal_directo_decod_canal(nombre_archivo_in_cod_canal, nombre_archivo_out_decod_canal);
    %fprintf("PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE CANAL\n");
    %%MODULADOR
    mapeoTipo='gray';
    modulacionTipo ='PSK';
    %se transmiten 4 de cada dupla [0,0], [0,1],, [1,0], [1,1] 
    entrada=[0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1];
    entradaM=4;
    %EFECTOS DEL CANAL 
    %distribución uniforme entre min y max (para la atenuación
    min_atenuacion = 0.5;
    max_atenuacion =0.9;
    % snr para el ruido térmico
    SNR = 1; %db
    aplicarRuido=true;
    aplicarAtenuacion=false;
    fprintf("PRUEBA DE MODULACIÓN Y DEMODULACIÓN CON MAPEO GRAY EN MODULACIÓN 4-PSK CON RUIDO TÉRMICO SIN ATENUACIÓN\n");
    prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, entrada, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
end


function [longitud_minima, longitud_promedio, eficiencia]= prueba_cod_fuente_directo_decod_fuente(nombre_archivo_in, nombre_archivo_out)
    [arreglo_codificado, dict, cantidad_caracteres_distintos, longitud_minima, longitud_promedio, eficiencia] = cod_fuente(nombre_archivo_in);
    salida = decodif_fuente(arreglo_codificado, nombre_archivo_out, dict, cantidad_caracteres_distintos);
end


%function prueba_cod_canal_directo_decod_canal(nombre_archivo_in, nombre_archivo_out)

%end

function prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, entrada, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion)

    [energiaSimbolo, energiaBit, simbolosModulados, simbolosOriginales, constelacion]=modulador(entrada, entradaM, mapeoTipo,modulacionTipo)
    [simbolosModulados]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo)

    %La entrada original y simbolosOriginales entran para calcular el error de
    %bit/simbolo
    [bitsDetectados, simbolosDetectados]=demodulador(entrada,simbolosOriginales,simbolosModulados,entradaM,mapeoTipo,modulacionTipo, constelacion)

end