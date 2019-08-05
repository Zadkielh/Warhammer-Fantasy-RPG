SKILL.name = "Natural Armor I"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 3
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
SKILL.category = "Tactical"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE


SKILL.desc = [[
You gain 25 armorrating.
Ability Slot: Passive

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Tactical
]]

local function onAquire(SKILL, char)
    local naturalArmorRating = char:getData("naturalArmorRating", 0)
    naturalArmorRating = naturalArmorRating + 25
    char:setData("naturalArmorRating", naturalArmorRating)
end

SKILL.onAquire = onAquire