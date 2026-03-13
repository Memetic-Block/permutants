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

-- Apply lazy decay and advance state to the current timestamp.
-- `state` is mutated in place and returned.
-- `now` is the current timestamp in milliseconds (msg.Timestamp).
function decay.tick(state, now)
  -- Egg and dead don't decay
  if state.stage == 'egg' or state.stage == 'dead' then
    return state
  end

  -- Guard against missing or future timestamps
  if state.last_interaction <= 0 or now <= state.last_interaction then
    return state
  end

  -- Elapsed time in seconds (AO Timestamps are in milliseconds)
  local elapsed = (now - state.last_interaction) / 1000
  local rates = config.DECAY_RATE[state.stage] or config.DECAY_RATE['baby']

  -- Decay stats
  for stat, rate in pairs(rates) do
    if rate > 0 then
      state.stats[stat] = math.max(
        config.MIN_STAT,
        state.stats[stat] - (elapsed * rate)
      )
    end
  end

  -- Advance age
  state.age = state.age + elapsed

  -- Check death (health reached 0)
  if state.stats.health <= 0 then
    state.stage = 'dead'
    state.last_interaction = now
    return state
  end

  -- Check stage transitions
  local newStage = stageForAge(state.age)
  if newStage ~= state.stage then
    state.variant = resolveVariant(newStage, state.stats)
    state.stage = newStage
  end

  state.last_interaction = now
  return state
end

-- Create a fresh egg state
function decay.newEgg()
  return {
    name             = '',
    stage            = 'egg',
    variant          = nil,
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
