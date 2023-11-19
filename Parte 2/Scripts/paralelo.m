function Zeq = paralelo(impedancias)
    Zeq = sum(impedancias.^(-1));
    Zeq = Zeq^(-1);
end

