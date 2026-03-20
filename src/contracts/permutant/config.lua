local config = {}

-- Stat ranges
config.MIN_STAT = 0
config.MAX_STAT = 100

-- Action boost amounts
config.BOOST = {
  feed  = 25,
  play  = 25,
  heal  = 25,
  sleep = 25,
}

-- Decay rates per stage (points lost per second)
-- Later stages decay faster for difficulty scaling
config.DECAY_RATE = {
  egg   = { hunger = 0,      happiness = 0,      health = 0,      energy = 0      },
  baby  = { hunger = 0.015,  happiness = 0.012,  health = 0.008,  energy = 0.010  },
  child = { hunger = 0.018,  happiness = 0.015,  health = 0.010,  energy = 0.013  },
  teen  = { hunger = 0.022,  happiness = 0.018,  health = 0.013,  energy = 0.016  },
  adult = { hunger = 0.025,  happiness = 0.022,  health = 0.015,  energy = 0.020  },
  elder = { hunger = 0.030,  happiness = 0.025,  health = 0.020,  energy = 0.025  },
  dead  = { hunger = 0,      happiness = 0,      health = 0,      energy = 0      },
}

-- Age thresholds for stage transitions (in seconds)
-- Egg is hatched manually; these are cumulative from birth
config.AGE_THRESHOLDS = {
  { age = 0,      stage = 'baby'  },
  { age = 3600,   stage = 'child' },  -- 1 hour
  { age = 14400,  stage = 'teen'  },  -- 4 hours
  { age = 43200,  stage = 'adult' },  -- 12 hours
  { age = 172800, stage = 'elder' },  -- 48 hours
}

-- Evolution variants by dominant stat at stage transition
-- Key = stat name that is highest at transition time
config.VARIANTS = {
  egg = {
    hunger    = 'ember',
    happiness = 'glimmer',
    health    = 'stone',
    energy    = 'spark',
  },
  baby = {
    hunger    = 'glutton',
    happiness = 'playful',
    health    = 'hardy',
    energy    = 'restless',
  },
  child = {
    hunger    = 'ravenous',
    happiness = 'joyful',
    health    = 'sturdy',
    energy    = 'hyperactive',
  },
  teen = {
    hunger    = 'voracious',
    happiness = 'charismatic',
    health    = 'resilient',
    energy    = 'tireless',
  },
  adult = {
    hunger    = 'insatiable',
    happiness = 'radiant',
    health    = 'ironclad',
    energy    = 'perpetual',
  },
  elder = {
    hunger    = 'famished-sage',
    happiness = 'blissful-sage',
    health    = 'undying-sage',
    energy    = 'eternal-sage',
  },
}

-- Emoji icon per stage
config.STAGE_ICON = {
  egg   = '&#129370;',  -- 🥚
  baby  = '&#128118;',  -- 👶
  child = '&#129306;',  -- 🧒
  teen  = '&#128526;',  -- 😎
  adult = '&#128170;',  -- 💪
  elder = '&#129309;',  -- 🧓
  dead  = '&#128128;',  -- 💀
}

config.STAGE_SPRITE = {
	egg   = './assets/egg/idle/idle.gif',
	baby  = './assets/baby/idle/idle.gif',
	child = './assets/child/idle/idle.gif',
	teen  = './assets/teen/idle/idle.gif',
	adult = './assets/adult/idle/idle.gif',
	elder = './assets/elder/idle/idle.gif',
	dead  = './assets/dead/dead.png',
}

-- Ordered stat names for tie-breaking (first in list wins)
config.STAT_PRIORITY = { 'happiness', 'health', 'energy', 'hunger' }

return config
