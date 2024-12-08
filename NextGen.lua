local function getversion()
    local success, scriptversion = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/UnboundedScripts/Volleyball4.2/refs/heads/main/currentversion.lua"))()
    end)
    if success then
        print("📜 Volleyball 4.2 | UB Hub " .. scriptversion)
        return scriptversion
    else
        warn("Fetch version information FAIL!")
        return nil
    end
end

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

-- Save configurations
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("UBHub/Volleyball42")
InterfaceManager:SetLibrary(Library)

----------------MOBILE GUI FUNCTIONALITY---------------- 
repeat task.wait(0.25) until game:IsLoaded()
getgenv().Image = "rbxassetid://10734973457"
getgenv().ToggleUI = "E"

task.spawn(function()
    if not getgenv().LoadedMobileUI == true then 
        getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")
        
        OpenUI.Name = "OpenUI"
        OpenUI.Parent = game:GetService("CoreGui")
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        ImageButton.Parent = OpenUI
        ImageButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0.9, 0, 0.1, 0)
        ImageButton.Size = UDim2.new(0, 50, 0, 50)
        ImageButton.Image = getgenv().Image
        ImageButton.Draggable = true
        ImageButton.ImageTransparency = 1 -- Fixed property
        
        UICorner.CornerRadius = UDim.new(0, 200)
        UICorner.Parent = ImageButton
        
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, getgenv().ToggleUI, false, game)
        end)
    end
end)

local currentVersion = getversion()

local Window = Library:CreateWindow{
    Title = "UB HUB | " .. currentVersion,
    SubTitle = "",
    TabWidth = 155,
    Size = UDim2.fromOffset(560, 420),
    Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(470, 380),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Vynixu",
    MinimizeKey = Enum.KeyCode.E -- Used when there's no MinimizeKeybind
}

local Tabs = {
    Home = Window:CreateTab{
        Title = "Home",
        Icon = "square-power"
    },
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "Map"
    },
    Teleport = Window:CreateTab{
        Title = "Teleport",
        Icon = "move"
    },
    Status = Window:CreateTab{
        Title = "Status",
        Icon = "info"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local LP = Tabs.Home:AddSection("LocalPlayer")
local Exec = Tabs.Status:AddSection("Executor")
local ScriptStatus = Tabs.Status:AddSection("Script")
local DC = Tabs.Home:AddSection("Discord")

local Input = LP:AddInput("WS", {
    Title = "WalkSpeed",
    Default = "Enter here",
    Numeric = true, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
        getgenv().Enabled = true -- change to false then execute again to turn off
        getgenv().Speed = Value -- change speed to the number you want
        loadstring(game:HttpGet("https://raw.githubusercontent.com/UnboundedScripts/Volleyball4.2/refs/heads/main/resources/SimpleSpeed_Eclipsology"))()
    end
})

DC:AddButton({
    Title = "Copy Server Link",
    Description = "https://discord.gg/KHckwwtYH9",
    Callback = function()
        setclipboard("https://discord.gg/KHckwwtYH9")
        toclipboard("https://discord.gg/KHckwwtYH9")
    end
})

local ToggleWSUsed = LP:AddToggle("WSUsed", {
    Title = "Walkspeed Use",
    Default = false,
    Callback = function(state)
        usewalkspeed = state
        if state then
            print("WalkSpeed Enable")
        else
            getgenv().Speed = 16
            getgenv().Enabled = true -- change speed to the number you want
            loadstring(game:HttpGet("https://raw.githubusercontent.com/UnboundedScripts/Volleyball4.2/refs/heads/main/resources/SimpleSpeed_Eclipsology"))()
        end
    end
})

----------------NoClip FUNCTION----------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local noclipConnection = nil

local function toggleNoclip(state)
    noclipEnabled = state
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = Players.LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

local ToggleNoClip = LP:AddToggle("No Clip", {
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        toggleNoclip(state)
    end
})

----------------SCRIPT CLOCK----------------
local Paragraph = ScriptStatus:Paragraph("Uptime", {
    Title = "Uptime",
    Content = "Time Running"
})

----------------EXECUTOR CHECKING----------------
local exec_name = (identifyexecutor)()
local status_icon
if exec_name == "Solara" then
    status_icon = "🟢"
elseif exec_name == "JJSploit x Xeno" then
    status_icon = "🟠"
elseif exec_name == "Delta" then
    status_icon = "🟢"
else
    status_icon = "❓"
    Library:Notify({
        Title = "⚠ | Warning",
        Content = "Your executor is unknown",
        SubContent = "It may have problems or be unsupported!",
        Duration = 8 -- Set to nil to make the notification not disappear
    })
end

local Paragraph = Exec:Paragraph("EXECUSE", {
    Title = "Current Use Executor",
    Content = "Name: " .. exec_name .. "\nStatus: " .. status_icon
})

Library:Notify({
    Title = "Successful Execution",
    Content = "The Script has loaded.",
    Duration = 5 -- Set to nil to make the notification not disappear
})
