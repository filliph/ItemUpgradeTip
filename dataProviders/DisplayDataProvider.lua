---@diagnostic disable: duplicate-set-field

ItemUpgradeTipDisplayDataProviderMixin = CreateFromMixins(ItemUpgradeTipDataProviderMixin)

local itemLinkToLevel = {}

function ItemUpgradeTipDisplayDataProviderMixin:OnLoad()
    ItemUpgradeTipDataProviderMixin.OnLoad(self)
    self.selectedIndexes = {}
    self.processCountPerUpdate = 200 --Reduce flickering when updating the display
    self.selectedIndexes = {}

    local function ApplyItemLevel(entry, itemLevel)
        entry.itemName = entry.itemName .. " (" .. itemLevel .. ")"
        entry.itemNamePretty = self:ApplyQualityColor(entry.itemName, entry.itemLink)
    end

    -- Populate item level in any item names
    self:SetOnEntryProcessedCallback(function(entry)
        if entry.itemLink == nil then
            self:NotifyCacheUsed()
            return
        end

        -- Use cached item level to reduce flickering and scroll jumping up and down
        if itemLinkToLevel[entry.itemLink] then
            ApplyItemLevel(entry, itemLinkToLevel[entry.itemLink])
            self:NotifyCacheUsed()
            return
        end

        local item = Item:CreateFromItemLink(entry.itemLink)
        item:ContinueOnItemLoad(function()
            local itemLevel = GetDetailedItemLevelInfo(entry.itemLink)

            if itemLevel ~= nil then
                itemLinkToLevel[entry.itemLink] = itemLevel
                ApplyItemLevel(entry, itemLevel)
                self:SetDirty()
            end
        end)
    end)
end

function ItemUpgradeTipDisplayDataProviderMixin:OnShow()
    self:Refresh()
end

-- Load/refresh the current view
function ItemUpgradeTipDisplayDataProviderMixin:Refresh()
    error("This should be overridden.")
end

function ItemUpgradeTipDisplayDataProviderMixin:UniqueKey(entry)
    return tostring(entry)
end

function ItemUpgradeTipDisplayDataProviderMixin:IsSelected(index)
    return self.selectedIndexes[index] ~= nil
end

function ItemUpgradeTipDisplayDataProviderMixin:GetRowTemplate()
    return "ItemUpgradeTipTableResultsRowTemplate"
end

function ItemUpgradeTipDisplayDataProviderMixin:ApplyQualityColor(name, link)
    return "|c" .. string.match(link, "|c(........)|") .. name .. "|r"
end
