function [arreglo_codificado, dict, cantidad_caracteres_distintos, longitud_minima, longitud_promedio, eficiencia] = codificacion_fuente(nombre_archivo_in_codificacion)
    % CODIFICACIÓN DE FUENTE

    nombre_archivo_out_codificacion = "salida_codificacion.txt";
    archivo = abrir_archivo_lectura(nombre_archivo_in_codificacion);

    %Se obtienen los distintos caracteres con su probabilidad de ocurrencia y
    %La cantidad de caracteres distintos de la fuente
    [caracteres, probabilidades, cantidad_caracteres_distintos] = leer_archivo(archivo);

    %Verificación de la suma de las probabilidades
    verificacion_suma(probabilidades);

    %Se calcula la entropía de la fuente
    entropia = calcular_entropia_fuente(probabilidades);

    %Se arma el diccionario de Huffman y se buscan las longitudes mínima y
    %promedio
    disp('Armando el diccionario de Huffman...')
    [dict, avglen] = huffmandict(caracteres, probabilidades);

    disp('Buscando las longitudes mínima y promedio...');
    longitud_minima = entropia / log2(2); % = entropia
    longitud_promedio = avglen;
    eficiencia = entropia / avglen;

    %Se codifica el archivo en función del diccionario armado
    arreglo_codificado = codificar_archivo(nombre_archivo_in_codificacion, nombre_archivo_out_codificacion, dict, cantidad_caracteres_distintos);
end

%% FUNCIONES DE CODIFICACIÓN DE FUENTE 

function archivo = abrir_archivo_lectura(nombre_archivo)
    disp('Abriendo archivo...')
    archivo = fopen(nombre_archivo, 'r');
    if archivo == -1
        error("No se pudo abrir el archivo")
    end
end

function [caracteres, probabilidades, cantidad_caracteres_distintos] = leer_archivo(archivo)
    disp('Leyendo el archivo...')
    cantidad_caracteres_distintos = 0;
    cantidad_caracteres_totales = 0;
    caracteres = 0;
    cantidad_apariciones = 0;
    caracter = fread(archivo, 1, '*char');
    while caracter ~= char(0)
       % caracter = fread(archivo, 1, '*char')
        caracter_in_caracteres = false;
        for i=1:cantidad_caracteres_distintos
            if caracter == caracteres(i)
                cantidad_apariciones(i) = cantidad_apariciones(i) + 1;
                caracter_in_caracteres = true;
            end
        end 
        if not (caracter_in_caracteres)
            cantidad_caracteres_distintos = cantidad_caracteres_distintos + 1;
            caracteres(cantidad_caracteres_distintos) = caracter;
            cantidad_apariciones(cantidad_caracteres_distintos) = 1;
        end
        cantidad_caracteres_totales = cantidad_caracteres_totales + 1;
    caracter = fread(archivo, 1, '*char');
    end
    probabilidades = cantidad_apariciones / cantidad_caracteres_totales;
    fclose(archivo);
end

function suma = verificacion_suma(probas)
    suma = 0;
    for i = 1:length(probas)
        suma = suma + probas(i);
    end
end


function entropia = calcular_entropia_fuente(probas)
    disp('Calculando la entropía de la fuente...')
    % entropia = suma (k= 0; n-1) de pk * log2(1/pk)
    entropia = 0;
    for i = 1:length(probas)
        entropia = entropia + probas(i) * log2(1/probas(i));
    end
end

function salida_codificacion = codificar_archivo(nombre_archivo_entrada, nombre_archivo_salida, diccionario, cant_distintos)
    salida_codificacion = [];
    archivo_entrada = abrir_archivo_lectura(nombre_archivo_entrada);
    archivo_salida = fopen(nombre_archivo_salida, 'w');
    caracter = fread(archivo_entrada, 1, '*char');
    while caracter ~= char(0)
        posicion_en_dic = 0;
        for i= 1:cant_distintos
            dict_char = diccionario{i,1}; %columna 1 valor original, columna 2 valor original codificado
            int_char = uint8(caracter);
            if dict_char == int_char
                posicion_en_dic = i;
            end
        end
        %diccionario(posicion_en_dic)
        salida_codificacion = [salida_codificacion, diccionario{posicion_en_dic, 2}];
        palabra = sprintf('%d', diccionario{posicion_en_dic, 2});
        fwrite(archivo_salida, palabra, 'char');
        caracter = fread(archivo_entrada, 1, '*char');
    end
    fwrite(archivo_salida, char(0), 'char');
    disp('Cerrando archivos...')
    fclose(archivo_salida);
    fclose(archivo_entrada);
end
