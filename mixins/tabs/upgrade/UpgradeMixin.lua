---@diagnostic disable: duplicate-set-field

local UPGRADE_DATA_PROVIDER_LAYOUT = {
    {
        headerTemplate = "ItemUpgradeTipStringColumnHeaderTemplate",
        headerText = _G["ITEMUPGRADETIP_L_ITEM_LEVEL"],
        headerParameters = { "ilvl" },
        cellTemplate = "ItemUpgradeTipStringCellTemplate",
        cellParameters = { "ilvl" },
        width = 100,
    },
    {
        headerTemplate = "ItemUpgradeTipStringColumnHeaderTemplate",
        headerText = _G["ITEMUPGRADETIP_L_UPGRADE_TRACK_VETERAN"],
        headerParameters = { "veteranTier" },
        cellTemplate = "ItemUpgradeTipStringCellTemplate",
        cellParameters = { "veteranTier" },
    },
    {
        headerTemplate = "ItemUpgradeTipStringColumnHeaderTemplate",
        headerText = _G["ITEMUPGRADETIP_L_UPGRADE_TRACK_CHAMPION"],
        headerParameters = { "championTier" },
        cellTemplate = "ItemUpgradeTipStringCellTemplate",
        cellParameters = { "championTier" },
    },
    {
        headerTemplate = "ItemUpgradeTipStringColumnHeaderTemplate",
        headerText = _G["ITEMUPGRADETIP_L_UPGRADE_TRACK_HERO"],
        headerParameters = { "heroTier" },
        cellTemplate = "ItemUpgradeTipStringCellTemplate",
        cellParameters = { "heroTier" },
    },
    {
        headerTemplate = "ItemUpgradeTipStringColumnHeaderTemplate",
        headerText = _G["ITEMUPGRADETIP_L_UPGRADE_TRACK_MYTH"],
        headerParameters = { "mythTier" },
        cellTemplate = "ItemUpgradeTipStringCellTemplate",
        cellParameters = { "mythTier" },
    },
    {
        headerTemplate = "ItemUpgradeTipStringColumnHeaderTemplate",
        headerText = _G["ITEMUPGRADETIP_L_CREST_TYPE"],
        headerParameters = { "crestType" },
        cellTemplate = "ItemUpgradeTipStringCellTemplate",
        cellParameters = { "crestType" },
        width = 244
    },
}

ItemUpgradeTipUpgradeDataProviderMixin = CreateFromMixins(ItemUpgradeTipDisplayDataProviderMixin)

function ItemUpgradeTipUpgradeDataProviderMixin:Refresh()
    self.onPreserveScroll()
    self:Reset()

    local results = {}
    local UPGRADE_TIER_FORMAT_STRING = "%d/%d"

    for index, upgradeTrack in ipairs(ItemUpgradeTip:GetupgradeTrackInfo()) do
        local icon = upgradeTrack.currencyInfo.iconFileID and CreateTextureMarkup(upgradeTrack.currencyInfo.iconFileID, 64, 64, 0, 0, 0.1, 0.9, 0.1, 0.9) or ""

        local rank1 = upgradeTrack.upgrade1.rank
        local rank2 = nil

        local upgradeTierString1 = UPGRADE_TIER_FORMAT_STRING:format(upgradeTrack.upgrade1.upgradeLevel, upgradeTrack.upgrade1.maxUpgradeLevel)
        local upgradeTierString2 = nil

        if upgradeTrack.upgrade2 ~= nil then
            rank2 = upgradeTrack.upgrade2.rank
            upgradeTierString2 = UPGRADE_TIER_FORMAT_STRING:format(upgradeTrack.upgrade2.upgradeLevel, upgradeTrack.upgrade2.maxUpgradeLevel)
        end

        local upgradeInfo = {
            ilvl = upgradeTrack.itemLevel,
            crestType = icon .. " " .. upgradeTrack.color:WrapTextInColorCode(upgradeTrack.currencyInfo.name),
            veteranTier = (rank1 == 3 and upgradeTierString1) or (rank2 == 3 and upgradeTierString2) or "",
            championTier = (rank1 == 4 and upgradeTierString1) or (rank2 == 4 and upgradeTierString2) or "",
            heroTier = (rank1 == 5 and upgradeTierString1) or (rank2 == 5 and upgradeTierString2) or "",
            mythTier = (rank1 == 6 and upgradeTierString1) or (rank2 == 6 and upgradeTierString2) or "",
            index = index,
            selected = self:IsSelected(index),
            crestTypeCurrencyId = upgradeTrack.currencyId
        }

        table.insert(results, upgradeInfo)
    end

    self:AppendEntries(results)
end

function ItemUpgradeTipUpgradeDataProviderMixin:GetColumnHideStates()
    return {}
end

function ItemUpgradeTipUpgradeDataProviderMixin:GetTableLayout()
    return UPGRADE_DATA_PROVIDER_LAYOUT
end

function ItemUpgradeTipUpgradeDataProviderMixin:GetRowTemplate()
    return "ItemUpgradeTipUpgradeRowTemplate"
end
