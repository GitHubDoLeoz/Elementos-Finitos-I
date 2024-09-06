''' Ache a solução analítica do problema da barra de seção constante
com carga q(x) = q0 constante, considerando u(0) = 0 eu(L) = ub valor 
conhecido constante. Compare a sua solução com a obtida no código 1.8 (1),
que é igual ao exercício I.
A barra é feita de aço, a seção é circular com diâmetro 30 mm, e a 
carga constante de 1kN/m. Verifique sua resposta para diferentes valores 
de ub, comparando com os resultados obtidos no código 1.8 (1), que é igual 
ao exercício I. '''

import numpy as np
import matplotlib.pyplot as plt

# Entradas
L = 2.0 # Comprimento da barra [m]
nx = 200 # Número de pontos em x
x = np.linspace(0, L, nx) # Coordenadas x
h = L / (nx - 1) # Comprimento dos intervalos
A = np.pi * (0.015**2) # Área da seção [m^2]
E = 210e6 # Módulo de Young [Pa]
q0 = 1e3 # Carga distribuída [N/m]
ua = 0 # Deslocamento à esquerda [m]
ubs = [0.0025, 0.005, 0.0075, 0.01, 0.025] # Deslocamento à direita [m]

# Definições da carga
y = x / L # Vetor de posição normalizada
p = q0 * np.ones(len(y))

for ub in ubs:
    # Obter a solução particular up e sua derivada
    up = (-q0 * x**2) / (2 * E * A) + ((E * A * ub) / L + (q0 * L) / 2) * x
    dup = (-q0 * x) / (E * A) + ((E * A * ub) / L + (q0 * L) / 2)

    # Obter os valores constantes para uh e sua derivada duh
    up0 = up[0]
    upL = up[-1]
    c2 = ua - up0
    c1 = (ub - upL - c2) / L

    # Obter a solução uana e sua derivada duana
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

    # Plotar o deslocamento
    plt.subplot(3, 1, 2)
    plt.plot(x, uana, 'r', label='Deslocamento u(x)')
    plt.grid(True)
    plt.title('Campo de Deslocamento')
    plt.xlabel('Posição [m]')
    plt.ylabel('Deslocamento [m]')
    plt.legend()

    # Plotar a deformação
    plt.subplot(3, 1, 3)
    plt.plot(x, duana, 'g', label='Deformação du(x)/dx')
    plt.grid(True)
    plt.title('Campo de Deformação')
    plt.xlabel('Posição [m]')
    plt.ylabel('Deformação')
    plt.legend()

    plt.tight_layout()
    plt.show()