function printCorrente012(complexo,base)
    % Printa magnitude e angulo em graus de um vetor de números complexos.
    % Função printPolar modificada.
    % Printa três sequências da corrente em pu e Amperes.
    %tipo - Representa se quer printar
    magnitude = abs(complexo);
    angulo = rad2deg(angle(complexo));
    seqs = ["Zero","Positiva","Negativa"];
    fprintf("Valores em pu:\n")
    for i = 1:length(complexo)
        fase_rotulo = sprintf('Seq %s:', seqs(i));
        fprintf('%s %.3f ∠ %.3f° pu\n', fase_rotulo, magnitude(i), angulo(i));
    end
    fprintf("Valores em Amperes:\n")
    for i = 1:length(complexo)
        fase_rotulo = sprintf('Seq %s:', seqs(i));
        fprintf('%s %.2f ∠ %.3f° A\n', fase_rotulo, magnitude(i)*base, angulo(i));
    end
end