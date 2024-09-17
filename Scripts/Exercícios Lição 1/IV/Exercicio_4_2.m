% Solução item 4.1 - Solução analítica barra com seção variável
close all
clear all
clc

L = 10; % comprimento da barra [m]
nx = 20; % número de pontos x
x = linspace(0, L, nx)'; % coordenadas x
E = 210e9; % módulo de elasticidade [Pa]
b = 0.03; % largura da seção [m]
h = 0.04; % altura da seção [m]
A = b * h; % área da seção transversal [m^2]
F = 1000; % força aplicada [N]

% Cálculo do deslocamento y
y = -(F * L / (2 * E * A)) * log(1 - (2 * x / (3 * L)));

% Cálculo da tensão sigma
dudx = (F * L) ./ (A * E * (3 * L - 2 * x));
Nx = E * A * dudx;
sigma =  Nx / A;

% Criar figura com dois subplots
figure;

% Subplot 1: Deslocamento
subplot(2, 1, 1);
plot(x, y, '-r', 'LineWidth', 1.5);
title('Deslocamento ao longo da barra');
xlabel('Posição x [m]');
ylabel('Deslocamento [m]');
grid on;

% Subplot 2: Tensão
subplot(2, 1, 2);
plot(x, sigma, '-b', 'LineWidth', 1.5);
title('Tensão ao longo da barra');
xlabel('Posição x [m]');
ylabel('Tensão \sigma [Pa]');
grid on;