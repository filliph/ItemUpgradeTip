-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

---@class private.currencyInfo : Array<CurrencyInfo>
private.currencyInfo = {}

---@class private.currencyIds : { [string]: number }
private.currencyIds = {}

---@class private.currencyIndexes : Array<boolean>
private.currencyIndexes = {}

---@class private.upgradeHandlers : { [number]: fun(tooltip: GameTooltip, itemId: number, itemLink: string, currentUpgrade: number, maxUpgrade: number, bonusIds: table<number, number>): boolean }
private.upgradeHandlers = {}

---@class private.mythicPlusInfo : Array<MythicPlusInfo>
private.mythicPlusInfo = {}

---@type Localizations
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnFolderName)

-- Export constants into the global scope (for XML frames to use)
for key, value in pairs(L) do
    _G["ITEMUPGRADETIP_L_" .. key] = value
end

-- ----------------------------------------------------------------------------
-- Preferences
-- ----------------------------------------------------------------------------
local metaVersion = GetAddOnMetadata(AddOnFolderName, "Version")
local isDevelopmentVersion = metaVersion == "@project-version@"

local buildVersion = isDevelopmentVersion and "Development Version" or metaVersion

---@type table
local Options

---@class Preferences
---@field OptionsFrame Frame
local Preferences = {
    DisabledIntegrations = {},
    DefaultValues = {
        profile = {
            CompactTooltips = false,

            DisabledIntegrations = {},
        },
    },
    GetOptions = function()
        if not Options then
            local DB = private.DB.profile

            local count = 1;
            local function increment() count = count + 1; return count end;

            Options = {
                type = "group",
                name = ("%s - %s"):format(AddOnFolderName, buildVersion),
                childGroups = "tab",
                args = {
                    general = {
                        order = increment(),
                        type = "group",
                        name = L["GENERAL"],
                        args = {
                            compactTooltips = {
                                order = increment(),
                                type = "toggle",
                                name = L["COMPACT_TOOLTIPS"],
                                desc = L["COMPACT_TOOLTIPS_DESC"],
                                width = "double",
                                get = function()
                                    return DB.CompactTooltips
                                end,
                                set = function(info, value)
                                    DB.CompactTooltips = value
                                end,
                            },

                            separatorIntegrations = {
                                order = increment(),
                                type = "header",
                                name = L["DISABLED_INTEGRATIONS"],
                            },

                            disabledIntegrationsHelp = {
                                order = increment(),
                                type = "description",
                                name = L["DISABLED_INTEGRATIONS_DESC"],
                            }
                        }
                    }
                },
            }

            for upgradeHandler, optionTable in pairs(private.Preferences.DisabledIntegrations) do
                optionTable.get = function(info)
                    return DB.DisabledIntegrations[info[#info]]
                end

                optionTable.set = function(info, value)
                    DB.DisabledIntegrations[info[#info]] = value;
                end

                Options.args.general.args["disabledIntegrations_" .. upgradeHandler] = optionTable
            end

            -- Get the option table for profiles
	        Options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(private.DB)
        end

        return Options
    end,
    ---@param self Preferences
    InitializeDatabase = function(self)
        return LibStub("AceDB-3.0"):New(AddOnFolderName .. "DB", self.DefaultValues, true)
    end,
    ---@param self Preferences
    SetupOptions = function(self)
        LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(AddOnFolderName, self.GetOptions)
        self.OptionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(AddOnFolderName)
    end,
}

private.Preferences = Preferences
