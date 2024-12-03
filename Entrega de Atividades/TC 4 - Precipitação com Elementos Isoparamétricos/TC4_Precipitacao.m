clear; close all; clc; format long g;

%% ----------------------- DADOS DE ENTRADA -----------------------
% Coordenadas dos nós da região A
coord = [1  0.00  33.3
         2  13.2  62.3
         3  39.3  84.5
         4  22.2  30.1
         5  49.9  57.6
         6  78.8  78.2
         7  39.3  10.0
         8  59.7  34.3
         9  73.9  36.2
         10 69.8  5.1];

% Conectividade dos elementos da região A
inci = [1 1 4 5 2
        2 2 5 6 3
        3 4 7 8 5
        4 5 8 9 6
        5 7 10 9 8];

% Coordenadas dos nós da sub-região
coord2 = [1 45 50
          2 55 50
          3 65 60
          4 60 70];

% Conectividade dos elementos da sub-região
inci2 = [1 1 2 3 4];

% Valores do vetor u (precipitações nos nós conhecidos)
u = [4.62 3.81 4.76 5.45 4.90 10.35 4.96 4.26 18.36 15.69];

%% ----------------------- PLOT DA MALHA INICIAL -----------------------
% Construção da matriz de conectividade para gplot
Y = zeros(size(coord, 1));
for i = 1:size(inci, 1)
    Y(inci(i, 2), inci(i, 3)) = 1;
    Y(inci(i, 3), inci(i, 4)) = 1;
    Y(inci(i, 4), inci(i, 5)) = 1;
    Y(inci(i, 5), inci(i, 2)) = 1;
end

% Plot da malha inicial
figure;
gplot(Y, coord(:, 2:3), 'b-*');
axis equal;
xlabel('Coordenada x [km]'); ylabel('Coordenada y [km]');
hold on;
xlim([0, 80]);
ylim([0, 90]);

%% ----------------------- PLOT DA SUB-REGIÃO -----------------------
% Construção da matriz de conectividade para gplot
Y2 = zeros(size(coord2, 1));
Y2(inci2(1, 2), inci2(1, 3)) = 1;
Y2(inci2(1, 3), inci2(1, 4)) = 1;
Y2(inci2(1, 4), inci2(1, 5)) = 1;
Y2(inci2(1, 5), inci2(1, 2)) = 1;

% Plot da sub-região
gplot(Y2, coord2(:, 2:3), 'r-*');
plot(50, 50, 'g*');

%% ----------------------- INTERPOLAÇÃO E CÁLCULOS -----------------------
% Inicializar variáveis
nnos = size(coord2, 1);
nel=size(inci,1);
subnel=size(inci2,1);
precipitacao_pontos = zeros(nnos, 1);
Ae = zeros(nel, 1); Pe = zeros(nel, 1);

% Loop sobre os elementos da região A
for i = 1:nel
    % Nós do elemento
    no1 = inci(i, 2); no2 = inci(i, 3); no3 = inci(i, 4); no4 = inci(i, 5);

    % Coordenadas dos nós
    x1 = coord(no1, 2); y1 = coord(no1, 3);
    x2 = coord(no2, 2); y2 = coord(no2, 3);
    x3 = coord(no3, 2); y3 = coord(no3, 3);
    x4 = coord(no4, 2); y4 = coord(no4, 3);

    % Valores de precipitação nos nós
    u1A = u(no1); u2A = u(no2);
    u3A = u(no3); u4A = u(no4);

    % Cálculo dos coeficientes de área e peso
    A0 = (1/8) * ((y4-y2)*(x3-x1) - (y3-y1)*(x4-x2));
    A1 = (1/8) * ((y3-y4)*(x2-x1) - (y2-y1)*(x3-x4));
    A2 = (1/8) * ((y4-y1)*(x3-x2) - (y3-y2)*(x4-x1));

    % Cálculo da área efetiva e do peso
    Ae(i) = 4 * A0;
    Pe(i) = 4 * A0 * (u1A/4 + u2A/4 + u3A/4 + u4A/4) ...
          - (4 * A1 * (u1A/4 - u2A/4 - u3A/4 + u4A/4)) / 3 ...
          - (4 * A2 * (u1A/4 + u2A/4 - u3A/4 - u4A/4)) / 3;
end

chuvaTotal1 = sum(Pe);

% Calcular precipitação nos nós da sub-região por interpolação
for i = 1:nnos
    pos_x = coord2(i, 2);
    pos_y = coord2(i, 3);

    % Calcular distâncias aos nós conhecidos
    distancias_nos = sqrt((coord(:, 2) - pos_x).^2 + (coord(:, 3) - pos_y).^2);
    distancias_nos(distancias_nos == 0) = 1e-6;

    % Pesos inversos às distâncias
    pesos_inversos = 1 ./ distancias_nos;

    % Precipitação interpolada
    precipitacao_pontos(i) = sum(pesos_inversos .* u') / sum(pesos_inversos);
end

% Loop sobre os elementos da sub-região
for i = 1:subnel
    % Nós do elemento
    no1 = inci2(i, 2); no2 = inci2(i, 3); no3 = inci2(i, 4); no4 = inci2(i, 5);

    % Coordenadas dos nós
    x1 = coord2(no1, 2); y1 = coord2(no1, 3);
    x2 = coord2(no2, 2); y2 = coord2(no2, 3);
    x3 = coord2(no3, 2); y3 = coord2(no3, 3);
    x4 = coord2(no4, 2); y4 = coord2(no4, 3);

    % Valores de precipitação nos nós
    u1 = precipitacao_pontos(no1); u2 = precipitacao_pontos(no2);
    u3 = precipitacao_pontos(no3); u4 = precipitacao_pontos(no4);

    % Cálculo dos coeficientes de área e peso
    A0 = (1/8) * ((y4-y2)*(x3-x1) - (y3-y1)*(x4-x2));
    A1 = (1/8) * ((y3-y4)*(x2-x1) - (y2-y1)*(x3-x4));
    A2 = (1/8) * ((y4-y1)*(x3-x2) - (y3-y2)*(x4-x1));

    % Cálculo da área efetiva e do peso
    Ae2(i) = 4 * A0;
    Pe2(i) = 4 * A0 * (u1/4 + u2/4 + u3/4 + u4/4) ...
          - (4 * A1 * (u1/4 - u2/4 - u3/4 + u4/4)) / 3 ...
          - (4 * A2 * (u1/4 + u2/4 - u3/4 - u4/4)) / 3;
end

% Precipitação total na sub-região
chuvaTotal = sum(Pe2);

% Cálculo da precipitação no ponto (50, 50)
localizacao = [50, 50];
distancias_local = sqrt((coord(:, 2) - localizacao(1)).^2 + (coord(:, 3) - localizacao(2)).^2);
distancias_local(distancias_local == 0) = 1e-6;
pesos_local = 1 ./ distancias_local;
precipitacao_pontual = sum(pesos_local .* u') / sum(pesos_local);

%% ----------------------- APRESENTAÇÃO DOS RESULTADOS -----------------------
Ae = round(Ae, 1);
Pe = round(Pe, 4);

TabelaResultados2 = table((1:nel)', Ae, Pe, ...
    'VariableNames', {'Elemento', 'Área total(Ae) [km²]', 'Precipitação total(Qe) [cm·km²]'});

texto2 = sprintf('Área e precipitação total da região A: \n');
disp(texto2);
disp(TabelaResultados2);

Ae2 = round(Ae2, 1);
chuvaTotal = round(chuvaTotal, 4);
precipitacao_pontual = round(precipitacao_pontual, 4);

fprintf(repmat('=', 1, 102));
fprintf('\n');

TabelaResultados = table((1:subnel)', Ae2, chuvaTotal, precipitacao_pontual, ...
    'VariableNames', {'Elemento', 'Área total(Ae) [km²]', 'Precipitação total(Pe) [cm·km²]', 'Chuva no ponto (50, 50) [cm]'});

texto = sprintf('\nÁrea, precipitação total e precipitação no ponto (50, 50) da sub-região considerada: \n');
disp(texto);
disp(TabelaResultados);