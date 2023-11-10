ItemUpgradeTipMythicPlusRowMixin = CreateFromMixins(ItemUpgradeTipResultsRowTemplateMixin)

ItemUpgradeTipMythicPlusRowMixin.Populate = ItemUpgradeTipTableResultsRowMixin.Populate
ItemUpgradeTipMythicPlusRowMixin.OnClick = ItemUpgradeTipTableResultsRowMixin.OnClick

function ItemUpgradeTipMythicPlusRowMixin:ShowTooltip()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    self.UpdateTooltip = self.OnEnter

    if self.rowData.itemLink then
        GameTooltip:SetHyperlink(self.rowData.itemLink)
    elseif self.rowData.currencyId then
        GameTooltip:SetCurrencyByID(self.rowData.currencyId)
    else
        GameTooltip:SetText(self.rowData.keyLevel)
    end

    GameTooltip:Show()
end

-- Used to prevent tooltip triggering too late and interfering with another
-- tooltip
function ItemUpgradeTipMythicPlusRowMixin:CancelContinuable()
    if self.continuableContainer then
        self.continuableContainer:Cancel()
        self.continuableContainer = nil
    end
end

function ItemUpgradeTipMythicPlusRowMixin:OnHide()
    self:CancelContinuable()
end

function ItemUpgradeTipMythicPlusRowMixin:OnEnter()
    ItemUpgradeTipResultsRowTemplateMixin.OnEnter(self)

    self:CancelContinuable()

    self:ShowTooltip()
end

function ItemUpgradeTipMythicPlusRowMixin:OnLeave()
    ItemUpgradeTipResultsRowTemplateMixin.OnLeave(self)
    self.UpdateTooltip = nil
    self:CancelContinuable()
    GameTooltip:Hide()
end
