local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateTabBar(parent, tabs, onSelect)
    local C = self.Colors

    local bar = CreateFrame("Frame", nil, parent)
    bar:SetHeight(self.Constants.TAB_BAR_HEIGHT)
    bar:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)

    local accentBar = bar:CreateTexture(nil, "ARTWORK")
    accentBar:SetHeight(2)
    accentBar:SetColorTexture(unpack(C.accentBronze))
    bar.accentBar = accentBar

    bar.buttons = {}
    bar.activeKey = nil

    for i, info in ipairs(tabs) do
        local btn = CreateFrame("Button", nil, bar)
        btn:SetHeight(self.Constants.TAB_BAR_HEIGHT)
        btn.label = btn:CreateFontString(nil, "OVERLAY")
        btn.label:SetFont(self.Constants.FONT, 12, "")
        btn.label:SetPoint("CENTER")
        btn.label:SetText(info.label)
        btn.label:SetTextColor(unpack(C.tabInactive))
        btn:SetWidth(btn.label:GetStringWidth() + 16)
        btn.key = info.key

        if i == 1 then
            btn:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 8, 0)
        else
            btn:SetPoint("BOTTOMLEFT", bar.buttons[i - 1], "BOTTOMRIGHT", 16, 0)
        end

        btn:SetScript("OnClick", function()
            bar:Select(info.key)
            if onSelect then onSelect(info.key) end
        end)
        btn:SetScript("OnEnter", function(self)
            if bar.activeKey ~= self.key then
                self.label:SetTextColor(unpack(C.ctrlHover))
            end
        end)
        btn:SetScript("OnLeave", function(self)
            if bar.activeKey ~= self.key then
                self.label:SetTextColor(unpack(C.tabInactive))
            end
        end)

        bar.buttons[i] = btn
    end

    function bar:Select(key)
        bar.activeKey = key
        for _, btn in ipairs(bar.buttons) do
            if btn.key == key then
                btn.label:SetTextColor(unpack(C.accent))
                accentBar:ClearAllPoints()
                accentBar:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", 0, 0)
                accentBar:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)
                accentBar:Show()
            else
                btn.label:SetTextColor(unpack(C.tabInactive))
            end
        end
    end

    if #tabs > 0 then
        bar:Select(tabs[1].key)
    end

    return bar
end
