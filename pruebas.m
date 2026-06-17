%% PRUEBAS FUENTE 
   prueba_cod_fuente_directo_decod_fuente("entrada.txt", "salida2.txt");
   prueba_cod_fuente_directo_decod_fuente("sherlock_holmes.txt", "sherlock_decoded.txt");

%% PRUEBAS CANAL
   %arreglo_huffman = cod_fuente("entrada.txt");
   %arreglo_a_archivo(arreglo_huffman, "entrada_pruebas_codificado_fuente.txt");
   [k, n, G, ~] = parametros();
   prueba_cod_canal_directo_decod_canal("entrada_pruebas_codificado_fuente.txt", "salida_prueba1.txt", k, n, G);
   

%% PRUEBAS MODULACIÓN / DEMODULACIÓN
   nombre_archivo_entrada = "entrada_pruebas_codificado_fuente.txt";
   nombre_archivo_salida = "salida_prueba_mod1.txt";
   [k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, snr_actual, aplicarRuido, aplicarAtenuacion] = parametros();
   
   %primero se realiza una prueba sin ruido ni atenuación
   aplicarRuido = false;
   aplicarAtenuacion = false;
   prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_entrada, nombre_archivo_salida, entradaM, min_atenuacion, max_atenuacion, snr_actual, aplicarRuido, aplicarAtenuacion);
     
    %luego se realiza una prueba con ruido bajo (10dB) y sin atenuación
    snr_actual = 10; %dB
    aplicarRuido = true;
    prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_entrada, nombre_archivo_salida, entradaM, min_atenuacion, max_atenuacion, snr_actual, aplicarRuido, aplicarAtenuacion);
  
    %se realiza una prueba con ruido alto (1dB) y sin atenuación
    snr_actual = 1;
    prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_entrada, nombre_archivo_salida, entradaM, min_atenuacion, max_atenuacion, snr_actual, aplicarRuido, aplicarAtenuacion);

%% PRUEBAS FUENTE + CANAL
    prueba_cod_decod_fuente_canal("entrada.txt", "salida2.txt");
    prueba_cod_decod_fuente_canal("sherlock_holmes.txt", "sherlock_decoded.txt");


%% PRUEBAS DE ANÁLISIS DE SISTEMA
    nombre_archivo_in = "entrada.txt";
    nombre_archivo_out = "salida_analisis_sist.txt";
    [k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion] = parametros();
    entradaM = 1; %para arrancar en M8
    for i=1:2 
        entradaM = entradaM * 2;
        %PSK SIN Y CON CODIFICACIÓN DE CANAL
        prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out, true, k, n,G, mapeoTipo, "PSK", entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
        prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out, false, k, n,G, mapeoTipo, "PSK", entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
        %FSK SIN Y CON CODIFICACIÓN DE CANAL
        prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out, true, k, n,G, mapeoTipo, "FSK", entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
        prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out, false, k, n,G, mapeoTipo, "FSK", entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    end   
    



%% PRUEBAS SISTEMA COMPLETO (FUENTE + CANAL + MODULACIÓN + EFECTOS DE CANAL)
    [k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, ~] = parametros();
    aplicarRuido = false;
    aplicarAtenuacion = false;
    prueba_programa_completo("hola.txt", "chau.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    prueba_programa_completo("entrada.txt", "salida_cod_decod.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    prueba_programa_completo("sherlock_holmes.txt", "mycroft_holmes.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    aplicarRuido = true;
    prueba_programa_completo("hola.txt", "chau.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    prueba_programa_completo("entrada.txt", "salida_cod_decod.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    prueba_programa_completo("sherlock_holmes.txt", "mycroft_holmes.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);

%%  Prueba de análisis de sistema para casos puntuales
    %prueba 2-PSK con y sin cod canal 
    nombre_archivo_in = "texto_grande.txt";
    nombre_archivo_out = "salida_analisis_sist.txt";
    [k,n,G, mapeoTipo, ~, ~, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion] = parametros();
    modulacionTipo = "PSK";
    entradaM = 16; 
    %prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out, codificaciondecanal, k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion)
    prueba_analisis_de_sistema(nombre_archivo_in,  nombre_archivo_out, true,                k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    prueba_analisis_de_sistema(nombre_archivo_in,  nombre_archivo_out, false,               k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
   

%% FUNCIONES PARA PRUEBAS

function prueba_cod_fuente_directo_decod_fuente(nombre_archivo_in, nombre_archivo_out)
    fprintf("INICIO DE PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE FUENTE CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_in);
    [arreglo_codificado, dict, cantidad_caracteres_distintos, longitud_minima, longitud_promedio, eficiencia] = cod_fuente(nombre_archivo_in);
    mensaje_prueba_cod_decod_fuente(longitud_minima, longitud_promedio, eficiencia);
    decod_fuente(arreglo_codificado, nombre_archivo_out, dict, cantidad_caracteres_distintos);
    comparar_entrada_y_salida(nombre_archivo_in, nombre_archivo_out);
    fprintf("FIN DE PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE FUENTE CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_in);
end

function prueba_cod_canal_directo_decod_canal(nombre_archivo_in, nombre_archivo_out, k, n, G)
    fprintf("INICIO DE PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE CANAL CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_in);
    arreglo_in = archivo_a_arreglo(nombre_archivo_in);
    arreglo_out_cod = cod_canal(arreglo_in, k, n, G);
    [arreglo_out, dmin, e, t] = decod_canal(arreglo_out_cod, k, n, G);
    mensaje_prueba_cod_decod_canal(k, n, G, dmin, e, t);
    arreglo_a_archivo(arreglo_out, nombre_archivo_out);
    comparar_entrada_y_salida(nombre_archivo_in, nombre_archivo_out);
    fprintf("FIN DE PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE CANAL CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_in);
end

function prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_in, nombre_archivo_out, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion)
    fprintf("INICIO DE PRUEBA DE MODULACIÓN, EFECTOS DE CANAL Y DEMODULACIÓN CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_in);
    mensaje_prueba_mod_demod_efectos_canal(mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    entrada = archivo_a_arreglo(nombre_archivo_in);
    [energiaSimbolo, energiaBit, simbolosModulados, simbolosOriginales, constelacion]=modulador(entrada, entradaM, mapeoTipo,modulacionTipo);
    [simbolosModulados]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo, entradaM);
    %La entrada original y simbolosOriginales entran para calcular el error de
    %bit/simbolo
    [bitsDetectados, simbolosDetectados, ~]=demodulador(entrada,simbolosOriginales,simbolosModulados,entradaM,mapeoTipo,modulacionTipo, constelacion);
    arreglo_a_archivo(bitsDetectados, nombre_archivo_out);
    comparar_entrada_y_salida(nombre_archivo_in, nombre_archivo_out);
    fprintf("FIN DE PRUEBA DE MODULACIÓN, EFECTOS DE CANAL Y DEMODULACIÓN CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_in);
end



function prueba_cod_decod_fuente_canal(nombre_archivo_entrada, nombre_archivo_salida)
    fprintf("INICIO DE PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE FUENTE Y CANAL CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_entrada)
    [arreglo_salida_cod_fuente, diccionario, cant_distintos, longitud_minima, longitud_promedio, eficiencia] = cod_fuente(nombre_archivo_entrada);
    fprintf("La longitud mínima de codificación de Huffman es de %d, la promedio es de %d y la eficiencia se encuentra en %.2f\n", longitud_minima, longitud_promedio, eficiencia);
    [k,n,G, ~] = parametros();
    arreglo_salida_cod_canal = cod_canal(arreglo_salida_cod_fuente, k, n, G);
    [arreglo_salida_decod_canal, dmin, e, t] = decod_canal(arreglo_salida_cod_canal, k, n, G); 
    fprintf("La distancia mínima es de %d, la cantidad de errores detectables es de %d y la cantidad de errores corregibles es de %d\n", dmin, e, t);
    decod_fuente(arreglo_salida_decod_canal, nombre_archivo_salida, diccionario, cant_distintos);  
    comparar_entrada_y_salida(nombre_archivo_entrada, nombre_archivo_salida);
    fprintf("FIN DE PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE FUENTE Y CANAL CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_entrada)
end


function [SER, BER] = prueba_programa_completo(nombre_archivo_entrada, nombre_archivo_out, codificaciondecanal, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion)
    fprintf("INICIO DE PRUEBA DEL PROGRAMA COMPLETO CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_entrada)
    [arreglo_salida_cod_fuente, diccionario, cant_distintos, longitud_minima, longitud_promedio, eficiencia] = cod_fuente(nombre_archivo_entrada);
    mensaje_prueba_cod_decod_fuente(longitud_minima, longitud_promedio, eficiencia);
    if codificaciondecanal
        arreglo_salida_cod_canal = cod_canal(arreglo_salida_cod_fuente, k, n, G);
    else
        arreglo_salida_cod_canal = arreglo_salida_cod_fuente;
    end
    mensaje_prueba_mod_demod_efectos_canal(mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    [energiaSimbolo, energiaBit, simbolosModulados, simbolosOriginales, constelacion]=modulador(arreglo_salida_cod_canal, entradaM, mapeoTipo,modulacionTipo);
    [simbolosModulados]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo, entradaM);
    [bitsDetectados, simbolosDetectados, SER, BER]=demodulador(arreglo_salida_cod_canal,simbolosOriginales,simbolosModulados,entradaM,mapeoTipo,modulacionTipo, constelacion);
    if codificaciondecanal
        [arreglo_salida_decod_canal, dmin, e, t] = decod_canal(bitsDetectados, k, n, G);
        mensaje_prueba_cod_decod_canal(k, n, G, dmin, e, t);
    else
        arreglo_salida_decod_canal = bitsDetectados;
    end
    decod_fuente(arreglo_salida_decod_canal, nombre_archivo_out, diccionario, cant_distintos);  
    comparar_entrada_y_salida(nombre_archivo_entrada, nombre_archivo_out);
    fprintf("FIN DE PRUEBA DEL PROGRAMA COMPLETO CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_entrada)
end

function prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out,codificaciondecanal, k, n, G,mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR,...
    aplicarRuido, aplicarAtenuacion)

    EbNo_vec = 0:10;

    arreglo_ser = zeros(size(EbNo_vec));
    arreglo_ber = zeros(size(EbNo_vec));

    for idx = 1:length(EbNo_vec)

        EbNo = EbNo_vec(idx);

        for i = 1:5

            snr_actual = EbNo + 10*log10(log2(entradaM));

            [SER, BER] = prueba_programa_completo(...
                nombre_archivo_in,...
                nombre_archivo_out,...
                codificaciondecanal,...
                k, n, G,...
                mapeoTipo,...
                modulacionTipo,...
                entradaM,...
                min_atenuacion,...
                max_atenuacion,...
                snr_actual,...
                aplicarRuido,...
                aplicarAtenuacion);

            arreglo_ser(idx) = arreglo_ser(idx) + SER;
            arreglo_ber(idx) = arreglo_ber(idx) + BER;

        end
    end

    arreglo_ser = arreglo_ser/5;
    arreglo_ber = arreglo_ber/5;

    cadena_modulacion = int2str(entradaM) + "-" + modulacionTipo;

    if codificaciondecanal
        cadena_cod = "con codificacion de canal";
    else
        cadena_cod = "sin codificacion de canal";
    end

    %% Guardar resultados

    tabla_resultados = [EbNo_vec(:), arreglo_ser(:), arreglo_ber(:)];

    nombre_txt = "resultados_M=2" + cadena_modulacion + "_" + ...
                 strrep(cadena_cod," ","_") + ".txt";

    writematrix(tabla_resultados, nombre_txt, 'Delimiter','tab');

    %% Graficar SER

    nombre_figura = "SER vs Eb/No " + cadena_cod + ...
                    " en " + cadena_modulacion;

    figure('Name', nombre_figura)

    semilogy(EbNo_vec, arreglo_ser,'o-','LineWidth',1.5)

    grid on

    xlabel('E_b/N_0 (dB)')
    ylabel('SER')
    title(nombre_figura)

    %% Graficar BER

    nombre_figura = "BER vs Eb/No " + cadena_cod + ...
                    " en " + cadena_modulacion;

    figure('Name', nombre_figura)

    semilogy(EbNo_vec, arreglo_ber,'o-','LineWidth',1.5)

    grid on

    xlabel('E_b/N_0 (dB)')
    ylabel('BER')
    title(nombre_figura)

end

%% FUNCIONES EXTRA DE MENSAJES

function cadena = cadena_para_indicar_estado_bool(booleano)
    if booleano
        cadena = "Sí";
    else
        cadena = "No";
    end
end

function mensaje_prueba_mod_demod_efectos_canal(mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion)
    fprintf("Parámetros de modulación y demodulación:\n\tTipo de mapeo=%s\n\tTipo de modulación =%s\n\tM=%d\n",mapeoTipo, modulacionTipo, entradaM);
    cadena_ruido = cadena_para_indicar_estado_bool(aplicarRuido);
    cadena_atenuacion = cadena_para_indicar_estado_bool(aplicarAtenuacion);
    fprintf("Parámetros de efectos del canal:\n\tRango de atenuación=[%.2f, %.2f]\n\tSNR =%d\n\t%s se aplica ruido al canal.\n\t%s se aplica atenuación al canal.\n",min_atenuacion, max_atenuacion, SNR, cadena_ruido, cadena_atenuacion);
end

function mensaje_prueba_cod_decod_canal(k, n, G, dmin, e, t)
    fprintf("Parámetros de codificación y decodificación de canal:\n\tk=%d bits, n=%d bits\n\tG=", k, n);
    for f = 1:size(G, 1)
        for c = 1:size(G, 2)
            fprintf("%d ", G(f,c));
        end
        fprintf("\n\t  ");
    end
    fprintf("Distancia mínima: %d.\n\tCantidad de errores detectables e = %d.\n\tCantidad de errores corregibles= %d\n", dmin, e, t);
end

function mensaje_prueba_cod_decod_fuente(lmin, lprom, ef)
    fprintf("Longitud mínima: %d.\n Longitud promedio = %d.\n Eficiencia= %.2f\n", lmin, lprom, ef);
end