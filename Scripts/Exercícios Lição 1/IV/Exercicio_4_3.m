close all
clear all
clc

%% Entrada de dados
L = 10;                % comprimento total da Barra
E = 210e9;
b = 0.03;
h = 0.04;              % altura da barra
Ao = b*h;              % area no ponto x = 0
F = 1e3;               % carga pontual na extremidade direita x=L
n_els = [5, 10, 20, 40]; % diferentes números de elementos

%% Loop para diferentes números de elementos
for n_idx = 1:length(n_els)
    nel = n_els(n_idx);  % numero de elementos
    nnos = nel + 1;      % numero de nos
    he = L / nel;        % comprimento do elemento
    xn = 0:he:L;         % coordenadas nos
    inci = [[1:nnos-1]' [2:nnos]']; % formacao dos elementos

    %% Montagem da matriz de Rigidez
    Kg = zeros(nnos);
    uh = zeros(nnos, 1);
    Fg = zeros(nnos, 1);

    % Montagem da matriz de rigidez global
    for e = 1:nel
        % Coordenadas do elemento
        x1 = xn(inci(e, 1));
        x2 = xn(inci(e, 2));

        % Áreas nos pontos x1 e x2
        A1 = Ao * (3 - (2 * x1 / L));
        A2 = Ao * (3 - (2 * x2 / L));

        % Rigidez do elemento com a área variando linearmente
        ke = (E / (x2 - x1)) * [(A1 + A2)/2, -(A1 + A2)/2; -(A1 + A2)/2, (A1 + A2)/2];

        % Montagem na matriz global
        Kg(inci(e,:), inci(e,:)) = Kg(inci(e,:), inci(e,:)) + ke;
    end

    % Aplicar força concentrada em x = L (último nó)
    Fg(end, 1) = F;

    % Aplicar as condições de contorno
    freedofs = 2:nnos;
    uh(freedofs, 1) = Kg(freedofs, freedofs) \ Fg(freedofs, 1);

    %% Pós-processamento
    xc = (xn(1:end-1) + xn(2:end)) / 2;  % Coordenadas médias dos elementos
    for e = 1:nel
        % Coordenadas dos nós do elemento
        x1 = xn(inci(e, 1));
        x2 = xn(inci(e, 2));
        Le = x2 - x1;

        % Deslocamentos nos nós do elemento
        ue = uh(inci(e, :));

        % Gradiente de deslocamento (du/dx) é constante para elementos lineares
        du_dx = (ue(2) - ue(1)) / Le;

        % Cálculo da tensão numérica
        Ten(e) = E * du_dx;
    end

    %% Solução analítica
    x = 0:he/5:L;
    A_x = Ao * (3 - (2 * x / L));
    u = -(F * L / (2 * E * Ao)) * log(1 - (2 * x / (3 * L)));
    dudx = (F * L) ./ (Ao * E * (3 * L - 2 * x));
    Nx = E * Ao * dudx;
    sigma = Nx / Ao;

    %% Cálculo do erro percentual
    u_analitica_interp = interp1(x, u, xn);
    sigma_analitica_interp = interp1(x, sigma, xc);

    % Cálculo do erro percentual no deslocamento
    erro_u = abs((uh' - u_analitica_interp) ./ u_analitica_interp) * 100;

    % Cálculo do erro percentual na tensão
    erro_sigma = abs((Ten - sigma_analitica_interp) ./ sigma_analitica_interp) * 100;

    %% Gráficos
    % Deslocamentos
    figure(1);
    subplot(2,2,n_idx);
    plot(xn, uh(:,1), 'o-k', x, u, 'R');
    legend('Numérica', 'Analítica');
    xlabel('Posicao x [m]');
    ylabel('Deslocamento u(x) [m]');
    title(sprintf('Deslocamento (%d elementos)', nel));
    grid on;

    % Tensão
    figure(2);
    subplot(2,2,n_idx);
    plot(xc, Ten, 'o-k', x, sigma, 'B');
    xlabel('Posicao x [m]');
    ylabel('Tensão (Pa)');
    legend('Numérica', 'Analítica');
    title(sprintf('Tensão (%d elementos)', nel));
    grid on;

    %% Gráficos dos erros
    % Erro de deslocamento
    figure(3);
    subplot(2,2,n_idx);
    plot(xn, erro_u, '-o');
    xlabel('Posição x [m]');
    ylabel('Erro (%)');
    title(sprintf('Erro (%d elementos)', nel));
    grid on;

    % Erro de tensão
    figure(4);
    subplot(2,2,n_idx);
    plot(xc, erro_sigma, '-o');
    xlabel('Posição x [m]');
    ylabel('Erro (%)');
    title(sprintf('Erro (%d elementos)', nel));
    grid on;
end