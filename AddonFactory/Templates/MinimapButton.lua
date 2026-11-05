local MVC = LibStub("LibMVC-1.0")

MVC:Controller("AddonFactory.MinimapButton", function()

	local function GetIconAngle()
		local xPos, yPos = GetCursorPosition()
		
		-- 12.x : Get the ui scale inside this function, Blizzard no longer properly returns it outside.
		local uiScale = UIParent:GetScale()

		-- X-Axis
		local left = Minimap:GetLeft()
		local right = Minimap:GetRight()
		local offsetX = (right - left) / 2

		-- Y-Axis
		local top = Minimap:GetTop()
		local bottom = Minimap:GetBottom()
		local offsetY = (top - bottom) / 2

		-- Convert cursor coordinates
		xPos = left - xPos/uiScale + offsetX 
		yPos = yPos/uiScale - bottom - offsetY 

		-- Get the angle
		local iconAngle = math.deg(math.atan2(yPos, xPos))
		
		-- Clamp it to 0..360
		if iconAngle < 0 then
			iconAngle = iconAngle + 360
		end
		
		return iconAngle
	end

	local buttons = {}

	return {
		OnBind = function(frame)
		end,
		Initialize = function(frame, info)
			--[[	self:Initialize({
						addonName = "addon table name",
						icon = "Interface\\Icons\\INV_Drink_13",
						iconAngleOption = "UI.Minimap.IconAngle",
						iconRadiusOption = "UI.Minimap.IconRadius",
						onUpdate = function() 
							-- do stuff
						end,
					})
			--]]
		
			buttons[frame] = info
			
			frame.Icon:SetTexture(info.icon)
			frame:RegisterForClicks("LeftButtonDown", "RightButtonDown")
			frame:RegisterForDrag("RightButton")
		end,
		Move = function(frame)
			local info = buttons[frame]
			local addon = _G[info.addonName]
			
			local options = _G[info.options].Minimap
			local angle = options.IconAngle
			local radius = options.IconRadius
			
			frame:SetPoint( "TOPLEFT", "Minimap", "TOPLEFT", 79 - (radius * cos(angle)), (radius * sin(angle)) - 83)
		end,
		Update = function(frame)
			
			if frame.isMoving then
				local info = buttons[frame]
				local addon = _G[info.addonName]
			
				local iconAngle = GetIconAngle()
				local options = _G[info.options].Minimap
				options.IconAngle = iconAngle
				
				frame:Move()

				if info.onUpdate then
					info.onUpdate(iconAngle)
				end
			end
		end,
	}
end)
