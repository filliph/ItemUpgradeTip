---@meta

-- ----------------------------------------------------------------------------
-- Types
-- ----------------------------------------------------------------------------
---@class Array<T>: { [integer]: T }
---@class Dictionary<T>: { [string]: T }
---@class Localizations: Dictionary<string>


-- ----------------------------------------------------------------------------
-- Flightstone Upgrade Data
-- ----------------------------------------------------------------------------
---@class flightstoneUpgradeData
---@field id string
---@field name string
---@field color ColorMixin
---@field icon fileID|integer
---@field itemId integer?
---@field currencyId integer?

---@class flightstoneUpgradeCostData
---@field whelpCrests integer
---@field drakeCrests integer
---@field wyrmCrests integer
---@field aspectCrests integer
---@field flightstones integer


-- ----------------------------------------------------------------------------
-- Flightstone Bonus Data
-- ----------------------------------------------------------------------------
---@class flightstoneBonusData
---@field itemLevel integer
---@field rank integer
---@field upgradeLevel integer
---@field upgradeGroup integer


-- ----------------------------------------------------------------------------
-- Honor Bonus Data
-- ----------------------------------------------------------------------------
---@class honorBonusData
---@field itemLevel integer
---@field upgradeLevel integer
---@field maxUpgradeLevel integer


-- ----------------------------------------------------------------------------
-- Bonus Data
-- ----------------------------------------------------------------------------
---@class bonusData
---@field currencyId integer
---@field amount integer
---@field toMax integer


-- ----------------------------------------------------------------------------
-- Mythic+ Table Data
-- ----------------------------------------------------------------------------
---@class MythicPlusInfo
---@field keyLevel integer|string
---@field lootDrops integer
---@field vaultReward integer
---@field currencyId integer
---@field color ColorMixin
---@field currencyInfo CurrencyInfo?


-- ----------------------------------------------------------------------------
-- Raid Table Data
-- ----------------------------------------------------------------------------
---@class RaidInfo
---@field boss integer|string
---@field lfr integer
---@field normal integer
---@field heroic integer
---@field mythic integer

---@class RaidCurrencyInfo
---@field lfrCurrencyId integer
---@field lfrColor ColorMixin
---@field lfrCurrencyName string
---@field lfrCurrencyInfo CurrencyInfo?
---@field normalCurrencyId integer
---@field normalColor ColorMixin
---@field normalCurrencyName string
---@field normalCurrencyInfo CurrencyInfo?
---@field heroicCurrencyId integer
---@field heroicColor ColorMixin
---@field heroicCurrencyName string
---@field heroicCurrencyInfo CurrencyInfo?
---@field mythicCurrencyId integer
---@field mythicColor ColorMixin
---@field mythicCurrencyName string
---@field mythicCurrencyInfo CurrencyInfo?


-- ----------------------------------------------------------------------------
-- Upgrade Table Data
-- ----------------------------------------------------------------------------
---@class UpgradeTrackInfo
---@field itemLevel integer
---@field upgrade1 UpgradeTrackUpgrade
---@field upgrade2 UpgradeTrackUpgrade?
---@field currencyId integer
---@field currencyName string
---@field color ColorMixin
---@field currencyInfo CurrencyInfo?

---@class UpgradeTrackUpgrade
---@field rank integer
---@field upgradeLevel integer
---@field maxUpgradeLevel integer


-- ----------------------------------------------------------------------------
-- Crafting Data
-- ----------------------------------------------------------------------------
---@class CraftingInfo
---@field itemLevel integer
---@field itemId integer
---@field rank integer
---@field itemInfo table?
