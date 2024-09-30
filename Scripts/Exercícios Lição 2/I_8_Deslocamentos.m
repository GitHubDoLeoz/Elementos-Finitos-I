% Parâmetros
E = 2.1e11;  % Módulo de elasticidade (Pa)
A = 0.001;    % Área da seção transversal (m^2)
Po = 2000;   % Carga distribuída (N/m)
L = 3.0;     % Comprimento total da barra (m)

% Solução FEM (com deslocamentos u_2 e u_3 já obtidos)
L1 = 0.5; L2 = 1.0; L3 = 1.5;
u_2 = 5.94e-6;  % Deslocamento no nó 2 (m)
u_3 = 1.07e-5;  % Deslocamento no nó 3 (m)

% Interpolação de deslocamentos FEM
x_fem = [0, L1, L1+L2, L];
u_fem = [0, u_2, u_3, 0];

% Gráfico
figure;
plot(x_fem, u_fem, 'o-r', 'LineWidth', 2);
hold on;
xlabel('Posição (m)');
ylabel('Deslocamento u(x) (m)');
grid on;