clc;
clear;
close all;

% Parâmetros de entrada
E = 210e9;    % Módulo de elasticidade (Pa)
A = pi * (0.015^2);  % Área da seção transversal (m²)
L = 1.0;       % Comprimento da barra (m)
Po = 1e3;    % Carga máxima distribuída (N/m)

% Diferentes discretizações e valores de deslocamento
nels = [5, 10, 20, 40];  % Número de elementos
ubs = [0, 2.5345e-06, 5.7825e-06];  % Diferentes valores de deslocamento

% Função para calcular a norma euclidiana dos erros
norma_euclidiana_erro = @(e, L) sqrt(trapz(linspace(0, L, length(e)), e.^2));

% Loop para cada valor de deslocamento prescrito
for ub_idx = 1:length(ubs)
    ub = ubs(ub_idx);
    figure;

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
        K(1, :) = 0;
        K(1, 1) = 1;
        F(1) = 0;
        K(end, :) = 0;
        K(end, end) = 1;
        F(end) = ub;

        % Resolver o sistema linear para obter os deslocamentos
        u = K \ F;

        % Calcular o esforço interno (Nx)
        Nx = zeros(nel, 1);
        for i = 1:nel
            no1 = inci(i, 1);
            no2 = inci(i, 2);
            Nx(i) = E * A / h * (u(no2) - u(no1));
        end

        % Solução analítica
        x = linspace(0, L, 100);
        ua = (-Po * x.^3) / (6 * E * A * L) + ((ub + (Po * L^2) / (6 * E * A)) / L) * x;
        Nxa = (-Po * x.^2) / (2 * L) + ((ub * E * A + (Po * L^2) / 6) / L);

        % Interpolação dos resultados numéricos
        u_interp = interp1(coord, u, x);
        erro_percentual = abs((ua - u_interp) ./ ua) * 100;

        % Função de erro para a norma euclidiana
        erro_func = @(x) (1 / (E * A)) * (-0.5 * Po * x.^2 + ((ub * E * A + 0.5 * Po * L^2) / L) * x) - interp1(coord, u, x);
        norma_erro = norma_euclidiana_erro(erro_func(x), L);

        % Exibir a norma euclidiana dos erros
        fprintf('Norma Euclidiana dos Erros para %d elementos e ub = %.5f: %.10e m\n', nel, ub, norma_erro);

        % Plotar deslocamentos
        subplot(length(nels), 2, 2*nel_idx-1);
        plot(coord, u, 'o-k', x, ua, '-r');
        title(sprintf('Deslocamento (%d elementos)', nel));
        xlabel('Posição (m)');
        ylabel('Deslocamento (m)');
        grid on;
        if nel_idx == 1
            legend('Numérico', 'Analítico');
        end

        % Plotar o gráfico de erros percentuais
        subplot(length(nels), 2, 2*nel_idx);
        plot(x, erro_percentual, '-b', 'LineWidth', 1.5);
        title(sprintf('Erro Percentual (%d elementos)', nel));
        xlabel('Posição (m)');
        ylabel('Erro (%)');
        grid on;
    end

    fprintf([repmat('-', 1, 80) '\n']);
end

% Inicializa a figura para a análise de convergência
figure;
hold on;

% Loop para cada valor de deslocamento prescrito
for ub_idx = 1:length(ubs)
    ub = ubs(ub_idx);
    normas_erro_L2 = zeros(length(nels), 1);

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
        K(1, :) = 0;
        K(1, 1) = 1;
        F(1) = 0;
        K(end, :) = 0;
        K(end, end) = 1;
        F(end) = ub;

        % Resolver o sistema linear para obter os deslocamentos
        u = K \ F;

        % Calcular o esforço interno (Nx)
        Nx = zeros(nel, 1);
        for i = 1:nel
            no1 = inci(i, 1);
            no2 = inci(i, 2);
            Nx(i) = E * A / h * (u(no2) - u(no1));
        end

        % Solução analítica
        x = linspace(0, L, 100);
        ua = (-Po * x.^3) / (6 * E * A * L) + ((ub + (Po * L^2) / (6 * E * A)) / L) * x;
        Nxa = (-Po * x.^2) / (2 * L) + ((ub * E * A + (Po * L^2) / 6) / L);

        % Calcular o erro entre as soluções numérica e analítica
        erro = abs(interp1(coord, u, x) - ua);

        % Calcular a norma euclidiana dos erros
        norma_erro_L2 = norma_euclidiana_erro(erro, L);
        normas_erro_L2(nel_idx) = norma_erro_L2;
    end

    % Plotar a análise de convergência
    loglog(nels, normas_erro_L2, '-o', 'LineWidth', 2);
end

xlabel('Número de Elementos');
ylabel('Norma Euclidiana dos Erros');
grid on;
legend('ub = 0 m', 'ub = 2.5345e-06 m', 'ub = 5.7825e-06 m');
hold off;