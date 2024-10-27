% Parâmetros
E = 210e9;  % Módulo de elasticidade (Pa)
A = 0.001;  % Área da seção transversal (m^2)
Po = 2000;  % Carga distribuída (N/m)
L = 3.0;    % Comprimento total da barra (m)
nx = 100;   % Número de pontos para discretização em x

% Coordenadas ao longo do comprimento da barra
x = linspace(0, L, nx);
ua = 0;                   % Deslocamento na extremidade esquerda [m]
ub = 0;                   % Deslocamento na extremidade direita [m]

% 1. Solução Analítica
% Solução particular para u(x) e sua derivada
up = (Po*L^2 / (4*A0*E)) * ((3 - (2*x)/L) - 3*log(3 - (2*x)/L)) ...
    - ((3*p0/2 - (Po*L)/log(3)) * L / (2*E*A0)) * log(3 - (2*x)/L) ...
    + (Po*L^2) / (4*E*A0);
dup = -Po * x / (E * A);

% Determinação das constantes para a solução homogênea
up0 = up(1);
upL = up(end);
c2 = ua - up0;
c1 = (ub - upL - c2) / L;

% Solução analítica completa
uana = up + c1 * x + c2;

% 2. Solução FEM
% Deslocamentos conhecidos dos nós internos
u_2 = 5.95238095e-6;
u_3 = 1.07142857e-5;

% Definir comprimentos dos elementos FEM
L1 = 0.5; L2 = 1.0; L3 = 1.5;

% Coordenadas dos nós FEM e respectivos deslocamentos
x_fem = [0, L1, L1 + L2, L];
u_fem = [0, u_2, u_3, 0];

% 3. Análise de Deformações nos Elementos FEM
% Parâmetros de deslocamentos nos nós
u1 = 0;
u2 = 5.94e-6;
u3 = 1.07e-5;
u4 = 0;

% Calcular deformações numéricas para os três elementos
epsilon1 = (-1/L1) * u1 + (1/L1) * u2;
epsilon2 = (-1/L2) * u2 + (1/L2) * u3;
epsilon3 = (-1/L3) * u3 + (1/L3) * u4;

% Definir as posições para plotagem das deformações com segmentos de linhas
x_deform = [0, L1, L1 + L2, L];
deformacao = [epsilon1, epsilon2, epsilon3];

% Gráfico das soluções FEM, Analítica e Deformação
figure(1);
plot(x_fem, u_fem, 'o-r', 'LineWidth', 2);
hold on;
plot(x, uana, 'b--', 'LineWidth', 1.25);
xlabel('Posição [m]');
ylabel('Deslocamento u(x) [m]');
grid on;
legend('Aproximação por EF','Solução Analítica');
title('Comparação entre solução analítica e por elementos finitos')

% Plotar deformações ao longo da barra com segmentos de linhas horizontais e legenda
figure(2);
hold on;
plot([x_deform(1), x_deform(2)], [deformacao(1), deformacao(1)], 'LineWidth', 2, 'DisplayName', 'Elemento 1');
plot([x_deform(2), x_deform(3)], [deformacao(2), deformacao(2)], 'LineWidth', 2, 'DisplayName', 'Elemento 2');
plot([x_deform(3), x_deform(4)], [deformacao(3), deformacao(3)], 'LineWidth', 2, 'DisplayName', 'Elemento 3');

% Configurações adicionais do gráfico
xlabel('Posição ao longo da barra (m)'); ylabel('Deformação (\epsilon)'); grid on;
title('Deformação ao longo da barra');
xlim([0, L]); ylim([min(deformacao)-0.1*abs(min(deformacao)), max(deformacao)+0.1*abs(max(deformacao))]);
legend show;

% 5. Cálculo da energia no elemento 3
% Matriz de rigidez global do sistema
K = [4.2e8, -4.2e8, 0, 0;
     -4.2e8, 6.3e8, -2.1e8, 0;
     0, -2.1e8, 3.5e8, -1.4e8;
     0, 0, -1.4e8, 1.4e8];

% Vetor de deslocamentos global
u_global = [0; u_2; u_3; 0];

% Deslocamentos e matriz de rigidez para o elemento 3
u_elem3 = u_global(3:4);
K_elem3 = K(3:4, 3:4);

% Cálculo da energia elástica no elemento 3
energia_elem3 = 0.5 * u_elem3' * K_elem3 * u_elem3;
fprintf('Energia no elemento 3: %.6e J\n', energia_elem3);