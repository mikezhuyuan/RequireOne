from path_resolver import PathResolver
import unittest

class Test_PathResolver(unittest.TestCase):
	def test(self):
		r = PathResolver('/Users/clarissawang/Development/play201', {'a':'framework', '/nodejs':'/Users/clarissawang/Development/nodejs/'})##, ignores=['a', 'framework'])	
		self.assertIsNotNone(r.resolve('framework/build'))
		self.assertIsNotNone(r.resolve('/nodejs/test'))
		self.assertIsNotNone(r.resolve('a/build'))
if __name__ == '__main__':
    unittest.main()