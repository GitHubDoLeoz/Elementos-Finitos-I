% Coordenadas dos nós
coord = [1 0  0;
         2 0  3;
         3 0  6;
         4 6  6;
         5 6  3;
         6 6  0];

% Definição da conectividade dos elementos
inci = [1  1  1 2;
        1  1  2 3;
        1  1  3 4;
        1  1  4 5;
        1  1  3 5;
        1  1  2 5;
        1  1  5 6];

% Propriedades do material
Tmat = [2.1e11 7800 0.3;
        70e9   2700 0.27];

% Propriedades geométricas
Tgeo = [(20e-3)^2 ((20e-3)^4)/12 ((20e-3)^4)/12;
        (5e-3)^2  ((5e-3)^4)/12  ((5e-3)^4)/12];

% Inicialização de variáveis
nnos = size(coord, 1); % Número de nós
nel = size(inci, 1);   % Número de elementos

K = zeros(3*nnos, 3*nnos); % Matriz de rigidez
F = zeros(3*nnos, 1);       % Vetor de forças
u = zeros(3*nnos, 1);       % Vetor de deslocamentos

% Loop sobre todos os elementos
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

    % Matriz de rigidez total do elemento
    ke_por = ke_bar + ke_viga;
    ke = T' * ke_por * T;

    % Montagem da matriz de rigidez global
    K(loc, loc) = K(loc, loc) + ke;
end

% Aplicando as condições de contorno
AllDofs = 1:3*nnos;
FixedDofs = [1 2 3 16 17 18];
FreeDofs = setdiff(AllDofs, FixedDofs);

% Aplicação das forças
F(3*3 - 2) = F(3*3 - 2) - 1000; % Força aplicada no grau de liberdade y do nó 3

% Resolvendo o sistema de equações
u(FreeDofs, 1) = K(FreeDofs, FreeDofs) \ F(FreeDofs, 1);

index=1;
plotMalha(coord,inci,index)

% Plotagem da malha original e deformada
figure;
xmax = max(coord(:, 2));
ymax = max(coord(:, 3));
xmin = min(coord(:, 2));
ymin = min(coord(:, 3));
Lscale = max((xmax - xmin), (ymax - ymin));
scale = (0.05 * Lscale) / max(abs(u));
coord_deslocada = coord + [zeros(nnos, 1), u(1:3:3*nnos-1), u(2:3:3*nnos)] * scale;
index = 0;
plotMalha(coord, inci, index); hold on;
plotMalha(coord_deslocada, inci, index); 
title('Malha de Elementos Finitos');