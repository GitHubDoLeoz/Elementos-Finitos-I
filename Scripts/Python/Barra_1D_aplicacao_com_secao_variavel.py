import numpy as np
import matplotlib.pyplot as plt

# Dados de entrada
# Coordenadas dos nós
coord = np.array([
    [0, 0, 0],
    [2, 0, 0],
    [4, 0, 0],
    [6, 0, 0]
])

# Matriz de incidência dos elementos
inci = np.array([
    [1, 1, 1, 1, 1, 2],
    [2, 1, 1, 2, 2, 3],
    [3, 1, 1, 3, 3, 4]
])

# Tabela de Materiais
Tmat = np.array([
    [210E9, 70E9],     # Módulo de Elasticidade
    [0.33, 0.27],      # Coeficiente de Poisson
    [7850, 2700]       # Massa específica
])

# Tabela de Propriedades Geométricas
Tgeo = np.array([
    [0.1*0.1, 0.1*0.07, 0.1*0.04],  # Área
    [0.1*0.1**3/12, 0.1*0.07**3/12, 0.1*0.04**3/12]  # Momento de inércia
])

# Condições de contorno
cc = np.array([
    [1, 1, 0],
    [1, 2, 0],
    [2, 2, 0],
    [3, 2, 0],
    [4, 2, 0]
])

# Carregamentos externos
fe = np.array([
    [4, 1, 1000]
])

# Solução numérica
nel = inci.shape[0]   # Número de elementos
nnos = coord.shape[0] # Número de nós
ncc = cc.shape[0]     # Número de condições de contorno
nfe = fe.shape[0]     # Número de forças externas

# Calcular o volume e o centro de gravidade da estrutura
Vtotal = 0
Mtotal = 0
Cg = 0
g = 9.81
for i in range(nel):
    no1, no2 = inci[i, 4], inci[i, 5]
    x1, y1 = coord[no1-1, :2]
    x2, y2 = coord[no2-1, :2]
    l = np.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    A = Tgeo[0, inci[i, 3] - 1]
    rho = Tmat[2, inci[i, 2] - 1]
    Vtotal += A * l
    Mtotal += rho * A * l
    xce = (x1 + x2) / 2
    yce = (y1 + y2) / 2
    Cg += xce * A * l * rho
Cg /= Mtotal

# Cálculo do deslocamento
# Cria matriz id
id = np.zeros((2, nnos), dtype=int)
# Le as condições de contorno e trava id
for k in range(ncc):
    id[cc[k, 1] - 1, cc[k, 0] - 1] = 1

neq = 0
for k in range(nnos):
    for j in range(2):
        if id[j, k] == 0:
            neq += 1
            id[j, k] = neq
        else:
            id[j, k] = 0

kg = np.zeros((neq, neq))
for i in range(nel):
    no1, no2 = inci[i, 4], inci[i, 5]
    x1, y1 = coord[no1-1, :2]
    x2, y2 = coord[no2-1, :2]
    l = np.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    A = Tgeo[0, inci[i, 3] - 1]
    E = Tmat[0, inci[i, 2] - 1]
    ke = (E * A / l) * np.array([[1, -1], [-1, 1]])
    loc = [id[0, no1 - 1], id[0, no2 - 1]]
    for il in range(2):
        ilg = loc[il]
        if ilg != 0:
            for ic in range(2):
                icg = loc[ic]
                if icg != 0:
                    kg[ilg - 1, icg - 1] += ke[il, ic]

# Montar o vetor de força
f = np.zeros(neq)
for k in range(nfe):
    f[id[fe[k, 1] - 1, fe[k, 0] - 1] - 1] = fe[k, 2]

# Resolver o sistema
u = np.linalg.solve(kg, f)

# Reconstruir o vetor solução numérica
uh = np.zeros(nnos)
for i in range(nnos):
    if id[0, i] != 0:
        uh[i] = u[id[0, i] - 1]

# Pós-processamento
plt.plot(coord[:, 0], uh, 'o-k')
plt.grid(True)
plt.title('Deslocamento vs. Coordenadas')
plt.xlabel('Coordenadas')
plt.ylabel('Deslocamento')
plt.show()

# Sugestões para melhorias:
# 1) Calcular a solução analítica para a barra de seção variando linearmente e comparar com a solução numérica.
# 2) Calcular as tensões e comparar com as soluções analíticas.
# 3) Refinar a malha.