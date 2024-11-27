clc; clear all;

% Dados do problema 
E = 210e9;           % Módulo de elasticidade do material (Pa)
A = pi * (0.015^2);  % Área da seção transversal da barra (m²)
L = 10.0;            % Comprimento da barra (m)
p0 = 1e3;            % Carga máxima distribuída ao longo da barra (N/m)

nels = [5, 10, 20, 40];

%% Resolução
for nel_idx=1:length(nels)
    nel = nels(nel_idx);
    nnos = nel + 1;   % Número de nós
    h = L / nel;      % Comprimento de cada elemento
    coord = 0:h:L;    % Coordenadas dos nós
    inci = [[1:nnos-1]' [2:nnos]'];   % Conectividade dos elementos

    K = zeros(nnos, nnos);  % Matriz global de rigidez
    F = zeros(nnos, 1);     % Vetor global de forças

    KE = ((E * A) / h) * [1 -1; -1 1];  % Matriz de rigidez local do elemento

    for i = 1:nel
        FE = ((((p0/L)*coord(i)*h)/ 2) * [1; 1]) + (((((((p0/L)*coord(i+1))-((p0/L)*coord(i)))*h)/2)/ 3)* [1; 2]); % Vetor de força nodal equivalente local
        no1 = inci(i,1);
        no2 = inci(i,2);
        loc = [no1 no2];
        K(loc, loc) = K(loc, loc) + KE;
        F(loc,1) = F(loc,1) + FE;
    end 

    % Condições de contorno
    fixed_dofs = [1, nnos];
    free_dofs = setdiff(1:nnos, fixed_dofs);

    % Resolver o sistema para os graus de liberdade livres
    u = zeros(nnos, 1);
    u(free_dofs) = K(free_dofs, free_dofs) \ F(free_dofs);

    FR = K*u;
    T = zeros(nel, 1);

    % Pré-alocar o vetor coord_mid para os pontos médios de cada elemento
    coord_mid = zeros(1, nel); 

    % Calcular as coordenadas dos pontos médios
    for i = 1:(nel)
        coord_mid(i) = (coord(i) + ((coord(i+1)- coord(i)) / 2));
    end

    % Calculo das tensões dentro de cada elemento
    somaF = 0;
    for j = 1:(nnos-1)
        somaF = somaF + FR(j);
        FIE = -somaF;
        TE = (FIE/A);
        T(j,1) = T(j,1) + TE; 
    end

    % Solução analítica para carga triangular 
    x = [0:h/10:L];
    ua = (1/(E*A))*(((-p0*x.^3)/(6*L))+((p0*L*x)/6));
    sxx = (((-p0*x.^2)/(2*L))+((p0*L)/6))/A;

    %% ERROS 
    % ERROS DO DESLOCAMENTO INTERPOLANDO PELAS FUNÇÕES DE FORMA DO ELEMENTO
    % Interpolar a solução numérica para 10 pontos dentro de cada elemento
    u_interp = zeros((nnos*10)-10,1);
    t_interp = zeros((nnos*10)-10,1);

    % Loop sobre cada elemento
    for i = 1:nel
        no1 = inci (i,1);
        no2 = inci (i,2);

        % Deslocamentos nos nós do elemento
        u1 = u(no1);
        u2 = u(no2);

        % Gera pontos internos igualmente espaçados no elemento
        xx = linspace(h/10, h-(h/10), 9);

        for j = 1:9

        %Tensão e deformação dentro do elemento
        t_interpele = T(i);
        t_interp (((no1-1)*10)+(1+j)) =  t_interpele;
        t_interp ((no2*10)-9) =  t_interpele;
        t_interp(1) =  T(1);

        % Funções de forma para o deslocamento
        N1 = ((h) - xx(j)) / h;
        N2 = xx(j) / h;

        % Interpolação dos deslocamentos para os pontos internos
        u_interpele = N1 * u1 + N2 * u2;
        u_interp (((no1-1)*10)+(1+j)) =  u_interpele;
        end
        u_interp (((no1-1)*10)+11) =  u(no2);
    end

    % Calcular o erro absoluto nos pontos de interpolação
    erro_absolut = abs(ua - u_interp');
    erro_absolut2 = abs(sxx - t_interp');

    % Calcular o erro relativo em porcentagem nos pontos de interpolação
    erro_percent = (erro_absolut ./ ua) * 100;
    erro_percent2 = (erro_absolut2 ./ sxx) * 100;

    % Cálculo da norma euclidiana dos erros
    erro_euclidiano1 = norm(erro_absolut);
    titulo1 = sprintf('Norma L2: %.4e', erro_euclidiano1);
    erro_euclidiano2 = norm(erro_absolut2);
    titulo2 = sprintf('Norma L2: %.4e', erro_euclidiano2);

    %% Plotagem
    % Plotagem dos resultados dos deslocamentos
    figure(1);
    subplot(length(nels), 3, 3*nel_idx-2);
    plot(coord, u, 'o-k', 'DisplayName', 'Numérico'); hold on;
    plot(x, ua, '-r', 'DisplayName', 'Analítico');
    xlabel('Posição [m]'); ylabel('Deslocamento [m]');
    title(sprintf('(%d elementos)', nel)); grid on;
    if nel_idx == 1
        legend('show');
    end

    subplot(length(nels), 3, 3*nel_idx-1);
    plot(x, erro_percent, '-b', 'LineWidth', 1.25); 
    title('Erro Percentual'); grid on;
    xlabel('Posição x [m]'); ylabel('Erro [%]'); hold on;

    subplot(length(nels), 3, 3*nel_idx);
    plot(x, erro_absolut, '-g', 'LineWidth', 1.25); 
    title (titulo1); grid on;
    xlabel('Posição x [m]'); ylabel('Erro Absoluto [m]');
    hold on   

    % Plotagem dos resultados das tensões
    figure(2);
    subplot(length(nels), 3, 3*nel_idx-2);
    bar((coord(1:end-1) + coord(2:end)) / 2, T, 'FaceColor', 'k'); 
    hold on; plot(x, sxx, '-b'); 
    xlabel('Posição [m]'); ylabel('Tensão [Pa]');
    title(sprintf('(%d elementos)', nel)); grid on;
    if nel_idx == 1
        legend('Numérico', 'Analítico');
    end

    subplot(length(nels), 3, 3*nel_idx-1);
    plot(x, erro_percent2, '-b', 'LineWidth', 1.25); 
    title('Erro Percentual'); grid on;
    xlabel('Posição x [m]'); ylabel('Erro [%]');
    hold on;

    subplot(length(nels), 3, 3*nel_idx);
    plot(x, erro_absolut2, '-g', 'LineWidth', 1.25); 
    grid on;
    title (titulo2);
    xlabel('Posição x [m]'); ylabel('Erro Absoluto [Pa]');
    hold off;
end