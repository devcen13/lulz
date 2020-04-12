local lulz = require 'lulz'
local types = require 'lulz.types'
local sz = require 'lulz.serialize'

local TestCase = lulz.testcase


local TestSerializeTrivial = TestCase:inherit 'Serialize Trivial'


function TestSerializeTrivial:test_number_is_serializable()
  self:assert(types.isinstance(5, sz.serializable))
end

function TestSerializeTrivial:test_number_is_trivially_serializable()
  self:assert(types.number:trivially_serializable())
end

function TestSerializeTrivial:test_number_can_be_trivially_serialized()
  self:assert_equal(sz.serialize(42), 42)
end

function TestSerializeTrivial:test_number_can_be_trivially_deserialized()
  self:assert_equal(sz.deserialize(42), 42)
end


function TestSerializeTrivial:test_bool_is_serializable()
  self:assert(types.isinstance(false, sz.serializable))
end

function TestSerializeTrivial:test_bool_is_trivially_serializable()
  self:assert(types.bool:trivially_serializable())
end

function TestSerializeTrivial:test_bool_can_be_trivially_serialized()
  self:assert_equal(sz.serialize(true), true)
  self:assert_equal(sz.serialize(false), false)
end

function TestSerializeTrivial:test_bool_can_be_trivially_deserialized()
  self:assert_equal(sz.deserialize(true), true)
  self:assert_equal(sz.deserialize(false), false)
end


function TestSerializeTrivial:test_string_is_serializable()
  self:assert(types.isinstance("test", sz.serializable))
end

function TestSerializeTrivial:test_string_is_trivially_serializable()
  self:assert(types.string:trivially_serializable())
end

function TestSerializeTrivial:test_string_can_be_trivially_serialized()
  self:assert_equal(sz.serialize("test"), "test")
end

function TestSerializeTrivial:test_string_can_be_trivially_deserialized()
  self:assert_equal(sz.deserialize("test"), "test")
end
