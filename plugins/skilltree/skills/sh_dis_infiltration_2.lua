SKILL.name = "Infiltration II"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 15
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {
    "lightveil"
}
SKILL.icon = "vgui/skills/Dow2_sm_infiltrate_2.png"
SKILL.category = "Stealth"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
SKILL.class = {
    "tactical",
    "ist_specialist",
	"reiver"
}

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE


SKILL.desc = [[
Infiltration duration is increased to 10 seconds. - Inspired by Wikkyd.

Ability Slot: Passive

Requires: Infiltration 

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Tactical, Reiver, IST Specialist
]]
