local list = require 'lulz.collections.list'
local fn = require 'lulz.functional'
local op = require 'lulz.operators'
local types = require 'lulz.types'
local I = require 'lulz.types.interfaces'
local iterator = require 'lulz.iterator'

local TestCase = require 'lulz.testcase'


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

TestListUnbound.test_list_reverse = TestCase.args_test {
  call = function(self, orig, reversed)
    list.reverse(orig)
    self:assert_equal(orig, reversed)
  end,
  argsset = {
    { {}, {} },
    { { 1, 2 }, { 2, 1 } },
    { { 1, 2, 3 }, { 3, 2, 1 } },
  }
}

TestListUnbound.test_list_reverse = TestCase.args_test {
  call = function(self, orig, sorted, predicate)
    list.sort(orig, predicate)
    self:assert_equal(orig, sorted)
  end,
  argsset = {
    { {}, {} },
    { { 1, 2 }, { 1, 2 } },
    { { 3, 2, 3 }, { 2, 3, 3 } },
    { { 1, 2, 3 }, { 3, 2, 1 }, op.more },
  }
}


local TestListClass = TestCase:inherit 'List Class'

function TestListClass:test_call_construct()
  local lst = list { 5, 6, 7 }
  self:assert(types.isinstance(lst, list))
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

function TestListClass:test_size_valid()
  local lst = list { 2, 'a', 3, 78 }
  self:assert_equal(lst.size, 4)
  if _VERSION < "Lua 5.3" then
    self:warning('__len is not supported by lua < 5.3')
    return
  end
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
  self:assert(I.iterable:isimplemented(list))
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
