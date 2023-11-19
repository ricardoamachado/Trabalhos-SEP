function printPolar(complexo)
    %Printa magnitude e angulo em graus de um vetor de números complexos.
    magnitude = abs(complexo);
    angulo = rad2deg(angle(complexo));
    for i = 1:length(complexo)
        fprintf('Barra %d: %.3f ∠ %.3f°\n', i, magnitude(i), angulo(i));
    end
end
