SKILL.name = "Last Breath"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_sprint.png"
SKILL.category = "Tactical"

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "tactical",
}

SKILL.desc = [[
When you become severly injured you gain a short speed boost for a short duration. - Inspired by Shield

Duration: 5 Seconds.
Cost: No Cost.
Cooldown: 60 Seconds.
Class Restriction: Tactical
Ability Slot: Passive

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

]]




local function onAquire(SKILL, char)
    char:getPlayer():SetNWBool("lastBreath", false)
end

SKILL.onAquire = onAquire