
return {
  sign = function(x)
    assert(type(x) == 'number')
    if x < 0 then return -1 end
    return 1
  end
}
