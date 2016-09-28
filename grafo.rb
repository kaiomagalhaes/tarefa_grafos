# 1 - Dado um vertice v determine o grau, d(v);
# 2 - Determinar o grau maximo e o grau mnimo do grafo G;
# 3 - Determinar a vizinhança de v, ou seja, N(v);
# 4 - Determinar a sequencia de graus do grafo G, do maior para o menor;
# 5 - Determinar se o grafo  conexo * (desafio, no obrigatrio);
# 6 - Determinar se o grafo digitado pertence a uma das classes: completo, ciclo, caminho, k-regular (k digitado pelo usurio);
# 7 - Suponha que o grafo G  uma arvore, calcule o centro de G;
# 8 - Determinar se o grafo digitado pertence a classe dos grafos bipartidos * (desafio, no obrigatrio);
# 9 - Determinar se o grafo digitado pertence a classe das arvores * (desafio, no obrigatrio);
# 10 - Calcular o centro do grafo G, sendo G qualquer grafo. * (desafio, no obrigatrio);

class Grafo
  def initialize(matrix)
    @matrix = matrix
  end

  def order(v)
    column(v).max
  end

  def max_order
    @matrix.flatten.max
  end

  def min_order
    @matrix.flatten.min
  end

  def order_sequence
    @matrix.flatten.sort
  end

  def neighborhood(v)
    col = column(v)
    col.each_with_index.collect  do | item, index |
      item > 0 ? index +1 : nil
    end - [nil]
  end

  def conex?
    (@matrix.min - [0]).empty?
  end

  def graph_class(k = nil)
    classes = []
    classes << 'complete' if complete?
    classes << 'ciclo' if cicle?
    classes << 'caminho' if path?
    classes << 'k-regular' if regular(k)
    classes
  end

  def calculate_center

    # Enquanto houver mais de 2 vértices, teremos folhas para serem removidas
    while (amount_of_vertices_with_edges() > 2) do
      remove_wave_of_leafs
    end

    list_of_vertices_with_edges

  end

  def bipartite?

    posicao_inicial = 0
    lista_analisados = []
    grupo_atual = 0 # O zero representa o grupo A e o um representa o grupo B
    lista_de_grupos = [ [], [] ] # Tanto o grupo A quanto o grupo B estão vazios

    retorno = check_vertice_group(posicao_inicial, lista_analisados, grupo_atual, lista_de_grupos)

  end

  # Um grafo que é uma árvore não pode apresentar um ciclo de 3 ou mais vértices
  # Para provarmos isso, removemos todas as suas folhas, pois os vértices em um ciclo nunca serão folhas
  # Daí ao removermos todas as folhas, verificamos os vértices restantes e constatamos se o que temos é um ciclo, um aresta com dois vértices ou apenas um vértice
  def tree?
    while (list_of_leafs.count > 0)
      remove_wave_of_leafs
    end

    list_of_vertices_with_edges.count <= 2
  end

  private

  def complete?
    edge_number = (@matrix.size * ( @matrix.size - 1)) / 2
    total = @matrix.flatten.inject(:+) / 2
    total == edge_number
  end

  def cicle?
    cicle = false
    (0..(@matrix.size - 1)).each do |index|
      cicle = true if @matrix[index][index] != 0
    end
    cicle
  end
  
  def path?
    path = true
    number_leaves = 0

    for node in (0..@matrix.count - 1) do
      actual_vertex = @matrix[node]
      edge_number = 0
      for column in (0..actual_vertex .count - 1)
        if(actual_vertex [column] == 1 )
          edge_number += 1
        end
      end

      if (edge_number == 1)
        number_leaves += 1
      end

      if (edge_number > 2)
        path = false
        break
      end
    end
    if (number_leaves != 2)
      path = false
    end
    path
  end

  def regular(k)
    regular = true
    for node in (0..@matrix.count - 1) do
      actual_vertex = @matrix[node]
      edge_number = 0
      for column in (0..actual_vertex .count - 1)
        if(actual_vertex [column] == 1 )
          edge_number += 1
        end
      end

      if (edge_number != k)
        regular = false
        break
      end
    end
    regular
  end

  def column(v)
    @matrix.collect do | line |
      line[vertice_number(v)]
    end
  end

  def vertice_number(v)
    v - 1
  end

  def remove_wave_of_leafs
    vetor_folhas = list_of_leafs

    # Para cada vértice com somente uma aresta, iremos remover na matriz a ligação entre eles, pois a matriz representa tanto "a - b" como "b - a"
    vetor_folhas.each do |vertice|

      # Removemos a ligação do vértice folha com o resto da árvore na matriz, também conhecida como a "ida" da aresta
      for coluna in (0..@matrix[vertice].count - 1)
        @matrix[vertice][coluna] = 0
      end

      # Removemos a ligação do vizinho do vértice folha com a própria folha na matriz, também conhecida como a "volta" da aresta
      for linha in (0..@matrix.count - 1)
        @matrix[linha][vertice] = 0
      end

    end
  end

  # Método para retornar a quantidade de vértices do grafo que apresentam alguma aresta incidente
  def amount_of_vertices_with_edges

    # O número de vértices é igual a quantidade de linhas onde ao somar todas as arestas incidentes o resultado é maior que zero
    quantidade_de_vertices = (@matrix.find_all {|linha| linha.inject(0){|sum, x| sum + x } > 0}).count

  end

  def list_of_leafs
    vetor_folhas = []

    for linha in (0..@matrix.count - 1) do # Iremos verificar a quantidade de arestas em cada linha da matriz
      vertice_atual = @matrix[linha]
      quantidade_arestas_no_vertice = 0

      for coluna in (0..vertice_atual.count - 1) # Cada coluna na matriz que apresentar um número, é a quantidade de arestas daquele vértice no grafo
        if (vertice_atual[coluna] == 1)
          quantidade_arestas_no_vertice += 1
        end
      end

      # Iremos retornar os vértices que apresentam somente uma aresta
      if (quantidade_arestas_no_vertice == 1)
        vetor_folhas << linha
      end

    end

    vetor_folhas

  end

  # Método para retornar uma lista com os vértices do grafo que apresentam alguma aresta incidente
  def list_of_vertices_with_edges
    retorno = []

    # Encontramos todos as linhas que apresentam pelo menos uma aresta
    linhas_com_aresta = @matrix.find_all {|linha| linha.include? 1}

    # Como o menor valor da matriz é 0 e o menor valor do grafo é 1, somamos um para ficar com o número correto
    linhas_com_aresta.each do |linha|
      retorno << (@matrix.find_index(linha) + 1)
    end

    retorno
  end

  # O método funciona da seguinte maneira
  # Primeiro, ele irá selecionar um vértice, e inserir o mesmo em um grupo, caso ainda não tenha sido inserido
  # Segundo, ele irá certificar que os vizinhos estão em grupos opostos das arestas, retornando falso caso encontre um que fuja a regra, e
  # assinalando grupos para os vizinhos que ainda não o possuem
  # Terceiro, ao fim da análise, ele irá executar a mesma análise aos vizinhos que ainda não foram analisados
  def check_vertice_group(position, lista_analisados, numero_grupo_atual, lista_grupos)
    eh_grupo = true # Enquanto uma contra-prova não for encontrada, acredita-se que o grafo é bipartido
    vertice = @matrix[position]

    # Após esse vértice ter sido analisado, iremos tratar os vértices vizinhos que ainda não foram analisados
    lista_vizinhos_nao_analisados = []

    # Se esse vértice ainda não foi assinalado um grupo, iremos assinalar a ele agora
    if(!lista_grupos[numero_grupo_atual].include? position)
      lista_grupos[numero_grupo_atual] << position
    end

    # Vamos assinalar um grupo para cada vértice vizinho e anotar os que não foram analisados
    for i in (0..vertice.count - 1)
      if(vertice[i] == 1)

        # Se o vértice vizinho for do mesmo grupo que o atual, significa que é uma aresta entre o mesmo grupo, logo não é um bipartido
        if(lista_grupos[numero_grupo_atual].include? i)
          return [false, nil]
        elsif (!lista_grupos[proximo_grupo(numero_grupo_atual)].include? i) # Se o grupo contrário ainda não teve esse vértice assinalado
          lista_grupos[proximo_grupo(numero_grupo_atual)] << i
        end

        # Se esse vértice não foi analisado, iremos analisar ele após analisar o atual
        if(!lista_analisados.include? i)
          lista_vizinhos_nao_analisados << i
        end

      end
    end

    # Agora marcamos o atual como analisado
    if(!lista_analisados.include? position)
      lista_analisados << position
    end

    # Se todos os vizinhos foram analisados, não iremos analisar novamente, ou irá entrar em um loop infinito
    if(lista_vizinhos_nao_analisados.count == 0)
      return [true, lista_grupos]
    elsif
      for i in (0..lista_vizinhos_nao_analisados.count - 1) # Agora iremos analisar todos os vértices vizinhos que ainda não foram analisados
        retorno = check_vertice_group(lista_vizinhos_nao_analisados[i], lista_analisados, proximo_grupo(numero_grupo_atual), lista_grupos)

        if(retorno[0] == false) # Se alguém retornar falso, é porque encontrou uma aresta dentro do mesmo grupo
          return [false, nil]
        end

        eh_grupo = retorno[0]
        lista_grupos = retorno[1] # Atualizamos as informações dos grupos para os próximos vértices a serem analisados

      end
    end

    return [eh_grupo, lista_grupos] # Retorno da análise atual

  end

  def proximo_grupo(numero_grupo_atual) # Se o vértice atual é do grupo A, o próximo é do grupo B, e vice-versa
    numero_grupo_atual == 0 ? 1 : 0
  end


end
