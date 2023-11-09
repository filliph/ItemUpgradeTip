-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

---@type Localizations
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnFolderName)

---@class ItemUpgradeTip: AceAddon, AceConsole-3.0, AceEvent-3.0
local ItemUpgradeTip = LibStub("AceAddon-3.0"):NewAddon(AddOnFolderName, "AceConsole-3.0", "AceEvent-3.0")

-- Core initialisation
function ItemUpgradeTip:OnInitialize()
    private:InitializeFrame()
    local DB = private.Preferences:InitializeDatabase()

    private.DB = DB

    private.Preferences:SetupOptions()

    self:RegisterChatCommand("itemupgradetip", "ChatCommand")
    self:RegisterChatCommand("iut", "ChatCommand")
end

-- Ran during PLAYER_LOGIN
function ItemUpgradeTip:OnEnable()
    for currencyId, _ in pairs(private.currencyIndexes) do
        private.currencyInfo[currencyId] = C_CurrencyInfo.GetCurrencyInfo(currencyId)
    end

    self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

    -- TODO: Move to slash command
    private.frame:Show()
end

-- Not super useful just now, but might be in the future
function ItemUpgradeTip:OnDisable()
    self:UnregisterEvent("CURRENCY_DISPLAY_UPDATE")
    self:UnregisterChatCommand("itemupgradetip")
    self:UnregisterChatCommand("iut")
end

---Currency updated
---@diagnostic disable: unused-local
---@param event string
---@param currencyType number?
---@param quantity number?
---@param quantityChange number?
---@param quantityGainSource number?
---@param quantityLostSource number?
function ItemUpgradeTip:CURRENCY_DISPLAY_UPDATE(event, currencyType, quantity, quantityChange, quantityGainSource, quantityLostSource)

    if currencyType and quantity then
        if private.currencyIndexes[currencyType] then
            -- Refresh the entire currency info in case there's info other than quantity that also updated
            private.currencyInfo[currencyType] = C_CurrencyInfo.GetCurrencyInfo(currencyType)
        end
    end
end

local SUBCOMMAND_FUNCS = {}

---@param input string
function ItemUpgradeTip:ChatCommand(input)
    local subcommand, arguments = self:GetArgs(input, 2)

    if subcommand then
        local func = SUBCOMMAND_FUNCS[subcommand:upper()]

        if func then
            func(arguments or "")
        end
    else
        local settingsPanel = SettingsPanel

        if settingsPanel:IsVisible() then
            settingsPanel:Hide()
        else
            InterfaceOptionsFrame_OpenToCategory(private.Preferences.OptionsFrame)
        end
    end
end

function ItemUpgradeTip_OnAddonCompartmentClick()
	InterfaceOptionsFrame_OpenToCategory(private.Preferences.OptionsFrame)
end
