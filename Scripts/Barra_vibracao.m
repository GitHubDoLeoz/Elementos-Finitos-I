clc
clear all;
close all;

% EAu'' + lambda u = 0

% Barra livre - livre
% u'(0) = 0 u'(L) = o 

L = 1;
nel = 40;
% Tmat = [E, rho, e nu]
Tmat = [2.1e11 7800 0.3 ;
        70e9   2700 0.27];
        
% Tmat = [A, e Izz/Iyy]        
Tgeo = [(10e-3)^2 ((10e-3)^4)/12 ((10e-3)^4)/12 ;
        (5e-3)^2  ((5e-3)^4)/12  ((5e-3)^4)/12];

nnos = nel+1;
h = L/nel;
coord = [0:h:L];
% Inci = [nTmat nTgeo nó1 nó2]
inci = [ones(nel, 1) ones(nel, 1) [1:nnos-1]' [2:nnos]'];

ke = zeros(2,2);
me = zeros(2,2);
K = zeros(nnos, nnos);
M = zeros(nnos, nnos);

for i=1:nel
    no1 =inci(i,3);
    no2 = inci(i,4);
    x1 = coord(no1);
    x2 = coord(no2);
    h = x2-x1;
    E = Tmat(inci(i,1),1);
    rho = Tmat(inci(i,1),2);
    A = Tgeo(inci(i,2),1);
    loc = [no1 no2];
    
    ke = (E*A/h)*[1 -1 
                  -1 1];
                  
    me = (rho*A*h/6)*[2 1 
                      1 2];
                      
    K(loc,loc)=K(loc,loc)+ke;
    M(loc,loc)=M(loc,loc)+me;
end

freedofs = [2:nnos];

% Cálculo dos autovalores
[V,D] = eig(K(freedofs, freedofs),M(freedofs, freedofs));

omeg = sqrt(diag(D));

plot(coord(2:nnos),V(:,3)); grid on;