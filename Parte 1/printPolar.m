function printPolar(complexo)
    %Printa magnitude e angulo em graus de um número complexo.
    magnitude = abs(complexo);
    angulo = rad2deg(angle(complexo));
    fprintf('Número Complexo: %.3f * ∠ %.3f°\n', magnitude, angulo);
end
