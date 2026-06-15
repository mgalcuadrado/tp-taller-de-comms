
%Main
%Parámetros y entrada

mapeoTipo='gray';
modulacionTipo ='PSK';

% para que sirva apra todos los casos de MPSK tiene que ser multiplo de 12,
% le paso 24 con 3 de cada 00, 01, 11, 10
%entrada=[0,0,0,1,1,0,1,1,0,0,1,0,0,0,0,1,1,0,1,1,0,1,1,1];
%entrada mas larga para la prueba
entrada=[0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,0,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,0,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1];
entradaM=2;
k = log2(entradaM);
[simbolosModulados,simbolosOriginales, constelacion] = modularSimbolos(entrada, entradaM,mapeoTipo,modulacionTipo);

[energiaSimbolo,energiaBit]=calcularEnergias(simbolosModulados,entradaM);

%agrego ruido para probar
transmisionRuidosa=awgn(simbolosModulados,5);


[bitsDetectados, simbolosDetectados] = demodularSimbolos(transmisionRuidosa,entradaM,mapeoTipo,modulacionTipo);

disp('El error de símbolo se estima en');
errorSimbolo(simbolosOriginales,simbolosDetectados)

disp('El error de bit se estima en:');
errorBit(entrada,bitsDetectados)

entrada
bitsDetectados

%% EFECTOS DEL CANAL 

%distribución uniforme entre min y max (para la atenuación)
min_atenuacion = 0.5;
max_atenuacion =0.9;
% snr para el ruido térmico
SNR = 6; %db
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

simbolosCanal = aplicar_efectos_canal(simbolosModulados, muestra_ruido_termico, muestra_atenuacion, true, false);

%% Grafico de las regiones de decision PSK, muestras teoricas y ruidosas
colorYellowGreen = [154, 205, 50] / 255;


if strcmp(modulacionTipo, 'FSK')
    msgbox('FSK es M-dimensional. Las regiones de decisión no se pueden graficar en un plano 2D.', 'Aviso FSK');
else
    figure('Color', 'w'); hold on; grid on; axis equal;
    
    %lim = max(max(abs(constelacion))) + 1.5; 
    lim = 2; %asi todas las imagenes tienen el mismo tamaño
    
    %Grafico los simbolos que recibí, los hice un poco mas lindos
    %plot(simbolosCanal(:,1), simbolosCanal(:,2), '.', 'Color', colorYellowGreen, 'MarkerSize', 15);
    scatter(simbolosCanal(:,1), simbolosCanal(:,2),50,colorYellowGreen, 'filled','MarkerFaceAlpha',0.4);
    
    % Regiones de decision
    ang_sep = 2*pi/entradaM;
    for m = 0:entradaM-1
        theta = m*ang_sep - ang_sep/2;
        line([0 lim*cos(theta)], [0 lim*sin(theta)], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
    end
        
    % Grafico los puntos ideales de la constelación
    %plot(constelacion(:,1), constelacion(:,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', colorYellowGreen,'MarkerEdgeColor', colorYellowGreen);
    scatter(constelacion(:,1), constelacion(:,2),100,colorYellowGreen, 'filled','MarkerFaceAlpha',1,'MarkerEdgeColor', 'b');
    
    % Dibujo etiquetas de texto binarias al lado de los puntos ideales
    for m = 0:entradaM-1
        if strcmpi(mapeoTipo,'gray')
            etiqueta = bitxor(m,bitshift(m,-1));
        else
            etiqueta = m;
        end

        b_texto = dec2bin(etiqueta,k);
        text(constelacion(m+1, 1)+0.15, constelacion(m+1, 2)+0.15, b_texto, 'FontSize', 10, 'FontWeight', 'bold');
    end
    

    xlim([-lim, lim]); ylim([-lim, lim]);
    %title(['Espacio de Señales y Regiones de Decisión: ' num2str(entradaM) '-' modulacionTipo]);
    xlabel('\phi_1'); ylabel('\phi_2');
end


%%
%Moudulación

function [simbolosModulados, bitsAlineados, constelacion] = modularSimbolos(bits, M, mapeoTipo, modulacionTipo)
    


    k = log2(M);
    if mod(k, 1) ~= 0 || M < 2 || M > 16
        error('M debe ser una potencia de 2 entre 2 y 16.');
    end
    if mod(length(bits), k) ~= 0
        error('La longitud del vector de bits debe ser múltiplo de log2(M).');
    end

    % Agrupo bits en palabras y convierto a decimal
    bitsAlineados = reshape(bits, k, []).';
    simbolosDecod = bi2de(bitsAlineados, 'left-msb');

    % COnversión si me piden Gray
    if strcmp(mapeoTipo, 'gray')
        simbolosDecod = bitxor(simbolosDecod, bitshift(simbolosDecod, -1)); %Para pasar a Gray es 1 shift derecha y XOR
    end



    % Armo la constelación de referencia
    constelacion = zeros(M, 2);
    switch upper(modulacionTipo)

        case 'PSK'
            %acá cambie el indice para corregir el desfasaje
            for m=0:M-1
                constelacion(m+1,1)=cos(2*pi*m/M);
                constelacion(m+1,2)=sin(2*pi*m/M);
            end
    

        case 'FSK'
            constelacion=eye(M);    %Es una matriz identidad
                                    %A cada simmbolo ortogonal le asignaría
                                    %una frecuencia separada de las otras
                                    %por 1/Ts (Tiempo de Símbolo)

        otherwise
            error('Tipo de modulación no soportada');
    end
    
    %filtro ruido numerico 
    constelacion(abs(constelacion) < 1e-15) = 0;
    % A cada símbolo le asigno su par de coordenadas
    simbolosModulados = constelacion(simbolosDecod + 1, :);
    % escribo en un .txt
    writematrix(simbolosModulados, "simbolosModulados.txt", 'Delimiter', 'tab');
end

%%
%Demodulación

function [bitsRecibidos, simbolosDetectados] = demodularSimbolos(simbolos, M, mapeoTipo, modulacionTipo)


    k = log2(M);
    numSimbolos = size(simbolos, 1);

    % Hago la constelación de referencia de nuevo
    constelacion = zeros(M, 2);
    %aca tambien cambie la referencia
    for m=0:M-1
        constelacion(m+1,1)=cos(2*pi*m/M);
        constelacion(m+1,2)=sin(2*pi*m/M);  
    end

    % Inicializo el vector
    simbolosDetectados = zeros(numSimbolos, 1);
    
    switch upper(modulacionTipo)

        case('PSK')
    % Lo hacemos para cada simbolo
            for i = 1:numSimbolos
                puntoRecibido = simbolos(i, :);
                
                % Calculo la distancia a los puntos de la constelacion
                distancias = sqrt((constelacion(:,1) - puntoRecibido(1)).^2 + ...
                                  (constelacion(:,2) - puntoRecibido(2)).^2);
                
                % Agarro la distancia mas chica
                [~, simbolosDetectados(i)] = min(distancias);
                
            end
        case('FSK')

            [~, simbolosDetectados] = max(simbolos, [], 2);
        otherwise
            error('Tipo de modulación no soportada');
    end

    simbolosDetectados=simbolosDetectados-1;

    %Deshacer el Gray ???

    if strcmp(mapeoTipo, 'gray')

        simbolosBinarios = zeros(size(simbolosDetectados));
    
        % Recorro cada símbolo recibido
        for i = 1:length(simbolosDetectados)

            valoresGray = simbolosDetectados(i);
            valoresBinarios = 0;
           
            while valoresGray > 0
                valoresBinarios = bitxor(valoresBinarios, valoresGray);
                valoresGray = bitshift(valoresGray, -1);
            end
            
            % Guardo el valor final del simbolo
            simbolosBinarios(i) = valoresBinarios;
        end
    simbolosDetectados = simbolosBinarios;
    end
        
    
    simbolosDetectados = de2bi(simbolosDetectados,k,'left-msb');
    bitsRecibidos= reshape(simbolosDetectados',1,[]);
    
end

%%
%Energía de símbolo/bit

function [eSimbolo, eBit] = calcularEnergias(simbolosModulados, M)

    k = log2(M);
    
    % Norma al cuadrado de cada simbolo y se suma
    eSimbolosTotal = sum(simbolosModulados.^2, 2);
    eSimbolo = mean(eSimbolosTotal);
   
    eBit = eSimbolo / k;
end


function SER = errorSimbolo(simbolosTransmitidos, simbolosDemodulados)

    numSimbolos = size(simbolosTransmitidos, 1);
    
    % Busco qué filas son diferentes
    diferencias = sum(abs(simbolosTransmitidos - simbolosDemodulados), 2);
    diferencias = diferencias>0.001;

    % Cuento los que tienen errores
    simbolosError = sum(diferencias);
    
    % Estimo la tasa de error
    SER = simbolosError / numSimbolos;
end


function BER = errorBit(bitsTransmitidos, bitsRecibidos)
   
    numBits=length(bitsTransmitidos);
    
    %Los bits erroneos son los que son distintos
    bitsErroneos=sum(bitsRecibidos~=bitsTransmitidos);
    
    %Estimo el error de bit
    BER=bitsErroneos/numBits;
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