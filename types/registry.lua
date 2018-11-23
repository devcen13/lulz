local registry = {
  types = {}
}


function registry.add(tp)
  table.insert(registry.types, tp)
  return #registry.types
end

function registry.find(id)
  return registry.types[id]
end


return registry
