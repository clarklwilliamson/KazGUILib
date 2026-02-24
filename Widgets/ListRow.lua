local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateListRow(parent, index, height)
    local C = self.Colors
    height = height or self.Constants.ROW_HEIGHT_LARGE

    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(height)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -(index - 1) * height)
    row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -(index - 1) * height)

    row.bg = row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints()
    row.bg:SetColorTexture(1, 1, 1, 0)

    row.leftAccent = row:CreateTexture(nil, "ARTWORK", nil, 2)
    row.leftAccent:SetSize(2, height)
    row.leftAccent:SetPoint("LEFT")
    row.leftAccent:SetColorTexture(unpack(C.accentBronze))
    row.leftAccent:Hide()

    row.divider = row:CreateTexture(nil, "ARTWORK", nil, 1)
    row.divider:SetHeight(1)
    row.divider:SetPoint("BOTTOMLEFT", 4, 0)
    row.divider:SetPoint("BOTTOMRIGHT", -4, 0)
    row.divider:SetColorTexture(unpack(C.rowDivider))

    row._defaultBgAlpha = (index % 2 == 0) and 0.03 or 0
    row.bg:SetColorTexture(1, 1, 1, row._defaultBgAlpha)

    row:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(unpack(C.rowHover))
        self.leftAccent:Show()
    end)
    row:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(1, 1, 1, self._defaultBgAlpha)
        self.leftAccent:Hide()
    end)

    return row
end
