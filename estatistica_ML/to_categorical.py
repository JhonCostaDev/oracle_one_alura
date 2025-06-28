#%%
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
# %%
url = 'https://raw.githubusercontent.com/alura-cursos/Estatisticas-Python-frequencias-medidas/refs/heads/main/dados/vendas_ecommerce.csv'
# %%
df = pd.read_csv(url)
df.info()
# %%
df.head()
# %%
df.avaliacao.unique() # valores unicos da coluna
# %%
# Criar uma coluna de avaliacao_categorica com indicativos
avaliacao_labels = {1: 'Péssimo', 2: 'Ruim', 3: 'Regular', 4: 'Bom', 5: 'Ótimo'}
# Categorica com sequência lógica
df['avalicao_cat'] = pd.Categorical(
    df['avaliacao'],
    categories=[1,2,3,4,5],
    ordered=True
)
#%%
#Muda para classificação por indicador avaliação lógica
df['avalicao_cat'] = df['avalicao_cat'].map(avaliacao_labels)
df['avalicao_cat'].unique() 
# %% Verificando
df[['avaliacao','avalicao_cat']].drop_duplicates()
# %%
# Mudar tipo para categorical
df['avalicao_cat'] = df['avalicao_cat'].astype('category')
df['avalicao_cat'].dtype
# %%
df.dtypes
# %%

'''Frequência absoluta **

É o número de vezes em que uma dada observação aparece numa variável. Para cada valor possível, você tem uma dada frequência, cuja soma seria igual a frequência total absoluta, ou melhor, o número total de registros.
**Como construir:**

1.  Ordenar os valores das variáveis em ordem crescente ou decrescente;

2.  Determinar a frequência de cada valor;

3.  Agrupar os dados em classes ou intervalos
'''


# %%
distribuicao_freq = df['avalicao_cat'].value_counts().reset_index(name='freq_absoluta')
distribuicao_freq 
# %%
# Frequencia relativa
distribuicao_freq['freq_relativa'] = (df['avalicao_cat'].value_counts(normalize=True)*100).values.round(2)
distribuicao_freq

#%% Rename columns
distribuicao_freq.columns = ['avaliacao', 'quantidade', 'porcentagem %']

# %%
sns.barplot(data=distribuicao_freq, x='avaliacao', y='porcentagem %')

plt.title('Distribuição de Frequência')
plt.xlabel("Classificação das avaliações")
plt.ylabel("Porcentagem das avaliações")

# for i, row in distribuicao_freq.iterrows():
#     plt.text(i, row['quantidade'] + 0.1, f"{row['quantidade']} ({row['porcentagem %']:.1f}%)", ha='center', va='bottom', fontsize=12)

plt.show()
# %%

# %%
