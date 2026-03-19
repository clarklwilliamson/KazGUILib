local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateFrame(name, width, height, options)
    options = options or {}

    local f = CreateFrame("Frame", name, options.parent or UIParent, "BackdropTemplate")
    f:SetSize(width, height)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetFrameStrata(options.strata or "DIALOG")
    f:SetClampedToScreen(false)
    f:SetToplevel(true)

    self:ApplyBackdrop(f, options.bgColor, options.borderColor)
    if options.shadow ~= false then
        self:AddShadow(f)
    end

    -- Drag handlers with position saving
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        if self.SavePosition then self:SavePosition() end
        if f._savePosition then f._savePosition() end
    end)

    -- ESC to close (opt out with escClose = false)
    if name and options.escClose ~= false then
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

    -- Window shade (double-click title bar to collapse/restore)
    if options.shadeable ~= false and options.title then
        f._shaded = false
        f._unshadedHeight = height
        f._shadedChildren = {}  -- track hidden children by reference

        local function ShadeLog(...)
            if KazUtil and KazUtil.DebugLog then
                KazUtil.DebugLog("KazGUILib", ...)
            end
        end

        function f:Shade()
            if f._shaded then
                ShadeLog("Shade: already shaded, skipping")
                return
            end
            f._unshadedHeight = f:GetHeight()
            f._shaded = true
            ShadeLog("Shade: saving height:", f._unshadedHeight)

            -- Pin the title bar position: re-anchor from TOPLEFT so collapsing
            -- shrinks from the bottom (title bar stays put)
            local top = f:GetTop()
            local left = f:GetLeft()
            if top and left then
                f._shadeAnchor = {f:GetPoint()}
                f:ClearAllPoints()
                f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
                ShadeLog("Shade: pinned TOPLEFT at", left, top)
            end

            -- Hide all children except title bar + shadow
            wipe(f._shadedChildren)
            local children = {f:GetChildren()}
            ShadeLog("Shade: frame has", #children, "children")
            for _, child in ipairs(children) do
                if child ~= f.titleBar and child ~= f._shadow and child:IsShown() then
                    f._shadedChildren[child] = true
                    child:Hide()
                    ShadeLog("Shade: hiding child:", child:GetName() or child:GetObjectType())
                end
            end

            local titleH = KazGUI.Constants.TITLE_HEIGHT + 2
            f:SetHeight(titleH)
            if f:IsResizable() then f:SetResizable(false) end
            if f.grip then f.grip:Hide() end
            if f.titleBar and f.titleBar._shadeIndicator then
                f.titleBar._shadeIndicator:SetText("+")
            end
            ShadeLog("Shade: done, height now:", f:GetHeight())
        end

        function f:Unshade()
            if not f._shaded then
                ShadeLog("Unshade: not shaded, skipping")
                return
            end
            ShadeLog("Unshade: restoring height:", f._unshadedHeight)
            f._shaded = false
            f:SetHeight(f._unshadedHeight)
            if options.resizable then f:SetResizable(true) end
            if f.grip then f.grip:Show() end

            -- Restore children
            local restored = 0
            for child in pairs(f._shadedChildren) do
                child:Show()
                restored = restored + 1
            end
            wipe(f._shadedChildren)
            ShadeLog("Unshade: restored", restored, "children, height now:", f:GetHeight())

            if f.titleBar and f.titleBar._shadeIndicator then
                f.titleBar._shadeIndicator:SetText("-")
            end
        end

        function f:ToggleShade()
            ShadeLog("ToggleShade: current state:", f._shaded and "shaded" or "unshaded")
            if f._shaded then f:Unshade() else f:Shade() end
        end

        function f:IsShaded()
            return f._shaded
        end

        -- Shade button on title bar (left of close)
        local shadeBtn = CreateFrame("Button", nil, f.titleBar)
        shadeBtn:SetSize(KazGUI.Constants.TITLE_HEIGHT, KazGUI.Constants.TITLE_HEIGHT)
        shadeBtn:SetPoint("RIGHT", f.titleBar.closeBtn, "LEFT", 0, 0)

        local shadeTxt = KazGUI:CreateText(shadeBtn, KazGUI.Constants.FONT_SIZE_TITLE, "ctrlText")
        shadeTxt:SetPoint("CENTER")
        shadeTxt:SetText("-")
        f.titleBar._shadeIndicator = shadeTxt

        shadeBtn:SetScript("OnEnter", function()
            shadeTxt:SetTextColor(unpack(KazGUI.Colors.ctrlHover))
        end)
        shadeBtn:SetScript("OnLeave", function()
            shadeTxt:SetTextColor(unpack(KazGUI.Colors.ctrlText))
        end)
        shadeBtn:SetScript("OnClick", function()
            ShadeLog("Shade button clicked")
            f:ToggleShade()
        end)
        f.titleBar._shadeBtn = shadeBtn

        -- Double-click title bar to toggle shade
        -- Title bar must propagate drag to parent frame
        f.titleBar:RegisterForDrag("LeftButton")
        f.titleBar:SetScript("OnDragStart", function() f:StartMoving() end)
        f.titleBar:SetScript("OnDragStop", function()
            f:StopMovingOrSizing()
            if f.SavePosition then f:SavePosition() end
            if f._savePosition then f._savePosition() end
        end)
        -- Track clicks for double-click (only fires on non-drag mouse-up)
        f.titleBar._lastClickTime = 0
        f.titleBar._dragging = false
        f.titleBar:HookScript("OnDragStart", function() f.titleBar._dragging = true end)
        f.titleBar:HookScript("OnDragStop", function() f.titleBar._dragging = false end)
        f.titleBar:SetScript("OnMouseUp", function(_, button)
            if button ~= "LeftButton" or f.titleBar._dragging then return end
            local now = GetTime()
            if (now - f.titleBar._lastClickTime) < 0.3 then
                f.titleBar._lastClickTime = 0
                ShadeLog("Title bar double-clicked")
                f:ToggleShade()
            else
                f.titleBar._lastClickTime = now
            end
        end)

        -- Restore shade state on show
        f:HookScript("OnShow", function()
            if f._shaded then
                ShadeLog("OnShow while shaded — re-applying shade height")
                f:SetHeight(KazGUI.Constants.TITLE_HEIGHT + 2)
            end
        end)
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
