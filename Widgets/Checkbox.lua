local KazGUI = LibStub("KazGUILib-1.0")

function KazGUI:CreateCheckbox(parent, labelText, default, onChange)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(14 + 5 + (labelText and 100 or 0), 20)
    frame:EnableMouse(true)

    -- Box
    local box = frame:CreateTexture(nil, "ARTWORK")
    box:SetSize(14, 14)
    box:SetPoint("LEFT", frame, "LEFT", 0, 0)

    -- Border edges
    local function MakeEdge(p1, p2, w, h)
        local e = frame:CreateTexture(nil, "OVERLAY")
        e:SetSize(w, h)
        e:SetPoint(p1, box, p2)
        e:SetColorTexture(unpack(KazGUI.Colors.border))
        return e
    end
    MakeEdge("TOPLEFT", "TOPLEFT", 14, 1)
    MakeEdge("BOTTOMLEFT", "BOTTOMLEFT", 14, 1)
    MakeEdge("TOPLEFT", "TOPLEFT", 1, 14)
    MakeEdge("TOPRIGHT", "TOPRIGHT", 1, 14)

    -- Checkmark
    local check = frame:CreateTexture(nil, "OVERLAY")
    check:SetSize(10, 10)
    check:SetPoint("CENTER", box, "CENTER")
    check:SetColorTexture(unpack(KazGUI.Colors.checkOn))

    -- Label
    if labelText then
        local label = KazGUI:CreateText(frame, KazGUI.Constants.FONT_SIZE_NORMAL, "ctrlText")
        label:SetPoint("LEFT", box, "RIGHT", 5, 0)
        label:SetText(labelText)
        frame.label = label
    end

    -- State
    frame.checked = default or false

    local function UpdateVisual()
        if frame.checked then
            check:Show()
            box:SetColorTexture(35/255, 32/255, 28/255, 1)
        else
            check:Hide()
            box:SetColorTexture(unpack(KazGUI.Colors.checkOff))
        end
    end
    UpdateVisual()

    frame:SetScript("OnMouseUp", function()
        frame.checked = not frame.checked
        UpdateVisual()
        if onChange then onChange(frame.checked) end
    end)

    function frame:SetChecked(val)
        self.checked = val
        UpdateVisual()
    end
    function frame:GetChecked()
        return self.checked
    end

    return frame
end
