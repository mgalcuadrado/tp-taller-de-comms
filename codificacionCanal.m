%% Codficación de Canal

%% Nuestros Datos
n = 15; 
k = 11;

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
%% Prueba de Trasmision

 mensaje = [1 0 1 1 1 0 1 1 1 0 1];

 codigo = codificarMensaje(mensaje,G);

 bits = [1 0 1 1 0 1 0 0 1 1 0 1 1 0 1 1];

 codigo2 = codificarCanal(bits, G);
 

%%
H = matrizParidad(G, n, k);
 
S = tablaSindromes(H);

% Verificación matemática: G * H' en módulo 2 debe ser una matriz de ceros
verificacion = mod(G * H', 2); % mod(, 2) para simular una operación XOR ya que Hamming opera en binario

if all(verificacion(:) == 0) 

    fprintf('Verificación exitosa: G * H^T = 0 (mod 2)\n');
else
    fprintf('Error en el cálculo de la matriz.\n');
end

%%
palabra = corregirPalabra(H, S, codigo);


%%
codigo = [1 1 0 1 0 0 1 0 1 1 0 1 1 0 1 0 1 0 1 1 1 1];
bitsInfo = decodificarCanal(H,S,codigo,n,k);

%%

[dmin, errores_det, errores_a_corregir] = calcularParametrosCodigo(G);
fprintf('La distancia minima es %d, la cantidad maxima de errores a detectar es %d y a corregir %d.', dmin, errores_det, errores_a_corregir);
%% Transmisión
% 1)
function codigo = codificarMensaje(mensaje, G)

    % Verificar dimensiones
    k = size(G,1);

    if length(mensaje) ~= k
        error('El mensaje debe contener %d bits.', k);
    end

    % Codificación lineal
    
    codigo = mod(mensaje * G, 2);

end

% 2)

function bitsCodificados = codificarCanal(bitsEntrada, G)

    k = size(G,1);
    n = size(G,2);

    % Cantidad de ceros a agregar
    resto = mod(length(bitsEntrada), k);

    if resto ~= 0
        bitsEntrada = [bitsEntrada zeros(1, k-resto)];
    end

    cantidadBloques = length(bitsEntrada)/k;

    bitsCodificados = zeros(1, cantidadBloques*n);

    indiceSalida = 1;

    for i = 1:cantidadBloques

        inicio = (i-1)*k + 1;
        fin = i*k;

        mensaje = bitsEntrada(inicio:fin);

        palabraCodigo = codificarMensaje(mensaje,G);

        bitsCodificados(indiceSalida:indiceSalida+n-1) = palabraCodigo;

        indiceSalida = indiceSalida + n;

    end

end

%% Receptor

% 1)

function H = matrizParidad(G, n, k)
    [G_rref, ~] = rref(G);
    G_sys = mod(round(G_rref), 2); % Convertir a enteros y aplicar módulo 2 / XOR
    P = G_sys(:, k+1:end);
    m = n - k;
    I_m = eye(m);
    H = [P', I_m];
end

% 2)

function S = tablaSindromes(H)

    n = size(H,2);
    r = size(H,1);

    % fila 1 -> sin error
    S = zeros(n+1,r);

    % filas siguientes -> columnas de H
    for i = 1:n
        S(i+1,:) = H(:,i)';
    end

end

% 3) %% Acá hay un tema, nuestra matriz G de Hamming que nos dan, en teoria
% dado los parametros del punto 5), no puede corregir errores

function palabraCorregida = corregirPalabra(H,S,palabra)

    % Calcular síndrome
    sindrome = mod(H * palabra',2)';

    palabraCorregida = palabra;

    % Si es cero no hay error
    if all(sindrome==0)
        return;
    end

    % Buscar síndrome en la tabla
    for i=2:size(S,1)

        if isequal(S(i,:),sindrome)

            posicionError = i-1;

            palabraCorregida(posicionError) = ...
                mod(palabraCorregida(posicionError)+1,2);

            return;

        end

    end

    warning('Error no corregible.');

end

%4) Idem con 3), 

function bitsDecodificados = decodificarCanal(H,S,bits,n,k)

    cantidadPalabras = floor(length(bits)/n);

    bitsDecodificados = size(cantidadPalabras);

    for i = 1:cantidadPalabras

        inicio = (i-1)*n + 1;
        fin = i*n;

        palabra = bits(inicio:fin);

        palabraCorregida = corregirPalabra(H,S,palabra);

        mensaje = palabraCorregida(1:k);

        bitsDecodificados = [bitsDecodificados mensaje];

    end

end

% 5) %% 100% que esto esta bien

function [dmin,e,t] = calcularParametrosCodigo(G)

    k = size(G,1);

    dmin = inf;

    % Generar todos los mensajes posibles
    for i = 1:(2^k-1)

        mensaje = de2bi(i,k,'left-msb');

        codigo = mod(mensaje*G,2);

        peso = sum(codigo);

        if peso < dmin
            dmin = peso;
        end

    end

    e = dmin - 1;

    t = floor((dmin-1)/2);

end