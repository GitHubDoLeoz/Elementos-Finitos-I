% **********************************
%        Quad4 - Precipitação  
%
%           Touzot e Dhat 
%

clc; clear all; close all; 

%% Entrada de dados
% Coordenadas
x=[0.0    
   13.2
   39.3
   22.2
   49.9
   78.8
   39.3
   59.7
   73.9
   69.8];

y=[33.3
   62.3
   84.5
   30.1
   57.6
   78.2
   10.0
   34.3
   36.2
   5.1];

coord=[[1:size(x)]', x , y];

% Inci =[nTmat nTgeo no1 no2]
inci=[1  1  1 4 5 2; 
      1  1  2 5 6 3; 
      1  1  4 7 8 5; 
      1  1  5 8 9 6; 
      1  1  7 10 9 8];
      
u=[4.62 3.81 4.76 5.45 4.90 10.35 4.96 4.26 18.36 15.69];
 
index=1;
plotMalha(coord,inci,index)

%% Solver
nnos = size(coord,1);
nel = size(inci,1);
area = zeros(nel,1);

for i = 1:nel
    no1 = inci(i,3);
    no2 = inci(i,4);
    no3 = inci(i,5);
    no4 = inci(i,6);

    x1 = coord(no1,2);
    y1 = coord(no1,3);
    x2 = coord(no2,2);
    y2 = coord(no2,3);
    x3 = coord(no3,2);
    y3 = coord(no3,3);
    x4 = coord(no4,2);
    y4 = coord(no4,3);

    u1 = u(no1);
    u2 = u(no2);
    u3 = u(no3);
    u4 = u(no4);

    A0 = (1/8)*((y4-y2)*(x3-x1)-(y3-y1)*(x4-x2));
    A1 = (1/8)*((y3-y4)*(x2-x1)-(y2-y1)*(x3-x4));
    A2 = (1/8)*((y4-y1)*(x3-x2)-(y3-y2)*(x4-x1));

    Ae(i) = 4*A0;
    Pe(i) = 4*A0*(u1/4 + u2/4 + u3/4 + u4/4) - (4*A1*(u1/4 - u2/4 - u3/4 + u4/4))/3 ...
            - (4*A2*(u1/4 + u2/4 - u3/4 - u4/4))/3;
end

totalAe = sum(Ae);
totalPe = sum(Pe);
um = totalPe/totalAe;
