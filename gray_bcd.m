%
k = 4
simbolo_BCD = gray_a_bcd([1,1,0,1], k)

function simbolo_BCD = gray_a_bcd(simbolo_gray, k)
    bit_actual = simbolo_gray(1);
    indice = 1;
    simbolo_BCD(1)= bit_actual;
    while (indice < k)
        bit_siguiente = simbolo_gray(indice+1);
        simbolo_BCD(indice+1) = bitxor(bit_actual, bit_siguiente);
        bit_actual = bit_siguiente;
        indice = indice + 1;
    end    
end