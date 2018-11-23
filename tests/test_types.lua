local types = require 'lulz.types'
local TestCase = require 'lulz.testcase'


local TestTypes = TestCase:inherit 'Types'

TestTypes.test_type_is_type = TestCase.args_test {
  call = function(self, tp)
    self:assert(types.istype(tp))
  end,
  argsset = {
    { types['nil'] },
    { types.bool },
    { types.boolean },
    { types.number },
    { types.int },
    { types.float },
    { types.string },
    { types.str },
    { types.table },

    { types['function'] },
    { types['thread'] },
    { types['userdata'] },
  }
}

TestTypes.test_typeof_type_is_type = TestCase.args_test {
  call = function(self, tp)
    self:assert_equal(types.typeof(tp), types.type)
  end,
  argsset = {
    { types['nil'] },
    { types.bool },
    { types.boolean },
    { types.number },
    { types.int },
    { types.float },
    { types.string },
    { types.str },
    { types.table },

    { types['function'] },
    { types['thread'] },
    { types['userdata'] },
  }
}

TestTypes.test_base_type_can_be_created_by_call = TestCase.args_test {
  call = function(self, tp, default)
    self:assert_equal(tp(), default)
  end,
  argsset = {
    { types['nil'], nil },
    { types.bool, false },
    { types.boolean, false },
    { types.number, 0 },
    { types.int, 0 },
    { types.float, 0.0 },
    { types.string, '' },
    { types.str, '' },
    { types.table, {} },

    --- @todo noncreatable
    -- { types['function'] },
    -- { types['thread'] },
    -- { types['userdata'] },
  }
}

TestTypes.test_base_type_can_be_created_from_same_val = TestCase.args_test {
  call = function(self, tp, val)
    self:assert_equal(tp(val), val)
  end,
  argsset = {
    { types['nil'], nil },
    { types.bool, false },
    { types.bool, true },
    { types.boolean, false },
    { types.boolean, true },
    { types.number, 0 },
    { types.number, 42 },
    { types.int, 0 },
    { types.int, 42 },
    { types.float, 0.0 },
    { types.float, 0.7 },
    { types.string, '' },
    { types.string, 'str' },
    { types.str, '' },
    { types.str, 'test' },
    { types.table, {} },
    { types.table, { a = 0, 1, 2 } },
  }
}

TestTypes.test_type_converter_creation = TestCase.args_test {
  call = function(self, tp, val, converted)
    self:assert_equal(tp(val), converted)
  end,
  argsset = {
    { types['nil'], {}, nil },
    { types.bool, nil, false },
    { types.bool, '', true },
    { types.int, 0.6, 0 },
    { types.int, 42.5, 42 },
    { types.float, 10, 10.0 },
    { types.string, nil, '' },
    { types.string, 0.2, '0.2' },
  }
}

TestTypes.test_value_type_is_valid = TestCase.args_test {
  call = function(self, tp, val)
    self:assert_equal(types.typeof(val), tp)
  end,
  argsset = {
    { types['nil'], nil },
    { types.bool, false },
    { types.bool, true },
    { types.boolean, false },
    { types.boolean, true },
    { types.number, 0 },
    { types.number, 42 },
    { types.string, '' },
    { types.string, 'str' },
    { types.str, '' },
    { types.str, 'test' },
    { types.table, {} },
    { types.table, { a = 0, 1, 2 } },
  }
}

TestTypes.test_value_type_is_not_different = TestCase.args_test {
  call = function(self, tp, val)
    self:assert_not_equal(types.typeof(val), tp)
  end,
  argsset = {
    { types['nil'], false },
    { types.bool, nil },
    { types.bool, 0 },
    { types.boolean, 'false' },
    { types.boolean, { true } },
    { types.number, '0' },
    { types.number, nil },
    { types.string, 42 },
    { types.string, { 'str' } },
    { types.str, nil },
    { types.str, false },
    { types.table, types.table },
    { types.table, function() end },
  }
}

TestTypes.test_value_is_instance_of_its_type = TestCase.args_test {
  call = function(self, tp, val)
    self:assert(types.isinstance(val, tp))
  end,
  argsset = {
    { types['nil'], nil },
    { types.bool, false },
    { types.bool, true },
    { types.boolean, false },
    { types.boolean, true },
    { types.number, 0 },
    { types.number, 42 },
    { types.int, 0 },
    { types.float, 0.0 },
    { types.string, '' },
    { types.string, 'str' },
    { types.str, '' },
    { types.str, 'test' },
    { types.table, {} },
    { types.table, { a = 0, 1, 2 } },
  }
}

TestTypes.test_value_is_not_instance_of_different_type = TestCase.args_test {
  call = function(self, tp, val)
    self:assert_false(types.isinstance(val, tp))
  end,
  argsset = {
    { types['nil'], false },
    { types.bool, nil },
    { types.bool, 0 },
    { types.boolean, 'false' },
    { types.boolean, { true } },
    { types.number, '0' },
    { types.number, nil },
    { types.int, 0.5 },
    { types.float, '0.0' },
    { types.string, 42 },
    { types.string, { 'str' } },
    { types.str, nil },
    { types.str, false },
    { types.table, function() end },
  }
}