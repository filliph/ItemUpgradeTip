-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

---@type Localizations
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnFolderName, "zhCN", false)

if not L then
    return
end

L["HEIRLOOM_UPGRADES"] = "传家宝升级"
L["X_UPGRADES"] = "%s 升级"
L["ITEM_UPGRADED_TO_MAX"] = "物品已升到最大等级物品！"
L["ITEM_CAN_BE_UPGRADED_TO_MAX"] = "物品可以升级到满等级！"
L["UPGRADE_LEVEL_X_Y"] = "提升等级: %d / %d"
L["COST_FOR_NEXT_LEVEL"] = "下一个等级:"
L["COST_TO_UPGRADE_TO_MAX"] = "升到满等级:"
L["CURRENCY_NEEDED_FOR_MAX"] = "到满等级所需货币:"
L["CURRENCY_REMAINING_AFTER_UPGRADING"] = "升级后剩余货币:"
L["FLIGHTSTONE_CREST_UPGRADES"] = "飞珑石/ 纹章升级"
L["WHELP_CRESTS"] = "雏龙的暗影烈焰纹章"
L["DRAKE_CRESTS"] = "幼龙的暗影烈焰纹章"
L["WYRM_CRESTS"] = "魔龙的暗影烈焰纹章"
L["ASPECT_CRESTS"] = "守护巨龙的暗影烈焰纹章"
L["FLIGHTSTONES"] = "飞珑石"
L["GENERAL"] = "选项"
L["ANIMA_UPGRADES"] = "心能"
L["HONOR_UPGRADES"] = "荣誉点数"
L["CONQUEST_UPGRADES"] = "征服点数"
L["DISABLED_INTEGRATIONS"] = "选择需要禁用功能"
L["DISABLED_INTEGRATIONS_DESC"] = "如果您希望禁用某些功能提示，可以通过选择以下选项来关闭提示。"
L["COMPACT_TOOLTIPS"] = "简约显示"
L["COMPACT_TOOLTIPS_DESC"] = "如果启用，兼容的鼠标提示将使用更简约的格式，而不是显示完整的信息。"
L["NEXT_UPGRADE_X"] = "下个等级 (%d):"
L["MAX_UPGRADE_X"] = "满等级 (%d):"
