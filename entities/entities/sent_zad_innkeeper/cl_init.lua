if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('shared.lua')
/*--------------------------------------------------
	=============== Test Entity ===============
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to Test Things
--------------------------------------------------*/
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:Draw() self:DrawModel() end

function OpenTheMenuCode()
	local RandomWelcomeText = {}
	RandomWelcomeText[2] = "Hello "..LocalPlayer():GetName()..", You need anything?"
	RandomWelcomeText[3] = "What can I do for you "..LocalPlayer():GetName().."?"
	//local ent = net.ReadEntity()

	//ent.MenuOpen = true
	local MenuFrame = vgui.Create('DFrame')
	MenuFrame:SetSize(600, 300)
	MenuFrame:Center()
	MenuFrame:SetTitle('Innkeeper')
	//MenuFrame:SetBackgroundBlur(true)
	MenuFrame:SetSizable(true)
	MenuFrame:SetDeleteOnClose(false)
	MenuFrame:MakePopup()
	MenuFrame:DockMargin( 20, 20, 20, 20 )
	MenuFrame:DockPadding( 100,100, 100, 100 )
	MenuFrame.Paint = function(this)
		local bg1 = nut.util.getMaterial("vgui/border_bg2.png")	
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(bg1)
		--surface.DrawTexturedRect(0, 0, ScrW() * 0.23, ScrH() * 0.05)
		surface.DrawTexturedRect( 0, 0, 600, 300 )
	end
	
	/*local MenuPanel_1 = vgui.Create( "DPanelList", DermaPanel )
	MenuPanel_1:SetPos( 0,0 )
	MenuPanel_1:SetSize( 100, 100 )
	MenuPanel_1:SetSpacing( 5 )
	MenuPanel_1:EnableHorizontal( false )
	MenuPanel_1:EnableVerticalScrollbar( true )
 
    local MenuCategory_1 = vgui.Create("DLabel")
    MenuCategory_1:SetText( "Test" )
    MenuCategory_1:SizeToContents()
	MenuPanel_1:AddItem( MenuCategory_1 )*/

	local MenuTest_1 = vgui.Create("DLabel", MenuFrame)
	MenuTest_1:SetPos(200, 20)
	MenuTest_1:SetText(table.Random(RandomWelcomeText))
	MenuTest_1:SizeToContents()


	
	local MenuButton = vgui.Create( "DButton", MenuFrame )
	MenuButton:SetText( "Rest" )
	MenuButton:Dock(FILL)
	MenuButton:SetSize( 100, 50 )
	MenuButton.DoClick = function()
		local pos = LocalPlayer():GetPos()
		
		net.Start("innkeeper_rest")
		net.SendToServer()
		MenuFrame:Close()
	end
	/*


	local MenuTest_1 = vgui.Create("DLabel", MenuFrame)
	MenuTest_1:SetPos(10, 110)
	MenuTest_1:SetText("NOTE: Only admins can use these buttons! Remember most of this commands require 'sv_cheats' to be 1")
	MenuTest_1:SizeToContents()
	
	local MenuButton_2 = vgui.Create( "DButton", MenuFrame )
	MenuButton_2:SetText( "Toggle God Mode" )
	MenuButton_2:SetPos( 10, 130 ) -- y, x
	MenuButton_2:SetSize( 100, 50 )
	MenuButton_2.DoClick = function()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then RunConsoleCommand("god") end
	end
	-- Add 110
	local MenuButton_3 = vgui.Create( "DButton", MenuFrame )
	MenuButton_3:SetText( "Toggle Buddha" )
	MenuButton_3:SetPos( 120, 130 ) -- y, x
	MenuButton_3:SetSize( 100, 50 )
	MenuButton_3.DoClick = function()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then RunConsoleCommand("buddha") end
	end
	
	local MenuButton_4 = vgui.Create( "DButton", MenuFrame )
	MenuButton_4:SetText( "Firstperson" )
	MenuButton_4:SetPos( 230, 130 ) -- y, x
	MenuButton_4:SetSize( 100, 50 )
	MenuButton_4.DoClick = function()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then RunConsoleCommand("firstperson") end
	end
	
	local MenuButton_5 = vgui.Create( "DButton", MenuFrame )
	MenuButton_5:SetText( "Thirdperson" )
	MenuButton_5:SetPos( 340, 130 ) -- y, x
	MenuButton_5:SetSize( 100, 50 )
	MenuButton_5.DoClick = function()
		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then RunConsoleCommand("thirdperson") end
	end
	
	if (LocalPlayer():SteamID() == "STEAM_1:0:48278492") then
		local MenuButton_DrVrej1 = vgui.Create( "DButton", MenuFrame )
		MenuButton_DrVrej1:SetText( "Illuminati" )
		MenuButton_DrVrej1:SetPos( 10, 170 ) -- y, x
		MenuButton_DrVrej1:SetSize( 50, 30 )
		MenuButton_DrVrej1.DoClick = function()
			net.Start("vj_testentity_runtextsd")
			net.WriteEntity(LocalPlayer())
			net.WriteString("Zadkiel is in this server, be aware!")
			net.WriteString("vj_illuminati/Illuminati Confirmed.mp3")
			net.SendToServer()
		end
		local MenuButton_DrVrej2 = vgui.Create( "DButton", MenuFrame )
		MenuButton_DrVrej2:SetText( "THIRSTY" )
		MenuButton_DrVrej2:SetPos( 120, 170 ) -- y, x
		MenuButton_DrVrej2:SetSize( 50, 30 )
		MenuButton_DrVrej2.DoClick = function()
			net.Start("vj_testentity_runtextsd")
			net.WriteEntity(LocalPlayer())
			net.WriteString("Are you thirsty?")
			net.WriteString("vj_illuminati/areyouthristy.wav")
			net.SendToServer()
		end
	end
	*/
end
usermessage.Hook("vj_testentity_onmenuopen",OpenTheMenuCode)