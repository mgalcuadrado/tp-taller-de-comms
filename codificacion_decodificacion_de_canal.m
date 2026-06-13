%% PASO EXTRA PORQUE TODAVÍA NO ESTAMOS TRABAJANDO EN LOS MÓDULOS: 
% VOY A LEVANTAR LA SALIDA DE LA FUENTE Y METERLA EN UN ARREGLO PARA 
% DESPUÉS PASARNOS EL ARREGLO ENTRE BLOQUES DIRECTAMENTE

entrada_codificacion = "salida_codificacion.txt";
entrada_decodificacion = "salida_canal.txt";

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

arreglo = archivo_bits_a_arreglo(entrada_codificacion);

arreglo_salida = codificacion_Hamming_completa(arreglo, k, n, G)

function arreglo_salida = codificacion_Hamming_completa(arreglo, k, n, G)
    size_salida = int32(15 + 15 * length(arreglo) / 11); %acá chequear en función de qué hacemos con el último bloque que va a quedar incompleto
    arreglo_salida = zeros(1, size_salida);
    indice_original = 1;
    indice_nuevo = 1;
    while indice_nuevo <= size_salida
        bloque_actual = parsear_arreglo(arreglo, indice_original, indice_original + k - 1);
        arreglo_salida(indice_nuevo, indice_nuevo + n - 1) = codificacion_Hamming_bloque(bloque_actual, k, n, G); 
        %este límite de indice_nuevo + n se podría pasar con un criterio distinto para el último bloque
        indice_original = indice_original + k - 1;
        indice_nuevo = indice_nuevo + n - 1;
    end
end

%codificacion_Hamming_bloque recibe un arreglo bloque de k elementos (es decir, k
%bits) y por medio de la matriz G devuelve un bloque_codificado de n bits
function bloque_codificado = codificacion_Hamming_bloque(bloque, k, n, G)
    bloque_codificado = zeros(1, n-1);
    if length(bloque) ~= k-1
        bloque_codificado(1:length(bloque)) = bloque;
        %error ('Ayuda?'); %esto es momentáneo hasta que vea qué dejar
    end
    length(bloque)
    bloque_codificado = bloque * G;
end

function salida_codificacion = archivo_bits_a_arreglo(nombre_archivo_entrada)
    salida_codificacion = [];
    archivo_entrada = fopen(nombre_archivo_entrada, 'r');
    if archivo_entrada == -1
      error('No se puedo abrir el archivo');
    end
    salida_codificacion = fread(archivo_entrada, Inf, 'bit1')';
    fclose(archivo_entrada);
end


function arreglo_recortado = parsear_arreglo(arreglo, inicio, fin)
    if length(arreglo) <= fin
        arreglo_recortado = arreglo(inicio, length(arreglo))
    end
    arreglo_recortado = arreglo(inicio:fin)
end


