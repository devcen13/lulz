local functional = require 'lulz.functional'
local TestCase = require 'lulz.tests.testcase'

local id = functional.id
local bind = functional.bind


local TestBind = TestCase:inherit 'Functional Bind'

function TestBind:test_id_bind()
  self:assert_equal(bind(id)(5), 5)
end

function TestBind:test_single_argument_bind()
  self:assert_equal(bind(id, 5)(), 5)
end
