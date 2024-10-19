%**************************************************************************
% 
%   Plot malha: Plota a malha de elementos finitos a partir dos nos e   
%                       conectividade                  
%
%	%numbering == 1: Plota a malha em preto com os nós e elementos
%                              0: Plota a malha em preto somente
%
%    % inci(tmat, tgeo, no1, no2 no3,...)
%     %coord( x1,y1; x2,y2 ; ...)
%
%   Author: Renato Pavanello
%   Copyright (c) 2016 by The DMC/FEM/UNICAMP.
%   $Revision: 1.0 $
%
%**************************************************************************
function plotMalha(coord,inci,index)
%se numbering é
% 1: Plota a malha em preto com os nós e os números de elementos
% 0: Plota a malha em preto somente
nel=length(inci(:,1));  %numero de elementos
nnos=length(coord(:,1));%numero de nós
vnos=[1:nnos]';
nnel=size(inci(:,3:end),2);      %Numero de ntoseleme por elemento
dimension=size(coord(2:3),2); %Dimensao da malha
%Initializacao das matrices
X = zeros(nnel,nel) ;
Y = zeros(nnel,nel) ;
if dimension==2            %For 2D plots
    for iel=1:nel
        for i=1:nnel
            X(i,iel)=coord(inci(iel,i+2),2);
            Y(i,iel)=coord(inci(iel,i+2),3);
        end
    end
    
    switch index
        case 0
        %Plotting the FEM mesh
        plot(X,Y,'k') 
        title('Finite Element Mesh') ;
        fill(X,Y,'w') % Preenche os elementos de branco para ficar mais visivel
        axis off 
        axis equal

        case 1
        %Plotting the FEM mesh, display Node numbers and Element numbers
        plot(X,Y,'k') 
        title('Finite Element Mesh') ;
        fill(X,Y,'w') % Preenche os elementos de branco para ficar mais visivel
        axis off 
        axis equal
        %Numeracao
        text(coord(:,2),coord(:,3),int2str(vnos(:,1)),'fontsize',8,'color','k');
        for i = 1:nel
            text(sum(X(:,i))/nnel,sum(Y(:,i))/nnel,int2str(i),'fontsize',10,'color','r');
        end
                 
          otherwise
            disp('Unknown method in PlotMalha.')
    end
    end
end