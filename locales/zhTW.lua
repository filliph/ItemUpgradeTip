-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

---@type Localizations
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnFolderName, "zhTW", false)

if not L then
    return
end

L["HEIRLOOM_UPGRADES"] = "傳家寶升級"
L["X_UPGRADES"] = "%s 升級"
L["ITEM_UPGRADED_TO_MAX"] = "物品已升到最大等級！"
L["ITEM_CAN_BE_UPGRADED_TO_MAX"] = "物品可以升級到滿等！"
L["UPGRADE_LEVEL_X_Y"] = "提升等級: %d / %d"
L["COST_FOR_NEXT_LEVEL"] = "下個等級花費:"
L["COST_TO_UPGRADE_TO_MAX"] = "升到滿等花費:"
L["CURRENCY_NEEDED_FOR_MAX"] = "到滿等所需通貨:"
L["CURRENCY_REMAINING_AFTER_UPGRADING"] = "升級後剩餘通貨:"
L["FLIGHTSTONE_CREST_UPGRADES"] = "龍石 / 紋章升級"
L["WHELP_CRESTS"] = "幼龍紋章"
L["DRAKE_CRESTS"] = "飛龍紋章"
L["WYRM_CRESTS"] = "巨龍紋章"
L["ASPECT_CRESTS"] = "守護巨龍紋章"
L["FLIGHTSTONES"] = "龍石"
