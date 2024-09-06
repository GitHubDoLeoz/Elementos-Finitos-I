''' Para a barra de seção constante compare as soluções numéricas com 
as analíticas para diferentes discretizações (nel = 5, 10, 20, 40).
Faça um gráfico comparando as soluções analíticas e numéricas.
Faça um gráfico dos erros em porcentagem calculados em cada ponto. 
Calcule e informe a norma euclidiana dos erros obtidos. Repita o 
procedimento para cada discretização adotada e faça uma análise 
de convergência usando a escala logarítmica. Comente e justifique 
os resultados. '''

import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import quad
import warnings

warnings.filterwarnings("ignore", category=RuntimeWarning)

# Entradas
E = 210e6  # Módulo de elasticidade do material
A = np.pi * (0.015**2)  # Área da seção transversal da barra
L = 2  # Comprimento da barra
Po = 1e3  # Carga distribuída ao longo da barra

# Definição de nel e ub
nels = [5, 10, 20, 40]  # Diferentes números de elementos na malha
ubs = [0.0025, 0.005, 0.0075, 0.01, 0.025]  # Diferentes valores de deslocamento prescrito na extremidade da barra

# Função para calcular a norma euclidiana dos erros
def norma_euclidiana_erro(e, L):
    integral, _ = quad(lambda x: e(x)**2, 0, L)
    return np.sqrt(integral)

# Loop para cada valor de deslocamento prescrito
for ub in ubs:
    fig, axes = plt.subplots(len(nels), 2, figsize=(14, 10))
    plt.suptitle(f'Comparação de Deslocamentos e Esforços para ub = {ub} m', fontsize=16)

    # Loop para cada valor de nel
    for nel_idx, nel in enumerate(nels):
        # Cálculo das coordenadas dos nós e incidências dos elementos
        nnos = nel + 1  # Número de nós
        h = L / nel  # Tamanho de cada elemento
        coord = np.linspace(0, L, nnos)  # Coordenadas dos nós
        inci = np.array([[i, i+1] for i in range(nnos - 1)])  # Incidências dos elementos

        # Cálculo da matriz de rigidez e vetor de forças de um elemento
        ke = (E * A / h) * np.array([[1, -1], [-1, 1]])  # Matriz de rigidez do elemento
        fe = (Po * h / 2) * np.array([1, 1])  # Vetor de forças do elemento

        # Inicializa a matriz de rigidez global e o vetor de forças globais
        K = np.zeros((nnos, nnos))  # Matriz de rigidez global
        F = np.zeros(nnos)  # Vetor de forças globais

        # Montagem da matriz de rigidez e vetor de forças globais
        for i in range(nel):
            no1, no2 = inci[i]
            loc = [no1, no2]
            K[np.ix_(loc, loc)] += ke
            F[loc] += fe
            
        # Condição de contorno: fixar deslocamento u(0) = 0 no primeiro nó
        K[0, :] = 0
        K[0, 0] = 1
        F[0] = 0

        # Condição de contorno: fixar deslocamento u(L) = ub no último nó
        K[-1, :] = 0
        K[-1, -1] = 1
        F[-1] = ub

        # Calcular o deslocamento
        u = np.linalg.solve(K, F)

        # Calcular o esforço interno
        Nx = np.zeros(nel)
        for i in range(nel):
            no1, no2 = inci[i]
            Nx[i] = E * A / h * (u[no2] - u[no1])

        # Calcular a solução analítica
        x = np.linspace(0, L, 100)
        ua = (1 / (E * A)) * (-0.5 * Po * x**2 + ((ub * E * A + 0.5 * Po * L**2) / L) * x)
        Nxa = (-Po * x + ((ub * E * A + 0.5 * Po * L**2) / L))

        u_interp = np.interp(x, coord, u)
        erro_percentual = np.where(ua != 0, np.abs((ua - u_interp) / ua) * 100, 0)

        # Função de erro ajustada para retornar um valor escalar
        def erro_func(x):
            u_interp_x = np.interp(x, coord, u)
            return (1 / (E * A)) * (-0.5 * Po * x**2 + ((ub * E * A + 0.5 * Po * L**2) / L) * x) - u_interp_x
        
        norma_erro = norma_euclidiana_erro(erro_func, L)
        
        print(f'Norma Euclidiana dos Erros para {nel} elementos e ub = {ub}: {norma_erro:.5e} m')
        
        # Plotar dos resultados para o valor atual de nel
        axes[nel_idx, 0].plot(coord, u, 'o-k', label='Numérico')
        axes[nel_idx, 0].plot(x, ua, '-r', label='Analítico')
        axes[nel_idx, 0].set_title(f'Deslocamento ({nel} elementos)')
        axes[nel_idx, 0].set_xlabel('Coordenadas')
        axes[nel_idx, 0].set_ylabel('Deslocamento (m)')
        axes[nel_idx, 0].grid(True)
        if nel_idx == 0:
            axes[nel_idx, 0].legend()

        axes[nel_idx, 1].bar((coord[:-1] + coord[1:]) / 2, Nx, width=h, align='center', color='k')
        axes[nel_idx, 1].plot(x, Nxa, '-r')
        axes[nel_idx, 1].set_title(f'Esforço Interno ({nel} elementos)')
        axes[nel_idx, 1].set_xlabel('Coordenadas')
        axes[nel_idx, 1].set_ylabel('Esforço Interno (N)')
        axes[nel_idx, 1].grid(True)
    
    plt.tight_layout(rect=[0, 0, 1, 0.95])
    plt.show()

    # Gráfico de erro percentual para cada discretização
    plt.figure(figsize=(10, 6))
    for nel in nels:
        nnos = nel + 1
        h = L / nel
        coord = np.linspace(0, L, nnos)
        inci = np.array([[i, i+1] for i in range(nnos - 1)])
        
        ke = (E * A / h) * np.array([[1, -1], [-1, 1]])
        fe = (Po * h / 2) * np.array([1, 1])

        K = np.zeros((nnos, nnos))
        F = np.zeros(nnos)

        for i in range(nel):
            no1, no2 = inci[i]
            loc = [no1, no2]
            K[np.ix_(loc, loc)] += ke
            F[loc] += fe
            
        K[0, :] = 0
        K[0, 0] = 1
        F[0] = 0

        K[-1, :] = 0
        K[-1, -1] = 1
        F[-1] = ub

        u = np.linalg.solve(K, F)

        Nx = np.zeros(nel)
        for i in range(nel):
            no1, no2 = inci[i]
            Nx[i] = E * A / h * (u[no2] - u[no1])

        u_interp = np.interp(x, coord, u)
        erro_percentual = np.where(ua != 0, np.abs((ua - u_interp) / ua) * 100, 0)
        norma_erro = norma_euclidiana_erro(erro_func, L)

        plt.plot(x, erro_percentual, label=f'{nel} elementos')
    
    plt.title(f'Erro Percentual no Deslocamento para ub = {ub} m')
    plt.xlabel('Coordenadas')
    plt.ylabel('Erro (%)')
    plt.legend()
    plt.grid(True)
    plt.show()

    print('-'*60)


''' Comente e justifique os resultados. '''


''' À medida que o número de elementos na malha aumenta, a solução numérica se aproxima da solução analítica, mostrando maior precisão. 
Esse comportamento é evidenciado pelos gráficos de deslocamento e esforço interno, onde a precisão melhora conforme a malha é refinada.

O erro percentual entre a solução numérica e a analítica diminui com o aumento do número de elementos, indicando que a precisão da solução 
melhora com uma malha mais fina. Esse erro percentual é um reflexo direto da capacidade da malha em capturar melhor as variações ao longo da barra.

A norma euclidiana dos erros também diminui à medida que o número de elementos aumenta, confirmando que a solução numérica está se aproximando 
da solução analítica. Essa métrica ajuda a quantificar a discrepância global entre as soluções.

A análise de convergência, quando apresentada em escala logarítmica, deve mostrar uma redução dos erros com o aumento da discretização. Isso 
evidencia que a solução numérica melhora à medida que a malha se torna mais refinada, reforçando a precisão do modelo numérico. '''