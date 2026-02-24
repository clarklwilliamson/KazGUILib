local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateFrame(name, width, height, options)
    options = options or {}

    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetSize(width, height)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetFrameStrata(options.strata or "DIALOG")
    f:SetClampedToScreen(true)

    self:ApplyBackdrop(f)
    self:AddShadow(f)

    -- Drag handlers with position saving
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        if f._savePosition then f._savePosition() end
    end)

    -- ESC to close
    if name then
        table.insert(UISpecialFrames, name)
    end

    -- Title bar
    if options.title then
        f.titleBar = KazGUI:CreateTitleBar(f, options.title)
    end

    -- Resizable
    if options.resizable then
        f:SetResizable(true)
        local minW = options.minSize and options.minSize[1] or 200
        local minH = options.minSize and options.minSize[2] or 100
        f:SetResizeBounds(minW, minH)

        f.grip = KazGUI:CreateResizeGrip(f, {
            minW = minW,
            minH = minH,
            clampToContent = options.clampToContent,
            onResize = options.onResize,
        })
    end

    f:Hide()
    return f
end

function KazGUI:CreateTitleBar(parent, titleText)
    local bar = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    bar:SetHeight(self.Constants.TITLE_HEIGHT)
    bar:SetPoint("TOPLEFT", parent, "TOPLEFT", 1, -1)
    bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -1, -1)
    bar:SetBackdrop({ bgFile = "Interface\\BUTTONS\\WHITE8X8" })
    bar:SetBackdropColor(unpack(self.Colors.headerBg))

    -- Title text
    local title = self:CreateText(bar, self.Constants.FONT_SIZE_TITLE, "accent")
    title:SetPoint("LEFT", bar, "LEFT", 10, 0)
    title:SetText(titleText)
    bar.title = title

    -- Close button
    local closeBtn = CreateFrame("Button", nil, bar)
    closeBtn:SetSize(self.Constants.TITLE_HEIGHT, self.Constants.TITLE_HEIGHT)
    closeBtn:SetPoint("RIGHT", bar, "RIGHT", 0, 0)

    local closeTxt = self:CreateText(closeBtn, self.Constants.FONT_SIZE_TITLE, "closeNormal")
    closeTxt:SetPoint("CENTER")
    closeTxt:SetText("x")

    closeBtn:SetScript("OnEnter", function()
        closeTxt:SetTextColor(unpack(KazGUI.Colors.closeHover))
    end)
    closeBtn:SetScript("OnLeave", function()
        closeTxt:SetTextColor(unpack(KazGUI.Colors.closeNormal))
    end)
    closeBtn:SetScript("OnClick", function()
        parent:Hide()
    end)

    bar.closeBtn = closeBtn
    return bar
end
