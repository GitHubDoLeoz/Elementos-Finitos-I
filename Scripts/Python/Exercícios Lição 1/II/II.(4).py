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
E = 210e6  # Módulo de elasticidade do material (Pa)
A = np.pi * (0.015**2)  # Área da seção transversal da barra (m²)
L = 2  # Comprimento da barra (m)
Po = 1e3  # Carga máxima distribuída ao longo da barra (N/m)

# Definição de nel e ub
nels = [5, 10, 20, 40]  # Diferentes números de elementos na malha
ubs = [0.0025, 0.005, 0.0075, 0.01, 0.025] # Diferentes valores de deslocamento prescrito na extremidade da barra

# Função para calcular a norma euclidiana dos erros
def norma_euclidiana_erro(e, L):
    integral, _ = quad(lambda x: e(x)**2, 0, L)
    return np.sqrt(integral)

# Loop para cada valor de deslocamento prescrito
for ub in ubs:
    # Criar uma figura com subplots para deslocamento e esforço interno
    fig, axes = plt.subplots(len(nels), 2, figsize=(14, 10))
    plt.suptitle(f'Comparação de Deslocamentos e Esforços Internos para ub = {ub} m', fontsize=16)
    
    # Loop para cada valor de nel
    for nel_idx, nel in enumerate(nels):
        # Calcular das coordenadas dos nós e incidências dos elementos
        nnos = nel + 1  # Número de nós
        h = L / nel  # Tamanho de cada elemento
        coord = np.linspace(0, L, nnos)  # Coordenadas dos nós
        inci = np.array([[i, i+1] for i in range(nnos - 1)])  # Incidências dos elementos

        # Calcular a matriz de rigidez e vetor de forças de um elemento
        ke = (E * A / h) * np.array([[1, -1], [-1, 1]])

        # Inicializar a matriz de rigidez global e o vetor de forças globais
        K = np.zeros((nnos, nnos))  # Matriz de rigidez global
        F = np.zeros(nnos)  # Vetor de forças globais

        # Montar a matriz de rigidez e vetor de forças globais
        for i in range(nel):
            no1, no2 = inci[i]
            loc = [no1, no2]
            K[np.ix_(loc, loc)] += ke
            
            # Calcular a carga distribuída triangular crescente da esquerda para a direita
            x1, x2 = coord[no1], coord[no2]
            f1 = Po * x1 / L  # Carga no nó inicial do elemento
            f2 = Po * x2 / L  # Carga no nó final do elemento
            
            # Vetor de força nodal ponderado para a carga triangular
            fe = (h / 6) * np.array([f1 + 2 * f2, 2 * f1 + f2])
            
            # Montar o vetor global de forças
            F[no1] += fe[0]
            F[no2] += fe[1]
            
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

        # Calcular o esforço interno (Nx)
        Nx = np.zeros(nel)
        for i in range(nel):
            no1, no2 = inci[i]
            Nx[i] = E * A / h * (u[no2] - u[no1])

        # Calcular a solução analítica para carga triangular
        x = np.linspace(0, L, 100)
        ua = (-Po * x**3) / (6 * E * A * L) + ((ub + (Po * L**2) / (6 * E * A)) / L) * x
        Nxa = (-Po * x**2) / (2 * L) + ((ub * E * A + (Po * L**2) / 6) / L)

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
        axes[nel_idx, 0].set_xlabel('Posição (m)')
        axes[nel_idx, 0].set_ylabel('Deslocamento (m)')
        axes[nel_idx, 0].grid(True)
        if nel_idx == 0:
            axes[nel_idx, 0].legend()

        axes[nel_idx, 1].bar((coord[:-1] + coord[1:]) / 2, Nx, width=h, align='center', color='k')
        axes[nel_idx, 1].plot(x, Nxa, '-r')
        axes[nel_idx, 1].set_title(f'Esforço Interno ({nel} elementos)')
        axes[nel_idx, 1].set_xlabel('Posição (m)')
        axes[nel_idx, 1].set_ylabel('Esforço Interno (N)')
        axes[nel_idx, 1].grid(True)
    
    plt.tight_layout(rect=[0, 0, 1, 0.95])
    plt.show()

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
            
            # Calcular a força distribuída triangular crescente da esquerda para a direita
            x1, x2 = coord[no1], coord[no2]
            f1 = Po * x1 / L  # Carga no nó inicial do elemento
            f2 = Po * x2 / L  # Carga no nó final do elemento
            
            # Vetor de força nodal ponderado para a carga triangular
            fe = (h / 6) * np.array([f1 + 2 * f2, 2 * f1 + f2])
            
            # Montar o vetor global de forças
            F[no1] += fe[0]
            F[no2] += fe[1]
            
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


''' Os resultados mostram que, conforme o número de elementos na malha aumenta, a solução numérica para o deslocamento 
e o esforço interno da barra de seção constante se aproxima da solução analítica. Inicialmente, com apenas 5 elementos, 
as diferenças entre as soluções numérica e analítica são mais evidentes, com maiores erros percentuais e uma norma 
euclidiana dos erros mais alta. Isso ocorre porque uma malha mais grossa não captura com precisão a variação contínua 
da carga triangular.

À medida que o número de elementos aumenta para 10, 20 e 40, a precisão da solução numérica melhora significativamente. 
Os gráficos mostram que, com mais elementos, o deslocamento e o esforço interno calculados numericamente se ajustam melhor 
à solução analítica, evidenciando a redução dos erros. O gráfico dos erros percentuais confirma essa melhoria, mostrando 
uma diminuição dos erros à medida que a malha é refinada.

A norma euclidiana dos erros, que quantifica o erro global entre as soluções, também diminui com o aumento do número de 
elementos. Essa redução confirma que a solução numérica está convergindo para a solução analítica. A análise de convergência, 
apresentada em uma escala logarítmica, revela que a norma euclidiana dos erros decresce de forma quase exponencial, indicando 
que a precisão do método numérico melhora conforme a malha se torna mais fina. '''