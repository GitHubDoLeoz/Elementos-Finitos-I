% Definição de parâmetros
E = 210e9;  % Módulo de elasticidade do material (Pa)
A = pi * (0.015^2);  % Área da seção transversal da barra (m²)
L = 10.0;  % Comprimento da barra (m)
Po = 1e3;  % Carga máxima distribuída ao longo da barra (N/m)
x = linspace(0, L, 100);

% Definição de números de elementos
nels = [5, 10, 20, 40];

% Inicializa figuras para plotagem
figure;
subplot_length = length(nels);
erros_euclidianos = zeros(subplot_length, 1);

for nel_idx = 1:subplot_length
    nel = nels(nel_idx);
    nnos = nel + 1;  % Número de nós
    h = L / nel;  % Tamanho de cada elemento
    coord = linspace(0, L, nnos);  % Coordenadas dos nós
    inci = [(1:nel)', (2:nel+1)'];  % Incidências dos elementos

    % Cálculo da matriz de rigidez e vetor de forças de um elemento
    ke = (E * A / h) * [1 -1; -1 1];

    % Inicializa a matriz de rigidez global e o vetor de forças globais
    K = zeros(nnos, nnos);  % Matriz de rigidez global
    F = zeros(nnos, 1);  % Vetor de forças globais

    % Montagem da matriz de rigidez e vetor de forças globais
    for i = 1:nel
        no1 = inci(i, 1);
        no2 = inci(i, 2);
        loc = [no1, no2];
        K(loc, loc) = K(loc, loc) + ke;

        % Cálculo da carga distribuída triangular crescente da esquerda para a direita
        x1 = coord(no1);
        x2 = coord(no2);
        f1 = Po * x1 / L;  % Carga no nó inicial do elemento
        f2 = Po * x2 / L;  % Carga no nó final do elemento
        
        % Vetor de força nodal ponderado para a carga triangular
        fe = (h / 6) * [f1 + 2 * f2; 2 * f1 + f2];
        
        % Montagem no vetor global de forças
        F(no1) = F(no1) + fe(1);
        F(no2) = F(no2) + fe(2);
    end

    % Condição de contorno: fixar deslocamento u(0) = 0 no primeiro nó
    K(1, :) = 0;
    K(1, 1) = 1;
    F(1) = 0;

    % Condição de contorno: fixar deslocamento u(L) = 0 no último nó
    K(end, :) = 0;
    K(end, end) = 1;
    F(end) = 0;

    % Cálculo do deslocamento
    u = K \ F;

    % Cálculo da tensão interna (σ)
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
    u_interp = interp1(coord, u, x);

    % Cálculo do erro percentual no deslocamento
    erro_percentual = abs((ua - u_interp) ./ ua) * 100;

    % Cálculo da norma euclidiana do erro
    norma_erro = norm(ua - u_interp);

    % Adiciona o erro euclidiano ao vetor
    erros_euclidianos(nel_idx) = norma_erro;

    % Plotagem dos resultados
    subplot(subplot_length, 2, 2*nel_idx-1);
    plot(coord, u, 'o-k', 'DisplayName', 'Numérico');
    hold on;
    plot(x, ua, '-r', 'DisplayName', 'Analítico');
    title(sprintf('Deslocamento (%d elementos)', nel));
    xlabel('Posição (m)');
    ylabel('Deslocamento (m)');
    grid on;
    if nel_idx == 1
        legend('show');
    end

    subplot(subplot_length, 2, 2*nel_idx);
    bar((coord(1:end-1) + coord(2:end)) / 2, sigma, 'FaceColor', 'k', 'DisplayName', 'Numérico');
    hold on;
    plot(x, sigma_analitica, '-b', 'DisplayName', 'Analítico');
    title(sprintf('Tensão (%d elementos)', nel));
    xlabel('Posição (m)');
    ylabel('Tensão Interna (Pa)');
    grid on;
    if nel_idx == 1
        legend('show');
end

end

% Plotagem dos erros percentuais
figure;
hold on;
for nel_idx = 1:subplot_length
    nel = nels(nel_idx);
    nnos = nel + 1;
    h = L / nel;
    coord = linspace(0, L, nnos);
    inci = [(1:nel)', (2:nel+1)'];

    ke = (E * A / h) * [1 -1; -1 1];

    K = zeros(nnos, nnos);
    F = zeros(nnos, 1);

    for i = 1:nel
        no1 = inci(i, 1);
        no2 = inci(i, 2);
        loc = [no1, no2];
        K(loc, loc) = K(loc, loc) + ke;

        x1 = coord(no1);
        x2 = coord(no2);
        f1 = Po * x1 / L;
        f2 = Po * x2 / L;

        fe = (h / 6) * [f1 + 2 * f2; 2 * f1 + f2];

        F(no1) = F(no1) + fe(1);
        F(no2) = F(no2) + fe(2);
    end

    K(1, :) = 0;
    K(1, 1) = 1;
    F(1) = 0;

    K(end, :) = 0;
    K(end, end) = 1;
    F(end) = 0;

    u = K \ F;

    sigma = zeros(nel, 1);
    for i = 1:nel
        no1 = inci(i, 1);
        no2 = inci(i, 2);
        sigma(i) = E * (u(no2) - u(no1)) / h;
    end

    u_interp = interp1(coord, u, x);
    erro_percentual = abs((ua - u_interp) ./ ua) * 100;
    plot(x, erro_percentual, 'DisplayName', sprintf('%d elementos', nel));
end

xlabel('Posição (m)');
ylabel('Erro Percentual (%)');
legend('show');
grid on;

% Impressão dos erros euclidianos
fprintf('Erros Euclidianos:\n');
for nel_idx = 1:subplot_length
    nel = nels(nel_idx);
    fprintf('Número de elementos: %d, Erro Euclidiano: %.10e\n', nel, erros_euclidianos(nel_idx));
end