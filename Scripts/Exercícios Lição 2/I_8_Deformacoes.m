% Parâmetros conhecidos
q0 = 2000;      % Carga distribuída (N/m)
L = 3;          % Comprimento total da barra (m)
A = 0.001;      % Área da seção transversal (m^2)
E = 2.1e11;     % Módulo de elasticidade (Pa)

% Definir os valores conhecidos de deslocamentos e comprimentos dos elementos
u1 = 0;         % Deslocamento na posição 0 m
u2 = 5.94e-6;   % Deslocamento no nó 2
u3 = 1.07e-5;   % Deslocamento no nó 3
u4 = 0;         % Deslocamento no nó 4 (assumido como zero por simplicidade)

L1 = 0.5; L2 = 1; L3 = 1.5;       

% Calcular deformações numéricas para os três elementos
% Elemento 1 (de 0 a 0.5):
epsilon1 = (-1/L1)*u1 + (1/L1)*u2;

% Elemento 2 (de 0.5 a 1.5):
epsilon2 = (-1/L2)*u2 + (1/L2)*u3;

% Elemento 3 (de 1.5 a 3.0):
epsilon3 = (-1/L3)*u3 + (1/L3)*u4;

% Definir as posições acumuladas para os elementos numéricos
x_num = [L1, L1+L2, L];  % Posições de início e fim dos elementos
deformacao = [epsilon1, epsilon2, epsilon3];  % Repetir valor de epsilon no início e fim de cada elemento

% Plotar as deformações
figure;
hold on;

% Plot deformações numéricas
plot(x_num, deformacao, 'o-b', 'LineWidth', 2);

% Configurações do gráfico
xlabel('Posição ao longo da barra (m)');
ylabel('Deformação (\epsilon)');
grid on;
hold off;