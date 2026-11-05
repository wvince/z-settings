local MVC = LibStub("LibMVC-1.0")

MVC:Controller("AddonFactory.PanelTabButton", function()
	local TAB_SIDES_PADDING = 20

	return {
		OnBind = function(frame)
			frame:SetFrameLevel(frame:GetFrameLevel() + 4)
			frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
		end,
		
		Resize = function(frame, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
			-- Note: this is a port PanelTemplates_TabResize 
			-- from Interface/AddOns/Blizzard_SharedXML/Mainline/SharedUIPanelTemplates.lua
			-- 
			-- For the auction house UI, all these parameters are passed as nil, but I still kept them.
						
			local textButton = frame.Text
			
			textButton:SetWidth(absoluteTextSize or 0)

			local textWidth = textButton:GetStringWidth()
			local width = textWidth + TAB_SIDES_PADDING + (padding or 0)
			local sideWidths = frame.Left:GetWidth() + frame.Right:GetWidth()
			minWidth = minWidth or sideWidths

			if absoluteSize then
				width = (absoluteSize < sideWidths) and sideWidths or absoluteSize
			else
				if maxWidth and width > maxWidth then
					width = maxWidth
				elseif minWidth and width < minWidth then
					width = minWidth
				end
			end
			
			textWidth = width - TAB_SIDES_PADDING - (padding or 0)

			textButton:SetWidth(textWidth)
			frame:SetWidth(width)
		end,
		
		SetDisabledState = function(frame)
			frame.Left:Show()
			frame.Middle:Show()
			frame.Right:Show()
			frame:Disable()
			frame:SetDisabledFontObject(GameFontDisableSmall)

			local offsetY = frame.deselectedTextY or 2
			if frame.isTopTab then
				offsetY = -offsetY - 6
			end

			frame.Text:SetPoint("CENTER", frame, "CENTER", (frame.deselectedTextX or 0), offsetY)

			frame.LeftActive:Hide()
			frame.MiddleActive:Hide()
			frame.RightActive:Hide()
		end,
		
		Deselect = function(frame)
			frame.Left:Show()
			frame.Middle:Show()
			frame.Right:Show()
			frame:Enable()

			local offsetY = frame.deselectedTextY or 2
			if frame.isTopTab then
				offsetY = -offsetY - 6
			end

			frame.Text:SetPoint("CENTER", frame, "CENTER", (frame.deselectedTextX or 0), offsetY)

			frame.LeftActive:Hide()
			frame.MiddleActive:Hide()
			frame.RightActive:Hide()
		end,
		
		Select = function(frame)
			frame.Left:Hide()
			frame.Middle:Hide()
			frame.Right:Hide()
			frame:Disable();
			frame:SetDisabledFontObject(GameFontHighlightSmall)

			local offsetY = frame.selectedTextY or -3
			if frame.isTopTab then
				offsetY = -offsetY - 7
			end

			frame.Text:SetPoint("CENTER", frame, "CENTER", (frame.deselectedTextX or 0), offsetY)

			frame.LeftActive:Show()
			frame.MiddleActive:Show()
			frame.RightActive:Show()

			local tooltip = AddonFactory_Tooltip
			if tooltip:IsOwned(frame) then
				tooltip:Hide()
			end
		end,
	}
end)
