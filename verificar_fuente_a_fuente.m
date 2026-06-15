function verificar_fuente_a_fuente(nombre_archivo_in, nombre_archivo_out)

    txt1 = strtrim(fileread(nombre_archivo_in));
    txt2 = strtrim(fileread(nombre_archivo_out));

    if isequal(txt1, txt2)
        fprintf('Los archivos son iguales.\n');
    else
        fprintf('Los archivos son diferentes.\n');
    end

end