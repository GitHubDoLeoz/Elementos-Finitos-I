%% Entrada de dados
L = 2; % comprimento total da Barra
E = 200e9; % módulo de elasticidade
A = pi * (0.01^2); % área
po = 3000; % carga distribuída constante

% Diferentes números de elementos na malha e valores de deslocamento
nels = [5, 10, 20, 40];
ub = 1.2825e-4;

% Função para calcular a norma euclidiana dos erros
normas_euclidianas = zeros(length(nels), 1);
norma_euclidiana_erro = @(e, x) sqrt(trapz(x, e.^2)); % Usando x como argumento

% Loop para cada valor de nel
for nel_idx = 1:length(nels)
    nel = nels(nel_idx);
    nnos = nel + 1;
    h = L / nel;
    coord = linspace(0, L, nnos);
    inci = [1:nel; 2:nel+1]';

    % Cálculo da matriz de rigidez e vetor de forças de um elemento
    ke = (E * A / h) * [1, -1; -1, 1];
    fe = (po * h / 2) * [1; 1];

    % Inicializa a matriz de rigidez global e o vetor de forças globais
    K = zeros(nnos);
    F = zeros(nnos, 1);

    % Montagem da matriz de rigidez e vetor de forças globais
    for i = 1:nel
        loc = inci(i, :);
        K(loc, loc) = K(loc, loc) + ke;
        F(loc) = F(loc) + fe;
    end

    % Condições de contorno
    K(1, :) = 0; K(end, :) = 0;
    K(1, 1) = 1; K(end, end) = 1;
    F(1) = 0; F(end) = ub;
    
    % Calcular o deslocamento
    u = K \ F;

    % Calcular a solução analítica
    x = linspace(0, L, 1000);
    ua = (1 / (E * A)) * (-0.5 * po * x.^2 + ((ub * E * A + 0.5 * po * L^2) / L) * x);
    
    %% Cálculo dos erros
    uh_interp = interp1(coord, u, x);
    erro_absoluto = abs(uh_interp - ua);
    erro_percentual = abs((uh_interp - ua) ./ ua) * 100;

    % Calcular a norma euclidiana dos erros
    normas_euclidianas(nel_idx) = norma_euclidiana_erro(uh_interp - ua, x); % Corrigido aqui

    % Plotar os resultados para o valor atual de nel
    figure(1);
    subplot(length(nels), 3, 3*nel_idx-2);
    plot(coord, u, 'o-k', x, ua, '-r');
    title(sprintf('%d elementos', nel));
    xlabel('Posição [m]'); ylabel('Deslocamento [m]');
    grid on;
    if nel_idx == 1
        legend('Numérico', 'Analítico');
    end 

    % Plotar o gráfico de erros percentuais
    subplot(length(nels), 3, 3*nel_idx-1);
    plot(x, erro_percentual, '-b', 'LineWidth', 1.25);
    title(sprintf('Erro Percentual'));
    xlabel('Posição [m]'); ylabel('Erro [%]');
    grid on;

    % Plotar o gráfico de erros absolutos
    subplot(length(nels), 3, 3*nel_idx);
    plot(x, erro_absoluto, '-g', 'LineWidth', 1.25); % Correto aqui
    title(sprintf('Norma L2: %.3e', normas_euclidianas(nel_idx)));
    xlabel('Posição [m]'); ylabel('Erro Absoluto [m]');
    grid on;
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
        sprintf('%.3e', normas_euclidianas(nel_idx)), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
end
hold off;