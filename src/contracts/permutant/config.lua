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
	egg   = [[<svg version="1.1" width="64" height="64" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges">
			<rect x="24" y="0" width="4" height="4" fill="black" />
			<rect x="28" y="0" width="4" height="4" fill="black" />
			<rect x="32" y="0" width="4" height="4" fill="black" />
			<rect x="36" y="0" width="4" height="4" fill="black" />
			<rect x="40" y="0" width="4" height="4" fill="black" />
			<rect x="20" y="4" width="4" height="4" fill="black" />
			<rect x="24" y="4" width="4" height="4" fill="white" />
			<rect x="28" y="4" width="4" height="4" fill="white" />
			<rect x="32" y="4" width="4" height="4" fill="white" />
			<rect x="36" y="4" width="4" height="4" fill="white" />
			<rect x="40" y="4" width="4" height="4" fill="white" />
			<rect x="44" y="4" width="4" height="4" fill="black" />
			<rect x="16" y="8" width="4" height="4" fill="black" />
			<rect x="20" y="8" width="4" height="4" fill="white" />
			<rect x="24" y="8" width="4" height="4" fill="white" />
			<rect x="28" y="8" width="4" height="4" fill="white" />
			<rect x="32" y="8" width="4" height="4" fill="white" />
			<rect x="36" y="8" width="4" height="4" fill="white" />
			<rect x="40" y="8" width="4" height="4" fill="white" />
			<rect x="44" y="8" width="4" height="4" fill="white" />
			<rect x="48" y="8" width="4" height="4" fill="black" />
			<rect x="12" y="12" width="4" height="4" fill="black" />
			<rect x="16" y="12" width="4" height="4" fill="white" />
			<rect x="20" y="12" width="4" height="4" fill="white" />
			<rect x="24" y="12" width="4" height="4" fill="white" />
			<rect x="28" y="12" width="4" height="4" fill="white" />
			<rect x="32" y="12" width="4" height="4" fill="white" />
			<rect x="36" y="12" width="4" height="4" fill="white" />
			<rect x="40" y="12" width="4" height="4" fill="white" />
			<rect x="44" y="12" width="4" height="4" fill="white" />
			<rect x="48" y="12" width="4" height="4" fill="black" />
			<rect x="12" y="16" width="4" height="4" fill="black" />
			<rect x="16" y="16" width="4" height="4" fill="white" />
			<rect x="20" y="16" width="4" height="4" fill="white" />
			<rect x="24" y="16" width="4" height="4" fill="white" />
			<rect x="28" y="16" width="4" height="4" fill="white" />
			<rect x="32" y="16" width="4" height="4" fill="white" />
			<rect x="36" y="16" width="4" height="4" fill="white" />
			<rect x="40" y="16" width="4" height="4" fill="white" />
			<rect x="44" y="16" width="4" height="4" fill="white" />
			<rect x="48" y="16" width="4" height="4" fill="black" />
			<rect x="12" y="20" width="4" height="4" fill="black" />
			<rect x="16" y="20" width="4" height="4" fill="white" />
			<rect x="20" y="20" width="4" height="4" fill="white" />
			<rect x="24" y="20" width="4" height="4" fill="white" />
			<rect x="28" y="20" width="4" height="4" fill="white" />
			<rect x="32" y="20" width="4" height="4" fill="white" />
			<rect x="36" y="20" width="4" height="4" fill="white" />
			<rect x="40" y="20" width="4" height="4" fill="white" />
			<rect x="44" y="20" width="4" height="4" fill="white" />
			<rect x="48" y="20" width="4" height="4" fill="white" />
			<rect x="52" y="20" width="4" height="4" fill="black" />
			<rect x="8" y="24" width="4" height="4" fill="black" />
			<rect x="12" y="24" width="4" height="4" fill="white" />
			<rect x="16" y="24" width="4" height="4" fill="white" />
			<rect x="20" y="24" width="4" height="4" fill="white" />
			<rect x="24" y="24" width="4" height="4" fill="white" />
			<rect x="28" y="24" width="4" height="4" fill="white" />
			<rect x="32" y="24" width="4" height="4" fill="white" />
			<rect x="36" y="24" width="4" height="4" fill="white" />
			<rect x="40" y="24" width="4" height="4" fill="white" />
			<rect x="44" y="24" width="4" height="4" fill="white" />
			<rect x="48" y="24" width="4" height="4" fill="white" />
			<rect x="52" y="24" width="4" height="4" fill="black" />
			<rect x="8" y="28" width="4" height="4" fill="black" />
			<rect x="12" y="28" width="4" height="4" fill="white" />
			<rect x="16" y="28" width="4" height="4" fill="white" />
			<rect x="20" y="28" width="4" height="4" fill="white" />
			<rect x="24" y="28" width="4" height="4" fill="white" />
			<rect x="28" y="28" width="4" height="4" fill="white" />
			<rect x="32" y="28" width="4" height="4" fill="white" />
			<rect x="36" y="28" width="4" height="4" fill="white" />
			<rect x="40" y="28" width="4" height="4" fill="white" />
			<rect x="44" y="28" width="4" height="4" fill="white" />
			<rect x="48" y="28" width="4" height="4" fill="white" />
			<rect x="52" y="28" width="4" height="4" fill="black" />
			<rect x="8" y="32" width="4" height="4" fill="black" />
			<rect x="12" y="32" width="4" height="4" fill="white" />
			<rect x="16" y="32" width="4" height="4" fill="white" />
			<rect x="20" y="32" width="4" height="4" fill="white" />
			<rect x="24" y="32" width="4" height="4" fill="white" />
			<rect x="28" y="32" width="4" height="4" fill="white" />
			<rect x="32" y="32" width="4" height="4" fill="white" />
			<rect x="36" y="32" width="4" height="4" fill="white" />
			<rect x="40" y="32" width="4" height="4" fill="white" />
			<rect x="44" y="32" width="4" height="4" fill="white" />
			<rect x="48" y="32" width="4" height="4" fill="white" />
			<rect x="52" y="32" width="4" height="4" fill="black" />
			<rect x="8" y="36" width="4" height="4" fill="black" />
			<rect x="12" y="36" width="4" height="4" fill="white" />
			<rect x="16" y="36" width="4" height="4" fill="white" />
			<rect x="20" y="36" width="4" height="4" fill="white" />
			<rect x="24" y="36" width="4" height="4" fill="white" />
			<rect x="28" y="36" width="4" height="4" fill="white" />
			<rect x="32" y="36" width="4" height="4" fill="white" />
			<rect x="36" y="36" width="4" height="4" fill="white" />
			<rect x="40" y="36" width="4" height="4" fill="white" />
			<rect x="44" y="36" width="4" height="4" fill="white" />
			<rect x="48" y="36" width="4" height="4" fill="white" />
			<rect x="52" y="36" width="4" height="4" fill="black" />
			<rect x="8" y="40" width="4" height="4" fill="black" />
			<rect x="12" y="40" width="4" height="4" fill="white" />
			<rect x="16" y="40" width="4" height="4" fill="white" />
			<rect x="20" y="40" width="4" height="4" fill="white" />
			<rect x="24" y="40" width="4" height="4" fill="white" />
			<rect x="28" y="40" width="4" height="4" fill="white" />
			<rect x="32" y="40" width="4" height="4" fill="white" />
			<rect x="36" y="40" width="4" height="4" fill="white" />
			<rect x="40" y="40" width="4" height="4" fill="white" />
			<rect x="44" y="40" width="4" height="4" fill="white" />
			<rect x="48" y="40" width="4" height="4" fill="white" />
			<rect x="52" y="40" width="4" height="4" fill="black" />
			<rect x="8" y="44" width="4" height="4" fill="black" />
			<rect x="12" y="44" width="4" height="4" fill="white" />
			<rect x="16" y="44" width="4" height="4" fill="white" />
			<rect x="20" y="44" width="4" height="4" fill="white" />
			<rect x="24" y="44" width="4" height="4" fill="white" />
			<rect x="28" y="44" width="4" height="4" fill="white" />
			<rect x="32" y="44" width="4" height="4" fill="white" />
			<rect x="36" y="44" width="4" height="4" fill="white" />
			<rect x="40" y="44" width="4" height="4" fill="white" />
			<rect x="44" y="44" width="4" height="4" fill="white" />
			<rect x="48" y="44" width="4" height="4" fill="white" />
			<rect x="52" y="44" width="4" height="4" fill="black" />
			<rect x="8" y="48" width="4" height="4" fill="black" />
			<rect x="12" y="48" width="4" height="4" fill="white" />
			<rect x="16" y="48" width="4" height="4" fill="white" />
			<rect x="20" y="48" width="4" height="4" fill="white" />
			<rect x="24" y="48" width="4" height="4" fill="white" />
			<rect x="28" y="48" width="4" height="4" fill="white" />
			<rect x="32" y="48" width="4" height="4" fill="white" />
			<rect x="36" y="48" width="4" height="4" fill="white" />
			<rect x="40" y="48" width="4" height="4" fill="white" />
			<rect x="44" y="48" width="4" height="4" fill="white" />
			<rect x="48" y="48" width="4" height="4" fill="white" />
			<rect x="52" y="48" width="4" height="4" fill="black" />
			<rect x="12" y="52" width="4" height="4" fill="black" />
			<rect x="16" y="52" width="4" height="4" fill="white" />
			<rect x="20" y="52" width="4" height="4" fill="white" />
			<rect x="24" y="52" width="4" height="4" fill="white" />
			<rect x="28" y="52" width="4" height="4" fill="white" />
			<rect x="32" y="52" width="4" height="4" fill="white" />
			<rect x="36" y="52" width="4" height="4" fill="white" />
			<rect x="40" y="52" width="4" height="4" fill="white" />
			<rect x="44" y="52" width="4" height="4" fill="white" />
			<rect x="48" y="52" width="4" height="4" fill="black" />
			<rect x="16" y="56" width="4" height="4" fill="black" />
			<rect x="20" y="56" width="4" height="4" fill="white" />
			<rect x="24" y="56" width="4" height="4" fill="white" />
			<rect x="28" y="56" width="4" height="4" fill="white" />
			<rect x="32" y="56" width="4" height="4" fill="white" />
			<rect x="36" y="56" width="4" height="4" fill="white" />
			<rect x="40" y="56" width="4" height="4" fill="white" />
			<rect x="44" y="56" width="4" height="4" fill="black" />
			<rect x="20" y="60" width="4" height="4" fill="black" />
			<rect x="24" y="60" width="4" height="4" fill="black" />
			<rect x="28" y="60" width="4" height="4" fill="black" />
			<rect x="32" y="60" width="4" height="4" fill="black" />
			<rect x="36" y="60" width="4" height="4" fill="black" />
			<rect x="40" y="60" width="4" height="4" fill="black" />
		</svg>
	]],
	baby  = [[<svg version="1.1" width="64" height="64" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges">
			<rect x="12" y="0" width="4" height="4" fill="black" />
			<rect x="16" y="0" width="4" height="4" fill="black" />
			<rect x="20" y="0" width="4" height="4" fill="black" />
			<rect x="24" y="0" width="4" height="4" fill="black" />
			<rect x="28" y="0" width="4" height="4" fill="black" />
			<rect x="32" y="0" width="4" height="4" fill="black" />
			<rect x="36" y="0" width="4" height="4" fill="black" />
			<rect x="40" y="0" width="4" height="4" fill="black" />
			<rect x="44" y="0" width="4" height="4" fill="black" />
			<rect x="48" y="0" width="4" height="4" fill="black" />
			<rect x="8" y="4" width="4" height="4" fill="black" />
			<rect x="12" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="4" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="4" width="4" height="4" fill="black" />
			<rect x="4" y="8" width="4" height="4" fill="black" />
			<rect x="8" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="8" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="8" width="4" height="4" fill="black" />
			<rect x="0" y="12" width="4" height="4" fill="black" />
			<rect x="4" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="12" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="12" width="4" height="4" fill="black" />
			<rect x="0" y="16" width="4" height="4" fill="black" />
			<rect x="4" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="16" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="16" width="4" height="4" fill="black" />
			<rect x="0" y="20" width="4" height="4" fill="black" />
			<rect x="4" y="20" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="20" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="20" width="4" height="4" fill="black" />
			<rect x="16" y="20" width="4" height="4" fill="black" />
			<rect x="20" y="20" width="4" height="4" fill="black" />
			<rect x="24" y="20" width="4" height="4" fill="black" />
			<rect x="28" y="20" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="20" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="20" width="4" height="4" fill="black" />
			<rect x="40" y="20" width="4" height="4" fill="black" />
			<rect x="44" y="20" width="4" height="4" fill="black" />
			<rect x="48" y="20" width="4" height="4" fill="black" />
			<rect x="52" y="20" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="20" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="20" width="4" height="4" fill="black" />
			<rect x="0" y="24" width="4" height="4" fill="black" />
			<rect x="4" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="24" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="24" width="4" height="4" fill="black" />
			<rect x="0" y="28" width="4" height="4" fill="black" />
			<rect x="4" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="28" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="28" width="4" height="4" fill="black" />
			<rect x="0" y="32" width="4" height="4" fill="black" />
			<rect x="4" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="32" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="32" width="4" height="4" fill="black" />
			<rect x="0" y="36" width="4" height="4" fill="black" />
			<rect x="4" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="36" width="4" height="4" fill="lightseagreen" />
			<rect x="28" y="36" width="4" height="4" fill="deepskyblue" />
			<rect x="32" y="36" width="4" height="4" fill="lightseagreen" />
			<rect x="36" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="36" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="36" width="4" height="4" fill="black" />
			<rect x="0" y="40" width="4" height="4" fill="black" />
			<rect x="4" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="40" width="4" height="4" fill="deepskyblue" />
			<rect x="28" y="40" width="4" height="4" fill="mediumblue" />
			<rect x="32" y="40" width="4" height="4" fill="deepskyblue" />
			<rect x="36" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="40" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="40" width="4" height="4" fill="black" />
			<rect x="0" y="44" width="4" height="4" fill="black" />
			<rect x="4" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="44" width="4" height="4" fill="lightseagreen" />
			<rect x="28" y="44" width="4" height="4" fill="deepskyblue" />
			<rect x="32" y="44" width="4" height="4" fill="lightseagreen" />
			<rect x="36" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="44" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="44" width="4" height="4" fill="black" />
			<rect x="0" y="48" width="4" height="4" fill="black" />
			<rect x="4" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="8" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="48" width="4" height="4" fill="lightseagreen" />
			<rect x="32" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="48" width="4" height="4" fill="darksalmon" />
			<rect x="60" y="48" width="4" height="4" fill="black" />
			<rect x="4" y="52" width="4" height="4" fill="black" />
			<rect x="8" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="12" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="52" width="4" height="4" fill="darksalmon" />
			<rect x="56" y="52" width="4" height="4" fill="black" />
			<rect x="8" y="56" width="4" height="4" fill="black" />
			<rect x="12" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="16" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="20" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="24" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="28" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="32" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="36" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="40" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="44" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="48" y="56" width="4" height="4" fill="darksalmon" />
			<rect x="52" y="56" width="4" height="4" fill="black" />
			<rect x="12" y="60" width="4" height="4" fill="black" />
			<rect x="16" y="60" width="4" height="4" fill="black" />
			<rect x="20" y="60" width="4" height="4" fill="black" />
			<rect x="24" y="60" width="4" height="4" fill="black" />
			<rect x="28" y="60" width="4" height="4" fill="black" />
			<rect x="32" y="60" width="4" height="4" fill="black" />
			<rect x="36" y="60" width="4" height="4" fill="black" />
			<rect x="40" y="60" width="4" height="4" fill="black" />
			<rect x="44" y="60" width="4" height="4" fill="black" />
			<rect x="48" y="60" width="4" height="4" fill="black" />
		</svg>
	]],
	child = 'child_sprite',
	teen  = 'teen_sprite',
	adult = 'adult_sprite',
	elder = 'elder_sprite',
	dead  = 'dead_sprite',
}

-- Ordered stat names for tie-breaking (first in list wins)
config.STAT_PRIORITY = { 'happiness', 'health', 'energy', 'hunger' }

return config
