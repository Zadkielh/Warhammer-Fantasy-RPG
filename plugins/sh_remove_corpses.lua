PLUGIN.name = "Corpse Remover"
PLUGIN.desc = "Removes corpses"
PLUGIN.author = "!bok"


function PLUGIN:OnNPCKilled()
    timer.Simple(4, function()
        game.RemoveRagdolls()
        for id, ent in pairs( ents.FindByClass( "prop_ragdoll" )) do 
            ent:Remove() 
        end
    end)
end