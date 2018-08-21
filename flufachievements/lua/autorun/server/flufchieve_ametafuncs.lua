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
floofAchievements.Achievements = floofAchievements.Achievements or {}
floofAchievements.Client = floofAchievements.Client or FindMetaTable( "Player" )

util.AddNetworkString( "floofAchievements_UnlockedAchievement" )

--[[---------------------------------------------------------
	Name: floofAchievements.CreateAchievement
	Desc: Creates our achievements.
-----------------------------------------------------------]]
function floofAchievements.Client:UnlockAchievement( id )

	if ( not IsValid( self ) ) then return end

	if ( not file.IsDir( "floofachievements", "DATA" ) ) then floofAchievements.ConsolePrint( "Unable to unlock achievement for " .. self:Nick() or "unknown" .. " due to the main data file not existing.", "Please restart the server to fix this issue", "If you have done the above and it still doesn't work then, please contact the author at scriptfodder, not steam." ) return end
	if ( not file.IsDir( "floofachievements/players/" .. self:SteamID64(), "DATA" ) ) then file.CreateDir( "floofachievements/players/" .. self:SteamID64(), "DATA" ) end
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "DATA" ) ) then file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "" ) end
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "DATA" ) ) then file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "" ) end
	if ( self:HasUnlockedAchievement( id ) ) then return end
	if ( gmod.GetGamemode().Name == "Trouble in Terrorist Town" and floofAchievements.Config.ShouldWaitWithUnlock and not floofAchievements.IsRoundEnding ) then

		if ( next( floofAchievements.ShouldUnlockOnRoundEnd[ self:SteamID64() ] ) ) then

			for k, v in pairs( floofAchievements.ShouldUnlockOnRoundEnd[ self:SteamID64() ] ) do

				if ( v.achievement == id ) then 

					return

				end

			end

		end

		table.insert( floofAchievements.ShouldUnlockOnRoundEnd[ self:SteamID64() ], { achievement = id } )

		return

	end

	local Achievements = file.Read( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "DATA" )
	local Achieve = {}

	//First time, ever.
	if ( Achievements == nil or Achievements == "" ) then

		Achieve[ id ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, reward = floofAchievements.Achievements[ id ].reward, unlocked = true, category = floofAchievements.Achievements[ id ].category, id = floofAchievements.Achievements[ id ].id, unlockdate = os.date( "%d/%m/%y" ) }

		local rType = floofAchievements.GetAchievementRewardType( id ) or ""
		local rR = floofAchievements.GetAchievementReward( id ) or ""

		local json = util.TableToJSON( Achieve )
		file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", json )

		net.Start( "floofAchievements_UnlockedAchievement" ) net.WriteString( floofAchievements.Achievements[ id ].title or "unknown" ) net.WriteString( floofAchievements.Achievements[ id ].description or "unknown" ) net.WriteString( floofAchievements.FancyRewardType( rType ) ) net.WriteString( rR ) net.Send( self )
		floofAchievements.ClientPrint( false, "[" .. self:Nick() .. "] has earned the achievement " .. "[" .. floofAchievements.Achievements[ id ].title .. "]!" )

		if ( floofAchievements.IsSupportedRewardType( rType ) ) then

			floofAchievements.GiveReward( self, rType, rR )
			
		end

		self:AddToRecentAchievements( id )

		local effectData = EffectData()
		effectData:SetOrigin( self:GetPos() )

		util.Effect( "fluffy_confetti", effectData )

		return

	end

	local CurrAchievements = util.JSONToTable( Achievements )
	if ( CurrAchievements == nil ) then return end

	if ( CurrAchievements and not CurrAchievements[ id ] ) then

		CurrAchievements[ id ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, reward = floofAchievements.Achievements[ id ].reward, unlocked = true, category = floofAchievements.Achievements[ id ].category, id = floofAchievements.Achievements[ id ].id, unlockdate = os.date( "%d/%m/%y" ) }

		local json = util.TableToJSON( CurrAchievements )
		file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", json )

	end

	net.Start( "floofAchievements_UnlockedAchievement" ) net.WriteString( floofAchievements.Achievements[ id ].title or "unknown" ) net.WriteString( floofAchievements.Achievements[ id ].description or "unknown" ) net.WriteString( floofAchievements.FancyRewardType( floofAchievements.GetAchievementRewardType( id ) or "" ) or "" ) net.WriteString( floofAchievements.GetAchievementReward( id ) or "" ) net.Send( self )
	floofAchievements.ClientPrint( false, "[" .. self:Nick() .. "] has earned the achievement " .. "[" .. floofAchievements.Achievements[ id ].title .. "]!" )

	local rType = floofAchievements.GetAchievementRewardType( id ) or ""
	local rR = floofAchievements.GetAchievementReward( id ) or ""

	if ( floofAchievements.IsSupportedRewardType( rType ) ) then

		floofAchievements.GiveReward( self, rType, rR )
			
	end

	self:AddToRecentAchievements( id )

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() )

	util.Effect( "fluffy_confetti", effectData )

end

--[[---------------------------------------------------------
	Name: floofAchievements.HasUnlockedAchievement
	Desc: Checks if the player has unlocked said achievement.
-----------------------------------------------------------]]
function floofAchievements.Client:HasUnlockedAchievement( id )

	if ( not file.IsDir( "floofachievements", "DATA" ) ) then floofAchievements.ConsolePrint( "Unable to check achievement for " .. self:Nick() or "unknown" .. " due to the main data file not existing.", "Please restart the server to fix this issue", "If you have done the above and it still doesn't work then, please contact the author at scriptfodder, not steam." ) return end
	if ( not file.IsDir( "floofachievements/players/" .. self:SteamID64(), "DATA" ) ) then file.CreateDir( "floofachievements/players/" .. self:SteamID64(), "DATA" ) end
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "DATA" ) ) then file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "" ) end
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "DATA" ) ) then file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "" ) end

	local Achievements = file.Read( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "DATA" )
	local json = util.JSONToTable( Achievements )

	if ( json and json[ id ] and json[ id ].id == id and json[ id ].unlocked ) then

		return true

	end

	return false

end

--[[---------------------------------------------------------
	Name: floofAchievements.AddProgression
	Desc: Adds to our progression on said achievement
-----------------------------------------------------------]]
function floofAchievements.Client:AddProgression( id, int, Needed, canUnlock, Overwrite )

	if ( not file.IsDir( "floofachievements", "DATA" ) ) then floofAchievements.ConsolePrint( "Unable to add progression for " .. self:Nick() or "unknown" .. " due to the main data file not existing.", "Please restart the server to fix this issue", "If you have done the above and it still doesn't work then, please contact the author at scriptfodder, not steam." ) return end
	if ( not file.IsDir( "floofachievements/players/" .. self:SteamID64(), "DATA" ) ) then file.CreateDir( "floofachievements/players/" .. self:SteamID64(), "DATA" ) end
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "DATA" ) ) then file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "" ) end
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "DATA" ) ) then file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "" ) end

	local AchievementProgress = file.Read( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "DATA" )
	local Achieve = {}
	Overwrite = Overwrite or false	

	//First time, ever.
	if ( AchievementProgress == nil or AchievementProgress == "" ) then

		if ( canUnlock ) then

			Achieve[ id ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, category = floofAchievements.Achievements[ id ].category, progress = int, needed = Needed, id = floofAchievements.Achievements[ id ].id }

			local json = util.TableToJSON( Achieve )
			file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", json )

			//Call the updated version.
			local UpdatedAchievementProgress = file.Read( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "DATA" )
			local UpdatedJson = util.JSONToTable( UpdatedAchievementProgress )
			local Needed = UpdatedJson[ id ].needed
			local Progress = UpdatedJson[ id ].progress
			local ProgressID = UpdatedJson[ id ].id

			if ( Progress >= Needed and not self:HasUnlockedAchievement( ProgressID ) ) then
			
				self:UnlockAchievement( ProgressID )

			end

			return

		end
		
		Achieve[ id ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, category = floofAchievements.Achievements[ id ].category, progress = 1, id = floofAchievements.Achievements[ id ].id }

		local json = util.TableToJSON( Achieve )
		file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", json )

		return

	end	

	local CurrAchievements = util.JSONToTable( AchievementProgress )
	if ( CurrAchievements == nil ) then return end

	if ( CurrAchievements and floofAchievements.Achievements[ id ] ) then

		if ( not CurrAchievements[ id ] ) then

			CurrAchievements[ id ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, category = floofAchievements.Achievements[ id ].category, progress = int, needed = Needed, id = floofAchievements.Achievements[ id ].id }

			local json = util.TableToJSON( CurrAchievements )
			file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", json )

			//Call the updated version.
			local UpdatedAchievementProgress = file.Read( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "DATA" )
			local UpdatedJson = util.JSONToTable( UpdatedAchievementProgress )
			local Needed = UpdatedJson[ id ].needed
			local Progress = UpdatedJson[ id ].progress
			local ProgressID = UpdatedJson[ id ].id

			if ( Progress >= Needed and not self:HasUnlockedAchievement( ProgressID ) ) then
			
				self:UnlockAchievement( ProgressID )

			end

			return

		end

		local Progress = CurrAchievements[ id ].progress

		if ( Overwrite ) then

			Progress = int

		else

			Progress = Progress + int

		end

		if ( canUnlock ) then

			CurrAchievements[ id ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, category = floofAchievements.Achievements[ id ].category, progress = Progress, needed = Needed, id = floofAchievements.Achievements[ id ].id }

			local json = util.TableToJSON( CurrAchievements )
			file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", json )

			local Needed = CurrAchievements[ id ].needed
			local Progress = CurrAchievements[ id ].progress
			local ProgressID = CurrAchievements[ id ].id

			if ( Progress >= Needed and not self:HasUnlockedAchievement( ProgressID ) ) then
			
				self:UnlockAchievement( ProgressID )

			end

			return

		end

		CurrAchievements[ id ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, category = floofAchievements.Achievements[ id ].category, progress = Progress, id = floofAchievements.Achievements[ id ].id }

		local json = util.TableToJSON( CurrAchievements )
		file.Write( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", json )

	end

end

--[[---------------------------------------------------------
	Name: floofAchievements.AddToRecentAchievements
	Desc: Adds to our recent achievements
-----------------------------------------------------------]]
floofAchievements.RecentAchievements = {}

function floofAchievements.Client:AddToRecentAchievements( id )

	if ( not file.IsDir( "floofachievements", "DATA" ) ) then floofAchievements.ConsolePrint( "Unable to add last five for " .. self:Nick() or "unknown" .. " due to the main data file not existing.", "Please restart the server to fix this issue", "If you have done the above and it still doesn't work then, please contact the author at scriptfodder, not steam." ) return end
	if ( not file.IsDir( "floofachievements/players/" .. self:SteamID64(), "DATA" ) ) then file.CreateDir( "floofachievements/players/" .. self:SteamID64(), "DATA" ) end
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "DATA" ) ) then file.Write( "floofAchievements/players/" .. self:SteamID64() .. "/achievements.txt", "" ) end
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "DATA" ) ) then file.Write( "floofAchievements/players/" .. self:SteamID64() .. "/achievementprogress.txt", "" ) end	
	if ( not file.Exists( "floofachievements/players/" .. self:SteamID64() .. "/recentachievements.txt", "DATA" ) ) then file.Write( "floofAchievements/players/" .. self:SteamID64() .. "/recentachievements.txt", "" ) end
	if ( not self:HasUnlockedAchievement( id ) ) then return end

	for k, v in pairs( floofAchievements.RecentAchievements ) do
		
		if ( floofAchievements.Achievements[ id ].title == v.title ) then
			
			return

		end

	end

	local RecentAchievementsData = file.Read( "floofachievements/players/" .. self:SteamID64() .. "/recentachievements.txt", "DATA" )
	local RecentAchievements = util.JSONToTable( RecentAchievementsData )

	local CompletedAchievementsData = file.Read( "floofachievements/players/" .. self:SteamID64() .. "/achievements.txt", "DATA" )
	local CompletedAchievements = util.JSONToTable( CompletedAchievementsData )

	local Recent = {}

	if ( RecentAchievements == nil or RecentAchievements == "" ) then

		Recent[ 1 ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, reward = floofAchievements.Achievements[ id ].reward, unlocked = true, unlockdate = CompletedAchievements[ id ].unlockdate }

		local json = util.TableToJSON( Recent )
		file.Write( "floofachievements/players/" .. self:SteamID64() .. "/recentachievements.txt", json )

		return

	end

	RecentAchievements[ #RecentAchievements + 1 ] = { title = floofAchievements.Achievements[ id ].title, description = floofAchievements.Achievements[ id ].description, reward = floofAchievements.Achievements[ id ].reward, unlocked = true, unlockdate = CompletedAchievements[ id ].unlockdate }

	local toRemove = floofAchievements.GetLowestNumb( RecentAchievements )

	if ( #RecentAchievements > 5 ) then

		RecentAchievements[ toRemove ] = nil

	end

	local json = util.TableToJSON( RecentAchievements )
	file.Write( "floofachievements/players/" .. self:SteamID64() .. "/recentachievements.txt", json )

end