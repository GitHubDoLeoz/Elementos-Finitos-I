% Solução item 4.1 - Solução analítica barra com seção variável
close all; clear all; clc

%% Parâmetros de entrada
L = 10;                  % Comprimento da barra [m]
nx = 20;                 % Número de pontos x
x = linspace(0, L, nx)'; % Coordenadas x
E = 210e9;               % Módulo de elasticidade [Pa]
b = 0.03;                % Largura da seção [m]
h = 0.04;                % Altura da seção [m]
A = b * h;               % Área da seção transversal [m^2]
F = 1000;                % Força aplicada [N]

%% Cálculo do deslocamento y
y = -(F * L / (2 * E * A)) * log(1 - (2 * x / (3 * L)));

%% Cálculo da tensão sigma
dudx = (F * L) ./ (A * E * (3 * L - 2 * x));
Nx = E * A * dudx;
sigma =  Nx / A;

%% Subplot 1: Deslocamento
figure;
subplot(2, 1, 1);
plot(x, y, '-r', 'LineWidth', 1.5);
title('Deslocamento ao longo da barra');
xlabel('Posição x [m]');
ylabel('Deslocamento [m]');
grid on;

%% Subplot 2: Tensão
subplot(2, 1, 2);
plot(x, sigma, '-b', 'LineWidth', 1.5);
title('Tensão ao longo da barra');
xlabel('Posição x [m]');
ylabel('Tensão \sigma [Pa]');
grid on;