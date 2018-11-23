local types = require 'lulz.types'
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
  self:assert(types.isinstance(vec.xy, vec2))
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


local vec3 = lmath.vec3


local TestVec3 = TestCase:inherit 'Test vec3'

function TestVec3:test_vec3_numbers_construct()
  local vec = vec3:new(1, 0, -1)
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
  self:assert_equal(vec.z, -1)
end

function TestVec3:test_vec3_table_construct()
  local vec = vec3:new { 1, 0, -1 }
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
  self:assert_equal(vec.z, -1)
end

function TestVec3:test_vec3_table_call_construct()
  local vec = vec3 { 1, 0, -1 }
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
  self:assert_equal(vec.z, -1)
end

function TestVec3:test_vec3_named_table_construct()
  local vec = vec3:new { x = 1, y = 0, z = -1 }
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
  self:assert_equal(vec.z, -1)
end

function TestVec3:test_vec3_named_table_call_construct()
  local vec = vec3 { x = 1, y = 0, z = -1 }
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
  self:assert_equal(vec.z, -1)
end

function TestVec3:test_vec3_vec3_construct()
  local vec = vec3 { 1, 0, -1 }
  local vec_copy = vec3:new(vec)
  self:assert_equal(vec_copy.x, 1)
  self:assert_equal(vec_copy.y, 0)
  self:assert_equal(vec_copy.z, -1)
end

function TestVec3:test_vec3_x_get()
  local vec = vec3 { 1, 0, -1 }
  self:assert_equal(vec.x, 1)
end

function TestVec3:test_vec3_y_get()
  local vec = vec3 { 1, 0, -1 }
  self:assert_equal(vec.y, 0)
end

function TestVec3:test_vec3_z_get()
  local vec = vec3 { 1, 0, -1 }
  self:assert_equal(vec.z, -1)
end

function TestVec3:test_vec3_xy_get()
  local vec = vec3 { 1, 0, -1 }
  self:assert(types.isinstance(vec.xy, vec2))
  self:assert_equal(vec.xy.x, 1)
  self:assert_equal(vec.xy.y, 0)
end

function TestVec3:test_vec3_yz_get()
  local vec = vec3 { 1, 0, -1 }
  self:assert(types.isinstance(vec.yz, vec2))
  self:assert_equal(vec.yz.x, 0)
  self:assert_equal(vec.yz.y, -1)
end

function TestVec3:test_vec3_xz_get()
  local vec = vec3 { 1, 0, -1 }
  self:assert(types.isinstance(vec.xz, vec2))
  self:assert_equal(vec.xz.x, 1)
  self:assert_equal(vec.xz.y, -1)
end

function TestVec3:test_vec3_x_set()
  local vec = vec3 { 1, 0, -1 }
  vec.x = 4
  self:assert_equal(vec.x, 4)
  self:assert_equal(vec.y, 0)
  self:assert_equal(vec.z, -1)
end

function TestVec3:test_vec3_y_set()
  local vec = vec3 { 1, 0, -1 }
  vec.y = 2
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 2)
  self:assert_equal(vec.z, -1)
end

function TestVec3:test_vec3_z_set()
  local vec = vec3 { 1, 0, -1 }
  vec.z = 2
  self:assert_equal(vec.x, 1)
  self:assert_equal(vec.y, 0)
  self:assert_equal(vec.z, 2)
end

function TestVec3:test_vec3_xy_set_by_vec2()
  local vec = vec3 { 1, 0, -1 }
  vec.xy = vec2 { 2, 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.y, 3)
end

function TestVec3:test_vec3_xy_set_by_table()
  local vec = vec3 { 1, 0, -1 }
  vec.xy = { 2, 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.y, 3)
end

function TestVec3:test_vec3_xy_set_by_named_table()
  local vec = vec3 { 1, 0, -1 }
  vec.xy = { x = 2, y = 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.y, 3)
end

function TestVec3:test_vec3_yz_set_by_vec2()
  local vec = vec3 { 1, 0, -1 }
  vec.yz = vec2 { 2, 3 }
  self:assert_equal(vec.y, 2)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_yz_set_by_table()
  local vec = vec3 { 1, 0, -1 }
  vec.yz = { 2, 3 }
  self:assert_equal(vec.y, 2)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_yz_set_by_named_table()
  local vec = vec3 { 1, 0, -1 }
  vec.yz = { x = 2, y = 3 }
  self:assert_equal(vec.y, 2)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_xz_set_by_vec2()
  local vec = vec3 { 1, 0, -1 }
  vec.xz = vec2 { 2, 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_xz_set_by_table()
  local vec = vec3 { 1, 0, -1 }
  vec.xz = { 2, 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_xz_set_by_named_table()
  local vec = vec3 { 1, 0, -1 }
  vec.xz = { x = 2, y = 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_xyz_set_by_vec3()
  local vec = vec3 { 1, 0, -1 }
  vec.xyz = vec3 { 2, 1, 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.y, 1)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_xyz_set_by_table()
  local vec = vec3 { 1, 0, -1 }
  vec.xyz = { 2, 1, 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.y, 1)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_xyz_set_by_named_table()
  local vec = vec3 { 1, 0, -1 }
  vec.xyz = { x = 2, y = 1, z = 3 }
  self:assert_equal(vec.x, 2)
  self:assert_equal(vec.y, 1)
  self:assert_equal(vec.z, 3)
end

function TestVec3:test_vec3_indexed_get()
  local vec = vec3 { 1, 0, -1 }
  self:assert_equal(vec[1], 1)
  self:assert_equal(vec[2], 0)
  self:assert_equal(vec[3], -1)
end

function TestVec3:test_vec3_indexed_set()
  local vec = vec3 { 1, 0, -1 }
  vec[1] = 2
  vec[2] = 3
  vec[3] = 4
  self:assert_equal(vec[1], 2)
  self:assert_equal(vec[2], 3)
  self:assert_equal(vec[3], 4)
end

TestVec3.test_vec3_str = TestCase.args_test {
  call = function(self, data, str)
    self:assert_equal(tostring(vec3:new(data)), str)
  end,
  argsset = {
    { { 5, 4, 1 }, 'vec3 { 5, 4, 1 }' },
    { { 5.2, 4, 0.2 }, 'vec3 { 5.2, 4, 0.2 }' }
  }
}

TestVec3.test_vec3_len = TestCase.args_test {
  call = function(self, data, len)
    local vec = vec3:new(data)
    self:assert_equal(vec.len, len)
  end,
  argsset = {
    { { 2, 0, 0 }, 2 },
    { { 0, 2, 0 }, 2 },
    { { 0, 0, 2 }, 2 },
    { { 2, 2, 2 }, 2 * math.sqrt(3) },
  }
}

TestVec3.test_vec3_dot2 = TestCase.args_test {
  call = function(self, v1, v2, dot2)
    v1 = vec3:new(v1)
    v2 = vec3:new(v2)
    self:assert_equal(v1:dot2(v2), dot2)
  end,
  argsset = {
    { { 1, 0, 0 }, { 0, 1, 0 }, 0 },
    { { 1, 0, 0 }, { 1, 0, 0 }, 1 },
    { { 1, 1, 0 }, { 1, 1, 0 }, 2 },
  }
}

TestVec3.test_vec3_dot = TestCase.args_test {
  call = function(self, v1, v2, dot)
    v1 = vec3:new(v1)
    v2 = vec3:new(v2)
    self:assert_equal(v1:dot(v2), dot)
  end,
  argsset = {
    { { 1, 0, 0 }, { 0, 1, 0 }, 0 },
    { { 1, 0, 0 }, { 1, 0, 0 }, 1 },
    { { 1, 1, 0 }, { 1, 1, 0 }, math.sqrt(2) },
  }
}

TestVec3.test_vec3_unm = TestCase.args_test {
  call = function(self, v1, res)
    v1 = vec3:new(v1)
    self:assert_equal(-v1, vec3:new(res))
  end,
  argsset = {
    { { 1, 0, 1 }, { -1,  0, -1 } },
    { { 1, 1, 1 }, { -1, -1, -1 } },
  }
}

TestVec3.test_vec3_sum = TestCase.args_test {
  call = function(self, v1, v2, res)
    v1 = vec3:new(v1)
    v2 = vec3:new(v2)
    self:assert_equal(v1 + v2, vec3:new(res))
  end,
  argsset = {
    { { 1, 0, 0 }, { 0, 1, 0 }, { 1, 1, 0 } },
    { { 1, 1, 2 }, { 1, 1, 1 }, { 2, 2, 3 } },
  }
}

TestVec3.test_vec3_sub = TestCase.args_test {
  call = function(self, v1, v2, res)
    v1 = vec3:new(v1)
    v2 = vec3:new(v2)
    self:assert_equal(v1 - v2, vec3:new(res))
  end,
  argsset = {
    { { 1, 0, 0 }, { 0, 1, 1 }, { 1, -1, -1 } },
    { { 1, 1, 0 }, { 1, 1, 1 }, { 0, 0, -1 } },
  }
}

TestVec3.test_vec3_mul = TestCase.args_test {
  call = function(self, v, k, res)
    self:assert_equal(vec3:new(v) * k, vec3:new(res))
    self:assert_equal(k * vec3:new(v), vec3:new(res))
  end,
  argsset = {
    { { 1, 0, 1 }, 0, { 0, 0, 0 } },
    { { 1, 0, 1 }, 1, { 1, 0, 1 } },
  }
}

TestVec3.test_vec3_div = TestCase.args_test {
  call = function(self, v, k, res)
    self:assert_equal(vec3:new(v) / k, vec3:new(res))
  end,
  argsset = {
    { { 1, 0, 1 }, 1, { 1, 0, 1 } },
    { { 4, 2, 2 }, 2, { 2, 1, 1 } },
  }
}

TestVec3.test_vec3_eq = TestCase.args_test {
  call = function(self, v1, v2)
    self:assert_equal(vec3:new(v1), vec3:new(v2))
  end,
  argsset = {
    { { 1, 0, 0 }, { 1, 0, 0 } },
    { { 4, 2, 0 }, { 4, 2, 0 } },
    { { 4, 2, 3 }, { 4, 2, 3 } },
  }
}

TestVec3.test_vec3_ne = TestCase.args_test {
  call = function(self, v1, v2)
    self:assert_not_equal(vec3:new(v1), vec3:new(v2))
  end,
  argsset = {
    { { 1, 0, 0 }, { 0, 1, 0 } },
    { { 4, 2, 0 }, { 4, 3, 0 } },
    { { 0, 0, 1 }, { 0, 0, 0 } },
  }
}
