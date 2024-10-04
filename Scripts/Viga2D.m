%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      Viga Euler - EF 
%
%
%      E Izz d4v/dx4 = q(x) 
%
%      v(0)=0
%      Mz(0)=0
%      thetaz(L)=0
%      v(L)=0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; 
clear all; 
close all; 

L=5; % comprimento em [m]

Izz=(0.04^4)/12; 
E=2.07e11;

F=-10000;
M=-10000;
qo=1000;

nel=30;

nnos=nel+1;
he=L/nel;

%  sistema de coordenadas local 
xe=0:he/10:he;

%  sistema de coordenadas global 
xn=0:he:L; 

% vetor de incidencia 
for i=1:nel
    inci(i,:)=[ i i+1];
end

% inicializando as matrizes 

kg=zeros(2*nnos,2*nnos);
fg=zeros(2*nnos,1);
ug=zeros(2*nnos,1);

% montagem da matriz kg
 for e=1:nel
     
     no1=inci(e,1);
     no2=inci(e,2); 
     he=xn(no2)-xn(no1);
     
     ke=(E*Izz/he^3)* [12  6*he    -12    6*he   ;
                      6*he 4*he^2  -6*he  2*he^2 ;
                      -12  -6*he    12   -6*he   ;
                      6*he 2*he^2   -6*he  4*he^2];
                  
      fe=[qo*he/2; qo*he^2/12 ;qo*he/2 ;-qo*he^2/12]; 
                  
      loc=[2*no1-1 2*no1 2*no2-1 2*no2];
      kg(loc,loc)=kg(loc,loc)+ke;
      fg(loc,1)=fg(loc,1)+fe;
 end
 
 %
 %   condi��es de contorno 
 % 
 fixedDofs=[ 1 2 2*nnos-1 2*nnos];
 allDofs=[1:2*nnos];
 freeDofs=setdiff(allDofs,fixedDofs);
 
 %fg(2*round(nnos/2),1)=M;
 %fg(2*round(nnos/2)-1,1)=F;
 
 ug(freeDofs)=kg(freeDofs,freeDofs)\fg(freeDofs,1);
 
 
 figure(1);subplot(4,1,4);plot(xn',ug(1:2:2*nnos-1),'b-o');grid on;
 xlabel('Position [m]');ylabel('Displacement [m]');
 
 figure(1);subplot(4,1,3);plot(xn',ug(2:2:2*nnos),'r-o');grid on;
 xlabel('Position [m]');ylabel('Rotation [rad]');
 
 MzEl=zeros(nel,2); % momento nos n�s dos elementos
 for e=1:nel
     no1=inci(e,1);
     no2=inci(e,2);
     x1=0;
     x2=he;
     d2n1dx2=(-6/he^2)+(12/he^3)*x1;
     d2n2dx2=(-4/he)+(6/he^2)*x1;
     d2n3dx2=(6/he^2)-(12/he^3)*x1;
     d2n4dx2=(-2/he)+(6/he^2)*x1;
     MzEl(e,1)=E*Izz*(d2n1dx2*ug(2*no1-1)+ d2n2dx2*ug(2*no1) ...
                    + d2n3dx2*ug(2*no2-1)+ d2n4dx2*ug(2*no2));
                
     d2n1dx2=(-6/he^2)+(12/he^3)*x2;
     d2n2dx2=(-4/he)+(6/he^2)*x2;
     d2n3dx2=(6/he^2)-(12/he^3)*x2;
     d2n4dx2=(-2/he)+(6/he^2)*x2;
     MzEl(e,2)=E*Izz*(d2n1dx2*ug(2*no1-1)+ d2n2dx2*ug(2*no1) ...
                    + d2n3dx2*ug(2*no2-1)+ d2n4dx2*ug(2*no2));
                
     figure(1);subplot(4,1,2);area([xn(no1) xn(no2)],[MzEl(e,1) MzEl(e,2)], 'FaceColor','r');
     hold on;
 end
 hold off;
 xlabel('Position [m]');ylabel('Bending Moment [Nm]');
 
 
  VyEl=zeros(nel,1); % momento nos n�s dos elementos
 for e=1:nel
     no1=inci(e,1);
     no2=inci(e,2);
     x1=0;
     x2=he;
     d3n1dx3=(12/he^3);
     d3n2dx3=(6/he^2);
     d3n3dx3=(-12/he^3);
     d3n4dx3=(6/he^2);
     VyEl(e,1)=E*Izz*(d3n1dx3*ug(2*no1-1)+ d3n2dx3*ug(2*no1) ...
                    + d3n3dx3*ug(2*no2-1)+ d3n4dx3*ug(2*no2));
     figure(1);subplot(4,1,1);area([xn(no1) xn(no2)],[VyEl(e,1) VyEl(e,1)],'FaceColor','r');
     hold on;
 end
 hold off;
 xlabel('Position [m]');ylabel('Shear force [N]');