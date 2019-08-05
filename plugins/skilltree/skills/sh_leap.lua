SKILL.name = "Leap"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {
    "dash"
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_heroicleap.png"
SKILL.category = "Path of Blood"

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaos_warrior",
}
SKILL.desc = [[
This skill enables leaping for your character. You access leaping by pressing your slow walk button (ALT).
Leap distance and stamina cost improves with a higher strength and endurance value.

Incompatible: Dash
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: All
]]