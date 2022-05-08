Config = {}
Config.Locale = 'en'

Config.ItemName = 'casinochips' -- The chip item in DB

Config.PrintClient = false -- Print on client's console the spins in case of object bug
Config.Offset = true -- Add 30% propability to stop the spins in wrong position

Config.HideUI = true
Config.HideUIEvent = 'pma-voice:toggleui'
Config.ShowUIEvent = 'pma-voice:toggleui'

Config.Mult = { -- Multipliers based on GTA:ONLINE
	['1'] = 25,	
	['2'] = 50,
	['3'] = 75,
	['4'] = 100,
	['5'] = 250,
	['6'] = 500,
	['7'] = 1000,
}

Config.Slots = {
	[1] = { -- Diamonds
		pos = vector3(973.84368896484, 63.71541595459, 74.742706298828),
		bet = 2500,
		prop = 'vw_prop_casino_slot_07a',
		prop1 = 'vw_prop_casino_slot_07a_reels',
		prop2 = 'vw_prop_casino_slot_07b_reels',
	},
	[2] = { -- Diamonds
		pos = vector3(977.00476074219, 73.394256591797, 74.734687805176),
		bet = 2500,
		prop = 'vw_prop_casino_slot_07a',
		prop1 = 'vw_prop_casino_slot_07a_reels',
		prop2 = 'vw_prop_casino_slot_07b_reels',
	},
	[3] = { -- Diamonds
		pos = vector3(969.94055175781, 67.007064819336, 74.735908508301),
		bet = 2500,
		prop = 'vw_prop_casino_slot_07a',
		prop1 = 'vw_prop_casino_slot_07a_reels',
		prop2 = 'vw_prop_casino_slot_07b_reels',
	},
	
	
	[4] = { -- Deity of the Sun
		pos = vector3(968.94866943359, 66.618591308594, 74.737915039063),
		bet = 2500,
		prop = 'vw_prop_casino_slot_05a',
		prop1 = 'vw_prop_casino_slot_05a_reels',
		prop2 = 'vw_prop_casino_slot_05b_reels',
	},
	[5] = { -- Deity of the Sun
		pos = vector3(979.04925537109, 67.974685668945, 74.733177185059),
		bet = 2500,
		prop = 'vw_prop_casino_slot_05a',
		prop1 = 'vw_prop_casino_slot_05a_reels',
		prop2 = 'vw_prop_casino_slot_05b_reels',
	},
	
	
	
	[6] = { -- Have A Stab
		pos = vector3(969.64099121094, 66.335395812988, 74.739044189453),
		bet = 2500,
		prop = 'vw_prop_casino_slot_06a',
		prop1 = 'vw_prop_casino_slot_06a_reels',
		prop2 = 'vw_prop_casino_slot_06b_reels',
	},
	[7] = { -- Have A Stab
		pos = vector3(979.46875, 67.342468261719, 74.735130310059),
		bet = 2500,
		prop = 'vw_prop_casino_slot_06a',
		prop1 = 'vw_prop_casino_slot_06a_reels',
		prop2 = 'vw_prop_casino_slot_06b_reels',
	},
	[8] = { -- Have A Stab
		pos = vector3(977.15307617188, 72.675872802734, 74.739761352539),
		bet = 2500,
		prop = 'vw_prop_casino_slot_06a',
		prop1 = 'vw_prop_casino_slot_06a_reels',
		prop2 = 'vw_prop_casino_slot_06b_reels',
	},	
	
	
	
	[9] = { -- Shoot First
		pos = vector3(974.48059082031, 63.07453918457, 74.731216430664),
		bet = 2500,
		prop = 'vw_prop_casino_slot_03a',
		prop1 = 'vw_prop_casino_slot_03a_reels',
		prop2 = 'vw_prop_casino_slot_03b_reels',
	},
	[10] = { -- Shoot First
		pos = vector3(978.80773925781, 66.921783447266, 74.740577697754),
		bet = 2500,
		prop = 'vw_prop_casino_slot_03a',
		prop1 = 'vw_prop_casino_slot_03a_reels',
		prop2 = 'vw_prop_casino_slot_03b_reels',
	},
	[11] = { -- Shoot First
		pos = vector3(971.17065429688, 72.150833129883, 74.73868560791),
		bet = 2500,
		prop = 'vw_prop_casino_slot_03a',
		prop1 = 'vw_prop_casino_slot_03a_reels',
		prop2 = 'vw_prop_casino_slot_03b_reels',
	},
	
	
	
	[12] = { -- Fame or Shame
		pos = vector3(969.24456787109, 67.345886230469, 74.736198425293),
		bet = 2500,
		prop = 'vw_prop_casino_slot_04a',
		prop1 = 'vw_prop_casino_slot_04a_reels',
		prop2 = 'vw_prop_casino_slot_04b_reels',
	},
	[13] = { -- Fame or Shame
		pos = vector3(978.44470214844, 67.645492553711, 74.738159179688),
		bet = 2500,
		prop = 'vw_prop_casino_slot_04a',
		prop1 = 'vw_prop_casino_slot_04a_reels',
		prop2 = 'vw_prop_casino_slot_04b_reels',
	},
	


	[14] = { -- Angel of the knight
		pos = vector3(970.52551269531, 72.978073120117, 74.730865478516),
		bet = 2500,
		prop = 'vw_prop_casino_slot_01a',
		prop1 = 'vw_prop_casino_slot_01a_reels',
		prop2 = 'vw_prop_casino_slot_01b_reels',
	},
	[15] = { -- Angel of the knight
		pos = vector3(971.29016113281, 72.839576721191, 74.74063873291),
		bet = 2500,
		prop = 'vw_prop_casino_slot_01a',
		prop1 = 'vw_prop_casino_slot_01a_reels',
		prop2 = 'vw_prop_casino_slot_01b_reels',
	},
	[16] = { -- Angel of the knight
		pos = vector3(974.39739990234, 64.468574523926, 74.72876739502),
		bet = 2500,
		prop = 'vw_prop_casino_slot_01a',
		prop1 = 'vw_prop_casino_slot_01a_reels',
		prop2 = 'vw_prop_casino_slot_01b_reels',
	},
	


	[17] = { -- Impotent Rage
		pos = vector3(970.44403076172, 72.202575683594, 74.732772827148),
		bet = 2500,
		prop = 'vw_prop_casino_slot_02a',
		prop1 = 'vw_prop_casino_slot_02a_reels',
		prop2 = 'vw_prop_casino_slot_02b_reels',
	},
	[18] = { -- Impotent Rage
		pos = vector3(975.13122558594, 63.770801544189, 74.737648010254),
		bet = 2500,
		prop = 'vw_prop_casino_slot_02a',
		prop1 = 'vw_prop_casino_slot_02a_reels',
		prop2 = 'vw_prop_casino_slot_02b_reels',
	},



	[19] = { -- Evacuator
		pos = vector3(976.42083740234, 72.456115722656, 74.737419128418),
		bet = 5000,
		prop = 'vw_prop_casino_slot_08a',
		prop1 = 'vw_prop_casino_slot_08a_reels',
		prop2 = 'vw_prop_casino_slot_08b_reels',
	},
	[20] = { -- Evacuator
		pos = vector3(976.24975585938, 73.238677978516, 74.733192443848),
		bet = 5000,
		prop = 'vw_prop_casino_slot_08a',
		prop1 = 'vw_prop_casino_slot_08a_reels',
		prop2 = 'vw_prop_casino_slot_08b_reels',
	},
	
}




Config.Wins = { -- DO NOT TOUCH IT
	[1] = '2',
	[2] = '3',
	[3] = '6',
	[4] = '2',
	[5] = '4',
	[6] = '1',
	[7] = '6',
	[8] = '5',
	[9] = '2',
	[10] = '1',
	[11] = '3',
	[12] = '6',
	[13] = '7',
	[14] = '1',
	[15] = '4',
	[16] = '5',
}