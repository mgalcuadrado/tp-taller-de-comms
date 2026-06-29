%% Receptor
function [arreglo_salida, dmin, e, t, Pe] = decod_canal(arreglo, k, n, G, comparar_simbolos, arreglo_salida_cod_canal)
    extra = 0;
    % if mod(ceil(size(arreglo, 2)), n) ~= 0
    %     extra = n - mod(ceil(size(arreglo, 2)), n);
    % end
    size_salida = int32(k * (ceil(size(arreglo, 2)+extra) / n));
    arreglo_salida = zeros(1, size_salida);
    indice_original = 1;
    indice_nuevo = 1;
    H = matrizParidad(G, n, k)
    S = tablaSindromes(H);
    imprimir_hash_claves_m(S, n-k)
    Pe = 0; 
    if comparar_simbolos  
        contador_errores = 0; 
        contador_bloques = 0;
    end
    while indice_nuevo < size_salida 
        bloque_actual = parsear_arreglo(arreglo, indice_original, indice_original + n - 1);
        [arreglo_salida(1, indice_nuevo:indice_nuevo + k - 1), flag] = decodificar_Hamming_bloque(H, S, bloque_actual, n, k); 
        if comparar_simbolos
           bloque_original = parsear_arreglo(arreglo_salida_cod_canal, indice_original, indice_original + n - 1);
           if flag
                   contador_errores = contador_errores + 1; 
           elseif bloque_original ~= codificacion_Hamming_bloque(arreglo_salida(1, indice_nuevo:indice_nuevo + k - 1), k, n, G);
                   contador_errores = contador_errores + 1; 
           end
           contador_bloques = contador_bloques + 1;
         end    
        indice_original = indice_original + n;
        indice_nuevo = indice_nuevo + k;
    end
    [dmin, e, t] = calcularParametrosCodigo(G);
    if comparar_simbolos
        Pe = contador_errores / contador_bloques; 
    end
end


% 1)

function H = matrizParidad(G, n, k)
    G_sys = mod(round(G), 2); 
    m = n - k;
    P = G_sys(:, 1:m)
    I_m = eye(m)
    H = [I_m, P'];
end

% 2)

function hash_sindromes = tablaSindromes(H)

    n = size(H,2)
    r = size(H,1)
    cantidad_combinaciones = 2^r
    % Creo un mapa hash para buscar síndromes y guardar su patrón de error
    % de menor peso
    cantidad_sindromes = 0; 
    hash_sindromes = containers.Map('KeyType', 'char', 'ValueType', 'any');
     % fila 1 -> sin error o error no detectabl
    e = zeros(1,n);
    sindrome = e*H';
    clave = sprintf('%d', sindrome)
    if ~isKey(hash_sindromes, clave)
        hash_sindromes(clave) = e;
        cantidad_sindromes = cantidad_sindromes + 1;
    end
    for i = 0:n-1
        e = zeros(1, n);
        e(n-i) = 1;
        sindrome = mod(e*H',2);
        clave = sprintf('%d', sindrome)
        if ~isKey(hash_sindromes, clave)
            hash_sindromes(clave) = e;
            cantidad_sindromes = cantidad_sindromes + 1;
        end
    end
    for i = 0:n-1
        if cantidad_sindromes >= cantidad_combinaciones
            break;
        end 
        for j = 0:n-1
            e = zeros(1, n);
            e(n-i) = 1;
            e(n-j) = 1;
            sindrome = mod(e*H',2);
            clave = sprintf('%d', sindrome)
            if ~isKey(hash_sindromes, clave)
                hash_sindromes(clave) = e;
                cantidad_sindromes = cantidad_sindromes + 1;
            end
        end
        
    end
end

% 3) %% Acá hay un tema, nuestra matriz G de Hamming que nos dan, en teoria
% dado los parametros del punto 5), no puede corregir errores

function [palabraCorregida, flag] = corregirPalabra(H,S,palabra)
    flag = false; 
    % Calcular síndrome
    sindrome = mod(H * palabra',2)';
    clave = sprintf('%d', sindrome);
    palabraCorregida = palabra;

    % Si es cero no hay error, o el error no es detectable
    if all(sindrome==0)
        return;
    end

    palabra_error = S(clave);
    palabraCorregida = mod(palabra + palabra_error, 2);
    flag = true;
    %warning('Error no corregible.');

end

%4) Idem con 3), 

function [bitsDecodificados, flag] = decodificar_Hamming_bloque(H,S,bloque,n,k)
    %cantidadPalabras = floor(length(bits)/n);
    %bitsDecodificados = size(cantidadPalabras);
   % for i = 1:cantidadPalabras
    %    inicio = (i-1)*n + 1;
     %   fin = i*n;
        palabra = bloque;
        [palabraCorregida, flag] = corregirPalabra(H,S,palabra);
        mensaje = palabraCorregida(n-k + 1:end);
        bitsDecodificados = mensaje;
    %end
end

% 5) %% 100% que esto esta bien

function [dmin,e,t] = calcularParametrosCodigo(G)
    k = size(G,1);
    dmin = inf;
    % Generar todos los mensajes posibles
    for i = 1:((2^k)-1)
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

function arreglo_recortado = parsear_arreglo(arreglo, inicio, fin)
    if size(arreglo, 2) < fin
        arreglo_recortado = zeros(1, (fin - inicio) + 1); 
        % Rellena con ceros (ZeroPadding) lo que queda incompleto
        arreglo_recortado(1, 1:(size(arreglo, 2) - inicio + 1)) = arreglo(inicio:end);
        return
    end
    arreglo_recortado = arreglo(inicio:fin);
end


%% función auxiliar: codificación de Hamming para una palabra (para cálculo de Pe)
function bloque_codificado = codificacion_Hamming_bloque(bloque, k, n, G)
   bloque_codificado = mod(G' * bloque', 2)';
end


%%auxiliar: impresión hash para armado tabla de síndromes
function imprimir_hash_claves_m(hash_sindromes, m)
    for i=0:2^m-1
        clave_sindrome = dec2bin(i, m)
        %clave_sindrome = sprintf('%d', sindrome)
        if isKey(hash_sindromes, clave_sindrome)
            hash_sindromes(clave_sindrome)
        else
            fprintf("No hay patrón de error asignado al síndrome\n")
        end
    end
end


%%% esta era la forma que se esperaba para el cálculo de la tabla de
%%% síndromes, pero como tenemos solo errores con patrones de 1 y 2 bits
%%% resulta más eficiente la implementación realizada previamente. Por
%%% completitud, se incluye:

function hash_sindromes = tabla_sindromes_completa(H)
    n = size(H,2)
    r = size(H,1)
    cantidad_combinaciones = 2^r
    % Creo un mapa hash para buscar síndromes y guardar su patrón de error
    % de menor peso
    hash_sindromes = containers.Map('KeyType', 'char', 'ValueType', 'any');
    for i = 0:cantidad_combinaciones
       clave_sindrome = dec2bin(i, m); % Genera '0000', '0001', ..., '1111'
       hash_sindromes(clave_sindrome) = ones(1, n); % Patrón de error inicial (peso máximo)
    end
    for i= 0: 2^n-1
        e = dec2bin(i, n) - '0'
        sindrome = e*H';
        clave = sprintf('%d', sindrome)
        if peso_palabra(hash_sindromes(clave)) > peso_palabra(e)
            hash_sindromes(clave) = e;
        end
    end
   
end

function peso = peso_palabra(palabra)
    peso = 0;
    for i = 1:length(palabra)
        peso = peso + palabra(i)
    end
end