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


surface.CreateFont( "flufChieve_Buttons", { font = "Roboto Lt", size = 16, antialias = true, weight = 1 } )
surface.CreateFont( "flufChieve_ButtonsSmall", { font = "Roboto Lt", size = 14, antialias = true, weight = 1 } )
surface.CreateFont( "flufChieve_ButtonsExtraSmall", { font = "Roboto Lt", size = 13, antialias = true, weight = 1 } )
surface.CreateFont( "flufChieve_ButtonsTitle", { font = "Roboto Lt", size = 20, antialias = true, weight = 1 } )

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

local I = 0
local AI = 0
local gradient = Material( "gui/center_gradient" )
local icon = Material( "flufmaterials/icon.png" )

floofAchievements.Active = false
floofAchievements.pnl = nil

local blur = Material( "pp/blurscreen" )
local function DrawBlur( panel, amount )

	local x, y = panel:LocalToScreen( 0, 0 )
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( blur )

	for i = 1, 3 do

		blur:SetFloat( "$blur", ( i / 3 ) * ( amount or 6 ) )
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )

	end

end

local PANEL = {}

--[[---------------------------------------------------------
	Name: Category Holder
	Desc: Holds all of our categories
-----------------------------------------------------------]]
function PANEL:CreateCategoryHolder()

	self.CategoryHolder = vgui.Create( "DFrame", self )
	self.CategoryHolder:SetPos( 0, 0 )
	self.CategoryHolder:SetSize( x( .25 ), self:GetTall() )
	self.CategoryHolder:SetTitle( "" )
	self.CategoryHolder:ShowCloseButton( false )
	self.CategoryHolder:SetDraggable( false )
	self.CategoryHolder.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 175 ) )
		draw.RoundedBox( 0, x( .249 ), 0, x( .001 ), h, Color( 0, 0, 0, 175 ) )

	end

	self.Exit = vgui.Create( "DButton", self.CategoryHolder )
	self.Exit:SetPos( x( .01 ), y( 1.13 ) )
	self.Exit:SetSize( x( .23 ), y( .05 ) )
	self.Exit:SetText( "" )
	self.Exit.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		draw.RoundedBox( 0, 0, y( .047 ), w, y( .002 ), Color( 68, 123, 17, 100 ) )
		draw.DrawText( "Exit", "flufChieve_Buttons", x( .002 ), y( .005 ), p:IsHovered() and Color( 68, 123, 17, 100 ) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

	end

	self.Exit.DoClick = function()

		self:Remove()

	end

	return self.CategoryHolder

end

--[[---------------------------------------------------------
	Name: Category Buttons
	Desc: Creates our button(s)
-----------------------------------------------------------]]
function PANEL:CreateCategoryButton( parent, text, func )

	func = func or function() return end

	self.CategoryButton = vgui.Create( "DButton", parent )
	self.CategoryButton:SetPos( x( .01 ), ( y( .0198 ) + y( I ) ) )
	self.CategoryButton:SetSize( x( .23 ), y( .05 ) )
	self.CategoryButton:SetText( "" )
	self.CategoryButton.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		draw.RoundedBox( 0, 0, y( .047 ), w, y( .002 ), Color( 68, 123, 17, 100 ) )
		draw.DrawText( text, "flufChieve_Buttons", x( .002 ), y( .005 ), p:IsHovered() and Color( 68, 123, 17, 100 ) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )

	end

	self.CategoryButton.DoClick = func

	I = I + .06

	return self.CategoryButton

end

--[[---------------------------------------------------------
	Name: Summary Panel
	Desc: Very different than our normal panels.
-----------------------------------------------------------]]
function PANEL:CreateSummaryPanel()

	AI = 0

	if ( IsValid( self.SummaryPanel ) ) then self.SummaryPanel:Remove() end
	if ( IsValid( self.AchievementPanel ) ) then self.AchievementPanel:Remove() end

	local maxAchieve = math.min( floofAchievements.TotalCreatedAchievements, ( floofAchievements.CompletedAchivements == floofAchievements.TotalCreatedAchievements and floofAchievements.CompletedAchivements ) or 0 )
	local ratio = math.Min( floofAchievements.CompletedAchivements / floofAchievements.TotalCreatedAchievements, 1 )

	self.SummaryPanel = vgui.Create( "DFrame", self )
	self.SummaryPanel:SetPos( x( .25 ) , 0 )
	self.SummaryPanel:SetSize( self:GetWide(), self:GetTall() )
	self.SummaryPanel:SetTitle( "" )
	self.SummaryPanel:ShowCloseButton( false )
	self.SummaryPanel:SetDraggable( false )
	self.SummaryPanel.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 175 ) )

		surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
		surface.SetMaterial( gradient )
		surface.DrawTexturedRect( x( .02 ), y( .02 ), x( .7 ), y( .05 ) )
		surface.DrawTexturedRect( x( .02 ), y( .73 ), x( .7 ), y( .05 ) )

		draw.DrawText( "Recent Achievements", "flufChieve_Buttons", x( .36 ), y( .025 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.DrawText( "Progress Overview", "flufChieve_Buttons", x( .355 ), y( .735 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

		surface.SetDrawColor( Color( 0, 0, 0, 175 ) )
		surface.DrawOutlinedRect( x( .009 ), y( .799 ), x( .7314 ), y( .05 ) )

		draw.RoundedBox( 0, x( .009 ), y( .8 ), x( .729 ) * ratio, y( .046 ), Color( 0, 100, 0, 175 ) )

		draw.DrawText( floofAchievements.CompletedAchivements .. "/" .. floofAchievements.TotalCreatedAchievements, "flufChieve_Buttons", x( .73 ), y( .803 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
		draw.DrawText( "Achievements Earned", "flufChieve_Buttons", x( .015 ), y( .803 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		if ( #floofAchievements.RecentAchievements < 1 ) then
			
			draw.DrawText( "Complete Achievements to see your recent Achievements!", "flufChieve_Buttons", x( .36 ), y( .08 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			
		end

	end

	for k, v in pairs( floofAchievements.RecentAchievements ) do

		local mat

		if ( v.unlocked ) then
		
			mat = Material( "flufmaterials/checked.png" )

		else

			mat = Material( "flufmaterials/cross.png" )

		end

		self.RecentAchievement = vgui.Create( "DButton", self.SummaryPanel )
		self.RecentAchievement:SetPos( x( .009 ), ( y( .0798 ) + y( AI ) ) )
		self.RecentAchievement:SetSize( x( .733 ), y( .12 ) )
		self.RecentAchievement:SetText( "" )
		self.RecentAchievement.Paint = function( p, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
			surface.SetDrawColor( Color( 0, 0, 0, 175 ) )
			surface.DrawOutlinedRect( 0, 0, w, h )
			
			if ( v.unlocked ) then

				surface.SetDrawColor( Color( 0, 100, 0, 255 ) )
				surface.SetMaterial( mat )
				surface.DrawTexturedRect( x( .7 ), y( .015 ), 16, 16 )

			else

				surface.SetDrawColor( Color( 100, 0, 0, 255 ) )
				surface.SetMaterial( mat )
				surface.DrawTexturedRect( x( .7 ), y( .015 ), 16, 16 )

			end

			surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
			surface.SetMaterial( gradient )
			surface.DrawTexturedRect( x( .01 ), y( .01 ), x( .7 ), y( .05 ) )
				
			draw.DrawText( v.title, "flufChieve_ButtonsTitle", x( .35 ), y( .01 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER )
			draw.DrawText( v.description, "flufChieve_Buttons", x( .35 ), y( .06 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER )
			draw.DrawText( v.unlockdate, "flufChieve_ButtonsSmall", x( .69 ), y( .017 ), Color( 255, 255, 255, 100 ), TEXT_ALIGN_RIGHT )

			surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
			surface.SetMaterial( icon )
			surface.DrawTexturedRect( x( .01 ), y( .01 ), 32, 32 )

		end
			
		AI = AI + .13

	end		

	return self.SummaryPanel	

end

--[[---------------------------------------------------------
	Name: Achievement Panel
	Desc: Here's where we're going to store our Achievements.
-----------------------------------------------------------]]
function PANEL:CreateAchievementPanel()

	if ( IsValid( self.AchievementPanel ) ) then self.AchievementPanel:Remove() end

	AI = 0 

	self.AchievementPanel = vgui.Create( "DScrollPanel", self )
	self.AchievementPanel:SetPos( x( .25 ) , 0 )
	self.AchievementPanel:SetSize( self:GetWide(), self:GetTall() )
	self.AchievementPanel.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 175 ) )

	end

	return self.AchievementPanel	

end


--[[---------------------------------------------------------
	Name: Achievement Buttons
	Desc: Creates our button(s)
-----------------------------------------------------------]]
function PANEL:CreateAchievementButton( parent, title, desc, rewardType, rewardInt, unlocked, unlockdate, progress, needed, func )
 
    func = func or function() return end
    local prefix = "Reward: "
   
    rewardType = rewardType or ""
    rewardInt = rewardInt or ""
    unlocked = tobool( unlocked )
 
    if ( rewardType == "" or rewardType == nil ) then
       
        prefix = ""
 
    end
 
    local mat
 
    if ( unlocked ) then
       
        mat = Material( "flufmaterials/checked.png" )
 
    else
 
        mat = Material( "flufmaterials/cross.png" )
 
    end
 
    self.AchievementButton = vgui.Create( "DButton", parent )
    self.AchievementButton:SetPos( x( .009 ), ( y( .0198 ) + y( AI ) ) )
    self.AchievementButton:SetSize( x( .733 ), y( .2 ) )
    self.AchievementButton:SetText( "" )
    self.AchievementButton.Paint = function( p, w, h )
   
        if ( progress != "" and needed != "" ) then
            local percentage = math.Clamp( progress / needed, 0, 1 )
            local poly = {
                { x = x( .2 ), y = y( .198 ) },
                { x = x( .2 ), y = y( .17 ) },
                { x = x( .212 ), y = y( .15 ) },
                { x = x( .4 ), y = y( .15 ) },
                { x = x( .517 ), y = y( .15 ) },
                { x = x( .529 ), y = y( .172 ) },
                { x = x( .529 ), y = y( .198 ) },
            }
           
            render.ClearStencil()
            render.SetStencilEnable(true)
 
            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )
 
            render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
            render.SetStencilPassOperation( STENCILOPERATION_ZERO )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
            render.SetStencilReferenceValue( 1 )
 
            surface.SetDrawColor( color_white )
            draw.NoTexture()
            surface.DrawPoly( poly )
            surface.DrawRect( x( .002 ), y( .172 ), x( .221 ), y( .028 ) )
            surface.DrawRect( x( .51 ), y( .172 ), x( .221 ), y( .028 ) )
 
            render.SetStencilFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
            render.SetStencilReferenceValue( 1 )
 
            draw.RoundedBox( 0, 0, y( .15 ), w * percentage, y( .05 ), Color( 0, 100, 0, 175 ) )
 
            render.SetStencilEnable(false)
            render.ClearStencil()

        end
 
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
        surface.SetDrawColor( Color( 0, 0, 0, 175 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
       
        if ( unlocked ) then
 
            surface.SetDrawColor( Color( 0, 100, 0, 255 ) )
            surface.SetMaterial( mat )
            surface.DrawTexturedRect( x( .7 ), y( .015 ), 16, 16 )
 
        else
 
            surface.SetDrawColor( Color( 100, 0, 0, 255 ) )
            surface.SetMaterial( mat )
            surface.DrawTexturedRect( x( .7 ), y( .015 ), 16, 16 )
 
        end
 
        surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
        surface.SetMaterial( gradient )
        surface.DrawTexturedRect( x( .01 ), y( .01 ), x( .7 ), y( .05 ) )
           
        draw.DrawText( title, "flufChieve_ButtonsTitle", x( .35 ), y( .01 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER )
        draw.DrawText( desc, "flufChieve_Buttons", x( .35 ), y( .06 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER )
        draw.DrawText( prefix .. rewardInt .. " " .. rewardType, "flufChieve_Buttons", x( .36 ), y( .15 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER )
        draw.DrawText( unlockdate or "", "flufChieve_ButtonsSmall", x( .69 ), y( .015 ), Color( 255, 255, 255, 100 ), TEXT_ALIGN_RIGHT )
 
        surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
        surface.SetMaterial( icon )
        surface.DrawTexturedRect( x( .01 ), y( .01 ), 32, 32 )     
 
        if ( rewardType ~= "" or rewardTpye ~= nil ) then
 
            //DrawLine xdddd
            surface.DrawLine( x( .2 ), y( .17 ), 0, y( .17 ) )
            surface.DrawLine( x( .2113 ), y( .15 ), x( .2 ), y( .17 ) )
            surface.DrawLine( x( .4 ), y( .15 ), x( .211 ), y( .15 ) )
            surface.DrawLine( x( .4 ), y( .15 ), x( .517 ), y( .15 ) )
            surface.DrawLine( x( .517 ), y( .15 ), x( .529 ), y( .172 ) )
            surface.DrawLine( x( .529 ), y( .171 ), x( .75 ), y( .171 ) )
 
        end
 
        if ( progress != "" and needed != "" ) then
 
            draw.DrawText( "Progress: " .. progress .. "/" .. needed, "flufChieve_ButtonsExtraSmall", x( .002 ), y( .168 ), Color( 255, 255, 255, 100 ), TEXT_ALIGN_LEFT )
 
        end
       
    end
 
    self.AchievementButton.OnMousePressed = function()
 
        func( self.AchievementButton, parent )
 
    end
 
    AI = AI + .21
 
    return self.AchievementButton
 
end

function PANEL:Init()

	I = 0
	AI = 0

	self:SetPos( x( .5 ), y( .4 ) )
	self:SetSize( x( 1 ), y( 1.2 ) )
	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:SetDraggable( false )
	self:MakePopup()

	local cat = self:CreateCategoryHolder()
	self:CreateCategoryButton( cat, "Summary", function() self:CreateSummaryPanel() end )

	for k, v in SortedPairsByValue( floofAchievements.Categories ) do
		
		self:CreateCategoryButton( cat, k, function()

			local AchievementFrame = self:CreateAchievementPanel()
			if ( IsValid( self.SummaryPanel ) ) then self.SummaryPanel:Remove() end

			for _, Achievements in SortedPairsByMemberValue( floofAchievements.Achievements, "unlocked" ) do
				
				if ( Achievements.category == k ) then

					self:CreateAchievementButton( AchievementFrame, Achievements.title, Achievements.description, Achievements.rewardType, Achievements.rewardInt, Achievements.unlocked, Achievements.unlockdate, Achievements.progress or "", Achievements.needed or "" )

				end

			end

		end )

	end

	floofAchievements.Active = true
	floofAchievements.pnl = self
	self:CreateSummaryPanel()

end

function PANEL:Paint( w, h )

	DrawBlur( self, 5 )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 175 ) )
	surface.SetDrawColor( Color( 20, 20, 20, 200 ) )
	surface.DrawOutlinedRect( 0, 0, w, h )

end
derma.DefineControl( "flufchieve_achievementui", "", PANEL, "DFrame" )