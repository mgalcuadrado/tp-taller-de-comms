%% Receptor
function [arreglo_salida, dmin, e, t, Pe] = decod_canal(arreglo, k, n, G, comparar_simbolos, arreglo_salida_cod_canal)
    size_salida = int32(k * (ceil(size(arreglo, 2)) / n));
    arreglo_salida = zeros(1, size_salida);
    indice_original = 1;
    indice_nuevo = 1;
    H = matrizParidad(G, n, k);
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
    P = G_sys(:, 1:m);
    I_m = eye(m);
    H = [I_m, P'];
end

% 2)

function hash_sindromes = tablaSindromes(H)
    n = size(H,2);
    r = size(H,1);
    cantidad_combinaciones = 2^r;
    % Se crea un mapa hash para buscar síndromes y guardar su patrón de error
    % de menor peso
    hash_sindromes = containers.Map('KeyType', 'char', 'ValueType', 'any');
    for i = 0:cantidad_combinaciones-1
       clave_sindrome = dec2bin(i, r); % Genera '0000', '0001', ..., '1111'
       hash_sindromes(clave_sindrome) = ones(1, n); % Patrón de error inicial (peso máximo)
    end
    for i= 0: (2^n)-1
        e = dec2bin(i, n) - '0';
        sindrome = mod(e*H', 2);
        clave = sprintf('%d', sindrome);
        if peso_palabra(hash_sindromes(clave)) > peso_palabra(e)
            hash_sindromes(clave) = e;
        end
    end
   
end

function peso = peso_palabra(palabra)
    peso = 0;
    for i = 1:length(palabra)
        peso = peso + palabra(i);
    end
end
   

% 3)

function [palabraCorregida, flag] = corregirPalabra(H,S,palabra)
    flag = false; 
    % Primero se calcula el síndrome
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

end

%4)

function [bitsDecodificados, flag] = decodificar_Hamming_bloque(H,S,bloque,n,k)
    palabra = bloque;
    [palabraCorregida, flag] = corregirPalabra(H,S,palabra);
    mensaje = palabraCorregida(n-k + 1:end);
    bitsDecodificados = mensaje;
end

% 5)

function [dmin,e,t] = calcularParametrosCodigo(G)
    k = size(G,1);
    dmin = inf;
    % Se generan todos los mensajes posibles
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
        % Se rellena con ceros (ZeroPadding) cuando faltann bits para
        % completar si fin > máximo del arreglo a analizar
        arreglo_recortado(1, 1:(size(arreglo, 2) - inicio + 1)) = arreglo(inicio:end);
        return
    end
    arreglo_recortado = arreglo(inicio:fin);
end


%% función auxiliar: codificación de Hamming para una palabra (para cálculo de Pe)
function bloque_codificado = codificacion_Hamming_bloque(bloque, k, n, G)
   bloque_codificado = mod(G' * bloque', 2)';
end


%% función auxiliar: impresión hash para armado tabla de síndromes
function imprimir_hash_claves_m(hash_sindromes, m)
    fprintf("INICIO DE IMPRESIÓN DEL HASH DE LA TABLA DE SÍNDROMES S\n");
    for i=0:2^m-1
        clave_sindrome = dec2bin(i, m)
        if isKey(hash_sindromes, clave_sindrome)
            hash_sindromes(clave_sindrome)
        else
            fprintf("No hay patrón de error asignado al síndrome\n")
        end
    end
    fprintf("FIN DE IMPRESIÓN DEL HASH DE LA TABLA DE SÍNDROMES S\n");
end

