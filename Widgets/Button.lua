local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateButton(parent, text, width, height, onClick)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width or 80, height or self.Constants.BUTTON_HEIGHT)

    btn:SetBackdrop({
        bgFile = "Interface\\BUTTONS\\WHITE8X8",
        edgeFile = "Interface\\BUTTONS\\WHITE8X8",
        edgeSize = 1,
    })
    btn:SetBackdropColor(30/255, 30/255, 30/255, 0.8)
    btn:SetBackdropBorderColor(unpack(self.Colors.border))

    btn.label = self:CreateText(btn, self.Constants.FONT_SIZE_NORMAL, "ctrlText")
    btn.label:SetPoint("CENTER")
    btn.label:SetText(text)

    btn:SetScript("OnEnter", function(self)
        self.label:SetTextColor(unpack(KazGUI.Colors.ctrlHover))
        self:SetBackdropBorderColor(unpack(KazGUI.Colors.accentBronze))
    end)
    btn:SetScript("OnLeave", function(self)
        self.label:SetTextColor(unpack(KazGUI.Colors.ctrlText))
        self:SetBackdropBorderColor(unpack(KazGUI.Colors.border))
    end)

    if onClick then
        btn:SetScript("OnClick", onClick)
    end

    function btn:SetText(t) self.label:SetText(t) end
    function btn:SetEnabled(enabled)
        if enabled then
            self:Enable()
            self.label:SetTextColor(unpack(KazGUI.Colors.ctrlText))
        else
            self:Disable()
            self.label:SetTextColor(unpack(KazGUI.Colors.gray))
        end
    end

    return btn
end
