local MAJOR, MINOR = "KazGUILib-1.0", 2
local KazGUI = LibStub:NewLibrary(MAJOR, MINOR)
if not KazGUI then return end

-- Expose globally for non-LibStub access
_G.KazGUI = KazGUI

--------------------------------------------------------------------------------
-- Color Palette (THE source of truth)
--------------------------------------------------------------------------------
KazGUI.Colors = {
    -- Backgrounds
    bg              = {18/255, 18/255, 18/255, 0.94},
    bgSolid         = {18/255, 18/255, 18/255, 1},
    headerBg        = {30/255, 28/255, 25/255, 1},
    panelBg         = {12/255, 12/255, 12/255, 0.5},
    footerBg        = {10/255, 10/255, 10/255, 0.6},

    -- Borders
    border          = {70/255, 65/255, 55/255, 1},
    borderLight     = {90/255, 80/255, 65/255, 1},

    -- Accent
    accent          = {255/255, 235/255, 180/255, 1},  -- warm gold title
    accentBronze    = {200/255, 170/255, 100/255, 1},  -- bronze highlights

    -- Text
    textNormal      = {220/255, 215/255, 200/255, 1},
    textDim         = {150/255, 140/255, 120/255, 1},
    textHeader      = {130/255, 125/255, 115/255, 1},
    textMuted       = {180/255, 180/255, 180/255, 1},

    -- Status
    green           = {0.3, 0.9, 0.3, 1},
    red             = {0.9, 0.3, 0.3, 1},
    gold            = {1, 0.82, 0, 1},
    gray            = {128/255, 128/255, 128/255, 1},

    -- Buttons
    btnNormal       = {35/255, 32/255, 28/255, 1},
    btnHover        = {55/255, 50/255, 42/255, 1},
    btnPressed      = {25/255, 22/255, 18/255, 1},

    -- Controls
    ctrlText        = {150/255, 140/255, 120/255, 1},
    ctrlHover       = {220/255, 200/255, 160/255, 1},
    tabInactive     = {160/255, 150/255, 130/255, 1},
    searchBg        = {10/255, 10/255, 10/255, 0.6},
    searchFocus     = {120/255, 105/255, 80/255, 1},

    -- Checkbox
    checkOff        = {25/255, 23/255, 20/255, 1},
    checkOn         = {200/255, 170/255, 100/255, 1},

    -- Close button
    closeNormal     = {140/255, 130/255, 115/255, 1},
    closeHover      = {220/255, 100/255, 100/255, 1},

    -- Resize grip
    gripNormal      = {70/255, 65/255, 55/255, 1},
    gripHover       = {130/255, 120/255, 100/255, 1},

    -- Rows
    rowOdd          = {0, 0, 0, 0},
    rowEven         = {255/255, 255/255, 255/255, 0.03},
    rowHover        = {255/255, 220/255, 150/255, 0.08},
    rowSelected     = {200/255, 170/255, 100/255, 0.12},
    rowDivider      = {70/255, 65/255, 55/255, 0.5},
    zoneBg          = {255/255, 255/255, 255/255, 0.03},

    -- Scrollbar
    scrollTrack     = {30/255, 30/255, 30/255, 0.5},
    scrollThumb     = {80/255, 75/255, 65/255, 1},
    scrollThumbHover= {120/255, 110/255, 90/255, 1},
}

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
KazGUI.Constants = {
    FONT            = "Fonts\\FRIZQT__.TTF",
    FONT_SIZE_TITLE = 14,
    FONT_SIZE_NORMAL= 11,
    FONT_SIZE_SMALL = 10,

    TITLE_HEIGHT    = 28,
    ROW_HEIGHT      = 22,
    BUTTON_HEIGHT   = 20,
    SCROLLBAR_WIDTH = 6,
    ROW_HEIGHT_LARGE= 26,
    ICON_SIZE       = 20,
    TAB_BAR_HEIGHT  = 28,

    SHADOW_OFFSET   = 2,
    SHADOW_EXTEND   = 4,
    SHADOW_ALPHA    = 0.4,
}

--------------------------------------------------------------------------------
-- Utility: Apply standard backdrop
--------------------------------------------------------------------------------
function KazGUI:ApplyBackdrop(frame, colorKey, borderKey)
    colorKey = colorKey or "bg"
    borderKey = borderKey or "border"

    frame:SetBackdrop({
        bgFile = "Interface\\BUTTONS\\WHITE8X8",
        edgeFile = "Interface\\BUTTONS\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(unpack(self.Colors[colorKey]))
    frame:SetBackdropBorderColor(unpack(self.Colors[borderKey]))
end

--------------------------------------------------------------------------------
-- Utility: Create drop shadow
--------------------------------------------------------------------------------
function KazGUI:AddShadow(frame)
    local shadow = CreateFrame("Frame", nil, frame)
    shadow:SetFrameLevel(math.max(1, frame:GetFrameLevel() - 1))
    shadow:SetPoint("TOPLEFT", -self.Constants.SHADOW_OFFSET, self.Constants.SHADOW_OFFSET)
    shadow:SetPoint("BOTTOMRIGHT", self.Constants.SHADOW_EXTEND, -self.Constants.SHADOW_EXTEND)

    local tex = shadow:CreateTexture(nil, "BACKGROUND")
    tex:SetAllPoints()
    tex:SetColorTexture(0, 0, 0, self.Constants.SHADOW_ALPHA)

    return shadow
end

--------------------------------------------------------------------------------
-- Utility: Create FontString with defaults
--------------------------------------------------------------------------------
function KazGUI:CreateText(parent, size, colorKey)
    size = size or self.Constants.FONT_SIZE_NORMAL
    colorKey = colorKey or "textNormal"

    local text = parent:CreateFontString(nil, "OVERLAY")
    text:SetFont(self.Constants.FONT, size, "")
    text:SetTextColor(unpack(self.Colors[colorKey]))
    return text
end

--------------------------------------------------------------------------------
-- Utility: Format copper value as gold string
--------------------------------------------------------------------------------
function KazGUI:FormatGold(copper)
    if not copper or copper == 0 then return "—" end
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    if gold > 0 then
        return string.format("%s|cffffd700g|r %02d|cffc7c7cfs|r", BreakUpLargeNumbers(gold), silver)
    elseif silver > 0 then
        return string.format("%d|cffc7c7cfs|r %02d|cffeda55fc|r", silver, copper % 100)
    else
        return string.format("%d|cffeda55fc|r", copper % 100)
    end
end

--------------------------------------------------------------------------------
-- Utility: Crafting quality helpers
--------------------------------------------------------------------------------
function KazGUI:GetCraftingQuality(itemID)
    if not itemID then return nil end
    if C_TradeSkillUI and C_TradeSkillUI.GetItemReagentQualityByItemInfo then
        return C_TradeSkillUI.GetItemReagentQualityByItemInfo(itemID)
    end
    return nil
end

function KazGUI:GetQualityAtlas(tier)
    if not tier or tier < 1 or tier > 5 then return nil end
    return "Professions-Icon-Quality-Tier" .. tier .. "-Small"
end

--------------------------------------------------------------------------------
-- Utility: Create close button (top-right "x")
--------------------------------------------------------------------------------
function KazGUI:CreateCloseButton(parent)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(20, 20)
    btn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -4, -4)
    btn.label = btn:CreateFontString(nil, "OVERLAY")
    btn.label:SetFont(self.Constants.FONT, 14, "")
    btn.label:SetPoint("CENTER")
    btn.label:SetText("x")
    btn.label:SetTextColor(unpack(self.Colors.closeNormal))

    btn:SetScript("OnEnter", function(self)
        self.label:SetTextColor(unpack(KazGUI.Colors.closeHover))
    end)
    btn:SetScript("OnLeave", function(self)
        self.label:SetTextColor(unpack(KazGUI.Colors.closeNormal))
    end)
    btn:SetScript("OnClick", function()
        parent:Hide()
    end)

    return btn
end

--------------------------------------------------------------------------------
-- Utility: Smooth alpha fade
--------------------------------------------------------------------------------
function KazGUI:FadeFrame(frame, targetAlpha, duration)
    if not frame then return end
    duration = duration or 0.2
    if targetAlpha > 0 then frame:Show() end
    local startAlpha = frame:GetAlpha()
    if math.abs(startAlpha - targetAlpha) < 0.01 then
        frame:SetAlpha(targetAlpha)
        if targetAlpha == 0 then frame:Hide() end
        return
    end
    local startTime = GetTime()
    if frame._fadeTicker then frame._fadeTicker:Cancel() end
    frame._fadeTicker = C_Timer.NewTicker(0.016, function(ticker)
        local elapsed = GetTime() - startTime
        local pct = math.min(1, elapsed / duration)
        frame:SetAlpha(startAlpha + (targetAlpha - startAlpha) * pct)
        if pct >= 1 then
            ticker:Cancel()
            frame._fadeTicker = nil
            if targetAlpha == 0 then frame:Hide() end
        end
    end)
end

--------------------------------------------------------------------------------
-- Utility: Classic scroll frame (UIPanelScrollFrameTemplate wrapper)
--------------------------------------------------------------------------------
function KazGUI:CreateClassicScrollFrame(parent, topOffset, bottomOffset)
    topOffset = topOffset or 0
    bottomOffset = bottomOffset or 0

    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -topOffset)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, bottomOffset)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetWidth(scrollFrame:GetWidth())
    content:SetHeight(1)
    scrollFrame:SetScrollChild(content)

    local scrollBar = scrollFrame.ScrollBar
    if scrollBar then
        scrollBar:ClearAllPoints()
        scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 2, -16)
        scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 2, 16)
    end

    scrollFrame.content = content
    return scrollFrame
end

--------------------------------------------------------------------------------
-- /kaz Dispatcher — Unified Slash Command Router
--------------------------------------------------------------------------------
KAZ_COMMANDS = {}

SLASH_KAZ1 = "/kaz"
SlashCmdList["KAZ"] = function(msg)
    msg = (msg or ""):trim()
    local cmd, rest = msg:match("^(%S+)%s*(.*)$")

    if not cmd then
        -- No args: list all registered commands
        local sorted = {}
        for name, entry in pairs(KAZ_COMMANDS) do
            table.insert(sorted, {name = name, alias = entry.alias, desc = entry.desc})
        end
        table.sort(sorted, function(a, b) return a.name < b.name end)

        print("|cffc8aa64Kaz:|r Commands:")
        for _, entry in ipairs(sorted) do
            local alias = entry.alias and ("(" .. entry.alias .. ")") or ""
            print(string.format("  /kaz %-12s %-12s %s", entry.name, alias, entry.desc or ""))
        end
        return
    end

    cmd = cmd:lower()
    local entry = KAZ_COMMANDS[cmd]
    if entry and entry.handler then
        entry.handler(rest)
    else
        print("|cffc8aa64Kaz:|r Unknown command: " .. cmd)
    end
end
