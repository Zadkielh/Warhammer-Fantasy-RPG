TRAIT.name = "The Path of Dead"

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
TRAIT.category = "Blessings of Morr"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
TRAIT.faction = FACTION_EMPIRE

TRAIT.desc = [[
This trait is the entry trait for the Morr tree. This one locks out all the other gods aswell as the undivided advanced traits.

Attrib Boost: +5 Faith
Attrib Boost: +5 Magic Power

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]
local function onAquire(TRAIT, char)
    local attribBoost = char:getData("morrAttribBoost")
    if attribBoost then
        return
    else
        char:setData("morrAttribBoost", true)
        char:setAttrib("fth", char:getAttrib("fth") + 5)
        char:setAttrib("mgc", char:getAttrib("mgc") + 5)
    end
end

TRAIT.onAquire = onAquire