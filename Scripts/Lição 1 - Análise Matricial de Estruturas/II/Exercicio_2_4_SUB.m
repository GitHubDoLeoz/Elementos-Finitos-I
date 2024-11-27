clc; clear all; close all;

%% Dados do problema 
E = 68e9;                 % Módulo de elasticidade (Pa)
A = pi * (0.05^2);        % Área da seção transversal (m²)
L = 2.0;                  % Comprimento da barra (m)
p0 = 3000;                % Carga máxima distribuída (N/m)

nels = [5, 10, 20, 40];
erro_euclidiano = zeros(1, length(nels));

%% Resolução 
for nel_idx = 1:length(nels)
    nel = nels(nel_idx);
    nnos = nel + 1;
    h = L / nel;
    coord = [0:h:L];
    inci = [[1:nnos-1]' [2:nnos]'];

    ke = zeros(2);
    fe = zeros(2, 1);
    K = zeros(nnos, nnos);
    F = zeros(nnos, 1);

    ke = ((E*A) / h) * [1 -1; -1 1];
    fe = (p0 * h / 2) * [1; 1];
    u = zeros(nnos, 1);

    % Montar a matriz de rigidez e o vetor de forças globais
    for i = 1:nel
        no1 = inci(i, 1);
        no2 = inci(i, 2);
        loc = [no1 no2];
        K(loc, loc) = K(loc, loc) + ke;

        % Cálculo das forças nodais equivalentes considerando carga distribuída triangular
        x1 = coord(no1);
        x2 = coord(no2);
        f1 = p0 * (x1 / L);
        f2 = p0 * (x2 / L);
        
        % Calcular força nodal exata através da integração da carga distribuída
        fe = (h / 6) * [2*f1 + f2; f1 + 2*f2];
        F(no1) = F(no1) + fe(1); 
        F(no2) = F(no2) + fe(2);
    end

    % Condições de contorno
    freedofs = [2:nnos];
    u(freedofs, 1) = K(freedofs, freedofs) \ F(freedofs, 1);

    % Solução analítica 
    x = [0:h/10:L];
    ua = (p0 / (6*E*A*L)) * x .* (3*L^2 - x.^2);

    % Interpolar a solução numérica para 10 pontos dentro de cada elemento
    u_interp = zeros((nnos*10)-10, 1);

    % Loop sobre cada elemento
    for i = 1:nel
        no1 = inci(i, 1);
        no2 = inci(i, 2);
        % Deslocamentos nos nós do elemento
        u1 = u(no1);
        u2 = u(no2);

        % Gera pontos internos igualmente espaçados no elemento
        xx = linspace(h / 10, h - (h / 10), 9);

        for j = 1:9
            % Funções de forma
            N1 = (h - xx(j)) / h;
            N2 = xx(j) / h;

            % Interpolação dos deslocamentos para os pontos internos
            u_interpele = N1 * u1 + N2 * u2;
            u_interp(((no1 - 1) * 10) + (1 + j)) = u_interpele;
        end

        u_interp(((no1 - 1) * 10) + 11) = u(no2);
    end

    % Calcular o erro absoluto nos pontos de interpolação
    erro_absolut = abs(ua - u_interp.');

    % Calcular o erro relativo em porcentagem nos pontos de interpolação
    erro_percent = (erro_absolut ./ ua) * 100;

    % Cálculo da norma euclidiana dos erros
    erro_euclidiano(nel_idx) = norm(erro_absolut);
    titulo1 = sprintf('Norma L2: %.3e', erro_euclidiano(nel_idx));
    
    %% Plotagem
    % Plotar os resultados para o valor atual de nel
    subplot(length(nels), 3, 3*nel_idx - 2);
    plot(coord, u, 'o-k', x, ua, '-r'); 
    grid on;
    xlabel('Posição [m]'); ylabel('Deslocamento [m]');
    title(sprintf('%d elementos', nel));
    if nel_idx == 1
        legend('Numérico', 'Analítico');
    end

    % Plotar o gráfico de erros percentuais
    subplot(length(nels), 3, 3*nel_idx - 1);
    plot(x, erro_percent, '-b', 'LineWidth', 1.25);
    title('Erro Percentual');
    xlabel('Posição [m]'); ylabel('Erro [%]');
    grid on;

    % Plotar o gráfico de erros absolutos
    subplot(length(nels), 3, 3*nel_idx);
    plot(x, erro_absolut, '-g', 'LineWidth', 1.25);
    grid on;
    title(titulo1);
    xlabel('Posição [m]'); ylabel('Erro Absoluto [m]');
end

% Exibir normas euclidianas dos erros
disp('Normas Euclidianas dos Erros:');
for nel_idx = 1:length(nels)
    fprintf('Para %d elementos: %.4e\n', nels(nel_idx), erro_euclidiano(nel_idx));
end

% Plotar a análise de convergência
figure;
loglog(nels, erro_euclidiano, 'o-m', 'LineWidth', 1.5);
xlabel('Número de Elementos'); ylabel('Norma Euclidiana dos Erros');
title('Análise de Convergência');
grid on;

% Adicionar texto com os valores dos erros nas bolinhas
for nel_idx = 1:length(nels)
    text(nels(nel_idx), erro_euclidiano(nel_idx), ...
        sprintf('%.3e', erro_euclidiano(nel_idx)), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
end
hold off;