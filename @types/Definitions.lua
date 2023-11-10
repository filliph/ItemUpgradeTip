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
---@field currencyInfo CurrencyInfo?
