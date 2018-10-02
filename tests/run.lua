local tests = require 'lulz.tests.testcase'


require 'lulz.tests.test_dict'
require 'lulz.tests.test_class'
require 'lulz.tests.test_functional'
require 'lulz.tests.test_str'
require 'lulz.tests.test_namedtuple'
require 'lulz.tests.test_generator'
require 'lulz.tests.test_list'


tests:run_all_tests()
