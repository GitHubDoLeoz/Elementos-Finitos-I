% Definições de parâmetros
L = 10.0; % Comprimento da barra [m]
nx = 200; % Número de pontos em x
x = linspace(0, L, nx); % Coordenadas x
h = L / (nx - 1); % Comprimento dos intervalos
d = 0.03; % Diâmetro da seção [m]
A = pi * (d/2)^2; % Área da seção [m^2]
E = 210e6; % Módulo de Young [Pa]
q0 = 1e3; % Carga distribuída [N/m]
ua = 0; % Deslocamento à esquerda [m]
ub = 0; % Deslocamento à direita [m]

% Definições da carga
y = x / L; % Vetor de posição normalizada
p = q0 * y; % Carga distribuída

% Obter a solução particular up e sua derivada
up = q0 * (L^2 * x - x.^3) / (6 * E * A * L);
dup = q0 * (L^2 - 3 * x.^2) / (6 * E * A * L);

% Obter os valores constantes para uh e sua derivada duh
up0 = up(1);
upL = up(end);
c2 = ua - up0;
c1 = (ub - upL - c2) / L;

% Obter a solução uana e sua derivada duana
uana = up + c1 * x + c2;
duana = dup + c1;

% Calcular a tensão
tensao = E * duana / 1e6; % Tensão em MPa

% Plotar o carregamento distribuído
subplot(3, 1, 1);
bar(x, p, 'histc');
grid on;
title('Carregamento Linear');
xlabel('Posição [m]');
ylabel('Carga [N/m]');

% Plotar o deslocamento
subplot(3, 1, 2);
plot(x, uana, 'r', 'LineWidth', 1.5);
grid on;
title('Campo de Deslocamento');
xlabel('Posição [m]');
ylabel('Deslocamento [m]');
legend('Deslocamento u(x)');

% Plotar a tensão
subplot(3, 1, 3);
plot(x, tensao, 'b', 'LineWidth', 1.5);
grid on;
title('Campo de Tensão');
xlabel('Posição [m]');
ylabel('Tensão [MPa]');
legend('Tensão \sigma_{xx}(x)');