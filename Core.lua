local MAJOR, MINOR = "KazGUILib-1.0", 1
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

    -- Status
    green           = {100/255, 200/255, 100/255, 1},
    red             = {200/255, 100/255, 100/255, 1},
    gold            = {255/255, 200/255, 50/255, 1},
    gray            = {128/255, 128/255, 128/255, 1},

    -- Buttons
    btnNormal       = {35/255, 32/255, 28/255, 1},
    btnHover        = {55/255, 50/255, 42/255, 1},
    btnPressed      = {25/255, 22/255, 18/255, 1},

    -- Controls
    ctrlText        = {150/255, 140/255, 120/255, 1},
    ctrlHover       = {220/255, 200/255, 160/255, 1},

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
    rowSelected     = {200/255, 170/255, 100/255, 0.15},
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
