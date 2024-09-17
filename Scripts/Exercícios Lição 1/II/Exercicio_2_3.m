% Entradas
E = 210e9; % Módulo de elasticidade do material
A = pi * (0.015^2); % Área da seção transversal da barra
L = 1.0; % Comprimento da barra
Po = 1e3; % Carga distribuída ao longo da barra

% Diferentes números de elementos na malha e valores de deslocamento
nels = [5, 10, 20, 40];
ubs = [0, 2.5345e-06, 5.7825e-06];

% Função para calcular a norma euclidiana dos erros
norma_euclidiana_erro = @(e, L) sqrt(trapz(linspace(0, L, length(e)), e.^2));

% Loop para cada valor de deslocamento prescrito
for ub_idx = 1:length(ubs)
    ub = ubs(ub_idx);
    figure;

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

        % Calcular o erro entre as soluções numérica e analítica
        erro = abs(interp1(coord, u, x) - ua);

        % Calcular a norma euclidiana dos erros
        norma_erro_L2 = norma_euclidiana_erro(erro, L);

        % Exibir a norma euclidiana dos erros no console
        fprintf('Norma L2 dos erros para nel = %d e ub = %.6fm: %.10e\n', nel, ub, norma_erro_L2);

        % Plotar dos resultados para o valor atual de nel
        subplot(length(nels), 2, 2*nel_idx-1); % Deslocamento
        plot(coord, u, 'o-k', x, ua, '-r');
        title(sprintf('Deslocamento (%d elementos)', nel));
        xlabel('Posição (m)');
        ylabel('Deslocamento (m)');
        grid on;
        if nel_idx == 1
            legend('Numérico', 'Analítico');
        end 

        % Plotar o gráfico de erros percentuais
        erro_percentual = abs((interp1(coord, u, x) - ua) ./ ua) * 100;
        subplot(length(nels), 2, 2*nel_idx); % Erro percentual
        plot(x, erro_percentual, '-b', 'LineWidth', 1.5);
        title(sprintf('Erro Percentual (%d elementos)', nel));
        xlabel('Posição (m)');
        ylabel('Erro (%)');
        grid on;
    end
    fprintf([repmat('-', 1, 70) '\n']);
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

        % Calcular o erro entre as soluções numérica e analítica
        erro = abs(interp1(coord, u, x) - ua);

        % Calcular a norma euclidiana dos erros
        norma_erro_L2 = norma_euclidiana_erro(erro, L);
        normas_erro_L2(nel_idx) = norma_erro_L2;
    end

    % Análise de convergência: plotar a norma dos erros L2 em escala log-log
    loglog(nels, normas_erro_L2, '-o', 'LineWidth', 2);
end

% Configurar o gráfico final com legenda e título
xlabel('Número de Elementos (log)');
ylabel('Norma dos Erros L2 (log)');
grid on;
legend('ub = 0 m', 'ub = 2.5345e-06 m', 'ub = 5.7825e-06 m');
hold off;