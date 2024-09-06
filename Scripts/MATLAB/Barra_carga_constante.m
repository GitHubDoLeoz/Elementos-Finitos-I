% **************************************************
% Barra carga Constante
%
% E*A*u'' = -po
% u(0) = 0
% du(L)/dx = F/EA
%
% Solução Analítica u(x) = Fx/EA + (po/2EA) * (2L-x) * x
% Força de Reação R(0) = -(poL + F)
%
% Malha de Elementos Finitos
%
% 1-----2-----3-----4 ... node number
% 1 2 3 element number
%
% R. Pavanelo
% www.fem.unicamp.br/~ltm
% outubro 2021
% **************************************************

close all;
clear all;
clc;

%% Entrada de dados

L = 1; % comprimento total da Barra
E = 100e9; % módulo de elasticidade
A = (10e-3)^2; % área
F = 500; % carga pontual na extremidade direita x=L
po = 2000; % carga distribuída constante
nel = 3; % número de elementos

%% Gerando a malha

nnos = nel + 1; % número de nós
he = L / nel; % comprimento do elemento
xn = 0:he:L; % coordenadas nodais
inci = [[1:nnos-1]' [2:nnos]']; % formação dos elementos

%% Montagem da matriz de Rigidez

Kg = zeros(nnos);
uh = zeros(nnos, 1);
Fg = zeros(nnos, 1);

ke = (E*A / he) * [1 -1; -1 1]; % Rigidez do elemento
fe = (po * he / 2) * [1; 1]; % Carga nodal equivalente > po

for e = 1:nel
    Kg(inci(e, :), inci(e, :)) = Kg(inci(e, :), inci(e, :)) + ke;
    Fg(inci(e, :), 1) = Fg(inci(e, :), 1) + fe;
end

Fg(end, 1) = Fg(end, 1) + F; % carga Pontual no nó da Direita
freedofs = 2:nnos; % aplicar as condições de contorno
uh(freedofs, 1) = Kg(freedofs, freedofs) \ Fg(freedofs, 1); % cálculo da resposta

%% Pós-processamento

% cálculo das forças internas
for e = 1:nel
    NxEl(e) = E*A / he * [-1 1] * uh(inci(e, :));
end

%% cálculo da solução analítica
x = 0:he/5:L;
u = (F / (E*A)) * x + (po / (2 * E * A)) * (2 * L - x) .* x;
Nx = F + po * (L - x);

%% gráficos

% deslocamentos
figure(1);
subplot(2, 1, 1);
plot(xn, uh(:, 1), '-o', x, u, 'r-x');
grid on;
legend('Numérica', 'Analítica');
xlabel('Posição x [m]');
ylabel('Deslocamento u(x) [m]');

% Força Normal
subplot(2, 1, 2);
bar((xn(2:nel+1) + xn(1:nel)) / 2, NxEl(1:nel), 1);
hold on;
plot(x, Nx, 'r-x');
grid on;
axis([0 L -1.5 * abs(min(Nx)), 1.5 * abs(max(Nx))]);
xlabel('Posição x [m]');
ylabel('Carga Normal Nx [N]');
legend('Numérica', 'Analítica');
hold off;
