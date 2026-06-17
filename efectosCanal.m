
 
function [simbolosCanal]=efectosCanal(simbolosModulados,min_atenuacion,max_atenuacion,SNR, energiaSimbolo, aplicarRuido, aplicarAtenuacion,modulacionTipo, entradaM)

    SNRlin = 10^(SNR/10);
    N0 = energiaSimbolo / SNRlin;
    v = N0/2; %N0, densidad espectral de potencia

    %cantidad de muestras depende del tipo de modulación
    switch upper(modulacionTipo)
    
        case 'PSK'
            N = size(simbolosModulados,1) * 2;
    
        case 'FSK'
            N = size(simbolosModulados,1) * entradaM;
    
        otherwise
            error('Modulación no soportada');
    end
    
    muestra_ruido_termico = generacion_ruido_termico(v, N);
    muestra_ruido_termico = reshape(muestra_ruido_termico,size(simbolosModulados));
    muestra_atenuacion = generacion_atenuacion(min_atenuacion, max_atenuacion);
    
    simbolosCanal = aplicar_efectos_canal(simbolosModulados, muestra_ruido_termico, muestra_atenuacion, aplicarRuido, aplicarAtenuacion);
end


%% efectos del canal

%generacion_ruido_termico() recibe una varianza v y dimensión n y genera
%una muestra aleatoria de ruido térmico con función de distribución
%Gaussiana de media nula, varianza v y dimensión n. 
function ruido = generacion_ruido_termico(v, N)
    disp('Generando muestra aleatoria de ruido térmico')
    ruido = sqrt(v) * randn(1, N);
end

%generacion_atenuacion() genera una atenuación aleatoria en el canal con
%distribución uniforme entre los valores min y max en veces. 
function atenuacion = generacion_atenuacion(min, max)
    disp('Generando muestra aleatoria de atenuación')
    atenuacion = min + (max-min) * rand();
    disp(['La atenuación introducida al canal es de ', num2str(atenuacion)])

    
end

function simbolosCanal = aplicar_efectos_canal(simbolosModulados, ruidoTermico, atenuacion, aplicarRuido, aplicarAtenuacion)

    simbolosCanal = simbolosModulados;

    % Aplicar atenuación
    if aplicarAtenuacion
        simbolosCanal = atenuacion * simbolosCanal;
    end

    % Aplicar ruido AWGN
    if aplicarRuido
        simbolosCanal = simbolosCanal + ruidoTermico;
    end

end