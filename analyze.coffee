require 'coffee-script'
PathResolver = require './resolver'
Nodes = (require './model').Nodes
parser = require './parser'
reporter = require './reporter'
fs = require 'fs'

module.exports = (path) ->
  contents = fs.readFileSync path, 'utf8'
  config = JSON.parse contents.replace(/\/\/.*/g,'').replace(/\/\*[\s\S]*?\*\//g, '') #remove comments
  resolver = new PathResolver config.root, config.map, config.ignores
  nodes = new Nodes
  
  for target in config.targets
    parser.parse nodes, resolver, target

  reporter.hiearchy nodes