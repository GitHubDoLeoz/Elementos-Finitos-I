% Entradas
L = 2.0;                % Comprimento da barra [m]
nx = 100;               % Número de pontos em x
x = linspace(0, L, nx); % Coordenadas x
h = L / (nx - 1);       % Comprimento dos intervalos
A = 0.01;               % Área da seção [m^2]
E = 210e6;              % Módulo de Young [Pa]
q0 = 1e3;               % Carga distribuída [N/m]
ua = 0;                 % Deslocamento à esquerda [m]
ub = 0;                 % Deslocamento à direita [m]

% Definições da carga
y = x / L;              % Vetor de posição normalizada
p = q0 * ones(size(y));

% Obtenha a solução particular up e sua derivada
up = -q0 * x.^2 / (2 * E * A);
dup = -q0 * x / (E * A);

% Obtenha os valores constantes para uh e sua derivada duh
up0 = up(1);
upL = up(end);
c2 = ua - up0;
c1 = (ub - upL - c2) / L;

% Obtenha a solução uana e sua derivada duana
uana = up + c1 * x + c2;
duana = dup + c1;

% Plotar o carregamento distribuído
figure;

subplot(3,1,1);
bar(x, p, 'b'); % A função 'histc' ajusta as larguras das barras para coincidir com o espaçamento
grid on;
title('Carregamento Distribuído');
xlabel('Posição [m]');
ylabel('Carga [N/m]');

% Plotar o campo de deslocamento
subplot(3,1,2);
plot(x, uana, 'r', 'DisplayName', 'Deslocamento u(x)');
grid on;
title('Campo de Deslocamento');
xlabel('Posição [m]');
ylabel('Deslocamento [m]');
legend;

% Plotar a derivada do campo de deslocamento
subplot(3,1,3);
plot(x, duana, 'g', 'DisplayName', 'Derivada du(x)/dx');
grid on;
title('Derivada do Campo de Deslocamento');
xlabel('Posição [m]');
ylabel('Derivada [m/m]');
legend;

% Ajuste de layout
sgtitle('Soluções Analíticas e Carregamento');