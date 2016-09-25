#!/usr/bin/env ruby
gem 'minitest', '>= 5.0.0'
require 'minitest/autorun'
require_relative 'grafo'

class GrafoTest < Minitest::Test

  # Tests with matrix 1
  MATRIX =[
    [0, 2, 1, 1],
    [2, 0, 1, 0],
    [1, 1, 0, 1],
    [1, 0, 1, 1]
  ]
  #  1 - order

  def test_order_1
    assert_equal 2, Grafo.new(MATRIX).order(2)
  end

  def test_order_2
    assert_equal 1, Grafo.new(MATRIX).order(4)
  end

  #  2 -max order

  def test_max_order
    assert_equal 2, Grafo.new(MATRIX).max_order
  end

  #  2 - min order

  def test_min_order
    assert_equal 0, Grafo.new(MATRIX).min_order
  end

  #  3 - neighborhood

  def test_neighborhood_1
    result = Grafo.new(MATRIX).neighborhood(1)
    assert_equal [2, 3, 4], result
  end

  def test_neighborhood_2
    result = Grafo.new(MATRIX).neighborhood(2)
    assert_equal [1, 3], result
  end


  #  4 - neighborhood
  def test_order_sequence
    result = Grafo.new(MATRIX).order_sequence
    expected = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2]
    assert_equal expected, result
  end

  #  5 - conex?
  def test_conex
    result = Grafo.new(MATRIX).conex?
    assert !result
  end

  # 6 - class

  # 6 - complete

  MATRIX_COMPLETE =[
    [0, 2, 1, 1],
    [2, 0, 1, 1],
    [1, 1, 0, 1],
    [1, 0, 1, 0]
  ]

  def test_complete
    assert_equal ['complete'], Grafo.new(MATRIX_COMPLETE).graph_class
  end

  # 6 - cicle
  MATRIX_CICLE =[
    [0, 2, 1, 1],
    [2, 0, 1, 1],
    [1, 1, 0, 1],
    [1, 0, 1, 1]
  ]

  # 7 - Suponha que o grafo G é uma arvore, calcule o centro de G;

  MATRIX_GRAPH =
  [
      [0, 1, 0, 0, 0, 0, 0],
      [1, 0, 1, 0, 0, 0, 0],
      [0, 1, 0, 1, 0, 0, 0],
      [0, 0, 1, 0, 1, 1, 0],
      [0, 0, 0, 1, 0, 0, 0],
      [0, 0, 0, 1, 0, 0, 1],
      [0, 0, 0, 0, 0, 1, 0],
  ]

  #
  #     4
  #   / | \
  #  3  6  5
  #  |  |
  #  2  7
  #  |
  #  1
  #
  # Centro = [3-4]

  def test_graph_center
    result = Grafo.new(MATRIX_GRAPH).calculate_center
    expected = [3, 4]

    assert_equal(expected, result)
  end

  def test_cicle
    assert_equal ["ciclo"], Grafo.new(MATRIX_CICLE).graph_class
  end

  def test_all_classess
    assert_equal ["complete", "ciclo"], Grafo.new(MATRIX).graph_class
  end
end
