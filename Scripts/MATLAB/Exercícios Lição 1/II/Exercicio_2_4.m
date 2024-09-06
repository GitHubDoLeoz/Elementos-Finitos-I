clc;
clear;
close all;

% Parâmetros de entrada
E = 210e6;    % Módulo de elasticidade (Pa)
A = pi * (0.015^2);  % Área da seção transversal (m²)
L = 2;       % Comprimento da barra (m)
Po = 1e3;    % Carga máxima distribuída (N/m)
nels = [5, 10, 20, 40];  % Diferentes discretizações
ubs = [0.0025, 0.005, 0.0075, 0.01, 0.025]; % Diferentes valores de deslocamento

% Função para calcular a norma euclidiana dos erros
norma_euclidiana_erro = @(e, L) sqrt(integral(@(x) e(x).^2, 0, L));

% Loop para cada valor de deslocamento prescrito
for ub_idx = 1:length(ubs)
    ub = ubs(ub_idx);
    
    figure;
    sgtitle(['Comparação de Deslocamentos e Esforços Internos para ub = ', num2str(ub), ' m']);
    
    % Loop para cada valor de nel
    for nel_idx = 1:length(nels)
        nel = nels(nel_idx);
        
        % Calcular coordenadas dos nós e incidências dos elementos
        nnos = nel + 1;  % Número de nós
        h = L / nel;     % Tamanho de cada elemento
        coord = linspace(0, L, nnos);  % Coordenadas dos nós
        inci = [(1:nel)' (2:nnos)'];   % Incidências dos elementos
        
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
            
            % Cálculo da carga distribuída triangular
            x1 = coord(no1);
            x2 = coord(no2);
            f1 = Po * x1 / L;
            f2 = Po * x2 / L;
            fe = (h / 6) * [f1 + 2*f2; 2*f1 + f2];
            F(no1) = F(no1) + fe(1);
            F(no2) = F(no2) + fe(2);
        end
        
        % Condições de contorno
        K(1, :) = 0;
        K(1, 1) = 1;
        F(1) = 0;
        K(end, :) = 0;
        K(end, end) = 1;
        F(end) = ub;
        
        % Resolver o sistema linear para obter os deslocamentos
        u = K \ F;
        
        % Calcular o esforço interno (Nx)
        Nx = zeros(nel, 1);
        for i = 1:nel
            no1 = inci(i, 1);
            no2 = inci(i, 2);
            Nx(i) = E * A / h * (u(no2) - u(no1));
        end
        
        % Solução analítica
        x = linspace(0, L, 100);
        ua = (-Po * x.^3) / (6 * E * A * L) + ((ub + (Po * L^2) / (6 * E * A)) / L) * x;
        Nxa = (-Po * x.^2) / (2 * L) + ((ub * E * A + (Po * L^2) / 6) / L);
        
        % Interpolação dos resultados numéricos
        u_interp = interp1(coord, u, x);
        erro_percentual = abs((ua - u_interp) ./ ua) * 100;
        
        % Função de erro para a norma euclidiana
        erro_func = @(x) (1 / (E * A)) * (-0.5 * Po * x.^2 + ((ub * E * A + 0.5 * Po * L^2) / L) * x) - interp1(coord, u, x);
        norma_erro = norma_euclidiana_erro(erro_func, L);
        
        fprintf('Norma Euclidiana dos Erros para %d elementos e ub = %.5f: %.5e m\n', nel, ub, norma_erro);
        
        % Plotar deslocamentos
        subplot(length(nels), 2, 2*nel_idx-1);
        plot(coord, u, 'o-k', x, ua, '-r');
        title(['Deslocamento (', num2str(nel), ' elementos)']);
        xlabel('Posição (m)');
        ylabel('Deslocamento (m)');
        grid on;
        
        % Plotar esforços internos
        subplot(length(nels), 2, 2*nel_idx);
        bar((coord(1:end-1) + coord(2:end)) / 2, Nx, 'k');
        hold on;
        plot(x, Nxa, '-r');
        title(['Esforço Interno (', num2str(nel), ' elementos)']);
        xlabel('Posição (m)');
        ylabel('Esforço Interno (N)');
        grid on;
    end
    
    % Gráfico de erros percentuais
    figure;
    hold on;
    for nel_idx = 1:length(nels)
        nel = nels(nel_idx);
        nnos = nel + 1;
        h = L / nel;
        coord = linspace(0, L, nnos);
        inci = [(1:nel)' (2:nnos)'];
        ke = (E * A / h) * [1 -1; -1 1];
        K = zeros(nnos, nnos);
        F = zeros(nnos, 1);
        
        for i = 1:nel
            no1 = inci(i, 1);
            no2 = inci(i, 2);
            loc = [no1 no2];
            K(loc, loc) = K(loc, loc) + ke;
            x1 = coord(no1);
            x2 = coord(no2);
            f1 = Po * x1 / L;
            f2 = Po * x2 / L;
            fe = (h / 6) * [f1 + 2*f2; 2*f1 + f2];
            F(no1) = F(no1) + fe(1);
            F(no2) = F(no2) + fe(2);
        end
        
        K(1, :) = 0;
        K(1, 1) = 1;
        F(1) = 0;
        K(end, :) = 0;
        K(end, end) = 1;
        F(end) = ub;
        
        u = K \ F;
        u_interp = interp1(coord, u, x);
        erro_percentual = abs((ua - u_interp) ./ ua) * 100;
        plot(x, erro_percentual, 'DisplayName', [num2str(nel), ' elementos']);
    end
    title(['Erro Percentual no Deslocamento para ub = ', num2str(ub), ' m']);
    xlabel('Coordenadas');
    ylabel('Erro (%)');
    legend show;
    grid on;
    
end