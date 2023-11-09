-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

---@class private.currencyInfo : { [number]: CurrencyInfo }
private.currencyInfo = {}

---@class private.currencyIds : { [string]: number }
private.currencyIds = {}

---@class private.currencyIndexes : { [number]: boolean }
private.currencyIndexes = {}

---@class private.upgradeHandlers : { [number]: fun(tooltip: GameTooltip, itemId: number, itemLink: string, currentUpgrade: number, maxUpgrade: number, bonusIds: table<number, number>): boolean }
private.upgradeHandlers = {}

---@type Localizations
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnFolderName)

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
                        name = L["General"],
                        args = {
                            compactTooltips = {
                                order = increment(),
                                type = "toggle",
                                name = L["Compact tooltips"],
                                desc = L["If enabled, compatible tooltip integrations will use a more compact format rather than showing the full upgrade info."],
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
                                name = L["Disabled Integrations"],
                            },

                            disabledIntegrationsHelp = {
                                order = increment(),
                                type = "description",
                                name = L["If you wish to disable certain tooltip integrations, you can do so via the options below."],
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


-- ----------------------------------------------------------------------------
-- Upgrade information frame
-- ----------------------------------------------------------------------------
local cols = {
    [1] = {
        header = "",
        width = 0.25,
    },
    [2] = {
        header = "Key",
        width = 1,
    },
    [3] = {
        header = "Loot",
        width = 1,
    },
    [4] = {
        header = "Vault",
        width = 1,
    },
    [5] = {
        header = "Drops",
        width = 1,
    },
    [6] = {
        header = "",
        width = 2,
    },
    [7] = {
        header = "Boss",
        width = 1,
    },
    [8] = {
        header = "LFR",
        width = 1,
    },
    [9] = {
        header = "Normal",
        width = 1,
    },
    [10] = {
        header = "Heroic",
        width = 1,
    },
    [11] = {
        header = "Mythic",
        width = 1,
    },
}

local function ClearTooltip()
    GameTooltip:ClearLines()
    GameTooltip:Hide()
end

function private:InitializeFrame()
    -- [[ Frame ]]
    local frame = CreateFrame("Frame", AddOnFolderName .. "Frame", UIParent, "SettingsFrameTemplate")
    frame.NineSlice.Text:SetText(AddOnFolderName)
    frame:SetSize(1000, 500)
    frame:SetPoint("CENTER")
    frame:Hide()
    private.frame = frame

    -- Set movable
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetMovable(true)
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- Set resizable
    frame:SetResizable(true)
    frame:SetResizeBounds(500, 300, GetScreenWidth() - 400, GetScreenHeight() - 200)

    local resize = CreateFrame("Button", nil, frame)
    resize:SetPoint("BOTTOMRIGHT", -2, 2)
    resize:SetNormalTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]])
    resize:SetHighlightTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]])
    resize:SetPushedTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]])
    resize:SetSize(16, 16)
    resize:EnableMouse(true)

    resize:SetScript("OnMouseDown", function()
        frame:StartSizing("BOTTOMRIGHT")
    end)

    resize:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
    end)

    -- Sorting
    frame.sorting = { 1, 2, 4, 3, 5, 6, 7, 8 }

    -- [[ Table ]]
    ---------------------
    local scrollBox = CreateFrame("Frame", nil, frame, "WoWScrollBoxList")
    local scrollBar = CreateFrame("EventFrame", nil, frame, "MinimalScrollBar")

    -- Headers
    frame.headers = {}
    for id, col in ipairs(cols) do
        local header = frame.headers[id] or CreateFrame("Button", nil, frame, "BackdropTemplate")

        if col.header ~= "" then
            DevTools_Dump(col.header)
            header:SetBackdrop({
                bgFile = [[Interface\Buttons\WHITE8x8]],
                edgeFile = [[Interface\Buttons\WHITE8x8]],
                edgeSize = 1,
            })
            header:SetBackdropBorderColor(0, 0, 0)
            header:SetBackdropColor(0, 0, 0, 0.5)
        end

        header:SetScript("OnEnter", function()
            header.text:SetFontObject("GameFontHighlight")
        end)
        header:SetScript("OnLeave", function()
            header.text:SetFontObject("GameFontNormal")
        end)

        header:SetHeight(20)
        frame.headers[id] = header

        
        header.text = header.text or header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        header.text:SetPoint("TOPLEFT", 4, -4)
        header.text:SetPoint("BOTTOMRIGHT", -4, 4)
        header.text:SetJustifyH("LEFT")
        header.text:SetJustifyV("BOTTOM")
        header.text:SetText(col.header)

        header:SetScript("OnClick", function()
            local DataProvider = scrollBox:GetDataProvider()
            if DataProvider then
                if col.des then
                    col.des = nil
                else
                    col.des = true
                end

                DataProvider:Sort()
            end
        end)

        function header:DoLayout()
            header:SetPoint("TOP", frame.Bg, "TOP", 0, -10)
            if id == 1 then
                header:SetPoint("LEFT", frame.Bg, "LEFT", 0, 0)
            else
                header:SetPoint("LEFT", frame.headers[id - 1], "RIGHT", 0, 0)
            end
            header:SetWidth((scrollBox.colWidth or 0) * col.width)
        end
    end

    -- Set scrollBox/scrollBar points
    scrollBar:SetPoint("BOTTOMRIGHT", -10, 10)
    scrollBar:SetPoint("TOP", frame.headers[1] or frame.Bg, "BOTTOM", 0, -10)
    scrollBox:SetPoint("TOPLEFT", frame.headers[1] or frame.Bg, "BOTTOMLEFT", 0, -10)
    scrollBox:SetPoint("RIGHT", scrollBar, "LEFT", -10, 0)
    scrollBox:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)

    -- Create scrollView
    local scrollView = CreateScrollBoxListLinearView()

    scrollView:SetElementExtentCalculator(function()
        return 20
    end)

    scrollView:SetElementInitializer("Frame", function(frame, data)
        local order = frame:GetOrderIndex()
        local bgAlpha = mod(order, 2) == 0 and 0.5 or 0.25
        frame.bg = frame.bg or frame:CreateTexture(nil, "BACKGROUND")
        frame.bg:SetAllPoints(frame)
        frame.bg:SetColorTexture(0, 0, 0, bgAlpha)

        frame.cells = frame.cells or {}

        function frame:SetHighlighted(isHighlighted)
            for _, cell in pairs(frame.cells) do
                if isHighlighted then
                    cell.text:SetTextColor(1, 0.82, 0, 1)
                else
                    cell.text:SetTextColor(1, 1, 1, 1)
                end
            end

            if isHighlighted then
                frame.bg:SetColorTexture(1, 1, 1, 0.25)
            else
                frame.bg:SetColorTexture(0, 0, 0, bgAlpha)
            end
        end

        frame:SetScript("OnEnter", function()
            frame:SetHighlighted(true)
        end)

        frame:SetScript("OnLeave", function()
            frame:SetHighlighted()
            ClearTooltip()
        end)

        for id, col in pairs(cols) do
            local cell = frame.cells[id] or CreateFrame("Button", nil, frame)
            frame.cells[id] = cell

            
            cell.icon = cell.icon or cell:CreateTexture(nil, "ARTWORK")
            cell.icon:ClearAllPoints()
            cell.icon:SetTexture()

            cell.text = cell.text or cell:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            cell.text:SetPoint("TOPLEFT", 2, -2)
            cell.text:SetPoint("BOTTOMRIGHT", -2, 2)
            cell.text:SetJustifyH("LEFT")
            cell.text:SetJustifyV("TOP")
            cell.text:SetText(col.text(data))

            if col.icon then
                local success = col.icon(cell.icon, data)
                if success then
                    cell.text:SetPoint("TOPLEFT", cell.icon, "TOPRIGHT", 2, 0)
                end
            end

            function cell:SetPoints()
                cell:SetPoint("TOP")
                if id == 1 then
                    cell:SetPoint("LEFT", 0, 0)
                    cell:SetPoint("RIGHT", frame, "LEFT", scrollBox.colWidth * col.width, 0)
                else
                    cell:SetPoint("LEFT", frame.cells[id - 1], "RIGHT", 0, 0)
                    cell:SetPoint("RIGHT", frame.cells[id - 1], "RIGHT", scrollBox.colWidth * col.width, 0)
                end
                cell:SetPoint("BOTTOM")
            end

            cell:SetScript("OnEnter", function()
                frame:SetHighlighted(true)
                GameTooltip:SetOwner(cell, "ANCHOR_RIGHT")
                if col.tooltip then
                    col.tooltip(data, order)
                else
                    GameTooltip:AddLine(cell.text:GetText(), 1, 1, 1)
                end
                GameTooltip:Show()
            end)

            cell:SetScript("OnLeave", function()
                frame:SetHighlighted()
                ClearTooltip()
            end)
        end

        function frame:ArrangeCells()
            for _, cell in pairs(frame.cells) do
                cell:SetPoints()
            end
        end

        frame:SetScript("OnSizeChanged", frame.ArrangeCells)
        frame:ArrangeCells()
    end)

    ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, scrollView)

    -- OnSizeChanged scripts
    function frame:ArrangeHeaders()
        for _, header in pairs(frame.headers) do
            header:DoLayout()
        end
    end

    -- frame:SetScript("OnSizeChanged", frame.ArrangeHeaders)

    scrollBox:SetScript("OnSizeChanged", function(self, width)
        self.width = width
        self.colWidth = width / #cols
        frame:ArrangeHeaders()

        -- Need this to populate new entries when scrollBox gains height
        scrollBox:Update()
    end)

    -- [[ Post layout ]]
    frame.scrollBox = scrollBox
    scrollBox.scrollBar = scrollBar
    scrollBox.scrollView = scrollView
end
