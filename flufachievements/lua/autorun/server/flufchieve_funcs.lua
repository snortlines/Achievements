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
floofAchievements.Rewards = {}

--[[---------------------------------------------------------
	Name: floofAchievements.ConsolePrint
	Desc: Prints to our console; much easier to use than MsgC( ... )
-----------------------------------------------------------]]
function floofAchievements.ConsolePrint( ... )

	local args = { ... }

	if ( not args[ 1 ] ) then floofAchievements.ConsolePrint( "Unable to console print: No arguments provided." ) return end
	if ( not MsgC ) then return end

	for _, v in pairs( args ) do

		MsgC( Color( 255, 255, 0, 255 ), "[floofAchievements]: ", Color( 255, 255, 255, 255 ), tostring( v ) .. "\n" )

	end

end

--[[---------------------------------------------------------
	Name: floofAchievements.ClientConsolePrint
	Desc: Prints to our clients console; much easier to use than MsgC( ... )
-----------------------------------------------------------]]
util.AddNetworkString( "flufchieve_clientconsoleprint" )

function floofAchievements.ClientConsolePrint( ply, ... )

	local args = { ... }

	if ( not args[ 1 ] ) then floofAchievements.ConsolePrint( "Unable to client console print: No arguments provided." ) return end
	if ( not MsgC ) then return end
	if ( not ply or not IsValid( ply ) ) then return end

	net.Start( "flufchieve_clientconsoleprint" )
		net.WriteTable( args )
	net.Send( ply )

end

--[[---------------------------------------------------------
	Name: floofAchievements.ClientPrint
	Desc: Prints to our clients;
-----------------------------------------------------------]]
util.AddNetworkString( "flufchieve_clientprint" )

function floofAchievements.ClientPrint( ply, ... )

	local args = { ... }

	if ( not args[ 1 ] ) then floofAchievements.ConsolePrint( "Unable to client print: No arguments provided." ) return end

	if ( not ply or not IsValid( ply ) ) then

		net.Start( "flufchieve_clientprint" )
			net.WriteTable( args )
		net.Broadcast()

		return

	end

	net.Start( "flufchieve_clientprint" )
		net.WriteTable( args )
	net.Send( ply )

end

--[[---------------------------------------------------------
	Name: floofAchievements.GetAchievementName
	Desc: Returns the name of our achievement
-----------------------------------------------------------]]
function floofAchievements.GetAchievementName( id )

	if ( not floofAchievements.Achievements ) then return end
	if ( not id or id == nil ) then return end
	if ( not isnumber( id ) ) then floofAchievements.ConsolePrint( "Unable to find name: The id you provided is not a number." ) return end
	if ( not floofAchievements.Achievements[ id ] ) then floofAchievements.ConsolePrint( "Unable to find name: The achievement does not exist." ) return end

	return floofAchievements.Achievements[ id ].title or "unknown"

end

--[[---------------------------------------------------------
	Name: floofAchievements.GetAchievementDescription
	Desc: Returns the description of our achievement
-----------------------------------------------------------]]
function floofAchievements.GetAchievementDescription( id )

	if ( not floofAchievements.Achievements ) then return end
	if ( not id or id == nil ) then return end
	if ( not isnumber( id ) ) then floofAchievements.ConsolePrint( "Unable to find description: the id you provided is not a number." ) return end
	if ( not floofAchievements.Achievements[ id ] ) then floofAchievements.ConsolePrint( "Unable to find description: The achievement does not exist." ) return end

	return floofAchievements.Achievements[ id ].description or "unknown"

end

--[[---------------------------------------------------------
	Name: floofAchievements.GetAchievementReward
	Desc: Returns the reward for our achievement
-----------------------------------------------------------]]
function floofAchievements.GetAchievementReward( id )

	if ( not id ) then floofAchievements.ConsolePrint( "Unable to get reward: id is nil." ) return end
	if ( not floofAchievements.Achievements[ id ] ) then floofAchievements.ConsolePrint( "Unable to retreive reward for: " .. tostring( id ) .. "; Achievement doesn't exist." ) return end
	if ( not floofAchievements.Achievements[ id ].reward ) then floofAchievements.ConsolePrint( "Unable to retreive reward for: " .. tostring( id ) .. "; This achievement doesn't have a reward" ) return end

	for k, v in pairs( floofAchievements.Achievements[ id ].reward ) do

		if ( floofAchievements.IsSupportedRewardType( k ) ) then

			return v

		end	

	end

	return ""

end

--[[---------------------------------------------------------
	Name: floofAchievements.GetAchievementRewardType
	Desc: Returns the reward type for our achievement
-----------------------------------------------------------]]
function floofAchievements.GetAchievementRewardType( id )

	if ( not id ) then floofAchievements.ConsolePrint( "Unable to get reward type: id is nil." ) return end
	if ( not floofAchievements.Achievements[ id ] ) then floofAchievements.ConsolePrint( "Unable to retreive reward type for: " .. tostring( id ) .. "; Achievement doesn't exist." ) return end
	if ( not floofAchievements.Achievements[ id ].reward ) then floofAchievements.ConsolePrint( "Unable to retreive reward type for: " .. tostring( id ) .. "; This achievement doesn't have a reward" ) return end

	for k, v in pairs( floofAchievements.Achievements[ id ].reward ) do

		if ( floofAchievements.IsSupportedRewardType( k ) ) then
			
			return k

		end

	end

	return

end

--[[---------------------------------------------------------
	Name: floofAchievements.CreateAchievementReward
	Desc: Creates the rewards
-----------------------------------------------------------]]
function floofAchievements.CreateAchievementReward( id, func )

	if ( floofAchievements.Rewards[ id ] ) then return end

	floofAchievements.Rewards[ id ] = func

end

floofAchievements.CreateAchievementReward( "darkrp_money", function( ply, int ) ply:addMoney( int ) end )
floofAchievements.CreateAchievementReward( "pointshop2", function( ply, int ) ply:PS2_AddStandardPoints( int ) end )
floofAchievements.CreateAchievementReward( "pointshop2_premium", function( ply, int ) ply:PS2_AddPremiumPoints( int ) end )
floofAchievements.CreateAchievementReward( "pointshop", function( ply, int ) ply:PS_GivePoints( int ) end )
floofAchievements.CreateAchievementReward( "pointshop_item", function( ply, item ) ply:PS_GiveItem( item ) end  )
floofAchievements.CreateAchievementReward( "set_usergroup_ulx", function( ply, group ) RunConsoleCommand( "ulx", "adduserid", ply:SteamID(), group ) end )
floofAchievements.CreateAchievementReward( "give_weapon", function( ply, wep ) ply:Give( wep ) end )
floofAchievements.CreateAchievementReward( "set_runspeed", function( ply, int ) ply:SetRunSpeed( int ) end )
floofAchievements.CreateAchievementReward( "vrondakis_add_xp", function( ply, int ) ply:addXP( int ) end )
floofAchievements.CreateAchievementReward( "vrondakis_set_level", function( ply, int ) ply:setDarkRPVar( "level", int ) end )

--[[---------------------------------------------------------
	Name: floofAchievements.IsSupportedRewardType
	Desc: Creates the rewards
-----------------------------------------------------------]]
function floofAchievements.IsSupportedRewardType( str )

	if ( str == "" or str == nil ) then return false end

	local converter = { 

		[ "darkrp_money" ] = function() if ( DarkRP ) then return true end return false end,
		[ "pointshop2" ] = function() if ( Pointshop2 ) then return true end return false end,
		[ "pointshop2_premium" ] = function() if ( Pointshop2 ) then return true end return false end,
		[ "pointshop" ] = function() if ( PS ) then return true end return false end,
		[ "vrondakis_xp" ] = function() if ( LevelSystemConfiguration ) then return true end return false end,
		[ "set_usergroup_ulx" ] = function() if ( ulx ) then return true end return false end,

	}

	if ( converter[ str ] ) then

		return converter[ str ]()

	end

	floofAchievements.ConsolePrint( str .. " isn't supported by floofAchievements. Add it yourself by using floofAchievements.CreateAchievementReward", "Example: floofAchievements.CreateAchievementReward( \"darkrp_money\", function( ply, int ) ply:addMoney( int ) end ) " )

	return "unknown"

end

--[[---------------------------------------------------------
	Name: floofAchievements.GetAllRewardTypes
	Desc: Get all of our reward types
-----------------------------------------------------------]]
function floofAchievements.GetAllRewardTypes()

	if ( not floofAchievements.Rewards ) then return end

	return floofAchievements.Rewards or {}

end

--[[---------------------------------------------------------
	Name: floofAchievements.FancyRewardType
	Desc: Gets our fancy name for SupportedRewardTypes
-----------------------------------------------------------]]
function floofAchievements.FancyRewardType( str )

	if ( str == "" or str == nil ) then return "" end

	local Converter =
	{

		[ "darkrp_money" ] = "DarkRP Money",
		[ "pointshop2" ] = "Standard Points",
		[ "pointshop2_premium" ] = "Premium Points",
		[ "pointshop1" ] = "Pointshop Points",
		[ "set_usergroup_ulx" ] = "Usergroup",
		[ "give_weapon" ] = "Weapon",
		[ "set_runspeed" ] = "Run speed",

	}

	for k, v in pairs( Converter ) do

		if ( string.find( string.lower( k ), string.lower( str ) ) ) then
			
			return v

		end

	end

	return ""

end

--[[---------------------------------------------------------
	Name: floofAchievements.GiveReward
	Desc: Gives the reward
-----------------------------------------------------------]]
function floofAchievements.GiveReward( ply, id, reward )

	if ( not ply or not IsValid( ply ) ) then floofAchievements.ConsolePrint( "Unable to give reward: ply is nil or doesn't exist." ) return end
	if ( not floofAchievements.Rewards[ id ] ) then floofAchievements.ConsolePrint( "Unable to give reward: ID doesn't exist." ) return end
	if ( not reward or reward == nil ) then floofAchievements.ConsolePrint( "Unable to give reward: Reward is nil or is in the wrong format." ) return end
	if ( id == nil ) then return end

	floofAchievements.Rewards[ id ]( ply, reward )

end

--[[---------------------------------------------------------
	Name: floofAchievements.GetAchievementUniqueID
	Desc: Returns the unique id for our achievement
-----------------------------------------------------------]]
function floofAchievements.GetAchievementUniqueID( name )

	if ( not floofAchievements.Achievements ) then return end
	if ( not name or name == "" ) then return end

	local tbl = {}

	name = string.lower( name )

	for k, v in pairs( floofAchievements.GetAchievements() ) do
		
		local title = string.lower( v.title )

		if ( name == title ) then

			table.insert( tbl, v.id )

			break

		else

			if ( string.find( title, name ) ) then
				
				table.insert( tbl, v.id )

			end

		end

	end

	if ( #tbl > 1 ) then
		
		floofAchievements.ConsolePrint( "Unable to find unique id: There were multiple results, please be more specific." )

		return "Unable to find unique id: There were multiple results, please be more specific."

	end

	if ( #tbl < 1 ) then
		
		floofAchievements.ConsolePrint( "Unable to find unique id: There is nothing named: " .. name )

		return "Unable to find unique id: There is nothing named: " .. name		

	end

	floofAchievements.ConsolePrint( "Found unique id; Title -> " .. floofAchievements.GetAchievementName( tbl[ 1 ] ) .. " -> ID -> " .. tbl[ 1 ] )

	return tbl[ 1 ]

end

--[[---------------------------------------------------------
	Name: floofAchievements.GetAchievements
	Desc: Returns all the achievements we have
-----------------------------------------------------------]]
function floofAchievements.GetAchievements()

	if ( not floofAchievements.Achievements ) then return end

	local achievementsData = file.Read( "floofachievements/achievements/achievements.txt", "DATA" )
	local Achievements = util.JSONToTable( achievementsData )

	return Achievements

end

--[[---------------------------------------------------------
	Name: floofAchievements.AchievementSearch
	Desc: Searches our input then prints to us.
-----------------------------------------------------------]]
function floofAchievements.AchievementSearch( ply, text )

	if ( not ply or not IsValid( ply ) ) then return end

	if ( string.sub( text, 1, 18 ) == "!achievementsearch" or string.sub( text, 1, 18 ) == "/achievementsearch" ) then
		
		local Achievement = string.sub( text, 20 )
		local Search = floofAchievements.GetAchievementUniqueID( Achievement )

		if ( Search == "" or Search == nil )  then
			
			floofAchievements.ClientPrint( ply, Search )

			return ""

		end

		local Title = floofAchievements.GetAchievementName( Search )
		local Description = floofAchievements.GetAchievementDescription( Search )

		if ( Title == "" or Title == nil or Description == "" or Description == nil ) then
			
			floofAchievements.ClientPrint( ply, Search )

			return ""

		end

		floofAchievements.ClientPrint( ply, "Found data for: " .. Achievement, "Description: " .. Description, "For the full data list, please look in your console." )
		floofAchievements.ClientConsolePrint( ply, "Achievement ID: " .. Search, "Achievement Title: " .. Title, "Achievement Description: " .. Description )

		return ""

	end

end
hook.Add( "PlayerSay", "flufchieve_playersayachievementsearch", floofAchievements.AchievementSearch )

--[[---------------------------------------------------------
	Name: floofAchievements.GetLowestNumb
	Desc: Returns the lowest number
-----------------------------------------------------------]]
function floofAchievements.GetLowestNumb( tbl )

	if ( not istable( tbl ) ) then floofAchievements.ConsolePrint( "Unable to retreive lowest number from " .. tostring( tbl ) .. " the argument provided is not a table" ) return end

	local lowest = 0
	local foundLowest = false

	for k, v in pairs( tbl ) do
		
		if ( not foundLowest or k < lowest ) then
			
			foundLowest = k

		end

	end

	return foundLowest

end

--[[---------------------------------------------------------
	Name: Opens the UI on the player
-----------------------------------------------------------]]
util.AddNetworkString( "flufchieve_openui" )
util.AddNetworkString( "flufchieve_requestuifromclient" )

function floofAchievements.OpenAchievementUI( ply )

	if ( not ply or not IsValid( ply ) ) then return end
	
	local temptbl = {}

	for k, v in pairs( floofAchievements.GetAchievements() ) do
		
		temptbl[ k ] = v

		if ( ply:HasUnlockedAchievement( k ) ) then	

			temptbl[ k ].unlocked = tostring( true )

		end

		local rType = floofAchievements.GetAchievementRewardType( k )
		local rR = floofAchievements.GetAchievementReward( k )
		local fName = floofAchievements.FancyRewardType( rType )

		temptbl[ k ].rewardType = fName
		temptbl[ k ].rewardInt = rR

	end

	local progressTableData = file.Read( "floofachievements/players/" .. ply:SteamID64() .. "/achievementprogress.txt", "DATA" )
	local progressTable = util.JSONToTable( progressTableData )

	local recentAchievementsData = file.Read( "floofachievements/players/" .. ply:SteamID64() .. "/recentachievements.txt", "DATA" )
	local recentAchievements = util.JSONToTable( recentAchievementsData or "" )

	net.Start( "flufchieve_openui" ) net.WriteTable( temptbl or {} ) net.WriteTable( progressTable or {} ) net.WriteTable( recentAchievements or {} ) net.WriteString( floofAchievements.TotalCreatedAchievements or "0" ) net.Send( ply )

end

net.Receive( "flufchieve_requestuifromclient", function( _, ply )

	if ( not ply or not IsValid( ply ) ) then return end

	floofAchievements.OpenAchievementUI( ply )

end )

function floofAchievements.OpenAchievementUICommand( ply, text )

	if ( not ply or not IsValid( ply ) ) then return end

	text = string.lower( text )
	local str = string.lower( floofAchievements.Config.ChatCommandUI )
	local strcount = #floofAchievements.Config.ChatCommandUI + 1

	if ( string.sub( text, 1, strcount ) == "!" .. str ) then

		if ( floofAchievements.Config.UseKey ) then return end
		
		floofAchievements.OpenAchievementUI( ply )

	end

end
hook.Add( "PlayerSay", "flufchieve_openuichatcommand", floofAchievements.OpenAchievementUICommand )

function floofAchievements.UnlockAchievementsOnRound()

	floofAchievements.IsRoundEnding = true

	timer.Simple( 1, function()

		for k, v in pairs( floofAchievements.ShouldUnlockOnRoundEnd ) do

			local ply = player.GetBySteamID64( k )
			
			if ( IsValid( ply ) ) then

				for _, achievemvents in pairs( floofAchievements.ShouldUnlockOnRoundEnd[ ply:SteamID64() ] ) do
			
					ply:UnlockAchievement( achievemvents.achievement )

				end

				floofAchievements.ShouldUnlockOnRoundEnd[ ply:SteamID64() ] = {}

			end

		end

	end )

end
hook.Add( "TTTEndRound", "floofachievements.unlock", floofAchievements.UnlockAchievementsOnRound )