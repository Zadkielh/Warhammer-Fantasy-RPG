

-- NPC XP Table
NPC_XP = {

	/*
	["zombie"] = { -- Name of key, useful if we don't want to use for loops
		class = "npc_zombie", -- Class of the NPC, can find it by using copy to clipboard in the q menu.
		value = 1, -- XP Value given when npc is level 1
		name = "Zombie", -- Name of the NPC, can be whatever you want.
		baselevel = 1, -- Lowest Level
		maxlevel = 20, -- Highest Level
		size = true, -- Does the size increase by level?
		damagemulti = 2, -- Damage multiplier, 2 means it does 200% of normal damage at level 100
		xpmulti = 5, -- XP Multiplier, gives 500% xp at level 100 
		healthmulti = 1, Health Multiplier
		},
	*/

	--== Half Life 2 NPCs ==--
	
	["zombie"] = {class = "npc_zombie", value = 1, name = "Zombie", baselevel = 1, maxlevel = 20, size = true, damagemulti = 2, xpmulti = 10, healthmulti = 1},
	["fastzombie"] = {class = "npc_fastzombie", value = 0.75, name = "Fast Zombie", baselevel = 1, maxlevel = 20, size = false, damagemulti = 2, xpmulti = 10, healthmulti = 1},
	["poisonzombie"] = {class = "npc_poisonzombie", value = 1.25, name = "Poision Zombie", baselevel = 1, maxlevel = 20, size = true,  damagemulti = 2, xpmulti = 10, healthmulti = 1},
	["antlion"] = {class = "npc_antlion", value = 1, name = "Antlion", baselevel = 10, maxlevel = 30, size = true,  damagemulti = 8, xpmulti = 10, healthmulti = 1},
	["antlionguard"] = {class = "npc_antlionguard", value = 20, name = "Antlion Guard", baselevel = 20, maxlevel = 50, size = true,  damagemulti = 2, xpmulti = 10, healthmulti = 1},
	["headcrab_black"] = {class = "npc_headcrab_black", value = 0.7, name = "Poision Headcrab", baselevel = 1, maxlevel = 5, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 1},
	["headcrab_poison"] = {class = "npc_headcrab_poison", value = 0.7, name = "Poision Headcrab", baselevel = 1, maxlevel = 5, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 1},
	["headcrab"] = {class = "npc_headcrab", value = 0.5, name = "Headcrab", baselevel = 1, maxlevel = 5, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 1},
	["fastzombie_torso"] = {class = "npc_fastzombie_torso", value = 0.7, name = "Fast Zombie Torso", baselevel = 1, maxlevel = 20, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 1},
	["headcrab_fast"] = {class = "npc_headcrab_fast", value = 0.4, name = "Fast Headcrab", baselevel = 1, maxlevel = 5, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 1},
	["zombie_torso"] = {class = "npc_zombie_torso", value = 0.75, name = "Zombie Torso", baselevel = 1, maxlevel = 20, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 1},
	
	--== 40k SNPC's ==--
	["tarantula"] = {class = "npc_zad_40k_tarantula", value = 0, name = "Tarantula Turret", baselevel = 10, maxlevel = 10, size = true, damagemulti = 1, xpmulti = 0, healthmulti = 1},


	["bloodletter"] = {class = "npc_vj_bloodletter", value = 50, name = "Bloodletter", baselevel = 50, maxlevel = 60, size = true, damagemulti = 2, xpmulti = 5, healthmulti = 1},
	["bloodcrusher"] = {class = "npc_vj_bloodcrusher", value = 105, name = "Bloodcrusher", baselevel = 60, maxlevel = 70, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 1},
	["heraldkhorne"] = {class = "npc_vj_herald", value = 125, name = "Herald Of Khorne", baselevel = 65, maxlevel = 75, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 1},
	// Tyranids
	["carnifex"] = {class = "npc_vj_carnifex", value = 500, name = "Carnifex", baselevel = 35, maxlevel = 75, size = true,  damagemulti = 5, xpmulti = 5, healthmulti = 2},
	["lictor"] = {class = "npc_vj_lictor", value = 50, name = "Lictor", baselevel = 25, maxlevel = 50, size = true,  damagemulti = 5, xpmulti = 5, healthmulti = 2},
	["hormagaunt"] = {class = "npc_vj_hormagaunt", value = 5, name = "Hormagaunt", baselevel = 1, maxlevel = 25, size = true,  damagemulti = 5, xpmulti = 5, healthmulti = 4},
	["swarmlord"] = {class = "npc_vj_swarmlord", value = 1000, name = "Lictor", baselevel = 75, maxlevel = 100, size = true,  damagemulti = 15, xpmulti = 5, healthmulti = 5},
	["termagaunt"] = {class = "npc_vj_termagaunt", value = 5, name = "Termagaunt", baselevel = 1, maxlevel = 25, size = true,  damagemulti = 2, xpmulti = 5, healthmulti = 5},
	["warrior"] = {class = "npc_vj_warrior", value = 25, name = "Warrior", baselevel = 10, maxlevel = 50, size = true,  damagemulti = 5, xpmulti = 5, healthmulti = 5},

	// Eldar
	["avatar"] = {class = "npc_zad_eldar_avatar", value = 750, name = "Avatar of Khaine", baselevel = 75, maxlevel = 100, size = true,  damagemulti = 5, xpmulti = 5, healthmulti = 5},
	["banshee"] = {class = "npc_zad_eldar_banshee", value = 25, name = "Howling Banshee", baselevel = 40, maxlevel = 70, size = true,  damagemulti = 5, xpmulti = 2, healthmulti = 2},
	["farseer"] = {class = "npc_zad_eldar_farseer", value = 250, name = "Howling Banshee", baselevel = 40, maxlevel = 70, size = true,  damagemulti = 2, xpmulti = 2, healthmulti = 2},
	["guardian"] = {class = "npc_zad_eldar_guardian", value = 25, name = "Howling Banshee", baselevel = 40, maxlevel = 70, size = true,  damagemulti = 1, xpmulti = 2, healthmulti = 2},
	
	// Tau
	["firewarrior"] = {class = "npc_zad_firewarrior", value = 25, name = "Firewarrior", baselevel = 25, maxlevel = 50, size = true,  damagemulti = 0.5, xpmulti = 2, healthmulti = 1},
	["stealthwarrior"] = {class = "npc_zad_stealthwarrior", value = 25, name = "Stealthwarrior", baselevel = 15, maxlevel = 50, size = true,  damagemulti = 0.5, xpmulti = 2, healthmulti = 1},

	--== Warhammer Fantasy SNPC's ==--
	["chs_warhound"] = {class = "npc_zad_chs_warhound", value = 5, name = "Chaos Warhound", baselevel = 10, maxlevel = 50, size = true, damagemulti = 2, xpmulti = 5, healthmulti = 1.2},
	["chs_warhound_poison"] = {class = "npc_zad_chs_warhound_poison", value = 7.5, name = "Chaos Warhound (Poison)", baselevel = 10, maxlevel = 50, size = true, damagemulti = 2.5, xpmulti = 5, healthmulti = 1.2},
	["bst_warhound"] = {class = "npc_zad_bst_warhound", value = 2, name = "Feral Warhound", baselevel = 1, maxlevel = 20, size = true, damagemulti = 2, xpmulti = 5, healthmulti = 1},
	["grn_wolf"] = {class = "npc_zad_grn_wolf", value = 2.5, name = "Giant Wolf", baselevel = 5, maxlevel = 25, size = true, damagemulti = 2, xpmulti = 5, healthmulti = 1.5},
	["vmp_dire_wolf"] = {class = "npc_zad_vmp_dire_wolf", value = 5, name = "Vampire Dire Wolf", baselevel = 10, maxlevel = 50, size = true, damagemulti = 2, xpmulti = 5, healthmulti = 1.2},


}


