function [arreglo_codificado, dict, cantidad_caracteres_distintos, longitud_minima, longitud_promedio, eficiencia] = cod_fuente(nombre_archivo_in_codificacion)
    % CODIFICACIÓN DE FUENTE

    nombre_archivo_out_codificacion = "salida_codificacion.txt";
    archivo = abrir_archivo_lectura(nombre_archivo_in_codificacion);

    %Se obtienen los distintos caracteres con su probabilidad de ocurrencia y
    %La cantidad de caracteres distintos de la fuente
    [caracteres, probabilidades, cantidad_caracteres_distintos, cantidad_caracteres_totales] = leer_archivo(archivo);

    %Verificación de la suma de las probabilidades
    verificacion_suma(probabilidades);

    %Se calcula la entropía de la fuente
    entropia = calcular_entropia_fuente(probabilidades);

    %Se arma el diccionario de Huffman y se buscan las longitudes mínima y
    %promedio
    disp('Armando el diccionario de Huffman...')
    [dict, avglen] = huffmandict(caracteres, probabilidades / sum(probabilidades));

    disp('Buscando las longitudes mínima y promedio...');
    longitud_minima = entropia / log2(2); % = entropia
    longitud_promedio = avglen;
    eficiencia = entropia / avglen;

    %Se codifica el archivo en función del diccionario armado
    arreglo_codificado = codificar_archivo(nombre_archivo_in_codificacion, nombre_archivo_out_codificacion, dict, cantidad_caracteres_distintos, cantidad_caracteres_totales, avglen);
end
%% FUNCIONES DE CODIFICACIÓN DE FUENTE 

function archivo = abrir_archivo_lectura(nombre_archivo)
    disp('Abriendo archivo...')
    archivo = fopen(nombre_archivo, 'r');
    if archivo == -1
        error("No se pudo abrir el archivo")
    end
end

function [caracteres, probabilidades, cantidad_caracteres_distintos, cantidad_caracteres_totales] = leer_archivo(archivo)
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
                amount_apariciones(i) = cantidad_apariciones(i) + 1;
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
    cantidad_caracteres_distintos =  cantidad_caracteres_distintos + 1;
    caracteres(cantidad_caracteres_distintos) = char(0);
    cantidad_caracteres_totales = cantidad_caracteres_totales + 1;
    cantidad_apariciones(cantidad_caracteres_distintos) = 1;
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

function salida_codificacion = codificar_archivo(nombre_archivo_entrada, nombre_archivo_salida, diccionario, cant_distintos, cant_totales, avglen)
    % Se agrega en una suerte de "header" al arreglo indicando una cantidad
    % impar de veces (se elije 3, quizás con más ruido haya que hacerlo 5,
    % lo vemos) la cantidad total de caracteres de entrada del archivo. 
    cant_totales_64 = uint64(cant_totales);
    cant_totales_en_bits = dec2bin(cant_totales_64, 64);
    arreglo_bits_cabecera = cant_totales_en_bits - '0';
    header_repetido = repmat(arreglo_bits_cabecera, 1, 3); %3 es la cantidad de veces que se repite
    %
    salida_codificacion= zeros(1,length(header_repetido) + cant_totales * ceil(avglen));
    salida_codificacion(1, 1:length(header_repetido)) = header_repetido;
    indice = length(header_repetido) + 1;
    archivo_entrada = abrir_archivo_lectura(nombre_archivo_entrada);
    archivo_salida = fopen(nombre_archivo_salida, 'w'); 
    % Creo un mapa hash para buscar en el diccionario
    claves = cell2mat(diccionario(:, 1));
    codigos = diccionario(:, 2);
    mapaHuffman = containers.Map(uint8(claves), codigos);
    
    caracter = fread(archivo_entrada, 1, '*char');
    
    
    while caracter ~= char(0)

        int_char = uint8(caracter);
        
        % checkeo si el carácter existe en el mapa, y si no existe lo añado
        if isKey(mapaHuffman, int_char)
            codigoBinario = mapaHuffman(int_char);
            largoCodigo = length(codigoBinario);
            
            if indice + largoCodigo > length(salida_codificacion)
                fprintf("Redimensión del arreglo de codificación de fuente\n");
                salida_codificacion = [salida_codificacion, zeros(1, 3* length(salida_codificacion))];
            end
            
            salida_codificacion(indice: (indice - 1 + largoCodigo)) = codigoBinario;
            palabra = sprintf('%d', codigoBinario);
            fwrite(archivo_salida, palabra, 'char');
            
            caracter = fread(archivo_entrada, 1, '*char');
            indice = indice + largoCodigo;
        else
            % Por si lee un carácter que por algún motivo no quedó registrado
            caracter = fread(archivo_entrada, 1, '*char');
        end
    end
    
    % if indice + length(diccionario{cant_distintos, 2}) > length(salida_codificacion)
    %     fprintf("Redimensión del arreglo de codificación de fuente para el end of file\n");
    %     salida_codificacion = [salida_codificacion, zeros(1, length(diccionario{cant_distintos, 2}))];
    % end
    % salida_codificacion(indice: (indice - 1 + length(diccionario{cant_distintos, 2}))) = diccionario{cant_distintos, 2};
    % indice = indice + length(diccionario{cant_distintos, 2});
    if indice > length(salida_codificacion)
        salida_codificacion = salida_codificacion(1:indice + 1);
    end
    %if mod(length(salida_codificacion), 12) ~= 0
    %    salida_codificacion = [salida_codificacion, zeros(1, 12 - mod(length(salida_codificacion)))]; %acá chequear este límite para la modulación 
    %end
    fwrite(archivo_salida, char(0), 'char');
    disp('Cerrando archivos...')
    fclose(archivo_salida);
    fclose(archivo_entrada);
end
