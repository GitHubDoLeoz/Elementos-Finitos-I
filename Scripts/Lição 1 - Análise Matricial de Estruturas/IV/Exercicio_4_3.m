clc; clear all;

%% Parâmetros de entrada
E = 210e9;      % Módulo de elasticidade (Pa)
A0 = 0.03*0.04; % Área na seção transversal no ponto x = 0 (m²)
AI = 3*A0;      % Área na seção transversal no ponto x = L (m²)
P0 = 0;         % Carga distribuída
L = 10;         % Comprimento total da barra (m)
F = 1000;       % Carga pontual na extremidade direita (N)
nels = [5, 10, 20, 40];

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

        % Montagem na matriz global
        Kg(inci(e,:), inci(e,:)) = Kg(inci(e,:), inci(e,:)) + ke;
    end

    % Condições de contorno
    Fg(nnos) = Fg(nnos) + F;
    freedofs = [2:nnos];

    % Resolvendo o sistema de equações para deslocamento
    u = zeros(nnos, 1);
    u(freedofs,1) = Kg(freedofs,freedofs) \ Fg(freedofs,1);

    % Resolvendo o sistema de equações para tensões
    FR = Kg*u;
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
        Am = ((((-0.2)*A0*coord(j)) + AI) + (((-0.2)*A0*coord(j+1)) + AI)) / 2;
        somaF = somaF + FR(j);
        FIE = -somaF;
        TE = (FIE/Am);
        T(j,1) = T(j,1) + TE; 
    end

    % Solução analítica 
    x = [0:h/10:L];
    ua = ((-F*L)/(2*A0*E))*log(1 - (2*x / (3*L)));
    sxx = (F / (3 * A0)) ./ (1 - (2 * x / (3 * L)));

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
    figure(1);
    subplot(length(nels), 3, 3*n_idx-2);
    plot(coord, u, 'o-k', x, ua, '-R');
    grid on; xlabel('Posição x [m]'); ylabel('Deslocamento [m]');
    title(sprintf('%d elementos', nel));
    if n_idx == 1
        legend('Numérico', 'Analítico');
    end

    % Erro percentual no deslocamento
    subplot(length(nels), 3, 3*n_idx-1);
    plot(x, erro_percent, '-b', 'LineWidth', 1.25); 
    grid on; xlabel('Posição x [m]'); ylabel('Erro [%]');
    title('Erro Percentual'); hold on;

    % Erro absoluto com norma L2 no deslocamento
    subplot(length(nels), 3, 3*n_idx);
    plot(x, erro_absolut, '-g', 'LineWidth', 1.25); 
    title (titulo1); grid on;
    xlabel('Posição x [m]'); ylabel('Erro Absoluto [m]'); hold on;

    % Plotagem 
    figure(2);
    subplot(length(nels), 3, 3*n_idx-2);
    bar((coord(1:end-1) + coord(2:end)) / 2, T, 'FaceColor', 'k'); hold on;
    plot(x, sxx, '-b'); grid on;
    xlabel('Posição [m]'); ylabel('Tensão [Pa]');
    title(sprintf('(%d elementos)', nel));
    if n_idx == 1
        legend('Numérico', 'Analítico');
    end

    % Erro percentual na tensão
    subplot(length(nels), 3, 3*n_idx-1);
    plot(x, erro_percent2, '-b', 'LineWidth', 1.25); 
    grid on; xlabel('Posição x [m]'); ylabel('Erro [%]');
    title('Erro Percentual'); hold on;

    % Erro absoluto com norma L2 na tensão
    subplot(length(nels), 3, 3*n_idx);
    plot(x, erro_absolut2, '-g', 'LineWidth', 1.25); 
    title (titulo2); grid on;
    xlabel('Posição x [m]'); ylabel('Erro Absoluto [Pa]');
    hold off;
 end