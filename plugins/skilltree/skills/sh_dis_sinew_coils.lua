SKILL.name = "Sinew Coils"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 5
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sta_hardened_armor.png"
SKILL.category = "Primaris"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
SKILL.class = {
    "reiver",
    "intercessor",
    "aggressor",
    "inceptor"
}

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE


SKILL.desc = [[
You gain an additional 50 armor rating.  - Idea by Splinters
Ability Slot: Passive

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Primaris Classes
]]

local function onAquire(SKILL, char)
    local naturalArmorRating = char:getData("naturalArmorRating", 0)
    naturalArmorRating = naturalArmorRating + 50
    char:setData("naturalArmorRating", naturalArmorRating)
end

SKILL.onAquire = onAquire