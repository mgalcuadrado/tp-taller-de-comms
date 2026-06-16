function [k,n,G, mapeoTipo, modulacionTipo, entradaM, min_atenuacion, max_atenuacion, SNR, aplicarRuido, aplicarAtenuacion] = parametros()
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
    mapeoTipo='gray';
    modulacionTipo ='PSK';
    entradaM=4;
    %EFECTOS DEL CANAL 
    %distribución uniforme entre min y max (para la atenuación)
    min_atenuacion = 0.5;
    max_atenuacion =0.9;
    % snr para el ruido térmico
    SNR = 10; %db
    aplicarRuido=true;
    aplicarAtenuacion=false;
end