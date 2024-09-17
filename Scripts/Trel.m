% **********************************
%         Trel -  caso01 
%
%          M u'' + K u = f
%
%
%
%
clc
clear all; 
close all; 

%% entrada de dados 

%Coordenadas
coord=[ 1 0    0 ; 
        2 1    0; 
        3 2    0 ; 
        4 0.5  1 ;
        5 1.5  1];

%  Inci =[ nTmat nTgeo no1 no2 ]
inci=[ 1  1  1 2;
       1  1  2 3; 
       1  1  1 4; 
       1  1  2 4; 
       1  1  4 5; 
       1  1  2 5;
       1  1  3 5];

% Tmat=[ E rho nu ; ]
Tmat=[ 2.1e11 7800 0.3 ;
       70e9   2700 0.27];
% Tgeo= [ Area Izz Iyy ; 
Tgeo=[(10e-3)^2 ((10e-3)^4)/12 ((10e-3)^4)/12 ;
      (5e-3)^2  ((5e-3)^4)/12  ((5e-3)^4)/12];
 
index=1;
plotMalha(coord,inci,index)

%%  Solver 
nnos=size(coord,1);
nel=size(inci,1);

ke_bar=zeros(4,4);
ke=zeros(4,4);
me_bar=zeros(4,4);
me=zeros(4,4);
T=zeros(4,4);
K=zeros(2*nnos,2*nnos);
M=zeros(2*nnos,2*nnos);

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

T= [  c  s  0  0;
     -s  c  0  0;
      0  0  c  s; 
      0  0 -s  c];

ke_bar=(E*A/h)*[ 1 0 -1 0; 
             0 0  0 0;
            -1 0  1 0;
             0 0  0 0];

ke=T'*ke_bar*T;
         
me_bar=(rho*A*h/6)*[ 2 0 1 0 ;
                     0 2 0 1 ;
                     1 0 2 0 ;
                     0 1 0 2];
                 
me=T'*me_bar*T;

K(loc,loc)=K(loc,loc)+ke;
M(loc,loc)=M(loc,loc)+me;
end

% aplicando as Condições de contorno
freedofs=[2:nnos];

% calculo dos autovalore

%[V,D] = eig(K(freedofs,freedofs),M(freedofs,freedofs),'vector');

%omeg=sqrt(D)/2/pi;

% u(freedofs,1)=K(freedofs,freedofs)\F(freedofs,1);
% 
% for i=1:nel
%     no1=inci(i,1);
%     no2=inci(i,2);
%     Nx(i)=(E*A/h)*(u(no2)-u(no1)); 
% end
% 
% 
% % solução analítica 
% x=[0:h/10:L]; 
% ua=((P/(E*A))*x)+((po/(2*E*A))*(2*L-x).*x );
% Nxa=P+po*(L-x);
% 
% % plota os resultados 
% 
% subplot(2,1,1);plot(coord,u,'o-k',x,ua,'-r'); grid on;
% subplot(2,1,2);bar( (coord(1:nnos-1)+coord(2:nnos))/2 , Nx ,1); hold on; 
% plot(x,Nxa); grid on;

