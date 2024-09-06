''' Usando a análise matricial de estruturas, desenvolva um código para o
caso de carga variando linearmente. Compare as soluções numéricas obtidas 
com as analíticas para diferentes discretizações (5, 10, 20, 40 elementos). 
Faça um gráfico comparando as soluções analíticas e numéricas em 
deslocamentos e em tensão. Faça um gráfico dos erros em porcentagem 
calculados em cada nó. Calcule e informe a norma euclidiana dos erros obtidos. 
Repita o procedimento para cada discretização adotada. Comente os resultados. '''

import numpy as np
import matplotlib.pyplot as plt
import warnings

warnings.filterwarnings("ignore", category=RuntimeWarning)

# Definição de parâmetros
E = 210e6  # Módulo de elasticidade do material (Pa)
A = np.pi * (0.015**2)  # Área da seção transversal da barra (m²)
L = 10.0  # Comprimento da barra (m)
Po = 1e3  # Carga máxima distribuída ao longo da barra (N/m)
x = np.linspace(0, L, 100)

# Definição de nel
nels = [5, 10, 20, 40]  # Diferentes números de elementos na malha

# Loop para cada valor de deslocamento prescrito
# Cria uma figura com subplots para deslocamento e tensão interna
fig, axes = plt.subplots(len(nels), 2, figsize=(14, 10))
plt.suptitle(f'Comparação de Deslocamentos e Tensões Internas para ua e ub = 0', fontsize=16)

# Loop para cada valor de nel
for nel_idx, nel in enumerate(nels):
    # Cálculo das coordenadas dos nós e incidências dos elementos
    nnos = nel + 1  # Número de nós
    h = L / nel  # Tamanho de cada elemento
    coord = np.linspace(0, L, nnos)  # Coordenadas dos nós
    inci = np.array([[i, i+1] for i in range(nnos - 1)])  # Incidências dos elementos

    # Cálculo da matriz de rigidez e vetor de forças de um elemento
    ke = (E * A / h) * np.array([[1, -1], [-1, 1]])

    # Inicializa a matriz de rigidez global e o vetor de forças globais
    K = np.zeros((nnos, nnos))  # Matriz de rigidez global
    F = np.zeros(nnos)  # Vetor de forças globais

    # Montagem da matriz de rigidez e vetor de forças globais
    for i in range(nel):
        no1, no2 = inci[i]
        loc = [no1, no2]
        K[np.ix_(loc, loc)] += ke
        
        # Cálculo da carga distribuída triangular crescente da esquerda para a direita
        x1, x2 = coord[no1], coord[no2]
        f1 = Po * x1 / L  # Carga no nó inicial do elemento
        f2 = Po * x2 / L  # Carga no nó final do elemento
        
        # Vetor de força nodal ponderado para a carga triangular
        fe = (h / 6) * np.array([f1 + 2 * f2, 2 * f1 + f2])
        
        # Montagem no vetor global de forças
        F[no1] += fe[0]
        F[no2] += fe[1]
        
    # Condição de contorno: fixar deslocamento u(0) = 0 no primeiro nó
    K[0, :] = 0
    K[0, 0] = 1
    F[0] = 0

    # Condição de contorno: fixar deslocamento u(L) = 0 no último nó
    K[-1, :] = 0
    K[-1, -1] = 1
    F[-1] = 0

    # Cálculo do deslocamento
    u = np.linalg.solve(K, F)

    # Cálculo da tensão interna (σ)
    sigma = np.zeros(nel)
    for i in range(nel):
        no1, no2 = inci[i]
        sigma[i] = E * (u[no2] - u[no1]) / h
        sigma[i] = sigma[i] / 1e6

    # Cálculo da solução analítica para carga triangular
    ua = Po * (L**2 * x - x**3) / (6 * E * A * L)  # Solução analítica
    sigma_analitica = Po * (L**2 - 3*x**2) / (6 * A * L)  # Tensão interna analítica
    sigma_analitica = sigma_analitica / 1e6

    # Interpolação da solução numérica para os pontos analíticos
    u_interp = np.interp(x, coord, u)
    
    # Cálculo do erro percentual no deslocamento
    erro_percentual = np.where(ua != 0, np.abs((ua - u_interp) / ua) * 100, 0)

    # Cálculo da norma euclidiana do erro
    norma_erro = np.linalg.norm(ua - u_interp)

    # Plotagem dos resultados para o valor atual de nel
    axes[nel_idx, 0].plot(coord, u, 'o-k', label='Numérico')
    axes[nel_idx, 0].plot(x, ua, '-r', label='Analítico')
    axes[nel_idx, 0].set_title(f'Deslocamento ({nel} elementos)')
    axes[nel_idx, 0].set_xlabel('Posição (m)')
    axes[nel_idx, 0].set_ylabel('Deslocamento (m)')
    axes[nel_idx, 0].grid(True)
    if nel_idx == 0:
        axes[nel_idx, 0].legend()

    axes[nel_idx, 1].bar((coord[:-1] + coord[1:]) / 2, sigma, width=h, align='center', color='k')
    axes[nel_idx, 1].plot(x, sigma_analitica, '-r')
    axes[nel_idx, 1].set_title(f'Tensão Interna ({nel} elementos)')
    axes[nel_idx, 1].set_xlabel('Posição (m)')
    axes[nel_idx, 1].set_ylabel('Tensão Interna (MPa)')
    axes[nel_idx, 1].grid(True)

plt.tight_layout(rect=[0, 0, 1, 0.95])
plt.show()

# Gráfico separado dos erros percentuais
plt.figure(figsize=(10, 6))
for nel in nels:
    nnos = nel + 1
    h = L / nel
    coord = np.linspace(0, L, nnos)
    inci = np.array([[i, i+1] for i in range(nnos - 1)])
    
    ke = (E * A / h) * np.array([[1, -1], [-1, 1]])

    K = np.zeros((nnos, nnos))
    F = np.zeros(nnos)

    for i in range(nel):
        no1, no2 = inci[i]
        loc = [no1, no2]
        K[np.ix_(loc, loc)] += ke
        
        # Cálculo da força distribuída triangular crescente da esquerda para a direita
        x1, x2 = coord[no1], coord[no2]
        f1 = Po * x1 / L  # Carga no nó inicial do elemento
        f2 = Po * x2 / L  # Carga no nó final do elemento
        
        # Vetor de força nodal ponderado para a carga triangular
        fe = (h / 6) * np.array([f1 + 2 * f2, 2 * f1 + f2])
        
        # Montagem no vetor global de forças
        F[no1] += fe[0]
        F[no2] += fe[1]
        
    K[0, :] = 0
    K[0, 0] = 1
    F[0] = 0

    K[-1, :] = 0
    K[-1, -1] = 1
    F[-1] = 0

    u = np.linalg.solve(K, F)

    sigma = np.zeros(nel)
    for i in range(nel):
        no1, no2 = inci[i]
        sigma[i] = E * (u[no2] - u[no1]) / h
        sigma[i] = sigma[i] / 1e6

    u_interp = np.interp(x, coord, u)
    erro_percentual = np.where(ua != 0, np.abs((ua - u_interp) / ua) * 100, 0)
    plt.plot(x, erro_percentual, label=f'{nel} elementos')

plt.xlabel('Posição (m)')
plt.ylabel('Erro Percentual (%)')
plt.legend()
plt.grid(True)
plt.title('Erro Percentual no Deslocamento')
plt.show()