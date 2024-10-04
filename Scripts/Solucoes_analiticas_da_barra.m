% **************************************
% Soluções Analíticas da Barra
% Condições de Dirichlet ua e ub
% **************************************

clear all; close all; clc;

% **************************************
% Data set
L = 2.0;       % Comprimento da barra [m]
nx = 100;      % Número de pontos no eixo x
x = linspace(0, L, nx)'; % Coordenadas ao longo de x
h = L / (nx - 1);        % Comprimento do intervalo
A = 0.01;      % Área da seção [m^2]
E = 210E9;     % Módulo de Young [Pa]

% Definição do tipo de carregamento: 'con', 'lin', 'par', 'sin', 'cos', 'exp'
tipo = 'con'; 
q0 = 1E6;      % Carga distribuída [N/m]
ua = 0;        % Deslocamento à esquerda [m]
ub = 0;        % Deslocamento à direita [m]

% Definição do carregamento
y = x / L; % Vetor de posição normalizado

switch tipo
    case 'con' % Constante
        p = q0 * ones(length(y), 1);
    case 'lin' % Linear
        p = q0 * y;
    case 'par' % Parabólico
        p = q0 * y .* (1 - y);
    case 'sin' % Senoidal
        p = q0 * sin(pi * y);
    case 'cos' % Cossenoidal
        p = q0 * cos(pi * y);
    case 'exp' % Exponencial
        p = q0 * exp(y);
    otherwise % Caso padrão = constante
        warning(['Tipo de carregamento >>> ' tipo ' <<< não implementado!!!']);
end

% Solução particular up e sua derivada dup
switch tipo
    case 'con' % Constante
        up = -q0 * x.^2 / (2 * E * A);
        dup = -q0 * x / (E * A);
    case 'lin' % Linear
        up = -q0 * x.^3 / (6 * E * A * L);
        dup = -q0 * x.^2 / (2 * E * A * L);
    case 'par' % Parabólico
        up = (-q0 * x.^3 .* (2 * L - x)) / (12 * E * A * L^2);
        dup = (-q0 * x.^2 .* (3 * L - 2 * x)) / (6 * E * A * L^2);
    case 'sin' % Senoidal
        up = q0 * (L / pi)^2 * sin(pi * x / L) / (E * A);
        dup = q0 * (L / pi) * cos(pi * x / L) / (E * A);
    case 'cos' % Cossenoidal
        up = q0 * (L / pi)^2 * cos(pi * x / L) / (E * A);
        dup = -q0 * (L / pi) * sin(pi * x / L) / (E * A);
    case 'exp' % Exponencial
        up = -q0 * L^2 * exp(x / L) / (E * A);
        dup = -q0 * L * exp(x / L) / (E * A);
    otherwise % Caso padrão = constante
        warning(['Tipo de carregamento >>> ' tipo ' <<< não implementado!!!']);
end

% Obter valores constantes para uh e sua derivada duh
up0 = up(1);
upL = up(end);
c2 = ua - up0;
c1 = (ub - upL - c2) / L;

% Obter solução analítica uana e sua derivada duana
uana = up + c1 * x + c2;
duana = dup + c1;

% Plot do carregamento distribuído
subplot(2, 1, 1), bar(x, p);
grid on;
title('Carregamento Distribuído');
xlabel('Posição [m]');
ylabel('Carga [N/m]');

% Plot do campo de deslocamento e sua derivada
subplot(2, 1, 2), plot(x, uana, 'r', x, duana, 'g');
grid on;
title('Campo de Deslocamento e sua Derivada');
xlabel('Posição [m]');
ylabel('Deslocamentos [m]');
legend('u(x)', 'du(x)/dx');