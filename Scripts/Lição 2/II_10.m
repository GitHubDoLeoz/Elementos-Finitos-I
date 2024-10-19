% ======================================================================
% Análise Numérica de uma Barra com Seção Varíavel com Carga Distribuida
% ======================================================================

close all; clear all; clc;

%% Entrada de dados
L = 10.0;                % Comprimento total da barra (m)
E = 210e9;              % Módulo de elasticidade (Pa)
Ao = 0.01;             % Área na seção transversal no ponto x = 0 (m²)
p0 = 1000;              % Carga distribuída constante
nels = [8];  % Diferentes números de elementos

% Inicialização para armazenar normas euclidianas dos erros
subplot_length = length(nels);
normas_euclidianas_u = zeros(subplot_length, 1);
normas_euclidianas_def = zeros(subplot_length, 1);
normas_euclidianas_ten = zeros(subplot_length, 1);

%% Loop para diferentes números de elementos
for n_idx = 1:subplot_length
    nel = nels(n_idx);
    nnos = nel + 1;
    he = L / nel;
    xn = linspace(0, L, nnos);
    inci = [(1:nnos-1)', (2:nnos)'];

    %% Montagem da matriz de rigidez
    Kg = zeros(nnos);
    Fg = zeros(nnos, 1);
    uh = zeros(nnos, 1);
    def = zeros(nel, 1);
    Ten = zeros(nel, 1);

    % Montagem da matriz de rigidez global
    for e = 1:nel
        % Coordenadas do elemento
        x1 = xn(inci(e, 1));
        x2 = xn(inci(e, 2));

        % Áreas nos pontos x1 e x2
        A1 = Ao * (3 - (2 * x1 / L));
        A2 = Ao * (3 - (2 * x2 / L));

        % Rigidez do elemento
        ke = (2 * E / (x2 - x1)) * [(A1 + A2) / 2, -(A1 + A2) / 2; -(A1 + A2) / 2, (A1 + A2) / 2];
        f1 = p0 * x1 / L;
        f2 = p0 * x2 / L; 
        fe = (he / 6) * [2*f1 + f2; f1 + 2*f2];

        % Montagem na matriz global
        Kg(inci(e,:), inci(e,:)) = Kg(inci(e,:), inci(e,:)) + ke;
        Fg(inci(e,:)) = Fg(inci(e,:)) + fe(1);
        Fg(inci(e,:)) = Fg(inci(e,:)) + fe(2);
    end

    % Aplicar as condições de contorno (u(0) = 0 e u(L) = 0)
    freedofs = 2:(nnos-1);
    uh(freedofs, 1) = Kg(freedofs, freedofs) \ Fg(freedofs, 1);

    %% Pós-processamento
    xc = (xn(1:end-1) + xn(2:end)) / 2; % Coordenadas médias dos elementos
    for e = 1:nel
        % Coordenadas dos nós do elemento
        x1 = xn(inci(e, 1));
        x2 = xn(inci(e, 2));
        Le = x2 - x1;

        % Deslocamentos nos nós do elemento
        ue = uh(inci(e, :));

        % Cálculo da variação do deslocamento (du/dx)
        def(e) = (ue(2) - ue(1)) / Le;

        % Cálculo da tensão numérica
        Ten(e) = E * def(e);
    end

    %% Solução analítica
    x = linspace(0, L, 1000);
    A_x = Ao * (3 - (2 * x / L));
    u = (p0 * L^2 / (16 * Ao * E)) * (((3 - (2 * x) / L).^2) / 2 - 6 .* (3 - (2 * x) / L) + 9 .* log(3 - (2 * x) / L)) ...
    - (((-p0 * L / log(3)) + (9 * p0 * L) / 8) * L) / (2 * E * Ao) .* log(3 - (2 * x) / L) ...
    + (11 * p0 * L^2) / (32 * E * Ao);

    % Definindo os termos individuais
    dudx = gradient(u,x);

    % Cálculo da tensão
    sigma = dudx * E;

    %% Cálculo do erro percentual
    % Erro no deslocamento
    uh_interp = interp1(xn, uh, x, 'linear', 'extrap');
    erro_absoluto_u = abs(u - uh_interp);
    normas_euclidianas_u(n_idx) = sqrt(trapz(x, erro_absoluto_u.^2));

    % Erro na deformação
    def_interp = interp1(xc, def, x, 'linear', 'extrap');
    erro_absoluto_def = abs(dudx - def_interp);
    normas_euclidianas_def(n_idx) = sqrt(trapz(x, erro_absoluto_def.^2));
    
    % Erro na tensão
    sigma_interp = interp1(xc, Ten, x, 'linear', 'extrap');
    erro_absoluto_ten = abs(sigma - sigma_interp);
    normas_euclidianas_ten(n_idx) = sqrt(trapz(x, erro_absoluto_ten.^2));

    %% Gráficos
    % Deslocamentos
    figure;

    % Subplot 1: Deslocamento - Comparação numérica e analítica
    subplot(3, 2, 1);
    plot(xn, uh, 'o-k', x, u, 'R'); % Comparação numérica e analítica
    grid on; 
    xlabel('Posição x [m]'); 
    ylabel('Deslocamento [m]');
    title(sprintf('%d elementos', nel));
    legend('Numérico', 'Analítico');

    % Subplot 2: Erro absoluto do deslocamento
    subplot(3, 2, 2);
    plot(x, erro_absoluto_u, '-g', 'LineWidth', 1.25);
    grid on; 
    xlabel('Posição x [m]'); 
    ylabel('Erro Absoluto [m]');
    title(sprintf('Norma L2: %.4e', normas_euclidianas_u(n_idx)));

    % Deformação
    % Subplot 3: Deformação - Comparação numérica e analítica
    subplot(3, 2, 3);
    plot(xc, def, 'x-k', x, dudx, 'y'); % Comparação numérica e analítica
    grid on; 
    xlabel('Posição x [m]'); 
    ylabel('Deformação');
    title(sprintf('%d elementos', nel));
    legend('Numérico', 'Analítico');

    % Subplot 4: Erro absoluto da deformação
    subplot(3, 2, 4);
    plot(x, erro_absoluto_def, '-g', 'LineWidth', 1.25);
    grid on; 
    xlabel('Posição x [m]'); 
    ylabel('Erro Absoluto');
    title(sprintf('Norma L2: %.3e', normas_euclidianas_def(n_idx)));

    % Tensão
    % Subplot 5: Tensão - Comparação numérica e analítica
    subplot(3, 2, 5);
    bar((xn(1:end-1) + xn(2:end)) / 2, Ten, 'FaceColor', 'k'); % Tensão numérica
    grid on; 
    hold on; 
    plot(x, sigma, '-b');
    xlabel('Posição [m]'); 
    ylabel('Tensão [Pa]');
    title(sprintf('(%d elementos)', nel));
    legend('Numérico', 'Analítico');

    % Subplot 6: Erro absoluto da tensão
    subplot(3, 2, 6);
    plot(x, erro_absoluto_ten, '-g', 'LineWidth', 1.25);
    grid on; 
    xlabel('Posição x [m]'); 
    ylabel('Erro Absoluto [Pa]');
    title(sprintf('Norma L2: %.3e', normas_euclidianas_ten(n_idx)));

end

%% Impressão dos erros euclidianos
% Erros no deslocamento
fprintf('Erros Euclidianos de Deslocamento:\n');
for n_idx = 1:subplot_length
    nel = nels(n_idx);
    fprintf('Número de elementos: %d, Erro Euclidiano: %.10e\n', nel, normas_euclidianas_u(n_idx));
end

fprintf('%s\n', repmat('-', 1, 60));

% Erros na deformação
fprintf('Erros Euclidianos de Deformação:\n');
for n_idx = 1:subplot_length
    nel = nels(n_idx);
    fprintf('Número de elementos: %d, Erro Euclidiano: %.10e\n', nel, normas_euclidianas_def(n_idx));
end

fprintf('%s\n', repmat('-', 1, 60));

% Erros na tensão
fprintf('Erros Euclidianos de Tensão:\n');
for n_idx = 1:subplot_length
    nel = nels(n_idx);
    fprintf('Número de elementos: %d, Erro Euclidiano: %.10e\n', nel, normas_euclidianas_ten(n_idx));
end