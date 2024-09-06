% Definição dos parâmetros
L = 10.0; % Comprimento da barra [m]
nx = 200; % Número de pontos em x
x = linspace(0, L, nx); % Coordenadas x
b = 0.03; % Base da seção na extremidade livre [m]
h = 0.04; % Altura da seção na extremidade livre [m]
A_0 = b * h; % Área da seção na extremidade livre [m^2]
E = 210e6; % Módulo de Young [MPa]
F = 0.5e3; % Força aplicada na extremidade [N]

% Função da área variável ao longo da barra
A_x = A_0 * (3 - 2 * x / L); % Área variando de 3A_0 a A_0

% Resolver a equação diferencial para deslocamento
dx = x(2) - x(1);
u = zeros(1, nx);
for i = 2:nx
    A_avg = 0.5 * (A_x(i) + A_x(i-1)); % Média da área entre pontos
    u(i) = u(i-1) + (F * dx) / (E * A_avg); % Método de integração numérica
end

% Calcular tensão ao longo da barra
tensao = F ./ A_x;
tensao = tensao / 1e3;

% Plotar o deslocamento
subplot(2, 1, 1);
plot(x, u, 'r', 'LineWidth', 1.5);
grid on;
title('Deslocamento ao longo da barra');
xlabel('Posição [m]');
ylabel('Deslocamento [m]');

% Plotar a tensão
subplot(2, 1, 2);
plot(x, tensao, 'b', 'LineWidth', 1.5);
grid on;
title('Tensão ao longo da barra');
xlabel('Posição [m]');
ylabel('Tensão [MPa]');