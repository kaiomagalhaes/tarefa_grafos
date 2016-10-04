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

    # While there is more than 2 vertices, there still will be leafs to be removed.
    while (amount_of_vertices_with_edges() > 2) do
      remove_wave_of_leafs
    end

    list_vertices_with_edges

  end

  def bipartite?

    initial_position = 0
    list_analyzed_vertices = []
    current_group = 0 # Zero represents group A, and one represents group B
    list_of_groups = [ [], [] ] # Both groups A and B starts empty

    check_vertice_group(initial_position, list_analyzed_vertices, current_group, list_of_groups)

  end

  # A graph is a tree which can't have a cycle with 3 or more vertices
  # To prove that, we will remove all the leafs, because the vertices in a cycle are never leafs
  # So when we remove all the leafs, we count the remaining vertices and verify if we have a cycle, an edge with two vertices or just one vertex
  def tree?
    while (list_leafs.count > 0)
      remove_wave_of_leafs
    end

    list_vertices_with_edges.count <= 2
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
    list_of_leafs = list_leafs

    # For each vertex with just one edge, we will remove in the matrix the link between the two vertices
    # That's because the matrix stores both the "a - b" and the "b - a" links
    list_of_leafs.each do |vertex|

      # We remove the link from the leaf to the rest of the tree, also known as "a - b" link
      for column in (0..@matrix[vertex].count - 1)
        @matrix[vertex][column] = 0
      end

      # We remove the link from the neighbour of the leaf to the leaf itself, also known as "b - a" link
      for line in (0..@matrix.count - 1)
        @matrix[line][vertex] = 0
      end

    end
  end

  # Method to return the count of vertices of the graph that have at least one edge linking on them
  def amount_of_vertices_with_edges

    # The number of vertices it's equal to the number of lines where their inner sum is greater than zero
    number_of_vertices = (@matrix.find_all {|line| line.inject(0){|sum, x| sum + x } > 0}).count

  end

  def list_leafs
    list_of_leafs = []

    for line in (0..@matrix.count - 1) do # We will count the number of edges in each line of the matrix
      current_vertex = @matrix[line]
      number_of_edges_on_vertex = 0

      for column in (0..current_vertex.count - 1) # For each column in the matrix that contains a number, the number is equal to the number of edges linking in that vertex
        if (current_vertex[column] == 1)
          number_of_edges_on_vertex += 1
        end
      end

      # We will later return the vertices that has at least one edge
      if (number_of_edges_on_vertex == 1)
        list_of_leafs << line
      end

    end

    list_of_leafs

  end

  # Method to return a list with all the vertices of the graph that has at least one edge linking on them
  def list_vertices_with_edges
    result = []

    # We search for all the lines that has at least one edge
    lines_with_edge = @matrix.find_all {|line| line.include? 1}

    # Because the smallest possible number in the matrix is zero but the smallest possible number in the graph is one,
    # we add one to all elements so the result is correct
    lines_with_edge.each do |line|
      result << (@matrix.find_index(line) + 1)
    end

    result
  end

  # The method works as follows
  # First, it will select a vertex, and insert it in a group if its not already in one
  # Second, it will assure that all its neighbours are in an opposite group, return false if it founds a vertex that breaks this law,
  # and marking groups for the neighbours that doesn't have it
  # Third, at the end of the check, it will execute the same check in the neighbours vertices that weren't checked before
  def check_vertice_group(vertex_position, list_vertices_checked, number_current_group, list_of_groups)
    is_group = true # While we don't find a counter-proof, we cannot say that its not a bipartide
    vertex = @matrix[vertex_position]

    # After we check this vertex, we will check the neighbour vertices that weren't checked before
    list_of_neighbours_not_checked = []

    # If this vertex wasn't marked for a group, we will mark it now
    if(!list_of_groups[number_current_group].include? vertex_position)
      list_of_groups[number_current_group] << vertex_position
    end

    # We will mark every neighbour vertex for a group and store those which weren't checked
    for i in (0..vertex.count - 1)
      if(vertex[i] == 1)

        # If the neighbour vertex is from the same group of the current vertex, it means that we have an edge inside the same group
        # Meaning that this is not a bipartide graph
        if(list_of_groups[number_current_group].include? i)
          return [false, nil]
        elsif (!list_of_groups[next_group(number_current_group)].include? i) # If the other group still hasn't this neighbour vertex
          list_of_groups[next_group(number_current_group)] << i
        end

        # If this vertex wasn't checked, we will check it after doing it in the current vertex
        if(!list_vertices_checked.include? i)
          list_of_neighbours_not_checked << i
        end

      end
    end

    # Now we mark the current vertex as checked
    if(!list_vertices_checked.include? vertex_position)
      list_vertices_checked << vertex_position
    end

    # If all the neighbour vertex were checked, we won't check it again, so we can avoid a endless loop
    if(list_of_neighbours_not_checked.count == 0)
      return [true, list_of_groups]
    elsif
      for i in (0..list_of_neighbours_not_checked.count - 1) # Now we will check all the neighbour vertices that weren't checked before
        result = check_vertice_group(list_of_neighbours_not_checked[i], list_vertices_checked, next_group(number_current_group), list_of_groups)

        if(result[0] == false) # If someone returns false, it's because it found an edge linking vertices from the same group
          return [false, nil]
        end

        is_group = result[0]
        list_of_groups = result[1] # We update the information about the groups so the next vertices can use it when they are being checked

      end
    end

    return [is_group, list_of_groups] # Return the result of the current analysis

  end

  def next_group(number_of_the_current_group) # If the current vertex is from the group A, the next group will be group B, and so on
    number_of_the_current_group == 0 ? 1 : 0
  end


end
