clc;
clear;
close all;

% Parâmetros de entrada
E = 68e9;                 % Módulo de elasticidade (Pa)
A = pi * (0.05^2);        % Área da seção transversal (m²)
L = 2.0;                  % Comprimento da barra (m)
Po = 3000;                % Carga máxima distribuída (N/m)

% Diferentes discretizações e valores de deslocamento
nels = [5, 10, 20, 40];

% Função para calcular a norma euclidiana dos erros
normas_euclidianas = zeros(length(nels), 1);
norma_euclidiana_erro = @(e, L) sqrt(trapz(linspace(0, L, length(e)), e.^2));

figure;

% Loop para cada valor de nel
for nel_idx = 1:length(nels)
    nel = nels(nel_idx);
    nnos = nel + 1;
    h = L / nel;
    coord = linspace(0, L, nnos);
    inci = [(1:nel)' (2:nnos)'];

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

        % Cálculo das forças nodais equivalentes considerando carga distribuída triangular
        x1 = coord(no1);
        x2 = coord(no2);
        f1 = Po * (x1 / L);
        f2 = Po * (x2 / L);
        
        % Calcular força nodal exata através da integração da carga distribuída
        fe = (h / 6) * [f1 + 2*f2; 2*f1 + f2];
        F(no1) = F(no1) + fe(1); 
        F(no2) = F(no2) + fe(2);
    end

    % Aplicar condições de contorno
    freedofs = 2:nnos;
    uh = zeros(nnos, 1);
    uh(freedofs, 1) = K(freedofs, freedofs) \ F(freedofs, 1);

    % Solução analítica
    x = linspace(0, L, 1000);
    u = (F / (E*A)) * x + (po / (2*E*A)) * (2*L-x) .* x;

    %% Cálculo dos erros
    uh_interp = interp1(coord, uh, x, 'linear', 'extrap');
    erro_percentual = abs((u - uh_interp) ./ u) * 100;
    erro_absoluto = abs(u - uh_interp);

    % Calcular norma euclidiana dos erros
    normas_euclidianas(nel_idx) = norma_euclidiana_erro(u - uh_interp, L);

    % Exibir a norma euclidiana dos erros
    fprintf('Norma L2 dos erros para %d elementos: %.10e m\n', nel, normas_euclidianas(nel_idx));

    %% Gráficos - Deslocamento numérico e analítico
    subplot(length(nels), 3, 3*nel_idx-2)
    plot(coord, uh, 'o-k', x, u, 'r');
    grid on; xlabel('Posição x [m]'); ylabel('Deslocamento [m]');
    title(sprintf('%d elementos', nel));
    if nel_idx == 1
        legend('Numérico', 'Analítico');
    end

    %% Gráfico dos erros percentuais
    subplot(length(nels), 3, 3*nel_idx-1)
    plot(x, erro_percentual, '-b', 'LineWidth', 1.25);
    grid on; xlabel('Posição x [m]'); ylabel('Erro [%]');
    title('Erro Percentual');
    
    %% Gráfico do erro absoluto
    subplot(length(nels), 3, 3*nel_idx)
    plot(x, erro_absoluto, '-g', 'LineWidth', 1.25);
    grid on; xlabel('Posição x [m]'); ylabel('Erro Absoluto');
    title(sprintf('Norma L2: %.3e', normas_euclidianas(nel_idx)));
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