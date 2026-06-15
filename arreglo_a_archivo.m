function arreglo_a_archivo(arreglo, nombre_archivo_salida)
    archivo_salida = fopen(nombre_archivo_salida, 'w');
    if archivo_salida == -1
      error('No se puedo abrir el archivo');
    end
    fprintf(archivo_salida, '%d', arreglo);
    fclose(archivo_salida);
end