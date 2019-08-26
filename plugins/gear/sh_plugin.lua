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
        local tempArmorRating = math.max(0,self:getData("tempArmorRating", 0) - naturalArmorRating)
        armorrating = armorrating + naturalArmorRating + tempArmorRating

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
        local constitutionHealth = factionHealth + (self:getAttrib("con", 0) * 100)
        local levelHealth = (100 * self:getLevel()) + (8 * self:getLevel() * self:getLevel())
        local classHealth = 0

        if (self:getClass()) then
            classHealth = nut.classes.list[self:getClass()].health
        end

        

        local hp = constitutionHealth + classHealth + levelHealth

        local naturalMaxHP = self:getData("naturalHPMax", 0)
        local tempMaxHP = math.max(0,self:getData("tempHPMax", 0) - naturalMaxHP)
        hp = hp + naturalMaxHP + tempMaxHP

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
        local tempDamage = math.max(0,self:getData("tempDamage", 0) - naturalDamage)
        local str = self:getAttrib("str") / 100
        damage = (damage + naturalDamage + tempDamage) * (1 + str)
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
        local tempShield = math.max(0,self:getData("tempShield", 0) - naturalShield)
        shield = shield + naturalShield + tempShield
        
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
        local tempShieldRegen = math.max(0,self:getData("tempShieldRegen", 0) - naturalShieldRegen)
        shieldregen = shieldregen + naturalShieldRegen + tempShieldRegen
        
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
        local temphpregen = math.max(0,self:getData("tempHPRegen", 0) - naturalhpregen)
        hpregen = hpregen + naturalhpregen + temphpregen
        
        for k, v in pairs(items) do
            if v:getData("equip") then
                hpregen = hpregen + v.traits.hpregen
            end
        end

        return hpregen
    end

    function charMeta:getSpeed()
        local items = self:getInv():getItems()
        
        local speed = 0

        local naturalSpeed = self:getData("naturalSpeed", 0)
        local tempSpeed = math.max(0,self:getData("tempSpeed", 0) - naturalSpeed)
        speed = speed + naturalSpeed + tempSpeed
        
        for k, v in pairs(items) do
            if v:getData("equip") then
                if (type(v.traits.speed)) == "number" then
                    speed = speed + v.traits.speed
                end
            end
        end

        return speed
    end

    local plyMeta = FindMetaTable( "Player" )

    function plyMeta:HealthRegeneration(valueHealth, valueArmor) 
        if (self) then
            local uniqueID = "HPRegen"..self:SteamID()
            local char = self:getChar()
            local items = char:getInv():getItems()

            local valueHealth = valueHealth or 0
            local valueArmor = valueArmor or 0

            local hpregen = char:getHealthRegen() 
            local shieldregen = char:getShieldRegen()
            local shield = char:getMaxShield()
            local MaxHp = char:getMaxHealth()
            local speed = char:getSpeed()
            local walkSpeed = 130
            local runSpeed = 235

            self:SetMaxHealth(MaxHp)
            self:SetWalkSpeed(walkSpeed + speed)
            self:SetRunSpeed(runSpeed + speed)

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
    
    local char = client:getChar()
    local items = char:getInv():getItems()

    client:SetNWFloat("runSpeed", 235)
	client:SetNWFloat("walkSpeed", 130)

    client:getChar():setData("naturalSpeed", 0)
    client:getChar():setData("naturalArmorRating", 0)
	client:getChar():setData("naturalDamage", 0)
    client:getChar():setData("naturalHPMax", 0)
	client:getChar():setData("naturalShield", 0)
    client:getChar():setData("naturalShieldRegen", 0)
	client:getChar():setData("naturalHPRegen", 0)
    client:getChar():setData("bloodpool", 0)
	client:getChar():setData("lifeSteal", 0)

    client:getChar():setData("tempSpeed", 0)
    client:getChar():setData("tempArmorRating", 0)
    client:getChar():setData("tempDamage", 0)
    client:getChar():setData("tempHPMax", 0)
    client:getChar():setData("tempShield", 0)
    client:getChar():setData("tempShieldRegen", 0)
    client:getChar():setData("tempHPRegen", 0)
    client:getChar():setData("tempbloodpool", 0)
    client:getChar():setData("templifeSteal", 0)

    local hp = 0
    local shield = 0
        for k, v in pairs(items) do 
            if v:getData("equip") then
                hp = hp + v.traits.hp
                shield = shield + v.traits.shield
            end
        end

    for k, v in pairs(client:getChar():getTraits()) do
		local trait = nut.traits.list[k]
		if (trait.onAquire) then
			trait.onAquire(trait, client:getChar())
		end
	end

    for k, v in pairs(client:getChar():getSkills()) do
		local skill = nut.skills.list[k]
		if (skill.onAquire) then
			skill.onAquire(skill, client:getChar())
		end
	end

    local MaxHP, ConHealth, FactionHealth, classHealth = char:getMaxHealth()
    client:SetHealth( MaxHP )
    client:SetMaxHealth(MaxHP)
    client:SetArmor(shield)


    
    client:HealthRegeneration()
end
)