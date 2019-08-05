local PANEL = {}
    local paintFunctions = {}
    paintFunctions[0] = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)
    end
    paintFunctions[1] = function(this, w, h)
    end
 
    function PANEL:Init()

		nut.gui.characterOptions = self
		nut.gui.gear.currentButton = "MELEE"

		local options = {}
		options["abilities"] = {}

		if file.Exists("gearoptions.txt", "DATA") then
			local table = file.Read("gearoptions.txt", "DATA")
			options = util.JSONToTable( table )
		else
			local table = util.TableToJSON( options )
			file.Write( "gearoptions.txt", table )
		end

		self:SetSize(self:GetParent():GetSize())

		self:SetAlpha(0)
		self:AlphaTo(255, 0.25, 0)
		self:DockPadding(100, 50, 100, 50)

		self.ScrollPanel = self:Add("DScrollPanel")
		self.ScrollPanel:Dock( FILL )
		self.ScrollPanel:DockMargin(0, 0, 0, 100)   
		self.ScrollPanel:DockPadding(0, 0, 0, 0)  
		self.ScrollPanel.Paint = function(this)
		end

		local bar = self.ScrollPanel:GetVBar()
		function bar:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,0) )
		end
		function bar.btnUp:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,0) )
		end
		function bar.btnDown:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,0) )
		end
		function bar.btnGrip:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,0) )
		end

		self.backgroundOptionTitle = self.ScrollPanel:Add("DLabel")
		self.backgroundOptionTitle:SetFont("CenturyGothicMedium")
		self.backgroundOptionTitle:SetTextColor(color_white)
		self.backgroundOptionTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.backgroundOptionTitle:SetText("Menu Background")
		self.backgroundOptionTitle:SizeToContentsY()
		self.backgroundOptionTitle:Dock(TOP)
		self.backgroundOptionTitle:DockMargin(0, 0, 0, 20)

		self.backgroundOption = self.ScrollPanel:Add("DComboBox")
		self.backgroundOption:Dock(TOP)
		self.backgroundOption:DockMargin(0, 0, 0, 50)  

		self.backgroundOption:SetValue("Backgrounds")

		self.backgroundOption:AddChoice("Wood Elves", "vgui/tree.png", false)
		self.backgroundOption:AddChoice("Chaos March", "vgui/aspiring1.png", false)
		self.backgroundOption:AddChoice("Blood Knight", "vgui/backgroundfantasy.png", false)
		self.backgroundOption:AddChoice("City", "vgui/city_bg.png", false)
		self.backgroundOption:AddChoice("Dwarves", "vgui/dwarf_bg.png", false)
		self.backgroundOption:AddChoice("Empire", "vgui/empire_bg.png", false)
		self.backgroundOption:AddChoice("Nagash", "vgui/nagash.png", false)
		self.backgroundOption:AddChoice("Sigmar", "vgui/sigmar.png", false)
		self.backgroundOption:AddChoice("Skaven", "vgui/skaven_bg.png", false)
		self.backgroundOption:AddChoice("Vampire Counts", "vgui/vampire.png", false)
		self.backgroundOption:AddChoice("Bretonnia", "vgui/bretonnia_bg.png", false)
		self.backgroundOption:AddChoice("Malekith", "vgui/Malekith.png", false)
		self.backgroundOption:AddChoice("Chaos Knight", "vgui/chaos_knight_2.png", false)
		self.backgroundOption:AddChoice("Chaos Warrior", "vgui/aspiring.png", false)
		self.backgroundOption:AddChoice("Settra", "vgui/nehekara.png", false)
		self.backgroundOption:AddChoice("Nehekara", "vgui/nehekara_2.png", false)
		self.backgroundOption:AddChoice("Lizardmen", "vgui/Lizardmen.png", false)

		self.backgroundOption.OnSelect = function( self, index, value, data )
			nut.gui.gear.backgroundMaterial = nut.util.getMaterial(data)
			options["background"] = data
			file.Write("gearoptions.txt", util.TableToJSON(options))
		end

		self.colourOptionTitle = self.ScrollPanel:Add("DLabel")
		self.colourOptionTitle:SetFont("CenturyGothicMedium")
		self.colourOptionTitle:SetTextColor(color_white)
		self.colourOptionTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.colourOptionTitle:SetText("Menu Button Colour")
		self.colourOptionTitle:SizeToContentsY()
		self.colourOptionTitle:Dock(TOP)
		self.colourOptionTitle:DockMargin(0, 0, 0, 20)

		self.colourOption = self.ScrollPanel:Add("DColorCombo")
		self.colourOption:Dock(TOP)
		self.colourOption:SetColor( Color( 225, 155, 20 ) )
		self.colourOption:DockMargin(0, 0, 0, 20)
		
		self.colourOption.OnValueChanged = function( self, col )
			options["colourButton"] = col
		end

		self.colourOptionButton = self.ScrollPanel:Add("DButton")
		self.colourOptionButton:SetText( "Apply Colour" )	
		self.colourOptionButton:SetFont("CenturyGothicSmall")				// Set the text on the button
		self.colourOptionButton:SetTextColor(Color(255,200,50,200))
		self.colourOptionButton:Dock(TOP)
		self.colourOptionButton:DockMargin(0,10,0,0)

		self.colourOptionButton.DoClick = function()
			nut.gui.gear.buttonColour = options["colourButton"]
			file.Write("gearoptions.txt", util.TableToJSON(options))
		end
		self.colourOptionButton.OnCursorEntered = function()
			self.colourOptionButton:SetTextColor(Color(255,255,255,255))
		end
		self.colourOptionButton.OnCursorExited = function()
			self.colourOptionButton:SetTextColor(Color(255,200,50,200))
		end
		self.colourOptionButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, self.colourOptionButton:GetWide(), self.colourOptionButton:GetTall(), Color(10,10,10,150) )
		end

		self.colourTargetOptionTitle = self.ScrollPanel:Add("DLabel")
		self.colourTargetOptionTitle:SetFont("CenturyGothicMedium")
		self.colourTargetOptionTitle:SetTextColor(color_white)
		self.colourTargetOptionTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.colourTargetOptionTitle:SetText("Target Colour")
		self.colourTargetOptionTitle:SizeToContentsY()
		self.colourTargetOptionTitle:Dock(TOP)
		self.colourTargetOptionTitle:DockMargin(0, 0, 0, 20)

		self.colourTargetOption = self.ScrollPanel:Add("DColorCombo")
		self.colourTargetOption:Dock(TOP)
		self.colourTargetOption:SetColor( Color( 225, 155, 20 ) )
		self.colourTargetOption:DockMargin(0, 0, 0, 20)
		
		self.colourTargetOption.OnValueChanged = function( self, col )
			options["colourTargetButton"] = col
		end

		self.colourTargetOptionButton = self.ScrollPanel:Add("DButton")
		self.colourTargetOptionButton:SetText( "Apply Target Colour" )	
		self.colourTargetOptionButton:SetFont("CenturyGothicSmall")				// Set the text on the button
		self.colourTargetOptionButton:SetTextColor(Color(255,200,50,200))
		self.colourTargetOptionButton:Dock(TOP)
		self.colourTargetOptionButton:DockMargin(0,10,0,0)

		self.colourTargetOptionButton.DoClick = function()
			file.Write("gearoptions.txt", util.TableToJSON(options))
		end
		self.colourTargetOptionButton.OnCursorEntered = function()
			self.colourTargetOptionButton:SetTextColor(Color(255,255,255,255))
		end
		self.colourTargetOptionButton.OnCursorExited = function()
			self.colourTargetOptionButton:SetTextColor(Color(255,200,50,200))
		end
		self.colourTargetOptionButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, self.colourTargetOptionButton:GetWide(), self.colourTargetOptionButton:GetTall(), Color(10,10,10,150) )
		end
		
		self.abilityBinderTitle = self.ScrollPanel:Add("DLabel")
		self.abilityBinderTitle:SetFont("CenturyGothicMedium")
		self.abilityBinderTitle:SetTextColor(color_white)
		self.abilityBinderTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.abilityBinderTitle:SetText("Ability Buttons")
		self.abilityBinderTitle:SizeToContentsY()
		self.abilityBinderTitle:Dock(TOP)
		self.abilityBinderTitle:DockMargin(0, 0, 0, 20)

		self.abilityOption = self.ScrollPanel:Add("DComboBox")
		self.abilityOption:Dock(TOP)
		self.abilityOption:DockMargin(0, 0, 0, 50)  

		self.abilityOption:SetValue("Abilities (Default)")

		self.abilityOption:AddChoice("Melee (1)", "MELEE", false)
		self.abilityOption:AddChoice("Ranged (2)", "RANGED", false)
		self.abilityOption:AddChoice("AOE (3)", "AOE", false)
		self.abilityOption:AddChoice("Ultimate (4)", "ULTIMATE", false)
		self.abilityOption:AddChoice("Follow (5)", "FOLLOW", false)
		self.abilityOption:AddChoice("Command (6)", "COMMAND", false)

		self.abilityOption.OnSelect = function( self, index, value, data )
			nut.gui.gear.currentButton = data
		end

		self.AbilityBinder = self.ScrollPanel:Add("DBinder")
		self.AbilityBinder:Dock(TOP)
		self.AbilityBinder:DockMargin(0, 10, 0, 0)

		self.AbilityBinder.OnChange = function(self, num)
			options[nut.gui.gear.currentButton] = num
			file.Write("gearoptions.txt", util.TableToJSON(options))
			LocalPlayer():ChatPrint( "Succesfully bound: "..input.GetKeyName( num ).." : to Ability: "..nut.gui.gear.currentButton)
		end

		self.networkButton = self.ScrollPanel:Add("DButton")
		self.networkButton:SetText( "Send Option Preferences to server. THIS IS NEEDED FOR KEYBIND CHANGES!" )	
		self.networkButton:SetFont("CenturyGothicSmall")				// Set the text on the button
		self.networkButton:SetTextColor(Color(255,200,50,200))
		self.networkButton:Dock(TOP)
		self.networkButton:DockMargin(0,10,0,0)

		self.networkButton.DoClick = function()
			local table = file.Read("gearoptions.txt", "DATA")
			local compressedTable = util.Compress( table )

			net.Start("TransmitOptionsToServer")
				net.WriteData( compressedTable, 60000 )
			net.SendToServer()
		end
		self.networkButton.OnCursorEntered = function()
			self.networkButton:SetTextColor(Color(255,255,255,255))
		end
		self.networkButton.OnCursorExited = function()
			self.networkButton:SetTextColor(Color(255,200,50,200))
		end
		self.networkButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, self.networkButton:GetWide(), self.networkButton:GetTall(), Color(10,10,10,150) )
		end

	end

    function PANEL:Paint(w, h)
        nut.util.drawBlur(self)

        surface.SetDrawColor(30, 30, 30, 100)
        surface.DrawRect(0, 0, w, h)
 
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end


vgui.Register("optionsGear", PANEL, "EditablePanel")