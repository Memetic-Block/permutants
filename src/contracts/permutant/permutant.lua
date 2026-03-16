local json   = require('json')
local lustache = require('..lib.lustache')
local config = require('.config')
local decay  = require('.decay')
acl          = require('..common.acl')
default_template = require('.template.stache')
template = template or default_template

-- Initialise permutant state (egg) --
permutant = permutant or decay.newEgg()

-- Helper: project decay forward and save as new base state
local function crystallize(msg)
  permutant = decay.project(permutant, msg.Timestamp)
end

-- Helper: emit a full state patch
-- When `now` is provided, decay is projected for the UI (lazy-eval at view-time).
local function emitPatch(now)
  local projected = permutant
  if now and permutant.stage ~= 'egg' and permutant.stage ~= 'dead' then
    projected = decay.project(permutant, now)
  end
  Send({
    device = 'patch@1.0',
    ---@diagnostic disable-next-line: assign-type-mismatch
    acl = acl,
    ---@diagnostic disable-next-line: assign-type-mismatch
    permutant = permutant,
    ui = lustache:render(template, { permutant = projected, permutantJson = json.encode(permutant), config = config, configJson = json.encode(config) })
  })
end

-- Helper: assert the pet is alive (not dead and not egg)
local function assertAlive(state)
  state = state or permutant
  assert(state.stage ~= 'dead', 'Permutant is dead. Send "Revive" to restart.')
  assert(state.stage ~= 'egg',  'Permutant is still an egg. Send "Hatch" first.')
end

-- Helper: boost a stat by a given amount, clamped to MAX_STAT
local function boostStat(stat, amount)
  permutant.stats[stat] = math.min(config.MAX_STAT, permutant.stats[stat] + amount)
end

Handlers.add('Set-Template', 'Set-Template', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner', 'admin', 'Set-Template' })
  template = msg.Data or template
  Send({ Target = msg.From, Action = 'Set-Template-Response', Data = 'OK' })
  emitPatch(msg.Timestamp)
end)

---------------------------------------------------------------------------
-- ACL Handlers (unchanged)
---------------------------------------------------------------------------

-- Update ACL Roles --
Handlers.add('Update-Roles', 'Update-Roles', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner', 'admin', 'Update-Roles' })
  acl = acl.updateRoles(json.decode(msg.Data), acl)
  Send({ Target = msg.From, Action = 'Update-Roles-Response', Data = 'OK' })
  emitPatch(msg.Timestamp)
end)

-- View ACL Roles --
Handlers.add('View-Roles', 'View-Roles', function (msg)
  Send({ Target = msg.From, Action = 'View-Roles-Response', Data = json.encode(acl.state) })
end)

---------------------------------------------------------------------------
-- Tamagotchi Handlers
---------------------------------------------------------------------------

-- Hatch: transition from egg to baby, set name --
Handlers.add('Hatch', 'Hatch', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  assert(permutant.stage == 'egg', 'Permutant has already hatched: stage = ' .. permutant.stage .. '.')

  local name = msg.Tags['Permutant-Name'] or msg.Data or ''
  assert(#name > 0, 'Provide a name in Permutant-Name tag or msg.Data.')

  permutant.name             = name
  permutant.stage            = 'baby'
  permutant.born_at          = msg.Timestamp
  permutant.last_interaction = msg.Timestamp
  permutant.age              = 0

  Send({ Target = msg.From, Action = 'Hatch-Response', Data = 'OK' })
  emitPatch()
end)

-- Feed: restore hunger --
Handlers.add('Feed', 'Feed', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  crystallize(msg)
  assertAlive()

  boostStat('hunger', config.BOOST.feed)

  Send({ Target = msg.From, Action = 'Feed-Response', Data = 'OK' })
  emitPatch(msg.Timestamp)
end)

-- Play: restore happiness --
Handlers.add('Play', 'Play', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  crystallize(msg)
  assertAlive()

  boostStat('happiness', config.BOOST.play)

  Send({ Target = msg.From, Action = 'Play-Response', Data = 'OK' })
  emitPatch(msg.Timestamp)
end)

-- Heal: restore health --
Handlers.add('Heal', 'Heal', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  crystallize(msg)
  assertAlive()

  boostStat('health', config.BOOST.heal)

  Send({ Target = msg.From, Action = 'Heal-Response', Data = 'OK' })
  emitPatch(msg.Timestamp)
end)

-- Sleep: restore energy --
Handlers.add('Sleep', 'Sleep', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  crystallize(msg)
  assertAlive()

  boostStat('energy', config.BOOST.sleep)

  Send({ Target = msg.From, Action = 'Sleep-Response', Data = 'OK' })
  emitPatch(msg.Timestamp)
end)

-- Revive: reset dead permutant back to egg --
Handlers.add('Revive', 'Revive', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  assert(permutant.stage == 'dead', 'Permutant is not dead.')

  permutant = decay.newEgg()

  Send({ Target = msg.From, Action = 'Revive-Response', Data = 'OK' })
  emitPatch()
end)

-- View-State: return raw stored state (no decay projection) --
Handlers.add('View-State', 'View-State', function (msg)
  Send({
    Target = msg.From,
    Action = 'View-State-Response',
    Data   = json.encode(permutant),
  })
end)

---------------------------------------------------------------------------
-- Initial state patch on load
---------------------------------------------------------------------------
emitPatch()
