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

surface.CreateFont( "flufChieve_Title", { font = "Roboto Lt", size = 24, antialias = true, weight = 1 } )
surface.CreateFont( "flufChieve_Description", { font = "Roboto Lt", size = 18, antialias = true, weight = 1 } )

--[[---------------------------------------------------------
	Name: xPos - So I don't have to type ( ScrW() / 2 ) * .1
-----------------------------------------------------------]]
local function x( times )

	return ( ScrW() / 2 ) * times

end

--[[---------------------------------------------------------
	Name: yPos - So I don't have to type ( ScrH() / 2 ) * .1
-----------------------------------------------------------]]
local function y( times )

	return ( ScrH() / 2 ) * times

end

local blur = Material( "pp/blurscreen" )

local function DrawBlur( panel, amount, alpha )

	local x, y = panel:LocalToScreen( 0, 0 )
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do

		blur:SetFloat( "$blur", ( i / 3 ) * ( amount or 6 ) )
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )

	end

end

local PANEL = {}
local i = 1.7

function PANEL:Init()

	self.alpha = 175
	self.shouldLerp = false
	self.countdown = 10
	self.currtime = CurTime() + 2
	self.achievementcolor = math.random( 1, 100 )
	self.achievementcolor2 = math.random( 1, 50 )
	self.achievementcolor3 = math.random( 1, 100 )

	self.id = math.random( 1, 10000 )

	self:SetPos( x( .75 ), y( i ) )
	self:SetSize( x( .5 ), y( .25 ) )
	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:SetDraggable( false )
	//self:CreateAchievementIcon()

	timer.Create( "remove_achievement_" .. self.id, self.countdown, 1, function()
		
		if ( ValidPanel( self ) ) then
			
			self.shouldLerp = true

		end

	end )

	i = i - .3

end

function PANEL:CreateAchievementIcon()

	self.iconFrame = vgui.Create( "DFrame" )
	self.iconFrame:SetPos( x( .6 ), y( i ) )
	self.iconFrame:SetSize( x( .15 ), y( .25 ) )
	self.iconFrame:SetTitle( "" )
	self.iconFrame:ShowCloseButton( false )
	self.iconFrame:SetDraggable( false )
	self.iconFrame.Paint = function( p, w, h )

		DrawBlur( p, 5, self.alpha )
		draw.RoundedBox( 8, 0, 0, w, h, p:IsHovered() and Color( 40, 40, 40, self.alpha ) or Color( 0, 0, 0, self.alpha ) )

	end

end

function PANEL:SetAchievementTitle( str )

	self.str = str or "unknown"

end

function PANEL:GetAchievementTitle()

	if ( string.len( self.str ) > 40 ) then
		
		return string.sub( self.str, 1, 40 ) .. "..." or ""

	end

	return self.str

end

function PANEL:SetReward( str )

	self.reward = str or ""

end

function PANEL:GetReward()

	return self.reward or ""

end

function PANEL:Paint( w, h )

	DrawBlur( self, 5, self.alpha )
	draw.RoundedBox( 8, 0, 0, w, h, self:IsHovered() and Color( 40, 40, 40, self.alpha ) or Color( 0, 0, 0, self.alpha ) )
	draw.RoundedBox( 0, 0, y( .068 ), w, y( .002 ), Color( 0, 0, 0, self.alpha ) )
	draw.RoundedBox( 0, 0, y( .18 ), w, y( .002 ), Color( 0, 0, 0, self.alpha ) )
	draw.RoundedBoxEx( 8, 0, 0, w, h - y( .18 ), Color( self.achievementcolor, self.achievementcolor3, self.achievementcolor2, self.alpha ), true, true, false, false )
	draw.RoundedBoxEx( 8, 0, y( .18 ), w, h - y( .18 ), Color( self.achievementcolor, self.achievementcolor3, self.achievementcolor2, self.alpha ), false, false, true, true )

	draw.DrawText( "Achievement Earned", "flufChieve_Description", x( .255 ), y( .02 ), Color( 255, 255, 255, self.alpha ), TEXT_ALIGN_CENTER )
	draw.DrawText( self:GetAchievementTitle(), "flufChieve_Title", x( .255 ), y( .1 ), Color( 255, 255, 255, self.alpha ), TEXT_ALIGN_CENTER )
	draw.DrawText( self:GetReward(), "flufChieve_Description", x( .255 ), y( .2 ), Color( 255, 255, 255, self.alpha ), TEXT_ALIGN_CENTER )

	self.achievementcolor = math.Approach( self.achievementcolor, 0, .1 )
	self.achievementcolor2 = math.Approach( self.achievementcolor2, 0, .1 )
	self.achievementcolor3 = math.Approach( self.achievementcolor3, 0, .1 )

	if ( self:IsHovered() and self.currtime < CurTime() ) then

		timer.Destroy( "remove_achievement_" .. self.id ) //Timer adjust doesn't work here, need to-recreate it.
		timer.Create( "remove_achievement_" .. self.id, self.countdown, 1, function()
			
			if ( ValidPanel( self ) ) then
				
				self.shouldLerp = true

			end

		end )

		self.alpha = 175
		self.shouldLerp = false
		self.currtime = CurTime() + 2

	end

	if ( self.shouldLerp ) then

		self.alpha = math.Approach( self.alpha, 0, 1 )

	end

	if ( self.alpha < 1 ) then
		
		self:Remove()
		//self.iconFrame:Remove()

		i = i + .3

		return

	end

end
derma.DefineControl( "floofAchievements_AchievementUnlockedUI", "", PANEL, "DFrame" )