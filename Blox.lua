local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local _G = _G or {}
_G.KillNpcs = false
_G.FruitESP = false
local selectedIslandPos = nil

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then return nil end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

local Islands = {
    ["Sea 1"] = {{"Starter Marine", CFrame.new(-2566, 7, 2045)}, {"Jungle", CFrame.new(-1108, 13, 331)}, {"Pirate Village", CFrame.new(-1122, 14, 3855)}, {"Desert", CFrame.new(1094, 14, 4192)}, {"Frozen Village", CFrame.new(1132, 27, -1150)}, {"Marine Fortress", CFrame.new(-4922, 24, 4210)}},
    ["Sea 2"] = {{"Kingdom of Rose", CFrame.new(-452, 73, 286)}, {"Green Bit", CFrame.new(-2448, 73, -263)}, {"Snow Mountain", CFrame.new(609, 401, -5350)}, {"Hot and Cold", CFrame.new(-5411, 15, -5264)}},
    ["Sea 3"] = {{"Port Town", CFrame.new(-290, 7, 5343)}, {"Hydra Island", CFrame.new(5228, 604, 332)}, {"Floating Turtle", CFrame.new(-13234, 531, -7576)}, {"Castle on the Sea", CFrame.new(-5075, 314, -3151)}}
}

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "BloxHubNull"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(60, 60, 60)

-- DRAG AVANZADO
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end
makeDraggable(MainFrame)

local TitleBtn = Instance.new("TextButton", MainFrame)
TitleBtn.Size = UDim2.new(1, 0, 0, 50)
TitleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBtn.Text = "  BLOX FRUITS GUI BY: NULL"
TitleBtn.TextColor3 = Color3.new(1, 1, 1)
TitleBtn.Font = Enum.Font.GothamBold; TitleBtn.TextSize = 18
TitleBtn.TextXAlignment = Enum.TextXAlignment.Left
TitleBtn.AutoButtonColor = false
Instance.new("UICorner", TitleBtn).CornerRadius = UDim.new(0, 15)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -50); ContentFrame.Position = UDim2.new(0, 0, 0, 50)
ContentFrame.BackgroundTransparency = 1

TitleBtn.MouseButton1Click:Connect(function()
    local targetSize = (MainFrame.Size.Y.Offset == 450) and UDim2.new(0, 400, 0, 50) or UDim2.new(0, 400, 0, 450)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
end)

local IslandList = Instance.new("ScrollingFrame", ContentFrame)
IslandList.Size = UDim2.new(1, -20, 0, 130); IslandList.Position = UDim2.new(0, 10, 0, 60)
IslandList.BackgroundColor3 = Color3.fromRGB(18, 18, 18); IslandList.ScrollBarThickness = 2
local ILay = Instance.new("UIListLayout", IslandList); ILay.Padding = UDim.new(0,5)

local function updateIslands(sea)
    IslandList:ClearAllChildren()
    Instance.new("UIListLayout", IslandList).Padding = UDim.new(0,5)
    for _, d in pairs(Islands[sea]) do
        local b = Instance.new("TextButton", IslandList)
        b.Size = UDim2.new(1, -10, 0, 30); b.Text = d[1]; b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        b.MouseButton1Click:Connect(function() selectedIslandPos = d[2]; print("Destino: "..d[1]) end)
    end
end

for i=1,3 do
    local b = Instance.new("TextButton", ContentFrame)
    b.Size = UDim2.new(0.3, 0, 0, 40); b.Position = UDim2.new(0.02 + (i-1)*0.32, 0, 0, 10)
    b.Text = "Sea "..i; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function() updateIslands("Sea "..i) end)
end

local function action(txt, pos, cb)
    local b = Instance.new("TextButton", ContentFrame)
    b.Size = UDim2.new(0, 180, 0, 45); b.Position = pos; b.BackgroundColor3 = Color3.new(1,1,1); b.TextColor3 = Color3.new(0,0,0)
    b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

action("TELEPORT ISLA", UDim2.new(0, 10, 0, 210), function()
    if selectedIslandPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0,0,0)
        task.wait(0.1)
        hrp.CFrame = selectedIslandPos
    end
end)

action("AUTO FARM: OFF", UDim2.new(0, 210, 0, 210), function(btn)
    _G.KillNpcs = not _G.KillNpcs
    btn.Text = _G.KillNpcs and "AUTO FARM: ON" or "AUTO FARM: OFF"
    
    task.spawn(function()
        local VirtualUser = game:GetService("VirtualUser")
        while _G.KillNpcs do
            pcall(function()
                local enemies = game:GetService("Workspace").Enemies:GetChildren()
                for _, npc in pairs(enemies) do
                    if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and npc:FindFirstChild("HumanoidRootPart") then
                        repeat
                            if not _G.KillNpcs then break end
                            local hrp = LocalPlayer.Character.HumanoidRootPart
                            hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                            hrp.Velocity = Vector3.new(0,0,0)
                            
                          
                            local rh = LocalPlayer.Character:FindFirstChild("RightHand")
                            if rh then rh.Size = Vector3.new(35,35,35); rh.CanCollide = false end
                            
                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new(1, 1))
                            task.wait(0.1)
                        until not npc.Parent or npc.Humanoid.Health <= 0
                    end
                end
            end)
            task.wait()
        end
        
        pcall(function() LocalPlayer.Character.RightHand.Size = Vector3.new(1,1,1) end)
    end)
end)

action("FRUIT ESP: OFF", UDim2.new(0, 10, 0, 270), function(btn)
    _G.FruitESP = not _G.FruitESP
    btn.Text = _G.FruitESP and "FRUIT ESP: ON" or "FRUIT ESP: OFF"
    
    task.spawn(function()
        while _G.FruitESP do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and v.Name:find("Fruit") and not v:FindFirstChild("ESP") then
                    local h = Instance.new("Highlight", v); h.Name = "ESP"
                    h.FillColor = Color3.new(1, 0, 0); h.OutlineColor = Color3.new(1, 1, 1)
                    
                    local billboard = Instance.new("BillboardGui", v)
                    billboard.Name = "Dist"
                    billboard.Size = UDim2.new(0, 200, 0, 50); billboard.Adornee = v.Handle; billboard.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", billboard)
                    txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.new(1, 1, 1); txt.Font = Enum.Font.GothamBold; txt.TextSize = 14
                    
                    task.spawn(function()
                        while v.Parent == game.Workspace and _G.FruitESP do
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Handle.Position).Magnitude
                            txt.Text = v.Name .. " [" .. math.floor(dist/3) .. "m]"
                            task.wait(0.5)
                        end
                        billboard:Destroy(); h:Destroy()
                    end)
                end
            end
            task.wait(2)
        end
    end)
end)

action("TP FRUTA", UDim2.new(0, 210, 0, 270), function()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:find("Fruit") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
            break
        end
    end
end)
