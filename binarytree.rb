class BinaryNode
  attr_accessor(:value, :right_child, :explored, :left_child, :parent, :distance)

  def initialize(value)
    @value = value
    @parent = nil
    @right_child = nil
    @left_child = nil
    @explored = false
    @distance = nil
  end

  def explored?
    @explored
  end

  def inspect
    "Node(#{@value})"
  end

  def link_parent(node)
    @parent = node
  end

  def link_left(node)
    @left_child = node
  end

  def link_right(node)
    @right_child = node
  end

end

class BinaryTree

  attr_accessor(:root, :nodes)

  def initialize(input=nil)
    @root = nil
    @nodes = []
    add_nodes(input) if input
  end

  def add_nodes(input_array)
    input = input_array.clone
    while input.length > 0 do
      input_value = input.slice!(rand(0...input.length))
      new_node = BinaryNode.new(input_value)
      if !@root
        @root = new_node
        p "making #{new_node.value} root"
        @nodes << new_node
      elsif new_node.value <= @root.value
        add_left(@root, new_node)
      elsif new_node.value > @root.value
        add_right(@root, new_node)
      end
    end
  end

  def add_left(parent, child)
    if !parent.left_child
      parent.left_child = child
      child.parent = parent
      p "adding #{child.value} to left of #{parent.value}"
      @nodes << child
    elsif child.value <= parent.left_child.value
      add_left(parent.left_child, child)
    elsif child.value > parent.left_child.value
      add_right(parent.left_child, child)
    end
  end

  def add_right(parent, child)
    if !parent.right_child
      parent.right_child = child
      child.parent = parent
      p "adding #{child.value} to right of #{parent.value}"
      @nodes << child
    elsif child.value <= parent.right_child.value
      add_left(parent.right_child, child)
    elsif child.value > parent.right_child.value
      add_right(parent.right_child, child)
    end
  end

  def bfs(target)
    q = []
    @root.explored = true
    @root.distance = 0
    q.push(@root)

    while q.length != 0
      current_node = q.shift
      p "current node is #{current_node.value}"
      if current_node.value == target
        return current_node
      end
      links = []
      links << current_node.left_child if current_node.left_child
      links << current_node.right_child if current_node.right_child

      links.each do |link|
        candidate_node = link
        if candidate_node.explored == false
          p "exploring #{candidate_node.value}"
          candidate_node.explored = true
          candidate_node.distance = current_node.distance + 1
          q.push(candidate_node)
        end
      end
    end
    return nil
  end

  def dfs(target)
    stack = []
    @root.explored = true
    @root.distance = 0
    stack.push(@root)

    while stack.length != 0
      current_node = stack.pop
      p "current node is #{current_node.value}"
      if current_node.value == target
        return current_node
      end
      links = []
      links << current_node.left_child if current_node.left_child
      links << current_node.right_child if current_node.right_child

      links.each do |link|
        candidate_node = link
        if candidate_node.explored == false
          p "exploring #{candidate_node.value}"
          candidate_node.explored = true
          candidate_node.distance = current_node.distance + 1
          stack.push(candidate_node)
        end
      end
    end
    return nil

  end

end
#test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324].uniq

test_array = []

20.times do
  test_array << rand(0..100)
end

test_array.uniq!

target = test_array.sample
p test_array
test = BinaryTree.new
test.add_nodes(test_array)
p test.nodes
test.nodes.each do |node|
  p "node: #{node.value}"
  p "parent: #{node.parent ? node.parent.value : 'none'},"
  p "left: #{node.left_child ? node.left_child.value : 'none'},"
  p "right: #{node.right_child ? node.right_child.value : 'none'}"
end
p test_array
p "target of search is #{target}"
result = test.dfs(target)
if !result
  p "target was not found"
else
  p "target found!"
  p "value: #{result.value}"
  p "parent: #{result.parent ? result.parent.value : 'none'}"
  p "left child: #{result.left_child ? result.left_child.value : 'none'}"
  p "right child: #{result.right_child ? result.right_child.value : 'none'}"
  p "depth: #{result.distance}"
end
