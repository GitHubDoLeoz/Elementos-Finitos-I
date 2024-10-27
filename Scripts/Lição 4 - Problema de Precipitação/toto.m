syms qsi eta A f A0 A1 A2 N1 N2 N3 N4 u1 u2 u3 u4

N1=(1/4)*(1-qsi)*(1-eta);
N2=(1/4)*(1+qsi)*(1-eta);
N3=(1/4)*(1+qsi)*(1+eta);
N4=(1/4)*(1-qsi)*(1+eta);

f=(N1*u1+N2*u2+N3*u3+N4*u4)*(A0+A1*qsi+A2*eta);

A=int(int(f,qsi,-1, 1),eta,-1,1);
