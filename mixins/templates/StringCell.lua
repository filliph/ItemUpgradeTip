ItemUpgradeTipStringCellTemplateMixin = CreateFromMixins(ItemUpgradeTipCellMixin, TableBuilderCellMixin)

function ItemUpgradeTipStringCellTemplateMixin:Init(columnName)
    self.columnName = columnName

    self.text:SetJustifyH("LEFT")
end

function ItemUpgradeTipStringCellTemplateMixin:Populate(rowData, index)
    ItemUpgradeTipCellMixin.Populate(self, rowData, index)

    self.text:SetText(rowData[self.columnName])
end

function ItemUpgradeTipStringCellTemplateMixin:OnHide()
    self.text:Hide()
end

function ItemUpgradeTipStringCellTemplateMixin:OnShow()
    self.text:Show()
end
