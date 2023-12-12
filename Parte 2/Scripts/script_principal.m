%Última edição: Ricardo - 2023/11/28 10:15:
clc;
clear;
NA = 1;
%Bases pu
Sb = 100e6;
Vb1 = 230e3;
Vb2 = 69e3;
Vb3 = 13.8e3;
Zb1 = Vb1^2/Sb;
Zb2 = Vb2^2/Sb;
Zb3 = Vb3^2/Sb;
Ib1 = Sb/(sqrt(3)*Vb1);
Ib2 = Sb/(sqrt(3)*Vb2);
Ib3 = Sb/(sqrt(3)*Vb3);

%Matrizes de transformação.
alfa = pol(1,120);
A = [1 1 1;1 alfa^2 alfa;1 alfa alfa^2];
A_inv = A^-1;

% SEQ. POSITIVA
%Impedâncias do circuito em pu.
Z1_lt02c1 = (0.08953 + 0.53092j) * (180+NA)/ Zb1;
Z1_lt02c2 = (0.08953 + 0.53092j) * (180+NA) / Zb1;
Z1_lt01c1 = (0.08953 + 0.53092j) * (390+NA) / Zb1;
Z1_lt01c2 = (0.08953 + 0.53092j) * (390+NA) / Zb1;
Z1_lt03c1 = (0.06731 + 0.48932j) * (480+NA) / Zb1;
Z1_lt04c1 = (0.03752 + 0.50121j) * (550+NA/10) / Zb1;
Z1_lt04c2 = (0.03752 + 0.50121j) * (550+NA/10) / Zb1;
Z1_lt01j1 = (0.02898 + 0.47598j) * (45+NA/10) / Zb2;
Z1_lt02j1 = (0.02898 + 0.47598j) * (35+NA/10) / Zb2;
Z1_lt03j1 = (0.04852 + 0.58921j) * (21+NA/10) / Zb2;
Z1_lt04j1 = (0.02898 + 0.47598j) * (25+NA/10) / Zb2;
Z1_lt01k1 = (0.02682 + 0.49327j) * (4+NA/10) / Zb3;
%Impedâncias TR01T1 - Yd1d1
Zps = ((0.0481 + NA*1e-4) + (7.5457 + NA*1e-2)*1j) / 100;
Zpt = ((0.0991 + NA*1e-4) + (16.7381 + NA*1e-2)*1j) / 100;
Zst = ((0.0398 + NA*1e-4) + (4.9875 + NA*1e-2)*1j) / 100;
Zst = Zst * 100/35; % Mudança de base
Z_tr01t1 = [1 1 0; 1 0 1; 0 1 1]^-1 * [Zps; Zpt; Zst];
Zp_tr01t1 = Z_tr01t1(1);
Zs_tr01t1 = Z_tr01t1(2);
Zt_tr01t1 = Z_tr01t1(3);

%Impedâncias TR01T2, TR02T1, TR03T1.
Z_tr01t2 = 1j*(4.2 + NA/100) * 1e-2;
Z_tr01t2 = Z_tr01t2 * 100/40; % Mudança de base
Z_tr02t1 = 1j*(4 + NA/100) * 1e-2;
Z_tr02t1 = Z_tr02t1 * 100/20; % Mudança de base
Z_tr03t1 = 1j*(5.5 + NA/100) * 1e-2;
Z_tr03t1 = Z_tr03t1 * 100/30; % Mudança de base
%Impedâncias equivalente de rede.
Scc3fase = pol(14533.4986, 87.1794) * 1e6/100e6;
Zeq_barra3 = 1/conj(Scc3fase);
Zeq_barra1 = pol(13.5671, 86.8264) / 100;

%Matriz Ybarra
Y = zeros(11,11);
Y(1,1) = 1/Zeq_barra1 + 1/Z1_lt02c1 + 1/Z1_lt02c2 + 1/Z1_lt04c1 + 1/Z1_lt04c2;
Y(2,2) = 1/Z1_lt02c1 + 1/Z1_lt02c2 + 1/Z1_lt03c1;
Y(3,3) = 1/Z1_lt01c2 + 1/Z1_lt01c1 + 1/Zeq_barra3;
Y(4,4) = 1/Z1_lt01c2 + 1/Z1_lt01c1 + 1/Zps + 1/Z_tr01t2 +1/Z1_lt03c1;
Y(5,5) = 1/Zps + 1/Z_tr01t2 + 1/Z1_lt01j1 + 1/Z1_lt02j1;
Y(6,6) = 1/Z1_lt02j1 +  1/Z1_lt04j1 + 1/Z1_lt03j1;
Y(7,7) = 1/Z1_lt03j1 + 1/Z_tr03t1;
Y(8,8) = 1/Z_tr03t1 + 1/Z1_lt04c1 + 1/Z1_lt04c2;
Y(9,9) = 1/Z1_lt04j1 + 1/Z1_lt01j1 + 1/Z_tr02t1;
Y(10,10) = 1/Z_tr02t1 + 1/Z1_lt01k1;
Y(11,11) = 1/Z1_lt01k1;

Y(1,2) = -(1/Z1_lt02c1 + 1/Z1_lt02c2);
Y(2,1) = Y(1,2);

Y(1,8) = -(1/Z1_lt04c1 + 1/Z1_lt04c2);
Y(8,1) = Y(1,8);

Y(2,4) = -1/Z1_lt03c1;
Y(4,2) = Y(2,4);

Y(3,4) = -(1/Z1_lt01c2 + 1/Z1_lt01c1);
Y(4,3) = Y(3,4);

Y(4,5) = -(1/Zps + 1/Z_tr01t2);
Y(5,4) = Y(4,5);

Y(5,6) = -1/Z1_lt02j1;
Y(6,5) = Y(5,6);

Y(5,9) = -1/Z1_lt01j1;
Y(9,5) = Y(5,9);

Y(6,9) = -1/Z1_lt04j1;
Y(9,6) = Y(6,9);

Y(6,7) = -1/Z1_lt03j1;
Y(7,6) = Y(6,7);

Y(7,8) = -1/Z_tr03t1;
Y(8,7) = Y(7,8);

Y(9,10) = -1/Z_tr02t1;
Y(10,9) = Y(9,10);

Y(10,11) = -1/Z1_lt01k1;
Y(11,10) = Y(10,11);
%Matriz Zbarra de seq. positiva.
Z1 = Y^-1;

% SEQ. NEGATIVA
%Matriz Zbarra de seq.negativa.
Z2 = Z1;

% SEQ. ZERO
%Linhas de transmissão.
Z0_lt02c1 = (0.44957 + 1.59869j) * (180+NA) / Zb1;
Z0_lt02c2 = (0.44957 + 1.59869j) * (180+NA) / Zb1;
Z0_lt01c1 = (0.44957 + 1.59869j) * (390+NA) / Zb1;
Z0_lt01c2 = (0.44957 + 1.59869j) * (390+NA) / Zb1;
Z0_lt03c1 = (0.40516 + 1.55659j) * (480+NA) / Zb1;
Z0_lt04c1 = (0.43212 + 1.51475j) * (550+NA/10) / Zb1;
Z0_lt04c2 = (0.43212 + 1.51475j) * (550+NA/10) / Zb1;
Z0_lt01j1 = (0.47056 + 1.71587j) * (45+NA/10) / Zb2;
Z0_lt02j1 = (0.47056 + 1.71587j) * (35+NA/10) / Zb2;
Z0_lt03j1 = (0.55212 + 1.97475j) * (21+NA/10) / Zb2;
Z0_lt04j1 = (0.47056 + 1.71587j) * (25+NA/10) / Zb2;
Z0_lt01k1 = (0.48713 + 1.79787j) * (4+NA/10) / Zb3;
%Impedância equivalente de seq. zero do trafo de 3 enrolamentos.
% Zp + Zs // Zt
Z0_tr01t1_eq = Zp_tr01t1 + paralelo([Zs_tr01t1 Zt_tr01t1]);
%Trafo aterramento
Zat_t1 = (1j*(6.2 + NA*1e-2) * 100/15)/100;
%Impedâncias mútuas
Z0m_b1b8 = ((0.04978 + 0.60745j) * (550+NA/10)) / Zb1;
Z0m_b3b4 = ((0.04547 + 0.58106j) * (390+NA)) / Zb1;
%Z0m_b3b4 = 0;
%Impedacia equivalente barra 1 - barra 8
Z0_eq_ltb1b8 = paralelo([Z0_lt04c1 - Z0m_b1b8, Z0_lt04c2 - Z0m_b1b8]) + Z0m_b1b8;
Z0_eq_ltb3b4 = paralelo([Z0_lt01c1 - Z0m_b3b4, Z0_lt01c2 - Z0m_b3b4]) + Z0m_b3b4;
%Impedâncias equivalente de rede.
Scc1fase = pol(7201.3748, 87.0701) * 1e6; %Valor em VA.
Z0_eq_barra3 = (3*Sb) / (conj(Scc1fase)) - 2*Zeq_barra3;
Z0_eq_barra1 = 8.6696j/100;
%Matriz Ybarra de Seq. Zero
Y0 = zeros(11,11);
Y0(1,1) = 1/Z0_eq_barra1 + 1/Z0_lt02c1 + 1/Z0_lt02c2 + 1/Z0_eq_ltb1b8;
Y0(2,2) = 1/Z0_lt02c1 + 1/Z0_lt02c2 + 1/Z0_lt03c1;
Y0(3,3) = 1/Z0_eq_barra3 + 1/Z0_eq_ltb3b4;
Y0(4,4) = 1/Z0_eq_ltb3b4 + 1/Z0_tr01t1_eq + 1/Z0_lt03c1 + 1/Z_tr01t2;
Y0(5,5) = 1/Zat_t1 + 1/Z0_lt01j1 + 1/Z0_lt02j1;
Y0(6,6) = 1/Z0_lt02j1 +  1/Z0_lt04j1 + 1/Z0_lt03j1;
Y0(7,7) = 1/Z0_lt03j1;
Y0(8,8) = 1/Z0_eq_ltb1b8 + 1/Z_tr03t1;
Y0(9,9) = 1/Z0_lt04j1 + 1/Z0_lt01j1;
Y0(10,10) = 1/Z_tr02t1 + 1/Z0_lt01k1;
Y0(11,11) = 1/Z0_lt01k1;

Y0(1,2) = -(1/Z0_lt02c1 + 1/Z0_lt02c2);
Y0(2,1) = Y0(1,2);

Y0(2,4) = -1/Z0_lt03c1;
Y0(4,2) = Y0(2,4);

Y0(3,4) = -1/Z0_eq_ltb3b4;
Y0(4,3) = Y0(3,4);

Y0(5,6) = -1/Z0_lt02j1;
Y0(6,5) = Y0(5,6);

Y0(5,9) = -1/Z0_lt01j1;
Y0(9,5) = Y0(5,9);

Y0(6,9) = -1/Z0_lt04j1;
Y0(9,6) = Y0(6,9);

Y0(6,7) = -1/Z0_lt03j1;
Y0(7,6) = Y0(6,7);

Y0(1,8) = -1/Z0_eq_ltb1b8;
Y0(8,1) = Y0(1,8);

Y0(10,11) = -1/Z0_lt01k1;
Y0(11,10) = Y0(10,11);

Z0 = Y0^-1;

%Tensões pré-falta em referenciadas a barra 1.
Vpre_b1 = zeros(11,1);
Vpre_b1(1) = pol(1.0380, 11.7008);
Vpre_b1(2) = pol(1.0195, 12.0656);
Vpre_b1(3) = pol(1.0265, 32.2270);
Vpre_b1(4) = pol(0.9813, 21.2785);
Vpre_b1(5) = pol(0.9792, 20.2045);
Vpre_b1(6) = pol(0.9738, 14.1765);
Vpre_b1(7) = pol(0.9953, 12.1878);
Vpre_b1(8) = pol(0.9954, 12.1870);
Vpre_b1(9) = pol(0.9604, 13.7159);
Vpre_b1(10) = pol(0.9604, 13.7135);
Vpre_b1(11) = pol(0.9578, 12.3971);
%Criando os vetores das tensões pré-falta referenciadas as barras 7 e 10, respectivamente.
Vpre_b7 = Vpre_b1*pol(1,-30);
Vpre_b10 = Vpre_b1*pol(1,-60);
%Defasar as tensões para as referências corretas.
%Matriz de defasagem relativa à barra 1.
Defasagem_b1_seq1 = [1;1;1;1;pol(1,-30);pol(1,-30);pol(1,-30);1;pol(1,-30);pol(1,-60);pol(1,-60)];
Defasagem_b1_seq2 = conj(Defasagem_b1_seq1);
Defasagem_b1 = [ones(11,1), Defasagem_b1_seq1, Defasagem_b1_seq2];
%Matriz de defasagem relativa à barra 7.
Defasagem_b7_seq1 = [pol(1,30);pol(1,30);pol(1,30);pol(1,30);1;1;1;pol(1,30);1;pol(1,-30);pol(1,-30)];
Defasagem_b7_seq2 = conj(Defasagem_b7_seq1);
Defasagem_b7 = [ones(11,1), Defasagem_b7_seq1, Defasagem_b7_seq2];
%Matriz de defasagem relativa à barra 10.
Defasagem_b10_seq1 = [pol(1,60);pol(1,60);pol(1,60);pol(1,60);pol(1,30);pol(1,30);pol(1,30);pol(1,60);pol(1,30);1;1];
Defasagem_b10_seq2 = conj(Defasagem_b10_seq1);
Defasagem_b10 = [ones(11,1),Defasagem_b10_seq1,Defasagem_b10_seq2];
%Resistências de falta.
Rf_a = 0.872 / Zb3;
Rf_b = 0.998 / Zb1;
Rf_c = 0.472 / Zb2;

%Sufixo 012 - Componentes simétricas.
%Sufixo abc - Fases a,b,c.

%Curto-circuito Monofásico na barra da SE10:
If_a_1 = Vpre_b10(10)/(Z1(10,10) + Z2(10,10) + Z0(10,10) + 3*Rf_a);
If_a = 3*If_a_1;
coluna10_Zbarra_012 = [Z0(:,10), Z1(:,10), Z1(:,10)];
Vpre_b10_012 = [zeros(11,1),Vpre_b10,zeros(11,1)];
Vpos_b10_012 = Vpre_b10_012 - If_a_1*coluna10_Zbarra_012;
Vpos_b10_012_defasado = Vpos_b10_012 .* Defasagem_b10;
fprintf("Seq Zero - Curto Monofásico SE10\n")
printPolar(Vpos_b10_012_defasado(:,1))
fprintf("\nSeq Positiva - Curto Monofásico SE10\n")
printPolar(Vpos_b10_012_defasado(:,2))
fprintf("\nSeq Negativa - Curto Monofásico SE10\n")
printPolar(Vpos_b10_012_defasado(:,3))
%Obtenção das fases a,b,c.
Vpos_b10_abc = zeros(size(Vpos_b10_012_defasado));
for i = 1:size(Vpos_b10_012_defasado, 1)
    Vpos_b10_abc(i, :) =  A * transpose(Vpos_b10_012_defasado(i, :));
end
fprintf("\nFase A - Curto Monofásico SE10\n")
printPolar(Vpos_b10_abc(:,1))
fprintf("\nFase B - Curto Monofásico SE10\n")
printPolar(Vpos_b10_abc(:,2))
fprintf("\nFase C - Curto Monofásico SE10\n")
printPolar(Vpos_b10_abc(:,3))
%CORRENTES CIRCUNVIZINHAS - BARRA 10.
%Corrente LT01K1
I_lt01k1_a1 = (Vpos_b10_012(10,2) - Vpos_b10_012(11,2))/(Z1_lt01k1);
I_lt01k1_a2 = (Vpos_b10_012(10,3) - Vpos_b10_012(11,3))/(Z1_lt01k1);
I_lt01k1_a0 = (Vpos_b10_012(10,1) - Vpos_b10_012(11,1))/(Z0_lt01k1);
I_lt01k1_a012 = [I_lt01k1_a0;I_lt01k1_a1;I_lt01k1_a2];
fprintf("\nCorrente LT01K1 - 012\n")
printCorrente012(I_lt01k1_a012,Ib3)
I_lt01k1_abc = A * I_lt01k1_a012;
fprintf("\nCorrente LT01K1 - abc\n")
printCorrente(I_lt01k1_abc,Ib3)
%Corrente TR02T1
I_tr02t1_a1 = (Vpos_b10_012(9,2) - Vpos_b10_012(10,2))/(Z_tr02t1);
I_tr02t1_a2 = (Vpos_b10_012(9,3) - Vpos_b10_012(10,3))/(Z_tr02t1);
I_tr02t1_a0 = (0 - Vpos_b10_012(10,1))/(Z_tr02t1);
I_tr02t1_a012 = [I_tr02t1_a0;I_tr02t1_a1;I_tr02t1_a2];
I_tr02t1_abc = A* I_tr02t1_a012;
fprintf("\nCorrente TR02T1 - 012\n")
printCorrente012(I_tr02t1_a012,Ib3)
fprintf("\nCorrente TR02T1 - abc\n")
printCorrente(I_tr02t1_abc,Ib3)


%Curto-circuito Bifásico na barra da SE2:
If_b_a1 = Vpre_b1(2)/(Z1(2,2) + Z2(2,2) + Rf_b);
If_b_012 = [0, If_b_a1, -If_b_a1];
Vpre_b2_012 = [zeros(11,1),Vpre_b1,zeros(11,1)];
coluna2_Zbarra_012 = [Z0(:,2),Z1(:,2),Z2(:,2)];
Vpos_b2_012 = Vpre_b2_012 - coluna2_Zbarra_012 .* If_b_012;
Vpos_b2_012_defasado = Vpos_b2_012 .* Defasagem_b1;
fprintf("\nSeq Zero - Curto Bifásico SE2\n")
printPolar(Vpos_b2_012_defasado(:,1))
fprintf("\nSeq Positiva - Curto Bifásico SE2\n")
printPolar(Vpos_b2_012_defasado(:,2))
fprintf("\nSeq Negativa - Curto Bifásico SE2\n")
printPolar(Vpos_b2_012_defasado(:,3))
%Cálculo das fases a,b,c das tensões de pós-falta.
Vpos_b2_abc = zeros(size(Vpos_b2_012_defasado));
for i = 1:size(Vpos_b2_012_defasado, 1)
    Vpos_b2_abc(i, :) =  A * transpose(Vpos_b2_012_defasado(i, :));
end
fprintf("\nFase A - Curto Bifásico SE2\n")
printPolar(Vpos_b2_abc(:,1))
fprintf("\nFase B - Curto Bifásico SE2\n")
printPolar(Vpos_b2_abc(:,2))
fprintf("\nFase C - Curto Bifásico SE2\n")
printPolar(Vpos_b2_abc(:,3))
%CORRENTES CIRCUNVIZINHAS - BARRA 2.
%Corrente LT03C1.
I_lt03c1_a1 = (Vpos_b2_012(4,2) - Vpos_b2_012(2,2))/Z1_lt03c1;
I_lt03c1_a2 = (Vpos_b2_012(4,3) - Vpos_b2_012(2,3))/Z1_lt03c1;
I_lt03c1_a0 = (Vpos_b2_012(4,1) - Vpos_b2_012(2,1))/Z0_lt03c1;
I_lt03c1_a012 = [I_lt03c1_a0;I_lt03c1_a1;I_lt03c1_a2];
I_lt01c1_abc = A*I_lt03c1_a012;
fprintf("\nCorrente LT03C1 - 012\n")
printCorrente012(I_lt03c1_a012,Ib1);
fprintf("\nCorrente LT03C1 - ABC\n")
printCorrente(I_lt01c1_abc,Ib1);
%Corrente LT02C1/LT02C2.
I_lt02cx_a1 = (Vpos_b2_012(1,2) - Vpos_b2_012(2,2))/Z1_lt02c1;
I_lt02cx_a0 = (Vpos_b2_012(1,1) - Vpos_b2_012(2,1))/Z0_lt02c1;
I_lt02cx_a2 = (Vpos_b2_012(1,3) - Vpos_b2_012(2,3))/Z1_lt02c1;
I_lt02cx_a012 = [I_lt02cx_a0;I_lt02cx_a1;I_lt02cx_a2];
I_lt02cx_abc = A * I_lt02cx_a012;
fprintf("\nCorrente LT02C1/LT02C2 - 012\n")
printCorrente012(I_lt02cx_a012,Ib1);
fprintf("\nCorrente LT02C1/LT02C2 - ABC\n")
printCorrente(I_lt02cx_abc,Ib1);

%Curto-circuito Bifásico à terra na barra da SE7:
If_c_a1 = Vpre_b7(7)/(Z1(7,7) + paralelo([Z2(7,7), Z0(7,7) + 3*Rf_c]));
%Correntes de seq. zero e seq. negativa por divisão de corrente:
If_c_a0 = - If_c_a1 * (Z2(7,7))/(Z0(7,7) + Z2(7,7) + 3*Rf_c) ;
If_c_a2 = - If_c_a1 * (Z0(7,7) + 3*Rf_c)/(Z0(7,7) + Z2(7,7) + 3*Rf_c);
If_c_012 = [If_c_a0,If_c_a1,If_c_a2];
Vpre_b7_012 = [zeros(11,1),Vpre_b7,zeros(11,1)];
coluna7_Zbarra_012 = [Z0(:,7), Z1(:,7), Z2(:,7)];
Vpos_b7_012 = Vpre_b7_012 - coluna7_Zbarra_012 .* If_c_012;
Vpos_b7_012_defasado =  Vpos_b7_012 .* Defasagem_b7;
fprintf("\nSeq Zero - Curto Bifásico SE7\n")
printPolar(Vpos_b7_012_defasado(:,1))
fprintf("\nSeq Positiva - Curto Bifásico SE7\n")
printPolar(Vpos_b7_012_defasado(:,2))
fprintf("\nSeq Negativa - Curto Bifásico SE7\n")
printPolar(Vpos_b7_012_defasado(:,3))
%Cálculo das fases a,b,c das tensões de pós-falta.
Vpos_b7_abc = zeros(size(Vpos_b7_012_defasado));
for i = 1:size(Vpos_b7_012_defasado, 1)
    Vpos_b7_abc(i, :) =  A * transpose(Vpos_b7_012_defasado(i, :));
end
fprintf("\nFase A - Curto Bifásico SE7\n")
printPolar(Vpos_b7_abc(:,1))
fprintf("\nFase B - Curto Bifásico SE7\n")
printPolar(Vpos_b7_abc(:,2))
fprintf("\nFase C - Curto Bifásico SE7\n")
printPolar(Vpos_b7_abc(:,3))
%CORRENTES CIRCUNVIZINHAS - BARRA 7.
%Corrente TR03T1
I_tr03t1_a1 = (Vpos_b7_012(8,2) - Vpos_b7_012(7,2))/(Z_tr03t1);
I_tr03t1_a2 = (Vpos_b7_012(8,3) - Vpos_b7_012(7,3))/(Z_tr03t1);
I_tr03t1_a0 = 0;
I_tr03t1_a012 = [I_tr03t1_a0;I_tr03t1_a1;I_tr03t1_a2];
fprintf("\nCorrente TR03T1 - 012\n")
printCorrente012(I_tr03t1_a012,Ib2);
I_tr03t1_abc  =  A * I_tr03t1_a012;
fprintf("\nCorrente TR03T1 - ABC\n")
printCorrente(I_tr03t1_abc,Ib2);
%Corrente LT03J1
I_lt03j1_a1 = (Vpos_b7_012(6,2) - Vpos_b7_012(7,2))/(Z1_lt03j1);
I_lt03j1_a2 = (Vpos_b7_012(6,3) - Vpos_b7_012(7,3))/(Z1_lt03j1);
I_lt03j1_a0 = (Vpos_b7_012(6,1) - Vpos_b7_012(7,1))/(Z0_lt03j1);
I_lt03j1_a012 = [I_lt03j1_a0;I_lt03j1_a1;I_lt03j1_a2];
I_lt03j1_abc  =  A * I_lt03j1_a012;
fprintf("\nCorrente LT03J1 - 012\n")
printCorrente012(I_lt03j1_a012,Ib2);
fprintf("\nCorrente LT03J1 - ABC\n")
printCorrente(I_lt03j1_abc,Ib2);



%Um Condutor aberto - LT04J1 (#6 - #9)
Z0_th69 = Z0(6,6) + Z0(9,9) - 2*Z0(6,9);
Z1_th69 = Z1(6,6) + Z1(9,9) - 2*Z1(6,9);
I_lt04j1_pre = (Vpre_b7(6) - Vpre_b7(9))/(Z1_lt04j1);
Z0_69 = -(Z0_lt04j1)^2/(Z0_th69 - Z0_lt04j1);
Z1_69 = -(Z1_lt04j1)^2/(Z1_th69 - Z1_lt04j1);
Z2_69 = Z1_69;
Ia1_69 = I_lt04j1_pre * Z1_69/(Z1_69 + paralelo([Z2_69, Z0_69]));
Ia2_69 = -Ia1_69 *(Z0_69)/(Z0_69 + Z2_69);
Ia0_69 = -Ia1_69 *(Z2_69)/(Z0_69 + Z2_69);
V_69 = Ia1_69 *(Z0_69 * Z2_69)/(Z0_69 + Z2_69) * ones(1,3);
deltaV_69 = [(Z0(:,6) - Z0(:,9))/(Z0_lt04j1), (Z1(:,6) - Z1(:,9))/(Z1_lt04j1), (Z2(:,6) - Z2(:,9))/(Z1_lt04j1)] .* V_69;
V_69_pos = [zeros(11,1),Vpre_b7,zeros(11,1)] + deltaV_69;
V_69_pos_defasado = V_69_pos .* Defasagem_b7;
V_69_pos_abc = zeros(size(V_69_pos_defasado));
for i = 1:size(V_69_pos_defasado, 1)
    V_69_pos_abc(i, :) =  A * transpose(V_69_pos_defasado(i, :));
end
fprintf("\nSeq Zero - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_defasado(:,1))
fprintf("\nSeq Positiva - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_defasado(:,2))
fprintf("\nSeq Negativa - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_defasado(:,3))
fprintf("\nFase A - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_abc(:,1))
fprintf("\nFase B - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_abc(:,2))
fprintf("\nFase C - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_abc(:,3))

%Dois Condutores abertos - LT01J1 (#5 - #9)
Z0_th59 = Z0(5,5) + Z0(9,9) - 2*Z0(5,9);
Z0_59 = -(Z0_lt01j1)^2/(Z0_th59 - Z0_lt01j1);
%Lembrando que Z1_th59 == Z2_th59 e Z1_59 == Z2_59
Z1_th59 = Z1(5,5) + Z1(9,9) - 2*Z1(5,9);
Z1_59 = -(Z1_lt01j1)^2/(Z1_th59 - Z1_lt01j1);
I_lt01j1_pre = (Vpre_b7(5) - Vpre_b7(9))/(Z1_lt01j1);
Ia_59 = I_lt01j1_pre * (Z1_59/(Z0_59 + 2*Z1_59));
V_59 = [-Z0_59*Ia_59, Ia_59*(Z0_59 + Z1_59), -Z1_59*Ia_59];
deltaV_59 = [(Z0(:,5) - Z0(:,9))/(Z0_lt01j1), (Z1(:,5) - Z1(:,9))/(Z1_lt01j1), (Z2(:,5) - Z2(:,9))/(Z1_lt01j1)] .* V_59;
V_59_pos = [zeros(11,1),Vpre_b7,zeros(11,1)] + deltaV_59;
V_59_pos_defasado = V_59_pos .* Defasagem_b7;
%Cálculo das fases a,b,c das tensões de pós-falta.
V_59_pos_abc = zeros(size(V_59_pos_defasado));
for i = 1:size(V_59_pos_defasado, 1)
    V_59_pos_abc(i, :) =  A * transpose(V_59_pos_defasado(i, :));
end
fprintf("\nSeq Zero - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_defasado(:,1))
fprintf("\nSeq Positiva - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_defasado(:,2))
fprintf("\nSeq Negativa - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_defasado(:,3))
fprintf("\nFase A - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_abc(:,1))
fprintf("\nFase B - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_abc(:,2))
fprintf("\nFase C - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_abc(:,3))

%Tensões das barras em Volts.
V_bases = [Vb1; Vb1; Vb1; Vb1; Vb2; Vb2; Vb2; Vb1; Vb2; Vb3; Vb3];
fprintf("\n Valores das tensões em Volts.\n")
fprintf("Seq Zero - Curto Monofásico SE10\n")
printPolar(Vpos_b10_012_defasado(:,1) .* V_bases)
fprintf("\nSeq Positiva - Curto Monofásico SE10\n")
printPolar(Vpos_b10_012_defasado(:,2) .* V_bases)
fprintf("\nSeq Negativa - Curto Monofásico SE10\n")
printPolar(Vpos_b10_012_defasado(:,3) .* V_bases)

fprintf("\nFase A - Curto Monofásico SE10\n")
printPolar(Vpos_b10_abc(:,1) .* V_bases)
fprintf("\nFase B - Curto Monofásico SE10\n")
printPolar(Vpos_b10_abc(:,2) .* V_bases)
fprintf("\nFase C - Curto Monofásico SE10\n")
printPolar(Vpos_b10_abc(:,3) .* V_bases)


fprintf("\nSeq Zero - Curto Bifásico SE2\n")
printPolar(Vpos_b2_012_defasado(:,1) .* V_bases)
fprintf("\nSeq Positiva - Curto Bifásico SE2\n")
printPolar(Vpos_b2_012_defasado(:,2) .* V_bases)
fprintf("\nSeq Negativa - Curto Bifásico SE2\n")
printPolar(Vpos_b2_012_defasado(:,3) .* V_bases)

fprintf("\nFase A - Curto Bifásico SE2\n")
printPolar(Vpos_b2_abc(:,1) .* V_bases)
fprintf("\nFase B - Curto Bifásico SE2\n")
printPolar(Vpos_b2_abc(:,2) .* V_bases)
fprintf("\nFase C - Curto Bifásico SE2\n")
printPolar(Vpos_b2_abc(:,3) .* V_bases)


fprintf("\nSeq Zero - Curto Bifásico SE7\n")
printPolar(Vpos_b7_012_defasado(:,1) .* V_bases)
fprintf("\nSeq Positiva - Curto Bifásico SE7\n")
printPolar(Vpos_b7_012_defasado(:,2) .* V_bases)
fprintf("\nSeq Negativa - Curto Bifásico SE7\n")
printPolar(Vpos_b7_012_defasado(:,3) .* V_bases)

fprintf("\nFase A - Curto Bifásico SE7\n")
printPolar(Vpos_b7_abc(:,1) .* V_bases)
fprintf("\nFase B - Curto Bifásico SE7\n")
printPolar(Vpos_b7_abc(:,2) .* V_bases)
fprintf("\nFase C - Curto Bifásico SE7\n")
printPolar(Vpos_b7_abc(:,3) .* V_bases)

fprintf("\nSeq Zero - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_defasado(:,1) .* V_bases)
fprintf("\nSeq Positiva - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_defasado(:,2) .* V_bases)
fprintf("\nSeq Negativa - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_defasado(:,3) .* V_bases)
fprintf("\nFase A - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_abc(:,1) .* V_bases)
fprintf("\nFase B - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_abc(:,2) .* V_bases)
fprintf("\nFase C - Condutor aberto - LT04J1\n")
printPolar(V_69_pos_abc(:,3) .* V_bases)

fprintf("\nSeq Zero - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_defasado(:,1) .* V_bases)
fprintf("\nSeq Positiva - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_defasado(:,2) .* V_bases)
fprintf("\nSeq Negativa - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_defasado(:,3) .* V_bases)
fprintf("\nFase A - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_abc(:,1) .* V_bases)
fprintf("\nFase B - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_abc(:,2) .* V_bases)
fprintf("\nFase C - Condutores abertos - LT01J1\n")
printPolar(V_59_pos_abc(:,3) .* V_bases)

%Especificação do resistor de aterramento.
Zg_66 = Z1(6,6) + Z2(6,6) + Z0(6,6);
imag_Zg_66_novo = imag(Z1(6,6) + Z2(6,6) + Z0(6,6));
If_novo = 40/Ib2;
abs_Zg_66_novo = (3*abs(Vpre_b7(6)))/If_novo;
real_Zg_66_novo = sqrt(abs_Zg_66_novo^2 - imag_Zg_66_novo^2);
R_aterramento = (real_Zg_66_novo - real(Zg_66))/3;
Pot_dissipada = Sb* If_novo^2 * R_aterramento;
