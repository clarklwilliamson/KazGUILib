local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateButton(parent, text, width, height, onClick)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width or 80, height or self.Constants.BUTTON_HEIGHT)

    self:ApplyBackdrop(btn, "btnNormal", "border")

    btn.label = self:CreateText(btn, self.Constants.FONT_SIZE_NORMAL, "ctrlText")
    btn.label:SetPoint("CENTER")
    btn.label:SetText(text)

    btn:SetScript("OnEnter", function(self)
        KazGUI:ApplyBackdrop(self, "btnHover", "border")
        self.label:SetTextColor(unpack(KazGUI.Colors.ctrlHover))
    end)
    btn:SetScript("OnLeave", function(self)
        KazGUI:ApplyBackdrop(self, "btnNormal", "border")
        self.label:SetTextColor(unpack(KazGUI.Colors.ctrlText))
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
