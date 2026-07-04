clc;clear all;close all;
%% EJEMPLO DE CORRECIÓN DE ERROR
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

arreglo_prueba = [1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0]

arreglo_salida = cod_canal(arreglo_prueba, k,n,G)

% salida de deco = [1     0     0     1     1     0     1     1     0     0
% 1     1     0     1     0]

arreglo_con_e = [ 1     0     0     1    1     0     1     1     0     0     1     1     0     1     1] %Se introduce un error en el bit 15 codificado
fprintf("El sindrome asociado y el patron de error estimado son:")
arreglo_corregido = decod_canal(arreglo_con_e, k, n, G, true,arreglo_salida)
