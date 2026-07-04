

%Funcion principal CON EL MISMO NOMBRE DEL ARCHIVO
function [energiaSimbolo, energiaBit, distancia, simbolosModulados, simbolosOriginales, constelacion]=modulador(entrada, entradaM, mapeoTipo,modulacionTipo)

    [simbolosModulados,simbolosOriginales, constelacion] = modularSimbolos(entrada, entradaM,mapeoTipo,modulacionTipo);
    [energiaSimbolo,energiaBit]=calcularEnergias(simbolosModulados,entradaM);
    distancia = calcularDistancia(energiaSimbolo, entradaM, modulacionTipo);

end

%%
%Modulación

function [simbolosModulados, bitsAlineados, constelacion] = modularSimbolos(bits, M, mapeoTipo, modulacionTipo)
    k = log2(M);
    if mod(k, 1) ~= 0 || M < 2 || M > 16
        error('M debe ser una potencia de 2 entre 2 y 16.');
    end
    if mod(length(bits), k) ~= 0
        %se agregan ceros al final si no se pueden agrupar de a k
        bits = [bits, zeros(1, k-mod(length(bits), k))];
    end

    % Se agrupan los bits de a k bits y se convierten a decimal
    bitsAlineados = reshape(bits, k, []).';
    simbolosDecod = bi2de(bitsAlineados, 'left-msb');

    % Conversión si se pide codificación de Gray
    if strcmp(mapeoTipo, 'gray')
        simbolosDecod = bitxor(simbolosDecod, bitshift(simbolosDecod, -1)); %Para pasar a Gray es 1 shift derecha y XOR
    end



    % Se arma la constelación de referencia
    constelacion = zeros(M, 2);
    switch upper(modulacionTipo)

        case 'PSK'
            for m = 0:M-1
                constelacion(m+1, 1) = cos(2 * pi * m / M); % Componente en fase
                constelacion(m+1, 2) = sin(2 * pi * m / M); % Componente en cuadratura
            end
    

        case 'FSK'
            constelacion=eye(M);    %Es una matriz identidad
                                    %A cada simmbolo ortogonal le asignaría
                                    %una frecuencia separada de las otras
                                    %por 1/Ts (Tiempo de Símbolo)

        otherwise
            error('Tipo de modulación no soportada');
    end
    
    % Se filtra el ruido numérico 
    constelacion(abs(constelacion) < 1e-15) = 0;
    % A cada símbolo se le asigna su par de coordenadas
    simbolosModulados = constelacion(simbolosDecod + 1, :);
    % se guarda la matriz en un archivo de texto
    writematrix(simbolosModulados, "simbolosModulados.txt", 'Delimiter', 'tab');
end

function [eSimbolo, eBit] = calcularEnergias(simbolosModulados, M)

    k = log2(M);
    
    % Se calcula la norma al cuadrado de cada símbolo y se suma
    eSimbolosTotal = sum(simbolosModulados.^2, 2);
    eSimbolo = mean(eSimbolosTotal);
    eBit = eSimbolo / k;
end

function d = calcularDistancia (eSimbolo, M, modulacionTipo)
    if modulacionTipo == "PSK"
        d = sqrt(eSimbolo) * 2 * sin(pi/M);
    elseif modulacionTipo == "FSK"
        d = sqrt(2 * eSimbolo);
    else
        fprintf("Las modulaciones trabajadas son PSK y FSK\n");
        d = 0;
    end
end