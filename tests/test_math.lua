local class = require 'lulz.class'
local lmath = require 'lulz.math'
local TestCase = require 'lulz.testcase'

local vec2 = lmath.vec2


local TestVec2 = TestCase:inherit 'Test vec2'

function TestVec2:test_vec2_numbers_construct()
  local vec = vec2:new(1, 0)
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
end

function TestVec2:test_vec2_table_construct()
  local vec = vec2:new { 1, 0 }
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
end

function TestVec2:test_vec2_table_call_construct()
  local vec = vec2 { 1, 0 }
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
end

function TestVec2:test_vec2_named_table_construct()
  local vec = vec2:new { x = 1, y = 0 }
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
end

function TestVec2:test_vec2_named_table_call_construct()
  local vec = vec2 { x = 1, y = 0 }
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
end

function TestVec2:test_vec2_vec2_construct()
  local vec = vec2 { 1, 0 }
  local vec_copy = vec2:new(vec)
  self:assert_equal(vec_copy.x, 1)
  self:assert_equal(vec_copy.y, 0)
end

function TestVec2:test_vec2_x_get()
  local vec = vec2 { 1, 0 }
  self:assert_equal(vec.x, 1)
end

function TestVec2:test_vec2_y_get()
  local vec = vec2 { 1, 0 }
  self:assert_equal(vec.y, 0)
end

function TestVec2:test_vec2_xy_get()
  local vec = vec2 { 1, 0 }
  self:assert(class.is_instance(vec.xy, vec2))
  self:assert_equal(vec.xy.x, 1)
  self:assert_equal(vec.xy.y, 0)
end

function TestVec2:test_vec2_x_set()
  local vec = vec2 { 1, 0 }
  vec.x = 4
  self:assert_equal(vec.x, 4)
  self:assert_equal(vec.y, 0)
end

function TestVec2:test_vec2_y_set()
  local vec = vec2 { 1, 0 }
  vec.y = 2
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 2)
end

function TestVec2:test_vec2_xy_set_by_vec2()
  local vec = vec2 { 1, 0 }
  vec.xy = vec2 { 2, 3 }
  self:assert_equal(vec.xy.x, 2)
  self:assert_equal(vec.xy.y, 3)
end

function TestVec2:test_vec2_xy_set_by_table()
  local vec = vec2 { 1, 0 }
  vec.xy = { 2, 3 }
  self:assert_equal(vec.xy.x, 2)
  self:assert_equal(vec.xy.y, 3)
end

function TestVec2:test_vec2_xy_set_by_named_table()
  local vec = vec2 { 1, 0 }
  vec.xy = { x = 2, y = 3 }
  self:assert_equal(vec.xy.x, 2)
  self:assert_equal(vec.xy.y, 3)
end

function TestVec2:test_vec2_indexed_get()
  local vec = vec2 { 1, 0 }
  self:assert_equal(vec[1], 1)
  self:assert_equal(vec[2], 0)
end

function TestVec2:test_vec2_indexed_set()
  local vec = vec2 { 1, 0 }
  vec[1] = 2
  vec[2] = 3
  self:assert_equal(vec[1], 2)
  self:assert_equal(vec[2], 3)
end

TestVec2.test_vec2_str = TestCase.args_test {
  call = function(self, data, str)
    self:assert_equal(tostring(vec2:new(data)), str)
  end,
  argsset = {
    { { 5, 4 }, 'vec2 { 5, 4 }' },
    { { 5.2, 4 }, 'vec2 { 5.2, 4 }' }
  }
}

TestVec2.test_vec2_len = TestCase.args_test {
  call = function(self, data, len)
    local vec = vec2:new(data)
    self:assert_equal(vec.len, len)
  end,
  argsset = {
    { { 2, 0 }, 2 },
    { { 0, 2 }, 2 },
    { { 2, 2 }, 2 * math.sqrt(2) },
  }
}

TestVec2.test_vec2_dot2 = TestCase.args_test {
  call = function(self, v1, v2, dot2)
    v1 = vec2:new(v1)
    v2 = vec2:new(v2)
    self:assert_equal(v1:dot2(v2), dot2)
  end,
  argsset = {
    { { 1, 0 }, { 0, 1 }, 0 },
    { { 1, 0 }, { 1, 0 }, 1 },
    { { 1, 1 }, { 1, 1 }, 2 },
  }
}

TestVec2.test_vec2_dot = TestCase.args_test {
  call = function(self, v1, v2, dot)
    v1 = vec2:new(v1)
    v2 = vec2:new(v2)
    self:assert_equal(v1:dot(v2), dot)
  end,
  argsset = {
    { { 1, 0 }, { 0, 1 }, 0 },
    { { 1, 0 }, { 1, 0 }, 1 },
    { { 1, 1 }, { 1, 1 }, math.sqrt(2) },
  }
}

TestVec2.test_vec2_unm = TestCase.args_test {
  call = function(self, v1, res)
    v1 = vec2:new(v1)
    self:assert_equal(-v1, vec2:new(res))
  end,
  argsset = {
    { { 1, 0 }, { -1,  0 } },
    { { 1, 1 }, { -1, -1 } },
  }
}

TestVec2.test_vec2_sum = TestCase.args_test {
  call = function(self, v1, v2, res)
    v1 = vec2:new(v1)
    v2 = vec2:new(v2)
    self:assert_equal(v1 + v2, vec2:new(res))
  end,
  argsset = {
    { { 1, 0 }, { 0, 1 }, { 1, 1 } },
    { { 1, 1 }, { 1, 1 }, { 2, 2 } },
  }
}

TestVec2.test_vec2_sub = TestCase.args_test {
  call = function(self, v1, v2, res)
    v1 = vec2:new(v1)
    v2 = vec2:new(v2)
    self:assert_equal(v1 - v2, vec2:new(res))
  end,
  argsset = {
    { { 1, 0 }, { 0, 1 }, { 1, -1 } },
    { { 1, 1 }, { 1, 1 }, { 0, 0 } },
  }
}

TestVec2.test_vec2_mul = TestCase.args_test {
  call = function(self, v, k, res)
    self:assert_equal(vec2:new(v) * k, vec2:new(res))
    self:assert_equal(k * vec2:new(v), vec2:new(res))
  end,
  argsset = {
    { { 1, 0 }, 0, { 0, 0 } },
    { { 1, 0 }, 1, { 1, 0 } },
  }
}

TestVec2.test_vec2_div = TestCase.args_test {
  call = function(self, v, k, res)
    self:assert_equal(vec2:new(v) / k, vec2:new(res))
  end,
  argsset = {
    { { 1, 0 }, 1, { 1, 0 } },
    { { 4, 2 }, 2, { 2, 1 } },
  }
}

TestVec2.test_vec2_eq = TestCase.args_test {
  call = function(self, v1, v2)
    self:assert_equal(vec2:new(v1), vec2:new(v2))
  end,
  argsset = {
    { { 1, 0 }, { 1, 0 } },
    { { 4, 2 }, { 4, 2 } },
  }
}

TestVec2.test_vec2_ne = TestCase.args_test {
  call = function(self, v1, v2)
    self:assert_not_equal(vec2:new(v1), vec2:new(v2))
  end,
  argsset = {
    { { 1, 0 }, { 0, 1 } },
    { { 4, 2 }, { 4, 3 } },
  }
}
