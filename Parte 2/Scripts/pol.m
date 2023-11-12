function complexo = pol(modulo, angulo)
    %Ângulo em graus.
    complexo = modulo*(cosd(angulo) + 1j*sind(angulo));
end
