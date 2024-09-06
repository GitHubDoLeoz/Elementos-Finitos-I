import numpy as np
import matplotlib.pyplot as plt
from scipy.linalg import eigh

# Definição dos parâmetros
L = 1
nel = 40

# Propriedades dos materiais
Tmat = np.array([
    [2.1e11, 7800, 0.3],
    [70e9, 2700, 0.27]
])

# Propriedades geométricas
Tgeo = np.array([
    [10e-3**2, (10e-3**4)/12, (10e-3**4)/12],
    [5e-3**2, (5e-3**4)/12, (5e-3**4)/12]
])

nnos = nel + 1
h = L / nel
coord = np.linspace(0, L, nnos)

# Matriz de conectividade
inci = np.array([
    [1, 1, i, i+1] for i in range(1, nnos)
])

K = np.zeros((nnos, nnos))
M = np.zeros((nnos, nnos))

for i in range(nel):
    no1 = inci[i, 2] - 1
    no2 = inci[i, 3] - 1
    x1 = coord[no1]
    x2 = coord[no2]
    h = x2 - x1
    E = Tmat[inci[i, 0] - 1, 0]
    rho = Tmat[inci[i, 0] - 1, 1]
    A = Tgeo[inci[i, 1] - 1, 0]
    
    ke = (E * A / h) * np.array([
        [1, -1],
        [-1, 1]
    ])
    
    me = (rho * A * h / 6) * np.array([
        [2, 1],
        [1, 2]
    ])
    
    loc = [no1, no2]
    K[np.ix_(loc, loc)] += ke
    M[np.ix_(loc, loc)] += me

# Cálculo dos autovalores
freedofs = np.arange(1, nnos)
K_reduced = K[np.ix_(freedofs, freedofs)]
M_reduced = M[np.ix_(freedofs, freedofs)]

eigenvalues, eigenvectors = eigh(K_reduced, M_reduced)
omeg = np.sqrt(eigenvalues)

# Inverter o sinal do modo de forma para corrigir a orientação
mode_shape = eigenvectors[:, 2] * -1

# Plotar o terceiro modo
plt.plot(coord[1:], mode_shape)
plt.grid(True)
plt.xlabel('Coord')
plt.ylabel('Modo de Forma')
plt.title('Modo de Forma do Terceiro Autovalor')
plt.show()