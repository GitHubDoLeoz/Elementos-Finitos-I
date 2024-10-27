close all;
clear all;
clc;

%% Entrada de dados
L = 2; % comprimento total da Barra
E = 200e9; % módulo de elasticidade
A = pi * (0.01^2); % área
po = 3000; % carga distribuída constante

nels = [5, 10, 20, 40];

% Função para calcular a norma euclidiana dos erros
normas_euclidianas = zeros(length(nels), 1);
norma_euclidiana_erro = @(e, L) sqrt(trapz(linspace(0, L, length(e)), e.^2));

figure;

% Loop para cada valor de nel
for nel_idx = 1:length(nels)
    nel = nels(nel_idx);
    nnos = nel + 1;  % Número de nós
    he = L / nel;     % Tamanho de cada elemento
    xn = linspace(0, L, nnos);  % Coordenadas dos nós
    inci = [(1:nel)' (2:nnos)'];   % Incidências dos elementos

    %% Montagem da matriz de rigidez
    Kg = zeros(nnos);
    Fg = zeros(nnos, 1);
    ke = (E*A / he) * [1 -1; -1 1];
    fe = (po * he / 2) * [1; 1];

    for e = 1:nel
        Kg(inci(e, :), inci(e, :)) = Kg(inci(e, :), inci(e, :)) + ke;
        Fg(inci(e, :), 1) = Fg(inci(e, :), 1) + fe;
    end

    freedofs = 2:nnos;
    uh = zeros(nnos, 1);
    uh(freedofs, 1) = Kg(freedofs, freedofs) \ Fg(freedofs, 1);
    
    %% Cálculo da solução analítica
    x = linspace(0, L, 1000);
    u = (po / (2 * E * A)) * (2 * L - x) .* x;

    %% Gráficos - Deslocamento numérico e analítico
    subplot(length(nels), 3, 3*nel_idx-2)
    plot(xn, uh, 'o-k', x, u, 'r');
    grid on; xlabel('Posição x [m]'); ylabel('Deslocamento [m]');
    title(sprintf('%d elementos', nel));
    if nel_idx == 1
        legend('Numérico', 'Analítico');
    end

    %% Cálculo dos erros
    uh_interp = interp1(xn, uh, x);
    erro_percentual = abs((u - uh_interp) ./ u) * 100;
    erro_absoluto = abs(u - uh_interp);
    
    %% Gráfico dos erros percentuais
    subplot(length(nels), 3, 3*nel_idx-1)
    plot(x, erro_percentual, '-b', 'LineWidth', 1.25);
    grid on; xlabel('Posição x [m]'); ylabel('Erro [%]');
    title('Erro Percentual');
    
    % Calcular norma euclidiana dos erros
    normas_euclidianas(nel_idx) = norma_euclidiana_erro(u - uh_interp, L);

    %% Gráfico do erro absoluto
    subplot(length(nels), 3, 3*nel_idx)
    plot(x, erro_absoluto, '-g', 'LineWidth', 1.25);
    grid on; xlabel('Posição x [m]'); ylabel('Erro Absoluto');
    title(sprintf('Norma L2: %.4e', normas_euclidianas(nel_idx)));
end

% Exibir normas euclidianas dos erros
disp('Normas Euclidianas dos Erros:');
for nel_idx = 1:length(nels)
    fprintf('Para %d elementos: %.4e\n', nels(nel_idx), normas_euclidianas(nel_idx));
end

% Plotar a análise de convergência
figure;
loglog(nels, normas_euclidianas, 'o-m', 'LineWidth', 1.5);
xlabel('Número de Elementos'); ylabel('Norma Euclidiana dos Erros');
title('Análise de Convergência');
grid on;

% Adicionar texto com os valores dos erros nas bolinhas
for nel_idx = 1:length(nels)
    text(nels(nel_idx), normas_euclidianas(nel_idx), ...
        sprintf('%.4e', normas_euclidianas(nel_idx)), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
end
hold off;
