local I = require 'lulz.types.interfaces'
local TestCase = require 'lulz.testcase'


local TestUtilsEqual = TestCase:inherit 'Utils Equals'


function TestUtilsEqual:test_different_type_objects_not_equal()
  self:assert(not I.equatable.equals(5, 'five'))
end

function TestUtilsEqual:test_equal_numbers_equal()
  self:assert(I.equatable.equals(2 + 2, 4))
end

function TestUtilsEqual:test_equal_floats_equal()
  self:assert(I.equatable.equals(0.2 + 0.1, 0.3))
end

function TestUtilsEqual:test_different_numbers_not_equal()
  self:assert(not I.equatable.equals(2 + 2, 5))
end

function TestUtilsEqual:test_equal_numbers_equal_with_epsilon()
  self:assert(I.equatable.equals(2 + 2, 5, 2))
end

function TestUtilsEqual:test_empty_tables_equal()
  self:assert(I.equatable.equals({}, {}))
end

function TestUtilsEqual:test_simple_tables_equal()
  self:assert(I.equatable.equals({ x = 3 }, { x = 3 }))
end

function TestUtilsEqual:test_recursive_tables_equal()
  self:assert(I.equatable.equals({ x = 3, { y = 5 } }, { x = 3, { y = 5 } }))
end

function TestUtilsEqual:test_different_values_in_table_not_equal()
  self:assert(not I.equatable.equals({ x = 3 }, { x = 5 }))
end

function TestUtilsEqual:test_more_values_in_table_not_equal()
  self:assert(not I.equatable.equals({ x = 3 }, { x = 3, y = 5 }))
end

function TestUtilsEqual:test_equal_arrays_equal()
  self:assert(I.equatable.equals({ 1, 2, 3 }, { 1, 2, 3 }))
end

function TestUtilsEqual:test_different_arrays_not_equal()
  self:assert(not I.equatable.equals({ 1, 2, 3 }, { 1, 2, 3, 4, 5 }))
end

function TestUtilsEqual:test_permutated_arrays_not_equal()
  self:assert(not I.equatable.equals({ 1, 2, 3 }, { 1, 3, 2 }))
end

function TestUtilsEqual:test_meta_call()
  local eq = function() return true end
  local a = setmetatable({}, { __eq = eq })
  local b = setmetatable({}, { __eq = eq })
  self:assert(I.equatable.equals(a, b))
end


local TestUtilsClone = TestCase:inherit 'Utils Clone'

function TestUtilsClone:test_clone_number()
  local value = 5
  self:assert_equal(I.clonable.clone(value), value)
end

function TestUtilsClone:test_clone_string()
  local value = 'value'
  self:assert_equal(I.clonable.clone(value), value)
end

function TestUtilsClone:test_cloned_table_equal()
  local value = { x = 0, y = 1 }
  self:assert_equal(I.clonable.clone(value), value)
end

function TestUtilsClone:test_cloned_table_not_same()
  local value = { x = 0, y = 1 }
  local cloned = I.clonable.clone(value)
  cloned.x = 2
  self:assert_not_equal(cloned, value)
end

function TestUtilsClone:test_recursive_cloned_table_equal()
  local value = { x = { x = 0, y = 2 }, y = 1 }
  self:assert_equal(I.clonable.clone(value), value)
end

function TestUtilsClone:test_recursive_cloned_table_not_same()
  local value = { x = { x = 0, y = 2 }, y = 1 }
  local cloned = I.clonable.clone(value)
  cloned.x.x = 2
  self:assert_not_equal(cloned, value)
end
