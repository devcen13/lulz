local tests = require 'lulz.tests.testcase'


require 'lulz.tests.test_dict'
require 'lulz.tests.test_class'
require 'lulz.tests.test_functional'


tests:run_all_tests()
