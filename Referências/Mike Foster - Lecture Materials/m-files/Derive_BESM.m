%Development of the beam element stiffness matrix

disp('*****Declaring of variables and defining the Shape Functions')
disp('syms u_i1 u_i2 u_j1 u_j2 x L E I')
syms u_i1 u_i2 u_j1 u_j2 x L E I
Si1 = 1 - 3*x^2/L^2 + 2*x^3/L^3
Si2 = x - 2*x^2/L + x^3/L^2
Sj1 = 3*x^2/L^2 - 2*x^3/L^3
Sj2 = -x^2/L + x^3/L^2
pause

disp('*****Lateral position equation for a beam at any point x along the beam')
disp('y = Si1*u_i1 + Si2*u_i2 + Sj1*u_j1 + Sj2*u_j2')
y = Si1*u_i1 + Si2*u_i2 + Sj1*u_j1 + Sj2*u_j2
pause

disp('*****Second derivative of the position equation')
disp('y2 = diff(y,2)')
y2 = diff(y,2)
pause

disp('*****Calculating the Strain Energy')
disp('strain = E*I/2 * int(y2^2,0,L)')
strain = E*I/2 * int(y2^2,0,L)
pause

disp('*****Minimize Strain Energy and Develop the Stiffness Matrix')
disp('Differentiating the Strain Energy with respect to u_i1 (divide by E*I/L^3 for clarity)')
disp('diff(strain,u_i1)/(E*I/L^3)')
diff(strain,u_i1)/(E*I/L^3)
disp('Differentiating the Strain Energy with respect to u_i2 (divide by E*I/L^3 for clarity)')
disp('diff(strain,u_i2)/(E*I/L^3)')
diff(strain,u_i2)/(E*I/L^3)
disp('Differentiating the Strain Energy with respect to u_j1 (divide by E*I/L^3 for clarity)')
disp('diff(strain,u_j1)/(E*I/L^3)')
diff(strain,u_j1)/(E*I/L^3)
disp('Differentiating the Strain Energy with respect to u_j2 (divide by E*I/L^3 for clarity)')
disp('diff(strain,u_j2)/(E*I/L^3)')
diff(strain,u_j2)/(E*I/L^3)