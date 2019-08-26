SKILL.name = "Infiltration III"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 20
SKILL.SkillPointCost = 4
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {
    "infiltration_2"
}
SKILL.icon = "vgui/skills/Dow2_sm_infiltrate_3.png"
SKILL.category = "Stealth"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
SKILL.class = {
    "tactical",
    "ist_specialist",
	"reiver"
}

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE


SKILL.desc = [[
Infiltration duration is increased to 20 seconds and your attacks within 5 seconds of leaving stealth deals 2x (+1.0 Marksmanship) damage. - Inspired by Wikkyd.

Ability Slot: Passive

Requires: Infiltration II

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Tactical, Reiver, IST Specialist
]]
