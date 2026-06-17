

function [bitsDetectados, simbolosDetectados, SER, BER]=demodulador(entradaOriginal,simbolosOriginales,transmisionRuidosa,entradaM,mapeoTipo,modulacionTipo, constelacion)


    [bitsDetectados, simbolosDetectados] = demodularSimbolos(transmisionRuidosa,entradaM,mapeoTipo,modulacionTipo);
    disp(entradaM);
    disp('El error de símbolo se estima en');
    SER = errorSimbolo(simbolosOriginales,simbolosDetectados) %sacar ;
    
    disp('El error de bit se estima en:');
    BER = errorBit(entradaOriginal,bitsDetectados) %sacar ;
    
    % %% Grafico de las regiones de decision PSK, muestras teoricas y ruidosas
    % colorYellowGreen = [154, 205, 50] / 255;
    % 
    % k=log2(entradaM);
    % if strcmp(modulacionTipo, 'FSK')
    %     msgbox('FSK es M-dimensional. Las regiones de decisión no se pueden graficar en un plano 2D.', 'Aviso FSK');
    % else
    %     figure('Color', 'w'); hold on; grid on; axis equal;
    % 
    %     %lim = max(max(abs(constelacion))) + 1.5; 
    %     lim = 2; %asi todas las imagenes tienen el mismo tamaño
    % 
    %     %Grafico los simbolos que recibí, los hice un poco mas lindos
    %     %plot(simbolosCanal(:,1), simbolosCanal(:,2), '.', 'Color', colorYellowGreen, 'MarkerSize', 15);
    %     scatter(transmisionRuidosa(:,1), transmisionRuidosa(:,2),50,colorYellowGreen, 'filled','MarkerFaceAlpha',0.4);
    % 
    %     % Regiones de decision
    %     ang_sep = 2*pi/entradaM;
    %     for m = 0:entradaM-1
    %         theta = m*ang_sep - ang_sep/2;
    %         line([0 lim*cos(theta)], [0 lim*sin(theta)], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
    %     end
    % 
    %     % Grafico los puntos ideales de la constelación
    %     %plot(constelacion(:,1), constelacion(:,2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', colorYellowGreen,'MarkerEdgeColor', colorYellowGreen);
    %     scatter(constelacion(:,1), constelacion(:,2),100,colorYellowGreen, 'filled','MarkerFaceAlpha',1,'MarkerEdgeColor', 'b');
    % 
    %     % Dibujo etiquetas de texto binarias al lado de los puntos ideales
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
    % Lo hacemos para cada simbolo
            for i = 1:numSimbolos
                puntoRecibido = simbolos(i, :);
                
                % Calculo la distancia a los puntos de la constelacion
                distancias = sqrt((constelacion(:,1) - puntoRecibido(1)).^2 + ...
                                  (constelacion(:,2) - puntoRecibido(2)).^2);
                
                % Agarro la distancia mas chica
                [~, simbolosDetectados(i)] = min(distancias);
                
            end
        case('FSK')

            [~, simbolosDetectados] = max(simbolos, [], 2);
        otherwise
            error('Tipo de modulación no soportada');
    end

    simbolosDetectados=simbolosDetectados-1;

    %Deshacer el Gray

    if strcmp(mapeoTipo, 'gray')

        simbolosBinarios = zeros(size(simbolosDetectados));
    
        % Recorro cada símbolo recibido
        for i = 1:length(simbolosDetectados)

            valoresGray = simbolosDetectados(i);
            valoresBinarios = 0;
           
            while valoresGray > 0
                valoresBinarios = bitxor(valoresBinarios, valoresGray);
                valoresGray = bitshift(valoresGray, -1);
            end
            
            % Guardo el valor final del simbolo
            simbolosBinarios(i) = valoresBinarios;
        end
    simbolosDetectados = simbolosBinarios;
    end
        
    
    simbolosDetectados = de2bi(simbolosDetectados,k,'left-msb');
    bitsRecibidos= reshape(simbolosDetectados',1,[]);
    
end

function SER = errorSimbolo(simbolosTransmitidos, simbolosDemodulados)

    numSimbolos = size(simbolosTransmitidos, 1);
    
    % Busco qué filas son diferentes
    diferencias = sum(abs(simbolosTransmitidos - simbolosDemodulados), 2);
    diferencias = diferencias>0.001;

    % Cuento los que tienen errores
    simbolosError = sum(diferencias);
    
    % Estimo la tasa de error
    SER = simbolosError / numSimbolos;
end


function BER = errorBit(bitsTransmitidos, bitsRecibidos)
    numBits = length(bitsTransmitidos);
    
    % Trunco los bits recibidos por redondeo
    bitsRecibidos = bitsRecibidos(1:numBits);

    bitsErroneos = sum(bitsRecibidos ~= bitsTransmitidos);
    BER = bitsErroneos / numBits;
end