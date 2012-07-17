require 'coffee-script'
assert = (require 'assert')
unique = (require './utils').unique

#models
class Node
  constructor:(@name) -> assert.ok @name; @parents=[]; @children=[]
  dependsOn: (node) ->
    assert (node instanceof Node), 'Must be a Node'
    assert node isnt this, 'Self reference'
    @children.push(node) if node not in @children
    node.parents.push(this) if this not in node.parents
  isRoot: -> @parents.length is 0
  isLeaf: -> @children.length is 0
  clone: ->
    new_node = new Node(@name)
    new_node.parents = @parents; new_node.children = @children
    new_node
  allDependants: -> unique loadAllDependants @parents
  allRootDependants: -> node for node in @allDependants() when node.isRoot()

class Nodes
  constructor: -> @nodes={}
  add: (node) ->
    assert (node instanceof Node), 'Must be a Node'
    @nodes[node.name]=node
  all: -> node for name,node of @nodes
  create: (name) -> 
    if name of @nodes
      @nodes[name]
    else
      @add new Node name
  find: (name) -> return @nodes[name]
  roots: -> node for name,node of nodes when node.isRoot()
  clone: ->
  	new_nodes = new Nodes
  	for name,node of @nodes
  	  new_nodes.add node.clone()
  	for name,node of new_nodes.nodes
  	  node.children = new_nodes.find(n.name) for n,i in node.children
  	  node.parents = new_nodes.find(n.name) for n,i in node.parents
  	new_nodes

loadAllDependants = (nodes) ->
  dependants = []
  for node in nodes
     for n in loadAllDependants node.parents
       dependants.push n
     dependants.push node
  dependants

#exports
exports.Node = Node
exports.Nodes = Nodes

#tests
'''
nodes = new Nodes
n1 = nodes.create 'n1'
n2 = nodes.create 'n2'
n3 = nodes.create 'n3'
n4 = nodes.create 'n4'
n5 = nodes.create 'n5'
n6 = nodes.create 'ddn6'
n7 = nodes.create 'n7'

n1.dependsOn n3
n2.dependsOn n3
n2.dependsOn n4
n3.dependsOn n5
n5.dependsOn n6
n4.dependsOn n6

n1 - n3 - n5 - n6
   /           /
n2 - n4 - - - - 
n7

n1 0 0
n2 0 0
n3 2 2
n4 1 1
n5 3 2
n6 5 2
n7 0 0

log n1.allDependants().length
log n2.allDependants().length
log n3.allDependants().length
log n4.allDependants().length
log n5.allDependants().length
log n6.allDependants().length
log n7.allDependants().length


for n in nodes.all()
  log n.allDependants().length, n.allRootDependants().length
'''








