local set = require 'lulz.collections.set'
local list = require 'lulz.collections.list'
local iterator = require 'lulz.iterator'
local TestCase = require 'lulz.testcase'

local TestSet = TestCase:inherit 'Set'


TestSet.test_set_construct = TestCase.args_test {
  call = function(self, elems, constructed)
    local s = set(elems)
    local items = list:new(s)
    items:sort()
    self:assert_equal(items, list(constructed))
  end,
  argsset = {
    { {}, {} },
    { { 1, 2 }, { 1, 2 } },
    { { 3, 2, 3 }, { 2, 3 } },
  }
}

TestSet.test_set_add = TestCase.args_test {
  call = function(self, elems, constructed)
    local s = set()
    for elem in iterator.values(elems) do
      s:add(elem)
    end
    self:assert_equal(s, set(constructed))
  end,
  argsset = {
    { {}, {} },
    { { 1, 2 }, { 1, 2 } },
    { { 3, 2, 3 }, { 2, 3 } },
  }
}

function TestSet:test_remove()
  local s = set { 1, 2, 3 }
  s:remove(1)
  self:assert_equal(s, set { 2, 3 })
end

TestSet.test_set_equal = TestCase.args_test {
  call = function(self, elems1, elems2, eq)
    local s1 = set(elems1)
    local s2 = set(elems2)
    self:assert_equal(s1 == s2, eq)
  end,
  argsset = {
    { {}, {}, true },
    { {}, { 1 }, false },
    { { 1, 2 }, { 1, 2 }, true },
    { { 3, 2, 3 }, { 2, 3 }, true },
    { { 1, 2, 3 }, { 2, 3 }, false },
    { { 1, 2, 3 }, { 2, 3, 4 }, false },
  }
}

TestSet.test_set_isdisjoint = TestCase.args_test {
  call = function(self, elems1, elems2, res)
    local s1 = set(elems1)
    local s2 = set(elems2)
    self:assert_equal(s1:isdisjoint(s2), res)
  end,
  argsset = {
    { {}, {}, true },
    { {}, { 1 }, true },
    { { 1 }, {}, true },
    { { 1 }, { 1, 2 }, false },
    { { 3, 2, 3 }, { 2, 3 }, false },
    { { 1, 2, 3 }, { 2, 3, 4 }, false },
  }
}

TestSet.test_set_subset = TestCase.args_test {
  call = function(self, elems1, elems2, res)
    local s1 = set(elems1)
    local s2 = set(elems2)
    self:assert_equal(s1 <= s2, res)
  end,
  argsset = {
    { {}, {}, true },
    { {}, { 1 }, true },
    { { 1, 2 }, { 1, 2 }, true },
    { { 3, 2, 3 }, { 2, 3 }, true },
    { { 1, 2, 3 }, { 1, 2, 3, 4 }, true },
    { { 1, 2, 3, 4 }, { 1, 2, 3 }, false },
    { { 1, 2, 3 }, { 2, 3, 4 }, false },
  }
}

TestSet.test_set_superset = TestCase.args_test {
  call = function(self, elems1, elems2, res)
    local s1 = set(elems1)
    local s2 = set(elems2)
    self:assert_equal(s1 >= s2, res)
  end,
  argsset = {
    { {}, {}, true },
    { {}, { 1 }, false },
    { { 1 }, {}, true },
    { { 1, 2 }, { 1, 2 }, true },
    { { 3, 2, 3 }, { 2, 3 }, true },
    { { 1, 2, 3 }, { 1, 2, 3, 4 }, false },
    { { 1, 2, 3, 4 }, { 1, 2, 3 }, true },
    { { 1, 2, 3 }, { 2, 3, 4 }, false },
  }
}

TestSet.test_set_simple_sum = TestCase.args_test {
  call = function(self, elems1, elems2, res)
    self:assert_equal(set(elems1) + set(elems2), set(res))
  end,
  argsset = {
    { {}, {}, {} },
    { { 1 }, {}, { 1 } },
    { { 1 }, { 1 }, { 1 } },
    { { 1 }, { 2 }, { 1, 2 } },
    { { 1 }, { 1, 2 }, { 1, 2 } },
  }
}

TestSet.test_set_simple_difference = TestCase.args_test {
  call = function(self, elems1, elems2, res)
    self:assert_equal(set(elems1) - set(elems2), set(res))
  end,
  argsset = {
    { {}, {}, {} },
    { { 1 }, {}, { 1 } },
    { { 1 }, { 1 }, {} },
    { { 1 }, { 2 }, { 1 } },
    { { 1 }, { 1, 2 }, {} },
  }
}

TestSet.test_set_simple_intersect = TestCase.args_test {
  call = function(self, elems1, elems2, res)
    self:assert_equal(set(elems1) * set(elems2), set(res))
  end,
  argsset = {
    { {}, {}, {} },
    { { 1 }, {}, {} },
    { { 1 }, { 1 }, { 1 } },
    { { 1 }, { 2 }, {} },
    { { 1 }, { 1, 2 }, { 1 } },
  }
}

TestSet.test_set_simple_symmetric_difference = TestCase.args_test {
  call = function(self, elems1, elems2, res)
    self:assert_equal(set(elems1) ^ set(elems2), set(res))
  end,
  argsset = {
    { {}, {}, {} },
    { { 1 }, {}, { 1 } },
    { { 1 }, { 1 }, {} },
    { { 1 }, { 2 }, { 1, 2 } },
    { { 1 }, { 1, 2 }, { 2 } },
  }
}

TestSet.test_set_multiple_sum = TestCase.args_test {
  call = function(self, elems1, elems2, elems3, res)
    self:assert_equal(set(elems1):union(set(elems2), set(elems3)), set(res))
  end,
  argsset = {
    { {}, {}, {}, {} },
    { { 1 }, {}, { 2 }, { 1, 2 } },
    { { 1 }, { 1 }, { 1 }, { 1 } },
    { { 1 }, { 2 }, { 1, 2 }, { 1, 2 } },
    { { 1 }, { 1, 2 }, { 3 }, { 1, 2, 3 } },
  }
}

TestSet.test_set_multiple_difference = TestCase.args_test {
  call = function(self, elems1, elems2, elems3, res)
    self:assert_equal(set(elems1):difference(set(elems2), set(elems3)), set(res))
  end,
  argsset = {
    { {}, {}, {} },
    { { 1 }, {}, {}, { 1 } },
    { { 1 }, { 1 }, {}, {} },
    { { 1 }, {}, { 1 }, {} },
    { { 1 }, { 1 }, { 1 }, {} },
    { { 1 }, { 2 }, { 3 }, { 1 } },
    { { 1 }, { 1, 2 }, { 1, 3 }, {} },
  }
}

TestSet.test_set_multiple_intersect = TestCase.args_test {
  call = function(self, elems1, elems2, elems3, res)
    self:assert_equal(set(elems1):intersection(set(elems2), set(elems3)), set(res))
  end,
  argsset = {
    { {}, {}, {} },
    { { 1 }, {}, {}, {} },
    { { 1 }, { 1 }, {}, {} },
    { { 1 }, {}, { 1 }, {} },
    { { 1 }, { 1 }, { 1 }, { 1 } },
    { { 1 }, { 2 }, { 3 }, {} },
    { { 1 }, { 1, 2 }, { 1, 3 }, { 1 } },
  }
}

TestSet.test_set_multiple_symmetric_difference = TestCase.args_test {
  call = function(self, elems1, elems2, elems3, res)
    self:assert_equal(set(elems1):symmetric_difference(set(elems2), set(elems3)), set(res))
  end,
  argsset = {
    { {}, {}, {} },
    { { 1 }, {}, {}, { 1 } },
    { { 1 }, { 1 }, {}, {} },
    { { 1 }, {}, { 1 }, {} },
    { { 1 }, { 1 }, { 1 }, {} },
    { { 1 }, { 2 }, { 3 }, { 1, 2, 3 } },
    { { 1 }, { 1, 2 }, { 1, 3 }, { 2, 3 } },
  }
}
