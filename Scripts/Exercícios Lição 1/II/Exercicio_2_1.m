% Parâmetros de entrada
L = 2.0; % Comprimento da barra [m]
nx = 200; % Número de pontos em x
x = linspace(0, L, nx); % Coordenadas x
h = L / (nx - 1); % Comprimento dos intervalos
A = pi * (0.015^2); % Área da seção [m^2]
E = 210e9; % Módulo de Young [Pa]
Po = 1e3; % Carga distribuída [N/m]
ua = 0; % Deslocamento à esquerda [m]
ubs = [2.5e-6]; % Deslocamento à direita [m]

for i = 1:length(ubs)
    ub = ubs(i); % Iterar para diferentes valores de ub

    % Obter a solução particular up e sua derivada
    up = (1 / E * A) * (-Po * x.^2 / 2 + (ub * E * A / L + Po / 2) * x);
    dup = (1 / E * A) * (-Po * x + (ub * E * A / L + Po / 2));

    % Obter os valores constantes para uh e sua derivada duh
    up0 = up(1);
    upL = up(end);
    c2 = ua - up0;
    c1 = (ub - upL - c2) / L;

    % Obter a solução analítica uana e sua derivada duana
    uana = up + c1 * x + c2;
    duana = dup + c1;

    % Plotar o carregamento distribuído
    figure;

    % Plotar o deslocamento
    subplot(2,1,1);
    plot(x, uana, 'r', 'LineWidth', 1.5);
    grid on;
    title('Campo de Deslocamento');
    xlabel('Posição [m]');
    ylabel('Deslocamento [m]');
    legend('Deslocamento u(x)', 'Location', 'Best');

    % Plotar a deformação
    subplot(2,1,2);
    plot(x, duana, 'g', 'LineWidth', 1.5);
    grid on;
    title('Campo de Deformação');
    xlabel('Posição [m]');
    ylabel('Deformação');
    legend('Deformação du(x)/dx', 'Location', 'Best');

    % Ajustar layout
    sgtitle(['Resultados para u_b = ', num2str(ub), ' m']);
end