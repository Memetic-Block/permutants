local config = require('.config')

local decay = {}

-- Determine the dominant stat for evolution variant selection
local function getDominantStat(stats)
  local maxVal = -1
  local dominant = config.STAT_PRIORITY[1]
  for _, stat in ipairs(config.STAT_PRIORITY) do
    if stats[stat] > maxVal then
      maxVal = stats[stat]
      dominant = stat
    end
  end
  return dominant
end

-- Resolve the evolution variant for a given stage based on current stats
local function resolveVariant(stage, stats)
  local variants = config.VARIANTS[stage]
  if not variants then return nil end
  local dominant = getDominantStat(stats)
  return variants[dominant]
end

-- Determine the correct stage for a given age (seconds since birth)
local function stageForAge(age)
  local result = 'baby'
  for _, threshold in ipairs(config.AGE_THRESHOLDS) do
    if age >= threshold.age then
      result = threshold.stage
    end
  end
  return result
end

-- Deep-copy a table (flat tables only, no metatables/cycles)
local function deepCopy(orig)
  if type(orig) ~= 'table' then return orig end
  local copy = {}
  for k, v in pairs(orig) do
    copy[k] = deepCopy(v)
  end
  return copy
end

-- Project state forward to `now` without mutating the input.
-- Returns a new table representing the state at time `now`.
-- `now` is the current timestamp in milliseconds (msg.Timestamp).
function decay.project(state, now)
  -- Egg and dead don't decay — return a copy unchanged
  if state.stage == 'egg' or state.stage == 'dead' then
    local copy = deepCopy(state)
    copy.icon = config.STAGE_ICON[state.stage]
    return copy
  end

  -- Guard against missing or future timestamps
  if state.last_interaction <= 0 or now <= state.last_interaction then
    return deepCopy(state)
  end

  local s = deepCopy(state)

  -- Elapsed time in seconds (AO Timestamps are in milliseconds)
  local elapsed = (now - s.last_interaction) / 1000
  local rates = config.DECAY_RATE[s.stage] or config.DECAY_RATE['baby']

  -- Decay stats
  for stat, rate in pairs(rates) do
    if rate > 0 then
      s.stats[stat] = math.max(
        config.MIN_STAT,
        s.stats[stat] - (elapsed * rate)
      )
    end
  end

  -- Advance age
  s.age = s.age + elapsed

  -- Check death (health reached 0)
  if s.stats.health <= 0 then
    s.stage = 'dead'
    s.icon = config.STAGE_ICON['dead']
    s.last_interaction = now
    return s
  end

  -- Check stage transitions
  local newStage = stageForAge(s.age)
  if newStage ~= s.stage then
    s.variant = resolveVariant(newStage, s.stats)
    s.stage = newStage
    s.icon = config.STAGE_ICON[newStage]
  end

  s.icon = config.STAGE_ICON[s.stage]
  s.last_interaction = now
  return s
end

-- Create a fresh egg state
function decay.newEgg()
  return {
    name             = 'Fresh Egg',
    stage            = 'egg',
    icon             = config.STAGE_ICON['egg'],
    variant          = resolveVariant('egg', {
      hunger    = config.MAX_STAT,
      happiness = config.MAX_STAT,
      health    = config.MAX_STAT,
      energy    = config.MAX_STAT,
    }),
    born_at          = 0,
    last_interaction = 0,
    age              = 0,
    stats = {
      hunger    = config.MAX_STAT,
      happiness = config.MAX_STAT,
      health    = config.MAX_STAT,
      energy    = config.MAX_STAT,
    },
  }
end

return decay
