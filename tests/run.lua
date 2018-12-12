
if not string.gmatch(package.path, '\\./\\?/init\\.lua')() then
  package.path = './?/init.lua;' .. package.path
end

local globals = require 'lulz.globals'
globals.lock()


local tests = require 'lulz.testcase'


require 'lulz.tests.test_utils'
require 'lulz.tests.test_types'
require 'lulz.tests.test_class'
require 'lulz.tests.test_functional'
require 'lulz.tests.test_iterable'
require 'lulz.tests.test_str'
require 'lulz.tests.test_namedtuple'
require 'lulz.tests.test_generator'
require 'lulz.tests.test_event'
require 'lulz.tests.test_list'
require 'lulz.tests.test_dict'
require 'lulz.tests.test_queue'
require 'lulz.tests.test_stack'
require 'lulz.tests.test_set'
require 'lulz.tests.test_ordereddict'
require 'lulz.tests.test_math'


tests:run_all_tests()
