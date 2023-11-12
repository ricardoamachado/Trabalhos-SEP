function printCorrente(complexo,base)
    % Printa magnitude e angulo em graus de um vetor de números complexos.
    % Função printPolar modificada.
    % Printa três fases da corrente em pu e Amperes.
    
    magnitude = abs(complexo);
    angulo = rad2deg(angle(complexo));
    alfabeto = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    fprintf("Valores em pu:\n")
    for i = 1:length(complexo)
        fase_rotulo = sprintf('Fase %s:', alfabeto(i));
        fprintf('%s %.4f ∠ %.4f° pu\n', fase_rotulo, magnitude(i), angulo(i));
    end
    fprintf("Valores em Amperes:\n")
    for i = 1:length(complexo)
        fase_rotulo = sprintf('Fase %s:', alfabeto(i));
        fprintf('%s %.2f ∠ %.4f° A\n', fase_rotulo, magnitude(i)*base, angulo(i));
    end
end