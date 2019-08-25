TRAIT.name = "The Path of Faith"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 3
TRAIT.SkillPointCost = 1
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
TRAIT.RequiredTraits = {

}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Sigmar"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
TRAIT.faction = FACTION_EMPIRE

TRAIT.desc = [[
This trait is the entry trait for the Sigmar tree. This one locks out all the other gods.

Attrib Boost: +10 Faith

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]

local function onAquire(TRAIT, char)
    local attribBoost = char:getData("sigmarAttribBoost")
    if attribBoost then
        return
    else
        char:setData("sigmarAttribBoost", true)
        char:setAttrib("fth", char:getAttrib("fth") + 10)
    end
end

TRAIT.onAquire = onAquire