mapeoTipo='gray';
modulacionTipo ='PSK';
%transmito 4 de cada [0,0], [0,1],, [1,0], [1,1] 
entrada=[0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1];
entradaM=4;

%EFECTOS DEL CANAL 
    %distribución uniforme entre min y max (para la atenuación)
    min_atenuacion = 0.5;
    max_atenuacion =0.9;
    % snr para el ruido térmico
    SNR = 1; %db
    aplicarRuido=true;
    aplicarAtenuacion=false;


[energiaSimbolo, energiaBit, simbolosModulados, simbolosOriginales, constelacion]=modulador(entrada, entradaM, mapeoTipo,modulacionTipo)


[simbolosModulados]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo)



%La entrada original y simbolosOriginales entran para calcular el error de
%bit/simbolo
[bitsDetectados, simbolosDetectados]=demodulador(entrada,simbolosOriginales,simbolosModulados,entradaM,mapeoTipo,modulacionTipo, constelacion)
