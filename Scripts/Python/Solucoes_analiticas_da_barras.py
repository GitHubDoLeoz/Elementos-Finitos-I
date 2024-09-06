import numpy as np
import matplotlib.pyplot as plt

# Entradas
L = 2.0                   # Comprimento da barra [m]
nx = 100                  # Número de pontos em x
x = np.linspace(0, L, nx) # Coordenadas x
h = L / (nx - 1)          # Comprimento dos intervalos
A = 0.01                  # Área da seção [m^2]
E = 210e9                 # Módulo de Young [Pa]
# Tipos de função: 'con', 'lin', 'par', 'sin', 'cos', 'exp'
type = 'con'
q0 = 1e6                  # Carga distribuída [N/m]
ua = 0                    # Deslocamento à esquerda [m]
ub = 0                    # Deslocamento à direita [m]

# Definições da carga
y = x / L                 # Vetor de posição normalizada
if type == 'con':          # Constante
    p = q0 * np.ones(len(y))
elif type == 'lin':        # Linear
    p = q0 * y
elif type == 'par':        # Parábola
    p = q0 * y * (1 - y)
elif type == 'sin':        # Seno
    p = q0 * np.sin(np.pi * y)
elif type == 'cos':        # Cosseno
    p = q0 * np.cos(np.pi * y)
elif type == 'exp':        # Exponencial
    p = q0 * np.exp(y)
else:                      # Padrão = constante
    print(f'Tipo de carregamento >>> {type} <<< não implementado !!!')

# Obtenha a solução particular up e sua derivada
if type == 'con':          # Constante
    up = -q0 * x**2 / (2 * E * A)
    dup = -q0 * x / (E * A)
elif type == 'lin':        # Linear
    up = -q0 * x**3 / (6 * E * A * L)
    dup = -q0 * x**2 / (2 * E * A * L)
elif type == 'par':        # Parábola
    up = (-q0 * x**3 * (2 * L - x)) / (12 * E * A * L**2)
    dup = (-q0 * x**2 * (3 * L - 2 * x)) / (6 * E * A * L**2)
elif type == 'sin':        # Seno
    up = q0 * (L / np.pi)**2 * np.sin(np.pi * x / L) / (E * A)
    dup = q0 * (L / np.pi) * np.cos(np.pi * x / L) / (E * A)
elif type == 'cos':        # Cosseno
    up = q0 * (L / np.pi)**2 * np.cos(np.pi * x / L) / (E * A)
    dup = -q0 * (L / np.pi) * np.sin(np.pi * x / L) / (E * A)
elif type == 'exp':        # Exponencial
    up = -q0 * L**2 * np.exp(x / L) / (E * A)
    dup = -q0 * L * np.exp(x / L) / (E * A)
else:                      # Padrão = constante
    print(f'Tipo de solução >>> {type} <<< não implementado !!!')

# Obtenha os valores constantes para uh e sua derivada duh
up0 = up[0]
upL = up[-1]
c2 = ua - up0
c1 = (ub - upL - c2) / L

# Obtenha a solução uana e sua derivada duana
uana = up + c1 * x + c2
duana = dup + c1

# Plotar o carregamento distribuído
plt.subplot(2, 1, 1)
plt.bar(x, p)
plt.grid(True)
plt.title('Carregamento Distribuído')
plt.xlabel('Posição [m]')
plt.ylabel('Carga [N/m]')

# Plotar o campo de deslocamento e sua derivada
plt.subplot(2, 1, 2)
plt.plot(x, uana, 'r', label='u(x)')
plt.plot(x, duana, 'g', label='du(x)/dx')
plt.grid(True)
plt.title('Campo de deslocamento e sua derivada')
plt.xlabel('Posição [m]')
plt.ylabel('Deslocamento [m]')
plt.legend()

plt.tight_layout()
plt.show()