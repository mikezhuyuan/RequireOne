parseDependencies = (content) ->
  match = /(define|require)\s*\(\s*(\[[^\]]*?\])/g.exec content  
  if match
    array = match[2].replace(/\'/g, '\"')
    name.substring name.lastIndexOf('!') + 1 for name in JSON.parse array
  else
    []

parse = (nodes, resolver, name) ->  
  content = resolver.read name
  if not content then return
  node = nodes.create name
  for n in parseDependencies content
    dep = parse nodes, resolver, n
    node.dependsOn dep if dep
  node

#exports
exports.parse = parse
'''
console.log extractDependencies 'define(["order!jquery","backbone"], function(jquery, backbone){return [jquery,backbone]});'
'''