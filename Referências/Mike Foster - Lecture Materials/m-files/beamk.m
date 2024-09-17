%Local stiffness matrix for a frame element

A = input('Area of element = ');
E = input('Modulus of element = ');
I = input('Moment of inertia of element = ');
L = input('Length of element = ');
k = [12*I*E/L^3 6*I*E/L^2 -12*I*E/L^3 6*I*E/L^2;...
    6*I*E/L^2 4*I*E/L -6*I*E/L^2 2*I*E/L;...
    -12*I*E/L^3 -6*I*E/L^2 12*I*E/L^3 -6*I*E/L^2;...
    6*I*E/L^2 2*I*E/L -6*I*E/L^2 4*I*E/L]