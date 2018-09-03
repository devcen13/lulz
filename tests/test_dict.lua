local dict = require 'lulz.dict'
local TestCase = require 'lulz.tests.testcase'


local TestDictEqual = TestCase:inherit 'Dict Equals'


function TestDictEqual:test_different_type_objects_not_equal()
  self:assert(not tablex:equals(5, 'five'))
end

function TestDictEqual:test_equal_numbers_equal()
  self:assert(tablex.equals(2 + 2, 4))
end

function TestDictEqual:test_equal_floats_equal()
  self:assert(tablex.equals(0.2 + 0.1, 0.3))
end

function TestDictEqual:test_different_numbers_not_equal()
  self:assert(not tablex.equals(2 + 2, 5))
end

function TestDictEqual:test_equal_numbers_equal_with_epsilon()
  self:assert(tablex.equals(2 + 2, 5, { eps = 2 }))
end

function TestDictEqual:test_empty_tables_equal()
  self:assert(tablex.equals({}, {}))
end

function TestDictEqual:test_simple_tables_equal()
  self:assert(tablex.equals({ x = 3 }, { x = 3 }))
end

function TestDictEqual:test_recursive_tables_equal()
  self:assert(tablex.equals({ x = 3, { y = 5 } }, { x = 3, { y = 5 } }))
end

function TestDictEqual:test_different_values_in_table_not_equal()
  self:assert(not tablex.equals({ x = 3 }, { x = 5 }))
end

function TestDictEqual:test_more_values_in_table_not_equal()
  self:assert(not tablex.equals({ x = 3 }, { x = 3, y = 5 }))
end

function TestDictEqual:test_equal_arrays_equal()
  self:assert(tablex.equals({ 1, 2, 3 }, { 1, 2, 3 }))
end

function TestDictEqual:test_different_arrays_not_equal()
  self:assert(not tablex.equals({ 1, 2, 3 }, { 1, 2, 3, 4, 5 }))
end

function TestDictEqual:test_permutated_arrays_not_equal()
  self:assert(not tablex.equals({ 1, 2, 3 }, { 1, 3, 2 }))
end

function TestDictEqual:test_meta_call()
  local alwaysEqual = setmetatable({}, { __eq = function() return true end })
  self:assert(tablex.equals(alwaysEqual, { 0 }))
end


local TestDictClone = TestCase:inherit 'Dict Clone'

function TestDictClone:test_clone_number()
  local value = 5
  self:assert_equal(tablex.clone(value), value)
end

function TestDictClone:test_clone_string()
  local value = 'value'
  self:assert_equal(tablex.clone(value), value)
end

function TestDictClone:test_cloned_table_equal()
  local value = { x = 0, y = 1 }
  self:assert_equal(tablex.clone(value), value)
end

function TestDictClone:test_cloned_table_not_same()
  local value = { x = 0, y = 1 }
  local cloned = tablex.clone(value)
  cloned.x = 2
  self:assert_not_equal(cloned, value)
end

function TestDictClone:test_recursive_cloned_table_equal()
  local value = { x = { x = 0, y = 2 }, y = 1 }
  self:assert_equal(tablex.clone(value), value)
end

function TestDictClone:test_recursive_cloned_table_not_same()
  local value = { x = { x = 0, y = 2 }, y = 1 }
  local cloned = tablex.clone(value)
  cloned.x.x = 2
  self:assert_not_equal(cloned, value)
end


local TestDictExtend = TestCase:inherit 'Dict Extend'

function TestDictExtend:test_extend_nil_equal()
  local value = {}
  self:assert_equal(tablex.extend(value, nil), value)
end

function TestDictExtend:test_extend_empty_equal()
  local value = { x = 0 }
  self:assert_equal(tablex.extend(value, {}), value)
end

function TestDictExtend:test_simple_extend()
  local value = { x = 0 }
  self:assert_equal(tablex.extend(value, { y = 0 }), { x = 0, y = 0 })
end

function TestDictExtend:test_recursive_extend()
  local value = { x = { x = 0 } }
  self:assert_equal(tablex.extend(value, { x = { y = 3 }, y = {} }), { x = { x = 0, y = 3 }, y = {} })
end

function TestDictExtend:test_extend_change_type()
  local value = { x = { x = 0 } }
  self:assert_equal(tablex.extend(value, { x = 3, y = {} }), { x = 3, y = {} })
end

function TestDictExtend:test_extend_override_policy()
  local value = { x = { x = 0, y = {} } }
  local overrides = { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } }
  local extended = tablex.extend(value, overrides, tablex.override)
  self:assert_equal(extended, { x = { x = 1, y = {} } })
end

function TestDictExtend:test_extend_add_key_policy()
  local value = { x = { x = 0, y = {} } }
  local overrides = { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } }
  local extended = tablex.extend(value, overrides, tablex.add_key)
  self:assert_equal(extended, { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } })
  overrides.y.y = 5
  self:assert_equal(extended, { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 5 } })
end

function TestDictExtend:test_extend_clone_policy()
  local value = { x = { x = 0, y = {} } }
  local overrides = { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } }
  local extended = tablex.extend(value, overrides, tablex.clone_new_items)
  self:assert_equal(extended, { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } })
  overrides.y.y = 5
  self:assert_equal(extended, { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } })
end
