% ========================================================================
% Código para análise de deslocamento em uma barra com carga distribuída
% ========================================================================

close all; clear all; clc;

%% Entrada de dados
L = 1;                % Comprimento total da barra [m]
E = 210e9;            % Módulo de elasticidade [Pa]
A = pi * (0.015^2);   % Área da seção transversal da barra [m^2]
po = 1000;            % Carga distribuída constante [N/m]
nel = 3;              % Número de elementos da malha

%% Geração da malha
nnos = nel + 1; % Número de nós
he = L / nel; % Comprimento de cada elemento [m]

%% Cálculo da solução analítica
x = 0:he/5:L; % Coordenadas ao longo da barra para a solução analítica
u = (po / (2 * E * A)) * (2 * L - x) .* x; % Deslocamento analítico [m]
Nx = po * (L - x); % Força normal ao longo da barra [N]

%% Gráfico de deslocamento
figure;
plot(x, u, 'r-x');
grid on; xlabel('Posição x [m]'); ylabel('Deslocamento u(x) [m]');
title('Distribuição de Deslocamento ao Longo da Barra');