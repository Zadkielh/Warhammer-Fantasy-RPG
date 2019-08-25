TRAIT.name = "The Path of Pleasure"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 5
TRAIT.SkillPointCost = 0
TRAIT.Incompatible = {
    "khorne",
    "nurgle",
    "undivided",
    "tzeentch"
}

TRAIT.RequiredTraits = {

}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Slaanesh"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
TRAIT.faction = FACTION_CHAOS
TRAIT.desc = [[
This trait is the entry trait for the slaanesh tree. This one locks out all the other gods aswell as the undivided advanced traits.

Attrib Boost: + 5 Dexterity
Damage: +50

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]
TRAIT.class = {
    "chaos_warrior",
    "sh_reaver",
    "asp_sorcerer"
}

local function onAquire(TRAIT, char)
    local naturalDamage = char:getData("naturalDamage", 0)
    char:setData("naturalDamage", naturalDamage + 50)

    local attribBoost = char:getData("slaaneshAttribBoost")
    if attribBoost then
        return
    else
        char:setData("slaaneshAttribBoost", true)
        char:setAttrib("dex", char:getAttrib("dex") + 5)
    end
end

TRAIT.onAquire = onAquire