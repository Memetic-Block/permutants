local json   = require('json')
local config = require('.config')
local decay  = require('.decay')
acl          = require('..common.acl')

-- Initialise permutant state (egg) --
State = State or decay.newEgg()

-- Helper: run lazy decay before processing an action
local function tickState(msg)
  State = decay.tick(State, msg.Timestamp)
end

-- Helper: emit a full state patch
local function emitPatch()
  Send({
    device = 'patch@1.0',
    ---@diagnostic disable-next-line: assign-type-mismatch
    acl = acl,
    permutant = State,
  })
end

-- Helper: assert the pet is alive (not dead and not egg)
local function assertAlive()
  assert(State.stage ~= 'dead', 'Permutant is dead. Send "Revive" to restart.')
  assert(State.stage ~= 'egg',  'Permutant is still an egg. Send "Hatch" first.')
end

-- Helper: boost a stat by a given amount, clamped to MAX_STAT
local function boostStat(stat, amount)
  State.stats[stat] = math.min(config.MAX_STAT, State.stats[stat] + amount)
end

---------------------------------------------------------------------------
-- ACL Handlers (unchanged)
---------------------------------------------------------------------------

-- Update ACL Roles --
Handlers.add('Update-Roles', 'Update-Roles', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner', 'admin', 'Update-Roles' })
  acl = acl.updateRoles(json.decode(msg.Data), acl)
  Send({ Target = msg.From, Action = 'Update-Roles-Response', Data = 'OK' })
  emitPatch()
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
  assert(State.stage == 'egg', 'Permutant has already hatched.')

  local name = msg.Data or ''
  assert(#name > 0, 'Provide a name in msg.Data.')

  State.name             = name
  State.stage            = 'baby'
  State.born_at          = msg.Timestamp
  State.last_interaction = msg.Timestamp
  State.age              = 0

  Send({ Target = msg.From, Action = 'Hatch-Response', Data = 'OK' })
  emitPatch()
end)

-- Feed: restore hunger --
Handlers.add('Feed', 'Feed', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  tickState(msg)
  assertAlive()

  boostStat('hunger', config.BOOST.feed)

  Send({ Target = msg.From, Action = 'Feed-Response', Data = 'OK' })
  emitPatch()
end)

-- Play: restore happiness --
Handlers.add('Play', 'Play', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  tickState(msg)
  assertAlive()

  boostStat('happiness', config.BOOST.play)

  Send({ Target = msg.From, Action = 'Play-Response', Data = 'OK' })
  emitPatch()
end)

-- Heal: restore health --
Handlers.add('Heal', 'Heal', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  tickState(msg)
  assertAlive()

  boostStat('health', config.BOOST.heal)

  Send({ Target = msg.From, Action = 'Heal-Response', Data = 'OK' })
  emitPatch()
end)

-- Sleep: restore energy --
Handlers.add('Sleep', 'Sleep', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  tickState(msg)
  assertAlive()

  boostStat('energy', config.BOOST.sleep)

  Send({ Target = msg.From, Action = 'Sleep-Response', Data = 'OK' })
  emitPatch()
end)

-- Revive: reset dead permutant back to egg --
Handlers.add('Revive', 'Revive', function (msg)
  acl.assertHasOneOfRole(msg.From, { 'owner' })
  assert(State.stage == 'dead', 'Permutant is not dead.')

  State = decay.newEgg()

  Send({ Target = msg.From, Action = 'Revive-Response', Data = 'OK' })
  emitPatch()
end)

-- View-State: return full state (public, runs tick for accurate snapshot) --
Handlers.add('View-State', 'View-State', function (msg)
  if State.stage ~= 'egg' and State.stage ~= 'dead' then
    tickState(msg)
  end
  Send({
    Target = msg.From,
    Action = 'View-State-Response',
    Data   = json.encode(State),
  })
end)

---------------------------------------------------------------------------
-- Initial state patch on load
---------------------------------------------------------------------------
emitPatch()
