clear all; close all; clc;

% Parâmetros do material
E = 200e9;        % Módulo de Elasticidade
nu = 0.3;         % Coeficiente de Poisson
Radius_in = 5;    % Raio interno
Radius_out = 10;  % Raio externo
theta = 90;       % Ângulo
N = 20;           % Quantidade de elementos (NxN)

% Parâmetros de malha e nós
NR = N;                     % Número de elementos na direção radial
NT = N;                     % Número de elementos na direção angular
nel = NR * NT;              % Número total de elementos
nnel = 4;                   % Número de nós por elemento
npR = NR + 1;               % Número de pontos na discretização radial
npT = NT + 1;               % Número de pontos na discretização angular
nnode = npR * npT;          % Número total de nós

% Discretizando o comprimento e largura
nR = linspace(Radius_in, Radius_out, npR);
nT = linspace(0, theta, npT) * pi / 180;
[R, T] = meshgrid(nR, nT);

% Calculando as coordenadas
XX = R .* cos(T);
YY = R .* sin(T);
coordinates = [XX(:) YY(:)];

% Ajuste no número de nós
if nR(1) == 0
    nnode = npR * npT - (NT - 1);
    NodeNo = [ones(1, NT-1), 1:nnode];
    coordinates = coordinates(NT:end, :);
else
    nnode = npR * npT;
    NodeNo = 1:nnode;
end

% Inicializando o array de nós
nodes = zeros(nel, nnel);
NodeNo = reshape(NodeNo, npT, npR);
nodes(:, 1) = reshape(NodeNo(1:npR-1, 1:npT-1), nel, 1);
nodes(:, 2) = reshape(NodeNo(2:npR, 1:npT-1), nel, 1);
nodes(:, 3) = reshape(NodeNo(2:npR, 2:npT), nel, 1);
nodes(:, 4) = reshape(NodeNo(1:npR-1, 2:npT), nel, 1);

% Matriz de rigidez e outras matrizes
D = (E / (1 - nu^2)) * [1 nu 0; nu 1 0; 0 0 (1 - nu) / 2];
npg = 2;                                         % Número de pontos de Gauss
peso = [1 1];                                    % Pesos de Gauss
abcissa = [-0.57735026918962 0.57735026918962];  % Abscissas de Gauss

% Inicializando matrizes globais
Kg = zeros(2 * nnode);    % Matriz de rigidez global
Fg = zeros(2 * nnode, 1); % Vetor de forças globais
u = zeros(2 * nnode, 1);  % Deslocamentos globais
T = zeros(nel, 1);        % Tensões de Von Mises

% Loop para calcular a rigidez de cada elemento e montar a matriz global
for e = 1:nel
    ke = zeros(8);
    no_elem = nodes(e, :);
    x_elem = coordinates(no_elem, 1);
    y_elem = coordinates(no_elem, 2);

    for i = 1:npg
        for j = 1:npg
            wi = peso(i);
            wj = peso(j);
            xi = abcissa(i);
            eta = abcissa(j);

            % Derivadas das funções de forma
            Nxi = [-1/4*(1-eta), 1/4*(1-eta), 1/4*(1+eta), -1/4*(1+eta)];
            Net = [-1/4*(1-xi), -1/4*(1+xi), 1/4*(1+xi), 1/4*(1-xi)];

            % Jacobiano
            J = [Nxi; Net] * [x_elem y_elem];
            invJ = inv(J);
            detJ = det(J);

            % Derivadas em coordenadas reais
            dN = invJ * [Nxi; Net];
            Nx = dN(1, :);
            Ny = dN(2, :);

            % Matriz B
            B = [Nx(1)  0      Nx(2)  0      Nx(3)  0      Nx(4)  0;
                 0      Ny(1)  0      Ny(2)  0      Ny(3)  0      Ny(4);
                 Ny(1)  Nx(1)  Ny(2)  Nx(2)  Ny(3)  Nx(3)  Ny(4)  Nx(4)];

            % Matriz de rigidez do elemento
            ke = ke + B' * D * B * wi * wj * detJ;
        end
    end

    % Montagem na matriz global
    loc = [2*no_elem-1; 2*no_elem];
    loc = loc(:)';
    Kg(loc, loc) = Kg(loc, loc) + ke;
end

% Aplicação de forças
Fg(1) = 50e5;

% Definindo graus de liberdade fixos e livres
fixeddofs = [];
for i = 1:size(NodeNo, 2)
    fixeddofs = [fixeddofs, 2*NodeNo(end, i)-1, 2*NodeNo(end, i)];
end
alldofs = 1:2*nnode;                     % Todos os graus de liberdade
freedofs = setdiff(alldofs, fixeddofs);  % Graus de liberdade livres

% Resolvendo os deslocamentos
u(freedofs) = Kg(freedofs, freedofs) \ Fg(freedofs);

% Cálculo das tensões nos elementos
for e = 1:nel
    no_elem = nodes(e, :);
    x_elem = coordinates(no_elem, 1);
    y_elem = coordinates(no_elem, 2);

    loc = [2*no_elem-1; 2*no_elem];
    loc = loc(:)';
    ue = u(loc);

    for i = 1:npg
        for j = 1:npg
            xi = abcissa(i);
            eta = abcissa(j);

            Nxi = [-1/4*(1-eta)  1/4*(1-eta)  1/4*(1+eta) -1/4*(1+eta)];
            Net = [-1/4*(1-xi) -1/4*(1+xi)  1/4*(1+xi)  1/4*(1-xi)];

            J = [Nxi; Net] * [x_elem y_elem];
            invJ = inv(J);

            dN = invJ * [Nxi; Net];
            Nx = dN(1, :);
            Ny = dN(2, :);

            B = [Nx(1)  0      Nx(2)  0      Nx(3)  0      Nx(4)  0;
                 0      Ny(1)  0      Ny(2)  0      Ny(3)  0      Ny(4);
                 Ny(1)  Nx(1)  Ny(2)  Nx(2)  Ny(3)  Nx(3)  Ny(4)  Nx(4)];

            epsilon = B * ue;
            sigma = D * epsilon;

            sigma_x = sigma(1);
            sigma_y = sigma(2);
            tau_xy = sigma(3);
            T(e) = sqrt(sigma_x^2 - sigma_x*sigma_y + sigma_y^2 + 3*tau_xy^2);
        end
    end
end

subplot(1, 1, 1); hold on;
colormap('jet'); colorbar;
c = colorbar;
ylabel(c, 'Tensão de Von Mises [Pa]', 'FontSize', 10, 'FontWeight', 'bold');
caxis([min(T), max(T)]); 
xlabel('x'); ylabel('y');
axis equal;

% Preenchendo o gráfico com as tensões de Von Mises
for e = 1:nel
    no_elem = nodes(e, :);
    x_elem = coordinates(no_elem, 1);
    y_elem = coordinates(no_elem, 2);
    fill(x_elem, y_elem, T(e), 'EdgeColor', 'k');
end
hold off;

%% ------------------ Imprimir Deslocamentos ------------------
disp(['Discretização - ', num2str(nel), ' elementos']);

% Criar tabela de deslocamentos para os nós
deslocamentos = table((1:nnode)', u(1:2:end), u(2:2:end), ...
                      'VariableNames', {'Nó', 'Deslocamento em X [m]', 'Deslocamento em Y [m]'});
disp('Deslocamentos nos nós:');
disp(deslocamentos);

max_ux = max(u(1:2:end));
max_uy = max(u(2:2:end));

disp('Deslocamento máximo em x (u_x):');
disp(max_ux);
disp('Deslocamento máximo em y (u_y):');
disp(max_uy);
disp('Tensão de Von Mises:');
disp(T(e));