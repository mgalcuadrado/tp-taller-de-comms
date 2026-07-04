

function [bitsDetectados, simbolosDetectados, SER, BER]=demodulador(entradaOriginal,simbolosOriginales,transmisionRuidosa,entradaM,mapeoTipo,modulacionTipo, constelacion)


    [bitsDetectados, simbolosDetectados] = demodularSimbolos(transmisionRuidosa,entradaM,mapeoTipo,modulacionTipo);
    %disp(entradaM);
    %disp('El error de símbolo se estima en');
    SER = errorSimbolo(simbolosOriginales,simbolosDetectados);
    %disp('El error de bit se estima en:');
    BER = errorBit(entradaOriginal,bitsDetectados);

    % %% Gráfico de las regiones de decision PSK, muestras teoricas y ruidosas
    % colorYellowGreen = [154, 205, 50] / 255;
    % 
    % k=log2(entradaM);
    % if strcmp(modulacionTipo, 'FSK')
    %     msgbox('FSK es M-dimensional. Las regiones de decisión no se pueden graficar en un plano 2D.', 'Aviso FSK');
    % else
    %     figure('Color', 'w'); hold on; grid on; axis equal;
    % 
    %     %lim = max(max(abs(constelacion))) + 1.5; 
    %     lim = 2; %para que todas las imagenes tengan el mismo tamaño
    % 
    %     %Gráfico de los simbolos recibidos
    %     %plot(simbolosCanal(:,1), simbolosCanal(:,2), '.', 'Color', colorYellowGreen, 'MarkerSize', 15);
    %     scatter(transmisionRuidosa(:,1), transmisionRuidosa(:,2),50,colorYellowGreen, 'filled','MarkerFaceAlpha',0.4);
    % 
    %     % Regiones de decisión
    %     ang_sep = 2*pi/entradaM;
    %     for m = 0:entradaM-1
    %         theta = m*ang_sep - ang_sep/2;
    %         line([0 lim*cos(theta)], [0 lim*sin(theta)], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
    %     end
    % 
    %     % Gráfico de los puntos ideales de la constelación
    %     %plot(constelacion(:,1), constelacion(:,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', colorYellowGreen,'MarkerEdgeColor', colorYellowGreen);
    %     scatter(constelacion(:,1), constelacion(:,2),100,colorYellowGreen, 'filled','MarkerFaceAlpha',1,'MarkerEdgeColor', 'b');
    % 
    %     % Dibujo de etiquetas de texto binarias al lado de los puntos ideales
    %     for m = 0:entradaM-1
    %         if strcmpi(mapeoTipo,'gray')
    %             etiqueta = bitxor(m,bitshift(m,-1));
    %         else
    %             etiqueta = m;
    %         end
    % 
    %         b_texto = dec2bin(etiqueta,k);
    %         text(constelacion(m+1, 1)+0.15, constelacion(m+1, 2)+0.15, b_texto, 'FontSize', 10, 'FontWeight', 'bold');
    %     end
    % 
    % 
    %     xlim([-lim, lim]); ylim([-lim, lim]);
    %     %title(['Espacio de Señales y Regiones de Decisión: ' num2str(entradaM) '-' modulacionTipo]);
    %     xlabel('\phi_1'); ylabel('\phi_2');
    % end
end

function [bitsRecibidos, simbolosDetectados] = demodularSimbolos(simbolos, M, mapeoTipo, modulacionTipo)
    k = log2(M);
    numSimbolos = size(simbolos, 1);
    % Hago la constelación de referencia de nuevo
    constelacion = zeros(M, 2);
    for m = 0:M-1
        constelacion(m+1, 1) = cos(2 * pi * m / M);
        constelacion(m+1, 2) = sin(2 * pi * m / M);
    end
    % Inicializo el vector
    simbolosDetectados = zeros(numSimbolos, 1);
    switch upper(modulacionTipo)
        case('PSK')
    % Para cada símbolo:
            for i = 1:numSimbolos
                puntoRecibido = simbolos(i, :);
                % Cálculo de la distancia a los puntos de la constelacion
                distancias = sqrt((constelacion(:,1) - puntoRecibido(1)).^2 + ...
                                  (constelacion(:,2) - puntoRecibido(2)).^2);
                % De todas las distancias calculadas se selecciona la
                % mínima
                [~, simbolosDetectados(i)] = min(distancias);    
            end
        case('FSK')
            [~, simbolosDetectados] = max(simbolos, [], 2);
        otherwise
            error('Tipo de modulación no soportada');
    end

    simbolosDetectados=simbolosDetectados-1;

    %Se debe deshacer la codificación Gray de haber sido aplicada
    if strcmp(mapeoTipo, 'gray')
        simbolosBinarios = zeros(size(simbolosDetectados));
    
        % Se recorren todos los símbolos recibidos
        for i = 1:length(simbolosDetectados)

            valoresGray = simbolosDetectados(i);
            valoresBinarios = 0;
           
            while valoresGray > 0
                valoresBinarios = bitxor(valoresBinarios, valoresGray);
                valoresGray = bitshift(valoresGray, -1);
            end
            
            % Se guarda el valor final del símbolo
            simbolosBinarios(i) = valoresBinarios;
        end
    simbolosDetectados = simbolosBinarios;
    end
        
    
    simbolosDetectados = de2bi(simbolosDetectados,k,'left-msb');
    bitsRecibidos= reshape(simbolosDetectados',1,[]);
    
end

function SER = errorSimbolo(simbolosTransmitidos, simbolosDemodulados)

    numSimbolos = size(simbolosTransmitidos, 1);
    
    % Se busca qué filas difieren
    diferencias = sum(abs(simbolosTransmitidos - simbolosDemodulados), 2);
    diferencias = diferencias>0.001;

    % Se cuentan los errores
    simbolosError = sum(diferencias);
    
    % Se estima la tasa de error
    SER = simbolosError / numSimbolos;
end


function BER = errorBit(bitsTransmitidos, bitsRecibidos)
    numBits = length(bitsTransmitidos);
    
    % Se truncan los bits recibidos por redondeo
    bitsRecibidos = bitsRecibidos(1:numBits);

    bitsErroneos = sum(bitsRecibidos ~= bitsTransmitidos);
    BER = bitsErroneos / numBits;
end