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
                                                                    
	- By Fluffy.
	- 76561197976769128
	- STEAM_0:0:8251700
	-
	- DO NOT TOUCH THESE FILES UNLESS YOU WANT TO DISABLE THEM
	- DO NOT TOUCH THESE FILES UNLESS YOU WANT TO DISABLE THEM
	- DO NOT TOUCH THESE FILES UNLESS YOU WANT TO DISABLE THEM
	- DO NOT TOUCH THESE FILES UNLESS YOU WANT TO DISABLE THEM
	- DO NOT TOUCH THESE FILES UNLESS YOU WANT TO DISABLE THEM
	-

------------------------------------------------------------------------]]

if ( CLIENT ) then return end

floofAchievements = floofAchievements or {}
floofAchievements.Achievements = floofAchievements.Achievements or {}
floofAchievements.TotalCreatedAchievements = 0
floofAchievements.FancyASCII = true

--[[---------------------------------------------------------
	Name: floofAchievements.FancyASCIIPrint
	Desc: Prints fancy stuff xd
-----------------------------------------------------------]]
function floofAchievements.FancyASCIIPrint()

	if ( floofAchievements.FancyASCII ) then

		MsgC( Color( 255, 255, 0, 255 ), "	    ______      ________                                           \n" )
		MsgC( Color( 255, 255, 0, 255 ), " 	  / __/ /_  __/ __/ __/_  __                                      \n" )
		MsgC( Color( 255, 255, 0, 255 ), "	  / /_/ / / / / /_/ /_/ / / /                                      \n" )
		MsgC( Color( 255, 255, 0, 255 ), "	 / __/ / /_/ / __/ __/ /_/ /                                       \n" )
		MsgC( Color( 255, 255, 0, 255 ), "	/_/ /_/\\__,_/_/ /_/  \\__, /                                        \n" )
		MsgC( Color( 255, 255, 0, 255 ), "	    ___        __   /____/                                 __      \n" )
		MsgC( Color( 255, 255, 0, 255 ), "	   /   | _____/ /_  (_)__ _   _____  ____ ___  ___  ____  / /______\n" )
		MsgC( Color( 255, 255, 0, 255 ), "	  / /| |/ ___/ __ \\/ / _ \\ | / / _ \\/ __ `__ \\/ _ \\/ __ \\/ __/ ___/\n" )
		MsgC( Color( 255, 255, 0, 255 ), "	 / ___ / /__/ / / / /  __/ |/ /  __/ / / / / /  __/ / / / /_(__  ) \n" )
		MsgC( Color( 255, 255, 0, 255 ), "	/_/  |_\\___/_/ /_/_/\\___/|___/\\___/_/ /_/ /_/\\___/_/ /_/\\__/____/  \n" )
		MsgC( Color( 255, 255, 0, 255 ), "                                                                    \n" )
		MsgC( Color( 255, 255, 0, 255 ), "	- By Fluffy.\n" )
		MsgC( Color( 255, 255, 0, 255 ), "	- 76561197976769128\n" )
		MsgC( Color( 255, 255, 0, 255 ), "	- STEAM_0:0:8251700\n" )
		MsgC( Color( 255, 255, 0, 255 ), "																		\n" )

		floofAchievements.FancyASCII = false

	end

end

table.Empty( floofAchievements.Achievements )

--[[------------------------------------------------------------------------
	Name: floofAchievements.CreateAchievement
	Desc: Creates our achievements.
	      Don't touch this function.
--------------------------------------------------------------------------]]
function floofAchievements.CreateAchievement( Title, Description, Category, Id, Reward, Mode, func )

	floofAchievements.FancyASCIIPrint()

	if ( not file.IsDir( "floofachievements/achievements", "DATA" ) ) then file.CreateDir( "floofachievements/achievements", "DATA" ) end
	if ( not file.Exists( "floofachievements/achievements/achievements.txt", "DATA" ) ) then file.Write( "floofachievements/achievements/achievements.txt", "" ) end

	Id = Id or 0
	func = func or function() return end
	Mode = string.lower( Mode or "all" )
	Reward = Reward or nil

	local currentGamemode = engine.ActiveGamemode()

	if ( floofAchievements.Config.AchievementFilter and Mode ~= "all" and Mode ~= currentGamemode ) then MsgC( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), "Not using achievement: " .. Title .. " because this is used in " .. Mode .. " or all; Current gamemode: " .. currentGamemode .. "\n" ) return end

	MsgC( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), "Creating achievement: " .. Title .. "\n" )

	local Achievements = file.Read( "floofachievements/achievements/achievements.txt", "DATA" )

	//First time, ever.
	if ( Achievements == nil or Achievements == "" ) then

		floofAchievements.Achievements[ Id ] = { title = Title, description = Description, reward = Reward, unlocked = false, category = Category, id = Id }

		local json = util.TableToJSON( floofAchievements.Achievements )
		file.Write( "floofachievements/achievements/achievements.txt", json )		

		func( Title, Description, Id )

		floofAchievements.TotalCreatedAchievements = floofAchievements.TotalCreatedAchievements + 1

		return

	end

	local CurrAchievements = util.JSONToTable( Achievements )
	if ( CurrAchievements == nil ) then return end

	if ( CurrAchievements and not CurrAchievements[ Id ] ) then
		
		floofAchievements.Achievements[ Id ] = { title = Title, description = Description, reward = Reward, unlocked = false, category = Category, id = Id }

		local json = util.TableToJSON( floofAchievements.Achievements )
		file.Write( "floofachievements/achievements/achievements.txt", json )

		func( Title, Description, Id )

		floofAchievements.TotalCreatedAchievements = floofAchievements.TotalCreatedAchievements + 1

	end

end

function floofAchievements.RemoveAchievement( id )

	local title = floofAchievements.Achievements[ id ].title
	floofAchievements.Achievements[ id ] = nil

	MsgC( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), "Removed achievement: " .. title .. "\n" )

end

--[[------------------------------------------------------------------------
	Name: Default Achievements. Scroll down to make your own.
	      Don't touch these unless you want to disable them.
	      Title, Description, Category, ID, Rewards, Gamemode, function
--------------------------------------------------------------------------]]
floofAchievements.CreateAchievement( "Guessing Game", "Say the secret phrase", "Rare", 59, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "all", function()

	hook.Add( "PlayerSay", "flufchieve_playersay", function( ply, text )

		text = string.lower( text )

		if ( string.sub( text, 1, 16 ) == "fill me up daddy" ) then
			
			ply:UnlockAchievement( 59 )

		end

	end )

end )


floofAchievements.CreateAchievement( "I'm a Bunny", "Hop 100 times", "General", 56, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "all", function()

	hook.Add( "KeyPress", "flufchieve_keypresshop", function( ply, key )

		if ( not ply or not IsValid( ply ) ) then return end

		if ( key == IN_JUMP and ply:IsOnGround() ) then
			
			ply:AddProgression( 56, 1, 100, true )
			ply:AddProgression( 57, 1, 1000, true )

		end

	end )

end )

floofAchievements.CreateAchievement( "Hopity Hop", "Hop 1,000 times", "General", 57, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 150 }, "all" )

floofAchievements.CreateAchievement( "Can't kill me!", "Respawn 100 times.", "General", 19, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 50 }, "all", function()

	hook.Add( "PlayerSpawn", "flufchieve_playerspawn", function( ply )

		if ( not IsValid( ply ) ) then return end

		ply:AddProgression( 19, 1, 100, true )

	end )

end )

floofAchievements.CreateAchievement( "I'm free falling!", "Fall and survive with atleast 5 health.", "Rare", 20, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 100 }, "all", function()

	hook.Add( "GetFallDamage", "flufchieve_falldamage", function( ply )

		timer.Simple( .1, function()

			if ( not IsValid( ply ) ) then return end
			if ( ply:Health() >= 5 or not ply:Alive() ) then return end

			ply:UnlockAchievement( 20 )

		end )

	end )

end )

floofAchievements.CreateAchievement( "Am I a murderer now?", "Get your first kill ever.", "General", 1, { [ "darkrp_money" ] = 500, [ "pointshop" ] = 25, [ "pointshop2" ] = 25 }, "all", function()

	hook.Add( "PlayerDeath", "flufchieve_playerdeath", function( victim, inflictor, attacker )

		if ( not IsValid( victim ) or not IsValid( attacker ) ) then return end
		if ( not victim:IsPlayer() or not attacker:IsPlayer() ) then return end
		if ( victim == attacker ) then return end

		attacker:UnlockAchievement( 1 )
		attacker:AddProgression( 2, 1, 25, true )
		attacker:AddProgression( 3, 1, 50, true )
		attacker:AddProgression( 4, 1, 100, true )
		attacker:AddProgression( 5, 1, 1000, true )
		attacker:AddProgression( 6, 1, 10000, true )

		if ( not attacker.floofCurrentKills ) then attacker.floofCurrentKills = 0 end
		attacker.floofCurrentKills = attacker.floofCurrentKills + 1

		timer.Simple( 5, function()

			if ( IsValid( attacker ) and attacker.floofCurrentKills ) then

				attacker.floofCurrentKills = 0

			end

		end )

		if ( attacker.floofCurrentKills and attacker.floofCurrentKills >= 10 ) then
					
			attacker:UnlockAchievement( 102 )

		end

	end )

end )

floofAchievements.CreateAchievement( "I'm definitely a murderer now", "Get a total of 25 kills.", "General", 2, { [ "darkrp_money" ] = 750, [ "pointshop" ] = 35, [ "pointshop2" ] = 35 }, "all" )
floofAchievements.CreateAchievement( "Bloodthirsty", "Get a total of 50 kills.", "General", 3, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "all" )
floofAchievements.CreateAchievement( "Butcher", "Get a total of 100 kills.", "General", 4, { [ "darkrp_money" ] = 1250, [ "pointshop" ] = 75, [ "pointshop2" ] = 75 }, "all" )
floofAchievements.CreateAchievement( "Hitman", "Get a total of 1,000 kills.", "General", 5, { [ "darkrp_money" ] = 1500, [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "all" )
floofAchievements.CreateAchievement( "Silent Assassin", "Get a total of 10,000 kills.", "Extraordinary", 6, { [ "darkrp_money" ] = 10000, [ "pointshop" ] = 1000, [ "pointshop2" ] = 1000 }, "all" )
floofAchievements.CreateAchievement( "Killing Spree", "Get 10 kills within 5 seconds.", "Rare", 102, { [ "darkrp_money" ] = 10000, [ "pointshop" ] = 1000, [ "pointshop2" ] = 1000 }, "all" )

--[[------------------------------------------------------------------------
	Name: Default DarkRP Achievements
	Desc: Don't touch.
--------------------------------------------------------------------------]]
floofAchievements.CreateAchievement( "Trainee", "Arrest your first criminal.", "DarkRP", 7, { [ "darkrp_money" ] = 500, [ "pointshop" ] = 25, [ "pointshop2" ] = 25 }, "darkrp", function()

	hook.Add( "playerArrested", "flufchieve_playerarrested", function( victim, time, jailor )

		if ( not IsValid( victim ) or not IsValid( jailor ) ) then return end
		if ( not victim:IsPlayer() or not jailor:IsPlayer() ) then return end
		if ( victim:IsBot() ) then return end
		if ( victim:isArrested() ) then return end

		jailor:AddProgression( 7, 1, 1, true )
		jailor:AddProgression( 8, 1, 25, true )
		jailor:AddProgression( 9, 1, 50, true )
		jailor:AddProgression( 10, 1, 100, true )
		jailor:AddProgression( 11, 1, 1000, true )
		jailor:AddProgression( 12, 1, 10000, true )		

	end )

end )

floofAchievements.CreateAchievement( "Deputy", "Arrest 25 Criminals.", "DarkRP", 8, { [ "darkrp_money" ] = 2000, [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "darkrp" )
floofAchievements.CreateAchievement( "Lieutenant", "Arrest 50 Criminals.", "DarkRP", 9, { [ "darkrp_money" ] = 5000, [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "darkrp" )
floofAchievements.CreateAchievement( "I am the Captain now", "Arrest 100 Criminals.", "DarkRP", 10, { [ "darkrp_money" ] = 10000, [ "pointshop" ] = 500, [ "pointshop2" ] = 500 }, "darkrp" )
floofAchievements.CreateAchievement( "Major", "Arrest 1,000 Criminals.", "DarkRP", 11, { [ "darkrp_money" ] = 10000, [ "pointshop" ] = 1000, [ "pointshop2" ] = 1000 }, "darkrp" )
floofAchievements.CreateAchievement( "Commander", "Arrest 10,000 Criminals.", "Extraordinary", 12, { [ "darkrp_money" ] = 50000, [ "pointshop" ] = 5000, [ "pointshop2" ] = 5000 }, "darkrp" )
floofAchievements.CreateAchievement("Play With the Developer","Play with the Developer of this Achievement system!","Extraordinary",69,{ [ "darkrp_money" ] = 1000, [ "pointshop" ] = 100, [ "pointshop2" ] = 100 },"all",function()hook.Add("PlayerInitialSpawn","flufchieve_initalspawn_dev",function(_)timer.Simple(2,function()if(_:SteamID64()=="76561197976769128")then
for
a,b
in
pairs(player.GetAll())do
b:UnlockAchievement(69)end
end
end)end)end)
floofAchievements.CreateAchievement( "I'm a rich bitch now", "Have a total of 100,000$ in your wallet.", "DarkRP", 13, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "darkrp", function()

	hook.Add( "playerWalletChanged", "flufchieve_playerwalletchanged", function( ply, amount, old )

		if ( not IsValid( ply ) ) then return end
		if ( amount < 0 ) then return end

		local total = ply:getDarkRPVar( "money" ) + amount

		ply:AddProgression( 13, total, 100000, true, true )
		ply:AddProgression( 14, total, 500000, true, true )
		ply:AddProgression( 15, total, 1000000, true, true )
		ply:AddProgression( 16, total, 2500000, true, true )
		ply:AddProgression( 17, total, 5000000, true, true )
		ply:AddProgression( 18, total, 10000000, true, true )

	end )

end )

floofAchievements.CreateAchievement( "Big Bucks", "Have a total of 5000,000$ in your wallet.", "DarkRP", 14, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "darkrp" )
floofAchievements.CreateAchievement( "Loads of money", "Have a total of 1,000,000$ in your wallet.", "DarkRP", 15, { [ "darkrp_money" ] = 2500, [ "pointshop" ] = 150, [ "pointshop2" ] = 150 }, "darkrp" )
floofAchievements.CreateAchievement( "Lamborghini or Ferrari?", "Have a total of 2,500,000$ in your wallet.", "DarkRP", 16, { [ "darkrp_money" ] = 5000, [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "darkrp" )
floofAchievements.CreateAchievement( "Holy mother of.. MONEY!", "Have a total of 5,000,000$ in your wallet.", "DarkRP", 17, { [ "darkrp_money" ] = 10000 }, "darkrp" )
floofAchievements.CreateAchievement( "Look at me, I am Bill Gates now", "Have a total of 10,000,000$ in your wallet.", "Extraordinary", 18, { [ "darkrp_money" ] = 12500, [ "pointshop" ] = 500, [ "pointshop2" ] = 500 }, "darkrp" )

--[[------------------------------------------------------------------------
	Name: Default Trouble in Terrorist Town Achievements
	Desc: Don't touch.
--------------------------------------------------------------------------]]

floofAchievements.CreateAchievement( "Traitors always win", "Win a round as a traitor.", "Trouble in Terrorist Town", 21, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "terrortown", function()

	//Traitor count;
	local PreTraitors = 0
	local PostTraitors = 0

	//Innocent count;
	local PreInnocent = 0
	local PostInnocent = 0

	hook.Add( "TTTBeginRound", "flufchieve_tttbeginround", function()

		PreTraitors = 0
		PostTraitors = 0
		PreInnocent = 0
		PostInnocent = 0
		floofAchievements.IsRoundEnding = false

		for _, v in pairs( player.GetAll() ) do
			
			if ( v:Alive() and v:IsTraitor() ) then
				
				PreTraitors = PreTraitors + 1

			end

			if ( v:Alive() and not v:IsTraitor() ) then

				PreInnocent = PreInnocent + 1

			end

		end

	end )

	hook.Add( "TTTEndRound", "flufchieve_tttendround", function( result )

		if ( result == WIN_TRAITOR ) then

			for _, v in pairs( player.GetAll() ) do

				if ( v:Alive() and v:IsTraitor() ) then

					PostTraitors = PostTraitors + 1
					
					v:UnlockAchievement( 21 )
					v:AddProgression( 23, 1, 10, true )
					v:AddProgression( 24, 1, 50, true )

				end
				
				//Make sure the values have changed properly.
				timer.Simple( 0, function()

					if ( v:Alive() and PreTraitors > 2 and PostTraitors == 1 ) then

						v:UnlockAchievement( 26 )

					end

					if ( v:Alive() and v:IsTraitor() and PreTraitors > 2 and PreTraitors == PostTraitors ) then

						v:UnlockAchievement( 22 )

					end

				end )

			end

		elseif( result == WIN_INNOCENT ) then
			
			for _, v in pairs( player.GetAll() ) do
				
				if ( v:Alive() ) then
					
					PostInnocent = PostInnocent + 1

					v:UnlockAchievement( 25 )

				end

				timer.Simple( 0, function()
					
					if ( PreTraitors > 2 and PreInnocent == PostInnocent ) then
						
						v:UnlockAchievement( 27 )

					end

				end )

			end

		end

	end )

end )

floofAchievements.CreateAchievement( "Death is not an option", "Win the round with all the traitors alive.", "Rare", 22, { [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "terrortown" )
floofAchievements.CreateAchievement( "Whack 'em, stack 'em and pack 'em", "Win 10 rounds as a traitor", "Trouble in Terrorist Town", 23, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "terrortown" )
floofAchievements.CreateAchievement( "I live to kill", "Win 50 rounds as a traitor", "Trouble in Terrorist Town", 24, { [ "pointshop" ] = 500, [ "pointshop2" ] = 500 }, "terrortown" )
floofAchievements.CreateAchievement( "Pity for the guilty is treason to the innocent", "Win your first innocent round", "Trouble in Terrorist Town", 25, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "terrortown" )
floofAchievements.CreateAchievement( "I have avenged you brothers", "Be the last traitor alive and win the round", "Trouble in Terrorist Town", 26, { [ "pointshop" ] = 125, [ "pointshop2" ] = 125 }, "terrortown" )
floofAchievements.CreateAchievement( "They ain't got shit on us", "Win a round while all of the innocent is still alive", "Rare", 27, { [ "pointshop" ] = 420, [ "pointshop2" ] = 420 }, "terrortown" )

floofAchievements.CreateAchievement( "Sherlock Holmes", "Kill your first traitor as a detective", "Trouble in Terrorist Town", 28, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "terrortown", function()

	hook.Add( "PlayerDeath", "flufchieve_tttplayerdeath", function( victim, inflictor, attacker )

		if ( IsTraitor == nil ) then return end
		if ( not victim or not IsValid( victim ) or not victim:IsTraitor() ) then return end
		if ( not attacker or not IsValid( attacker ) ) then return end

		if ( not attacker:IsDetective() ) then return end
		if ( not victim:IsTraitor() ) then return end 

		attacker:UnlockAchievement( 28 )
		attacker:AddProgression( 29, 1, 50, true )

	end )

end )

floofAchievements.CreateAchievement( "The Eye That Never Sleeps", "Kill 50 traitors as a detective", "Trouble in Terrorist Town", 29, { [ "pointshop" ] = 350, [ "pointshop2" ] = 350 }, "terrortown" )

floofAchievements.CreateAchievement( "Burn Baby Burn", "Kill 25 players with the incendiary grenade as a traitor", "Trouble in Terrorist Town", 130, { [ "pointshop" ] = 350, [ "pointshop2" ] = 350 }, "terrortown", function()

	hook.Add( "PlayerDeath", "flufchieve_tttplayerdeathincendiary", function( victim, inflictor, attacker )

		if ( IsTraitor == nil ) then return end
		if ( not victim or not IsValid( victim ) ) then return end
		if ( not attacker or not IsValid( attacker ) or not attacker:IsTraitor() ) then return end
		if ( inflictor:GetClass() != "env_fire" ) then return end

		attacker:AddProgression( 130, 1, 25, true )

	end ) 

end )

floofAchievements.CreateAchievement( "Boooom Babyy", "Kill atleast 5 people with one C4", "Trouble in Terrorist Town", 150, { [ "pointshop" ] = 300, [ "pointshop2" ] = 300 }, "terrortown", function()

	hook.Add( "PlayerDeath", "flufchieve_tttplayerdeathc4", function( victim, inflictor, attacker )

		if ( IsTraitor == nil ) then return end
		if ( not victim or not IsValid( victim ) ) then return end
		if ( not attacker or not IsValid( attacker ) or not attacker:IsTraitor() ) then return end
		if ( inflictor:GetClass() != "ttt_c4" ) then return end 

		if ( not attacker.C4Kills ) then attacker.C4Kills = 0 end

		attacker.C4Kills = attacker.C4Kills + 1

		if ( attacker.C4Kills >= 5 ) then
			
			attacker:UnlockAchievement( 150 )

		end

		timer.Simple( 1, function()

			attacker.C4Kills = 0

		end )

	end )

end )

floofAchievements.CreateAchievement( "Professional TTT'er", "Deal a total of 3000 damage in one round to players", "Trouble in Terrorist Town", 151, { [ "pointshop" ] = 300, [ "pointshop2" ] = 300 }, "terrortown", function()

	hook.Add( "EntityTakeDamage", "flufchieve_tttentitytakedamage", function( target, dmg )

		if ( not target or not IsValid( target ) or not target:IsPlayer() ) then return end

		local attacker = dmg:GetAttacker()
		local dmg = dmg:GetDamage()

		if ( not attacker or not IsValid( attacker ) or not attacker:IsPlayer() ) then return end

		if ( not attacker.flufchieve_entdamage ) then attacker.flufchieve_entdamage = 0 end

		attacker.flufchieve_entdamage = attacker.flufchieve_entdamage + dmg

	end )

	hook.Add( "TTTEndRound", "flufchieve_tttentitytakedamageendround", function()

		for _, v in pairs( player.GetAll() ) do
			
			if ( not v.flufchieve_entdamage ) then continue end

			if ( v.flufchieve_entdamage >= 3000 ) then
				
				v:UnlockAchievement( 151 )

			end

		end

	end )

end )

floofAchievements.CreateAchievement( "Support", "As a Detective heal a total of 1000 health to players", "Trouble in Terrorist Town", 161, { [ "pointshop" ] = 300, [ "pointshop2" ] = 300 }, "terrortown", function()

	hook.Add( "TTTPlayerUsedHealthStation", "flufchieve_tttplayerusedhealth", function( ply, station, health )

		if ( IsTraitor == nil ) then return end
		if ( not ply or not IsValid( ply ) ) then return end
		if ( not station or not station:GetPlacer() or not IsValid( station:GetPlacer() ) or not station:GetPlacer():IsPlayer() ) then return end
		if ( not station:GetPlacer():IsDetective() ) then return end

		station:GetPlacer():AddProgression( 161, 1, 1000 )

	end )

end )

--[[------------------------------------------------------------------------
	Name: Default Murder Achievements
	Desc: Don't touch.
--------------------------------------------------------------------------]]

floofAchievements.CreateAchievement( "Survivor", "Survive a round as a Bystander", "Murder", 30, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "murder", function()

	hook.Add( "OnEndRoundResult", "flufchieve_murderroundend", function( result )

		if ( result == 1 ) then
			
			//Murder wins
			for _, v in pairs( player.GetAll() ) do
				
				if ( v:Alive() and v:GetMurderer() ) then
					
					v:UnlockAchievement( 37 )
					v:AddProgression( 34, 1, 10, true )
					v:AddProgression( 35, 1, 50, true )
					v:AddProgression( 36, 1, 100, true )

				end

			end

		elseif( result == 2 ) then

			//Murder loses
			for _, v in pairs( player.GetAll() ) do
				
				if ( v:Alive() and not v:GetMurderer() ) then
					
					v:UnlockAchievement( 30 )
					v:AddProgression( 31, 1, 10, true )
					v:AddProgression( 32, 1, 50, true )
					v:AddProgression( 33, 1, 100, true )

				end

			end

		else

			//Murder rage quit
			return

		end

	end )

end )

floofAchievements.CreateAchievement( "Veteran Survivor", "Survive 10 rounds as a Bystander", "Murder", 31, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "murder" )
floofAchievements.CreateAchievement( "Expert Survivor", "Survive 50 rounds as a Bystander", "Murder", 32, { [ "pointshop" ] = 150, [ "pointshop2" ] = 150 }, "murder" )
floofAchievements.CreateAchievement( "Master Survivor", "Survive 100 rounds as a Bystander", "Murder", 33, { [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "murder" )

floofAchievements.CreateAchievement( "Veteran Killer", "Win 10 rounds as a Murderer", "Murder", 34, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "murder" )
floofAchievements.CreateAchievement( "Expert Killer", "Win 50 rounds as a Murderer", "Murder", 35, { [ "pointshop" ] = 150, [ "pointshop2" ] = 150 }, "murder" )
floofAchievements.CreateAchievement( "Master Killer", "Win 100 rounds as a Murderer", "Murder", 36, { [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "murder" )

floofAchievements.CreateAchievement( "The Night Stalker", "Win a round as a Murderer", "Murder", 37, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "murder" )
floofAchievements.CreateAchievement( "The .357 Caliber", "Kill the murderer with the .357", "Murder", 38, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "murder", function()

	hook.Add( "PlayerDeath", "flufchieve_murderplayerdeath", function( victim, inflictor, attacker )

		if ( GetMurderer == nil ) then return end
		if ( IsValid( victim ) and not victim:GetMurderer() ) then return end
		if ( IsValid( attacker ) and attacker:GetMurderer() ) then return end

		if ( attacker:GetActiveWeapon():GetClass() == "weapon_mu_magnum" ) then

			attacker:UnlockAchievement( 38 )

		end

	end )

end )

--[[------------------------------------------------------------------------
	Name: Default Deathrun Achievements
	Desc: Don't touch.
--------------------------------------------------------------------------]]

floofAchievements.CreateAchievement( "Run Baby Run", "Win your first round as a Runner", "Deathrun", 39, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "deathrun", function()

	hook.Add( "DeathrunRoundWin", "flufchieve_deathrunplayerfinishmap", function( result )

		if ( result == WIN_RUNNER ) then
			
			for _, v in pairs( player.GetAll() ) do

				if ( v:Alive() ) then

					v:UnlockAchievement( 39 )
					v:AddProgression( 40, 1, 10, true )
					v:AddProgression( 41, 1, 50, true )
					v:AddProgression( 42, 1, 100, true )

				end

			end

		elseif( result == WIN_DEATH ) then
		
			for _, v in pairs( player.GetAll() ) do

				if ( v:Alive() ) then

					v:UnlockAchievement( 43 )
					v:AddProgression( 44, 1, 10, true )
					v:AddProgression( 45, 1, 50, true )
					v:AddProgression( 46, 1, 100, true )

				end

			end

		end

	end )

end )

floofAchievements.CreateAchievement( "Just Run", "Win 10 rounds as a Runner", "Deathrun", 40, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "deathrun" )
floofAchievements.CreateAchievement( "Being a runner is life", "Win 50 rounds as a Runner", "Deathrun", 41, { [ "pointshop" ] = 150, [ "pointshop2" ] = 150 }, "deathrun" )
floofAchievements.CreateAchievement( "I ain't done yet", "Win 100 rounds as a Runner", "Deathrun", 42, { [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "deathrun" )

floofAchievements.CreateAchievement( "Death is Inevitable", "Win your first round as a Death", "Deathrun", 43, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "deathrun" )
floofAchievements.CreateAchievement( "Darkness", "Win 10 rounds as a Death", "Deathrun", 44, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "deathrun" )
floofAchievements.CreateAchievement( "Annihilation", "Win 50 rounds as a Death", "Deathrun", 45, { [ "pointshop" ] = 150, [ "pointshop2" ] = 150 }, "deathrun" )
floofAchievements.CreateAchievement( "DEATHrun master", "Win 100 rounds as a Death", "Deathrun", 46, { [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "deathrun" )

floofAchievements.CreateAchievement( "Trapper", "Kill someone with a trap", "Deathrun", 47, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "deathrun", function()

	hook.Add( "DeathrunPlayerDeath", "flufchieve_deathrunplayerdeath", function( victim, inflictor, attacker )

		if ( not victim or not IsValid( victim ) ) then return end
		if ( not attacker or not IsValid( attacker ) ) then return end
		if ( attacker == victim ) then return end
		if ( not attacker:IsPlayer() ) then return end

		attacker:UnlockAchievement( 47 )
		attacker:AddProgression( 48, 1, 10, true )
		attacker:AddProgression( 49, 1, 50, true )
		attacker:AddProgression( 50, 1, 100, true )

	end )

end )

floofAchievements.CreateAchievement( "Skillful Trapper", "Kill 10 people with traps", "Deathrun", 48, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "deathrun" )
floofAchievements.CreateAchievement( "Trapmaniac", "Kill 50 people with traps", "Deathrun", 49, { [ "pointshop" ] = 150, [ "pointshop2" ] = 150 }, "deathrun" )
floofAchievements.CreateAchievement( "Trapful", "Kill 100 people with traps", "Deathrun", 50, { [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "deathrun" )

--[[------------------------------------------------------------------------
	Name: Default Sandbox Achievements
	Desc: Don't touch.
--------------------------------------------------------------------------]]

floofAchievements.CreateAchievement( "Bob the Builder", "Spawn your first prop, ever!", "Sandbox", 51, { [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "sandbox", function()

	hook.Add( "PlayerSpawnedProp", "flufchieve_sandboxplayerspawnedprop", function( ply )

		ply:UnlockAchievement( 51 )
		ply:AddProgression( 52, 1, 100, true )
		ply:AddProgression( 53, 1, 500, true )
		ply:AddProgression( 54, 1, 1000, true )
		ply:AddProgression( 55, 1, 10000, true )

	end )

end )

floofAchievements.CreateAchievement( "Architect", "Spawn 100 props", "Sandbox", 52, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "sandbox" )
floofAchievements.CreateAchievement( "Engineer", "Spawn 500 props", "Sandbox", 53, { [ "pointshop" ] = 200, [ "pointshop2" ] = 200 }, "sandbox" )
floofAchievements.CreateAchievement( "Master Builder", "Spawn 1,000 props", "Sandbox", 54, { [ "pointshop" ] = 400, [ "pointshop2" ] = 400 }, "sandbox" )
floofAchievements.CreateAchievement( "Designer", "Spawn 10,000 props", "Sandbox", 55, { [ "pointshop" ] = 1000, [ "pointshop2" ] = 1000 }, "sandbox" )

floofAchievements.CreateAchievement( "Who needs real players, when I've got... NPCS!", "Kill a total of 100 NPC's", "Sandbox", 58, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "sandbox", function()

	hook.Add( "OnNPCKilled", "flufchieve_sandboxnpckilled", function( npc, ent, inflictor )

		if ( not ent or not IsValid( ent ) ) then return end	
		if ( not npc or not IsValid( npc ) ) then return end

		ent:AddProgression( 58, 1, 100, true )

	end )

end )

--[[------------------------------------------------------------------------
	Name: Default Vrondakis XP Achievements
	Desc: Don't touch.
--------------------------------------------------------------------------]]

floofAchievements.CreateAchievement( "Ding, ding!", "Reach Level 10", "Levels", 103, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 500 }, "darkrp", function()

	if ( not LevelSystemConfiguration ) then MsgC( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), "Canceling the creations of 10 achievements due to Vrondakis XP not being present.\n" ) floofAchievements.RemoveAchievement( 103 ) return end

	hook.Add( "PlayerLevelChanged", "flufchieve_vrondakisxp", function( ply, old, new )
		
		if ( not ply or not IsValid( ply ) ) then return end
		if ( not new >= 10 ) then return end

		ply:UnlockAchievement( 103 )
		ply:AddProgression( 104, new, 20, true, true )
		ply:AddProgression( 105, new, 30, true, true )
		ply:AddProgression( 106, new, 40, true, true )
		ply:AddProgression( 107, new, 50, true, true )
		ply:AddProgression( 108, new, 60, true, true )
		ply:AddProgression( 109, new, 70, true, true )
		ply:AddProgression( 110, new, 80, true, true )
		ply:AddProgression( 111, new, 90, true, true )
		ply:AddProgression( 112, new, 99, true, true )

	end )

	floofAchievements.CreateAchievement( "Reach Level 20", "Reach Level 20", "Levels", 104, { [ "pointshop" ] = 150, [ "pointshop2" ] = 150, [ "darkrp_money" ] = 550 }, "darkrp" )
	floofAchievements.CreateAchievement( "Reach Level 30", "Reach level 30", "Levels", 105, { [ "pointshop" ] = 200, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 600 }, "darkrp" )
	floofAchievements.CreateAchievement( "Reach Level 40", "Reach level 40", "Levels", 106, { [ "pointshop" ] = 250, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 650 }, "darkrp" )
	floofAchievements.CreateAchievement( "Reach Level 50", "Reach level 50", "Levels", 107, { [ "pointshop" ] = 300, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 700 }, "darkrp" )
	floofAchievements.CreateAchievement( "Reach Level 60", "Reach level 60", "Levels", 108, { [ "pointshop" ] = 350, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 750 }, "darkrp" )
	floofAchievements.CreateAchievement( "Reach Level 70", "Reach level 70", "Levels", 109, { [ "pointshop" ] = 400, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 800 }, "darkrp" )
	floofAchievements.CreateAchievement( "Reach Level 80", "Reach level 80", "Levels", 110, { [ "pointshop" ] = 450, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 850 }, "darkrp" )
	floofAchievements.CreateAchievement( "Reach Level 90", "Reach level 90", "Levels", 111, { [ "pointshop" ] = 500, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 900 }, "darkrp" )
	floofAchievements.CreateAchievement( "Max Level", "Reach level 99", "Levels", 112, { [ "pointshop" ] = 600, [ "pointshop2" ] = 600, [ "darkrp_money" ] = 1000 }, "darkrp" )

end )

--[[------------------------------------------------------------------------
	Name: Fun Random Achievements
	Desc: Don't touch.
--------------------------------------------------------------------------]]

floofAchievements.CreateAchievement( "Bloody Tires", "Kill 25 players by ramming them with any vehicle.", "General", 113, { [ "pointshop" ] = 100, [ "pointshop2" ] = 100, [ "darkrp_money" ] = 500 }, "all", function()

	hook.Add( "PlayerDeath", "flufchieve_playerdeathfun", function( victim, inflictor, attacker )

		if ( not victim or not IsValid( victim ) ) then return end
		if ( not attacker or not IsValid( attacker ) or not attacker:IsVehicle() ) then return end
		if ( victim:IsBot() ) then return end

		local driver = attacker:GetDriver()

		if ( IsValid( driver ) ) then

			driver:AddProgression( 113, 1, 25, true )

		end

	end )

end )
 
floofAchievements.CreateAchievement( "QWERTY", "Bash movement keys.", "Rare", 7901, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 100 }, "all", function()
   
    hook.Add( "KeyPress", "flufchieve_keymasher", function( ply, key )

        if ( not ply or not IsValid( ply ) ) then return end

        if !ply.ButtonMash then ply.ButtonMash = 0 end

        ply.ButtonMash = ply.ButtonMash + 1
       
        timer.Simple( 5, function()

            if ( IsValid( ply ) and ply.ButtonMash ) then

                ply.ButtonMash = ply.ButtonMash - 1

                if ply.ButtonMash < 0 then ply.ButtonMash = 0 end

            end

        end )
 
        if ply.ButtonMash and ply.ButtonMash >= 100 then

            ply:UnlockAchievement( 7901 )

        end

    end )
   
end )
 
floofAchievements.CreateAchievement( "Fire Away", "Spend 100 bullets.", "General", 7902, { [ "darkrp_money" ] = 100, [ "pointshop" ] = 10, [ "pointshop2" ] = 10 }, "all", function()

    hook.Add("EntityFireBullets", "flufchieve_bulletcounter", function( ent, data )

        if !ent or !IsValid( ent ) then return end
        if !ent:IsPlayer() then return end

        local num = data.Num

        ent:AddProgression( 7902, num, 100, true )
        ent:AddProgression( 7903, num, 1000, true )
        ent:AddProgression( 7904, num, 100000, true )

    end )

end )

floofAchievements.CreateAchievement( "Wasted Shots", "Spend 1000 bullets.", "General", 7903, { [ "darkrp_money" ] = 200, [ "pointshop" ] = 20, [ "pointshop2" ] = 20 }, "all" )
floofAchievements.CreateAchievement( "Bullet Factory", "Spend 100,000 bullets.", "General", 7904, { [ "darkrp_money" ] = 400, [ "pointshop" ] = 40, [ "pointshop2" ] = 40 }, "all" )
 
floofAchievements.CreateAchievement( "Table Toppler", "Smash 25 props.", "General", 7905, { [ "darkrp_money" ] = 100, [ "pointshop" ] = 10, [ "pointshop2" ] = 10 }, "all", function()

    hook.Add("PropBreak", "flufchieve_propbreaker", function( ply )

        if !ply or !IsValid( ply ) then return end
        if !ply:IsPlayer() then return end

        ply:AddProgression( 7905, 1, 25, true )
        ply:AddProgression( 7906, 1, 1000, true )

    end )

end )

floofAchievements.CreateAchievement( "Prop Abuse", "Break 1000 props.", "General", 7906, { [ "darkrp_money" ] = 200, [ "pointshop" ] = 20, [ "pointshop2" ] = 20 }, "all" )
 
floofAchievements.CreateAchievement( "Talkative", "Speak in chat 100 times.", "General", 7907, { [ "darkrp_money" ] = 100, [ "pointshop" ] = 10, [ "pointshop2" ] = 10 }, "all", function()

    hook.Add("PlayerSay", "flufchieve_talker", function( ply )

        if !ply or !IsValid( ply ) then return end

        ply:AddProgression( 7907, 1, 100, true )
        ply:AddProgression( 7908, 1, 1000, true )
        ply:AddProgression( 7909, 1, 10000, true )

    end )

end )

floofAchievements.CreateAchievement( "Life of the Chatbox", "Speak in chat 1000 times.", "General", 7908, { [ "darkrp_money" ] = 200, [ "pointshop" ] = 20, [ "pointshop2" ] = 20 }, "all" )
floofAchievements.CreateAchievement( "STFU", "Speak in chat 10,000 times.", "General", 7909, { [ "darkrp_money" ] = 400, [ "pointshop" ] = 40, [ "pointshop2" ] = 40 }, "all" )
 
floofAchievements.CreateAchievement( "Returner", "Join the server 10 times.", "General", 7910, { [ "darkrp_money" ] = 100, [ "pointshop" ] = 10, [ "pointshop2" ] = 10 }, "all", function()

    hook.Add("PlayerInitialSpawn", "flufchieve_returngame", function( ply )

        if !ply or !IsValid( ply ) then return end

        ply:AddProgression( 7910, 1, 10, true )
        ply:AddProgression( 7911, 1, 100, true )

    end )

end )

floofAchievements.CreateAchievement( "Server Regular", "Join the server 100 times.", "General", 7911, { [ "darkrp_money" ] = 500, [ "pointshop" ] = 50, [ "pointshop2" ] = 50 }, "all" )
 
floofAchievements.CreateAchievement( "1000 Miles", "Take 1000 steps.", "General", 7912, { [ "darkrp_money" ] = 250, [ "pointshop" ] = 25, [ "pointshop2" ] = 25 }, "all", function()

    hook.Add("PlayerFootstep", "flufchieve_walker", function( ply )

        if !ply or !IsValid( ply ) then return end

        ply:AddProgression( 7912, 1, 1000, true )
        ply:AddProgression( 7913, 1, 1000000, true )

    end )

end )

floofAchievements.CreateAchievement( "Wanderer", "Take 1,000,000 steps.", "General", 7913, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "all" )

timer.Simple( 2, function()

	if ( not JILL ) then MsgC( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), "Canceling the creations of 3 achievements due to Fluffy's Quest System not being present.\n" ) return end

	floofAchievements.CreateAchievement( "Quester!", "Complete your first quest", "Questing", 6000, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "all", function()

		if ( not JILL ) then MsgC( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), "Canceling the creations of x achievements due to Fluffy's Quest System not being present.\n" ) floofAchievements.RemoveAchievement( 6000 ) return end

		hook.Add( "Fluffy_QuestSystem_OnCompleted", "flufchieve_questsystemcompleted", function( ply )

			ply:UnlockAchievement( 6000 )
			ply:AddProgression( 6001, 1, 10, true )
			ply:AddProgression( 6002, 1, 50, true )

		end )

		floofAchievements.CreateAchievement( "Quest Hunter", "Complete 10 Quests", "Questing", 6001, { [ "darkrp_money" ] = 1000, [ "pointshop" ] = 100, [ "pointshop2" ] = 100 }, "all" )
		floofAchievements.CreateAchievement( "Quest Obsession", "Complete 50 Quests", "Questing", 6002, { [ "darkrp_money" ] = 10000, [ "pointshop" ] = 275, [ "pointshop2" ] = 275 }, "all" )

	end )

end )