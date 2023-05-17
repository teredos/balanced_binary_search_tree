# frozen_string_literal: true

require_relative 'node'

# Creates a class for balanced BSTs, including methods for various tree
# operations
class Tree
  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array, first = 0, last = array.length - 1)
    return nil if first > last

    mid = (first + last) / 2
    node = Node.new(array[mid])
    node.left = build_tree(array, first, mid - 1)
    node.right = build_tree(array, mid + 1, last)
    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    if node.right
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}",
                   false)
    end
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    return unless node.left

    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}",
                 true)
  end

  def insert(value, node = @root)
    return if node.data == value

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    elsif value > node.data
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = @root)
    return if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      temp_value = leftmost_node_of(node.right).data
      delete(leftmost_node_of(node.right).data)
      node.data = temp_value
    end
    node
  end

  def leftmost_node_of(node)
    return node if node.left.nil?

    leftmost_node_of(node.left)
  end

  def find(value, node = @root)
    return if node.nil?
    return node if node.data == value

    node.data < value ? find(value, node.right) : find(value, node.left)
  end

  def level_order(node = @root, queue = [], values = [])
    queue << node.data
    until queue.empty?
      node = find(queue[0])
      queue << node.left.data unless node.left.nil?
      queue << node.right.data unless node.right.nil?
      block_given? ? yield(queue[0]) : values << queue.shift
    end
    values
  end

  def inorder(node = @root, values = [], &block)
    inorder(node.left, values) unless node.left.nil?
    values << node.data
    inorder(node.right, values) unless node.right.nil?
    block_given? ? values.each(&block) : values
  end

  def preorder(node = @root, values = [], &block)
    values << node.data
    preorder(node.left, values) unless node.left.nil?
    preorder(node.right, values) unless node.right.nil?
    block_given? ? values.each(&block) : values
  end

  def postorder(node = @root, values = [], &block)
    postorder(node.left, values) unless node.left.nil?
    postorder(node.right, values) unless node.right.nil?
    values << node.data
    block_given? ? values.each(&block) : values
  end

  def height(node = @root, num = 0)
    return nil if node.nil?
    return num if node.left.nil? && node.right.nil?

    num += 1
    return height(node.right, num) if node.left.nil?
    return height(node.left, num) if node.right.nil?

    [height(node.left, num), height(node.right, num)].max
  end

  def depth(node = @root, cmp_node = @root, num = 0)
    return if node.nil? || find(node.data).nil?
    return num if node == cmp_node

    num += 1
    if node.data > cmp_node.data
      depth(node, cmp_node.right, num)
    elsif node.data < cmp_node.data
      depth(node, cmp_node.left, num)
    end
  end

  def balanced?(node = @root)
    return if node.nil?
    return false if (height(node.left).to_i - height(node.right).to_i).abs > 1

    balanced?(node.left)
    balanced?(node.right)
    true
  end

  def rebalance(node = @root)
    return if node.nil?

    @root = build_tree(inorder(node))
  end
end
