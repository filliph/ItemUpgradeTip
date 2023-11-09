-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

---@type Localizations
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnFolderName, "deDE", false)

if not L then
    return
end

L["X_UPGRADES"] = "%s Aufwertungen"
L["ANIMA_UPGRADES"] = "Anima Aufwertungen"
L["ASPECT_CRESTS"] = "Wappen des Aspekts"
L["COMPACT_TOOLTIPS"] = "Kompakte Tooltips"
L["CONQUEST_UPGRADES"] = "Eroberungs Aufwertungen"
L["COST_FOR_NEXT_LEVEL"] = "Kosten für die nächste Stufe:"
L["COST_TO_UPGRADE_TO_MAX"] = "Kosten um auf die maximal Stufe aufzuwerten:"
L["CURRENCY_NEEDED_FOR_MAX"] = "Für die maximal Stufe benötigte Währung:"
L["CURRENCY_REMAINING_AFTER_UPGRADING"] = "Verbleibende Währung nach dem Aufwerten:"
L["DISABLED_INTEGRATIONS"] = "Integration deaktivieren"
L["DRAKE_CRESTS"] = "Wappen des Drachen"
L["FLIGHTSTONE_CREST_UPGRADES"] = "Flugstein / Wappen Aufwertung"
L["FLIGHTSTONES"] = "Flugsteine"
L["GENERAL"] = "Allgemein"
L["HEIRLOOM_UPGRADES"] = "Erbstückaufwertungen"
L["HONOR_UPGRADES"] = "Ehren Aufwertungen"
L["COMPACT_TOOLTIPS_DESC"] = "Wenn diese Option aktiviert ist, verwenden kompatible Tooltip-Integrationen ein kompakteres Format, anstatt die vollständigen Upgrade-Informationen anzuzeigen."
L["DISABLED_INTEGRATIONS_DESC"] = "Wenn bestimmte Tooltip-Integrationen deaktiviert werden sollen, kann dies über die folgenden Optionen gemacht werden."
L["ITEM_CAN_BE_UPGRADED_TO_MAX"] = "Gegenstand kann auf die maximal Stufe aufgewertet werden!"
L["ITEM_UPGRADED_TO_MAX"] = "Gegenstand auf maximal Stufe aufgewertet!"
L["MAX_UPGRADE_X"] = "Max. Aufwertung (%d):"
L["NEXT_UPGRADE_X"] = "Nächste Aufwertung (%d):"
L["UPGRADE_LEVEL_X_Y"] = "Aufwertungsstufe: %d / %d"
L["WHELP_CRESTS"] = "Wappen des Welplings"
L["WYRM_CRESTS"] = "Wappen des Wyrms"
