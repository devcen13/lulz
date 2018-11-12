local dict = require 'lulz.collections.dict'
local class = require 'lulz.class'
local ordereddict = require 'lulz.collections.ordereddict'

local TestCase = require 'lulz.testcase'


local TestOrderedDict = TestCase.find('dict'):inherit 'OrderedDict' {
  Type = ordereddict
}

function TestOrderedDict:test_ordereddict_is_dict()
  local od = ordereddict:new()
  self:assert(class.is_instance(od, dict))
end
