# frozen_string_literal: true

require_relative 'lib/tree'

# Creates a new tree from an array of 15 numbers between 1-100
tree = Tree.new(Array.new(15) { rand(1..100) })

# Verifies that the tree is balanced
p tree.balanced?

# Outputs full arrays in level, pre, post, and in order
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder

# Adds 5 numbers between 100-1000 to unbalance the tree
5.times { tree.insert(rand(100..1000)) }

# Confirms this new tree is unbalanced
p tree.balanced?

# Rebalances tree
tree.rebalance

# Confirms the tree is balanced
p tree.balanced?

# Outputs full arrays in level, pre, post, and in order
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
