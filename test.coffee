require 'coffee-script'
PathResolver = require './resolver'
Nodes = (require './model').Nodes
parser = require './parser'

resolver = new PathResolver '/Users/clarissawang/Development/nodejs/test_require/public/scripts'
nodes = new Nodes

parser.parse nodes, resolver, 'main.js'

for node in nodes.all()
  console.log node.name, node.allRootDependants().length