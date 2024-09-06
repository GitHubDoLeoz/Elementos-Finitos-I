''' A barra é feita de aço com E = 210GPa, com seção circular de diâmetro
30 mm e a carga linear com q0 = 1kN/m e L = 10m. Calculee faça um gráfico 
da solução analítica em deslocamento e em tensão. Lembrando que neste caso 
a tensão pode ser calculada por σxx = Nx(x)/A. ''' 

import numpy as np
import matplotlib.pyplot as plt

# Definições de parâmetros
L = 10.0  # Comprimento da barra [m]
nx = 200  # Número de pontos em x
x = np.linspace(0, L, nx) # Coordenadas x
h = L / (nx - 1)  # Comprimento dos intervalos
A = np.pi * (0.015**2)  # Área da seção [m^2]
E = 210e6  # Módulo de Young [Pa]
q0 = 1e3  # Carga distribuída [N/m]
ua = 0  # Deslocamento à esquerda [m]
ub = 0  # Deslocamento à direita [m]

# Definições da carga
y = x / L  # Vetor de posição normalizada
p = q0 * y

# Obter a solução particular up e sua derivada
up = q0 * (L**2 * x - x**3) / (6 * E * A * L)
dup = q0 * (L**2 - 3*x**2) / (6 * E * A * L)

# Obter os valores constantes para uh e sua derivada duh
up0 = up[0]
upL = up[-1]
c2 = ua - up0
c1 = (ub - upL - c2) / L

# Obter a solução uana e sua derivada duana
uana = up + c1 * x + c2
duana = dup + c1

# Calcular a tensão
tensao = E * duana / 1e6

# Plotar o carregamento distribuído
plt.subplot(3, 1, 1)
plt.bar(x, p, width=h, align='edge')
plt.grid(True)
plt.title('Carregamento Linear')
plt.xlabel('Posição [m]')
plt.ylabel('Carga [N/m]')

# Plotar o deslocamento
plt.subplot(3, 1, 2)
plt.plot(x, uana, 'r', label='Deslocamento u(x)')
plt.grid(True)
plt.title('Campo de Deslocamento')
plt.xlabel('Posição [m]')
plt.ylabel('Deslocamento [m]')
plt.legend()

# Plotar a tensão
plt.subplot(3, 1, 3)
plt.plot(x, tensao, 'b', label='Tensão σxx(x)')
plt.grid(True)
plt.title('Campo de Tensão')
plt.xlabel('Posição [m]')
plt.ylabel('Tensão [MPa]')
plt.legend()

plt.tight_layout()
plt.show()