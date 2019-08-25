SWEP.Base = "tfa_melee_base"
SWEP.Category = "Warhammer Fantasy: Magic"
SWEP.PrintName = "Celestial Staff"
SWEP.ViewModel = "models/zadkiel/weapons/c_oren_katana.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
--SWEP.InspectPos = Vector(17.184, -4.891, -11.902) - SWEP.VMPos
--SWEP.InspectAng = Vector(70, 46.431, 70)
SWEP.WorldModel = "models/zadkiel/weapons/sword_daemonblade.mdl"
SWEP.HoldType = "melee2"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.VMPos = Vector(5, 7, -6)

SWEP.AllowSprintAttack = false

SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_HYBRID-- ANI = mdl, Hybrid = ani + lua, Lua = lua only
SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_loop", --Number for act, String/Number for sequence
		["is_idle"] = true
	},--looping animation
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_out", --Number for act, String/Number for sequence
		["transition"] = true
	} --Outward transition
}
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-10, -2.5, 2.5)


SWEP.CanBlock = true
SWEP.BlockAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_DEPLOY, --Number for act, String/Number for sequence
		["transition"] = true
	}, --Inward transition
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_IDLE_DEPLOYED, --Number for act, String/Number for sequence
		["is_idle"] = true
	},--looping animation
	["hit"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_DEPLOYED, --Number for act, String/Number for sequence
		["is_idle"] = true
	},--when you get hit and block it
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_UNDEPLOY, --Number for act, String/Number for sequence
		["transition"] = true
	} --Outward transition
}
SWEP.BlockCone = 360 --Think of the player's view direction as being the middle of a sector, with the sector's angle being this
SWEP.BlockDamageMaximum = 0.0 --Multiply damage by this for a maximumly effective block
SWEP.BlockDamageMinimum = 0.0 --Multiply damage by this for a minimumly effective block
SWEP.BlockTimeWindow = 1 --Time to absorb maximum damage
SWEP.BlockTimeFade = 0.5 --Time for blocking to do minimum damage.  Does not include block window
SWEP.BlockSound = Sound("block_1.wav")
SWEP.BlockDamageCap = 500
SWEP.BlockDamageTypes = {
	DMG_SLASH,DMG_CLUB, DMG_BULLET, DMG_BURN, DMG_BLAST
}

SWEP.Secondary.CanBash = true
SWEP.Secondary.BashDamage = 120
SWEP.Secondary.BashDelay = 0.1
SWEP.Secondary.BashLength = 60 * 3

SWEP.SequenceLengthOverride = {
	[ACT_VM_HITCENTER] = 0.8
}

SWEP.ViewModelBoneMods = {
	["RW_Weapon"] = { scale = Vector(0.01, 0.01, 0.01), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}
SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/zadkiel/empire/weapons/emp_wizard_staff.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {[0] = 6} }
}
SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/zadkiel/empire/weapons/emp_wizard_staff.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 0, -10), angle = Angle(0, -90, -90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {[0] = 6} }
}
SWEP.InspectionActions = {ACT_VM_RECOIL1, ACT_VM_RECOIL2, ACT_VM_RECOIL3}

local DenySound = Sound( "WallHealth.Deny" )


function SWEP:SecondaryAttack()
if (CLIENT) then return end
	local mana = self.Owner:getLocalVar("mana", 0)
	if mana < 15 then
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
		self.Owner:EmitSound( DenySound )
		return false
			
	else
		self.Owner:setLocalVar("mana", math.max(mana - 15, 0))
	end

	self.Owner:MuzzleFlash()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )


	local SpawnBlaserRod = ents.Create("sent_zad_icebolt")
	local OwnerPos = self.Owner:GetShootPos()
	local OwnerAng = self.Owner:GetAimVector():Angle()
	OwnerPos = OwnerPos + OwnerAng:Forward()*-20 + OwnerAng:Up()*-9 + OwnerAng:Right()*10
	if self.Owner:IsPlayer() then SpawnBlaserRod:SetPos(OwnerPos) else SpawnBlaserRod:SetPos(self:GetAttachment(self:LookupAttachment("missile")).Pos) end
	if self.Owner:IsPlayer() then SpawnBlaserRod:SetAngles(OwnerAng) else SpawnBlaserRod:SetAngles(self.Owner:GetAngles()) end
	SpawnBlaserRod:SetOwner(self.Owner)
	SpawnBlaserRod:Activate()
	SpawnBlaserRod:Spawn()
	
	local phy = SpawnBlaserRod:GetPhysicsObject()
	if phy:IsValid() then
		if self.Owner:IsPlayer() then
		phy:ApplyForceCenter(self.Owner:GetAimVector() * 20000) else //200000
		//phy:ApplyForceCenter((self.Owner:GetEnemy():GetPos() - self.Owner:GetPos()) * 4000)
		phy:ApplyForceCenter(((self.Owner:GetEnemy():GetPos()+self.Owner:GetEnemy():OBBCenter()+self.Owner:GetEnemy():GetUp()*-45) - self.Owner:GetPos()+self.Owner:OBBCenter()+self.Owner:GetEnemy():GetUp()*-45) * 4000)
		//data.Dir = (Entity:GetEnemy():GetPos()+Entity:GetEnemy():OBBCenter()+Entity:GetEnemy():GetUp()*-45) -Entity:GetPos()+Entity:OBBCenter()+Entity:GetEnemy():GetUp()*-45
		end
	end
end

function SWEP:ShouldDropOnDie()
	return false
end
-- function SWEP:Reload() --To do when reloading
-- end 
 
SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = math.random(51,71), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.3, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_light_1.wav"), -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(5, 0, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "F", --Swing dir,
		["combotime"] = 0.1,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
		{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(75, 0, 0), -- Trace arc cast
		["dmg"] = math.random(51,71), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.3, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_light_1.wav"), -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "R", --Swing dir,
		["combotime"] = 0.2,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(-75, 0, 0), -- Trace arc cast
		["dmg"] = math.random(51,71), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.3, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_light_1.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "L", --Swing dir,
		["combotime"] = 0.2,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
	{
		["act"] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(0, 20, 70), -- Trace arc cast
		["dmg"] = math.random(51,71), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.3, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_light_1.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(-5, 0, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "B", --Swing dir,
		["combotime"] = 0.2,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	}
}

 
function SWEP:Deploy()
return true;
end

function SWEP:Holster()
return true;
end