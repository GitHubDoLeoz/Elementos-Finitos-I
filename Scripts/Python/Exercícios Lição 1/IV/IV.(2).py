''' A barra é feita de aço com E = 210GPa, com seção retangular com
b = 30mm e h = 40mm para o ponto x = L, o comprimento é L = 10m. 
Faça um gráfico da solução analítica em deslocamento eem tensão. 
Lembrando que neste caso a tensão pode ser calculada por σxx = Nx(x)/A. '''

import numpy as np
import matplotlib.pyplot as plt

# Entradas
L = 10.0  # Comprimento da barra [m]
nx = 200  # Número de pontos em x
x = np.linspace(0, L, nx)  # Coordenadas x
b = 0.03  # Base da seção na extremidade livre [m]
h = 0.04  # Altura da seção na extremidade livre [m]
A_0 = b * h  # Área da seção na extremidade livre [m^2]
E = 210e6  # Módulo de Young [Pa]
F = 0.5e3  # Força aplicada na extremidade [N]

# Função da área variável ao longo da barra
A_x = A_0 * (3 - 2 * x / L)  # Área variando de 3A_0 a A_0

# Resolver a equação diferencial para deslocamento
dx = x[1] - x[0]
u = np.zeros(nx)
for i in range(1, nx):
    A_avg = 0.5 * (A_x[i] + A_x[i-1])  # Média da área entre pontos
    u[i] = u[i-1] + (F * dx) / (E * A_avg)  # Método de integração numérica

# Calcular tensão ao longo da barra
tensao = F / A_x
tensao = tensao / 1000.0

# Plotar o deslocamento
plt.subplot(2, 1, 1)
plt.plot(x, u, 'r', label='Deslocamento u(x)')
plt.grid(True)
plt.title('Deslocamento ao longo da barra')
plt.xlabel('Posição [m]')
plt.ylabel('Deslocamento [m]')
plt.legend()

# Plotar a tensão
plt.subplot(2, 1, 2)
plt.plot(x, tensao, 'b', label='Tensão σ(x)')
plt.grid(True)
plt.title('Tensão ao longo da barra')
plt.xlabel('Posição [m]')
plt.ylabel('Tensão [MPa]')
plt.legend()

plt.tight_layout()
plt.show()