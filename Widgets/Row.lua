local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateRow(parent, height, columns)
    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(height or self.Constants.ROW_HEIGHT)

    -- Background
    row.bg = row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints()
    row.bg:SetColorTexture(0, 0, 0, 0)

    -- Hover
    row.hover = row:CreateTexture(nil, "HIGHLIGHT")
    row.hover:SetAllPoints()
    row.hover:SetColorTexture(unpack(self.Colors.rowHover))

    -- Columns
    row.columns = {}
    if columns then
        local x = 4
        for i, colDef in ipairs(columns) do
            local text = self:CreateText(row, self.Constants.FONT_SIZE_NORMAL)
            text:SetPoint("LEFT", row, "LEFT", x, 0)
            text:SetWidth(colDef.width - 4)
            text:SetJustifyH(colDef.align or "LEFT")
            text:SetWordWrap(false)
            row.columns[i] = text
            x = x + colDef.width
        end
    end

    -- Stripe helper
    function row:SetStripe(isOdd)
        if isOdd then
            self.bg:SetColorTexture(unpack(KazGUI.Colors.rowOdd))
        else
            self.bg:SetColorTexture(unpack(KazGUI.Colors.rowEven))
        end
    end

    return row
end
