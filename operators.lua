
local operators = {}

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


return operators
