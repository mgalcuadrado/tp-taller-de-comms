clear;

%abrir_archivo(ruta);
%char[], proba[] lectura_archivo(archivo);
%float calcular_entropia_fuente(proba[]);
%dict huffmandict();
%float longitud_minima(dict);
%float longitud_promedio(dict);
%palabras[] codificar(archivo, dict);
nombre_archivo = "hola.txt";

disp('Abriendo archivo...')
archivo = fopen(nombre_archivo, 'r');
if archivo == -1
    error("No se pudo abrir el archivo")
end

disp('Leyendo el archivo...')

[caracteres, cantidad_apariciones] = leer_archivo(archivo)
function [caracteres, cantidad_apariciones] = leer_archivo(archivo)
    cantidad_caracteres_distintos = 0;
    cantidad_caracteres_totales = 0;
    caracteres = 0;
    cantidad_apariciones = 0;
    caracter = fread(archivo, 1, '*char')
    while caracter ~= char(0)
       % caracter = fread(archivo, 1, '*char')
        caracter_in_caracteres = false;
        for i=1:cantidad_caracteres_distintos
            if caracter == caracteres(i)
                cantidad_apariciones(i) = cantidad_apariciones(i) + 1
                caracter_in_caracteres = true;
            end
        end 
        if not (caracter_in_caracteres)
            cantidad_caracteres_distintos = cantidad_caracteres_distintos + 1
            caracteres(cantidad_caracteres_distintos) = caracter
            cantidad_apariciones(cantidad_caracteres_distintos) = 1
        end
        cantidad_caracteres_totales = cantidad_caracteres_totales + 1
    caracter = fread(archivo, 1, '*char')
    end
end


