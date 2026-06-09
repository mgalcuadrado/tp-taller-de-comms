    entrada=[0,0,1,1,1,0,0,1,0,0,0,0];
    entradaM=4;


% vector_digitos = [0011];
% num=0;
% while num > 0
%     vector_digitos = [mod(num,10) vector_digitos];
%     num = floor(num/10);
% end
% 
% disp(vector_digitos)


a= modularMPSK(entrada, entradaM,'nogray','FSK')

a=awgn(a,1000)

bitsRec = demodularMPSK(a,entradaM,'nogray','FSK')


function [simbolosModulados, constelacion] = modularMPSK(bits, M, mapeoTipo, modulacionTipo)
    


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

function bitsRecuperados = demodularMPSK(simbolos, M, mapeoTipo, modulacionTipo)

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


    bitsRecuperados= reshape(simbolosDetectados',1,[]);
    
end