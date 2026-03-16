function render(template, context)
  return template:gsub("{{(.-)}}", function(key)
    return context[key:match("^%s*(.-)%s*$")] or ""
  end)
end

function permutant_info(base, req)
  return {
    description = 'permutant info',
    id               = base.permutant.permutant_id or nil,
    owner            = base.permutant.permutant_owner or nil,
    name             = base.permutant.name or nil,
    stage            = base.permutant.stage or nil,
    variant          = base.permutant.variant or nil,
    born_at          = base.permutant.born_at or nil,
    last_interaction = base.permutant.last_interaction or nil,
    age              = base.permutant.age or nil,
    hunger           = base.permutant.stats.hunger or nil,
    happiness        = base.permutant.stats.happiness or nil,
    health           = base.permutant.stats.health or nil,
    energy           = base.permutant.stats.energy or nil
  }
end

function ui(base, req)
  local info = permutant_info(base, req)
  local template = [[
    <h1>{{name}}</h1>
    <p>Stage: {{stage}}</p>
    <p>Variant: {{variant}}</p>
    <p>Age: {{age}} seconds</p>
    <p>Hunger: {{hunger}}</p>
    <p>Happy: {{happiness}}</p>
    <p>Health: {{health}}</p>
    <p>Energy: {{energy}}</p>
  ]]
  return render(template, info)
end
