'''
path resolver
todo: doc
'''
import os

class PathResolver:
	__modifiers = [
		lambda x : x,
		lambda x : x + '.js'
	]
	def __init__(self, base='.', path_map={}, ignores=[]):
		self._base = base
		self._path_map = {k : v if k.startswith('/') or v.startswith('/') else os.path.join(base, v) for k,v in path_map.items()}
		self._ignores = list(ignores)
	def _each_mapping(self):
		for k, v in self._path_map.items():
			yield (k, v)
		yield ('', self._base)
	def resolve(self, path):
		if path in self._ignores:
			return None
		for k, v in self._each_mapping():
			if not path.startswith(k):
				continue
			for m in self.__modifiers:
				p = path[len(k):]
				if p.startswith('/'):
					p = p[1:]				
				resolved = os.path.join(v, m(p)) if p else m(v)
				resolved = resolved.replace('\\', '/')
				#print v, m(p), resolved
				if resolved.startswith('/'):
					return self.resolve(resolved)
				if os.path.exists(resolved):
					return resolved