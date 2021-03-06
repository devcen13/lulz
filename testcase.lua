local types = require 'lulz.types'
local class = require 'lulz.types.class'
local I = require 'lulz.types.interfaces'
local fn = require 'lulz.functional'

local ESCAPE = string.char(27)
local RED    = ESCAPE .. '[1;31m'
local GREEN  = ESCAPE .. '[1;32m'
local YELLOW = ESCAPE .. '[1;33m'
local WHITE  = ESCAPE .. '[1;37m'

local _testcaseclasses = {}
local TestCase = class {
  cases = {},
  fast_test = false,
  verbose = true,
  fail_on_assert = false,

  __init_subclass__ = function(self)
    table.insert(_testcaseclasses, self)
  end,
  __init__ = function(self)
    self.success = true
    self.warnings = 0
    self.messages = {}
  end,
  setup = function() end,
  teardown = function() end,

  find = function(test_name)
    for _,case in ipairs(_testcaseclasses) do
      if case.__name__ == test_name then
        return case
      end
    end
  end
}

function TestCase:info(message)
  if message and self.verbose then
    table.insert(self.messages, WHITE .. 'info: ' .. message .. WHITE)
  end
end

function TestCase:warning(message)
  self.warnings = self.warnings + 1
  if message then
    table.insert(self.messages, YELLOW .. 'warning: ' .. message .. WHITE)
  end
end

function TestCase:fail(message)
  self.success = false
  if message then
    table.insert(self.messages, RED .. 'error: ' .. message .. WHITE)
  end
end

function TestCase:assert(cond, message)
  if cond then return end
  self:fail(message)
end

function TestCase:assert_false(cond, message)
  if not cond then return end
  self:fail(message)
end

function TestCase:assert_equal(actual, expected, message)
  if I.equatable.equals(actual, expected) then return end
  self:fail('Actual:   ' .. I.displayable.dump(actual))
  self:fail('Expected: ' .. I.displayable.dump(expected))
  self:fail(message)
end

function TestCase:assert_not_equal(actual, expected, message)
  if not I.equatable.equals(actual, expected) then return end
  self:fail(message)
end

function TestCase:expect_failure(func, message)
  if pcall(func) then
    self:fail(message)
  end
end

function TestCase:print_results(testname)
  local color = self.success and (self.warnings > 0 and YELLOW or GREEN) or RED
  if not self.verbose and color == GREEN then
    return
  end
  local result = self.success and 'passed' or 'failed'
  if self.success and self.warnings > 0 then result = result .. ' with ' .. self.warnings .. ' warning(s)' end
  print(color .. 'Test \'' .. testname .. '\' ' .. result .. WHITE)
  for _,msg in ipairs(self.messages) do
    print('  ' .. msg)
  end
end

TestCase.args_test = class {
  __init__ = function(self, data)
    self.call = data.call
    self.argsset = data.argsset
  end
}
TestCase.args_test.__class_call__ = TestCase.args_test.new

function TestCase:run_test(testname, func, ...)
  local instance = self:new()
  instance:setup()

  if self.fail_on_assert then
    func(instance, ...)
  else
    local res, error = pcall(func, instance, ...)
    if not res then
      instance:fail(error)
    end
  end
  instance:teardown()
  instance:print_results(testname)
  return instance.success, instance.warnings
end

function TestCase:run()
  print(WHITE .. '-------------------------------------------------------')
  print('-- TestCase \'' .. self.__name__ .. '\'')
  print('-------------------------------------------------------')
  local all = 0
  local passed = 0
  local warnings = 0
  local function run_test(testname, test, ...)
    local success, warns = self:run_test(testname, test, ...)
    all = all + 1
    warnings = warnings + warns
    if success then passed = passed + 1 end
  end

  for testname, func in fn.filter(function(name) return name:find('^test_') end, self) do
    if type(func) == 'function' then
      run_test(testname, func)
    end
    if types.isinstance(func, TestCase.args_test) then
      for _,arg in ipairs(func.argsset) do
        run_test(testname .. ' ' .. I.displayable.dump(arg), func.call, unpack(arg))
      end
    end
  end
  print((passed == all) and (warnings > 0 and YELLOW or GREEN) or RED)
  print('-------------------------------------------------------')
  print('-- Summary: ' .. passed .. ' out of ' .. all .. ' tests passed with ' .. warnings .. ' warning(s)')
  print('-------------------------------------------------------')
  print(WHITE)

  return all, passed, warnings
end

function TestCase.run_all_tests()
  local cases = 0
  local passedcases = 0

  local tests = 0
  local passed = 0
  local warnings = 0

  for _, case in pairs(_testcaseclasses) do
    local _tests, _passed, warns = case:run()
    cases = cases + 1
    if _tests == _passed then passedcases = passedcases + 1 end
    tests = tests + _tests
    passed = passed + _passed
    warnings = warnings + warns
  end

  print((passed == tests) and (warnings > 0 and YELLOW or GREEN) or RED)
  print('-------------------------------------------------------')
  print('-- Overall summary:')
  print('-- ' .. passedcases .. ' (' .. passed .. ') out of ' .. cases .. ' (' .. tests .. ') tests passed with ' .. warnings .. ' warning(s)')
  print('-------------------------------------------------------')
  print(WHITE)
end

return TestCase
