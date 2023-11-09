-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

---@type Localizations
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnFolderName)

local ITEM_UPGRADE_LEVEL = ITEM_UPGRADE_TOOLTIP_FORMAT:gsub("%%d+", "(%%d+)")  -- Upgrade Level: %d/%d
local ITEM_UPGRADE_TRACK = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING:gsub("%%d", "(%%d+)"):gsub("%%s", "(.-)") -- "Upgrade Level: %s %d/%d"

--- Generic currency handler based on bonusInfo table
---@param tooltip GameTooltip
---@param currentUpgrade number
---@param maxUpgrade number
---@param bonusInfo bonusData
function private.HandleCurrency(tooltip, currentUpgrade, maxUpgrade, bonusInfo)
    local upgradesRemaining = maxUpgrade - currentUpgrade
    local currencyInfo = private.currencyInfo[bonusInfo.currencyId]
    if not currencyInfo then
        private.Debug(bonusInfo.currencyId, "was not found in the currency info cache");
        return
    end

    local currencyOwned = currencyInfo.quantity
    local currencyIconId = currencyInfo.iconFileID

    tooltip:AddLine("\n")

    tooltip:AddLine("|cffa335ee" .. L["X_UPGRADES"]:format(currencyInfo.name) .. "|r")
    tooltip:AddTexture(currencyIconId)

    if currencyOwned >= bonusInfo.toMax and upgradesRemaining > 0 and not private.DB.profile.CompactTooltips then
        tooltip:AddLine(L["ITEM_CAN_BE_UPGRADED_TO_MAX"])
    end

    if upgradesRemaining == 0 then
        if not private.DB.profile.CompactTooltips then
            tooltip:AddLine("|cffffffee" .. L["ITEM_UPGRADED_TO_MAX"] .. "|r")
        end
    else
        tooltip:AddDoubleLine("|cffffffee" .. L["COST_FOR_NEXT_LEVEL"] .. "|r", "|cffffffee" .. bonusInfo.amount .. "|r")
        tooltip:AddDoubleLine("|cffffffee" .. L["COST_TO_UPGRADE_TO_MAX"] .. "|r", "|cffffffee" .. bonusInfo.toMax .. "|r")

        if not private.DB.profile.CompactTooltips then
            if currencyOwned >= bonusInfo.toMax then
                tooltip:AddDoubleLine("|cffffffee" .. L["CURRENCY_REMAINING_AFTER_UPGRADING"] .. "|r", "|cffffffee" .. (currencyOwned - bonusInfo.toMax) .. "|r")
            else
                tooltip:AddDoubleLine("|cffffffee" .. L["CURRENCY_NEEDED_FOR_MAX"] .. "|r", "|cffffffee" .. (bonusInfo.toMax - currencyOwned) .. "|r")
            end
        end
    end
end

--- Handles updating an item tooltip to add additional information about upgrade costs
---@param tooltip GameTooltip
---@param tooltipData TooltipData
function private.HandleTooltipSetItem(tooltip, tooltipData)
    if tooltip ~= _G.GameTooltip then
        return
    end

    ---@type table<number, boolean>
    local processed = {};   --process each line once

    for i = 1, #tooltipData.lines do
        if not processed[i] then
            ---@type TooltipDataLine
            local tooltipLine = tooltipData.lines[i]

            private.Debug(tooltipLine.leftText)

            local debugPattern = ITEM_UPGRADE_LEVEL

            local currentUpgrade, ---@type number?
                maxUpgrade ---@type number?
            = tooltipLine.leftText:match(ITEM_UPGRADE_LEVEL)

            if not currentUpgrade or not maxUpgrade then
                _, currentUpgrade, maxUpgrade = tooltipLine.leftText:match(ITEM_UPGRADE_TRACK)

                debugPattern = ITEM_UPGRADE_TRACK
            end

            if currentUpgrade and maxUpgrade then
                private.Debug(debugPattern, "-", currentUpgrade, "/", maxUpgrade)

                if currentUpgrade == maxUpgrade then
                    private.Debug(currentUpgrade, "was equal to", maxUpgrade)
                    return
                end

                local _, itemLink = tooltip:GetItem()
                if not itemLink then
                    private.Debug("Tooltip does not have a valid item link")
                    return
                end

                ---@type string?
                local itemString = string.match(itemLink, "item:([%-?%d:]+)")
                if not itemString then
                    private.Debug(itemLink, "does not appear to be a valid item string (did not match \"item:([%-?%d:]+)\")");
                    return
                end

                ---@type table<number, number>
                local bonusIds = {}

                ---@type table<number,any>
                local itemSplit = {}

                for v in string.gmatch(itemString, "(%d*:?)") do
                    if v == ":" then
                        itemSplit[#itemSplit + 1] = 0
                    else
                        itemSplit[#itemSplit + 1] = string.gsub(v, ":", "")
                    end
                end

                ---@type number?
                local itemId = tonumber(itemSplit[1])
                if not itemId then
                    private.Debug(itemString, "does not appear to contain a valid item ID (found", itemId, ")");
                    return
                end

                ---@type number?
                local numBonusIds = tonumber(itemSplit[13])
                if not numBonusIds then
                    private.Debug(itemString, "does not appear to contain the number of bonuses (found", numBonusIds, ")");
                    return
                end

                for index = 1, numBonusIds do
                    bonusIds[#bonusIds + 1] = tonumber(itemSplit[13 + index])
                end

                processed[i] = true;

                for j = 1, #private.upgradeHandlers do
                    local callback = private.upgradeHandlers[j]

                    if type(callback) == "function" and callback(tooltip, itemId, itemLink, currentUpgrade, maxUpgrade, bonusIds) then return end
                end

                return
            end
        end
    end
end

-- Tooltip integration
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, private.HandleTooltipSetItem)
