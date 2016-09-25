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
end
