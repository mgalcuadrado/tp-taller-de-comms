
function nombre_archivo_salida = decod_fuente(arreglo_entrada, nombre_archivo_salida, diccionario, cant_distintos)
    disp('Decodificando el archivo usando el diccionario de Huffman')
    archivo_salida = fopen(nombre_archivo_salida, 'w');
    indice = 1;
    % simbolo_codificado es una variable para ir guardando la "cadena" de símbolos sin encontrar para poder compararla con
    % diccionario de Huffman
    simbolo_codificado = '';
    while indice <= size(arreglo_entrada, 2)
       caracter = int2str(arreglo_entrada(indice));
       simbolo_codificado = [simbolo_codificado, caracter];
       posicion_en_dic = 0;
        for i= 1:cant_distintos
            dict_char = sprintf('%d', diccionario{i,2}); %Columna 1 valor original, columna 2 valor original codificado
            if strcmp(dict_char, simbolo_codificado)
                posicion_en_dic = i;
            end
            if posicion_en_dic ~= 0
                %Se encontró match en el diccionario de Huffman para el
                %símbolo actual
                palabra = sprintf('%c', diccionario{posicion_en_dic, 1});
                fwrite(archivo_salida, palabra, 'char');
                simbolo_codificado = '';
                posicion_en_dic = 0;
            end
        end
        indice = indice + 1;
    end

    disp('Cerrando archivos...')
    fclose(archivo_salida); 

end



function verificar_archivos()

    txt1 = strtrim(fileread('entrada.txt'));
    txt2 = strtrim(fileread('salida_decodificacion.txt'));

    if isequal(txt1, txt2)
        fprintf('Los archivos son iguales.\n');
    else
        fprintf('Los archivos son diferentes.\n');
    end

end
