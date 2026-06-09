
%Main

%Parámetros y entrada
entrada=[0,0,1,1,1,0,0,1,0,0,0,0];
entradaM=16;



[simbolosModulados,simbolosOriginales] = modularMPSK(entrada, entradaM,'nogray','PSK');

[energiaSimbolo,energiaBit]=calcularEnergias(simbolosModulados,entradaM)

%agreggo ruido para probar
transmisionRuidosa=awgn(simbolosModulados,5);


[bitsRec, simbolosDetectados] = demodularMPSK(transmisionRuidosa,entradaM,'nogray','PSK')

disp('El error de símbolo se estima en');
errorSimbolo(simbolosOriginales,simbolosDetectados)

disp('El error de bit se estima en:');
errorBit(entrada,bitsRec)
%%
%Moudulación

function [simbolosModulados, bitsAlineados] = modularMPSK(bits, M, mapeoTipo, modulacionTipo)
    


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
            for m = 1:M
                constelacion(m, 1) = cos(2 * pi * m / M); % Componente en fase
                constelacion(m, 2) = sin(2 * pi * m / M); % Componente en cuadratura
            end
    

        case 'FSK'
            constelacion=eye(M);    %Es una matriz identidad
                                    %A cada simmbolo ortogonal le asignaría
                                    %una frecuencia separada de las otras
                                    %por 1/Ts (Tiempo de Símbolo)

        otherwise
            error('Tipo de modulación no soportada');
    end      
    % A cada símbolo le asigno su par de coordenadas
    simbolosModulados = constelacion(simbolosDecod + 1, :);
end

%%
%Decodificación

function [bitsRecibidos, simbolosDetectados] = demodularMPSK(simbolos, M, mapeoTipo, modulacionTipo)


    k = log2(M);
    numSimbolos = size(simbolos, 1);

    % Hago la constelación de referencia de nuevo
    constelacion = zeros(M, 2);
    for m = 1:M
        constelacion(m, 1) = cos(2 * pi * m / M);
        constelacion(m, 2) = sin(2 * pi * m / M);
  
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

    %if strcmp(mapeoTipo, 'gray')
     %   simbolosGray = SimbolosDetectados;
    %end
    
    simbolosDetectados = de2bi(simbolosDetectados,'left-msb');


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