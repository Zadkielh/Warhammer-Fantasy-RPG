local PANEL = {}
    local paintFunctions = {}
    paintFunctions[0] = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)
    end
    paintFunctions[1] = function(this, w, h)
    end

	local HIGHLIGHT = Color(255, 255, 255, 50)
 
    function PANEL:Init()

		nut.gui.partyInfo = self
		
		local char = LocalPlayer():getChar()
		local party = nut.party.list[char:getParty()]
		for k, v in pairs(nut.party.list) do
			print(k, v)
		end
		
		self:SetSize(self:GetParent():GetSize())
        self:SetAlpha(0)
		self:AlphaTo(255, 0.25, 0)
		self:DockPadding(50, 50, 50, 25)

		if !(party) then
			self:NoParty(self)
		else
			self.background = self:Add("DHTML")
			self.background:SetSize(128, 128)
			self.background:SetHTML(party.image)

			self.background.OnDocumentReady = function(background)
				self.bgLoader:AlphaTo(0, 2, 1, function()
					self.bgLoader:Remove()
				end)
			end
			self.background:MoveToBack()
			self.background:SetZPos(-999)

			self.bgLoader = self:Add("DPanel")
			self.bgLoader:SetSize(ScrW(), ScrH())
			self.bgLoader:SetZPos(-998)
			self.bgLoader.Paint = function(loader, w, h)
				surface.SetDrawColor(20, 20, 20)
				surface.DrawRect(0, 0, w, h)
			end
		end
		
	end

	local PADDING = 5

	function PANEL:NoParty(panel)
			
		panel.help = panel:Add("DPanel")
		panel.help:Dock(FILL)

		local helpTitle = panel.help:Add("DLabel")
		helpTitle:SetFont("nutCharSubTitleFont")
		helpTitle:SetTextColor(color_white)
		helpTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpTitle:SetText("No Party found!")
		helpTitle:SizeToContents()
		helpTitle:Dock(TOP)
		helpTitle:DockMargin(650,0,0,100)
		
		
		local helpDesc = panel.help:Add("DLabel")
		helpDesc:Dock(TOP)
		helpDesc:DockMargin(50,10,50,0)
		helpDesc:SetText( "No party was found, you can either make your own party or join someone elses party. Joining someone else requires an invite. Invites can be accessed in this menu." )
		helpDesc:SetTextColor(color_white)
		helpDesc:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpDesc:SetWrap(true)
		helpDesc:SetAutoStretchVertical(true)
		helpDesc:SetFont("CenturyGothicSmall")
		helpDesc:DockMargin(550,0,550,100)

		local AquireButton = panel.help:Add("DButton")
		AquireButton:SetText( "Create New Party" )	
		AquireButton:SetFont("nutCharSubTitleFont")				// Set the text on the button
		AquireButton:Dock(TOP)
		AquireButton:SetTextColor(Color(255,200,50,200))
		AquireButton:DockMargin(500,0,500,10)
		AquireButton.DoClick = function()
			if (LocalPlayer():getChar()) then
				self:CreateParty(panel)
				panel.help:Remove()
			end
		end
		
		AquireButton.OnCursorEntered = function()
			AquireButton:SetTextColor(Color(255,255,255,255))
		end
		AquireButton.OnCursorExited = function()
			AquireButton:SetTextColor(Color(255,200,50,200))
		end
		AquireButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, AquireButton:GetWide(), AquireButton:GetTall(), Color(10,10,10,150) )
		end

		panel.help.Paint = function(this)
			if !IsValid(panel.help) then return end
			local bg1 = nut.util.getMaterial("vgui/border_bg2.png")	
			surface.SetDrawColor(0, 255, 255, 0)
			--surface.SetMaterial(bg1)
			surface.DrawRect(0, 0, panel.help:GetWide(), panel.help:GetTall())
		end
		
		return panel.help
	end

	function PANEL:CreateParty(panel)
			
		panel.bg = panel:Add("DScrollPanel")
		panel.bg:SetAlpha(0)
		panel.bg:AlphaTo(255, 0.25, 0)
		panel.bg:Dock(FILL)
		panel.bg:GetCanvas():DockPadding(0, 0, 0, 100)
		panel.bg.Paint = function(this)
		end

		local bar = panel.bg:GetVBar()
		function bar:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,10) )
		end
		function bar.btnUp:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,50) )
		end
		function bar.btnDown:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,50) )
		end
		function bar.btnGrip:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,100) )
		end

		nut.gui.partyInfo = {}
		nut.gui.partyInfo.members = {}

		local helpTitle = panel.bg:Add("DTextEntry")
		helpTitle:SetTextColor(Color(255,255,255))
		helpTitle:SetFont("CenturyGothicMedium")
		helpTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpTitle:SetText("Party Name")
		helpTitle:SetSize( 100, 70 )
		helpTitle:Dock(TOP)
		helpTitle:DockMargin(500,50,500,0)
		helpTitle.OnValueChange = function(_, value)
			nut.gui.partyInfo.name = value
		end
		helpTitle.Paint = self.paintTextEntry
		helpTitle:SetUpdateOnType(true)

		local partyImageEntry = panel.bg:Add("DTextEntry")
		partyImageEntry:SetTextColor(Color(255,255,255))
		partyImageEntry:SetFont("CenturyGothicSmall")
		partyImageEntry:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		partyImageEntry:SetText("URL for Image")
		partyImageEntry:SetSize( 100, 20 )
		partyImageEntry:Dock(TOP)
		partyImageEntry:DockMargin(500,10,500,0)
		partyImageEntry.OnEnter = function( self )
			if (panel.image) then
				panel.image:SetHTML([[
					<html>
						<body style="margin: 0; padding: 0; overflow: hidden;">
							<img src="]]..self:GetValue()..[[" width="400" height="400" />
						</body>
					</html>
				]])
				nut.gui.partyInfo.image = self:GetValue()
			else
				panel.image = PANEL:OpenURLImage(panel.bg, self:GetValue())
				nut.gui.partyInfo.image = self:GetValue()
			end
		
		end
		partyImageEntry.Paint = self.paintTextEntry

		panel.image = self:OpenURLImage(panel.bg, "")

		local partyDesc = panel.bg:Add("DTextEntry")
		partyDesc:SetTextColor(Color(255,255,255))
		partyDesc:SetFont("CenturyGothicSmall")
		partyDesc:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		partyDesc:SetText("Party Description")
		partyDesc:SetSize( 100, 70 )
		partyDesc:Dock(TOP)
		partyDesc:DockMargin(500,10,500,25)
		partyDesc.OnValueChange = function(_, value)
			nut.gui.partyInfo.Desc = value
		end
		partyDesc.Paint = self.paintTextEntry
		partyDesc:SetUpdateOnType(true)

		local inviteList = panel.bg:Add("DLabel")
		inviteList:SetFont("nutCharSubTitleFont")
		inviteList:SetTextColor(color_white)
		inviteList:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		inviteList:SetText("Invite List")
		inviteList:Dock(TOP)
		inviteList:DockMargin(500,10,500,10)

		local players = player.GetAll()
		for k, v in pairs(players) do
			if !(v == LocalPlayer()) then
				self:addPlayer(v, panel.bg)
			end
		end

		local button = panel.bg:Add( "DButton" )
		button:SetText( "Create Party" )
		button:Dock(TOP)	
		button:DockMargin(ScrW() * 0.25,0,ScrW() * 0.25,0)
		button:SetTall(40)
		button:SetTextColor(Color(255,200,51,200))
		--button:SetWide(420)
		button:SetFont("nutCharSubTitleFont")
		--button:SetWrap(true)
		button.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, button:GetWide(), button:GetTall(), Color(10,10,10,150) )
		end
					
		button.OnCursorEntered = function()
			button:SetTextColor(Color(255,255,255,200))
		end
		button.OnCursorExited = function()
			button:SetTextColor(Color(255,200,51,200))
		end
		button.DoClick = function()
			net.Start("Party.SendPartyTable")
				net.WriteTable(nut.gui.partyInfo)
			net.SendToServer()
		end

		
		return panel.bg
	end

	function PANEL:OpenURLImage(panel, url)
		
		local partyImage = panel:Add("DHTML")
		partyImage:SetSize( 400, 400 )
		partyImage:Dock(TOP)
		partyImage:DockMargin(515,25,515,25)
		partyImage:SetHTML([[
			<html>
				<body style="margin: 0; padding: 0; overflow: hidden;">
					<img src="]]..url..[[" width="400" height="400" />
				</body>
			</html>
		]])
		
		return partyImage
	end

	function PANEL:paintTextEntry(w, h)
		nut.util.drawBlur(self)
		draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,100) )
		self:DrawTextEntryText(color_white, HIGHLIGHT, HIGHLIGHT)
	end

	
function PANEL:addPlayer(ply, panel)
    
	local button = panel:Add( "DButton" )
	button:SetText( "  "..ply:Nick().." ("..ply:steamName()..")" )
	button:Dock(TOP)	
	button:DockMargin(300,10,300,10)
    button:SetTall(40)
	button:SetTextColor(Color(255,200,51,200))
	--button:SetWide(420)
	button:SetFont("nutCharSubTitleFont")
    --button:SetWrap(true)
	button.Paint = function(this)
		draw.RoundedBox( 8, 0, 0, button:GetWide(), button:GetTall(), Color(10,10,10,150) )

		if (button.isSelected or button:IsHovered()) then
			surface.SetDrawColor(Color(255,200,51,200))
			surface.DrawOutlinedRect(0, 0, button:GetWide(), button:GetTall())
		end
	end
                
	button.OnCursorEntered = function()
		button:SetTextColor(Color(255,255,255,200))
	end
	button.OnCursorExited = function()
		button:SetTextColor(Color(255,200,51,200))
	end
    button.DoClick = function()
		nut.gui.partyInfo.members[#nut.gui.partyInfo.members + 1] = ply
    end

	return panel
end


    function PANEL:Paint(w, h)
        nut.util.drawBlur(self)

        surface.SetDrawColor(30, 30, 30, 100)
        surface.DrawRect(0, 0, w, h)
 
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end


vgui.Register("partyInfo", PANEL, "EditablePanel")

local PANEL = {}
    local paintFunctions = {}
    paintFunctions[0] = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)
    end
    paintFunctions[1] = function(this, w, h)
    end

	function PANEL:Paint(w, h)
        --nut.util.drawBlur(self)

        surface.SetDrawColor(30, 30, 30, 100)
        surface.DrawRect(0, 0, w, h)
 
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

	function PANEL:Init()

		nut.gui.partyInvite = self
		
		local char = LocalPlayer():getChar()
		local party = nut.party.list[char:getParty()]
		
		
		self:SetSize(ScrW()*0.3, ScrH()*0.5)
        self:SetAlpha(0)
		self:AlphaTo(255, 0.25, 0)
		self:DockPadding(50, 50, 50, 25)
		self:Center()

		if !(party) then
			self:Invite(self)
		else
			self:Party(self)
		end
		
	end

	function PANEL:Party(panel)
			
		panel.help = panel:Add("DPanel")
		panel.help:Dock(FILL)

		local helpTitle = panel.help:Add("DLabel")
		helpTitle:SetFont("nutCharSubTitleFont")
		helpTitle:SetTextColor(color_white)
		helpTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpTitle:SetText("Invite")
		helpTitle:SizeToContents()
		helpTitle:Dock(TOP)
		helpTitle:DockMargin(650,0,0,100)
		
		
		local helpDesc = panel.help:Add("DLabel")
		helpDesc:Dock(TOP)
		helpDesc:DockMargin(50,10,50,0)
		helpDesc:SetText( "You're already in a party. Please leave your current party to join this one." )
		helpDesc:SetTextColor(color_white)
		helpDesc:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpDesc:SetWrap(true)
		helpDesc:SetAutoStretchVertical(true)
		helpDesc:SetFont("CenturyGothicSmall")
		helpDesc:DockMargin(550,0,550,100)

		local AquireButton = panel.help:Add("DButton")
		AquireButton:SetText( "Close Invite" )	
		AquireButton:SetFont("nutCharSubTitleFont")				// Set the text on the button
		AquireButton:Dock(TOP)
		AquireButton:SetTextColor(Color(255,200,50,200))
		AquireButton:DockMargin(500,0,500,10)
		AquireButton.DoClick = function()
			if (LocalPlayer():getChar()) then
				panel.help:Remove()
			end
		end
		
		AquireButton.OnCursorEntered = function()
			AquireButton:SetTextColor(Color(255,255,255,255))
		end
		AquireButton.OnCursorExited = function()
			AquireButton:SetTextColor(Color(255,200,50,200))
		end
		AquireButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, AquireButton:GetWide(), AquireButton:GetTall(), Color(10,10,10,150) )
		end

		panel.help.Paint = function(this)
			if !IsValid(panel.help) then return end
			local bg1 = nut.util.getMaterial("vgui/border_bg2.png")	
			surface.SetDrawColor(0, 255, 255, 0)
			--surface.SetMaterial(bg1)
			surface.DrawRect(0, 0, panel.help:GetWide(), panel.help:GetTall())
		end
		
		return panel.help
	end

	function PANEL:Invite(panel)
			
		panel.help = panel:Add("DPanel")
		panel.help:Dock(FILL)

		local helpTitle = panel.help:Add("DLabel")
		helpTitle:SetFont("nutCharSubTitleFont")
		helpTitle:SetTextColor(color_white)
		helpTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpTitle:SetText("Invite")
		helpTitle:SizeToContents()
		helpTitle:Dock(TOP)
		helpTitle:DockMargin(650,0,0,100)
		
		
		local helpDesc = panel.help:Add("DLabel")
		helpDesc:Dock(TOP)
		helpDesc:DockMargin(50,10,50,0)
		helpDesc:SetText( "You have been invited to join ".. panel.partyInfo.name)
		helpDesc:SetTextColor(color_white)
		helpDesc:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpDesc:SetWrap(true)
		helpDesc:SetAutoStretchVertical(true)
		helpDesc:SetFont("CenturyGothicSmall")
		helpDesc:DockMargin(550,0,550,100)

		local AquireButton = panel.help:Add("DButton")
		AquireButton:SetText( "Join Party" )	
		AquireButton:SetFont("nutCharSubTitleFont")				// Set the text on the button
		AquireButton:Dock(TOP)
		AquireButton:SetTextColor(Color(255,200,50,200))
		AquireButton:DockMargin(500,0,500,10)
		AquireButton.DoClick = function()
			if (LocalPlayer():getChar()) then
				net.Start("Party.AcceptInvite")
				net.WriteTable(panel.partyInfo)
				net.SendToServer()
				panel.help:Remove()
			end
		end
		
		AquireButton.OnCursorEntered = function()
			AquireButton:SetTextColor(Color(255,255,255,255))
		end
		AquireButton.OnCursorExited = function()
			AquireButton:SetTextColor(Color(255,200,50,200))
		end
		AquireButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, AquireButton:GetWide(), AquireButton:GetTall(), Color(10,10,10,150) )
		end

		panel.help.Paint = function(this)
			if !IsValid(panel.help) then return end
			local bg1 = nut.util.getMaterial("vgui/border_bg2.png")	
			surface.SetDrawColor(0, 255, 255, 0)
			--surface.SetMaterial(bg1)
			surface.DrawRect(0, 0, panel.help:GetWide(), panel.help:GetTall())
		end
		
		return panel.help
	end

vgui.Register("partyInvite", PANEL, "EditablePanel")

net.Receive( "Party.SendInvite", function( len )
	local party = net.ReadTable()
	PANEL.partyInfo = party
	vgui.CreateFromTable( PANEL )
end) 

net.Receive("openParty", function(len)
	vgui.Create("partyInvite")
end)