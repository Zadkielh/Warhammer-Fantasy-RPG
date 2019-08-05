ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Krak Grenade"
ENT.Author 			= "DrVrej (Repurposed by Zadkiel)"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false

if (CLIENT) then
	local Name = "Frag Grenade"
	local LangName = "obj_40k_grenade_krak"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end