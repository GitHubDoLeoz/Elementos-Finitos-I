import numpy as np
import matplotlib.pyplot as plt

# Entradas
L = 2.0                   # Comprimento da barra [m]
nx = 100                  # Número de pontos em x
x = np.linspace(0, L, nx) # Coordenadas x
h = L / (nx - 1)          # Comprimento dos intervalos
A = 0.01                  # Área da seção [m^2]
E = 210e6                 # Módulo de Young [Pa]
q0 = 1e3                  # Carga distribuída [N/m]
ua = 0                    # Deslocamento à esquerda [m]
ub = 0                    # Deslocamento à direita [m]

# Definições da carga
y = x / L                 # Vetor de posição normalizada
p = q0 * np.ones(len(y))

# Obtenha a solução particular up e sua derivada
up = -q0 * x**2 / (2 * E * A)
dup = -q0 * x / (E * A)

# Obtenha os valores constantes para uh e sua derivada duh
up0 = up[0]
upL = up[-1]
c2 = ua - up0
c1 = (ub - upL - c2) / L

# Obtenha a solução uana e sua derivada duana
uana = up + c1 * x + c2
duana = dup + c1

# Plotar o carregamento distribuído
plt.figure(figsize=(10, 8))

plt.subplot(3, 1, 1)
plt.bar(x, p, width=h, align='edge')
plt.grid(True)
plt.title('Carregamento Distribuído')
plt.xlabel('Posição [m]')
plt.ylabel('Carga [N/m]')

# Plotar o campo de deslocamento
plt.subplot(3, 1, 2)
plt.plot(x, uana, 'r', label='Deslocamento u(x)')
plt.grid(True)
plt.title('Campo de Deslocamento')
plt.xlabel('Posição [m]')
plt.ylabel('Deslocamento [m]')
plt.legend()

# Plotar a derivada do campo de deslocamento
plt.subplot(3, 1, 3)
plt.plot(x, duana, 'g', label='Derivada du(x)/dx')
plt.grid(True)
plt.title('Derivada do Campo de Deslocamento')
plt.xlabel('Posição [m]')
plt.ylabel('Derivada [m/m]')
plt.legend()

plt.tight_layout()
plt.show()