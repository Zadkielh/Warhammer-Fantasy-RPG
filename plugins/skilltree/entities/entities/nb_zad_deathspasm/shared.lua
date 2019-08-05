ENT.Type 			= "nextbot"
ENT.Base 			= "base_nextbot"
ENT.PrintName		= "Dreadnought Missile"
ENT.Author 			= "Zadkiel"
ENT.Contact 		= ""
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if (CLIENT) then
	local Name = "Dreadnought Missile"
	local LangName = "obj_vj_dread_missile"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
