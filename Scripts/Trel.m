% 
%         Trel - Caso 01 
%
%        M u'' + K u = f
%

clc
clear all; 
close all; 

% Coordenadas
coord=[1  0  0 ; 
       2  1  0 ; 
       3  2  0 ; 
       4 0.5 1 ;
       5 1.5 1];

% Inci =[nTmat nTgeo no1 no2]
inci=[1 1 1 2;
      1 1 2 3; 
      1 1 1 4; 
      1 1 2 4; 
      1 1 4 5; 
      1 1 2 5;
      1 1 3 5];

% Tmat=[E rho nu ;]
Tmat=[2.1e11 7800 0.3 ;
      70e9   2700 0.27];
% Tgeo= [Area Izz Iyy;] 
Tgeo=[(10e-3)^2 ((10e-3)^4)/12 ((10e-3)^4)/12;
      (5e-3)^2  ((5e-3)^4)/12  ((5e-3)^4)/12];
 
index=1;
plotMalha(coord,inci,index)

%% Solver 
nnos=size(coord,1);
nel=size(inci,1);

ke_bar=zeros(4,4);
ke=zeros(4,4);
me_bar=zeros(4,4);
me=zeros(4,4);
T=zeros(4,4);
K=zeros(2*nnos,2*nnos);
M=zeros(2*nnos,2*nnos);
F=zeros(2*nnos,1);
u=zeros(2*nnos,1);

for i=1:nel
    no1=inci(i,3);
    no2=inci(i,4);
    x1=coord(no1,2);
    y1=coord(no1,3);
    x2=coord(no2,2);
    y2=coord(no2,3);

    h=sqrt((x2-x1)^2+(y2-y1)^2);
    c=(x2-x1)/h;
    s=(y2-y1)/h;

    E=Tmat(inci(i,1),1);
    rho=Tmat(inci(i,1),2);
    A=Tgeo(inci(i,2),1);
    loc=[2*no1-1 2*no1 2*no2-1 2*no2]; 

    T= [c  s  0  0;
       -s  c  0  0;
        0  0  c  s; 
        0  0 -s  c];

    ke_bar=(E*A/h)*[1 0 -1 0; 
                    0 0  0 0;
                   -1 0  1 0;
                    0 0  0 0];

    ke=T'*ke_bar*T;

    me_bar=(rho*A*h/6)*[2 0 1 0;
                        0 2 0 1;
                        1 0 2 0;
                        0 1 0 2];

    me=T'*me_bar*T;

    K(loc,loc)=K(loc,loc)+ke;
    M(loc,loc)=M(loc,loc)+me;
end

% Análise estática K u = f
% Aplicando as condições de contorno
% u > 2*nó-1 ; v = 2*nó
AllDofs=[1:2*nnos];
FixedDofs=[1 2 6];
FreeDofs=setdiff(AllDofs,FixedDofs);

% Aplicando as forças
% F=-1000, nó = 4, direção v 
F(2*4)=F(2*4)-1000;
% F=2000, nó = 5, direção v 
F(2*5)=F(2*5)-1000; 

% Resolvendo o sistema
u(FreeDofs,1)=K(FreeDofs,FreeDofs)\F(FreeDofs,1);

% Plotagem da malha deformada
figure;
xmax=max(coord(:,2));
ymax=max(coord(:,3));
xmin=min(coord(:,2));
ymin=min(coord(:,3));
Lscale=max((xmax-xmin),(ymax-ymin));
scale=(0.05*Lscale)/max(abs(u));
xy=coord+[zeros(nnos,1) u(1:2:2*nnos-1) u(2:2:2*nnos)]*scale;
index=0;
plotMalha(coord,inci,index); hold on;
plotMalha(xy,inci,index);

% Pós-processamento
for i=1:nel
    no1=inci(i,3);
    no2=inci(i,4);
    x1=coord(no1,2);
    y1=coord(no1,3);
    x2=coord(no2,2);
    y2=coord(no2,3);
    h=sqrt((x2-x1)^2+(y2-y1)^2);
    c=(x2-x1)/h;
    s=(y2-y1)/h;
    E=Tmat(inci(i,1),1);
    A=Tgeo(inci(i,2),1);
    loc=[2*no1-1 2*no1 2*no2-1 2*no2]; 
    ue=u(loc);
    Sxx(i)=(E/h)*((ue(3)*c+ue(4)*s) - (ue(1)*c+ue(2)*s));
end

% Análise dinâmica
% Cálculo dos autovalore
V=zeros(2*nnos,size(FreeDofs,2));
[V(FreeDofs,:),D] = eig(K(FreeDofs,FreeDofs),M(FreeDofs,FreeDofs),'vector');
omeg=sqrt(D)/2/pi;

% Plotagem do modo n 
figure;
nmodo=1;
scale=(0.08*Lscale)/max(abs(V(:,nmodo)));
xy=coord+[zeros(nnos,1) V(1:2:2*nnos-1,nmodo) V(2:2:2*nnos,nmodo)]*scale;
index=0;
plotMalha(coord,inci,index); hold on;
plotMalha(xy,inci,index);
title(['Frequência ',num2str(nmodo),'. omega = ',num2str(omeg(nmodo))]); 

% Cálculo da resposta em frequência
F=zeros(2*nnos,1);
u=zeros(2*nnos,1);
F(2*4)=F(2*4)+1;
freq=[0:1*2*pi:1000*2*pi];

for j=1:length(freq)
    u(FreeDofs,1)=(K(FreeDofs,FreeDofs) - ...
    (freq(j)^2) * M(FreeDofs,FreeDofs))\F(FreeDofs,1);
    resp(j)=u(2*2);    
end

figure;
semilogy(freq/2/pi,abs(resp));
grid on;