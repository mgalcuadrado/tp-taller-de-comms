function nombre_archivo_salida = decod_fuente(arreglo_entrada, nombre_archivo_salida, diccionario, cant_distintos)
    disp('Decodificando el archivo usando el diccionario de Huffman')
    archivo_salida = fopen(nombre_archivo_salida, 'w');
    indice = 1;
    % simbolo_codificado es una variable para ir guardando la "cadena" de símbolos sin encontrar para poder compararla con
    % diccionario de Huffman
    simbolo_codificado = '';
    
%Hago el mapa inverso
    clavesCodigo = cell(cant_distintos, 1);
    valoresChar = cell(cant_distintos, 1);
    for i = 1:cant_distintos
        % Guardo el codigo binario como string
        clavesCodigo{i} = sprintf('%d', diccionario{i,2});
        % Guardo el carácter original
        valoresChar{i} = diccionario{i,1};
    end
    mapaDecodificacion = containers.Map(clavesCodigo, valoresChar);

    while indice <= size(arreglo_entrada, 2)
       caracter = int2str(arreglo_entrada(indice));
       simbolo_codificado = [simbolo_codificado, caracter];
       
       % Reviso si la cadena existe en el mapa
       if isKey(mapaDecodificacion, simbolo_codificado)
           %Se encontró match en el diccionario de Huffman para el
           %símbolo actual
            char_encontrado = mapaDecodificacion(simbolo_codificado);
            
            if char_encontrado == char(0) %se llegó al final del archivo original
                break;
            end 
            
            palabra = sprintf('%c', char_encontrado);
            fwrite(archivo_salida, palabra, 'char');
            simbolo_codificado = '';
            
       % Si tengo una cadena invalida
       elseif length(simbolo_codificado) > cant_distintos
            fwrite(archivo_salida, '?', 'char'); 
            
            % Reseteo la cadena para intentar volver a sincronizar con los nuevos bits
            simbolo_codificado = ''; 
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
