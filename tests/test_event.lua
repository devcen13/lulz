local class = require 'lulz.types.class'
local event = require 'lulz.event'
local TestCase = require 'lulz.testcase'

local TestEvent = TestCase:inherit 'Event'


function TestEvent:test_handler_is_called_when_event_raised()
  local calls = 0
  local ev = event()
  local handler = function() calls = calls +1 end
  ev:subscribe(handler)
  ev:raise()
  self:assert_equal(calls, 1)
end

function TestEvent:test_handler_can_be_unsubscribed()
  local calls = 0
  local ev = event()
  local handler = function() calls = calls +1 end
  ev:subscribe(handler)
  ev:raise()
  ev:unsubscribe(handler)
  ev:raise()
  self:assert_equal(calls, 1)
end

function TestEvent:test_handler_can_be_subscribed_multiple_times()
  local calls = 0
  local ev = event()
  local handler = function() calls = calls +1 end
  ev:subscribe(handler)
  ev:subscribe(handler)
  ev:subscribe(handler)
  ev:raise()
  self:assert_equal(calls, 3)
end

function TestEvent:test_class_handler_can_be_used()
  local C = class {
    fn = function(this)
      this.called = true
    end
  }
  local c = C:new()

  local ev = event()
  ev:subscribe(c, c.fn)
  ev:raise()
  self:assert(c.called)
end

function TestEvent:test_class_handler_can_be_unsubscribed()
  local C = class {
    fn = function(this)
      this.called = true
    end
  }
  local c = C:new()

  local ev = event()
  ev:subscribe(c, c.fn)
  ev:unsubscribe(c, c.fn)
  ev:raise()
  self:assert_false(c.called)
end
