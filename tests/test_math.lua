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

function TestVec2:test_vec2_str()
  self:assert_equal(tostring(vec2 { 5.2, 4 }), 'vec2 { 5.2, 4 }')
end

function TestVec2:test_vec2_len()
  local vec = vec2 { 1, 0 }
  self:assert_equal(vec.len, 1)
  vec = vec2 { 1, 1 }
  self:assert_equal(vec.len, math.sqrt(2))
end
