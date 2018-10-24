
local operators = {}


--[[ Math ]]
function operators.sum(a, b)
  return a + b
end
operators['+'] = operators.sum

function operators.sub(a, b)
  return a - b
end
operators['-'] = operators.sub

function operators.mul(a, b)
  return a * b
end
operators['*'] = operators.mul

function operators.div(a, b)
  return a / b
end
operators['/'] = operators.div

function operators.mod(a, b)
  return a % b
end
operators['%'] = operators.mod

function operators.pow(a, b)
  return a ^ b
end
operators['^'] = operators.pow

function operators.concat(a, b)
  return a .. b
end
operators['..'] = operators.concat


--[[ Compare ]]
function operators.lt(a, b)
  return a < b
end
operators['<'] = operators.lt
operators.less = operators.lt

function operators.le(a, b)
  return a <= b
end
operators['<='] = operators.le

function operators.gt(a, b)
  return a > b
end
operators['>'] = operators.gt
operators.more = operators.gt

function operators.ge(a, b)
  return a >= b
end
operators['>='] = operators.ge

function operators.eq(a, b)
  return a == b
end
operators['=='] = operators.eq


--[[ Logical ]]
operators['&&'] = function(a, b) return a and b end
operators['||'] = function(a, b) return a or  b end


return operators
