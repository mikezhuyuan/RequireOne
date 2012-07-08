parseDependencies = (content) ->
  match = /(define|require)\s*\(\s*(\[.*?\])/g.exec content
  if match
    name.substring name.lastIndexOf('!') + 1 for name in JSON.parse match[2]
  else
    []

parse = (nodes, resolver, name) -> 
  node = nodes.create name
  content = resolver.read name
  node.dependsOn parse nodes, resolver, n for n in parseDependencies content if content 
  node

#exports
exports.parse = parse
'''
console.log extractDependencies 'define(["order!jquery","backbone"], function(jquery, backbone){return [jquery,backbone]});'
'''