local dict = require 'lulz.collections.dict'
local types = require 'lulz.types'
local ordereddict = require 'lulz.collections.ordereddict'

local TestCase = require 'lulz.testcase'


local TestOrderedDict = TestCase.find('Dict Class'):inherit {
  __name__ = 'Ordered Dict',
  Type = ordereddict
}

function TestOrderedDict:test_ordereddict_is_dict()
  local od = ordereddict:new()
  self:assert(types.isinstance(od, dict))
end
