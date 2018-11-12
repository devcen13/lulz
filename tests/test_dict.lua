local dict = require 'lulz.collections.dict'
local fn = require 'lulz.functional'
local class = require 'lulz.class'
local iterable = require 'lulz.iterable'
local iterator = require 'lulz.iterator'

local TestCase = require 'lulz.testcase'


local TestDictUnbound = TestCase:inherit 'Dict Unbound Functions'


function TestDictUnbound:test_dict_extend_with_table()
  local dct = { x = 2, y = 'a', z = 3, w = 78 }
  dict.extend(dct, { a = 42, b = 24 })
  self:assert_equal(dct, { x = 2, y = 'a', z = 3, w = 78, a = 42, b = 24 })
end

function TestDictUnbound:test_dict_extend_with_dict()
  local dct = { x = 2, y = 'a', z = 3, w = 78 }
  dict.extend(dct, dict { a = 42, b = 24 })
  self:assert_equal(dct, { x = 2, y = 'a', z = 3, w = 78, a = 42, b = 24 })
end

function TestDictUnbound:test_dict_extend_with_itertator()
  local dct = { x = 2, y = 'a', z = 3, w = 78 }
  dict.extend(dct, iterator.pairs({ a = 1, b = 1 }))
  self:assert_equal(dct, { x = 2, y = 'a', z = 3, w = 78, a = 1, b = 1 })
end


local TestDictClass = TestCase:inherit 'dict' {
  Type = dict
}

function TestDictClass:test_call_construct()
  local dct = self.Type { x = 5, y = 6, z = 7 }
  self:assert(class.is_instance(dct, self.Type))
end

function TestDictClass:test_call_initializes()
  local dct = self.Type { x = 5, y = 6, z = 7 }
  self:assert_equal(dct._values, { x = 5, y = 6, z = 7 })
end

function TestDictClass:test_construct_from_iterator()
  local dct = self.Type:new(iterator.pairs({ x = 5, y = 6, z = 7 }))
  self:assert_equal(dct._values, { x = 5, y = 6, z = 7 })
end

function TestDictClass:test_call_not_copies()
  local values = { x = 5, y = 6, z = 7 }
  local dct = self.Type(values)
  values.w = 1
  self:assert_equal(dct._values, { x = 5, y = 6, z = 7, w = 1 })
end

function TestDictClass:test_constructor_initializes()
  local dct = self.Type:new { x = 5, y = 6, z = 7 }
  self:assert_equal(dct._values, { x = 5, y = 6, z = 7 })
end

function TestDictClass:test_constructor_copies()
  local values = { x = 5, y = 6, z = 7 }
  local dct = self.Type:new(values)
  values.w = 1
  self:assert_equal(dct._values, { x = 5, y = 6, z = 7 })
end

function TestDictClass:test_size_valid()
  local dct = self.Type { x = 5, y = 6, z = 7 }
  self:assert_equal(dct:size(), 3)
end

function TestDictClass:test_dict_extend_with_table()
  local dct = self.Type { x = 2, y = 'a', z = 3, w = 78 }
  dict.extend(dct, { a = 42, b = 24 })
  self:assert_equal(dct._values, { x = 2, y = 'a', z = 3, w = 78, a = 42, b = 24 })
end

function TestDictClass:test_dict_extend_with_dict()
  local dct = self.Type { x = 2, y = 'a', z = 3, w = 78 }
  dct:extend(self.Type { a = 42, b = 24 })
  self:assert_equal(dct._values, { x = 2, y = 'a', z = 3, w = 78, a = 42, b = 24 })
end

function TestDictClass:test_dict_extend_with_iterator()
  local dct = self.Type { x = 2, y = 'a', z = 3, w = 78 }
  dct:extend(iterator.pairs { a = 42, b = 24 })
  self:assert_equal(dct._values, { x = 2, y = 'a', z = 3, w = 78, a = 42, b = 24 })
end

function TestDictClass:test_empty_dict_is_empty()
  self:assert(self.Type:new():is_empty())
end

function TestDictClass:test_dict_with_values_is_not_empty()
  local dct = self.Type { x = 1, y = 2 }
  self:assert_false(dct:is_empty())
end

function TestDictClass:test_cleared_dict_is_empty()
  local dct = self.Type { x = 1, y = 2 }
  dct:clear()
  self:assert(dct:is_empty())
end

function TestDictClass:test_dict_is_iterable()
  self:assert(class.is_base_of(iterable, self.Type))
end

function TestDictClass:test_dict_iter_is_pairs()
  local dct = self.Type:new(fn.zip(fn.range(100), fn.range(100)))
  for k,v in dct:iter() do
    self:assert_equal(v, k)
  end
  self:assert_equal(fn.count(dct:iter()), 100)
end

function TestDictClass:test_dict_values_is_single_value()
  local dct = self.Type:new(fn.zip(fn.range(100), fn.range(100)))
  for _,v in dct:values() do
    self:assert_equal(v, nil)
  end
end

function TestDictClass:test_dict_values_is_dict_size()
  local dct = self.Type:new(fn.zip(fn.range(100), fn.range(100)))
  self:assert_equal(fn.count(dct:values()), 100)
end

function TestDictClass:test_dict_keys_is_single_value()
  local dct = self.Type:new(fn.zip(fn.range(100), fn.range(100)))
  for _,v in dct:keys() do
    self:assert_equal(v, nil)
  end
end

function TestDictClass:test_dict_keys_is_dict_size()
  local dct = self.Type:new(fn.zip(fn.range(100), fn.range(100)))
  self:assert_equal(fn.count(dct:keys()), 100)
end
