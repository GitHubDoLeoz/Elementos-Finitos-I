clc;
clear;
close all;

% Parâmetros de entrada
E = 68e9;                 % Módulo de elasticidade (Pa)
A = pi * (0.05^2);        % Área da seção transversal (m²)
L = 2.0;                  % Comprimento da barra (m)
Po = 3000;                % Carga máxima distribuída (N/m)

% Diferentes discretizações e valores de deslocamento
nels = [5, 10, 20, 40];  % Número de elementos
ubs = [3.4312e-06];  % Diferentes valores de deslocamento (usei 'ubs' para um vetor)

% Função para calcular a norma euclidiana dos erros
norma_euclidiana_erro = @(e, L) sqrt(trapz(linspace(0, L, length(e)), e.^2));

% Inicializa um vetor para armazenar as normas dos erros para a análise de convergência
normas_erros_ub = zeros(length(ubs), length(nels));

% Loop para cada valor de ub
for ub_idx = 1:length(ubs)
    ub = ubs(ub_idx);

    % Loop para cada valor de nel
    for nel_idx = 1:length(nels)
        nel = nels(nel_idx);
        nnos = nel + 1;  % Número de nós
        h = L / nel;     % Tamanho de cada elemento
        coord = linspace(0, L, nnos);  % Coordenadas dos nós
        inci = [(1:nel)' (2:nnos)'];   % Incidências dos elementos

        % Matriz de rigidez do elemento
        ke = (E * A / h) * [1 -1; -1 1];

        % Inicializar matriz de rigidez global e vetor de forças globais
        K = zeros(nnos, nnos);
        F = zeros(nnos, 1);

        % Montar a matriz de rigidez e o vetor de forças globais
        for i = 1:nel
            no1 = inci(i, 1);
            no2 = inci(i, 2);
            loc = [no1 no2];
            K(loc, loc) = K(loc, loc) + ke;

            % Cálculo da carga distribuída triangular
            x1 = coord(no1);
            x2 = coord(no2);
            f1 = Po * x1 / L;
            f2 = Po * x2 / L;
            fe = (h / 6) * [f1 + 2*f2; 2*f1 + f2];
            F(no1) = F(no1) + fe(1);
            F(no2) = F(no2) + fe(2);
        end

        % Condições de contorno
        K(1, :) = 0; K(end, :) = 0;
        K(1, 1) = 1; K(end, end) = 1;
        F(1) = 0; F(end) = ub;

        % Resolver o sistema linear para obter os deslocamentos
        u = K \ F;

        % Solução analítica
        x = linspace(0, L, 1000);
        ua = (-Po * x.^3) / (6 * E * A * L) + ((ub + (Po * L^2) / (6 * E * A)) / L) * x;

        % Interpolação dos resultados numéricos
        u_interp = interp1(coord, u, x);
        erro_percentual = abs(ua - u_interp);
        erro_absoluto = abs(u_interp - ua);

        % Calcular a norma euclidiana dos erros
        norma_erro_L2 = norma_euclidiana_erro(erro_percentual, L);

        % Armazenar a norma do erro para este número de elementos e ub
        normas_erros_ub(ub_idx, nel_idx) = norma_erro_L2;

        % Exibir a norma euclidiana dos erros
        fprintf('Norma L2 dos erros para %d elementos: %.10e m\n', nel, norma_erro_L2);

        % Plotar deslocamentos
        figure(1);
        subplot(length(nels), 3, 3*nel_idx-2);
        plot(coord, u, 'o-k', x, ua, '-r');
        title(sprintf('%d elementos', nel));
        xlabel('Posição [m]');
        ylabel('Deslocamento [m]');
        grid on;
        if nel_idx == 1
            legend('Numérico', 'Analítico');
        end

        % Plotar o gráfico de erros percentuais
        erro_percentual = abs((u_interp - ua) ./ ua) * 100;
        subplot(length(nels), 3, 3*nel_idx-1);
        plot(x, erro_percentual, '-b', 'LineWidth', 1.5);
        title(sprintf('Erro Percentual'));
        xlabel('Posição [m]');
        ylabel('Erro [%]');
        grid on;
        
        % Plotar o gráfico de erros percentuais
        subplot(length(nels), 3, 3*nel_idx);
        plot(x, erro_absoluto, '-g', 'LineWidth', 1.5);
        title(sprintf('Norma L2: %.3e', normas_erros_ub(nel_idx)));
        grid on; xlabel('Posição x [m]'); ylabel('Erro Absoluto');
    end
end

fprintf([repmat('-', 1, 60) '\n']);

% Plotar a norma dos erros em escala log-log
figure;
loglog(nels, normas_erros_ub(ub_idx, :), 'm-o', 'LineWidth', 1.5);
hold on;

% Configurações do gráfico
xlabel('Número de Elementos');
ylabel('Norma L2 do Erro');
title('Análise de Convergência');
grid on; hold off;

% Adicionar texto com os valores dos erros nas bolinhas
for nel_idx = 1:length(nels)
    text(nels(nel_idx), normas_erros_ub(nel_idx), ...
        sprintf('%.3e', normas_erros_ub(nel_idx)), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
end
hold off;