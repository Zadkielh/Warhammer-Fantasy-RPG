SKILL.name = "Thunderbolt of Urannon"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_fire_flamebolt.png"
SKILL.category = "Lore of Heavens"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "celestial_wizard"
}

SKILL.desc = [[
Razor-sharp shards of ice hurl from the chill skies to blind and dishearten the foe.

Ability Slot: 2
Class Restriction: Bright Wizard

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 2

local function ability(SKILL, ply )
   local nospam = ply:GetNWBool( "nospamRanged" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
	ply:setLocalVar("mana", mana - 20)

	local BoneID = ply:LookupBone( "ValveBiped.Bip01_R_Hand" )
	local MainPos = ply:GetBonePosition(BoneID)
	
	local Ent = ents.Create("sent_zad_urannon")
			
	local OwnerPos = ply:GetShootPos()
	local OwnerAng = ply:GetAimVector():Angle()
	OwnerPos = OwnerPos + OwnerAng:Forward()*-20 + OwnerAng:Up()*-9 + OwnerAng:Right()*10
		
	if ply:IsPlayer() then Ent:SetAngles(OwnerAng) else Ent:SetAngles(ply:GetAngles()) end


	local BoneID = ply:LookupBone( "ValveBiped.Bip01_R_Hand" )
	Ent:SetPos(MainPos)

	local ent = nil 
	if ply:GetEyeTrace().Entity:IsPlayer() or ply:GetEyeTrace().Entity:IsNPC() then
		ent = ply:GetEyeTrace().Entity
	else
		local Ents = ents.FindInCone(ply:EyePos(), ply:GetAimVector(), 500, math.cos(math.rad(120)))
		for k, v in pairs(Ents) do
			if ((v:IsPlayer() and v != ply) or v:IsNPC()) then
				ent = v
			end
		end
	end


	Ent:SetOwner(ply)
	Ent:Spawn()
	Ent.InitialTarget = ent
			
	if (SERVER) then
		ply:SetNWBool( "nospamRanged", true )
		print("Cdstart")

		net.Start( "RangedActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
			timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamRanged", false )
			end)

	end
end

SKILL.ability = ability