local class = require 'lulz.class'
local TestCase = require 'lulz.tests.testcase'


local TestClass = TestCase:inherit 'Class'

function TestClass:setup()
  self.base = class {
    static_var = 0,
    __init__ = function(inst, value)
      inst.value = value
    end,
    get_value = function(inst) return inst.value end
  }
end

function TestClass:test_constructor_called()
  self.base.__init__ = function(inst) inst.called = true end
  local inst = self.base:new()
  self:assert(inst.called)
end

function TestClass:test_named_class()
  local cls = class 'Foo'
  self:assert_equal(cls.__name__, 'Foo')
end

function TestClass:test_named_class_constructor_called()
  local cls = class 'Foo' {
    __init__ = function(inst) inst.called = true end
  }
  local inst = cls:new()
  self:assert(inst.called)
  self:assert_equal(cls.__name__, 'Foo')
end

function TestClass:test_constructor_args()
  local inst = self.base:new(5)
  self:assert_equal(inst.value, 5)
end

function TestClass:test_self_var()
  local inst1 = self.base:new(5)
  local inst2 = self.base:new(42)
  self:assert(inst1.value ~= inst2.value)
end

function TestClass:test_static_var()
  self:assert(self.base.static_var == 0)
  local inst = self.base:new(nil)
  inst.static_var = 42
  self:assert(self.base.static_var == 42, 'Static var not changed')
  self:assert(inst.static_var == 42, 'Static var not accessable from instance')
end

function TestClass:test_method_call()
  local inst = self.base:new(5)
  self:assert(inst:get_value() == 5)
end

function TestClass:test_instance_function_override()
  local inst = self.base:new(5)
  inst.get_value = function() return 42 end
  self:assert(inst:get_value() == 42, 'Instance function not overrided')
  self:assert(self.base.get_value(inst) == 5, 'Instance overrides class function')
end

function TestClass:test_property()
  self.base.x = class.property {
    get = function(inst) return inst.value end,
    set = function(inst, value) inst.value = value end
  }
  local inst = self.base:new(5)
  self:assert(inst.x == 5, 'Property getter failed')
  inst.x = 42
  self:assert(inst.x == 42, 'Property setter failed')
end

function TestClass:test_readonly_property()
  self.base.x = class.property {
    get = function(inst) return inst.value end
  }
  local inst = self.base:new(5)
  self:assert(inst.x == 5, 'Property getter failed')
  local function set_property() inst.x = 42 end
  self:expect_failure(set_property, 'Readonly property must not be writable')
  self:assert(inst.x == 5, 'Readonly property value changed')
end


local TestMeta = TestCase:inherit 'Class Meta'

function TestMeta:setup()
  self.base = class {
    __init__ = function(this, x, y)
      this.x = x
      this.y = y
    end,

    __str__   = function(this) return '{ ' .. this.x .. ', ' .. this.y .. ' }' end,
    __len__   = function(this) return math.sqrt(this.x^2 + this.y^2) end,

    __unm__    = function(this) return this.__type__:new(-this.x, -this.y) end,
    __add__    = function(this, value) return this.__type__:new(this.x + value.x, this.y + value.y) end,
    __sub__    = function(this, value) return this.__type__:new(this.x - value.x, this.y - value.y) end,
    __mul__    = function(this, value) return this.__type__:new(this.x * value, this.y * value) end,
    __div__    = function(this, value) return this.__type__:new(this.x / value, this.y / value) end,
    __mod__    = function(this, value) return this.__type__:new(this.x % value, this.y % value) end,
    __pow__    = function(this, value) return this.__type__:new(this.x ^ value, this.y ^ value) end,
    __concat__ = function(this, value) return this + value end,

    __eq__   = function(this, value) return this.x == value.x and this.y == value.y end,
    __lt__   = function(this, value) return #this < #value end,
    __le__   = function(this, value) return #this <= #value end,
  }
end

function TestMeta:test_eq()
  local inst = self.base:new(2, 3)
  self:assert_equal(inst, { x = 2, y = 3, additional = 'any' })
end

function TestMeta:test_lt()
  local inst = self.base:new(2, 3)
  self:assert(inst < inst*2)
end

function TestMeta:test_le()
  local inst = self.base:new(2, 3)
  self:assert(inst <= inst)
end

function TestMeta:test_str()
  self:assert_equal(tostring(self.base:new(0, 1)), '{ 0, 1 }')
end

function TestMeta:test_add()
  self:assert_equal(self.base:new(2, 3) + self.base:new(2, 3), self.base:new(4, 6))
end

function TestMeta:test_concat()
  self:assert_equal(self.base:new(2, 3) .. self.base:new(2, 3), self.base:new(4, 6))
end

function TestMeta:test_sub()
  self:assert_equal(self.base:new(2, 3) - self.base:new(2, 2), self.base:new(0, 1))
end

function TestMeta:test_mul()
  self:assert_equal(self.base:new(2, 3) * 3, self.base:new(6, 9))
end

function TestMeta:test_div()
  self:assert_equal(self.base:new(6, 3) / 3, self.base:new(2, 1))
end


local TestInheritance = TestCase:inherit 'Class Inheritance'

function TestInheritance:setup()
  self.base = class {
    static_var = 0,
    __init__ = function(inst, value)
      inst.value = value
    end,
    get_value = function(inst) return inst.value end
  }
end

function TestInheritance:test_default_inherited_constructor()
  local derived = self.base:inherit()
  local inst = derived:new(5)
  self:assert_equal(inst.value, 5)
end

function TestInheritance:test_base_function_call()
  local derived = self.base:inherit()
  local inst = derived:new(5)
  self:assert_equal(inst:get_value(), 5)
end

function TestInheritance:test_inherited_function_override()
  local derived = self.base:inherit {
    get_value = function() return 42 end
  }
  local inst = derived:new(5)
  self:assert_equal(inst:get_value(), 42, 'Inherited function not overrided')
end
