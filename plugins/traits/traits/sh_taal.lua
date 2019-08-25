TRAIT.name = "The Path of the Wild"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 3
TRAIT.SkillPointCost = 1
TRAIT.Incompatible = {

}
TRAIT.Incompatible = {
    "tzeentch",
    "khorne",
    "undivided",
    "taal",
    "slaanesh",
    "sigmar",
    "nurgle",
    "moor",
}
TRAIT.icon = "vgui/skills/ability_ambush.png"
TRAIT.category = "Blessings of Taal"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
TRAIT.faction = FACTION_EMPIRE

TRAIT.desc = [[
Followers of Taal are adept in nature and have evolved to become faster and more durable. 

Speed: +50
Health Regen: +5

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]

local function onAquire(TRAIT, char)
    local naturalSpeed = char:getData("naturalSpeed")
    local naturalHPRegen = char:getData("naturalHPRegen")
    char:setData("naturalSpeed", naturalSpeed + 50)
    char:setData("naturalHPRegen", naturalHPRegen + 5)
end

TRAIT.onAquire = onAquire