SKILL.name = "Dash"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 1
SKILL.Incompatible = {
    "leap"
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_rogue_fleetfooted.png"
SKILL.category = "Tactical"

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "apothecary",
    "assault",
    "chaplain",
    "devestator",
    "librarian",
    "tactical",
    "techmarine",
    "inceptor",
	"intercessor",
	"aggressor",
	"reiver"
}

SKILL.desc = [[
This skill enables dashing for your character. You access dashing by pressing your slow walk button.
Dashing distance and stamina cost improves with a higher dexterity and endurance value.

Incompatible: Leap
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: All
]]