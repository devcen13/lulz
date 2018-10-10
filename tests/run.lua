local tests = require 'lulz.testcase'


require 'lulz.tests.test_utils'
require 'lulz.tests.test_class'
require 'lulz.tests.test_functional'
require 'lulz.tests.test_str'
require 'lulz.tests.test_namedtuple'
require 'lulz.tests.test_generator'
require 'lulz.tests.test_list'
require 'lulz.tests.test_dict'
require 'lulz.tests.test_queue'
require 'lulz.tests.test_math'


tests:run_all_tests()
