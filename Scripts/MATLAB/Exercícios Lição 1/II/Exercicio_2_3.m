% Entradas
E = 210e6; % Módulo de elasticidade do material
A = pi * (0.015^2); % Área da seção transversal da barra
L = 2; % Comprimento da barra
Po = 1e3; % Carga distribuída ao longo da barra

% Diferentes números de elementos na malha e valores de deslocamento
nels = [5, 10, 20, 40];
ubs = [0.0025, 0.005, 0.0075, 0.01, 0.025];

% Função para calcular a norma euclidiana dos erros
norma_euclidiana_erro = @(e, L) sqrt(integral(@(x) e(x).^2, 0, L));

% Loop para cada valor de deslocamento prescrito
for ub_idx = 1:length(ubs)
    ub = ubs(ub_idx);
    figure;
    sgtitle(sprintf('Comparação de Deslocamentos e Esforços para ub = %.4f m', ub), 'FontSize', 16);

    % Loop para cada valor de nel
    for nel_idx = 1:length(nels)
        nel = nels(nel_idx);
        nnos = nel + 1; % Número de nós
        h = L / nel; % Tamanho de cada elemento
        coord = linspace(0, L, nnos); % Coordenadas dos nós
        inci = [1:nel; 2:nel+1]'; % Incidências dos elementos

        % Cálculo da matriz de rigidez e vetor de forças de um elemento
        ke = (E * A / h) * [1, -1; -1, 1]; % Matriz de rigidez do elemento
        fe = (Po * h / 2) * [1; 1]; % Vetor de forças do elemento

        % Inicializa a matriz de rigidez global e o vetor de forças globais
        K = zeros(nnos); % Matriz de rigidez global
        F = zeros(nnos, 1); % Vetor de forças globais

        % Montagem da matriz de rigidez e vetor de forças globais
        for i = 1:nel
            loc = inci(i, :);
            K(loc, loc) = K(loc, loc) + ke;
            F(loc) = F(loc) + fe;
        end

        % Condição de contorno: fixar deslocamento u(0) = 0 no primeiro nó
        K(1, :) = 0;
        K(1, 1) = 1;
        F(1) = 0;

        % Condição de contorno: fixar deslocamento u(L) = ub no último nó
        K(end, :) = 0;
        K(end, end) = 1;
        F(end) = ub;

        % Calcular o deslocamento
        u = K \ F;

        % Calcular o esforço interno
        Nx = zeros(nel, 1);
        for i = 1:nel
            loc = inci(i, :);
            Nx(i) = E * A / h * (u(loc(2)) - u(loc(1)));
        end

        % Calcular a solução analítica
        x = linspace(0, L, 100);
        ua = (1 / (E * A)) * (-0.5 * Po * x.^2 + ((ub * E * A + 0.5 * Po * L^2) / L) * x);
        Nxa = (-Po * x + ((ub * E * A + 0.5 * Po * L^2) / L));

        u_interp = interp1(coord, u, x, 'linear');
        erro_percentual = abs((ua - u_interp) ./ ua) * 100;
        
        % Função de erro ajustada para retornar um valor escalar
        erro_func = @(x) (1 / (E * A)) * (-0.5 * Po * x.^2 + ((ub * E * A + 0.5 * Po * L^2) / L) * x) - interp1(coord, u, x, 'linear');

        norma_erro = norma_euclidiana_erro(erro_func, L);
        fprintf('Norma Euclidiana dos Erros para %d elementos e ub = %.4f: %.5e m\n', nel, ub, norma_erro);

        % Plotar dos resultados para o valor atual de nel
        subplot(length(nels), 2, (nel_idx - 1) * 2 + 1);
        plot(coord, u, 'o-k', x, ua, '-r');
        title(sprintf('Deslocamento (%d elementos)', nel));
        xlabel('Coordenadas');
        ylabel('Deslocamento (m)');
        grid on;
        if nel_idx == 1
            legend('Numérico', 'Analítico');
        end

        subplot(length(nels), 2, (nel_idx - 1) * 2 + 2);
        bar((coord(1:end-1) + coord(2:end)) / 2, Nx, 'k');
        hold on;
        plot(x, Nxa, '-r');
        title(sprintf('Esforço Interno (%d elementos)', nel));
        xlabel('Coordenadas');
        ylabel('Esforço Interno (N)');
        grid on;
    end

    % Gráfico de erro percentual para cada discretização
    figure;
    hold on;
    for nel_idx = 1:length(nels)
        nel = nels(nel_idx);
        nnos = nel + 1;
        h = L / nel;
        coord = linspace(0, L, nnos);
        inci = [1:nel; 2:nel+1]';

        ke = (E * A / h) * [1, -1; -1, 1];
        fe = (Po * h / 2) * [1; 1];

        K = zeros(nnos);
        F = zeros(nnos, 1);

        for i = 1:nel
            loc = inci(i, :);
            K(loc, loc) = K(loc, loc) + ke;
            F(loc) = F(loc) + fe;
        end

        K(1, :) = 0;
        K(1, 1) = 1;
        F(1) = 0;

        K(end, :) = 0;
        K(end, end) = 1;
        F(end) = ub;

        u = K \ F;

        u_interp = interp1(coord, u, x, 'linear');
        erro_percentual = abs((ua - u_interp) ./ ua) * 100;
        norma_erro = norma_euclidiana_erro(@(x) (1 / (E * A)) * (-0.5 * Po * x.^2 + ((ub * E * A + 0.5 * Po * L^2) / L) * x) - interp1(coord, u, x, 'linear'), L);

        plot(x, erro_percentual, 'DisplayName', sprintf('%d elementos', nel));
    end

    title(sprintf('Erro Percentual no Deslocamento para ub = %.4f m', ub));
    xlabel('Coordenadas');
    ylabel('Erro (%)');
    legend('show');
    grid on;
end