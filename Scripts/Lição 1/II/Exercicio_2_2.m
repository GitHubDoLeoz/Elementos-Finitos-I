% ========================================================================
% Código para calcular e plotar o campo de deslocamento em uma barra
% sob carga distribuída, considerando diferentes deslocamentos à direita.
% ========================================================================

%% Parâmetros de entrada
L = 1.0;                                    % Comprimento da barra [m]
nx = 200;                                   % Número de pontos em x
x = linspace(0, L, nx);                     % Coordenadas x
h = L / (nx - 1);                           % Comprimento dos intervalos
A = pi * (0.015^2);                         % Área da seção [m^2]
E = 210e9;                                  % Módulo de Young [Pa]
q0 = 1e3;                                   % Carga distribuída máxima [N/m]
ua = 0;                                     % Deslocamento à esquerda [m]
ubs = [0, 1.2825e-6, 3.4312e-6, 5.7895e-6]; % Deslocamento à direita [m]

% Cria a figura e o subplot uma vez
figure;
subplot(1, 1, 1);

%% Iterar sobre os diferentes valores de ub e calcular uana para cada um
for i = 1:length(ubs)
    ub = ubs(i);

    % Obter a solução particular up e sua derivada
    up = (-q0 * x.^3) / (6 * E * A * L) + ...
         ((ub + (q0 * L^2) / (6 * E * A)) / L) * x;
    dup = -q0 * x.^2 / (2 * E * A * L) + ...
          (ub / L + q0 / (6 * E * A));

    % Obter os valores constantes para uh e sua derivada duh
    up0 = up(1);
    upL = up(end);
    c2 = ua - up0;
    c1 = (ub - upL - c2) / L;

    % Obter a solução analítica uana e sua derivada duana
    uana = up + c1 * x + c2;
    duana = dup + c1;

    % Plotar o deslocamento no mesmo gráfico
    plot(x, uana, 'LineWidth', 1.5, 'DisplayName', ['u_b = ', num2str(ub), ' m']);
    hold on;
end

% Configurações finais do gráfico
title('Campo de Deslocamento');
grid on; hold off; xlabel('Posição [m]'); ylabel('Deslocamento [m]');
legend('Location', 'Best');