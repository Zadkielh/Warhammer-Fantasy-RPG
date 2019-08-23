PLUGIN.name = "Equipment"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Equipment"

if (SERVER) then
    
    util.AddNetworkString("lootBoxOpen")

end

nut.command.add("info", {
    adminOnly = false,
    syntax = "",
    onRun = function(client, args)
        net.Start( "openGear" )
		net.Send( client )
    end
})

nut.command.add("skills", {
    adminOnly = false,
    syntax = "",
    onRun = function(client, args)
        net.Start( "openSkills" )
		net.Send( client )
    end
})

nut.command.add("stats", {
    adminOnly = false,
    syntax = "",
    onRun = function(client, args)
        local items = client:getChar():getInv():getItems()
        for k, v in pairs(items) do
            print(v:getItemStats())
        end
    end
})

-- USAGE: local hp, hpregen, armorrating, shield, shieldregen, damage, faction = item:getItemStats()
do
    local charMeta = nut.meta.character

     function charMeta:getArmorRating()
        local items = self:getInv():getItems()
        
        local armorrating = 0
        local naturalArmorRating = self:getData("naturalArmorRating", 0)
        armorrating = armorrating + naturalArmorRating

        for k, v in pairs(items) do
            if v:getData("equip") then
                armorrating = armorrating + v.traits.armorrating
            end
        end

        return armorrating
    end

    function charMeta:getMaxHealth()
        local items = self:getInv():getItems()
        
        local factionHealth = nut.faction.indices[self:getFaction()].health
        local constitutionHealth = factionHealth + (self:getAttrib("con", 0) * 20)
        local classHealth = 0

        if (self:getClass()) then
            classHealth = nut.classes.list[self:getClass()].health
        end

        

        local hp = constitutionHealth + classHealth

        local naturalMaxHP = self:getData("naturalHPMax", 0)
        hp = hp + naturalMaxHP

        for k, v in pairs(items) do
            if v:getData("equip") then
                hp = hp + v.traits.hp
            end
        end
        return hp, constitutionHealth, factionHealth, classHealth
    end

    function charMeta:getDamage()
        local items = self:getInv():getItems()
        
        local damage = 0
        local naturalDamage = self:getData("naturalDamage", 0)
        damage = damage + naturalDamage
        /*
        for k, v in pairs(items) do 
            if v:getData("equip") then
                damage = damage + v.traits.damage
            end
        end
        */

        return damage
    end

    function charMeta:getMaxShield()
        local items = self:getInv():getItems()
        
        local shield = 0
        local naturalShield= self:getData("naturalShield", 0)
        shield = shield + naturalShield
        
        for k, v in pairs(items) do
            if v:getData("equip") then
                shield = shield + v.traits.shield
            end
        end

        return shield
    end

    function charMeta:getShieldRegen()
        local items = self:getInv():getItems()
        
        local shieldregen = 5

        local naturalShieldRegen = self:getData("naturalShieldRegen", 0)
        shieldregen = shieldregen + naturalShieldRegen
        
        for k, v in pairs(items) do
            if v:getData("equip") then
                shieldregen = shieldregen + v.traits.shieldregen
            end
        end

        return shieldregen
    end

    function charMeta:getHealthRegen()
        local items = self:getInv():getItems()
        
        local hpregen = 5

        local naturalhpregen = self:getData("naturalHPRegen", 0)
        hpregen = hpregen + naturalhpregen
        
        for k, v in pairs(items) do
            if v:getData("equip") then
                hpregen = hpregen + v.traits.hpregen
            end
        end

        return hpregen
    end

    local plyMeta = FindMetaTable( "Player" )

    function plyMeta:HealthRegeneration(valueHealth, valueArmor) 
        if (self) then
            local uniqueID = "HPRegen"..self:SteamID()
            local char = self:getChar()
            local items = char:getInv():getItems()

            local valueHealth = valueHealth or 0
            local valueArmor = valueArmor or 0

            local hpregen = 0 
            local shieldregen = 0
            local shield = 0
            local MaxHp = char:getMaxHealth()
            local walkSpeed = self:GetNWFloat("walkSpeed") or 130
            local runSpeed = self:GetNWFloat("runSpeed") or 235

            self:SetMaxHealth(MaxHp)

            for k, v in pairs(items) do
                if v:getData("equip") then
                    hpregen = hpregen + v.traits.hpregen
                    shieldregen = shieldregen + v.traits.shieldregen
                    shield = shield + v.traits.shield
                    if (v.traits.speed) then
                        self:SetWalkSpeed(walkSpeed + v.traits.speed)
                        self:SetRunSpeed(runSpeed + v.traits.speed)
                    end
                end
            end

            

            local hp = (5 + hpregen + valueHealth) * (0.20)
            local shieldreg = (5 + shieldregen + valueArmor) * (0.20)

            if timer.Exists(uniqueID) then
                timer.Remove(uniqueID)
            end
            if !(self:GetNWBool("RegenDisable")) then
                timer.Create(uniqueID, 0.25, 0, function()
                    if IsValid(self) then
                        self:SetHealth(math.Clamp( self:Health() + hp, 0, self:GetMaxHealth() ))
                        self:SetArmor(math.Clamp(self:Armor() + shieldreg, 0, shield))
                    end
                end)
            end
        end
    end

end

if SERVER then
    function PLUGIN:EntityTakeDamage(client, dmg)
        if IsValid(client) and client:IsPlayer() then
            local uniqueID = "HPRegen"..client:SteamID()
            if timer.Exists(uniqueID) then
                timer.Stop(uniqueID)
            end
            if timer.Exists(uniqueID.."HPRegenRestart") then
                timer.Remove(uniqueID.."HPRegenRestart")
            end
            timer.Create(uniqueID.."HPRegenRestart", 5, 1, function()
                timer.Start(uniqueID)
            end)
        end
    end
end


hook.Add("EntityTakeDamage", "gearModifiers", function(Entity, dmg)

	if dmg:GetAttacker():IsPlayer() then
        local char = dmg:GetAttacker():getChar()
        local items = char:getInv():getItems()
        
        local damage = char:getDamage()

        
        dmg:AddDamage(damage)
    end

	if Entity:IsPlayer() then
        local armor = Entity:getChar():getArmorRating() / 5
        dmg:SubtractDamage( armor )
    end

    
end)




hook.Add("PostPlayerLoadout", "EquipmentModifiers", function(client)

    timer.Simple(0.1, function()
    local char = client:getChar()
    local items = char:getInv():getItems()

    client:getChar():setData("naturalArmorRating", 0)
	client:getChar():setData("naturalDamage", 0)
    client:getChar():setData("naturalHPMax", 0)
	client:getChar():setData("naturalShield", 0)
    client:getChar():setData("naturalShieldRegen", 0)
	client:getChar():setData("naturalHPRegen", 0)

    local hp = 0
    local shield = 0
        for k, v in pairs(items) do 
            if v:getData("equip") then
                hp = hp + v.traits.hp
                shield = shield + v.traits.shield
            end
        end

    local _, MaxHp, k, classHealth = char:getMaxHealth()

    client:SetHealth( client:Health() + hp + classHealth)
    client:SetMaxHealth(MaxHp)
    client:SetArmor(shield)
    client:HealthRegeneration()
    end)
end
)