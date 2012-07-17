path = require 'path'
fs = require 'fs'

class PathResolver
  constructor: (@base='.', @path_map={}, @ignores=[]) ->
    for k,v of @path_map
      if v[0] is '/'
        @path_map[k] = map_path v, @path_map
  path: (name) ->
    if name in @ignores 
      return
    path.join @base, map_path(name, @path_map)
  read: (name) ->
    file_path = @path name
    if not file_path then return
    if not endswith file_path, '.js'
      file_path += '.js'
    fs.readFileSync file_path, 'utf8' if file_path and path.existsSync file_path

map_path = (name, map) ->
  for k,v of map
    if startswith name, k
      name = path.join v, name.substring k.length
      break
  name

startswith = (source, target) ->
  target is source.substring 0, target.length

endswith = (source, target) ->
  target is source.substring source.length - target.length

module.exports = PathResolver

'''
_map =
  'mm':'mocha.js', 
  'r':'jquery-require-sample/r', 
  'scripts':'/scripts',
  '/scripts':'../js/jquery-require-sample'

resolver = new PathResolver '/Users/clarissawang/Development/js', _map

check = (name) -> 
  console.log !!(resolver.read name)

check 'jquery-require-sample/r.js'
check 'mm'
check 'scripts/r'
check 'r'
'''