function prueba_decod_cod_canal(entrada_arreglo)
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

    arreglo_codificado = cod_canal(entrada_arreglo, k, n, G);

    arreglo_decodificado = decod_canal(arreglo_codificado, k, n, G);

    indice = 1;
    while indice <= size(entrada_arreglo,2)
          if entrada_arreglo(1,indice) ~= arreglo_decodificado(1, indice)
              error("Error en la verificación de ")
          end
       indice = indice + 1;
    end
end