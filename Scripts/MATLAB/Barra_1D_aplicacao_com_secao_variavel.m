%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Barra 1D  - aplica��o com se��o var�vel
%
%   R. Pavanello
%   Outubro 2020
%    @ ltm.fem.unicamp.br
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; 
clear all;
close all;
% Entrada dados 

% -------- Matriz de Coordenadas do sistema ----
%coord=[ X | Y | Z] => Matriz de coordenadas 
coord=[0 0 0;
       2 0 0;
       4 0 0;
       6 0 0];

% ------- Matriz de incid�ncia dos elementos
%inci=[ n elemnto ,tipo, tab mat, tab geo , n� 1 , n� 2 , ...]
% tipo 1 > barra 1D
% tipo 2 > treli�a
inci= [1 1 1 1 1 2;
          2 1 1 2 2 3;
          3 1 1 3 3 4];

% ------ Tabela de Materiais -----------------------
%
%
%  Tmat[ Material 1 | Material 2 | Material 3 ...]
%
%  linha 1:Mod de elasticidade
%  linha 2:Coeficiente de Poisson
%  linha 3:Massa espec�fica
  
Tmat=[210E9   70e9  ; 
      .33     .27   ;
      7850    2700  ];

% ------ Tabela de prop. geom�tricas--------------
%  Tgeo[ Geo 1 | Geo 2 | Geo 3 ...]
%
%  linha 1:�rea
%  linha 2:Momento de inercia da se��o
%  linha 3: ...
  
Tgeo=[.1*.1          .1*0.07        .1*0.04    ; 
      .1*.1^3/12     .1*0.07^3/12   .1*0.04^3/12  ];

% ------ condi��es de contorno ---------------------------------------------%
%cc=[n� | grau de liberdade | valor]
%
%   Grau de liberdade 1 --> u
%   Grau de liberdade 2 --> v
%   Grau de liberdade 3 --> w
%   Grau de liberdade 4 --> ox
%   Grau de liberdade 5 --> oy
%   Grau de liberdade 6 --> oz

cc=[1 1 0
       1 2 0
       2 2 0
      3 2 0
      4 2 0];
 
% ------ carregamentos externos ------------------------------------------%
% fe=[n� | grau | valor]
%
%   Garu de liberdade 1 --> Fx
%   Garu de liberdade 2 --> Fy
%   Garu de liberdade 3 --> Fz
%   Garu de liberdade 4 --> Mx
%   Garu de liberdade 5 --> My
%   Garu de liberdade 6 --> Mz

fe=[4 1 1000];
  
%%%%%%%%%%%%%%%%%%%% solver %%%%%%%%%%%%%%%%%%%%%%%

nel=size(inci,1);   %n�mero de elementos
nnos=size(coord,1); %n�mero de nos
ncc=size(cc,1);     %n�mero de condi��es de contorno
nfe=size(fe,1);     %n�mero de for�as externas

% Calcular o volume e o centro de gravidade da estrutura
Vtotal=0;
Mtotal=0;
Cg=0;
g=9.81;
for i=1:nel
no1=inci(i,5);
no2=inci(i,6);
x1=coord(no1,1);
y1=coord(no1,2);
x2=coord(no2,1);
y2=coord(no2,2);
l=sqrt((x2-x1)^2+(y2-y1)^2);
A=Tgeo(1,inci(i,4));
rho=Tmat(3,inci(i,3));
Vtotal=Vtotal+A*l;
Mtotal=Mtotal+rho*A*l;
xce=(x1+x2)/2;
yce=(y1+y2)/2;
Cg=Cg+xce*A*l*rho;
end
Cg=Cg/(Mtotal);

% c�lculo do deslocamento 

%cria matriz id, 
id=zeros(2,nnos);
%le as condi��es de contorno e trava id
for k=1:ncc
    id(cc(k,2),cc(k,1))=1;
end
neq=0;
for k=1:nnos
    for j=1:2
    if(id(j,k)==0)
       neq=neq+1;
       id(j,k)=neq;
    else
       id(j,k)=0;
    end
    end
end

kg=zeros(neq,neq);
for i=1:nel
no1=inci(i,5);
no2=inci(i,6);
x1=coord(no1,1);
y1=coord(no1,2);
x2=coord(no2,1);
y2=coord(no2,2);
l=sqrt((x2-x1)^2+(y2-y1)^2);
A=Tgeo(1,inci(i,4));
E=Tmat(1,inci(i,3));
ke=(E*A/l)*[ 1 -1 ;-1 1];
loc=[id(1,no1) id(1,no2)];        
  for il=1:2
    ilg=loc(il);
    if ilg~=0
    for ic=1:2
        icg=loc(ic);
        if icg~=0
           kg(ilg,icg)=kg(ilg,icg)+ke(il,ic);
        end
    end
    end
  end    
end
    
%  montar o vetor for�a
f=zeros(neq,1);
for k=1:nfe
    f(id(fe(k,2),fe(k,1)))=fe(k,3);
end
% resolvendo o istema
u=kg\f;
%reconstruindo o vetor solu��o num�rica
uh=zeros(nnos,1);
for i=1:nnos
    if(id(1,i)~=0)
       uh(i)=u(id(1,i));
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% p�s-processamento  
%
plot(coord(:,1),uh);grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Sugest�o:
%1) calcular a solu��o anal�tica da barra 
% de se��o variando linearmente e comparar 
% a solu��o num�rica com a solu��o anal�tica
%
%2)calcular as tens�es ecomparar com as solu��es 
% anal�ticas
%
%3) Refinar a malha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%