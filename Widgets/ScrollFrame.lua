local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateScrollFrame(parent, name)
    local sf = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
    sf.scrollBarHideable = true

    local content = CreateFrame("Frame", nil, sf)
    content:SetHeight(1)
    sf:SetScrollChild(content)
    sf.content = content

    -- Restyle scrollbar
    local scrollBar = sf.ScrollBar or (name and _G[name .. "ScrollBar"])
    if scrollBar then
        scrollBar:SetWidth(self.Constants.SCROLLBAR_WIDTH)

        -- Hide arrows
        local upBtn = scrollBar.ScrollUpButton or (name and _G[name .. "ScrollBarScrollUpButton"])
        local downBtn = scrollBar.ScrollDownButton or (name and _G[name .. "ScrollBarScrollDownButton"])
        if upBtn then upBtn:SetSize(1, 1); upBtn:SetAlpha(0); upBtn:EnableMouse(false) end
        if downBtn then downBtn:SetSize(1, 1); downBtn:SetAlpha(0); downBtn:EnableMouse(false) end

        -- Track
        local track = scrollBar:CreateTexture(nil, "BACKGROUND")
        track:SetAllPoints()
        track:SetColorTexture(unpack(self.Colors.scrollTrack))

        -- Thumb
        local thumb = scrollBar.ThumbTexture or scrollBar:GetThumbTexture()
        if thumb then
            thumb:SetColorTexture(unpack(self.Colors.scrollThumb))
            thumb:SetSize(self.Constants.SCROLLBAR_WIDTH, 40)

            scrollBar:HookScript("OnEnter", function()
                thumb:SetColorTexture(unpack(KazGUI.Colors.scrollThumbHover))
            end)
            scrollBar:HookScript("OnLeave", function()
                thumb:SetColorTexture(unpack(KazGUI.Colors.scrollThumb))
            end)
        end

        sf.scrollBar = scrollBar
    end

    -- Auto-hide helper
    function sf:UpdateScrollbar()
        if not self.scrollBar then return end
        local contentH = self.content:GetHeight()
        local visibleH = self:GetHeight()
        if contentH > visibleH then
            self.scrollBar:Show()
        else
            self.scrollBar:Hide()
            self:SetVerticalScroll(0)
        end
    end

    return sf
end
