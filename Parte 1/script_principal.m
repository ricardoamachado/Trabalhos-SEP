%Última edição: Ricardo - 2023/10/17 21:22:
clear
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
Zat_t1 = (1j*(6.2 + NA*1e-2) * 100/15)/100;
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

%Matriz Zbarra
Z = Y^-1;
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

%Cálculos relativo ao curto-circuito trifásico na barra da SE4.

%Cálculos relativo ao curto-circuito trifásico na barra da SE9.

%Cálculos relativo ao curto-circuito trifásico na barra da SE11.
