import re
import os

root = r'D:\TFS\ETTfsApp\EnglishTown\Team_ELab\Development\Source\ELab\ELab\EFSchools.Englishtown.ELab.UI\_scripts'
#'admin/main/user.view.main.js'
source = 'app/reportApp.js'

predefined = ['elabConfig', 'loginDetails']
alias = {
	'underscore': 'require/adapter/underscore',
	'jquery': 'require/adapter/jquery',
	'jquery.validate': 'jquery.validate.min',
	'jquery.ui':'/_scripts/jquery/jquery-ui-1.8.7.custom.min',
	'backbone': 'require/adapter/backbone',
	'fancybox': 'require/adapter/fancybox',
	'jtemplate': '/_scripts/jquery/jquery-jtemplates.js',
	'appRouter':'app/router',
	'appModel':'app/model',
	'appView':'app/view',
	'appData':'app/data',
	'base': 'admin/base'
}
resolve_path = '/elab/_scripts/'

re_find_deps = re.compile(r'(define|require)\s*\(\s*\[([^\]]*)\]', re.DOTALL | re.MULTILINE)
nodes = dict()

class ModuleNode:
	def __init__(self, name, content, match):
		self.name, self.content, self.match = name, content, match				
		self.deps = set()
		self._deps = set()
		nodes[name] = self
	def add_dep(self, node):
		self.deps.add(node)
		self._deps.add(node)
	def remove_dep(self, node):
		if(node in self.deps): self.deps.remove(node)
	def render(self):
		start, end = self.match.start(), self.match.end()			
		return self._debug_str() + '{0}{1}({2}[{3}]{4}'.format(self.content[0:start], 
				self.match.group(1), 
				('"' + self.name + '",') if self.name and self.match.group(1) == 'define' else '', 
				self.match.group(2), 
				self.content[end:])			
	def _debug_str(self):
		str = '/*debug{ name: ' + self.name
		if(self._deps):
			str += ', dependencies: ' + '|'.join([dep.name for dep in self._deps])		
		return str + ' }*/\n'

class InternalNode:
	def __init__(self, name, content):
		self.name, self.content = name, content
		nodes[name] = self
		self.deps = None
	def render(self):
		return '/*debug{ name: ' + self.name + ' }*/\ndefine("' + self.name + '");\n' + self.content

class NullNode:
	def __init__(self, name):
		self.name = name
		self.deps = None
		nodes[name] = self
	def render(self):
		return ''

class ExternalNode(NullNode):
	pass

class PredefinedNode(NullNode):
	pass

def file_exists(path):
	return os.path.exists(os.path.join(root, path))

def load_file(path):
	with open(os.path.join(root, path), 'r') as file:
		return file.read()

def create_entry(name):	
	if(nodes.has_key(name)):
		return nodes[name]
		
	if(name.startswith('/')):		
		if(name.startswith(resolve_path)):
			n = create_entry(name[len(resolve_path):])
			n.name = name
			return n
		else
			return ExternalNode(name)
		
	if(name.count('!')):
		pre, nm = name.split('!')
		if(pre == 'order'):
			n = create_entry(nm)
			n.name = name
			return n
		return NullNode(name)

	path = name	
	if(not file_exists(path)):		
		n = name.split(r'/')[0]		
		if(alias.has_key(n)):
			n = create_entry(alias[n] + name[len(n):])
			n.name = name
			return n
	if(not path.endswith('.js')):
		path = path + '.js'		
	if(not file_exists(path)):
		return NullNode(name)
	
	content = load_file(path)	
	match = re_find_deps.search(content)
	if(not match):		
		return InternalNode(name, content)
	
	entry = ModuleNode(name, content, match)
	for dep in match.group(2).split(','):
		dep = dep.strip()[1:-1].strip()		
		entry.add_dep(create_entry(dep))

	return entry

for name in predefined:
	PredefinedNode(name)

create_entry(source)

while len(nodes):
	rm = []
	for k in nodes:
		n = nodes[k]
		if(not n.deps):
			print n.render()
			rm.append(k)
	for k in rm:
		n = nodes.pop(k)
		for v in nodes.values():
			v.deps and v.remove_dep(n)