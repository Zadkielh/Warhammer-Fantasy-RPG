SKILL.name = "Natural Armor II"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 10
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {
    "naturalarmor_1"
}
SKILL.icon = "vgui/skills/ability_warrior_defensivestance_2.png"
SKILL.category = "Tactical"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE


SKILL.desc = [[
You gain 30 armorrating.
Ability Slot: Passive

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Tactical
]]

local function onAquire(SKILL, char)
    local naturalArmorRating = char:getData("naturalArmorRating", 0)
    naturalArmorRating = naturalArmorRating + 30
    char:setData("naturalArmorRating", naturalArmorRating)
end

SKILL.onAquire = onAquire