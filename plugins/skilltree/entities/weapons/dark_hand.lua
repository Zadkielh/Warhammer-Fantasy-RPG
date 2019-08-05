---- Carry weapon SWEP

AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Dark Hand"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
end

SWEP.Author = "Zadkiel"
SWEP.Instructions = ""
SWEP.Purpose = ""
SWEP.Drop = false

SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.ViewTranslation = 4

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 200
SWEP.Primary.Delay = 0.75

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = Model("models/weapons/c_arms_cstrike.mdl")
SWEP.WorldModel = ""

SWEP.UseHands = false
SWEP.LowerAngles = Angle(0, 5, -14)
SWEP.LowerAngles2 = Angle(0, 5, -22)
SWEP.Category = "Warhammer Fantasy: Magic"
SWEP.Spawnable				= true

SWEP.FireWhenLowered = true
SWEP.HoldType = "fist"

SWEP.holdingEntity			= nil
SWEP.carryHack				= nil
SWEP.constr					= nil
SWEP.prevOwner				= nil

CARRY_STRENGTH_NERD = 1
CARRY_STRENGTH_CHAD = 2
CARRY_STRENGTH_TERMINATOR = 3
CARRY_STRENGTH_GOD = 4

CARRY_FORCE_LEVEL = {
	16500,
	40000,
	100000,
	0,
}
-- not customizable via convars as some objects rely on not being carryable for
-- gameplay purposes
CARRY_WEIGHT_LIMIT = 100

-- I know some people will fuck around with new prop-throwing system. I'm preventing that shit without making it too non-sense
THROW_VELOCITY_CAP = 150
PLAYER_PICKUP_RANGE = 200

--[[
	CARRY_STRENGTH_NERD: 16500 - You can't push player with prop on this strength level.
								the grabbing fails kinda often. the most minge safe strength.
	CARRY_STRENGTH_CHAD: 40000 - You might push player with prop on this strength level.
								the grabbing barley fails.
	CARRY_STRENGTH_TERMINATOR:100000 - You can push player with prop on this strength level.
								the grabbing fail is almost non-existent.
								the the strength is too high, players might able to kill other players
								with prop pushing.
	CARRY_STRENGTH_GOD: 0 - You can push player with prop on this strength levle.
							the grabbing never fails.
							Try this if you're playing with very trustful community.				
]]--

CARRY_FORCE_LIMIT = CARRY_FORCE_LEVEL[CARRY_STRENGTH_CHAD] -- default strength level is CHAD.

if (CLIENT) then
	function SWEP:PreDrawViewModel(viewModel, weapon, client)
		local hands = player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(client:GetModel()))

		if (hands and hands.model) then
			viewModel:SetModel("models/mailer/characters/beserkerarmor_arms.mdl")
			viewModel:SetSkin(hands.skin)
			viewModel:SetBodyGroups(hands.body)
            viewModel:SetMaterial("models/effects/portalrift_sheet")
		end
	end
end

local player = player
local IsValid = IsValid
local CurTime = CurTime

	function SWEP:Think()
		if (CLIENT) then
			if (self.Owner) then
				local viewModel = self.Owner:GetViewModel()

				if (IsValid(viewModel)) then
					viewModel:SetPlaybackRate(1)
				end
			end
		end
	end


function SWEP:PrimaryAttack()
	if (!IsFirstTimePredicted()) then
		return
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local staminaUse = 20

	if (staminaUse > 0) then
		local value = self.Owner:getLocalVar("stm", 0) - staminaUse

		if (value < 0) then
			return
		elseif (SERVER) then
			self.Owner:setLocalVar("stm", value)
		end
	end

	if (SERVER) then
		self.Owner:EmitSound("npc/vort/claw_swing"..math.random(1, 2)..".wav")
	end

	local damage = self.Primary.Damage

	self:doPunchAnimation()

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(self.LastHand + 2, self.LastHand + 5, 0.125))

	self:SetNW2Float( "startTime", CurTime() );
	self:SetNW2Bool( "startPunch", true );
end

function SWEP:OnRemove()
    local viewModel = self.Owner:GetViewModel()
    viewModel:SetMaterial("")
end


function SWEP:Initialize()
	
    timer.Simple(10, function()
        if (IsValid(self)) then
            self:Holster()
        end
    end
    )

	self:SetHoldType(self.HoldType)
	self.LastHand = 0
end

ACT_VM_FISTS_DRAW = 3
ACT_VM_FISTS_HOLSTER = 2

function SWEP:Deploy()
	if (!IsValid(self.Owner)) then
		return
	end

	local viewModel = self.Owner:GetViewModel()

	if (IsValid(viewModel)) then
		viewModel:SetPlaybackRate(1)
		viewModel:ResetSequence(ACT_VM_FISTS_DRAW)
        viewModel:SetMaterial("models/effects/portalrift_sheet")
	end

	return true
end

function SWEP:Holster()
	if (!IsValid(self.Owner)) then
		return
	end

	local viewModel = self.Owner:GetViewModel()

	if (IsValid(viewModel)) then
		viewModel:SetPlaybackRate(1)
		viewModel:ResetSequence(ACT_VM_FISTS_HOLSTER)
        viewModel:SetMaterial("")
	end
    if (SERVER) then
        self:Remove()
    end
    
    return true
end

function SWEP:Precache()
	util.PrecacheSound("npc/vort/claw_swing1.wav")
	util.PrecacheSound("npc/vort/claw_swing2.wav")
	util.PrecacheSound("physics/plastic/plastic_box_impact_hard1.wav")
	util.PrecacheSound("physics/plastic/plastic_box_impact_hard2.wav")
	util.PrecacheSound("physics/plastic/plastic_box_impact_hard3.wav")
	util.PrecacheSound("physics/plastic/plastic_box_impact_hard4.wav")
	util.PrecacheSound("physics/wood/wood_crate_impact_hard2.wav")
	util.PrecacheSound("physics/wood/wood_crate_impact_hard3.wav")
end

function SWEP:doPunchAnimation()
	self.LastHand = math.abs(1 - self.LastHand)

	local sequence = 4 + self.LastHand
	local viewModel = self.Owner:GetViewModel()

	if (IsValid(viewModel)) then
		viewModel:SetPlaybackRate(0.5)
		viewModel:SetSequence(sequence)
	end

	if(self:GetNW2Bool( "startPunch", false )) then
		if( CurTime() > self:GetNW2Float( "startTime", CurTime() ) + 0.055 ) then
			self:doPunch();
			self:SetNW2Bool( "startPunch", false );
			self:SetNW2Float( "startTime", 0 );
		end
	end
end

function SWEP:doPunch()
	if (IsValid(self) and IsValid(self.Owner)) then
		local damage = self.Primary.Damage
		local context = {damage = damage}

		self.Owner:LagCompensation(true)
			local data = {}
				data.start = self.Owner:GetShootPos()
				data.endpos = data.start + self.Owner:GetAimVector()*96
				data.filter = self.Owner
			local trace = util.TraceLine(data)

			if (SERVER and trace.Hit) then
				local entity = trace.Entity

				if (IsValid(entity)) then
					local damageInfo = DamageInfo()
						damageInfo:SetAttacker(self.Owner)
						damageInfo:SetInflictor(self)
						damageInfo:SetDamage(damage)
						damageInfo:SetDamageType(DMG_SLASH)
						damageInfo:SetDamagePosition(trace.HitPos)
						damageInfo:SetDamageForce(self.Owner:GetAimVector()*50000)
					entity:DispatchTraceAttack(damageInfo, data.start, data.endpos)

					self.Owner:EmitSound("physics/body/body_medium_impact_hard"..math.random(1, 6)..".wav", 80)
				end
			end
		self.Owner:LagCompensation(false)
	end
end
