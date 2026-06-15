%% Prueba Completa

mapeoTipo='gray';

modulacionTipo ='PSK';

entradaM = 4;

nombre_archivo_in_codificacion = "entrada.txt";

k = 11;
n = 15; 

 G = [1 1 0 1 1 0 0 0 0 0 0 0 0 0 0;
      1 0 1 1 0 1 0 0 0 0 0 0 0 0 0;
      1 0 0 1 0 0 1 0 0 0 0 0 0 0 0;
      0 1 1 1 0 0 0 1 0 0 0 0 0 0 0;
      1 1 1 0 0 0 0 0 1 0 0 0 0 0 0;
      0 0 1 0 0 0 0 0 0 1 0 0 0 0 0;
      0 1 0 0 0 0 0 0 0 0 1 0 0 0 0;
      1 0 0 0 0 0 0 0 0 0 0 1 0 0 0;
      1 1 0 0 0 0 0 0 0 0 0 0 1 0 0;
      0 1 1 0 0 0 0 0 0 0 0 0 0 1 0;
      0 0 0 1 0 0 0 0 0 0 0 0 0 0 1];

%EFECTOS DEL CANAL 
    %distribución uniforme entre min y max (para la atenuación)
    min_atenuacion = 0.5;
    max_atenuacion =0.9;
    % snr para el ruido térmico
    SNR = 1; %db
    aplicarRuido=true;
    aplicarAtenuacion=false;


%% Codificación de Fuente
[salida_cod_fuente, dict, cantidad_caracteres_distintos, longitud_minima, longitud_promedio, eficiencia] = cod_fuente(nombre_archivo_in_codificacion);

%% Codificación de Canal
salida_cod_canal = cod_canal(salida_cod_fuente, k, n, G);

%% Modulador
[energiaSimbolo, energiaBit, simbolosModulados, simbolosOriginales, constelacion] = modulador(salida_cod_canal, entradaM, mapeoTipo, modulacionTipo);

% . . .

%% Efectos de Canal
[transmisionRuidosa] = efectosCanal(simbolosModulados, min_atenuacion, max_atenuacion, SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion, modulacionTipo);

% . . .

%% Demodulador
[bitsDetectados, simbolosDetectados] = demodulador (salida_cod_canal, simbolosOriginales, transmisionRuidosa, entradaM, mapeoTipo, modulacionTipo, constelacion);

%% Decodificación de Canal
[salida_de_cod, dmin, e, t] = decod_canal(bitsDetectados, k, n, G);

%  -> Disparidad de tipos de archivo acá, salen arreglos del deco de canal,
%     necesita archivo el deco de fuente.

%% Decodificación de Fuente
[nombre_archivo_out_decodificacion] = decod_fuente(nombre_archivo_in_decodificacion, dict, cantidad_caracteres_distintos);


