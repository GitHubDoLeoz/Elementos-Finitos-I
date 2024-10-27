% ========================================================================
% Análise Numérica de uma Barra com Carga Pontual
% ========================================================================

close all; clear all; clc;

%% Entrada de dados
L = 10;                 % Comprimento total da barra (m)
E = 210e9;              % Módulo de elasticidade (Pa)
b = 0.03;               % Largura da barra (m)
h = 0.04;               % Altura da barra (m)
Ao = b * h;             % Área na seção transversal no ponto x = 0 (m²)
F = 1e3;                % Carga pontual na extremidade direita (N)
nels = [5, 10, 20, 40]; % Diferentes números de elementos

% Inicialização para armazenar normas euclidianas dos erros
subplot_length = length(nels);
normas_euclidianas_u = zeros(subplot_length, 1);
normas_euclidianas_ten = zeros(subplot_length, 1);

%% Loop para diferentes números de elementos
for n_idx = 1:subplot_length
    nel = nels(n_idx);
    nnos = nel + 1;
    he = L / nel;
    xn = linspace(0, L, nnos);
    inci = [(1:nnos-1)', (2:nnos)'];

    %% Montagem da matriz de Rigidez
    Kg = zeros(nnos);
    Fg = zeros(nnos, 1);
    uh = zeros(nnos, 1);
    Ten = zeros(nel, 1);

    % Montagem da matriz de rigidez global
    for e = 1:nel
        % Coordenadas do elemento
        x1 = xn(inci(e, 1));
        x2 = xn(inci(e, 2));

        % Áreas nos pontos x1 e x2 (variação linear)
        A1 = Ao * (3 - (2 * x1 / L));
        A2 = Ao * (3 - (2 * x2 / L));

        % Rigidez do elemento
        ke = (E / (x2 - x1)) * [(A1 + A2) / 2, -(A1 + A2) / 2; -(A1 + A2) / 2, (A1 + A2) / 2];

        % Montagem na matriz global
        Kg(inci(e,:), inci(e,:)) = Kg(inci(e,:), inci(e,:)) + ke;
    end

    % Aplicar força concentrada em x = L
    Fg(end, 1) = F;

    % Aplicar as condições de contorno (u(0) = 0)
    freedofs = 2:nnos;
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
        du_dx = (ue(2) - ue(1)) / Le;

        % Cálculo da tensão numérica
        Ten(e) = E * du_dx;
    end

    %% Solução analítica
    x = linspace(0, L, 1000);
    A_x = Ao * (3 - (2 * x / L));
    u = -(F * L / (2 * E * Ao)) * log(1 - (2 * x / (3 * L)));
    dudx = (F * L) ./ (Ao * E * (3 * L - 2 * x));
    Nx = E * Ao * dudx;
    sigma = Nx / Ao;

    %% Cálculo do erro percentual
    % Erro no deslocamento
    uh_interp = interp1(xn, uh, x, 'linear', 'extrap');
    erro_percentual_u = abs((u - uh_interp) ./ u) * 100;
    erro_absoluto_u = abs(u - uh_interp);
    normas_euclidianas_u(n_idx) = sqrt(trapz(x, erro_absoluto_u.^2));

    % Erro na tensão
    sigma_interp = interp1(xc, Ten, x, 'linear', 'extrap'); % Interpolação da tensão numérica
    erro_percentual_ten = abs((sigma - sigma_interp) ./ sigma) * 100; % Erro percentual
    erro_absoluto_ten = abs(sigma - sigma_interp); % Erro absoluto
    normas_euclidianas_ten(n_idx) = sqrt(trapz(x, erro_absoluto_ten.^2)); % Norma euclidiana do erro

    %% Gráficos
    % Deslocamentos
    figure(1);
    subplot(length(nels), 3, 3*n_idx-2);
    plot(xn, uh, 'o-k', x, u, 'R'); % Comparação numérica e analítica
    grid on; xlabel('Posição x [m]'); ylabel('Deslocamento [m]');
    title(sprintf('%d elementos', nel));
    if n_idx == 1
        legend('Numérico', 'Analítico');
    end
        
    % Erro percentual no deslocamento
    subplot(length(nels), 3, 3*n_idx-1);
    plot(x, erro_percentual_u, '-b', 'LineWidth', 1.25);
    grid on; xlabel('Posição x [m]'); ylabel('Erro [%]');
    title('Erro Percentual');
    
    % Erro absoluto com norma L2 no deslocamento
    subplot(length(nels), 3, 3*n_idx);
    plot(x, erro_absoluto_u, '-g', 'LineWidth', 1.25);
    grid on; xlabel('Posição x [m]'); ylabel('Erro Absoluto [m]');
    title(sprintf('Norma L2: %.4e', normas_euclidianas_u(n_idx)));

    % Tensão
    figure(2);
    subplot(length(nels), 3, 3*n_idx-2);
    bar((xn(1:end-1) + xn(2:end)) / 2, Ten, 'FaceColor', 'k'); % Tensão numérica
    grid on; hold on; 
    plot(x, sigma, '-b'); % Tensão analítica
    xlabel('Posição [m]'); ylabel('Tensão [Pa]');
    title(sprintf('(%d elementos)', nel));
    if n_idx == 1
        legend('Numérico', 'Analítico');
    end
    
    % Erro percentual na tensão
    subplot(length(nels), 3, 3*n_idx-1);
    plot(x, erro_percentual_ten, '-b', 'LineWidth', 1.25);
    grid on; xlabel('Posição x [m]'); ylabel('Erro [%]');
    title('Erro Percentual');
    
    % Erro absoluto com norma L2 na tensão
    subplot(length(nels), 3, 3*n_idx);
    plot(x, erro_absoluto_ten, '-g', 'LineWidth', 1.25);
    grid on; xlabel('Posição x [m]'); ylabel('Erro Absoluto [Pa]');
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

% Erros na tensão
fprintf('Erros Euclidianos de Tensão:\n');
for n_idx = 1:subplot_length
    nel = nels(n_idx);
    fprintf('Número de elementos: %d, Erro Euclidiano: %.10e\n', nel, normas_euclidianas_ten(n_idx));
end