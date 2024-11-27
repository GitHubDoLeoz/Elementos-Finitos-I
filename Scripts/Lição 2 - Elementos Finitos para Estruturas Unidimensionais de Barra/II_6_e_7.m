clc; clear all;

%% Parâmetros de entrada
E = 210e9;      % Módulo de elasticidade (Pa)
A0 = 0.001;     % Área na seção transversal no ponto x = 0 (m²)
AI = 3*A0;      % Área na seção transversal no ponto x = L (m²)
P0 = 2000;      % Carga distribuída
L = 3;          % Comprimento total da barra (m)
F = 0;          % Carga pontual na extremidade direita (N)

nels = [4, 8, 16, 32];

%% Resolução
for n_idx = 1:length(nels)
    nel = nels(n_idx);
    nnos = nel + 1;
    h = L / nel;
    coord = [0:h:L];
    inci = [[1:nnos-1]' [2:nnos]'];

    Kg = zeros(nnos, nnos);
    Fg = zeros(nnos, 1);

    % Montagem da matriz de rigidez global
    for e = 1:nel
        % Coordenadas do elemento
        x1 = coord(inci(e, 1));
        x2 = coord(inci(e, 2));

        % Áreas nos pontos x1 e x2 (variação linear)
        A1 = A0 * (3 - (2 * x1 / L));
        A2 = A0 * (3 - (2 * x2 / L));

        % Rigidez do elemento
        ke = (E / (x2 - x1)) * [(A1 + A2) / 2, -(A1 + A2) / 2; -(A1 + A2) / 2, (A1 + A2) / 2];
        fe = (P0 * h / 2) * [1; 1];

        % Montagem na matriz global
        Kg(inci(e,:), inci(e,:)) = Kg(inci(e,:), inci(e,:)) + ke;
        Fg(inci(e,:)) = Fg(inci(e,:)) + fe;
    end

    % Condições de contorno
    Fg(nnos) = Fg(nnos) + F;
    freedofs = 2:(nnos-1);

    % Inicializar vetor de deslocamento
    u = zeros(nnos, 1);
    u(freedofs) = Kg(freedofs, freedofs) \ Fg(freedofs);

    % Calcular forças nodais reativas
    FR = Kg * u;
    T = zeros(nel, 1);
    def = zeros(nel, 1);

    % Pré-alocar o vetor coord_mid para os pontos médios de cada elemento
    coord_mid = zeros(1, nel);

    % Calcular as coordenadas dos pontos médios
    for i = 1:nel
        coord_mid(i) = (coord(i) + ((coord(i+1) - coord(i)) / 2));
    end

    % Calculo das tensões dentro de cada elemento
    somaF = 0;
    for j = 1:(nnos-1)
        % Calculando a área média usando a função de área variável
        A1 = A0 * (3 - (2 * coord(j) / L));
        A2 = A0 * (3 - (2 * coord(j+1) / L));
        Am = (A1 + A2) / 2;

        % Cálculo da tensão
        somaF = somaF + FR(j);
        FIE = -somaF;
        Te = (FIE / Am);
        T(j,1) = Te;
        
        % Cálculo da deformação
        dfm = Te / E;
        def(j,1) = dfm;
    end

    % Solução analítica 
    x = [0:h/10:L];
    ua = (-P0 * L^2 / (4 * A0 * E)) * ((3 - (2 * x) / L) - 3 * log(3 - (2 * x) / L)) ...
        - ((3 * P0 * L / 2 - (P0 * L) / log(3)) * L / (2 * E * A0)) * log(3 - (2 * x) / L) ...
        + (P0 * L^2) / (4 * E * A0);

    % Cálculo da deformação
    dudx = (-P0 * L^2 / (4 * A0 * E)) * (-2 / L + 6 ./ (L * (3 - (2 * x) / L))) ...
        - ((3 * P0 * L / 2 - P0 * L / log(3)) * L / (2 * E * A0)) * (-2 ./ (L * (3 - (2 * x) / L)));
    
    % Cálculo da tensão
    sxx = dudx * E;

    %% ERROS 
    % ERROS DO DESLOCAMENTO INTERPOLANDO PELAS FUNÇÕES DE FORMA DO ELEMENTO
    u_interp = zeros((nnos * 10) - 10, 1);
    d_interp = zeros((nnos * 10) - 10, 1);
    t_interp = zeros((nnos * 10) - 10, 1);

    % Loop sobre cada elemento
    for i = 1:nel
        no1 = inci(i,1);
        no2 = inci(i,2);
        u1 = u(no1);
        u2 = u(no2);
        xx = linspace(h/10, h - (h/10), 9);

        for j = 1:9
            d_interpele = def(i);
            d_interp(((no1 - 1) * 10) + (1 + j)) = d_interpele;
            d_interp((no2 * 10) - 9) = d_interpele;
            d_interp(1) = def(1);
            
            t_interpele = T(i);
            t_interp(((no1 - 1) * 10) + (1 + j)) = t_interpele;
            t_interp((no2 * 10) - 9) = t_interpele;
            t_interp(1) = T(1);

            N1 = ((h) - xx(j)) / h;
            N2 = xx(j) / h;
            u_interpele = N1 * u1 + N2 * u2;
            u_interp(((no1 - 1) * 10) + (1 + j)) = u_interpele;
        end
        u_interp(((no1 - 1) * 10) + 11) = u(no2);
    end

    erro_absolut = abs(ua - u_interp');
    erro_absolut2 = abs(sxx - t_interp');
    erro_absolut3 = abs(dudx - d_interp');
    erro_euclidiano1 = norm(erro_absolut);
    erro_euclidiano2 = norm(erro_absolut2);
    erro_euclidiano3 = norm(erro_absolut3);

    %% Plotagem
    % Deslocamento
    figure(1);
    subplot(length(nels), 2, 2*n_idx-1);
    plot(coord, u, 'o-k', x, ua, '-r');
    grid on; xlabel('Posição x [m]'); ylabel('Deslocamento [m]');
    title(sprintf('%d elementos', nel));
    if n_idx == 1
        legend('Numérico', 'Analítico');
    end

    subplot(length(nels), 2, 2*n_idx);
    plot(x, erro_absolut, '-g', 'LineWidth', 1.25); 
    title(sprintf('Norma L2: %.4e', erro_euclidiano1)); grid on;
    xlabel('Posição x [m]'); ylabel('Erro Absoluto [m]'); hold on;

    % Deformação
    figure(2);
    subplot(length(nels), 2, 2*n_idx-1);
    plot(coord_mid, def, 'x-k', x, dudx, 'y'); hold on; grid on;
    xlabel('Posição [m]'); ylabel('Deformação');
    title(sprintf('(%d elementos)', nel));
    if n_idx == 1
        legend('Numérico', 'Analítico');
    end

    subplot(length(nels), 2, 2*n_idx);
    plot(x, erro_absolut3, '-g', 'LineWidth', 1.25); 
    title(sprintf('Norma L2: %.4e', erro_euclidiano3)); grid on;
    xlabel('Posição x [m]'); ylabel('Erro Absoluto');
    hold off;
    
    % Tensão
    figure(3);
    subplot(length(nels), 2, 2*n_idx-1);
    bar((coord(1:end-1) + coord(2:end)) / 2, T, 'FaceColor', 'k'); hold on;
    plot(x, sxx, '-b'); grid on;
    xlabel('Posição [m]'); ylabel('Tensão [Pa]');
    title(sprintf('(%d elementos)', nel));
    if n_idx == 1
        legend('Numérico', 'Analítico');
    end

    subplot(length(nels), 2, 2*n_idx);
    plot(x, erro_absolut2, '-g', 'LineWidth', 1.25); 
    title(sprintf('Norma L2: %.4e', erro_euclidiano2)); grid on;
    xlabel('Posição x [m]'); ylabel('Erro Absoluto [Pa]');
    hold off;
end