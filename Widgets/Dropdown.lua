local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateDropdown(parent, width, options, default, onChange)
    local btn = self:CreateButton(parent, default or "Select", width or 120, self.Constants.BUTTON_HEIGHT)

    btn.options = options or {}
    btn.selected = default
    btn.onChange = onChange

    -- Dropdown menu frame (created on first open)
    btn.menu = nil

    local function CreateMenu()
        local menu = CreateFrame("Frame", nil, btn, "BackdropTemplate")
        menu:SetPoint("TOPLEFT", btn, "BOTTOMLEFT", 0, -2)
        menu:SetWidth(btn:GetWidth())
        menu:SetFrameStrata("FULLSCREEN_DIALOG")
        KazGUI:ApplyBackdrop(menu)

        menu.items = {}
        local y = -4
        for i, opt in ipairs(btn.options) do
            local item = CreateFrame("Button", nil, menu)
            item:SetHeight(20)
            item:SetPoint("TOPLEFT", menu, "TOPLEFT", 4, y)
            item:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -4, y)

            local label = KazGUI:CreateText(item, KazGUI.Constants.FONT_SIZE_NORMAL, "ctrlText")
            label:SetPoint("LEFT", 4, 0)
            label:SetText(opt)
            item.label = label

            item:SetScript("OnEnter", function(self)
                self.label:SetTextColor(unpack(KazGUI.Colors.ctrlHover))
            end)
            item:SetScript("OnLeave", function(self)
                self.label:SetTextColor(unpack(KazGUI.Colors.ctrlText))
            end)
            item:SetScript("OnClick", function()
                btn.selected = opt
                btn:SetText(opt)
                menu:Hide()
                if btn.onChange then btn.onChange(opt) end
            end)

            table.insert(menu.items, item)
            y = y - 20
        end

        menu:SetHeight(math.abs(y) + 4)
        menu:Hide()
        return menu
    end

    btn:SetScript("OnClick", function(self)
        if not self.menu then
            self.menu = CreateMenu()
        end
        if self.menu:IsShown() then
            self.menu:Hide()
        else
            self.menu:Show()
        end
    end)

    function btn:SetOptions(opts)
        self.options = opts
        if self.menu then
            self.menu:Hide()
            self.menu = nil  -- recreate on next open
        end
    end

    function btn:GetSelected()
        return self.selected
    end

    function btn:SetSelected(val)
        self.selected = val
        self:SetText(val)
    end

    return btn
end
