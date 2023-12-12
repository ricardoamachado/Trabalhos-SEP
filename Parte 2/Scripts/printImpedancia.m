function printImpedancia(complexo)
    %Printa magnitude e angulo em graus de números complexos.
        fprintf('Impedância: %.4f + j%.4f %%\n', real(complexo*100), imag(complexo*100));
end
