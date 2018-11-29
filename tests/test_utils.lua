local utils = require 'lulz.private.utils'
local TestCase = require 'lulz.testcase'


local TestUtilsEqual = TestCase:inherit 'Utils Equals'


function TestUtilsEqual:test_different_type_objects_not_equal()
  self:assert(not utils:equals(5, 'five'))
end

function TestUtilsEqual:test_equal_numbers_equal()
  self:assert(utils.equals(2 + 2, 4))
end

function TestUtilsEqual:test_equal_floats_equal()
  self:assert(utils.equals(0.2 + 0.1, 0.3))
end

function TestUtilsEqual:test_different_numbers_not_equal()
  self:assert(not utils.equals(2 + 2, 5))
end

function TestUtilsEqual:test_equal_numbers_equal_with_epsilon()
  self:assert(utils.equals(2 + 2, 5, { eps = 2 }))
end

function TestUtilsEqual:test_empty_tables_equal()
  self:assert(utils.equals({}, {}))
end

function TestUtilsEqual:test_simple_tables_equal()
  self:assert(utils.equals({ x = 3 }, { x = 3 }))
end

function TestUtilsEqual:test_recursive_tables_equal()
  self:assert(utils.equals({ x = 3, { y = 5 } }, { x = 3, { y = 5 } }))
end

function TestUtilsEqual:test_different_values_in_table_not_equal()
  self:assert(not utils.equals({ x = 3 }, { x = 5 }))
end

function TestUtilsEqual:test_more_values_in_table_not_equal()
  self:assert(not utils.equals({ x = 3 }, { x = 3, y = 5 }))
end

function TestUtilsEqual:test_equal_arrays_equal()
  self:assert(utils.equals({ 1, 2, 3 }, { 1, 2, 3 }))
end

function TestUtilsEqual:test_different_arrays_not_equal()
  self:assert(not utils.equals({ 1, 2, 3 }, { 1, 2, 3, 4, 5 }))
end

function TestUtilsEqual:test_permutated_arrays_not_equal()
  self:assert(not utils.equals({ 1, 2, 3 }, { 1, 3, 2 }))
end

function TestUtilsEqual:test_meta_call()
  local eq = function() return true end
  local a = setmetatable({}, { __eq = eq })
  local b = setmetatable({}, { __eq = eq })
  self:assert(utils.equals(a, b))
end


local TestUtilsClone = TestCase:inherit 'Utils Clone'

function TestUtilsClone:test_clone_number()
  local value = 5
  self:assert_equal(utils.clone(value), value)
end

function TestUtilsClone:test_clone_string()
  local value = 'value'
  self:assert_equal(utils.clone(value), value)
end

function TestUtilsClone:test_cloned_table_equal()
  local value = { x = 0, y = 1 }
  self:assert_equal(utils.clone(value), value)
end

function TestUtilsClone:test_cloned_table_not_same()
  local value = { x = 0, y = 1 }
  local cloned = utils.clone(value)
  cloned.x = 2
  self:assert_not_equal(cloned, value)
end

function TestUtilsClone:test_recursive_cloned_table_equal()
  local value = { x = { x = 0, y = 2 }, y = 1 }
  self:assert_equal(utils.clone(value), value)
end

function TestUtilsClone:test_recursive_cloned_table_not_same()
  local value = { x = { x = 0, y = 2 }, y = 1 }
  local cloned = utils.clone(value)
  cloned.x.x = 2
  self:assert_not_equal(cloned, value)
end


local TestUtilsExtend = TestCase:inherit 'Utils Extend'

function TestUtilsExtend:test_extend_nil_equal()
  local value = {}
  self:assert_equal(utils.extend(value, nil), value)
end

function TestUtilsExtend:test_extend_empty_equal()
  local value = { x = 0 }
  self:assert_equal(utils.extend(value, {}), value)
end

function TestUtilsExtend:test_simple_extend()
  local value = { x = 0 }
  self:assert_equal(utils.extend(value, { y = 0 }), { x = 0, y = 0 })
end

function TestUtilsExtend:test_recursive_extend()
  local value = { x = { x = 0 } }
  self:assert_equal(utils.extend(value, { x = { y = 3 }, y = {} }), { x = { x = 0, y = 3 }, y = {} })
end

function TestUtilsExtend:test_extend_change_type()
  local value = { x = { x = 0 } }
  self:assert_equal(utils.extend(value, { x = 3, y = {} }), { x = 3, y = {} })
end

function TestUtilsExtend:test_extend_override_policy()
  local value = { x = { x = 0, y = {} } }
  local overrides = { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } }
  local extended = utils.override(value, overrides)
  self:assert_equal(extended, { x = { x = 1, y = {} } })
end

function TestUtilsExtend:test_extend_add_key_policy()
  local value = { x = { x = 0, y = {} } }
  local overrides = { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } }
  local extended = utils.extend(value, overrides)
  self:assert_equal(extended, { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 2 } })
  overrides.y.y = 5
  self:assert_equal(extended, { x = { x = 1, y = { 0, 1, 2 } }, y = { y = 5 } })
end
