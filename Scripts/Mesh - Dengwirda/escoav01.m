%%%%%%%%%%%%%%%%%%%%%%
%
%      Potencial T3  
%           
%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all; 

%%
%
%     Entrada de dados
%
%

q=100;          % força externa [N]

% Gera malha 
initmsh();              % MESH2D function to update the path

% Coord = [x y]
node = [                % list of xy "node" coordinates
        0, 0            % Beam 
        15, 0
        15, 9
        0, 9
        3, 3            % inner square hole 
        6, 3
        6, 6
        3, 6];

edge = [                % list of "edges" between nodes
    1, 2                % outer square
    2, 3
    3, 4
    4, 1
    5, 6                % inner square
    6, 7
    7, 8
    8, 5];
    
% ************ Call mesh-gen. *************************

hfun = +.5;   % uniform "target" edge-lengths
[coord,etri,inci,tnum] = refine2(node,edge,[],[],hfun) ;

plotMalha(coord,inci,1); hold on;
           
%%  Solver 
%% %%%%%%%%%%%%%%%
%
% Matriz do elementos 
% Matriz Global       
%
nnos=size(coord,1);
nel=size(inci,1);
kg=zeros(nnos,nnos);
fg=zeros(nnos,1);

for i=1:nel
% Calculo da matriz do elemento
  no1=inci(i,1);
  no2=inci(i,2);
  no3=inci(i,3);
  x1=coord(no1,1);
  y1=coord(no1,2);
  x2=coord(no2,1);
  y2=coord(no2,2);
  x3=coord(no3,1);
  y3=coord(no3,2);
  J=[ x2-x1 y2-y1 ; x3-x1 y3-y1];
  A(i)=det(J)/2;
  ke(1,1)=(y3-y2)^2+(x3-x2)^2;
  ke(2,2)=(y3-y1)^2+(x3-x1)^2;
  ke(3,3)=(y2-y1)^2+(x2-x1)^2;
  ke(1,2)=(y2-y3)*(y3-y1)+(x3-x2)*(x1-x3);
  ke(2,1)=ke(1,2);
  ke(1,3)=(y2-y1)*(y3-y2)+(x2-x1)*(x3-x2);
  ke(3,1)=ke(1,3);
  ke(2,3)=(y1-y3)*(y2-y1)+(x1-x3)*(x2-x1);
  ke(3,2)=ke(2,3);
  ke=(.25*A(i))*ke;
  dofe=[no1 no2 no3];
  kg(dofe,dofe)=kg(dofe,dofe)+ke;
end

%% %%%%%%%%%%%%%%%
% Vetor de carga
% Aplicado no nó 6 direção y
NF=[1 14 17 10 4];
fg(NF)=fg(NF)+2*q;

%% %%%%%%%%%%%%%%%
%
%      Restrições 
%      1> no1 direçao x
%      2> no4 direçao x 
%      3> no4 direçao y

FixedDofs=[2 3 11 15 18];
AllDofs=[1:nnos];
FreeDofs=setdiff(AllDofs,FixedDofs);

%% %%%%%%%%%%%%%%%%
%
%      Solver 
ug=zeros(nnos,1);
ug(FreeDofs)=kg(FreeDofs,FreeDofs)\fg(FreeDofs);

for i=1:nel
  no1=inci(i,1);
  no2=inci(i,2);
  no3=inci(i,3);
  x1=coord(no1,1);
  y1=coord(no1,2);
  x2=coord(no2,1);
  y2=coord(no2,2);
  x3=coord(no3,1);
  y3=coord(no3,2);
  x = [x1; x2; x3];
  y = [y1; y2; y3];
  c = [ug(no1); ug(no2); ug(no3)];
  figure(2)
  patch(x,y,c)
  hold on
end

hold off 
colorbar