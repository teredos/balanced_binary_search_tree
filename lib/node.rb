# frozen_string_literal: true

# Creates a class for nodes, each containing a value and reference to their left
# and right child nodes
class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end
