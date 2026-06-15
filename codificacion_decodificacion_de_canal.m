

entrada_codificacion = "salida_codificacion.txt";
salida_decodificacion = "salida_decodificacion_canal.txt";

salida_codificacion_canal = "salida_codificacion_canal.txt";

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

%% PASO EXTRA PORQUE TODAVÍA NO ESTAMOS TRABAJANDO EN LOS MÓDULOS: 
% VOY A LEVANTAR LA SALIDA DE LA FUENTE Y METERLA EN UN ARREGLO PARA 
% DESPUÉS PASARNOS EL ARREGLO ENTRE BLOQUES DIRECTAMENTE
arreglo_ejemplo = archivo_a_arreglo(entrada_codificacion);
arreglo_prueba = [1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0,0, 0, 0, 1]
arreglo_salida_codif_canal = codificacion_Hamming_completa(arreglo_ejemplo, k, n, G)
arreglo_a_archivo(arreglo_salida_codif_canal, salida_codificacion_canal)
arreglo_salida_decodif_canal = decodificacion_Hamming_completa(arreglo_salida_codif_canal, k, n, G)
arreglo_a_archivo(arreglo_salida_decodif_canal, salida_decodificacion)


function arreglo_salida = codificacion_Hamming_completa(arreglo, k, n, G)
    suma_extra = 0;
    if mod(size(arreglo, 2), k)~= 0 
        suma_extra = n;
    end
    size_salida = int32(suma_extra + n * ceil(size(arreglo, 2) / k)); %acá chequear en función de qué hacemos con el último bloque que va a quedar incompleto
    arreglo_salida = zeros(1, size_salida); 
    indice_original = 1;
    indice_nuevo = 1;
    while indice_original <= size(arreglo, 2)
        bloque_actual = parsear_arreglo(arreglo, indice_original, indice_original + k - 1);
        arreglo_salida(1, indice_nuevo:indice_nuevo + n - 1) = codificacion_Hamming_bloque(bloque_actual, k, n, G);
        indice_original = indice_original + k;
        indice_nuevo = indice_nuevo + n;
    end
end


%codificacion_Hamming_bloque recibe un arreglo bloque de k elementos (es decir, k
%bits) y por medio de la matriz G devuelve un bloque_codificado de n bits
function bloque_codificado = codificacion_Hamming_bloque(bloque, k, n, G)
   bloque_codificado = mod(G' * bloque', 2)';
end

function salida_codificacion = archivo_a_arreglo(nombre_archivo_entrada)
    archivo_entrada = fopen(nombre_archivo_entrada, 'r');
    if archivo_entrada == -1
      error('No se pudo abrir el archivo');
    end
    caracteres = fread(archivo_entrada, Inf, '*char')';
    fclose(archivo_entrada);
    salida_codificacion = double(caracteres) - double('0');
end

function arreglo_a_archivo(arreglo, nombre_archivo_salida)
    archivo_salida = fopen(nombre_archivo_salida, 'w');
    if archivo_salida == -1
      error('No se puedo abrir el archivo');
    end
    fprintf(archivo_salida, '%d', arreglo);
    fclose(archivo_salida);
end

%function arreglo_recortado = parsear_arreglo(arreglo, inicio, fin)
   % if size(arreglo, 2) <= fin
    %    arreglo_recortado = zeros(1, (fin - inicio) + 1); %% Se prearma un vector de 15 elementos para que pueda multiplicarse con la matriz generadora // Largo 11 para eso
%
 %       arreglo_recortado(1, 1:(size(arreglo, 2) - inicio + 1)) = arreglo(inicio:size(arreglo, 2));
  %      return
   % end
    %arreglo_recortado = arreglo(inicio:fin);
   % return
%end

function arreglo_recortado = parsear_arreglo(arreglo, inicio, fin)
    % CORRECCIÓN: Cambiado a < para detectar correctamente bloques incompletos
    if size(arreglo, 2) < fin
        arreglo_recortado = zeros(1, (fin - inicio) + 1); 
        % Rellena con ceros (Padding) lo que falte
        arreglo_recortado(1, 1:(size(arreglo, 2) - inicio + 1)) = arreglo(inicio:end);
        return
    end
    arreglo_recortado = arreglo(inicio:fin);
end

%% Receptor
function arreglo_salida = decodificacion_Hamming_completa(arreglo, k, n, G)
    size_salida = int32(k * ceil(size(arreglo, 2) / n))
    tam_arreglo_original = size(arreglo, 2)
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
        indice_nuevo = indice_nuevo + k
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
        palabra = bloque
        palabraCorregida = corregirPalabra(H,S,palabra);
        mensaje = palabraCorregida(n-k + 1:end);
        bitsDecodificados = mensaje
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


