
%codificador_canal devuelve un arreglo columna de ceros y unos que genera
%tomando mensajes de k bits del arreglo original arreglo y pasándolos por
%la matriz generadora G para codificarlos en palabras de n bits. 
function arreglo_salida = cod_canal(arreglo, k, n, G)
    suma_extra = 0;
    if mod(size(arreglo, 2), k)~= 0 
        suma_extra = n;
    end
    size_salida = int32(suma_extra + n * ceil(size(arreglo, 2) / k)); %acá chequear en función de qué hacemos con el último bloque que va a quedar incompleto
    suma_extra = mod(size_salida, 12);
    size_salida = size_salida + (12-suma_extra);
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

%parsear_arreglo devuelve un arreglo_recortado que consiste en los
%elementos de inicio a fin inclusive de arreglo; es decir,
%arreglo(inicio:fin). Si el fin es mayor a la cantidad de elementos del
%arreglo original, completa lo faltante con ceros. 
function arreglo_recortado = parsear_arreglo(arreglo, inicio, fin)
    if size(arreglo, 2) < fin
        arreglo_recortado = zeros(1, (fin - inicio) + 1); 
        % Rellena con ceros (ZeroPadding) lo que queda incompleto
        arreglo_recortado(1, 1:(size(arreglo, 2) - inicio + 1)) = arreglo(inicio:end);
        return
    end
    arreglo_recortado = arreglo(inicio:fin);
end

