require 'coffee-script'

exports.graph = (nodes) ->
  convert = (n) ->
    name: n.name
    dependants: n.allDependants().length
    rootDependants: n.allRootDependants().length
    type: nodeType n

  ret_nodes = (convert(n) for n in nodes.all())
  map = {}
  for n,i in ret_nodes then map[n.name] = i    
  links = []
  for from in nodes.all()
    for to in from.children
      links.push {source: map[from.name], target: map[to.name]}

  nodes: ret_nodes, links:links

exports.hiearchy = (nodes) ->
  convert = (n) ->
    name: n.name
    dependants: n.allDependants().length
    rootDependants: n.allRootDependants().length
    dependencies: c.name for c in n.children
    type: nodeType n
  map = {}
  map[n.name] = convert(n) for n in nodes.all()
  map

nodeType = (n) ->
  if n.isRoot()
    'root'
  else if n.isLeaf()
    'leaf'
  else
    'inner'