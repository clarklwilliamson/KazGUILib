local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateEditBox(parent, width, height, options)
    options = options or {}

    local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    frame:SetSize(width or 100, height or 22)
    self:ApplyBackdrop(frame, "checkOff", "border")

    local editBox = CreateFrame("EditBox", nil, frame)
    editBox:SetPoint("TOPLEFT", 4, -2)
    editBox:SetPoint("BOTTOMRIGHT", -4, 2)
    editBox:SetFont(self.Constants.FONT, self.Constants.FONT_SIZE_NORMAL, "")
    editBox:SetTextColor(unpack(self.Colors.textNormal))
    editBox:SetAutoFocus(false)
    editBox:SetMaxLetters(options.maxLetters or 256)

    if options.numeric then
        editBox:SetNumeric(true)
    end

    if options.placeholder then
        local placeholder = self:CreateText(frame, self.Constants.FONT_SIZE_NORMAL, "textDim")
        placeholder:SetPoint("LEFT", editBox, "LEFT", 0, 0)
        placeholder:SetText(options.placeholder)

        editBox:SetScript("OnTextChanged", function(self)
            if self:GetText() == "" then
                placeholder:Show()
            else
                placeholder:Hide()
            end
            if options.onChange then options.onChange(self:GetText()) end
        end)
    elseif options.onChange then
        editBox:SetScript("OnTextChanged", function(self)
            options.onChange(self:GetText())
        end)
    end

    editBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)

    if options.onEnter then
        editBox:SetScript("OnEnterPressed", function(self)
            options.onEnter(self:GetText())
            self:ClearFocus()
        end)
    end

    frame.editBox = editBox

    function frame:GetText() return self.editBox:GetText() end
    function frame:SetText(t) self.editBox:SetText(t) end
    function frame:SetFocus() self.editBox:SetFocus() end
    function frame:ClearFocus() self.editBox:ClearFocus() end

    return frame
end
