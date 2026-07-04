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
   [~,~,~, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, snr_actual, ~] = parametros();
   
   %primero se realiza una prueba sin ruido ni atenuación
   aplicarRuido = false;
   aplicarAtenuacion = false;
   [~] = prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_entrada, nombre_archivo_salida, entradaM, min_atenuacion, max_atenuacion, snr_actual, aplicarRuido, aplicarAtenuacion);
     
    %luego se realiza una prueba con ruido bajo (10dB) y sin atenuación
    snr_actual = 10; %dB
    aplicarRuido = true;
    [~] = prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_entrada, nombre_archivo_salida, entradaM, min_atenuacion, max_atenuacion, snr_actual, aplicarRuido, aplicarAtenuacion);
  
    %se realiza una prueba con ruido alto (1dB) y sin atenuación
    snr_actual = 1;
    [~] = prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_entrada, nombre_archivo_salida, entradaM, min_atenuacion, max_atenuacion, snr_actual, aplicarRuido, aplicarAtenuacion);

%% PRUEBAS FUENTE + CANAL
    prueba_cod_decod_fuente_canal("entrada.txt", "salida2.txt");
    prueba_cod_decod_fuente_canal("sherlock_holmes.txt", "sherlock_decoded.txt");

%% PRUEBAS SISTEMA COMPLETO (FUENTE + CANAL + MODULACIÓN + EFECTOS DE CANAL)
    [k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, ~] = parametros();
    aplicarRuido = false;
    aplicarAtenuacion = false;
    prueba_programa_completo("entrada.txt", "salida_cod_decod.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    prueba_programa_completo("sherlock_holmes.txt", "mycroft_holmes.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    aplicarRuido = true;
    prueba_programa_completo("entrada.txt", "salida_cod_decod.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    prueba_programa_completo("sherlock_holmes.txt", "mycroft_holmes.txt", true, k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);

%% IMPRESIÓN DE LA TABLA DE SÍNDROMES
    [k, n, G, ~] = parametros();
    arreglo = archivo_a_arreglo("entrada_deco_pruebas.txt");
    [arreglo_salida, ~] = decod_canal(arreglo, k, n, G, false, char(0));
    arreglo_a_archivo(arreglo_salida, "salida_deco_pruebas.txt");
    

%% VERIFICACIÓN DE ENERGÍAS DE BIT Y SÍMBOLO 
    mapeoTipo = "gray";
    nombre_archivo_in = "entrada_pruebas_codificado_fuente.txt";
    disp('Verificación de las energías de bit y símbolo para PSK con M={2,4,8,16}')
    verificacion_energias_modulacion(nombre_archivo_in, "PSK" , mapeoTipo);
    disp('Verificación de las energías de bit y símbolo para FSK con M={2,4,8,16}')
    verificacion_energias_modulacion(nombre_archivo_in, "FSK" , mapeoTipo);
    

%%  Prueba de análisis de sistema con y sin codificación de canal
    %prueba 16-FSK con y sin cod canal 
    %nombre_archivo_in = "texto_grande.txt";
    modulacionTipo = "FSK";
    entradaM = 16; 
    nombre_archivo_in = "sherlock_holmes.txt";
    nombre_archivo_out = "salida_analisis_sist.txt";
    nombre_archivo_cod_fuente = "archivo_intermedio.txt";
    [k,n,G, mapeoTipo, ~, ~, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion] = parametros();
    %prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out, codificaciondecanal, k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion)
    [EbNo_vec, arreglo_ser_ccc, arreglo_ber_ccc, arreglo_Pe_ccc, arreglo_Pb_ccc]  = prueba_analisis_de_sistema(nombre_archivo_in,  nombre_archivo_out, true,                k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion, nombre_archivo_cod_fuente);
    [~,arreglo_ser_scc, arreglo_ber_scc, arreglo_Pe_scc, arreglo_Pb_scc] = prueba_analisis_de_sistema(nombre_archivo_in,  nombre_archivo_out, false,               k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion, nombre_archivo_cod_fuente);
    graficar_analisis_de_sistema(true, EbNo_vec, arreglo_ser_scc, arreglo_ber_scc, arreglo_Pe_scc, arreglo_Pb_scc, arreglo_ser_ccc, arreglo_ber_ccc, arreglo_Pe_ccc, arreglo_Pb_ccc, entradaM, modulacionTipo);

%%  Prueba de análisis de sistema sin codificación de canal
    %prueba 2-FSK con y sin cod canal 
    %nombre_archivo_in = "texto_grande.txt";
    modulacionTipo = "FSK";
    entradaM = 2; 
    nombre_archivo_in = "sherlock_holmes.txt";
    nombre_archivo_out = "salida_analisis_sist.txt";
    nombre_archivo_cod_fuente = "archivo_intermedio.txt";
    [k,n,G, mapeoTipo, ~, ~, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion] = parametros();
    %prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out, codificaciondecanal, k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion)
    %[EbNo_vec, arreglo_ser_ccc, arreglo_ber_ccc, arreglo_Pe_ccc, arreglo_Pb_ccc]  = prueba_analisis_de_sistema(nombre_archivo_in,  nombre_archivo_out, true,                k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion, nombre_archivo_cod_fuente);
    [EbNo_vec,arreglo_ser_scc, arreglo_ber_scc, arreglo_Pe_scc, arreglo_Pb_scc] = prueba_analisis_de_sistema(nombre_archivo_in,  nombre_archivo_out, false,               k, n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion, nombre_archivo_cod_fuente);
    graficar_analisis_de_sistema(false, EbNo_vec, arreglo_ser_scc, arreglo_ber_scc, arreglo_Pe_scc, arreglo_Pb_scc, 0, 0, 0, 0, entradaM, modulacionTipo);
%%%

%%%%%%%%%% A CONTINUACIÓN SE ENCONTRARÁN FUNCIONES AUXILIARES CREADAS
%%%%%%%%%% PARA REALIZAR LAS PRUEBAS PREVIAMENTE PRESENTADAS
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
    [arreglo_out, dmin, e, t, ~] = decod_canal(arreglo_out_cod, k, n, G, false, 0);
    mensaje_prueba_cod_decod_canal(k, n, G, dmin, e, t);
    arreglo_a_archivo(arreglo_out, nombre_archivo_out);
    comparar_entrada_y_salida(nombre_archivo_in, nombre_archivo_out);
    fprintf("FIN DE PRUEBA DE CODIFICACIÓN Y DECODIFICACIÓN DE CANAL CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_in);
end

function [SER, BER] = prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_in, nombre_archivo_out, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion)
    fprintf("INICIO DE PRUEBA DE MODULACIÓN, EFECTOS DE CANAL Y DEMODULACIÓN CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_in);
    mensaje_prueba_mod_demod_efectos_canal(mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion);
    entrada = archivo_a_arreglo(nombre_archivo_in);
    [energiaSimbolo, ~, ~, simbolosModulados, simbolosOriginales, constelacion]=modulador(entrada, entradaM, mapeoTipo,modulacionTipo);
    [simbolosModulados]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo, entradaM);
    %La entrada original y simbolosOriginales entran para calcular el error de bit/simbolo
    [bitsDetectados, ~, SER, BER]=demodulador(entrada,simbolosOriginales,simbolosModulados,entradaM,mapeoTipo,modulacionTipo, constelacion);
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
    [arreglo_salida_decod_canal, dmin, e, t, ~] = decod_canal(arreglo_salida_cod_canal, k, n, G, false, 0); 
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
    [energiaSimbolo, ~, ~, simbolosModulados, simbolosOriginales, constelacion]=modulador(arreglo_salida_cod_canal, entradaM, mapeoTipo,modulacionTipo);
    [simbolosModulados]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo, entradaM);
    [bitsDetectados, ~, SER, BER]=demodulador(arreglo_salida_cod_canal,simbolosOriginales,simbolosModulados,entradaM,mapeoTipo,modulacionTipo, constelacion);
    if codificaciondecanal
        [arreglo_salida_decod_canal, dmin, e, t, ~] = decod_canal(bitsDetectados, k, n, G, false, 0);
        mensaje_prueba_cod_decod_canal(k, n, G, dmin, e, t);
    else
        arreglo_salida_decod_canal = bitsDetectados;
    end
    decod_fuente(arreglo_salida_decod_canal, nombre_archivo_out, diccionario, cant_distintos);  
    comparar_entrada_y_salida(nombre_archivo_entrada, nombre_archivo_out);
    fprintf("FIN DE PRUEBA DEL PROGRAMA COMPLETO CON ARCHIVO DE ENTRADA %s\n", nombre_archivo_entrada)
end

function [EbNo_vec, arreglo_ser, arreglo_ber, arreglo_Pe, arreglo_Pb] = prueba_analisis_de_sistema(nombre_archivo_in, nombre_archivo_out,codificaciondecanal, k, n, G,mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR,...
    aplicarRuido, aplicarAtenuacion, nombre_archivo_cod_fuente)
    EbNo_vec = 0:10;
    arreglo_ser = zeros(size(EbNo_vec));
    arreglo_ber = zeros(size(EbNo_vec));
    arreglo_Pe = zeros(size(EbNo_vec));
    arreglo_Pb = zeros(size(EbNo_vec));
    for idx = 1:length(EbNo_vec)
       EbNo = EbNo_vec(idx);
       factor_canal = 1;
       if codificaciondecanal
            factor_canal = k/n; 
        end
        [arreglo_Pb(idx), arreglo_Pe(idx)] = calcular_probabilidades_teoricas(EbNo, entradaM, modulacionTipo, factor_canal);
        snr_actual = EbNo + 10*log10(log2(entradaM)) + log10(factor_canal); %cuando no hay codificaciondecanal log10(factor_canal) = 0
        [arreglo_salida_cod_fuente, ~] = cod_fuente(nombre_archivo_in);
        arreglo_a_archivo(arreglo_salida_cod_fuente, nombre_archivo_cod_fuente)
        if ~codificaciondecanal
            [SER, BER] = prueba_modulador_directo_demodulador(mapeoTipo, modulacionTipo, nombre_archivo_cod_fuente, nombre_archivo_out, entradaM, min_atenuacion, max_atenuacion, snr_actual, aplicarRuido, aplicarAtenuacion);
        else 
           [SER, BER] = calculo_ser_ber_con_cod_canal(arreglo_salida_cod_fuente,nombre_archivo_out,codificaciondecanal, ...
                k, n, G,mapeoTipo,modulacionTipo,entradaM,min_atenuacion,max_atenuacion,...
                snr_actual,aplicarRuido,aplicarAtenuacion);
        end
        arreglo_ser(idx) = arreglo_ser(idx) + SER;
        arreglo_ber(idx) = arreglo_ber(idx) + BER;
    end
end


%% FUNCIÓN PARA GRAFICAR EL ANÁLISIS DE SISTEMA

function graficar_analisis_de_sistema(codificaciondecanal, EbNo_vec, arreglo_ser_scc, arreglo_ber_scc, arreglo_Pe_scc, arreglo_Pb_scc, arreglo_ser_ccc, arreglo_ber_ccc, arreglo_Pe_ccc, arreglo_Pb_ccc, entradaM, modulacionTipo)
    cadena_modulacion = int2str(entradaM) + "-" + modulacionTipo;

    if codificaciondecanal
        cadena_cod = "sin y con codificacion de canal";
    else
        cadena_cod = "sin codificacion de canal";
    end
    % Graficar SER

    nombre_figura = "SER vs Eb/No " + cadena_cod + ...
                    " en " + cadena_modulacion;

    figure('Name', nombre_figura)

    semilogy(EbNo_vec, arreglo_ser_scc,'o-','LineWidth',1.5)
    hold on
        semilogy(EbNo_vec,arreglo_Pe_scc,'o-', 'LineWidth',1.5)
        if codificaciondecanal
            semilogy(EbNo_vec, arreglo_ser_ccc,'o-','LineWidth',1.5)
            semilogy(EbNo_vec,arreglo_Pe_ccc,'o-', 'LineWidth',1.5)
        end
    grid on

    xlabel('E_b/N_0 (dB)')
    ylabel('SER')
    if codificaciondecanal
        legend('Simulada s/CC', 'Teórica s/CC', 'Simulada c/CC', 'Teórica c/CC')
    else
        legend('Simulada', 'Teórica')
    end
    title(nombre_figura)

    % Graficar BER

    nombre_figura = "BER vs Eb/No " + cadena_cod + ...
                    " en " + cadena_modulacion;

    figure('Name', nombre_figura)

    semilogy(EbNo_vec, arreglo_ber_scc,'o-','LineWidth',1.5)
    hold on
        semilogy(EbNo_vec,arreglo_Pb_scc,'o-', 'LineWidth',1.5)
        if codificaciondecanal
            semilogy(EbNo_vec, arreglo_ber_ccc,'o-','LineWidth',1.5)
            semilogy(EbNo_vec,arreglo_Pb_ccc,'o-', 'LineWidth',1.5)
        end
    grid on

    xlabel('E_b/N_0 (dB)')
    ylabel('BER')
    title(nombre_figura)  
    if codificaciondecanal
        legend('Simulada s/CC', 'Teórica s/CC', 'Simulada c/CC', 'Teórica c/CC')
    else
        legend('Simulada', 'Teórica')
    end
end    


%% FUNCIONES PARA CÁLCULO DE PROBABILIDADES TEÓRICAS

    function [Pb, Pe] = calcular_probabilidades_teoricas(EbNodB, M, modulacion, factor_canal)
    EbNo = 10^(EbNodB/10);
    if factor_canal ~= 1
        EbNo = EbNo * factor_canal; 
    end
    k = log2(M);
    switch upper(modulacion)
        case 'PSK'
            % Número medio de bits erróneos (Gray)
            nb = 1; 
            if M > 2
                nb = 2;
            end
            % Es/N0
            EsNo = k * EbNo;
            % Probabilidad de error de símbolo
            Pe = qfunc(sqrt(2 * EsNo) * sin(pi/M));
            % Probabilidad de error de bit
            Pb = (nb/k) * Pe;

        case 'FSK'
            % Es/N0
            EsNo = k * EbNo;
            % Cota superior de Pe
            Pe = (M-1) * qfunc(sqrt(EsNo));
            % Probabilidad de error de bit
            Pb = (M/(2*(M-1))) * Pe;
         
        otherwise
            error('Tipo de modulación no válido. ');
    end
 end

%% FUNCIÓN PARA CÁLCULO DE SER Y BER CON COD CANAL
%se presupone que en arreglo_salida_cod_fuente hay un arreglo ya codificado por
%fuente :D 
function [SER, BER] = calculo_ser_ber_con_cod_canal(arreglo_salida_cod_fuente,nombre_archivo_out,codificaciondecanal, ...
                k, n, G,mapeoTipo,modulacionTipo,entradaM,min_atenuacion,max_atenuacion,...
                SNR,aplicarRuido,aplicarAtenuacion)
                    fprintf("INICIO DE CÁLCULO DE SER Y BER CON CODIFICACIÓN DE CANAL para %s-%s con snr = %.2f\n", entradaM, modulacionTipo, SNR)
                    arreglo_salida_cod_canal = cod_canal(arreglo_salida_cod_fuente, k, n, G);
                    [energiaSimbolo, ~, ~, simbolosModulados, simbolosOriginales, constelacion]=modulador(arreglo_salida_cod_canal, entradaM, mapeoTipo,modulacionTipo);
                    [simbolosModulados]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo, entradaM);
                    [bitsDetectados, ~, ~, ~]=demodulador(arreglo_salida_cod_canal,simbolosOriginales,simbolosModulados,entradaM,mapeoTipo,modulacionTipo, constelacion);
                    [arreglo_salida_decod_canal, ~, ~, ~, SER] = decod_canal(bitsDetectados, k, n, G, true, arreglo_salida_cod_fuente);
                    BER = errorBit(arreglo_salida_cod_fuente, arreglo_salida_decod_canal);
                    fprintf("FIN DEL CÁLCULO DEL SER Y BER CON COD CANAL PARA %s-%s con snr = %.2f\n", entradaM, modulacionTipo, SNR);   
end

%% FUNCIÓN CÁLCULO DE ERROR DE BIT

function BER = errorBit(bitsTransmitidos, bitsRecibidos)
    numBits = length(bitsTransmitidos);
    % Se truncan los bits recibidos por redondeo
    bitsRecibidos = bitsRecibidos(1:numBits);
    bitsErroneos = sum(bitsRecibidos ~= bitsTransmitidos);
    BER = bitsErroneos / numBits;
end

%% FUNCIÓN CÁLCULO DE ENERGÍAS DE BIT Y SÍMBOLO Y DISTANCIA d
%verificacion_eneregias_modulacion recibe un archivo de entrada, un tipo de
%modulación (PSK/FSK) y un mapeo (gray/binario) y calcula las energías de
%bit y símbolo para M = {2,4,8,16}
function verificacion_energias_modulacion(nombre_archivo_in, modulacionTipo, mapeoTipo)
    entradaM =2;
    while entradaM <= 16
        entrada = archivo_a_arreglo(nombre_archivo_in);
        [energiaSimbolo, energiaBit, distancia, ~]=modulador(entrada, entradaM, mapeoTipo, modulacionTipo);
        fprintf("La energía de símbolo para %d-%s es Es=%.2f\n", entradaM, modulacionTipo, energiaSimbolo);
        fprintf("La energía de bit para %d-%s es Eb=%.2f\n", entradaM, modulacionTipo, energiaBit);
        fprintf("La distancia para %d-%s es d=%.2f\n", entradaM, modulacionTipo, distancia);
        entradaM = entradaM*2;
    end
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

function arreglo = archivo_a_arreglo(nombre_archivo_entrada)
    archivo_entrada = fopen(nombre_archivo_entrada, 'r');
    if archivo_entrada == -1
      error('No se pudo abrir el archivo');
    end
    caracteres = fread(archivo_entrada, Inf, '*char')';
    fclose(archivo_entrada);
    arreglo = double(caracteres) - double('0');
end

function arreglo_a_archivo(arreglo, nombre_archivo_salida)
    archivo_salida = fopen(nombre_archivo_salida, 'w');
    if archivo_salida == -1
      error('No se puedo abrir el archivo');
    end
    fprintf(archivo_salida, '%d', arreglo);
    fclose(archivo_salida);
end

function comparar_entrada_y_salida(nombre_archivo_in, nombre_archivo_out)
    txt1 = strtrim(fileread(nombre_archivo_in));
    txt2 = strtrim(fileread(nombre_archivo_out));
    if isequal(txt1, txt2)
        fprintf('Los archivos son iguales.\n');
    else
        fprintf('Los archivos son diferentes.\n');
    end

end