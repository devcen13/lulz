local types = require 'lulz.types'
local struct = require 'lulz.types.struct'
local interface = require 'lulz.types.interface'

local TestCase = require 'lulz.testcase'


local TestInterface = TestCase:inherit 'Interface'


function TestInterface:test_interface_table_is_a_type()
  self:assert(types.istype(interface))
end

function TestInterface:test_interface_can_be_created_with_name()
  local foo = interface:new 'Foo'
  self:assert(interface.isinterface(foo))
end

function TestInterface:test_interface_is_type()
  local foo = interface:new 'Foo'
  self:assert(types.istype(foo))
end

function TestInterface:test_named_interface_has_name()
  local foo = interface:new 'Foo'
  self:assert_equal(foo.__name__, 'Foo')
end

function TestInterface:test_interface_can_be_created_with_default_impl()
  local foo = interface:new {
    bar = function() return 'bar' end
  }
  self:assert(interface.isinterface(foo))
end

function TestInterface:test_interface_can_be_created_with_name_and_impl()
  local foo = interface:new {
    __name__ = 'Foo';
    bar = function() return 'bar' end
  }
  self:assert_equal(foo.__name__, 'Foo')
end

function TestInterface:test_interface_can_be_default_implemented()
  local foo = interface:new {
    bar = function() return 'bar' end
  }
  local baz = struct:new {}
  foo:impl(baz)
end

function TestInterface:test_interface_method_can_be_called_if_implemented()
  local foo = interface:new {
    bar = function() return 'bar' end
  }
  local baz = struct:new {}
  foo:impl(baz)
  local obj = baz:new()
  self:assert_equal(obj:bar(), 'bar')
end

function TestInterface:test_interface_default_method_can_use_self_data()
  local foo = interface:new {
    bar = function(this) return this.__name__ end
  }
  local baz = struct:new 'baz'
  foo:impl(baz)
  local obj = baz:new()
  self:assert_equal(obj:bar(), 'baz')
end

function TestInterface:test_interface_method_can_be_reimplemented()
  local foo = interface:new {
    bar = function() return 'bar' end
  }
  local baz = struct:new 'baz'
  foo:impl(baz, {
    bar = function(this) return this.__name__ end
  })
  local obj = baz:new()
  self:assert_equal(obj:bar(), 'baz')
end

function TestInterface:test_interface_method_can_be_required_to_be_implemented()
  local foo = interface:new {
    bar = interface.impl_required
  }
  local baz = struct:new 'baz'
  self:expect_failure(foo.impl, foo, baz)
end

function TestInterface:test_interface_required_method_can_be_implemented()
  local foo = interface:new {
    bar = interface.impl_required
  }
  local baz = struct:new 'baz'
  foo:impl(baz, {
    bar = function(this) return this.__name__ end
  })
  local obj = baz:new()
  self:assert_equal(obj:bar(), 'baz')
end

function TestInterface:test_interface_can_be_partitially_reimplemented()
  local foo = interface:new {
    bar = function() return 'bar' end;
    baz = function() return '' end;
    print = function(self) return self:bar() .. self:baz() end
  }
  local baz = struct:new 'baz'
  foo:impl(baz, {
    baz = function(this) return this.__name__ end
  })
  local obj = baz:new()
  self:assert_equal(obj:print(), 'barbaz')
end

function TestInterface:test_interface_implementation_can_be_checked_for_type()
  local foo = interface:new {}
  local tp = struct:new 'tp'
  foo:impl(tp)
  self:assert(foo:isimplemented(tp))
end

function TestInterface:test_inherited_type_implements_base_interface()
  local foo = interface:new {}
  local base = struct:new 'base'
  foo:impl(base)
  local tp = base:inherit {}
  self:assert(foo:isimplemented(tp))
end

function TestInterface:test_interface_can_be_implementated_after_type_is_inherited()
  local foo = interface:new {}
  local base = struct:new 'base'
  local tp = base:inherit {}
  foo:impl(base)
  self:assert(foo:isimplemented(tp))
end

function TestInterface:test_instance_of_implementating_interface_type_is_instance_of_interface()
  local foo = interface:new {}
  local tp = struct:new 'tp'
  foo:impl(tp)
  local obj = tp:new()
  self:assert(types.isinstance(obj, foo))
end
