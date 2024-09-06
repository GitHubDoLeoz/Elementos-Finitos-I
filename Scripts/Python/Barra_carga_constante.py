import numpy as np
import matplotlib.pyplot as plt

# Entrada de dados
L = 1.0  # comprimento total da Barra
E = 100e9  # módulo de elasticidade
A = (10e-3)**2  # área
F = 500  # carga pontual na extremidade direita x=L
po = 2000  # carga distribuída constante
nel = 3  # número de elementos

# Gerando a malha
nnos = nel + 1  # número de nós
he = L / nel  # comprimento do elemento
xn = np.linspace(0, L, nnos)  # coordenadas nodais
inci = np.array([[i, i + 1] for i in range(nnos - 1)])  # formação dos elementos

# Montagem da matriz de Rigidez
Kg = np.zeros((nnos, nnos))
Fg = np.zeros(nnos)

ke = (E * A / he) * np.array([[1, -1], [-1, 1]])  # Rigidez do elemento
fe = (po * he / 2) * np.array([1, 1])  # Carga nodal equivalente > po

for e in range(nel):
    nodes = inci[e, :]
    Kg[np.ix_(nodes, nodes)] += ke
    Fg[nodes] += fe

Fg[-1] += F  # carga Pontual no nó da Direita
freedofs = np.arange(1, nnos)  # aplicar as condições de contorno
uh = np.zeros(nnos)
uh[freedofs] = np.linalg.solve(Kg[np.ix_(freedofs, freedofs)], Fg[freedofs])

# Pós-processamento
NxEl = np.zeros(nel)
for e in range(nel):
    nodes = inci[e, :]
    NxEl[e] = (E * A / he) * np.dot([-1, 1], uh[nodes])

# cálculo da solução analítica
x = np.linspace(0, L, 100)
u = (F / (E * A)) * x + (po / (2 * E * A)) * (2 * L - x) * x
Nx = F + po * (L - x)

# gráficos
plt.figure(figsize=(10, 6))

# Deslocamentos
plt.subplot(2, 1, 1)
plt.plot(xn, uh, 'o-', label='Numérica')
plt.plot(x, u, 'r-x', label='Analítica')
plt.grid(True)
plt.legend()
plt.xlabel('Posição x [m]')
plt.ylabel('Deslocamento u(x) [m]')

# Força Normal
plt.subplot(2, 1, 2)
plt.bar((xn[1:] + xn[:-1]) / 2, NxEl, width=he, align='center', label='Numérica')
plt.plot(x, Nx, 'r-x', label='Analítica')
plt.grid(True)
plt.axis([0, L, -1.5 * abs(np.min(Nx)), 1.5 * abs(np.max(Nx))])
plt.xlabel('Posição x [m]')
plt.ylabel('Carga Normal Nx [N]')
plt.legend()

plt.tight_layout()
plt.show()