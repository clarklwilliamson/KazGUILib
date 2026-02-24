local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateResizeGrip(parent, options)
    options = options or {}
    local minW = options.minW or 200
    local minH = options.minH or 100

    local grip = CreateFrame("Frame", nil, parent)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -1, 1)
    grip:EnableMouse(true)

    -- Draw grip lines
    local lines = {}
    local positions = {
        {10, 1, "BOTTOMRIGHT", -3, 3},
        {1, 10, "BOTTOMRIGHT", -3, 3},
        {6, 1, "BOTTOMRIGHT", -3, 7},
        {1, 6, "BOTTOMRIGHT", -7, 3},
    }
    for _, pos in ipairs(positions) do
        local line = grip:CreateTexture(nil, "OVERLAY")
        line:SetSize(pos[1], pos[2])
        line:SetPoint(pos[3], pos[4], pos[5])
        line:SetColorTexture(unpack(KazGUI.Colors.gripNormal))
        table.insert(lines, line)
    end

    grip:SetScript("OnEnter", function()
        for _, line in ipairs(lines) do
            line:SetColorTexture(unpack(KazGUI.Colors.gripHover))
        end
    end)
    grip:SetScript("OnLeave", function()
        for _, line in ipairs(lines) do
            line:SetColorTexture(unpack(KazGUI.Colors.gripNormal))
        end
    end)

    grip:SetScript("OnMouseDown", function()
        local screenW, screenH = GetScreenWidth(), GetScreenHeight()
        local left = parent:GetLeft() or 0
        local top = parent:GetTop() or screenH
        local maxW = math.max(minW, screenW - left - 20)
        local maxH = math.max(minH, top - 20)

        -- Content clamping
        if options.clampToContent then
            if options.contentWidth then
                maxW = math.min(maxW, options.contentWidth())
            end
            if options.contentHeight then
                maxH = math.min(maxH, options.contentHeight())
            end
        end

        parent:SetResizeBounds(minW, minH, maxW, maxH)
        parent:StartSizing("BOTTOMRIGHT")
    end)

    grip:SetScript("OnMouseUp", function()
        parent:StopMovingOrSizing()
        if options.onResize then options.onResize(parent) end
    end)

    -- Methods to update content constraints
    function grip:SetContentWidth(fn) options.contentWidth = fn end
    function grip:SetContentHeight(fn) options.contentHeight = fn end

    return grip
end
