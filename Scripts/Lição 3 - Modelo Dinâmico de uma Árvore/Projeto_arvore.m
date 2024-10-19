clc
clear all;
close all;

%% Entrada de dados
% Modos de frequências
modo=10;

% Comprimentos dos galhos
L1 = 0.3188;
L2 = 0.2530;
L3 = 0.2008;
L4 = 0.1594;

% Coordenadas dos nós
coord = [1,   0,                         0;
         2,   0,                         L1;
         3,   L2 * sind(20),             L1 + L2 * cosd(20);
         4,   -L2 * sind(20),            L1 + L2 * cosd(20);
         5,   -L2 * sind(20) - L3 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40);
         6,   -L2 * sind(20) + L3 * sind(0),  L1 + L2 * cosd(20) + L3 * cosd(0);
         7,   -L2 * sind(20) - L3 * sind(40) - L4 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60);
         8,   -L2 * sind(20) - L3 * sind(40) - L4 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20);
         9,   -L2 * sind(20) + L3 * sind(0) + L4 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20);
         10,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20);
         11,  L2 * sind(20) + L3 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40);
         12,  L2 * sind(20) - L3 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0);
         13,  L2 * sind(20) + L3 * sind(40) + L4 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60);
         14,  L2 * sind(20) + L3 * sind(40) + L4 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20);
         15,  L2 * sind(20) - L3 * sind(0) - L4 * sind(20),  L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20);
         16,  L2 * sind(20) - L3 * sind(0) + L4 * sind(20),  L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20)];

% Definição da conectividade dos elementos
inci = [1,  1,  1, 2;
        1,  2,  2, 3;
        1,  2,  2, 4;
        1,  3,  4, 5;
        1,  3,  4, 6;
        1,  4,  5, 7;
        1,  4,  5, 8;
        1,  4,  6, 9;
        1,  4,  6, 10;
        1,  3,  3, 11;
        1,  3,  3, 12;
        1,  4,  12, 15;
        1,  4,  12, 16;
        1,  4,  11, 13;
        1,  4,  11, 14];

% Propriedades do material
Tmat = [11.3e9 805 0.38];

% Propriedades geométricas
Tgeo = [pi*((0.18/2)^2)    (pi*((0.18/2)^4))/4     (pi*((0.18/2)^4))/4;
        pi*((0.1273/2)^2)  (pi*((0.1273/2)^4))/4   (pi*((0.1273/2)^4))/4;
        pi*((0.09/2)^2)    (pi*((0.09/2)^4))/4     (pi*((0.09/2)^4))/4;
        pi*((0.0636/2)^2)  (pi*((0.0636/2)^4))/4   (pi*((0.0636/2)^4))/4];

%% Inicialização de variáveis
nnos = size(coord, 1);
nel = size(inci, 1);

ke_bar = zeros(6,6);
ke = zeros(6,6);
me_bar = zeros(6,6);
me = zeros(6,6);

T = zeros(6,6);             % Matriz de transformação
K = zeros(3*nnos, 3*nnos);  % Matriz de rigidez
M = zeros(3*nnos, 3*nnos);  % Matriz de massa
u = zeros(3*nnos, 1);       % Vetor de deslocamentos

%% Loop sobre todos os elementos
for i = 1:nel
    % Identificando os nós do elemento
    no1 = inci(i, 3);
    no2 = inci(i, 4);

    % Obtendo coordenadas dos nós
    x1 = coord(no1, 2);
    y1 = coord(no1, 3);
    x2 = coord(no2, 2);
    y2 = coord(no2, 3);

    % Cálculo do comprimento e ângulos
    h = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    c = (x2 - x1) / h;
    s = (y2 - y1) / h;

    % Propriedades do material e geometria do elemento
    E = Tmat(inci(i, 1), 1);
    A = Tgeo(inci(i, 2), 1);
    Izz = Tgeo(inci(i, 2), 2);
    rho = Tmat(inci(i, 1), 2);

    % Localização dos graus de liberdade
    loc = [3*no1-2 3*no1-1 3*no1 3*no2-2 3*no2-1 3*no2];

    % Matriz de transformação
    T = [c  s  0  0  0 0;
        -s  c  0  0  0 0;
         0  0  0  0  0 0;
         0  0  0  c  s 0;
         0  0  0 -s  c 0;
         0  0  0  0  0 1];

    % Matriz de rigidez axial
    ke_bar = (E * A / h) * [1 0 0 -1 0 0;
                            0 0 0  0 0 0;
                            0 0 0  0 0 0;
                           -1 0 0  1 0 0;
                            0 0 0  0 0 0;
                            0 0 0  0 0 0];

    % Matriz de rigidez da viga
    ke_viga = (E * Izz / h^3) * [0  0    0     0    0     0;
                                 0 12   6*h    0   -12    6*h;
                                 0 6*h  4*h^2  0   -6*h  2*h^2;
                                 0  0    0     0   0      0;
                                 0 -12 -6*h    0   12   -6*h;
                                 0 6*h  2*h^2  0   -6*h  4*h^2];
                             
    me_por = (rho*A*h/6)*[2 0 0 1 0 0;
                          0 2 0 0 1 0;
                          0 0 0 0 0 0;
                          1 0 0 2 0 0;
                          0 1 0 0 2 0;
                          0 0 0 0 0 0];

    % Matriz de rigidez do elemento
    ke_por = ke_bar + ke_viga;
    ke = T' * ke_por * T;
    
    % Matriz de massa do elemento
    me = T'*me_por * T;

    % Montagem da matriz de rigidez e massa global
    K(loc, loc) = K(loc, loc) + ke;
    M(loc,loc) = M(loc,loc) + me;
end

%% Condições de contorno
AllDofs = 1:3*nnos;
FixedDofs = [1 2 3];
FreeDofs = setdiff(AllDofs, FixedDofs);

%% Estrutura da árvore
figure(1);
index=1;
plotMalha(coord,inci,index)
title('Estrutura da Árvore');

%% Análise dinâmica
% Cálculo dos modos e frequências
[V(FreeDofs,:),D] = eigs(K(FreeDofs,FreeDofs),M(FreeDofs,FreeDofs), modo, 'smallestabs');
D = diag(D);
omeg=sqrt(D)/2/pi;

% Plotagem da malha original e deformada
figure;
xmax = max(coord(:, 2));
ymax = max(coord(:, 3));
xmin = min(coord(:, 2));
ymin = min(coord(:, 3));
Lscale = max((xmax - xmin), (ymax - ymin));
scale = (Lscale*0.1)/max(abs(V(:,modo)));
coord_deslocada = coord + [zeros(nnos, 1), V(1:3:3*nnos-1, modo), V(2:3:3*nnos, modo)]*scale;
index=0;
plotMalha(coord_deslocada,inci,index)
hold on
plotMalha(coord,inci,index)
title (['Modo: ', num2str(modo), ' - Frequência: ', num2str(omeg(modo)), 'Hz'])