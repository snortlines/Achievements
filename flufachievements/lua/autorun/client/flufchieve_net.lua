--[[----------------------------------------------------------------------
	    ______      ________                                           
 	  / __/ /_  __/ __/ __/_  __                                      
	  / /_/ / / / / /_/ /_/ / / /                                      
	 / __/ / /_/ / __/ __/ /_/ /                                       
	/_/ /_/\__,_/_/ /_/  \__, /                                        
	    ___        __   /____/                                 __      
	   /   | _____/ /_  (_)__ _   _____  ____ ___  ___  ____  / /______
	  / /| |/ ___/ __ \/ / _ \ | / / _ \/ __ `__ \/ _ \/ __ \/ __/ ___/
	 / ___ / /__/ / / / /  __/ |/ /  __/ / / / / /  __/ / / / /_(__  ) 
	/_/  |_\___/_/ /_/_/\___/|___/\___/_/ /_/ /_/\___/_/ /_/\__/____/  
                                                                    
------------------------------------------------------------------------]]

floofAchievements = floofAchievements or {}
floofAchievements.RequestUICurrTime = CurTime() + 2

net.Receive( "floofAchievements_UnlockedAchievement", function( _, ply )

	if ( not IsValid( LocalPlayer() ) ) then return end
	
	local title = net.ReadString()
	local desc = net.ReadString()
	local rType = net.ReadString()
	local rR = net.ReadString()

	local p = vgui.Create( "floofAchievements_AchievementUnlockedUI" )
	p:SetAchievementTitle( title )

	if ( rType == "" or rType == nil ) then

		p:SetReward( rR .. " " .. rType )

	else

		p:SetReward( "Reward: " .. rR .. " " .. rType )

	end

end )

net.Receive( "flufchieve_clientprint", function( _, ply )

	if ( not IsValid( LocalPlayer() ) ) then return end

	local args = net.ReadTable()

	for _, v in pairs( args ) do
		
		chat.AddText( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), tostring( v ) )

	end

end )

net.Receive( "flufchieve_clientconsoleprint", function( _, ply )

	if ( not IsValid( LocalPlayer() ) ) then return end

	local args = net.ReadTable()

	for _, v in pairs( args ) do
		
		MsgC( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), tostring( v ) .. "\n" )

	end

end )

function floofAchievements.RequestUI()

	if ( input.WasKeyPressed( floofAchievements.Config.Key ) and floofAchievements.Config.UseKey ) then

		if ( gui.IsConsoleVisible() ) then return end
		if ( gui.IsGameUIVisible() ) then return end
		if ( LocalPlayer():IsTyping() ) then return end
		if ( floofAchievements.RequestUICurrTime > CurTime() ) then return end
		if ( floofAchievements.Active and IsValid( floofAchievements.pnl ) ) then floofAchievements.pnl:Remove() floofAchievements.pnl = nil floofAchievements.RequestUICurrTime = CurTime() + 2 return end

		net.Start( "flufchieve_requestuifromclient" ) net.SendToServer()

		floofAchievements.RequestUICurrTime = CurTime() + 2

	end

end
hook.Add( "Move", "flufchieve_clientrequestui", floofAchievements.RequestUI )

net.Receive( "flufchieve_openui", function( _, ply )

	floofAchievements.Achievements = net.ReadTable()
	floofAchievements.AchievementProgress = net.ReadTable()
	floofAchievements.RecentAchievements = net.ReadTable()
	floofAchievements.TotalCreatedAchievements = net.ReadString()
	floofAchievements.CompletedAchivements = 0
	floofAchievements.Categories = {}

	local Count = 0

	for k, v in pairs( floofAchievements.Achievements ) do
		
		if ( v.unlocked ) then floofAchievements.CompletedAchivements = floofAchievements.CompletedAchivements + 1 end

		if ( not floofAchievements.Categories[ v.category ] ) then
			
			if ( v.category == "Rare" ) then floofAchievements.Categories[ v.category ] = 1000 continue end
			if ( v.category == "Extraordinary" ) then floofAchievements.Categories[ v.category ] = 1001 continue end

			floofAchievements.Categories[ v.category ] = Count

			Count = Count + 1

		end

		if ( not v.progress and not v.needed ) then
			
			if ( not floofAchievements.AchievementProgress[ k ] ) then continue end

			v.needed = floofAchievements.AchievementProgress[ k ].needed or ""
			v.progress = floofAchievements.AchievementProgress[ k ].progress or ""

		end

	end

	vgui.Create( "flufchieve_achievementui" )

end )