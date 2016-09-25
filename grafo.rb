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

  def graph_class
    classes = []
    classes << 'complete' if complete?
    classes << 'ciclo' if cicle?
    classes
  end

  def calculate_center

    # Enquanto houver mais de 2 vértices, teremos folhas para serem removidas
    while (amount_of_vertices_with_edges() > 2) do
      vetor_folhas = []
      for linha in (0..@matrix.count - 1) do # Iremos verificar a quantidade de arestas em cada linha da matriz
        vertice_atual = @matrix[linha]
        quantidade_arestas_no_vertice = 0
        for coluna in (0..vertice_atual .count - 1) # Cada coluna na matriz que apresentar um número, é a quantidade de arestas daquele vértice no grafo
          if(vertice_atual[coluna] == 1 )
            quantidade_arestas_no_vertice += 1
          end
        end

        # Iremos remover os vértices que apresentam somente uma aresta
        if(quantidade_arestas_no_vertice == 1)
          vetor_folhas << linha
        end

      end

      # Para cada vértice com somente uma aresta, iremos remover na matriz a ligação entre eles, pois a matriz representa tanto "a - b" como "b - a"
      vetor_folhas.each do |vertice|

        # Removemos a ligação do vértice folha com o resto da árvore na matriz
        for coluna in (0..@matrix[vertice].count - 1)
          @matrix[vertice][coluna] = 0
        end

        # Removemos a ligação do vizinho do vértice folha com a própria folha na matriz
        for linha in (0..@matrix.count - 1)
          @matrix[linha][vertice] = 0
        end

      end
    end

    retorno = list_of_vertices_with_edges

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

  def column(v)
    @matrix.collect do | line |
      line[vertice_number(v)]
    end
  end

  def vertice_number(v)
    v - 1
  end

  # Método para retornar a quantidade de vértices do grafo que apresentam alguma aresta incidente
  def amount_of_vertices_with_edges

    # O número de vértices é igual a quantidade de linhas onde ao somar todas as arestas incidentes é maior que 0
    quantidade_de_vertices = (@matrix.find_all {|linha| linha.inject(0){|sum, x| sum + x } > 0}).count

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
end
