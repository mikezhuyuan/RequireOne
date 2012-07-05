from path_resolver import PathResolver
import unittest

class Test_PathResolver(unittest.TestCase):
	def test(self):
		r = PathResolver(base='D:/nodejs', 
			path_map={'bb':'backbone.js', 
				'express':'node_modules/express/lib', 
				'scripts':'/scripts',
				'/scripts':'D:/nodejs/node_modules/express/lib'})
		self.assertIsNotNone(r.resolve('bb'))
		self.assertIsNotNone(r.resolve('express/http'))
		self.assertIsNotNone(r.resolve('/scripts/http'))
		self.assertIsNotNone(r.resolve('scripts/http'))
		self.assertIsNotNone(r.resolve('express/http.js'))
		self.assertIsNotNone(r.resolve('/scripts/http.js'))
		self.assertIsNotNone(r.resolve('scripts/http.js'))

if __name__ == '__main__':
    unittest.main()