[k,n,G, ~] = parametros();
H = matrizParidad(G, n, k); 
hash = tabla_sindromes_completa(H);
imprimir_hash_claves_m(hash, n-k);

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

function H = matrizParidad(G, n, k)
    G_sys = mod(round(G), 2); 
    m = n - k;
    P = G_sys(:, 1:m)
    I_m = eye(m)
    H = [I_m, P'];
end





%%% esta era la forma que se esperaba para el cálculo de la tabla de
%%% síndromes, pero como tenemos solo errores con patrones de 1 y 2 bits
%%% resulta más eficiente la implementación realizada previamente. Por
%%% completitud, se incluye:

function hash_sindromes = tabla_sindromes_completa(H)
    n = size(H,2);
    r = size(H,1);
    cantidad_combinaciones = 2^r;
    % Creo un mapa hash para buscar síndromes y guardar su patrón de error
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