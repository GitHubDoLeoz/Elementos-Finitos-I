close all; clear all;

%% Parâmetros de entrada
L = 10;                  % Comprimento da barra [m]
nx = 20;                 % Número de pontos em x
x = linspace(0, L, nx)'; % Coordenadas x
E = 210e9;               % Módulo de elasticidade [Pa]
A = pi * (0.015^2);      % Área da seção transversal [m^2]
Po = 1e3;                % Força aplicada [N]

%% Cálculo do deslocamento y
y = Po / (6 * E * A * L) * (L.^2 * x - x.^3);

%% Cálculo da tensão sigma
dudx = Po * (L.^2 - 3 * x.^2) / (6 * E * A * L);
Nx = E * A * dudx;
sigma = Nx / A;

%% Subplot 1: Deslocamento
figure;
subplot(2, 1, 1);
plot(x, y, '-r', 'LineWidth', 1.25);
title('Deslocamento ao longo da barra');
xlabel('Posição x [m]');
ylabel('Deslocamento [m]');
grid on;

%% Subplot 2: Tensão
subplot(2, 1, 2);
plot(x, sigma, '-b', 'LineWidth', 1.25);
title('Tensão ao longo da barra');
xlabel('Posição x [m]');
ylabel('Tensão \sigma [Pa]');
grid on;