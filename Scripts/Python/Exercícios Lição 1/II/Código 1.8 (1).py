import numpy as np
import matplotlib.pyplot as plt

# Data set
L = 2.0                   # bar length [m]
nx = 100                  # number of x-points
x = np.linspace(0, L, nx) # x coordinates
h = L / (nx - 1)          # intervals length
A = np.pi * (0.015**2)    # section area [m^2]
E = 210e6                 # Young modulus [Pa]
q0 = 1e3                  # Distributed Load [N/m]
ua = 0                    # left displacement [m]
ub = 0                    # right displacement [m]

# Load definitions
y = x / L                 # normalized position vector
p = q0 * np.ones(len(y))

# Get particular solution up and its derivative
up = -q0 * x**2 / (2 * E * A)
dup = -q0 * x / (E * A)

# Get Constant Values for uh and its derivative duh
up0 = up[0]
upL = up[-1]
c2 = ua - up0
c1 = (ub - upL - c2) / L

# Get solution uana and its derivative duana
uana = up + c1 * x + c2
duana = dup + c1

# Plot the distributed load
plt.figure(figsize=(10, 8))

plt.subplot(3, 1, 1)
plt.bar(x, p, width=h, align='edge')
plt.grid(True)
plt.title('Carregamento Distribuído')
plt.xlabel('Posição [m]')
plt.ylabel('Carga [N/m]')

# Plot do campo de deslocamento
plt.subplot(3, 1, 2)
plt.plot(x, uana, 'r', label='u(x)')
plt.grid(True)
plt.title('Campo de Deslocamento')
plt.xlabel('Posição [m]')
plt.ylabel('Deslocamento [m]')
plt.legend()

# Plot da derivada do deslocamento (deformação)
plt.subplot(3, 1, 3)
plt.plot(x, duana, 'g', label='du(x)/dx')
plt.grid(True)
plt.title('Deformação')
plt.xlabel('Posição [m]')
plt.ylabel('Deformação [m]')
plt.legend()

plt.tight_layout()
plt.show()