function arreglo = archivo_a_arreglo(nombre_archivo_entrada)
    archivo_entrada = fopen(nombre_archivo_entrada, 'r');
    if archivo_entrada == -1
      error('No se pudo abrir el archivo');
    end
    caracteres = fread(archivo_entrada, Inf, '*char')';
    fclose(archivo_entrada);
    arreglo = double(caracteres) - double('0');
end