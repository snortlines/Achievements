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
floofAchievements.AchievementProgress = floofAchievements.AchievementProgress or {}
floofAchievements.Client = floofAchievements.Client or FindMetaTable( "Player" )
floofAchievements.ShouldUnlockOnRoundEnd = floofAchievements.ShouldUnlockOnRoundEnd or {}
floofAchievements.IsRoundEnding = false

if ( CLIENT ) then return end

if ( file.IsDir( "floofachievements", "DATA" ) ) then file.Write( "floofachievements/achievements/achievements.txt", "" ) end

function floofAchievements.CreateDirs()

	if ( file.IsDir( "floofachievements", "DATA" ) ) then return end

	file.CreateDir( "floofachievements", "DATA" )
	file.CreateDir( "floofachievements/players", "DATA" )

end
hook.Add( "Initialize", "floofAchievements_CreateDirs", floofAchievements.CreateDirs )

function floofAchievements.SetAchievements( ply )

	floofAchievements.ShouldUnlockOnRoundEnd[ ply:SteamID64() ] = {}

end
hook.Add( "PlayerInitialSpawn", "floofachievements.setachievements", floofAchievements.SetAchievements )