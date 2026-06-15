%% Receptor
function [arreglo_salida, dmin, e, t] = decod_canal(arreglo, k, n, G)
    size_salida = int32(k * ceil(size(arreglo, 2) / n));
    arreglo_salida = zeros(1, size_salida);
    indice_original = 1;
    indice_nuevo = 1;
    H = matrizParidad(G, n, k);
    S = tablaSindromes(H);
    while indice_nuevo < size_salida 
        bloque_actual = parsear_arreglo(arreglo, indice_original, indice_original + n - 1);
        arreglo_salida(1, indice_nuevo:indice_nuevo + k - 1) = decodificar_Hamming_bloque(H, S, bloque_actual, n, k); 

        %este límite de indice_nuevo + n se podría pasar con un criterio distinto para el último bloque

        indice_original = indice_original + n;
        indice_nuevo = indice_nuevo + k;
    end
    [dmin, e, t] = calcularParametrosCodigo(G);
end


% 1)

function H = matrizParidad(G, n, k)
    G_sys = mod(round(G), 2); 
    m = n - k;
    P = G_sys(:, 1:m);
    I_m = eye(m);
    H = [I_m, P'];
end

% 2)

function S = tablaSindromes(H)

    n = size(H,2);
    r = size(H,1);

    % fila 1 -> sin error
    S = zeros(n+1,r);

    % filas siguientes -> columnas de H
    for i = 1:n
        S(i+1,:) = H(:,i)';
    end

end

% 3) %% Acá hay un tema, nuestra matriz G de Hamming que nos dan, en teoria
% dado los parametros del punto 5), no puede corregir errores

function palabraCorregida = corregirPalabra(H,S,palabra)

    % Calcular síndrome
    sindrome = mod(H * palabra',2)';

    palabraCorregida = palabra;

    % Si es cero no hay error
    if all(sindrome==0)
        return;
    end

    % Buscar síndrome en la tabla
    for i=2:size(S,1)

        if isequal(S(i,:),sindrome)

            posicionError = i-1;

            palabraCorregida(posicionError) = ...
                mod(palabraCorregida(posicionError)+1,2);

            return;

        end

    end

    warning('Error no corregible.');

end

%4) Idem con 3), 

function bitsDecodificados = decodificar_Hamming_bloque(H,S,bloque,n,k)
    %cantidadPalabras = floor(length(bits)/n);
    %bitsDecodificados = size(cantidadPalabras);
   % for i = 1:cantidadPalabras
    %    inicio = (i-1)*n + 1;
     %   fin = i*n;
        palabra = bloque;
        palabraCorregida = corregirPalabra(H,S,palabra);
        mensaje = palabraCorregida(n-k + 1:end);
        bitsDecodificados = mensaje;
    %end
end

% 5) %% 100% que esto esta bien

function [dmin,e,t] = calcularParametrosCodigo(G)
    k = size(G,1);
    dmin = inf;
    % Generar todos los mensajes posibles
    for i = 1:(2^k-1)
        mensaje = de2bi(i,k,'left-msb');
        codigo = mod(mensaje*G,2);
        peso = sum(codigo);
        if peso < dmin
            dmin = peso;
        end
    end
    e = dmin - 1;
    t = floor((dmin-1)/2);
end


