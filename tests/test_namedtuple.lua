local namedtuple = require 'lulz.namedtuple'
local TestCase = require 'lulz.testcase'


local TestNamedTuple = TestCase:inherit 'Named Tuple'

function TestNamedTuple:test_empty_namedtuple_create()
  local Tuple = namedtuple('tuple with name', {})
  self:assert_equal(Tuple.__name__, 'tuple with name')
  self:assert_equal(Tuple.__items__, {})
end

function TestNamedTuple:test_anonimous_tuple_create()
  local Tuple = namedtuple({})
  self:assert_equal(Tuple.__name__, 'namedtuple')
  self:assert_equal(Tuple.__items__, {})
end

function TestNamedTuple:test_namedtuple_create()
  local Tuple = namedtuple('tuple', {'x', 'y'})
  local inst = Tuple(2, 0)
  self:assert_equal(inst.x, 2)
  self:assert_equal(inst.y, 0)
end

function TestNamedTuple:test_namedtuple_string()
  local Tuple = namedtuple('tuple', {'x', 'y'})
  self:assert_equal(tostring(Tuple), 'namedtuple tuple')
end

function TestNamedTuple:test_instance_string()
  local Tuple = namedtuple('tuple', {'x', 'y'})
  local inst = Tuple(2, 0)
  self:assert_equal(tostring(inst), 'tuple<2, 0>')
end

function TestNamedTuple:test_namedtuple_modified()
  local Tuple = namedtuple('tuple', {'x'})
  local inst = Tuple(2)
  inst.x = 3
  self:assert_equal(inst.x, 3)
end

function TestNamedTuple:test_namedtuple_index_fails()
  local Tuple = namedtuple('tuple', {'x'})
  local inst = Tuple(2)
  self:expect_failure(function() local _ = inst.y end)
end

function TestNamedTuple:test_namedtuple_newindex_fails()
  local Tuple = namedtuple('tuple', {'x'})
  local inst = Tuple(2)
  self:expect_failure(function() inst.y = 2 end)
end
