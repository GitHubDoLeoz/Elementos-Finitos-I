%% Definição de parâmetros
E = 210e9;           % Módulo de elasticidade do material (Pa)
A = pi * (0.015^2);  % Área da seção transversal da barra (m²)
L = 10.0;            % Comprimento da barra (m)
Po = 1e3;            % Carga máxima distribuída ao longo da barra (N/m)
x = linspace(0, L, 1000);

% Definição de números de elementos
nels = [5, 10, 20, 40];

% Matrizes para armazenar os erros percentuais
subplot_length = length(nels);
erros_euclidianos_deslocamento = zeros(subplot_length, 1);
erros_euclidianos_tensao = zeros(subplot_length, 1);
erros_percentuais_deslocamento = zeros(subplot_length, length(x));
erros_percentuais_tensao = zeros(subplot_length, length(x));

%% Loop para diferentes números de elementos
for nel_idx = 1:subplot_length
    nel = nels(nel_idx);
    nnos = nel + 1;
    h = L / nel;
    coord = linspace(0, L, nnos);
    inci = [(1:nel)', (2:nel+1)'];

    % Cálculo da matriz de rigidez e vetor de forças de um elemento
    ke = (E * A / h) * [1 -1; -1 1];

    % Inicializa a matriz de rigidez global e o vetor de forças globais
    K = zeros(nnos, nnos);
    F = zeros(nnos, 1);

    % Montagem da matriz de rigidez e vetor de forças globais
    for i = 1:nel
        no1 = inci(i, 1);
        no2 = inci(i, 2);
        loc = [no1, no2];
        K(loc, loc) = K(loc, loc) + ke;

        % Cálculo da carga distribuída triangular
        x1 = coord(no1);
        x2 = coord(no2);
        f1 = Po * x1 / L;
        f2 = Po * x2 / L; 
        fe = (h / 6) * [f1 + 2 * f2; 2 * f1 + f2];
        F(no1) = F(no1) + fe(1);
        F(no2) = F(no2) + fe(2);
    end

    % Condições de contorno
    K([1 end], :) = 0; 
    K(1, 1) = 1; F(1) = 0; 
    K(end, end) = 1; F(end) = 0;

    % Cálculo do deslocamento
    u = K \ F;

    % Cálculo da tensão (σ)
    sigma = zeros(nel, 1);
    for i = 1:nel
        no1 = inci(i, 1);
        no2 = inci(i, 2);
        sigma(i) = E * (u(no2) - u(no1)) / h;
    end

    % Cálculo da solução analítica para carga triangular
    ua = Po / (6 * E * A * L) * (L.^2 * x - x.^3);
    duadx = Po * (L.^2 - 3 * x.^2) / (6 * E * A * L);
    Nxa = E * A * duadx;
    sigma_analitica = Nxa / A;

    % Interpolação da solução numérica para os pontos analíticos
    centroides = (coord(1:end-1) + coord(2:end)) / 2;
    u_interp = interp1(coord, u, x);
    sxx_interp = interp1(centroides, sigma, x, 'linear', 'extrap');

    % Cálculo do erro percentual no deslocamento
    erro_percentual_deslocamento = abs((ua - u_interp) ./ ua) * 100;
    erro_absoluto_deslocamento = abs(ua - u_interp);
    erros_percentuais_deslocamento(nel_idx, :) = erro_percentual_deslocamento;
    
    % Cálculo do erro percentual na tensão
    erro_percentual_tensao = abs((sigma_analitica - sxx_interp) ./ sigma_analitica) * 100;
    erro_absoluto_tensao = abs(sigma_analitica - sxx_interp);
    erros_percentuais_tensao(nel_idx, :) = erro_percentual_tensao;

    % Cálculo da norma euclidiana do erro
    norma_erro_deslocamento = norm(ua - u_interp);
    norma_erro_tensao = norm(sigma_analitica - sxx_interp);

    % Adiciona o erro euclidiano ao vetor
    erros_euclidianos_deslocamento(nel_idx) = norma_erro_deslocamento;
    erros_euclidianos_tensao(nel_idx) = norma_erro_tensao;

    % Plotagem dos resultados dos deslocamentos
    figure(1);
    subplot(length(nels), 3, 3*nel_idx-2);
    plot(coord, u, 'o-k', 'DisplayName', 'Numérico');
    hold on;
    plot(x, ua, '-r', 'DisplayName', 'Analítico');
    title(sprintf('(%d elementos)', nel));
    xlabel('Posição [m]'); ylabel('Deslocamento [m]');
    grid on;
    if nel_idx == 1
        legend('show');
    end

    % Plotagem dos resultados
    figure(1);
    subplot(length(nels), 3, 3*nel_idx-2);
    plot(coord, u, 'o-k', x, ua, '-r'); xlabel('Posição [m]'); ylabel('Deslocamento [m]');
    title(sprintf('(%d elementos)', nel)); grid on;
    if nel_idx == 1
        legend('Numérico', 'Analítico');
    end

    subplot(length(nels), 3, 3*nel_idx-1);
    plot(x, erros_percentuais_deslocamento(nel_idx, :), '-b', 'LineWidth', 1.25); xlabel('Posição x [m]'); ylabel('Erro [%]');
    title('Erro Percentual'); grid on;

    subplot(length(nels), 3, 3*nel_idx);
    plot(x, abs(ua - u_interp), '-g', 'LineWidth', 1.25); xlabel('Posição x [m]'); ylabel('Erro Absoluto [m]');
    title(sprintf('Norma L2: %.4e', erros_euclidianos_deslocamento(nel_idx))); grid on;
    
    % Tensão
    figure(2);
    subplot(length(nels), 3, 3*nel_idx-2);
    bar((coord(1:end-1) + coord(2:end)) / 2, sigma, 'FaceColor', 'k'); 
    hold on; plot(x, sigma_analitica, '-b'); xlabel('Posição [m]'); ylabel('Tensão [Pa]');
    title(sprintf('(%d elementos)', nel)); grid on;
    if nel_idx == 1
        legend('Numérico', 'Analítico');
    end

    subplot(length(nels), 3, 3*nel_idx-1);
    plot(x, erros_percentuais_tensao(nel_idx, :), '-b', 'LineWidth', 1.25); xlabel('Posição x [m]'); ylabel('Erro [%]');
    title('Erro Percentual'); grid on;

    subplot(length(nels), 3, 3*nel_idx);
    plot(x, abs(sigma_analitica - sxx_interp), '-g', 'LineWidth', 1.25); xlabel('Posição x [m]'); ylabel('Erro Absoluto [Pa]');
    title(sprintf('Norma L2: %.4e', erros_euclidianos_tensao(nel_idx))); grid on;
end

%% Impressão dos erros euclidianos
% Deslocamento
fprintf('Erros Euclidianos de Deslocamento:\n');
for nel_idx = 1:subplot_length
    nel = nels(nel_idx);
    fprintf('Número de elementos: %d, Erro Euclidiano: %.10e\n', nel, erros_euclidianos_deslocamento(nel_idx));
end

fprintf('%s\n', repmat('-', 1, 65));

% Tensão
fprintf('Erros Euclidianos de Tensão:\n');
for nel_idx = 1:subplot_length
    nel = nels(nel_idx);
    fprintf('Número de elementos: %d, Erro Euclidiano: %.10e\n', nel, erros_euclidianos_tensao(nel_idx));
end