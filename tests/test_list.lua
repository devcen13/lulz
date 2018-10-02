local list = require 'lulz.list'
local fn = require 'lulz.functional'
local class = require 'lulz.class'
local iterable = require 'lulz.iterable'
local iterator = require 'lulz.iterator'

local TestCase = require 'lulz.tests.testcase'


local TestListUnbound = TestCase:inherit 'List Unbound Functions'

function TestListUnbound:test_list_append()
  local lst = { 2, 'a', 3, 78 }
  list.append(lst, 42)
  self:assert_equal(lst, { 2, 'a', 3, 78, 42 })
end

function TestListUnbound:test_list_extend_with_table()
  local lst = { 2, 'a', 3, 78 }
  list.extend(lst, { 42, 24, 'b' })
  self:assert_equal(lst, { 2, 'a', 3, 78, 42, 24, 'b' })
end

function TestListUnbound:test_list_extend_with_list()
  local lst = { 2, 'a', 3, 78 }
  list.extend(lst, list { 42, 24, 'b' })
  self:assert_equal(lst, { 2, 'a', 3, 78, 42, 24, 'b' })
end

function TestListUnbound:test_list_extend_with_itertator()
  local lst = { 2, 'a', 3, 78 }
  list.extend(lst, fn.take(2, fn.ones()))
  self:assert_equal(lst, { 2, 'a', 3, 78, 1, 1 })
end

function TestListUnbound:test_list_shrink()
  local lst = { 2, 'a', 3, 78 }
  list.resize(lst, 2)
  self:assert_equal(lst, { 2, 'a' })
end

function TestListUnbound:test_list_resize_with_value()
  local lst = { 2, 'a', 3, 78 }
  list.resize(lst, 6, 1)
  self:assert_equal(lst, { 2, 'a', 3, 78, 1, 1 })
end


local TestListClass = TestCase:inherit 'List Class'

function TestListClass:test_call_construct()
  local lst = list { 5, 6, 7 }
  self:assert(class.is_instance(lst, list))
end

function TestListClass:test_call_initializes()
  local lst = list { 5, 6, 7 }
  self:assert_equal(lst._values, { 5, 6, 7 })
end

function TestListClass:test_construct_from_iterator()
  local lst = list:new(fn.map(function(v) return v + 1 end, fn.range(3)))
  self:assert_equal(lst._values, { 2, 3, 4 })
end

function TestListClass:test_construct_from_pair_iterator()
  local lst = list:new(iterator.ipairs { 2, 3, 4 })
  self:assert_equal(lst._values, { 2, 3, 4 })
end

function TestListClass:test_call_not_copies()
  local values = { 3, 42 }
  local lst = list(values)
  table.insert(values, 3)
  self:assert_equal(lst._values, { 3, 42, 3 })
end

function TestListClass:test_constructor_initializes()
  local lst = list:new { 88, 99, 111 }
  self:assert_equal(lst._values, { 88, 99, 111 })
end

function TestListClass:test_constructor_copies()
  local values = { 3, 42 }
  local lst = list:new(values)
  table.insert(values, 3)
  self:assert_equal(lst._values, { 3, 42 })
end

function TestListClass:test_length_valid()
  local lst = list { 2, 'a', 3, 78 }
  self:assert_equal(#lst, 4)
end

function TestListClass:test_list_append()
  local lst = list { 2, 'a', 3, 78 }
  lst:append(42)
  self:assert_equal(lst._values, { 2, 'a', 3, 78, 42 })
end

function TestListClass:test_list_extend_with_table()
  local lst = list { 2, 'a', 3, 78 }
  lst:extend({ 42, 24, 'b' })
  self:assert_equal(lst._values, { 2, 'a', 3, 78, 42, 24, 'b' })
end

function TestListClass:test_list_extend_with_list()
  local lst = list { 2, 'a', 3, 78 }
  lst:extend(list { 42, 24, 'b' })
  self:assert_equal(lst._values, { 2, 'a', 3, 78, 42, 24, 'b' })
end

function TestListClass:test_list_extend_with_itertator()
  local lst = list { 2, 'a', 3, 78 }
  lst:extend(fn.take(2, fn.ones()))
  self:assert_equal(lst._values, { 2, 'a', 3, 78, 1, 1 })
end

function TestListClass:test_list_bound_checking_can_be_enabled()
  local lst = list { 2, 'a', 3, 78 }
  self:assert_equal(lst[22], nil)
  list.configure { strict = true }
  self:expect_failure(function() local _ = lst[22] end)
  list.configure { strict = false }
end

function TestListClass:test_list_shrink()
  local lst = list { 2, 'a', 3, 78 }
  lst:resize(2)
  self:assert_equal(lst._values, { 2, 'a' })
end

function TestListClass:test_list_resize_with_value()
  local lst = list { 2, 'a', 3, 78 }
  lst:resize(6, 1)
  self:assert_equal(lst._values, { 2, 'a', 3, 78, 1, 1 })
end

function TestListClass:test_list_is_iterable()
  self:assert(class.is_base_of(iterable, list))
end

function TestListClass:test_list_iter_is_ipairs()
  local lst = list:new(fn.range(100))
  for i,v in lst:iter() do
    self:assert_equal(v, i)
  end
  self:assert_equal(fn.count(lst:iter()), 100)
end

function TestListClass:test_list_items_is_values()
  local lst = list:new(fn.range(100))
  for _,v in lst:items() do
    self:assert_equal(v, nil)
  end
  self:assert_equal(fn.count(lst:items()), 100)
end
