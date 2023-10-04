%Última edição: Ricardo - 2023/10/04 00:09:
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
Ib2 = Sb/(sqrt(3)*Vb1);
Ib3 = Sb/(sqrt(3)*Vb1);

%Impedâncias do circuito em pu.
Z1_lt02c1 = (0.08953 + 0.53092j) * (180+NA)/ Zb1;
Z1_lt02c2 = (0.08953 + 0.53092j) * (180+NA) / Zb1;
Z1_lt01c1 = (0.08953 + 0.53092j) * (390+NA) / Zb1;
Z1_lt01c2 = (0.08953 + 0.53092j) * (390+NA) / Zb1;
Z1_lt03c1 = (0.06731 + 0.48932j) * (480+NA) / Zb1;
Z1_lt04c1 = (0.03752 + 0.50121j) * (550+NA/10) / Zb1;
Z1_lt04c2 = (0.03752 + 0.50121j) * (550+NA/10) / Zb1;
Z1_lt01j1 = (0.02898 + 0.47598j) * (45+NA/10) / Zb2;
Z1_lt02j1 = (0.02898 + 0.47598j) * (35+NA/10) / Zb2 ;
Z1_lt03j1 = (0.04852 + 0.58921j) * (21+NA/10) / Zb2;
Z1_lt04j1 = (0.02898 + 0.47598j) * (25+NA/10) / Zb2;
Z1_lt01k1 = (0.02682 + 0.49327j) * (4+NA/10) / Zb3;
Zat_t1 = 1j*(6.2 + NA*1e-2) * 100/15;
%Impedâncias TR01T1 - Yd1d1
Zps = (0.0481 + NA*1e-4) + (7.5457 + NA*1e-2)*1j;
Zpt = (0.0991 + NA*1e-4) + (16.7381 + NA*1e-2)*1j;
Zst = (0.0398 + NA*1e-4) + (4.9875 + NA*1e-2)*1j;
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
Scc3fase = pol(14533.4986, 87.1794)*1e6;
Zeq_barra1 = Vb1^2/conj(Scc3fase) * 1/Zb1;
Zeq_barra3 = pol(13.5671, 86.8264)/Zb1

%Matriz Ybarra
Y = zeros(11,11);
Y(1,1) = 1/Zeq_barra1 + 1/Z1_lt02c1 + 1/Z1_lt02c2 + 1/Z1_lt04c1 + 1/Z1_lt04c2;
Y(2,2) = 1/Z1_lt02c1 + 1/Z1_lt02c2 + 1/Z1_lt03c1;
%Falta concluir Y barra

%Matriz Zbarra
%Z = Y^-1
