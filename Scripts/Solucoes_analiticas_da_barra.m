clear all; close all; clc;

% Data set
L = 1.0;                  % bar length [m]
nx = 100;                 % number of x-points
x = linspace(0, L, nx)';  % x coordinates
h = L / (nx-1);             % intervals length
A = pi * (0.015^2);       % section area [m^2]
E = 210e9;                % Young modulus [Pa]
% function types: con, lin, par, sin, cos, exp
type = 'lin';
q0 = 1e3;                 % Distributed Load [N/m]
ua = 0;                   % left displacement [m]
ub = 5.7825e-6;               % right displacement [m]

% Load definitions
y = x/L;                  % normalized position vector
switch type
    case 'con' % constant
        p = q0*ones(length(y),1);
    case 'lin' % linear
        p = q0*y;
    case 'par' % parabola
        p = q0*y.*(1-y);
    case 'sin' % sinus
        p = q0*sin(pi*y);
    case 'cos' % cosinus
        p = q0*cos(pi*y);
    case 'exp' % exponential
        p = q0*exp(y);
    otherwise  % default = constant
        warning(['tipo de carregamento >>> ',type,' <<< nao implementado !!!'])
end

% get particular solution up and its derivative
switch type
case 'con' % constant
  up = -q0*x.^2/(2*E*A);
  dup = -q0*x/(E*A);
case 'lin' % linear
  up = -q0*x.^3/(6*E*A*L);
  dup = -q0*x.^2/(2*E*A*L);
case 'par' % parabola
  up = (-q0*x.^3.*(2*L-x))./(12*E*A*L^2);
  dup = (-q0*x.^2.*(3*L-2*x))./(6*E*A*L^2);
case 'sin' % sinus
  up = q0*(L/pi)^2*sin(pi*x/L)/(E*A);
  dup = q0*(L/pi)*cos(pi*x/L)/(E*A);
case 'cos' % cosinus
  up = q0*(L/pi)^2*cos(pi*x/L)/(E*A);
  dup = -q0*(L/pi)*sin(pi*x/L)/(E*A);
case 'exp' % exponential
  up = -q0*L^2*exp(x/L)/(E*A);
  dup = -q0*L*exp(x/L)/(E*A);
otherwise % default = constant
  warning(['tipo de carreamento >>>', type, '<<<<< nao implementado !!!'])
end
% get Constant Values for uh and its derivative duh
up0 = up(1);
upL = up(end);
c2 = ua - up0;
c1 = (ub - upL - c2)/L;
% get solution uana and its derivative duana
uana = up + c1*x+c2;
duana = dup + c1;

subplot(1,1,1), plot(x, uana, 'r', 'LineWidth', 1.5); grid on;
title('Campo de deslocamento para ua = 0 e ub = $\overline{ub}$ = 5.7825e-6m', 'Interpreter', 'latex');
xlabel('Posição [m]')
ylabel('Deslocamentos [m]')
legend('Deslocamento u(x)')