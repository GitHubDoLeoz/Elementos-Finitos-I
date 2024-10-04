clc; 
clear all;
close all;

%% Entrada de dados 
% -------- Matriz de coordenadas do sistema --------
% Coord=[X | Y | Z] => Matriz de coordenadas 
coord=[0 0 0;
       2 0 0;
       4 0 0;
       6 0 0];

% -------- Matriz de incidência dos elementos --------
% inci=[n elemento, tipo, tab mat, tab geo, nó 1, nó 2, ...]
% Tipo 1 > Barra 1D
% Tipo 2 > Treliça
inci= [1 1 1 1 1 2;
          2 1 1 2 2 3;
          3 1 1 3 3 4];

% -------- Tabela de materiais --------
%
%  Tmat[Material 1 | Material 2 | Material 3 ...]
%
%  Linha 1: Módulo de elasticidade
%  Linha 2: Coeficiente de Poisson
%  Linha 3: Massa específica
  
Tmat=[210E9   70e9  ; 
      .33     .27   ;
      7850    2700  ];

% -------- Tabela de propriedades geométricas --------
%  Tgeo[Geo 1 | Geo 2 | Geo 3 ...]
%
%  linha 1: Área
%  linha 2: Momento de inércia da seção
%  linha 3: ...
  
Tgeo=[.1*.1          .1*0.07        .1*0.04    ; 
      .1*.1^3/12     .1*0.07^3/12   .1*0.04^3/12  ];

% -------- Condições de contorno --------
%cc=[nó | grau de liberdade | valor]
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
 
% -------- Carregamentos externos --------
% fe=[nó | grau | valor]
%
%   Grau de liberdade 1 --> Fx
%   Grau de liberdade 2 --> Fy
%   Grau de liberdade 3 --> Fz
%   Grau de liberdade 4 --> Mx
%   Grau de liberdade 5 --> My
%   Grau de liberdade 6 --> Mz

fe=[4 1 1000];
  
%% Solver
nel=size(inci,1);   %número de elementos
nnos=size(coord,1); %número de nos
ncc=size(cc,1);     %número de condi��es de contorno
nfe=size(fe,1);     %número de for�as externas

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

% Cálculo do deslocamento 
% Cria matriz id
id=zeros(2,nnos);
% Lê as condições de contorno e trava ID
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
    
% Montar o vetor força
f=zeros(neq,1);
for k=1:nfe
    f(id(fe(k,2),fe(k,1)))=fe(k,3);
end
% Resolvendo o istema
u=kg\f;
% Reconstruindo o vetor solução numérica
uh=zeros(nnos,1);
for i=1:nnos
    if(id(1,i)~=0)
       uh(i)=u(id(1,i));
    end
end

% Pós-processamento  
plot(coord(:,1),uh);grid on;