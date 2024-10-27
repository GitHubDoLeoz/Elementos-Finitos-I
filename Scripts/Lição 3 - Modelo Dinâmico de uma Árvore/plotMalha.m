function plotMalha(coord, inci, index, coord_deformada)
    % Número de elementos e de nós
    nel = length(inci(:,1));        % Número de elementos
    nnos = length(coord(:,1));      % Número de nós
    nnel = size(inci(:,3:end),2);   % Número de nós por elemento
    dimension = size(coord(2:3),2); % Dimensão da malha (2D)

    % Inicialização das matrizes para armazenar as coordenadas
    X = zeros(nnel, nel);
    Y = zeros(nnel, nel);

    if dimension == 2
        for iel = 1:nel
            for i = 1:nnel
                X(i,iel) = coord(inci(iel,i+2),2);
                Y(i,iel) = coord(inci(iel,i+2),3);
            end
        end
        
        % Plota a malha com ou sem números de nós e elementos, de acordo com o 'index'
        switch index
            case 0
                % Plotando a malha de elementos finitos
                plot(X, Y, 'k');
                title('Finite Element Mesh');
                fill(X, Y, 'w');
                axis off;
                axis equal;

            case 1
                % Plotando a malha com números de nós e elementos
                plot(X, Y, 'k');
                hold on;
                title('Finite Element Mesh');
                fill(X, Y, 'w');
                axis off;
                axis equal;
                % Plotar a malha deformada
                X_deformada = zeros(nnel, nel);
                Y_deformada = zeros(nnel, nel);

                for iel = 1:nel
                    for i = 1:nnel
                        X_deformada(i,iel) = coord_deformada(inci(iel,i+2),2);
                        Y_deformada(i,iel) = coord_deformada(inci(iel,i+2),3);
                    end
                end

                % Plota a malha deformada em vermelho
                plot(X_deformada, Y_deformada, 'r', 'LineWidth', 0.5);
        end
        
        hold on;
        
        % Plotar o símbolo de engastamento no nó 1
        x_engast = coord(1,2);
        y_engast = coord(1,3);
        plot([x_engast - 0.2, x_engast + 0.2], [y_engast, y_engast], 'k', 'LineWidth', 1);
        plot([-0.2, -0.25], [y_engast, -0.03], 'k', 'LineWidth', 1);
        plot([-0.15, -0.2], [y_engast, -0.03], 'k', 'LineWidth', 1);
        plot([-0.1, -0.15], [y_engast, -0.03], 'k', 'LineWidth', 1);
        plot([-0.05, -0.1], [y_engast, -0.03], 'k', 'LineWidth', 1);
        plot([0, -0.05], [y_engast, -0.03], 'k', 'LineWidth', 1);
        plot([0.05, 0], [y_engast, -0.03], 'k', 'LineWidth', 1);
        plot([0.1, 0.05], [y_engast, -0.03], 'k', 'LineWidth', 1);
        plot([0.15, 0.1], [y_engast, -0.03], 'k', 'LineWidth', 1);
        plot([0.2, 0.15], [y_engast, -0.03], 'k', 'LineWidth', 1);
     end
end