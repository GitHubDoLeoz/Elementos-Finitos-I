clc; clear all; close all;

%% Entrada de dados
% Modos de frequências
modos = 10;

% Comprimentos dos galhos
L1 = 0.3188;
L2 = 0.2530;
L3 = 0.2008;
L4 = 0.1594;
L5 = 0.1265;
L6 = 0.1002;
L7 = 0.07958;
L8 = 0.06316;

% Coordenadas dos nós
coord = [1,   0,                       0;
         2,   0,                       L1;
         3,   L2 * sind(20),          L1 + L2 * cosd(20);
         4,   -L2 * sind(20),         L1 + L2 * cosd(20);
         5,   -L2 * sind(20) - L3 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40);
         6,   -L2 * sind(20) + L3 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0);
         7,   -L2 * sind(20) - L3 * sind(40) - L4 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60);
         8,   -L2 * sind(20) - L3 * sind(40) - L4 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20);
         9,   -L2 * sind(20) + L3 * sind(0) + L4 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20);
         10,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20);
         11,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80);
         12,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40);
         13,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0);
         14,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40);
         15,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0);
         16,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40);
         17,  -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0);
         18,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100);
         19,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60);
         20,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60);
         21,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20);
         22,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20);
         23,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60);
         24,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         25,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         26,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20);
         27,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60);
         28,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) + L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         29,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) - L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         30,  -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         31,  -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         32,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(100) - L7 * sind(120), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(120);
         33,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(100) - L7 * sind(80), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(80);
         34,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(60) - L7 * sind(80), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(80);
         35,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(60) - L7 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(40);
         36,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80);
         37,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40);
         38,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40);
         39,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0);
         40,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80);
         41,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40);
         42,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40);
         43,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0);
         44,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         45,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         46,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80);
         47,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40);
         48,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0);
         49,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40);
         50,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         51,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         52,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         53,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         54,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         55,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         56,  -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         57,  -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         58,  -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         59,  -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         60,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(100) - L7 * sind(120) - L8 * sind(140), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(120) + L8 * cosd(140);
         61,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(100) - L7 * sind(120) - L8 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(120) + L8 * cosd(100);
         62,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(100) - L7 * sind(80) - L8 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(80) + L8 * cosd(100);
         63,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(100) - L7 * sind(80) - L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(80) + L8 * cosd(60);
         64,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(60) - L7 * sind(80) - L8 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         65,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(60) - L7 * sind(80) - L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         66,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(60) - L7 * sind(40) - L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         67,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(80) - L6 * sind(60) - L7 * sind(40) - L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         68,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80) - L8 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         69,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80) - L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         70,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40) - L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         71,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40) - L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         72,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         73,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         74,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         75,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(60) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         76,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80) - L8 * sind(100),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         77,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80) - L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         78,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40) - L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         79,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         80,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         81,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         82,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         83,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         84,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         85,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         86,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         87,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         88,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80) - L8 * sind(100),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         89,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         90,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         91,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         92,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         93,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         94,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         95,  -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         96,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         97,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         98,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         99,  -L2 * sind(20) - L3 * sind(40) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         100, -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         101, -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         102, -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         103, -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         104, -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         105, -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         106, -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         107, -L2 * sind(20) + L3 * sind(0) - L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         108, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         109, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         110, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         111, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         112, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         113, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         114, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         115, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         116, L2 * sind(20) + L3 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40);
         117, L2 * sind(20) - L3 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0);
         118, L2 * sind(20) + L3 * sind(40) + L4 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60);
         119, L2 * sind(20) + L3 * sind(40) + L4 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20);
         120, L2 * sind(20) - L3 * sind(0) - L4 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20);
         121, L2 * sind(20) - L3 * sind(0) + L4 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20);
         122, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80);
         123, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40);
         124, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0);
         125, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40);
         126, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0);
         127, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40);
         128, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0);
         129, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100);
         130, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60);
         131, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60);
         132, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20);
         133, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20);
         134, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60);
         135, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         136, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         137, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20);
         138, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60);
         139, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) - L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         140, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) + L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         141, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         142, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20);
         143, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(100) + L7 * sind(120), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(120);
         144, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(100) + L7 * sind(80), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(80);
         145, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(60) + L7 * sind(80), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(80);
         146, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(60) + L7 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(40);
         147, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80);
         148, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40);
         149, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40);
         150, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0);
         151, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80);
         152, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40);
         153, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40);
         154, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0);
         155, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         156, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         157, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80);
         158, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40);
         159, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0);
         160, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40);
         161, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         162, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         163, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         164, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         165, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         166, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         167, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         168, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         169, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40);
         170, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0);
         171, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(100) + L7 * sind(120) + L8 * sind(140), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(120) + L8 * cosd(140);
         172, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(100) + L7 * sind(120) + L8 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(120) + L8 * cosd(100);
         173, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(100) + L7 * sind(80) + L8 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(80) + L8 * cosd(100);
         174, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(100) + L7 * sind(80) + L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(100) + L7 * cosd(80) + L8 * cosd(60);
         175, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(60) + L7 * sind(80) + L8 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         176, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(60) + L7 * sind(80) + L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         177, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(60) + L7 * sind(40) + L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         178, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(80) + L6 * sind(60) + L7 * sind(40) + L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(80) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         179, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80) + L8 * sind(100), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         180, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80) + L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         181, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40) + L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         182, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40) + L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         183, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         184, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         185, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         186, L2 * sind(20) + L3 * sind(40) + L4 * sind(60) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20), L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(60) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         187, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80) + L8 * sind(100),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         188, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80) + L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         189, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40) + L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         190, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         191, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         192, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         193, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         194, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         195, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         196, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         197, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         198, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         199, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80) + L8 * sind(100),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         200, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         201, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         202, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         203, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         204, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         205, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         206, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         207, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         208, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         209, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         210, L2 * sind(20) + L3 * sind(40) + L4 * sind(20) + L5 * sind(0) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),   L1 + L2 * cosd(20) + L3 * cosd(40) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         211, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         212, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         213, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         214, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         215, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         216, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         217, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         218, L2 * sind(20) - L3 * sind(0) + L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         219, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         220, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         221, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         222, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         223, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         224, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         225, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         226, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(0) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(0) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         227, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40);
         228, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60);
         229, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20);
         230, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80);
         231, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40);
         232, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40);
         233, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0);
         234, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80) + L8 * sind(100),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         235, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(80) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         236, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         237, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(60) + L7 * sind(40) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         238, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40) + L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         239, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(40) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         240, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         241, -L2 * sind(20) + L3 * sind(0) + L4 * sind(20) + L5 * sind(40) + L6 * sind(20) + L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         242, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40);
         243, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60);
         244, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20);
         245, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80);
         246, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40);
         247, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40);
         248, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0);
         249, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80) - L8 * sind(100),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(100);
         250, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(80) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(80) + L8 * cosd(60);
         251, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(60);
         252, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(60) - L7 * sind(40) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(60) + L7 * cosd(40) + L8 * cosd(20);
         253, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40) - L8 * sind(60),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(60);
         254, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(40) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(40) + L8 * cosd(20);
         255, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0) - L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20);
         256, L2 * sind(20) - L3 * sind(0) - L4 * sind(20) - L5 * sind(40) - L6 * sind(20) - L7 * sind(0) + L8 * sind(20),    L1 + L2 * cosd(20) + L3 * cosd(0) + L4 * cosd(20) + L5 * cosd(40) + L6 * cosd(20) + L7 * cosd(0) + L8 * cosd(20)];

% Definição da conectividade dos elementos
inci = [1,  1,  1, 2;
        1,  2,  2, 3;
        1,  2,  2, 4;
        1,  3,  4, 5;
        1,  3,  4, 6;
        1,  4,  5, 7;
        1,  4,  5, 8;
        1,  4,  6, 9;
        1,  4,  6, 10;
        1,  5,  7, 11;
        1,  5,  8, 12;
        1,  5,  10, 13
        1,  5,  7, 14;
        1,  5,  8, 15;
        1,  5,  10, 16;
        1,  5,  9, 17;
        1,  6,  11, 18;
        1,  6,  11, 19;
        1,  6,  14, 20;
        1,  6,  14, 21;
        1,  6,  12, 22;
        1,  6,  12, 23;
        1,  6,  15, 24;
        1,  6,  15, 25;
        1,  6,  16, 26;
        1,  6,  16, 27;
        1,  6,  13, 28;
        1,  6,  13, 29;
        1,  6,  17, 30;
        1,  6,  17, 31;
        1,  7,  18, 32;
        1,  7,  18, 33;
        1,  7,  19, 34;
        1,  7,  19, 35;
        1,  7,  20, 36;
        1,  7,  20, 37;
        1,  7,  21, 38;
        1,  7,  21, 39;
        1,  7,  23, 40;
        1,  7,  23, 41;
        1,  7,  22, 42;
        1,  7,  22, 43;
        1,  7,  24, 44;
        1,  7,  24, 45;
        1,  7,  27, 46;
        1,  7,  27, 47;
        1,  7,  26, 48;
        1,  7,  26, 49;
        1,  7,  25, 50;
        1,  7,  25, 51;
        1,  7,  29, 52;
        1,  7,  29, 53;
        1,  7,  28, 55;
        1,  7,  28, 54;
        1,  7,  30, 58;
        1,  7,  30, 59;
        1,  7,  31, 56;
        1,  7,  31, 57;
        1,  8,  32, 60;
        1,  8,  32, 61;
        1,  8,  33, 62;
        1,  8,  33, 63;
        1,  8,  34, 64;
        1,  8,  34, 65;
        1,  8,  35, 66;
        1,  8,  35, 67;
        1,  8,  36, 68;
        1,  8,  36, 69;
        1,  8,  37, 70;
        1,  8,  37, 71;
        1,  8,  38, 72;
        1,  8,  38, 73;
        1,  8,  39, 74;
        1,  8,  39, 75;
        1,  8,  40, 76;
        1,  8,  40, 77;
        1,  8,  41, 78;
        1,  8,  41, 79;
        1,  8,  42, 80;
        1,  8,  42, 81;
        1,  8,  43, 82;
        1,  8,  43, 83;
        1,  8,  44, 84;
        1,  8,  44, 85;
        1,  8,  45, 86;
        1,  8,  45, 87;
        1,  8,  46, 88;
        1,  8,  46, 89;
        1,  8,  47, 90;
        1,  8,  47, 91;
        1,  8,  48, 92;
        1,  8,  48, 93;
        1,  8,  49, 94;
        1,  8,  49, 95;
        1,  8,  50, 96;
        1,  8,  50, 97;
        1,  8,  51, 98;
        1,  8,  51, 99;
        1,  8,  52, 100;
        1,  8,  52, 101;
        1,  8,  53, 102;
        1,  8,  53, 103;
        1,  8,  54, 104;
        1,  8,  54, 105;
        1,  8,  55, 106;
        1,  8,  55, 107;
        1,  8,  56, 108;
        1,  8,  56, 109;
        1,  8,  57, 110;
        1,  8,  57, 111;
        1,  8,  58, 112;
        1,  8,  58, 113;
        1,  8,  59, 114;
        1,  8,  59, 115;
        1,  3,  3, 116;
        1,  3,  3, 117;
        1,  4,  117, 120;
        1,  4,  117, 121;
        1,  4,  116, 118;
        1,  4,  116, 119;
        1,  5,  120, 128;
        1,  5,  121, 124;
        1,  5,  121, 127;
        1,  5,  119, 126;
        1,  5,  119, 123;
        1,  5,  118, 125;
        1,  5,  118, 122;
        1,  6,  122, 129;
        1,  6,  122, 130;
        1,  6,  125, 131;
        1,  6,  125, 132;
        1,  6,  123, 133;
        1,  6,  123, 134;
        1,  6,  126, 135;
        1,  6,  126, 136;
        1,  6,  127, 137;
        1,  6,  127, 138;
        1,  6,  124, 139;
        1,  6,  124, 140;
        1,  6,  128, 141;
        1,  6,  128, 142;
        1,  7,  129, 143;
        1,  7,  129, 144;
        1,  7,  130, 145;
        1,  7,  130, 146;
        1,  7,  131, 147;
        1,  7,  131, 148;
        1,  7,  132, 149;
        1,  7,  132, 150;
        1,  7,  133, 153;
        1,  7,  133, 154;
        1,  7,  134, 151;
        1,  7,  134, 152;
        1,  7,  138, 157;
        1,  7,  138, 158;
        1,  7,  135, 155;
        1,  7,  135, 156;
        1,  7,  137, 159;
        1,  7,  137, 160;
        1,  7,  136, 161;
        1,  7,  136, 162;
        1,  7,  140, 163;
        1,  7,  140, 164;
        1,  7,  139, 166;
        1,  7,  139, 165;
        1,  7,  141, 169;
        1,  7,  141, 170;
        1,  7,  142, 167;
        1,  7,  142, 168;
        1,  8,  143, 171;
        1,  8,  143, 172;
        1,  8,  144, 173;
        1,  8,  144, 174;
        1,  8,  145, 175;
        1,  8,  145, 176;
        1,  8,  146, 177;
        1,  8,  146, 178;
        1,  8,  147, 179;
        1,  8,  147, 180;
        1,  8,  148, 181;
        1,  8,  148, 182;
        1,  8,  149, 183;
        1,  8,  149, 184;
        1,  8,  150, 185;
        1,  8,  150, 186;
        1,  8,  151, 187;
        1,  8,  151, 188;
        1,  8,  152, 189;
        1,  8,  152, 190;
        1,  8,  153, 191;
        1,  8,  153, 192;
        1,  8,  154, 193;
        1,  8,  154, 194;
        1,  8,  155, 195;
        1,  8,  155, 196;
        1,  8,  156, 197;
        1,  8,  156, 198;
        1,  8,  157, 199;
        1,  8,  157, 200;
        1,  8,  158, 201;
        1,  8,  158, 202;
        1,  8,  159, 203;
        1,  8,  159, 204;
        1,  8,  160, 205;
        1,  8,  160, 206;
        1,  8,  161, 207;
        1,  8,  161, 208;
        1,  8,  162, 209;
        1,  8,  162, 210;
        1,  8,  163, 211;
        1,  8,  163, 212;
        1,  8,  164, 213;
        1,  8,  164, 214;
        1,  8,  165, 215;
        1,  8,  165, 216;
        1,  8,  166, 217;
        1,  8,  166, 218;
        1,  8,  167, 219;
        1,  8,  167, 220;
        1,  8,  168, 221;
        1,  8,  168, 222;
        1,  8,  169, 223;
        1,  8,  169, 224;
        1,  8,  170, 225;
        1,  8,  170, 226;
        1,  5,  9, 227;
        1,  6,  227, 228;
        1,  6,  227, 229;
        1,  7,  228, 230;
        1,  7,  228, 231;
        1,  7,  229, 232;
        1,  7,  229, 233;
        1,  8,  230, 234;
        1,  8,  230, 235;
        1,  8,  231, 236;
        1,  8,  231, 237;
        1,  8,  232, 238;
        1,  8,  232, 239;
        1,  8,  233, 240;
        1,  8,  233, 241;
        1,  5,  120, 242;
        1,  6,  242, 243;
        1,  6,  242, 244;
        1,  7,  243, 245;
        1,  7,  243, 246;
        1,  7,  244, 247;
        1,  7,  244, 248;
        1,  8,  245, 249;
        1,  8,  245, 250;
        1,  8,  246, 251;
        1,  8,  246, 252;
        1,  8,  247, 253;
        1,  8,  247, 254;
        1,  8,  248, 255;
        1,  8,  248, 256];

% Propriedades do material
Tmat = [11.3e9 805 0.38];

% Propriedades geométricas
Tgeo = [pi*((0.18/2)^2)    (pi*((0.18/2)^4))/4     (pi*((0.18/2)^4))/4;
        pi*((0.1273/2)^2)  (pi*((0.1273/2)^4))/4   (pi*((0.1273/2)^4))/4;
        pi*((0.09/2)^2)    (pi*((0.09/2)^4))/4     (pi*((0.09/2)^4))/4;
        pi*((0.0636/2)^2)  (pi*((0.0636/2)^4))/4   (pi*((0.0636/2)^4))/4;
        pi*((0.045/2)^2)   (pi*((0.045/2)^4))/4    (pi*((0.045/2)^4))/4;
        pi*((0.03175/2)^2) (pi*((0.03175/2)^4))/4  (pi*((0.03175/2)^4))/4;
        pi*((0.02245/2)^2) (pi*((0.02245/2)^4))/4  (pi*((0.02245/2)^4))/4;
        pi*((0.01587/2)^2) (pi*((0.01587/2)^4))/4  (pi*((0.01587/2)^4))/4];

%% Inicialização de variáveis
nnos = size(coord, 1);
nel = size(inci, 1);

% Matrizes de rigidez e massa para cada elemento
ke_bar = zeros(6,6);
ke_viga = zeros(6,6);
ke = zeros(6,6);
me_por = zeros(6,6);
me = zeros(6,6);

% Matrizes globais de rigidez e massa
K = zeros(3*nnos, 3*nnos);
M = zeros(3*nnos, 3*nnos);

% Vetor de deslocamentos
u = zeros(3*nnos, 1);

%% Loop sobre os elementos
for i = 1:nel
    % Identificação dos nós do elemento
    no1 = inci(i, 3);
    no2 = inci(i, 4);

    % Coordenadas dos nós
    x1 = coord(no1, 2);
    y1 = coord(no1, 3);
    x2 = coord(no2, 2);
    y2 = coord(no2, 3);

    % Cálculo do comprimento e ângulos
    h = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    c = (x2 - x1) / h;
    s = (y2 - y1) / h;

    % Propriedades do material e geometria
    E = Tmat(inci(i, 1), 1);
    A = Tgeo(inci(i, 2), 1);
    Izz = Tgeo(inci(i, 2), 2);
    rho = Tmat(inci(i, 1), 2);

    % Localização dos graus de liberdade
    loc = [3*no1-2 3*no1-1 3*no1 3*no2-2 3*no2-1 3*no2];

    % Matriz de transformação
    T = [c  s  0  0  0 0;
        -s  c  0  0  0 0;
         0  0  1  0  0 0;
         0  0  0  c  s 0;
         0  0  0 -s  c 0;
         0  0  0  0  0 1];

    % Matriz de rigidez axial
    ke_bar = (E * A / h) * [1 0 0 -1 0 0;
                            0 0 0  0 0 0;
                            0 0 0  0 0 0;
                           -1 0 0  1 0 0;
                            0 0 0  0 0 0;
                            0 0 0  0 0 0];

    % Matriz de rigidez da viga
    ke_viga = (E * Izz / h^3) * [0   0     0    0    0     0;
                                 0  12    6*h   0   -12    6*h;
                                 0  6*h  4*h^2  0  -6*h  2*h^2;
                                 0   0     0    0    0     0;
                                 0  -12  -6*h   0   12   -6*h;
                                 0  6*h  2*h^2  0  -6*h  4*h^2];

    % Matriz de rigidez do elemento
    ke_por = ke_bar + ke_viga;
    ke = T' * ke_por * T;
    
    % Matriz de massa
    me_por = (rho * A * h / 6) * [2 0 0 1 0 0;
                                  0 2 0 0 1 0;
                                  0 0 0 0 0 0;
                                  1 0 0 2 0 0;
                                  0 1 0 0 2 0;
                                  0 0 0 0 0 0];
    
    me_por = me_por + (rho * A * h / 420) * [0    0     0     0    0     0;
                                             0   156   22*h   0   54   -13*h;
                                             0   22*h 4*h^2   0  13*h  -3*h^2;
                                             0    0     0     0    0     0;
                                             0   54    13*h   0   156  -22*h;
                                             0  -13*h -3*h^2  0  -22*h  4*h^2];
                         
    me = T' * me_por * T;

    % Montagem das matrizes globais
    K(loc, loc) = K(loc, loc) + ke;
    M(loc, loc) = M(loc, loc) + me;
end

%% Condições de contorno
AllDofs = 1:3*nnos;
FixedDofs = [1 2 3];
FreeDofs = setdiff(AllDofs, FixedDofs);%% Inicialização de variáveis
nnos = size(coord, 1);
nel = size(inci, 1);

% Matrizes de rigidez e massa para cada elemento
ke_bar = zeros(6,6);
ke_viga = zeros(6,6);
ke = zeros(6,6);
me_por = zeros(6,6);
me = zeros(6,6);

% Matrizes globais de rigidez e massa
K = zeros(3*nnos, 3*nnos);
M = zeros(3*nnos, 3*nnos);

% Vetor de deslocamentos
u = zeros(3*nnos, 1);

%% Loop sobre os elementos
for i = 1:nel
    % Identificação dos nós do elemento
    no1 = inci(i, 3);
    no2 = inci(i, 4);

    % Coordenadas dos nós
    x1 = coord(no1, 2);
    y1 = coord(no1, 3);
    x2 = coord(no2, 2);
    y2 = coord(no2, 3);

    % Cálculo do comprimento e ângulos
    h = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    c = (x2 - x1) / h;
    s = (y2 - y1) / h;

    % Propriedades do material e geometria
    E = Tmat(inci(i, 1), 1);
    A = Tgeo(inci(i, 2), 1);
    Izz = Tgeo(inci(i, 2), 2);
    rho = Tmat(inci(i, 1), 2);

    % Localização dos graus de liberdade
    loc = [3*no1-2 3*no1-1 3*no1 3*no2-2 3*no2-1 3*no2];

    % Matriz de transformação
    T = [c  s  0  0  0 0;
        -s  c  0  0  0 0;
         0  0  1  0  0 0;
         0  0  0  c  s 0;
         0  0  0 -s  c 0;
         0  0  0  0  0 1];

    % Matriz de rigidez axial
    ke_bar = (E * A / h) * [1 0 0 -1 0 0;
                            0 0 0  0 0 0;
                            0 0 0  0 0 0;
                           -1 0 0  1 0 0;
                            0 0 0  0 0 0;
                            0 0 0  0 0 0];

    % Matriz de rigidez da viga
    ke_viga = (E * Izz / h^3) * [0   0     0    0    0     0;
                                 0  12    6*h   0   -12    6*h;
                                 0  6*h  4*h^2  0  -6*h  2*h^2;
                                 0   0     0    0    0     0;
                                 0  -12  -6*h   0   12   -6*h;
                                 0  6*h  2*h^2  0  -6*h  4*h^2];

    % Matriz de rigidez do elemento
    ke_por = ke_bar + ke_viga;
    ke = T' * ke_por * T;
    
    % Matriz de massa
    me_por = (rho * A * h / 6) * [2 0 0 1 0 0;
                                  0 2 0 0 1 0;
                                  0 0 0 0 0 0;
                                  1 0 0 2 0 0;
                                  0 1 0 0 2 0;
                                  0 0 0 0 0 0];
    
    me_por = me_por + (rho * A * h / 420) * [0    0     0     0    0     0;
                                             0   156   22*h   0   54   -13*h;
                                             0   22*h 4*h^2   0  13*h  -3*h^2;
                                             0    0     0     0    0     0;
                                             0   54    13*h   0   156  -22*h;
                                             0  -13*h -3*h^2  0  -22*h  4*h^2];
                         
    me = T' * me_por * T;

    % Montagem das matrizes globais
    K(loc, loc) = K(loc, loc) + ke;
    M(loc, loc) = M(loc, loc) + me;
end

%% Condições de contorno
AllDofs = 1:3*nnos;
FixedDofs = [1 2 3];
FreeDofs = setdiff(AllDofs, FixedDofs);

%% Análise dinâmica
% Cálculo dos modos e frequências
[V(FreeDofs,:), D] = eigs(K(FreeDofs, FreeDofs), M(FreeDofs, FreeDofs), modos, 'smallestabs');
D = diag(D);
omeg = sqrt(D) / (2 * pi);

% Configura a janela da figura para tela cheia para os modos de vibração
figure(1);
set(gcf, 'WindowState', 'maximized');

% Determina os limites da estrutura para a escala
xmax = max(coord(:, 2));
ymax = max(coord(:, 3));
xmin = min(coord(:, 2));
ymin = min(coord(:, 3));
Lscale = max((xmax - xmin), (ymax - ymin));

% Parâmetros de animação
numFrames = 40;

% Loop para plotar os modos escolhidos
for modo = 1:modos
    subplot(2, ceil(modos/2), modo);
    
    % Cálculo da escala e da coordenada deslocada
    scale = (Lscale * 0.5) / max(abs(V(:, modo)));
    coord_deslocada = coord + [zeros(nnos, 1), V(1:3:3*nnos-1, modo), V(2:3:3*nnos, modo)] * scale;

    % Animação da deformação
    for frame = 1:numFrames
        % Interpolação entre a malha original e a deformada
        alpha = frame / numFrames;
        coord_atual = coord + alpha * (coord_deslocada - coord);
        
        % Plotagem da estrutura original e deformada
        cla; index = 1; plotMalha(coord, inci, index, coord_atual);
                
        % Configura título e exibe a frequência
        title(['(Modo: ', num2str(modo), ' - Frequência: ', num2str(omeg(modo), '%.3f'), ' Hz)']);
        
        % Adicionar legenda
        if modo == 1 && frame == 1
            annotation('textbox', [0.5, 0.01, 0.3, 0.05], ...
                       'String', 'Malha Original: preto, Malha Deformada: vermelho', ...
                       'FitBoxToText', 'on');
        end
        
        pause(0.02);
    end
end