ItemUpgradeTipDisplayMixin = {}

function ItemUpgradeTipDisplayMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self)
    ButtonFrameTemplate_HideButtonBar(self)
    self.Inset:Hide()

    self:RegisterForDrag("LeftButton")

    PanelTemplates_SetNumTabs(self, #self.Tabs)
    table.insert(UISpecialFrames, self:GetName())

    local lastTab = nil
    for index, tab in ipairs(self.Tabs) do
        tab:ClearAllPoints()
        if lastTab == nil then
            tab:SetPoint("BOTTOMLEFT", 20, -30)
        else
            tab:SetPoint("LEFT", lastTab, "RIGHT", 0, 0)
        end
        lastTab = tab
    end
end

function ItemUpgradeTipDisplayMixin:OnShow()
    local visibleDisplayModes = {}
    local visibleTab
    for _, tab in ipairs(self.Tabs) do
        if tab:IsShown() then
            table.insert(visibleDisplayModes, tab.displayMode)
            if visibleTab == nil then
                visibleTab = tab
            end
        end
    end

    self:SetDisplayMode("MythicPlus")
end

function ItemUpgradeTipDisplayMixin:OnHide()
end

function ItemUpgradeTipDisplayMixin:SetDisplayMode(displayMode)
    for index, tab in ipairs(self.Tabs) do
        if tab.displayMode == displayMode then
            PanelTemplates_SetTab(self, index)
            if self.SetTitle then -- Dragonflight
                self:SetTitle(tab.title)
            else
                self.TitleText:SetText(tab.title)
            end
            break
        end
    end

    for _, view in ipairs(self.Views) do
        view:SetShown(view.displayMode == displayMode)
    end
end
