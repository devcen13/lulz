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
  self.base = class 'vec2' {
    __init__ = function(this, x, y)
      rawset(this, 'x', x)
      rawset(this, 'y', y)
    end,

    __class_call__ = function(cls, ...) return cls:new(...) end,

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

    __newindex = function() error('invalid attribute') end,
    __index = function() error('invalid attribute') end
  }
end

function TestMeta:test_class_call()
  local inst = self.base(2, 3)
  self:assert_equal(inst, { x = 2, y = 3 })
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

function TestMeta:test_newindex()
  local inst = self.base:new(2, 3)
  inst.x = 0
  self:assert_equal(inst.x, 0)
  self:expect_failure(function() inst.z = 0 end)
end

function TestMeta:test_index()
  local inst = self.base:new(2, 3)
  local x = inst.x
  self:assert_equal(x, inst.x)
  self:expect_failure(function() local _ = inst.z end)
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

function TestInheritance:test_abstract_class_is_abstract()
  self.base.x = class.abstract_property()
  self:assert(class.is_abstract(self.base))
end

function TestInheritance:test_abstract_class_cannot_be_instanced()
  self.base.x = class.abstract_property()
  self:expect_failure(function() self.base:new() end)
end

function TestInheritance:test_overriding_abstract_property_with_method_fails()
  self.base.x = class.abstract_property()
  self:expect_failure(function() self.base.x = function() end end)
end

function TestInheritance:test_overriding_abstract_method_with_property_fails()
  self.base.x = class.abstract_method()
  self:expect_failure(function() self.base.x = class.property { get = 5 } end)
end

function TestInheritance:test_implementing_abstract_method_creates_valid_class()
  self.base.x = class.abstract_method()
  local derived = self.base:inherit {
    x = function() return 'x' end
  }
  local inst = derived:new()
  self:expect_failure(function() self.base:new() end)
  self:assert_equal(inst.x(), 'x')
end

function TestInheritance:test_implementing_abstract_property_creates_valid_class()
  self.base.x = class.abstract_property()
  local derived = self.base:inherit {
    x = class.property {
      get = function() return 'x' end
    }
  }
  local inst = derived:new()
  self:expect_failure(function() self.base:new() end)
  self:assert_equal(inst.x, 'x')
end

function TestInheritance:test_class_is_base_of_self()
  self:assert(class.is_base_of(self.base, self.base))
end

function TestInheritance:test_class_is_base_of_derived()
  local derived = self.base:inherit {}
  self:assert(class.is_base_of(self.base, derived))
end

function TestInheritance:test_instance_is_instance_of_self_type()
  self:assert(class.is_base_of(self.base:new(), self.base))
end

function TestInheritance:test_instance_is_instance_of_self_type()
  self:assert(class.is_instance(self.base:new(), self.base))
end

function TestInheritance:test_derived_instance_is_instance_of_self_type()
  local derived = self.base:inherit {}
  self:assert(class.is_instance(derived:new(), derived))
end

function TestInheritance:test_derived_instance_is_instance_of_base_type()
  local derived = self.base:inherit {}
  self:assert(class.is_instance(derived:new(), self.base))
end


local TestMixin = TestCase:inherit 'Class Mixin'

function TestMixin:setup()
  self.base = class {
    __init__ = function(inst, x, y)
      inst.value = { x, y }
    end,
    sum = function(inst, oth)
      inst.value[1] = inst.value[1] + oth[1]
      inst.value[2] = inst.value[2] + oth[2]
    end
  }
  self.operators = class {
    sum = class.abstract_method(),
    mul = class.abstract_method()
  }
  self.length = class {
    len = function(inst)
      return math.sqrt(inst.value[1] ^ 2 + inst.value[2] ^ 2)
    end,
  }
  self.length.length = class.property {
    get = self.length.len
  }
end

function TestMixin:test_is_mixin_instance()
  local derived = self.base:inherit { __mixin__ = { self.length } }
  self:assert(class.is_instance(derived:new(), self.length))
end

function TestMixin:test_mixin_methods_can_be_called()
  local derived = self.base:inherit { __mixin__ = { self.length } }
  self:assert_equal(derived:new(4, 3):len(), 5)
end

function TestMixin:test_mixin_properties_are_available()
  local derived = self.base:inherit { __mixin__ = { self.length } }
  self:assert_equal(derived:new(4, 3).length, 5)
end

function TestMixin:test_abstract_mixin_must_be_implemented()
  local derived = self.base:inherit { __mixin__ = { self.operators } }
  self:expect_failure(function() derived:new() end)
end

function TestMixin:test_abstract_mixin_can_be_implemented()
  local derived = self.base:inherit {
    __mixin__ = { self.operators, self.length },

    mul = function(inst, k)
      inst.value[1] = inst.value[1] * k
      inst.value[2] = inst.value[2] * k
    end
  }

  local vec = derived:new(2, 1.5)
  vec:mul(2)
  self:assert_equal(vec.length, 5)
end

function TestMixin:test_mixin_statics_are_available()
  local derived = self.base:inherit {
    __mixin__ = {
      class { static_var = 5 }
    }
  }
  
  self:assert_equal(derived:new().static_var, 5)
end
