-- إعداد اسم ورول بلاي للمستخدم مع اللون
local args1 = {
    [1] = "RolePlayName",
    [2] = "XENO V1 سكربت",
    [3] = "Aqua" -- لون الاسم
}
game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPNam1eTex1t"):FireServer(unpack(args1))

-- إعداد وصف رول بلاي مع اللون
local args2 = {
    [1] = "RolePlayBio",
    [2] = "مطور السكربت نيبرو/XENO",
    [3] = "Red" -- لون الوصف
}
game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPNam1eTex1t"):FireServer(unpack(args2))


wait()

game.Players.LocalPlayer.Character:FindFirstChild("Head"):Destroy()
local xenolib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xeno9995/Xeno-hub/refs/heads/main/XENO%20PRO%20LIBRARY%20NEW"))()
local Window = xenolib:MakeWindow({
  Title = "XENO HUB | BROOKHAVEN",
  SubTitle = "by xeno999",
  SaveFolder = "test | xeno lib v1.json"
})
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://1749375889088", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0.6, 1) },
})
local Tab1 = Window:MakeTab({"Discord", "Warning"})
Tab1:AddDiscordInvite({
    Name = "XENO COMMUNITY",
    Description = "Join server",
    Logo = "rbxassetid://1749375889088",
    Invite = "https://discord.gg/xAZq4kD6",
})

local Tab2 = Window:MakeTab({"Information", "Home"})
local Section = Tab2:AddSection({"Information from this script"})
Tab2:AddParagraph({
    Title = "Xeno Hub",
    Text = "This Script Was Created By Xeno9995"
})
Tab2:AddParagraph({
    Title = "Xeno hub",
    Text = "Script Have Updates Every 2 Weak"
})
Tab2:AddParagraph({
    Title = "Xeno Hub",
    Text = "Thank You For Using XENO HUB Script"
})
Tab2:AddParagraph({
    Title = "Xeno Hub",
    Text = "This Script Was Have Multiple languages in the upcoming update V2 And of these languages are Arabic and many more"
})
Tab2:AddParagraph({
    Title = "Xeno Hub",
    Text = "And if you have a problem with the script or you have a defect in something inside the script contact me at Discord I am available at any time"
})
Tab2:AddParagraph({
    Title = "Xeno Hub",
    Text = "Like And Subscribe To My Channel And Enjoy Using Script :)"
})
local Tab3 = Window:MakeTab({"Player Info", "info"})
local Section = Tab3:AddSection({"Information From Player"})
local player = game.Players.LocalPlayer
local username = player.Name
local displayName = player.DisplayName
local userId = player.UserId
local accountAge = player.AccountAge

-- Get the current game's name and ID
local gameName
local success, result = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)
if success then
    gameName = result
else
    gameName = "Unknown"
end

local gameId = game.PlaceId

-- Get the number of players currently in the server
local playersInServer = #game.Players:GetPlayers()

Tab3:AddParagraph({
    Title = "Username: " .. username,
    Text = ""
})
Tab3:AddParagraph({
    Title = "Display Name: " .. displayName,
    Text = ""
})
Tab3:AddParagraph({
    Title = "User ID: " .. userId,
    Text = ""
})
Tab3:AddParagraph({
    Title = "Account Age: " .. accountAge .. " days",
    Text = ""
})
Tab3:AddParagraph({
    Title = "Game Name: " .. gameName,
    Text = ""
})
Tab3:AddParagraph({
    Title = "Game ID: " .. gameId,
    Text = ""
})
Tab3:AddParagraph({
    Title = "Players in Server: " .. playersInServer,
    Text = ""
})
local Tab4 = Window:MakeTab({"Player", "User"})
local Section = Tab4:AddSection({"Choose a Player to Reveal his Whereabouts and Teleport to him"})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- إعدادات ESP --
local ESPSettings = {
    Enabled = false,
    BoxColor = Color3.fromRGB(0, 255, 0),
    TracerColor = Color3.fromRGB(255, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    BoxThickness = 1.4,
    TracerThickness = 1.4,
    TeamCheck = false,
    Autothickness = true,
}

local ESPData = {
    Connections = {},
    Objects = {}
}

local selectedPlayer = nil

-- وظيفة إنشاء عناصر ESP لكل لاعب --
local function CreateESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Head") then
        return
    end

    local drawings = {
        Lines = {},
        Text = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }

    -- إنشاء 12 خط للصندوق
    for i = 1, 12 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = ESPSettings.BoxColor
        line.Thickness = ESPSettings.BoxThickness
        table.insert(drawings.Lines, line)
    end

    -- إعداد النص
    drawings.Text.Visible = false
    drawings.Text.Color = ESPSettings.TextColor
    drawings.Text.Size = 15
    drawings.Text.Center = true
    drawings.Text.Outline = true
    drawings.Text.OutlineColor = Color3.new(0,0,0)

    -- إعداد خط التتبع
    drawings.Tracer.Visible = false
    drawings.Tracer.Color = ESPSettings.TracerColor
    drawings.Tracer.Thickness = ESPSettings.TracerThickness

    -- تحديث ESP كل إطار
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not ESPSettings.Enabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Head") then
            -- تنظيف عند عدم الحاجة
            for _, line in pairs(drawings.Lines) do line.Visible = false end
            drawings.Tracer.Visible = false
            drawings.Text.Visible = false
            return
        end

        local rootPart = player.Character.HumanoidRootPart
        local head = player.Character.Head
        local pos, vis = Camera:WorldToViewportPoint(rootPart.Position)
        if vis then
            local scale = head.Size.Y / 2
            local size = Vector3.new(2, 3, 1.5) * (scale * 2)

            local points = {
                Top = {
                    Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-size.X, size.Y, -size.Z)).p),
                    Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-size.X, size.Y, size.Z)).p),
                    Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(size.X, size.Y, size.Z)).p),
                    Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(size.X, size.Y, -size.Z)).p),
                },
                Bottom = {
                    Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-size.X, -size.Y, -size.Z)).p),
                    Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-size.X, -size.Y, size.Z)).p),
                    Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(size.X, -size.Y, size.Z)).p),
                    Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(size.X, -size.Y, -size.Z)).p),
                }
            }

            local lines = drawings.Lines
            -- تحديث خطوط الصندوق (12 خط)
            lines[1].From = Vector2.new(points.Top[1].X, points.Top[1].Y)
            lines[1].To = Vector2.new(points.Top[2].X, points.Top[2].Y)

            lines[2].From = Vector2.new(points.Top[2].X, points.Top[2].Y)
            lines[2].To = Vector2.new(points.Top[3].X, points.Top[3].Y)

            lines[3].From = Vector2.new(points.Top[3].X, points.Top[3].Y)
            lines[3].To = Vector2.new(points.Top[4].X, points.Top[4].Y)

            lines[4].From = Vector2.new(points.Top[4].X, points.Top[4].Y)
            lines[4].To = Vector2.new(points.Top[1].X, points.Top[1].Y)

            lines[5].From = Vector2.new(points.Bottom[1].X, points.Bottom[1].Y)
            lines[5].To = Vector2.new(points.Bottom[2].X, points.Bottom[2].Y)

            lines[6].From = Vector2.new(points.Bottom[2].X, points.Bottom[2].Y)
            lines[6].To = Vector2.new(points.Bottom[3].X, points.Bottom[3].Y)

            lines[7].From = Vector2.new(points.Bottom[3].X, points.Bottom[3].Y)
            lines[7].To = Vector2.new(points.Bottom[4].X, points.Bottom[4].Y)

            lines[8].From = Vector2.new(points.Bottom[4].X, points.Bottom[4].Y)
            lines[8].To = Vector2.new(points.Bottom[1].X, points.Bottom[1].Y)

            lines[9].From = Vector2.new(points.Bottom[1].X, points.Bottom[1].Y)
            lines[9].To = Vector2.new(points.Top[1].X, points.Top[1].Y)

            lines[10].From = Vector2.new(points.Bottom[2].X, points.Bottom[2].Y)
            lines[10].To = Vector2.new(points.Top[2].X, points.Top[2].Y)

            lines[11].From = Vector2.new(points.Bottom[3].X, points.Bottom[3].Y)
            lines[11].To = Vector2.new(points.Top[3].X, points.Top[3].Y)

            lines[12].From = Vector2.new(points.Bottom[4].X, points.Bottom[4].Y)
            lines[12].To = Vector2.new(points.Top[4].X, points.Top[4].Y)

            -- تحديث سماكة الخطوط تلقائياً حسب المسافة (اختياري)
            if ESPSettings.Autothickness then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                local thickness = math.clamp(1 / dist * 100, 0.1, 4)
                for _, line in pairs(lines) do
                    line.Thickness = thickness
                end
                drawings.Tracer.Thickness = thickness
            else
                for _, line in pairs(lines) do
                    line.Thickness = ESPSettings.BoxThickness
                end
                drawings.Tracer.Thickness = ESPSettings.TracerThickness
            end

            -- تحديث خط التتبع
            local tracerPos = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(0, -size.Y, 0)).p)
            drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.Tracer.To = Vector2.new(tracerPos.X, tracerPos.Y)

            -- تحديث النص (الاسم والمسافة)
            local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
            drawings.Text.Text = player.Name .. "\n" .. distance .. "m"
            drawings.Text.Position = Vector2.new(pos.X, pos.Y - 50)

            -- إظهار العناصر
            for _, line in pairs(lines) do line.Visible = true end
            drawings.Tracer.Visible = true
            drawings.Text.Visible = true
        else
            -- إخفاء العناصر إذا لم يكن مرئياً
            for _, line in pairs(drawings.Lines) do line.Visible = false end
            drawings.Tracer.Visible = false
            drawings.Text.Visible = false
        end
    end)

    table.insert(ESPData.Connections, connection)
    ESPData.Objects[player] = drawings
end

-- وظيفة إزالة كل ESP --
local function ClearESP()
    for _, conn in pairs(ESPData.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    ESPData.Connections = {}

    for _, drawings in pairs(ESPData.Objects) do
        for _, line in pairs(drawings.Lines) do
            pcall(function() line:Remove() end)
        end
        pcall(function() drawings.Text:Remove() end)
        pcall(function() drawings.Tracer:Remove() end)
    end
    ESPData.Objects = {}
end

-- تحديث قائمة أسماء اللاعبين --
local function GetPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

-- تحديث القائمة عند دخول وخروج اللاعبين --
Players.PlayerAdded:Connect(function()
    task.wait(1)
    if Tab4 and Tab4["Elements"] and Tab4["Elements"]["Select Player"] then
        Tab4["Elements"]["Select Player"].Dropdown:Refresh(GetPlayerNames(), true)
    end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(1)
    if Tab4 and Tab4["Elements"] and Tab4["Elements"]["Select Player"] then
        Tab4["Elements"]["Select Player"].Dropdown:Refresh(GetPlayerNames(), true)
    end
end)

-- إعداد واجهة المستخدم --

-- اختيار اللاعب --
Tab4:AddDropdown({
    Name = "Select Player",
    Options = GetPlayerNames(),
    Default = "",
    Callback = function(choice)
        selectedPlayer = Players:FindFirstChild(choice)
        ClearESP()
        if ESPSettings.Enabled and selectedPlayer then
            CreateESP(selectedPlayer)
        end
    end
})

-- تفعيل/إيقاف ESP --
Tab4:AddToggle({
    Name = "Esp Player",
    Default = false,
    Callback = function(state)
        ESPSettings.Enabled = state
        if state then
            if selectedPlayer then
                CreateESP(selectedPlayer)
            end
        else
            ClearESP()
        end
    end
})

-- تفعيل/إيقاف تتبع الكاميرا (View) --
local viewConnection = nil
Tab4:AddToggle({
    Name = "View Player",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") then
            viewConnection = RunService.Heartbeat:Connect(function()
                if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") then
                    Camera.CameraSubject = selectedPlayer.Character.Head
                end
            end)
        else
            if viewConnection then
                viewConnection:Disconnect()
                viewConnection = nil
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end
    end
})

-- زر للتنقل إلى اللاعب --
Tab4:AddButton({
    Name = "Teleport To Player",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(selectedPlayer.Character.HumanoidRootPart.Position)
        end
    end
})
local Section = Tab4:AddSection({"Show Character Player With Animation"})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local selectedPlayer = nil
local orbitEnabled = false
local orbitConnection = nil
local orbitRadius = 10
local orbitSpeed = 2

-- تحديث قائمة اللاعبين
local function GetPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

-- وظيفة الدوران
local function StartOrbit()
    if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("Head") then return end

    local angle = 0
    orbitConnection = RunService.RenderStepped:Connect(function(dt)
        if not orbitEnabled or not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("Head") then return end
        angle = angle + orbitSpeed * dt
        local targetPos = selectedPlayer.Character.Head.Position
        local offset = Vector3.new(math.cos(angle), 0.3, math.sin(angle)) * orbitRadius
        local cameraPos = targetPos + offset
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = CFrame.new(cameraPos, targetPos)
    end)
end

local function StopOrbit()
    if orbitConnection then
        orbitConnection:Disconnect()
        orbitConnection = nil
    end
    Camera.CameraType = Enum.CameraType.Custom
end

-- Dropdown لاختيار اللاعب
Tab4:AddDropdown({
    Name = "Select Player",
    Options = GetPlayerNames(),
    Default = "",
    Callback = function(selected)
        selectedPlayer = Players:FindFirstChild(selected)
        if orbitEnabled then
            StopOrbit()
            StartOrbit()
        end
    end
})

-- زر تفعيل الدوران
Tab4:AddToggle({
    Name = "Show Character",
    Default = false,
    Callback = function(state)
        orbitEnabled = state
        if state then
            StartOrbit()
        else
            StopOrbit()
        end
    end
})
local Section = Tab4:AddSection({"Walking through the walls"})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclipConnection
local noclipEnabled = false

Tab4:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state

        if noclipEnabled then
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            print("🚀 Noclip Enabled")
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end

            -- إعادة التفعيل للتصادم عند إيقاف Noclip
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            print("🛑 Noclip Disabled")
        end
    end
})
local Section = Tab4:AddSection({"Role Play Name (Boys)"})
Tab4:AddButton({
    Name = "Xeno",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "XENO", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Zoro",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "ZORO", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Mohamed",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "MOHAMED", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Ali",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "ALI", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Ahmed",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "AHMED", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Omar",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "OMAR", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Hacker",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "HACKER", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Admin",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "ADMIN", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Owner",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "OWNER", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "TUNG SAHUR",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "TUNG TUNG SAHUR", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Ran",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "RAN", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Jake",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "JAKE", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Jhon",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "JHON", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Mr Bean",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "MR BEAN", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Ghost",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "GHOST", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
local Section = Tab4:AddSection({"Role Play Name (Girls)"})
Tab4:AddButton({
    Name = "Lamees",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "LAMEES", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Lamar",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "LAMAR", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Maysam",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "MAYSAM", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Jana",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "JANA", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Mariam",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "MARIAM", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Maram",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "MARAM", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Remas",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "REMAS", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Sara",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "SARA", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Maria",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "MARIA", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Huda",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "HUDA", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Reham",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "REHAM", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Aiam",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "AIAM", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Toto",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "TOTO", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
Tab4:AddButton({
    Name = "Princess",
    Callback = function()
        local args1 = {
            [1] = "RolePlayName",
            [2] = "PRINCESS", -- اسم XENO الذي سيتم تفعيله
        }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1RPNam1eTex1t")
        if remote then
            remote:FireServer(unpack(args1))
        else
            warn("Remote '1RPNam1eTex1t' not found inside ReplicatedStorage.RE")
        end
    end
})
local Tab5 = Window:MakeTab({"Troll", "Glass"})
local Section = Tab5:AddSection({"Fun and Damn the players"})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local selectedPlayer = nil
local spectateConnection = nil

-- Dropdown: قائمة بأسماء اللاعبين في السيرفر
Tab5:AddDropdown({
    Name = "Select Player",
    Options = (function()
        local names = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(names, plr.Name)
            end
        end
        return names
    end)(),
    Default = nil,
    Callback = function(selected)
        selectedPlayer = selected
        print("Selected player:", selected)
    end
})

-- تحديث القائمة عند دخول/خروج اللاعبين
Players.PlayerAdded:Connect(function()
    Tab5["Elements"]["Select Player"].Dropdown:Refresh(
        (function()
            local names = {}
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    table.insert(names, plr.Name)
                end
            end
            return names
        end)(),
        true
    )
end)
Players.PlayerRemoving:Connect(function()
    Tab5["Elements"]["Select Player"].Dropdown:Refresh(
        (function()
            local names = {}
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    table.insert(names, plr.Name)
                end
            end
            return names
        end)(),
        true
    )
end)

-- Toggle: تفعيل مشاهدة اللاعب المحدد
Tab5:AddToggle({
    Name = "View Player",
    Default = false,
    Callback = function(isEnabled)
        if isEnabled then
            if selectedPlayer == nil then
                warn("الرجاء اختيار لاعب من القائمة أولاً")
                return
            end

            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                CurrentCamera.CameraSubject = targetPlayer.Character:FindFirstChild("Humanoid")
                print("Started spectating:", selectedPlayer)
            else
                warn("اللاعب غير موجود أو لا يملك شخصية")
            end
        else
            -- إرجاع الكاميرا للاعب المحلي
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
                print("Stopped spectating")
            end
        end
    end
})
local Section = Tab5:AddSection({"Troll And Kill Players"})
Tab5:AddButton({
    Name = "Jerk R15",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab5:AddButton({
    Name = "Get Sofa",
    Callback = function()
        local args = {"PickingTools", "Couch"}
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Sofa")
            else
                warn("❌ Error getting Sofa:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players         = game:GetService("Players")
local ReplicatedStore = game:GetService("ReplicatedStorage")
local RunService      = game:GetService("RunService")

local localPlayer     = Players.LocalPlayer
local selectedPlayer  = nil
local isBanging       = false
local bangTrack       = nil
local loopConn        = nil
local autoKillRunning = false

local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- انيميشن البانق
local function playBang()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://148840371"
    bangTrack = humanoid:LoadAnimation(anim)
    bangTrack.Looped = true
    bangTrack:Play()
end

local function stopBang()
    isBanging = false
    if bangTrack then bangTrack:Stop() end
end

-- Bang From Behind
local function smartBangBehind(args)
    local step = 0
    while isBanging and selectedPlayer do
        local target = Players:FindFirstChild(selectedPlayer)
        local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and hrp then
            local dist = (targetHRP.Position - hrp.Position).Magnitude
            local speed = dist > 10 and args.FastSpeed or args.SlowSpeed
            local behind = targetHRP.Position - targetHRP.CFrame.LookVector * args.Distance
            local offset = Vector3.new(0, math.sin(step) * 0.5, 0)
            local final = behind + offset

            local dir = (final - hrp.Position).Unit
            local newPos = hrp.Position + dir * speed * args.Delay
            newPos = Vector3.new(newPos.X, final.Y, newPos.Z)
            newPos = newPos:Lerp(final, 0.5)

            RunService.Heartbeat:Wait()
            localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(final, targetHRP.Position))
            step += args.Step
            wait(args.Delay)
        else
            break
        end
    end
    stopBang()
end

-- Bang Face
local function smartBangFace(args)
    local step = 0
    while isBanging and selectedPlayer do
        local target = Players:FindFirstChild(selectedPlayer)
        local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and hrp then
            local dist = (targetHRP.Position - hrp.Position).Magnitude
            local speed = dist > 10 and args.FastSpeed or args.SlowSpeed
            local inFront = targetHRP.Position + targetHRP.CFrame.LookVector * args.Distance
            local offset = Vector3.new(0, math.sin(step) * args.BobHeight, 0)
            local final = inFront + offset

            local dir = (final - hrp.Position).Unit
            local newPos = hrp.Position + dir * speed * args.Delay
            newPos = Vector3.new(newPos.X, final.Y, newPos.Z)
            newPos = newPos:Lerp(final, 0.5)

            RunService.Heartbeat:Wait()
            localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(final, targetHRP.Position))
            step += args.Step
            wait(args.Delay)
        else
            break
        end
    end
    stopBang()
end

-- تحديث أسماء اللاعبين
local function getOtherPlayerNames()
    local names = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= localPlayer then table.insert(names, pl.Name) end
    end
    return names
end

-- اختيار اللاعب من Dropdown
Tab5:AddDropdown({
    Name = "Select Player",
    Options = getOtherPlayerNames(),
    Default = nil,
    Callback = function(choice)
        selectedPlayer = choice
        print(">> Selected target:", choice)
    end
})

Players.PlayerAdded:Connect(function(pl)
    if pl ~= localPlayer then
        Tab5["Elements"]["Select Player"].Dropdown:Refresh(getOtherPlayerNames(), true)
    end
end)
Players.PlayerRemoving:Connect(function()
    Tab5["Elements"]["Select Player"].Dropdown:Refresh(getOtherPlayerNames(), true)
end)

-- Toggle: Bang Face
Tab5:AddToggle({
    Name = "Bang Face",
    Default = false,
    Callback = function(state)
        if not selectedPlayer then
            warn(">> اختر لاعبًا أولاً.")
            return
        end
        if state then
            isBanging = true
            playBang()
            local args = {
                Distance = 2.2,
                FastSpeed = 10,
                SlowSpeed = 2,
                Step = 0.2,
                Delay = 0.1,
                BobHeight = 0.2
            }
            task.spawn(function() smartBangFace(args) end)
        else
            stopBang()
        end
    end
})

-- Toggle: Bang From Behind
Tab5:AddToggle({
    Name = "Bang",
    Default = false,
    Callback = function(state)
        if not selectedPlayer then
            warn(">> اختر لاعبًا أولاً.")
            return
        end
        if state then
            isBanging = true
            playBang()
            local args = {
                Distance = 2.2,
                FastSpeed = 10,
                SlowSpeed = 2,
                Step = 0.2,
                Delay = 0.1
            }
            task.spawn(function() smartBangBehind(args) end)
        else
            stopBang()
        end
    end
})

-- زر قتل اللاعب + تفجير الحافلة
Tab5:AddToggle({
    Name = "Kill Player (Get Sofa)",
    Default = false,
    Callback = function(enabled)
        autoKillRunning = enabled

        if enabled then
            local spawnRemote = ReplicatedStore:FindFirstChild("SpawnRemote")
            if spawnRemote then
                spawnRemote:FireServer({ VehicleName = "School Bus" })
                print(">> Spawned School Bus")
            else
                warn("SpawnRemote not found")
            end

            loopConn = RunService.Heartbeat:Connect(function()
                if not autoKillRunning or not selectedPlayer then return end

                local target = Players:FindFirstChild(selectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                   and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then

                    local targetHRP = target.Character.HumanoidRootPart
                    local myHRP = localPlayer.Character.HumanoidRootPart
                    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)

                    for _, seat in pairs(workspace:GetDescendants()) do
                        if (seat:IsA("VehicleSeat") or seat:IsA("Seat"))
                           and seat.Occupant and seat.Occupant.Parent == target.Character then

                            local mdl = seat:FindFirstAncestorOfClass("Model")
                            if mdl then
                                for _, part in pairs(mdl:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CFrame = part.CFrame - Vector3.new(0, 500, 0)
                                        part.Velocity = Vector3.new(0, -100, 0)
                                        part.Anchored = false
                                    end
                                end
                                local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                                if humanoid then humanoid.Health = 0 end
                                print(">> Vehicle and player moved to void and killed.")
                                autoKillRunning = false
                            end
                            return
                        end
                    end
                end
            end)
        else
            if loopConn then
                loopConn:Disconnect()
                loopConn = nil
            end
            print(">> Auto Kill disabled.")
        end
    end
})
-- زر نسخ Display Name
Tab5:AddButton({
    Name = "Copy Player Name",
    Callback = function()
        if selectedPlayer then
            local player = Players:FindFirstChild(selectedPlayer)
            if player then
                setclipboard(player.DisplayName)
                print(">> Copied Display Name:", player.DisplayName)
            else
                warn(">> لا يمكن العثور على اللاعب.")
            end
        else
            warn(">> لم يتم اختيار لاعب.")
        end
    end
})
local Tab6 = Window:MakeTab({"Tools", "Tool"})
local Section = Tab6:AddSection({"Get All Tools You Want"})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Shopping Cart",
    Callback = function()
        local args = {"PickingTools", "ShoppingCart"} -- هذا هو الاسم الداخلي الصحيح للأداة
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Shopping Cart")
            else
                warn("❌ Error getting Shopping Cart:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Laptop",
    Callback = function()
        local args = {"PickingTools", "Laptop"}
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Laptop")
            else
                warn("❌ Error getting Laptop:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Sofa",
    Callback = function()
        local args = {"PickingTools", "Couch"}
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Sofa")
            else
                warn("❌ Error getting Sofa:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Crystal",
    Callback = function()
        local args = {"PickingTools", "Crystal"} -- اسم الأداة الداخلي
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Crystal")
            else
                warn("❌ Error getting Crystal:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get iPad",
    Callback = function()
        local args = {"PickingTools", "Ipad"} -- الاسم الداخلي في Brookhaven
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: iPad (Tablet)")
            else
                warn("❌ Error getting iPad:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Sign",
    Callback = function()
        local args = {"PickingTools", "Sign"}  -- تأكد من الاسم الداخلي الصحيح (بدلاً من "Sign" قد يكون "StreetSign")
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Sign")
            else
                warn("❌ Error getting Sign:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- RemoteFunction المسئول عن جلب الأدوات
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Shotgun",
    Callback = function()
        local args = {"PickingTools", "Shotgun"}  -- اسم Shotgun الداخلي في اللعبة
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Shotgun")
            else
                warn("❌ Error getting Shotgun:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Sniper",
    Callback = function()
        local args = {"PickingTools", "Sniper"}  -- اسم Sniper الداخلي في Brookhaven
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Sniper")
            else
                warn("❌ Error getting Sniper:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- الريموت المسؤول عن إعطاء الأدوات
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

-- زر لجلب Baby Bottle
Tab6:AddButton({
    Name = "Get Baby Bottle",
    Callback = function()
        local args = {"PickingTools", "BabyBottle"}
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Baby Bottle")
            else
                warn("❌ Error getting Baby Bottle:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- الريموت المسؤول عن إعطاء الأدوات
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

-- زر لجلب Milk
Tab6:AddButton({
    Name = "Get Milk",
    Callback = function()
        local args = {"PickingTools", "Milk"}
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Milk")
            else
                warn("❌ Error getting Milk:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- الريموت المسؤول عن إعطاء الأدوات
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

-- زر لجلب Hammer
Tab6:AddButton({
    Name = "Get Hammer",
    Callback = function()
        local args = {"PickingTools", "Hammer"}
        if pickToolRemote then
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received: Hammer")
            else
                warn("❌ Error getting Hammer:", err)
            end
        else
            warn("⚠️ RemoteFunction not found!")
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- تأكد من وجود RemoteFunction الصحيح
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Baby Monkey",
    Callback = function()
        -- جرب تغيّر الاسم بين هذه الاحتمالات حسب المشكلة
        local possibleNames = {"BabyMonkey", "Baby_Monkey", "BabyBaby", "MonkeyBaby"}
        for _, name in ipairs(possibleNames) do
            local args = {"PickingTools", name}
            local ok, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if ok then
                print("✅ Received Baby Monkey with name:", name)
                return
            end
        end
        warn("❌ Failed to get Baby Monkey. Tried: " .. table.concat(possibleNames, ", "))
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Swat Shield",
    Callback = function()
        local possibleNames = {"SWATShield", "SwatShield", "Shield", "RiotShield"}
        for _, name in ipairs(possibleNames) do
            local args = {"PickingTools", name}
            local success, err = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Received SWAT Shield with name:", name)
                return
            end
        end
        warn("❌ Failed to get SWAT Shield. Tried: " .. table.concat(possibleNames, ", "))
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Taser",
    Callback = function()
        local args = {"PickingTools", "Taser"}
        local success, err = pcall(function()
            pickToolRemote:InvokeServer(unpack(args))
        end)
        if success then
            print("✅ Taser received!")
        else
            warn("❌ Failed to get Taser:", err)
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Baby Boy",
    Callback = function()
        local args = {"PickingTools", "BabyBoy"}  -- الاسم الافتراضي المتوقع
        local success, err = pcall(function()
            pickToolRemote:InvokeServer(unpack(args))
        end)
        if success then
            print("✅ Baby Boy received!")
        else
            warn("❌ Error getting Baby Boy:", err)
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Baby Girl",
    Callback = function()
        -- أسماء محتملة للأداة
        local possibleNames = {"BabyGirl", "Baby_Girl", "GirlBaby", "BabyGirlTool"}
        for _, name in ipairs(possibleNames) do
            local args = {"PickingTools", name}
            local ok, _ = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if ok then
                print("✅ Received Baby Girl with name:", name)
                return
            end
        end
        warn("❌ Failed to get Baby Girl. Tried: " .. table.concat(possibleNames, ", "))
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Sleeping Bag",
    Callback = function()
        local args = {"PickingTools", "SleepingBag"}
        local success, err = pcall(function()
            pickToolRemote:InvokeServer(unpack(args))
        end)
        if success then
            print("✅ Received: Sleeping Bag")
        else
            warn("❌ Error:", err)
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Money",
    Callback = function()
        local args = {"PickingTools", "Money"}
        local success, err = pcall(function()
            pickToolRemote:InvokeServer(unpack(args))
        end)
        if success then
            print("✅ Received: Money")
        else
            warn("❌ Error:", err)
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pickToolRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")

Tab6:AddButton({
    Name = "Get Bomb",
    Callback = function()
        -- جرب أسماء محتملة للأداة
        local possibleNames = {"Bomb", "BombTool", "Explosive", "Grenade"}
        for _, name in ipairs(possibleNames) do
            local args = {"PickingTools", name}
            local ok, _ = pcall(function()
                pickToolRemote:InvokeServer(unpack(args))
            end)
            if ok then
                print("✅ Received Bomb with name:", name)
                return
            end
        end
        warn("❌ Failed to get Bomb. Tried:", table.concat(possibleNames, ", "))
    end
})
local Tab7 = Window:MakeTab({"Animations", "Play"})
local Section = Tab7:AddSection({"All You Want Animations Pick Your Favourite"})
Tab7:AddButton({
    Name = "Adidas Animation",
    Callback = function()
        -- Define the animation IDs for the Adidas Sports Animation Pack
        local animations = {
            idle = "rbxassetid://18537376492",    -- Primary idle animation
            idleAlt = "rbxassetid://18537371272", -- Alternate idle animation
            walk = "rbxassetid://18537392113",    -- Walk animation
            run = "rbxassetid://18537384940",     -- Run animation
            jump = "rbxassetid://18537380791",    -- Jump animation
            fall = "rbxassetid://18537367238",    -- Fall animation
            swim = "rbxassetid://18537389531",    -- Swim animation
            swimIdle = "rbxassetid://18537387180",-- Swim idle animation
            climb = "rbxassetid://18537378510"    -- Climb animation
        }

        -- Function to replace the default animations
        local function replaceAnimations()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            -- Wait for the Animate script to load
            local animateScript = character:WaitForChild("Animate")

            -- Replace each animation
            for animationType, animationId in pairs(animations) do
                if animateScript:FindFirstChild(animationType) then
                    for _, anim in ipairs(animateScript[animationType]:GetChildren()) do
                        if anim:IsA("Animation") then
                            anim.AnimationId = animationId
                        end
                    end
                end
            end

            -- Handle alternate idle animation separately
            local idle = animateScript:FindFirstChild("idle")
            if idle then
                local animAlt = idle:FindFirstChild("Animation2")
                if animAlt then
                    animAlt.AnimationId = animations.idleAlt
                end
            end
        end

        -- Function to ensure animations loop
        local function ensureAnimationsLoop()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            -- Wait for the Humanoid to load
            local humanoid = character:WaitForChild("Humanoid")

            -- Connect to the AnimationPlayed event
            humanoid.AnimationPlayed:Connect(function(animationTrack)
                animationTrack.Looped = true
            end)
        end

        -- Optional debug function for SwimIdle
        local function debugSwimIdle()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local animateScript = character:WaitForChild("Animate")
            local swimIdle = animateScript:FindFirstChild("swimIdle")

            if swimIdle then
                for _, anim in ipairs(swimIdle:GetChildren()) do
                    if anim:IsA("Animation") then
                        print("SwimIdle Animation ID:", anim.AnimationId)
                        anim.AnimationId = animations.swimIdle
                        print("Updated SwimIdle Animation ID:", anim.AnimationId)
                    end
                end
            else
                print("swimIdle animation not found in Animate script.")
            end
        end

        -- Run everything
        replaceAnimations()
        ensureAnimationsLoop()
        debugSwimIdle()

        print("✅ تم تفعيل Adidas Animation بنجاح.")
    end
})
Tab7:AddButton({
    Name = "Vampire Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        -- دالة لتفعيل الأنيميشنات
        local function applyVampireAnimation(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            -- إيقاف الأنيميشنات الحالية
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            -- تعيين معرفات أنيميشن Vampire
            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083445855"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083450166"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=1083473930"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=1083462077"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083455352"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=1083443587"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false
            print("✅ تم تطبيق Vampire Animation.")
        end

        -- تطبيق الأنيميشن فورًا الآن
        if plr.Character then
            applyVampireAnimation(plr.Character)
        end

        -- ربط الحدث عند الـ Respawn تلقائيًا
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5) -- انتظار خفيف لضمان تجهيز الشخصية
            applyVampireAnimation(char)
        end)

        print("🔁 تم تفعيل حفظ الأنيميشن بعد الموت.")
    end
})
Tab7:AddButton({
    Name = "Hero Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyHeroAnimation(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            -- إيقاف الأنيميشنات الحالية
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            -- تعيين معرفات أنيميشن Hero
            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616111295"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616113536"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616122287"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616117076"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616115533"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616104706"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616108001"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false

            print("✅ تم تطبيق Hero Animation.")
        end

        -- تفعيل الآن
        if plr.Character then
            applyHeroAnimation(plr.Character)
        end

        -- تفعيل تلقائي بعد الموت (Respawn)
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyHeroAnimation(char)
        end)

        print("🔁 تم تفعيل حفظ الأنيميشن بعد الموت.")
    end
})
Tab7:AddButton({
    Name = "Zombie Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyZombieClassicAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            -- إيقاف جميع الأنيميشنات الحالية
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            -- تعيين معرفات Zombie Classic
            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616158929"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616160636"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616161997"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616156119"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616157476"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false

            print("✅ تم تفعيل Zombie Classic Animation.")
        end

        -- تفعيل الآن
        if plr.Character then
            applyZombieClassicAnim(plr.Character)
        end

        -- تفعيل تلقائي بعد الموت (Respawn)
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyZombieClassicAnim(char)
        end)

        print("🔁 تم تفعيل حفظ Zombie Animation بعد الموت.")
    end
})
Tab7:AddButton({
    Name = "Mage Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyMageAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            -- إيقاف جميع الأنيميشنات الحالية
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            -- تعيين معرفات Mage Animation
            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=707742142"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=707855907"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=707897309"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=707861613"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=707853694"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=707826056"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=707829716"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false

            print("✅ تم تفعيل Mage Animation.")
        end

        -- تفعيل الآن
        if plr.Character then
            applyMageAnim(plr.Character)
        end

        -- تفعيل تلقائي بعد الموت (Respawn)
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyMageAnim(char)
        end)

        print("🔁 تم تفعيل حفظ Mage Animation بعد الموت.")
    end
})
Tab7:AddButton({
    Name = "Ghost Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyGhostAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            -- إيقاف كل الأنيمشنات الحالية
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            -- تعيين أنيميشن Ghost
            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false

            print("✅ تم تفعيل Ghost Animation.")
        end

        -- تفعيل الآن
        if plr.Character then
            applyGhostAnim(plr.Character)
        end

        -- تفعيل بعد الموت تلقائياً
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyGhostAnim(char)
        end)

        print("🔁 سيتم تفعيل Ghost Animation تلقائيًا بعد الموت.")
    end
})
Tab7:AddButton({
    Name = "Elder Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyElderAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=845397899"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=845400520"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=845403856"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=845386501"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=845398858"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=845392038"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=845396048"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false
        end

        if plr.Character then
            applyElderAnim(plr.Character)
        end

        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyElderAnim(char)
        end)
    end
})
Tab7:AddButton({
    Name = "Levitation Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyLevitationAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=616006778"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=616008087"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616013216"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616010382"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=616008936"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=616003713"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=616005863"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false
        end

        if plr.Character then
            applyLevitationAnim(plr.Character)
        end

        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyLevitationAnim(char)
        end)
    end
})
Tab7:AddButton({
    Name = "Toy Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyToyAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=782841498"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782845736"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=782843345"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=782842708"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=782847020"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=782843869"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=782846423"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false
        end

        if plr.Character then
            applyToyAnim(plr.Character)
        end

        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyToyAnim(char)
        end)
    end
})
Tab7:AddButton({
    Name = "Ninja Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyNinjaAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=656117400"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=656118341"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=656121766"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=656118852"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=656117878"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=656114359"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=656115606"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false
        end

        if plr.Character then
            applyNinjaAnim(plr.Character)
        end

        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyNinjaAnim(char)
        end)
    end
})
Tab7:AddButton({
    Name = "Cartoon Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyCartoonAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=742637544"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=742638445"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=742640026"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=742638842"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=742637942"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=742636889"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=742637151"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false
        end

        if plr.Character then
            applyCartoonAnim(plr.Character)
        end

        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyCartoonAnim(char)
        end)
    end
})
Tab7:AddButton({
    Name = "Pirate Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyPirateAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=750781874"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=750782770"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=750785693"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=750783738"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=750782230"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=750779899"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=750780242"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false
        end

        if plr.Character then
            applyPirateAnim(plr.Character)
        end

        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyPirateAnim(char)
        end)
    end
})
Tab7:AddButton({
    Name = "Knight Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer

        local function applyKnightAnim(char)
            local humanoid = char:WaitForChild("Humanoid")
            local animate = char:WaitForChild("Animate")

            animate.Disabled = true

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end

            animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=657595757"
            animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=657568135"
            animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=657552124"
            animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=657564596"
            animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=658409194"
            animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=658360781"
            animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=657600338"

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            animate.Disabled = false
        end

        if plr.Character then
            applyKnightAnim(plr.Character)
        end

        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            char:WaitForChild("Animate")
            task.wait(0.5)
            applyKnightAnim(char)
        end)
    end
})
Tab7:AddButton({
    Name = "Sneaky Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local character = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local animate = character:WaitForChild("Animate")

        -- إيقاف أي أنيميشن مخصص سابقًا
        local function StopAnim()
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end

        animate.Disabled = true
        StopAnim()

        -- تغيير الأنيميشنات للستايل السنيكي
        animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1132473842"
        animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1132477671"
        animate.walk.WalkAnim.AnimationId   = "http://www.roblox.com/asset/?id=1132510133"
        animate.run.RunAnim.AnimationId     = "http://www.roblox.com/asset/?id=1132494274"
        animate.jump.JumpAnim.AnimationId   = "http://www.roblox.com/asset/?id=1132489853"
        animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1132461372"
        animate.fall.FallAnim.AnimationId   = "http://www.roblox.com/asset/?id=1132469004"

        humanoid:ChangeState(Enum.HumanoidStateType.Running)
        animate.Disabled = false

        print(">> Sneaky animation enabled.")
    end
})
Tab7:AddButton({
    Name = "Werewolf Animation",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local character = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local animate = character:WaitForChild("Animate")

        -- إيقاف أي أنيميشنات شغالة
        local function StopAnim()
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end

        animate.Disabled = true
        StopAnim()

        -- تفعيل أنيميشن الذئب
        animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=1083195517"
        animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=1083214717"
        animate.walk.WalkAnim.AnimationId   = "http://www.roblox.com/asset/?id=1083178339"
        animate.run.RunAnim.AnimationId     = "http://www.roblox.com/asset/?id=1083216690"
        animate.jump.JumpAnim.AnimationId   = "http://www.roblox.com/asset/?id=1083218792"
        animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083182000"
        animate.fall.FallAnim.AnimationId   = "http://www.roblox.com/asset/?id=1083189019"

        humanoid:ChangeState(Enum.HumanoidStateType.Running)
        animate.Disabled = false

        print(">> Werewolf animation enabled.")
    end
})
local Tab8 = Window:MakeTab({"Teleport", "Home"})
local Section = Tab8:AddSection({"Teleport To Any Where You Want"})
Tab8:AddButton({
	Name = "Tp Tool",
	Callback = function(value)
mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Click To Tp By Xeno"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
end
})
local Section = Tab8:AddSection({"Teleport To The Houses"})
Tab8:AddButton({
Name = "House 1",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(262, 8, 134)
end
})

Tab8:AddButton({
Name = "House 2",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(242, 10, 149)
end
})

Tab8:AddButton({
Name = "House 3",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(220, 8, 180)
end
})

Tab8:AddButton({
Name = "House 4",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(197, 9, 191)
end
})

Tab8:AddButton({
Name = "House 5",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(172, 6, 221)
end
})

Tab8:AddButton({
Name = "House 6",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-43, 21, -137)
end
})

Tab8:AddButton({
Name = "House 7",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-40, 36, -137)
end
})

Tab8:AddButton({
Name = "House 11",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-21, 40, 436)
end
})

Tab8:AddButton({
Name = "House 12",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(155, 37, 433)
end
})

Tab8:AddButton({
Name = "House 13",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(255, 35, 431)
end
})

Tab8:AddButton({
Name = "House 14",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(254, 38, 394)
end
})

Tab8:AddButton({
Name = "House 15",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(148, 39, 387)
end
})

Tab8:AddButton({
Name = "House 16",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-17, 42, 395)
end
})

Tab8:AddButton({
Name = "House 17",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-189, 37, -247)
end
})

Tab8:AddButton({
Name = "House 18",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-354, 37, -244)
end
})

Tab8:AddButton({
Name = "House 19",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-456, 36, -245)
end
})

Tab8:AddButton({
Name = "House 20",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-453, 38, -295)
end
})

Tab8:AddButton({
Name = "House 21",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-356, 38, -294)
end
})

Tab8:AddButton({
Name = "House 22",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-187, 37, -295)
end
})

Tab8:AddButton({
Name = "House 23",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-410, 68, -447)
end
})

Tab8:AddButton({
Name = "House 24",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-348, 69, -496)
end
})

Tab8:AddButton({
Name = "House 28",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-103, 12, 1087)
end
})

Tab8:AddButton({
Name = "House 29",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-730, 6, 808)
end
})

Tab8:AddButton({
Name = "House 30",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-245, 7, 822)
end
})

Tab8:AddButton({
Name = "House 31",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(639, 76, -361)
end
})

Tab8:AddButton({
Name = "House 32",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-908, 6, -361)
end
})

Tab8:AddButton({
Name = "House 33",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-111, 70, -417)
end
})

Tab8:AddButton({
Name = "House 34",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(230, 38, 569)
end
})

Tab8:AddButton({
Name = "House 35",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-30, 13, 2209)
end
})

Tab8:AddButton({
Name = "House 36",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(248, 17, -2324)
end
})

Tab8:AddButton({
Name = "House 37",
Callback = function()
local player = game.Players.LocalPlayer
player.Character.HumanoidRootPart.CFrame = CFrame.new(-1946, 38, 327)
end
})
local Tab9 = Window:MakeTab({"Server", "Server"})
local Section = Tab9:AddSection({"Rejoin the server itself"})
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Tab9:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        local PlaceId = game.PlaceId
        local JobId = game.JobId

        -- إعادة إرسال اللاعب لنفس السيرفر عبر TeleportToPlaceInstance
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
    end
})
local Section = Tab9:AddSection({"Player Time On The Server"})
-- إضافة Paragraph
local playTimeParagraph = Tab9:AddParagraph({
    Title = "00:00:00",
    Text = "Your Time On The Server"
})

-- بدء التوقيت
local seconds = 0

-- تحديث العداد كل ثانية
task.spawn(function()
    while true do
        task.wait(1)
        seconds += 1

        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60

        local timeFormatted = string.format("%02d:%02d:%02d", hours, minutes, secs)
        playTimeParagraph:SetTitle(timeFormatted)
    end
end)
local Section = Tab9:AddSection({"When was the server created?"})
-- Paragraph للوقت
local serverTimeParagraph = Tab9:AddParagraph({
    Title = "00:00:00",
    Text = "Server Time Create"
})

-- تحديث كل ثانية لعرض الوقت الذي مضى منذ إنشاء السيرفر
task.spawn(function()
    while true do
        task.wait(0.5)
        local seconds = math.floor(workspace.DistributedGameTime)

        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60

        local formatted = string.format("%02d:%02d:%02d", hours, minutes, secs)
        serverTimeParagraph:SetTitle(formatted)
    end
end)
local Players = game:GetService("Players")

local notifyConnectionAdd
local notifyConnectionRemove

-- الدالة التي ترسل إشعار لكل اللاعبين
local function SendNotificationToAllPlayers(title, text, duration)
	for _, player in ipairs(Players:GetPlayers()) do
		pcall(function()
			player:WaitForChild("PlayerGui"):SetCore("SendNotification", {
				Title = title,
				Text = text,
				Duration = duration or 5
			})
		end)
	end
end

-- التوغل داخل التاب Tab9
Tab9:AddToggle({
	Name = "Exit & Entry Player",
	Default = false,
	Callback = function(enabled)
		if enabled then
			-- تفعيل الميزة
			notifyConnectionAdd = Players.PlayerAdded:Connect(function(player)
				task.wait(1)
				SendNotificationToAllPlayers("Player income", player.Name .. "Log in to the server", 5)
			end)

			notifyConnectionRemove = Players.PlayerRemoving:Connect(function(player)
				SendNotificationToAllPlayers("Exit player", player.Name .. "Leave the server", 5)
			end)

		else
			-- إيقاف الميزة
			if notifyConnectionAdd then
				notifyConnectionAdd:Disconnect()
			end
			if notifyConnectionRemove then
				notifyConnectionRemove:Disconnect()
			end
		end
	end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- إنشاء RemoteEvent في ReplicatedStorage إذا لم يكن موجودًا
local lagEvent = ReplicatedStorage:FindFirstChild("LagEvent")
if not lagEvent then
    lagEvent = Instance.new("RemoteEvent")
    lagEvent.Name = "LagEvent"
    lagEvent.Parent = ReplicatedStorage
end

-- استقبال اللاغ عند الجميع
lagEvent.OnServerEvent:Connect(function(player)
    for i = 1, 700 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(10,10,10)
        part.Anchored = true
        part.Position = Vector3.new(math.random(-9999,9999), math.random(1,1000), math.random(-9999,9999))
        part.Parent = workspace
        game.Debris:AddItem(part, 5) -- تنظيف تلقائي بعد 5 ثوانٍ
    end
end)

-- زر اللاغ داخل تبويب Tab9
Tab9:AddButton({
    Name = "Lag Server",
    Callback = function()
        -- جمع كل اللاعبين
        local args = {}
        for _, plr in pairs(Players:GetPlayers()) do
            table.insert(args, plr)
        end

        -- إرسال لاغ لكل اللاعبين باستخدام unpack
        for _, plr in pairs(unpack({args})) do
            if plr:IsDescendantOf(Players) then
                -- Trigger LagEvent من client إلى server
                lagEvent:FireServer()
            end
        end

        print("✅ تم إرسال لاغ إلى جميع اللاعبين")
    end
})
local Tab10 = Window:MakeTab({"Fun", "Game"})
local Section = Tab10:AddSection({"Jump Player Character"})
-- تخزين السلايدر لتعديل القيم لاحقًا
local jumpSlider
local speedSlider

-- ✅ سلايدر قوة القفز
jumpSlider = Tab10:AddSlider({
    Title = "Jump Power",
    Min = 10,
    Max = 1500,
    Default = 50,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})
local Section = Tab10:AddSection({"Speed Player Character"})
-- ✅ سلايدر السرعة
speedSlider = Tab10:AddSlider({
    Title = "Speed Power",
    Min = 10,
    Max = 1500,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
local Section = Tab10:AddSection({"Equip All Tools In Your Inventory"})
Tab10:AddButton({
 Name = "Equip all tools",
 Callback = function()
LP = game.Players.LocalPlayer
for _, tool in ipairs(LP.Backpack:GetDescendants()) do
  if tool:IsA("Tool") then
tool.Parent = LP.Character
  end
end
   end    
})
local Section = Tab10:AddSection({"Remove All Tools In Your Inventory"})
Tab10:AddButton({
	Name = "Remove tools",
	Callback = function()
	if table.merger == nil then
      loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/BHU/refs/heads/main/Table%20library%20expanding"))()
    end
for _, tool in next, table.merger(game.Players.LocalPlayer.Character:GetDescendants(), game.Players.LocalPlayer.Backpack:GetDescendants()) do
  if tool:IsA("Tool") then
    tool:Destroy()
  end
end
    end    
})
local Section = Tab10:AddSection({"Transparent View From Behind Walls"})
Tab10:AddToggle({
 Name = "Xray",
 Default = false,
 Callback = function(Value)
xrayen = Value
for _, part in ipairs(workspace:GetDescendants()) do
  if part:IsA("BasePart") and not part.Parent:FindFirstChildOfClass("Humanoid") and part.Parent ~= game.Players.LocalPlayer.Character then
 part.LocalTransparencyModifier = xrayen and 0.6 or 0
  end
end
 end
})
local Section = Tab10:AddSection({"Invisible All Character"})
Tab10:AddToggle({
    Name = "Invisible Player",
    Default = false,
    Callback = function(v)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local args = {character:GetDescendants()}

        if v then
            -- إخفاء كل أجزاء الشخصية
            for _, part in ipairs(unpack(args)) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 1
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                elseif part:IsA("Accessory") then
                    local handle = part:FindFirstChild("Handle")
                    if handle then
                        handle.Transparency = 1
                        handle.CanCollide = false
                    end
                end
            end
        else
            -- إرجاع الشخصية إلى الوضع الطبيعي
            for _, part in ipairs(unpack(args)) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 0
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                elseif part:IsA("Accessory") then
                    local handle = part:FindFirstChild("Handle")
                    if handle then
                        handle.Transparency = 0
                        handle.CanCollide = true
                    end
                end
            end
        end
    end
})
local Section = Tab10:AddSection({"Rainbow All Character"})
Tab10:AddToggle({
    Name = "Rainbow Character",
    Default = false,
    Callback = function(v)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local args = {character:GetDescendants()}
        local RunService = game:GetService("RunService")
        local rainbowConnection = player:FindFirstChild("RainbowConnection")

        if v then
            -- حفظ الألوان الأصلية
            if not player:FindFirstChild("OriginalColors") then
                local folder = Instance.new("Folder", player)
                folder.Name = "OriginalColors"
                for _, part in ipairs(unpack(args)) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        local color = Instance.new("Color3Value")
                        color.Name = part:GetFullName()
                        color.Value = part.Color
                        color.Parent = folder
                    end
                end
            end

            -- بدء تأثير قوس قزح
            if rainbowConnection then
                rainbowConnection:Destroy()
            end

            local bind = Instance.new("BindableEvent", player)
            bind.Name = "RainbowConnection"

            task.spawn(function()
                while player:FindFirstChild("RainbowConnection") do
                    local hue = tick() % 5 / 5
                    for _, part in ipairs(unpack(args)) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Color = Color3.fromHSV(hue, 1, 1)
                        end
                    end
                    task.wait(0.1)
                end
            end)

        else
            -- استرجاع الألوان الأصلية
            if rainbowConnection then
                rainbowConnection:Destroy()
            end

            local colorFolder = player:FindFirstChild("OriginalColors")
            if colorFolder then
                for _, colorVal in ipairs(colorFolder:GetChildren()) do
                    local part = game
                    for _, segment in ipairs(string.split(colorVal.Name, ".")) do
                        part = part:FindFirstChild(segment)
                        if not part then break end
                    end
                    if part and part:IsA("BasePart") then
                        part.Color = colorVal.Value
                    end
                end
                colorFolder:Destroy()
            end
        end
    end
})
local Section = Tab10:AddSection({"If Player Sit In Anything Then He Go To Void"})
local hiddenfling = false
Tab10:AddToggle({
    Name = "Touch Fling",
    Default = false,
    Callback = function(value)
 hiddenfling = value
            local hrp, c, vel, movel = nil, nil, nil, 0.1
            local player = game.Players.LocalPlayer

            while player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and hiddenfling == true do
                game:GetService("RunService").Heartbeat:Wait()

                local lp = player
                while hiddenfling == true and not (c and c.Parent and hrp and hrp.Parent) do
                    game:GetService("RunService").Heartbeat:Wait()
                    c = lp.Character
                    hrp = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
                end

                if hiddenfling == true then
                    vel = hrp.Velocity
                    hrp.Velocity = vel * 10000 + Vector3.new(0, 100000, 0)
                    game:GetService("RunService").RenderStepped:Wait()

                    if c and c.Parent and hrp and hrp.Parent then
                        hrp.Velocity = vel
                    end

                    game:GetService("RunService").Stepped:Wait()

                    if c and c.Parent and hrp and hrp.Parent then
                        hrp.Velocity = vel + Vector3.new(0, movel, 0)
                        movel = movel * -1
                    end
                end
            end
end
})
Tab10:AddButton({
    Name = "Fly",
    Callback = function()
       local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Initial color (will be animated)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

-- Rainbow color animation for the frame
spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.01) % 1
        Frame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        wait(0.1)
    end
end)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
up.BorderColor3 = Color3.fromRGB(255, 255, 255)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(255, 255, 255)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
down.BorderColor3 = Color3.fromRGB(255, 255, 255)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(255, 255, 255)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
onof.BorderColor3 = Color3.fromRGB(255, 255, 255)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(255, 255, 255)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "XENO9995 FLY SCRIPT"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
plus.BorderColor3 = Color3.fromRGB(255, 255, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255, 255, 255)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speed.BorderColor3 = Color3.fromRGB(255, 255, 255)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(255, 255, 255)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mine.BorderColor3 = Color3.fromRGB(255, 255, 255)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(255, 255, 255)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closebutton.BorderColor3 = Color3.fromRGB(255, 255, 255)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextColor3 = Color3.fromRGB(255, 0, 0)
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mini.BorderColor3 = Color3.fromRGB(255, 255, 255)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mini2.BorderColor3 = Color3.fromRGB(255, 255, 255)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextColor3 = Color3.fromRGB(255, 255, 255)
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "XENO FLY SCRIPT";
    Text = "BY XNEO HUB";
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;

Frame.Active = true -- main = gui
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

    if nowe == true then
        nowe = false

        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    else 
        nowe = true

        for i = 1, speeds do
            spawn(function()

                local hb = game:GetService("RunService").Heartbeat    

                tpwalking = true
                local chr = game.Players.LocalPlayer.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end

            end)
        end
        game.Players.LocalPlayer.Character.Animate.Disabled = true
        local Char = game.Players.LocalPlayer.Character
        local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

        for i,v in next, Hum:GetPlayingAnimationTracks() do
            v:AdjustSpeed(0)
        end
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    end

    if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
        local plr = game.Players.LocalPlayer
        local torso = plr.Character.Torso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 0

        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame
        local bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
            game:GetService("RunService").RenderStepped:Wait()

            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed+.5+(speed/maxspeed)
                if speed > maxspeed then
                    speed = maxspeed
                end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                speed = speed-1
                if speed < 0 then
                    speed = 0
                end
            end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
            else
                bv.velocity = Vector3.new(0,0,0)
            end
            bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
        end
        ctrl = {f = 0, b = 0, l = 0, r = 0}
        lastctrl = {f = 0, b = 0, l = 0, r = 0}
        speed = 0
        bg:Destroy()
        bv:Destroy()
        plr.Character.Humanoid.PlatformStand = false
        game.Players.LocalPlayer.Character.Animate.Disabled = false
        tpwalking = false
    else
        local plr = game.Players.LocalPlayer
        local UpperTorso = plr.Character.UpperTorso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 0

        local bg = Instance.new("BodyGyro", UpperTorso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = UpperTorso.CFrame
        local bv = Instance.new("BodyVelocity", UpperTorso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
            wait()

            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed+.5+(speed/maxspeed)
                if speed > maxspeed then
                    speed = maxspeed
                end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                speed = speed-1
                if speed < 0 then
                    speed = 0
                end
            end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
            else
                bv.velocity = Vector3.new(0,0,0)
            end

            bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
        end
        ctrl = {f = 0, b = 0, l = 0, r = 0}
        lastctrl = {f = 0, b = 0, l = 0, r = 0}
        speed = 0
        bg:Destroy()
        bv:Destroy()
        plr.Character.Humanoid.PlatformStand = false
        game.Players.LocalPlayer.Character.Animate.Disabled = false
        tpwalking = false
    end
end)

local tis

up.MouseButton1Down:connect(function()
    tis = up.MouseEnter:connect(function()
        while tis do
            wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
        end
    end)
end)

up.MouseLeave:connect(function()
    if tis then
        tis:Disconnect()
        tis = nil
    end
end)

local dis

down.MouseButton1Down:connect(function()
    dis = down.MouseEnter:connect(function()
        while dis do
            wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
        end
    end)
end)

down.MouseLeave:connect(function()
    if dis then
        dis:Disconnect()
        dis = nil
    end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    game.Players.LocalPlayer.Character.Animate.Disabled = false
end)

plus.MouseButton1Down:connect(function()
    speeds = speeds + 1
    speed.Text = speeds
    if nowe == true then
        tpwalking = false
        for i = 1, speeds do
            spawn(function()
                local hb = game:GetService("RunService").Heartbeat    
                tpwalking = true
                local chr = game.Players.LocalPlayer.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end
    end
end)

mine.MouseButton1Down:connect(function()
    if speeds == 1 then
        speed.Text = 'cannot be less than 1'
        wait(1)
        speed.Text = speeds
    else
        speeds = speeds - 1
        speed.Text = speeds
        if nowe == true then
            tpwalking = false
            for i = 1, speeds do
                spawn(function()
                    local hb = game:GetService("RunService").Heartbeat    
                    tpwalking = true
                    local chr = game.Players.LocalPlayer.Character
                    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
        end
    end
end)

closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    up.Visible = false
    down.Visible = false
    onof.Visible = false
    plus.Visible = false
    speed.Visible = false
    mine.Visible = false
    mini.Visible = false
    mini2.Visible = true
    main.Frame.BackgroundTransparency = 1
    closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
    up.Visible = true
    down.Visible = true
    onof.Visible = true
    plus.Visible = true
    speed.Visible = true
    mine.Visible = true
    mini.Visible = true
    mini2.Visible = false
    main.Frame.BackgroundTransparency = 0 
    closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)
    end
})
local Tab11 = Window:MakeTab({"Avatar", "Users"})
local Section = Tab11:AddSection({"Required Heads"})
-- جدول يجمع أسماء الرؤوس مع الـ ID الخاص بها
local skins = {
    ["Headless Head"] = 134082579,
    ["Korblox Blue Eye"] = 16580493236,
    ["Blaze Burner Head"] = 3210773801,
}

-- متغير لتخزين الخيار المحدد من الـ Dropdown
local selectedSkinName = nil

-- Dropdown للاختيار من بين الرؤوس
Tab11:AddDropdown({
    Name = "Select Skin",
    Options = {"Headless Head", "Korblox Blue Eye", "Blaze Burner Head"},
    Callback = function(value)
        selectedSkinName = value
    end
})

-- زر لتفعيل الرأس المختار
Tab11:AddButton({
    Name = "Change Skin",
    Callback = function()
        if selectedSkinName and skins[selectedSkinName] then
            local args = {
                [1] = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                    [4] = 0,
                    [5] = 0,
                    [6] = skins[selectedSkinName]
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(args))
        else
            warn("Please select a skin first.")
        end
    end
})
local Section = Tab11:AddSection({"Classic Heads"})
-- قائمة الرؤوس مع الـ IDs الخاصة بها
local heads = {
    ["Cheeks Head"] = 746767604,
    ["Narrow Head"] = 16580493236,
    ["Paragon Head"] = 616398268,
    ["Strong Jaw Head"] = 616399508,
    ["Chiseled Head"] = 616387160,
}

local selectedHead = nil -- لتخزين الرأس المختار من Dropdown

-- إضافة Dropdown مع أسماء الرؤوس
Tab11:AddDropdown({
    Name = "Select Head",
    Options = (function()
        local list = {}
        for headName, _ in pairs(heads) do
            table.insert(list, headName)
        end
        return list
    end)(),
    Default = "nil",
    Callback = function(choice)
        selectedHead = choice
    end,
})

-- تعيين القيمة الافتراضية للرأس المختار
selectedHead = ""

-- زر لتغيير الرأس بناءً على الاختيار في Dropdown
Tab11:AddButton({
    Name = "Change Head",
    Callback = function()
        if selectedHead and heads[selectedHead] then
            local args = {
                [1] = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                    [4] = 0,
                    [5] = 0,
                    [6] = heads[selectedHead]
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(args))
        else
            warn("Please select a valid head from the dropdown!")
        end
    end
})
local Section = Tab11:AddSection({"Girl Characters"})
local Characters = {
    ["SuperLazuu Tall Body"] = {
        14874108946, 122027795919157, 80393546275035, 14917855371, 14917855725, 0
    },
    ["Lazuu Type Body"] = {
        75159926897589, 76683091425509, 14567282030, 14567281990, 14874108946, 0
    },
    ["Plushy Chibi Woman"] = {
        84519338962111, 104625992479605, 89231963593670, 101500262169377, 130044271500910, 0
    },
    ["Lazuu Chibi Girl Bubbly"] = {
        17759625390, 17759625333, 17759625415, 17759626537, 17759626879, 0
    },
    ["Lazuu Manga Doll"] = {
        97119075795691, 72699005696177, 122027795919157, 80393546275035, 125637672664513, 0
    },
    ["Chibi Doll Girl (black)"] = {
        14775830263, 14775830261, 14775830259, 14775830269, 14775830264, 0
    },
    ["Chibi Doll Girl (White)"] = {
        14785351665, 14775830261, 14775830259, 14775830269, 14775830264, 0
    }
}

local selectedCharacter = nil

Tab11:AddDropdown({
    Name = "Select Character",
    Options = {"SuperLazuu Tall Body", "Lazuu Type Body", "Plushy Chibi Woman", "Lazuu Chibi Girl Bubbly", "Lazuu Manga Doll", "Chibi Doll Girl (black)", "Chibi Doll Girl (White)"},
    Callback = function(selected)
        selectedCharacter = selected
    end
})

Tab11:AddButton({
    Name = "Change Character",
    Callback = function()
        if selectedCharacter and Characters[selectedCharacter] then
            local args = {
                [1] = Characters[selectedCharacter]
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(args))
        else
            warn("Please select a body from the dropdown first.")
        end
    end
})
local Section = Tab11:AddSection({"Boys & Girls Characters"})
local characters = {
    ["Mini Plushie (black)"] = {
        [1] = {
            [1] = 14579958702,
            [2] = 14583777042,
            [3] = 14583777007,
            [4] = 14579959249,
            [5] = 14579963667,
            [6] = 0
        }
    },
    ["Mini Plushie (white)"] = {
        [1] = {
            [1] = 14583777041,
            [2] = 14583776823,
            [3] = 14583776741,
            [4] = 14583776823,
            [5] = 14583776741,
            [6] = 0
        }
    }
}

local selectedCharacter = nil

-- Dropdown لاختيار الشكل
Tab11:AddDropdown({
    Name = "Select Character",
    Options = {"Mini Plushie (black)", "Mini Plushie (white)"},
    Callback = function(selected)
        selectedCharacter = selected
    end
})

-- زر التفعيل
Tab11:AddButton({
    Name = "Change Character",
    Callback = function()
        if selectedCharacter and characters[selectedCharacter] then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(characters[selectedCharacter]))
        else
            warn("Please select a character first.")
        end
    end
})
local Section = Tab11:AddSection({"Boy Bodies"})
local selectedBody = nil

local bodyOptions = {
    ["Inf15 Body"] = {
        [1] = {
            [1] = 82491774691726,
            [2] = 99519402284266,
            [3] = 115905570886697,
            [4] = 84418052877367,
            [5] = 124343282827669,
            [6] = 0
        }
    },
    ["R6 Body"] = {
        [1] = {
            [1] = 106411216404626,
            [2] = 87202958751790,
            [3] = 81500432784353,
            [4] = 103452055306587,
            [5] = 129699548221468,
            [6] = 0
        }
    }
}

Tab11:AddDropdown({
    Name = "Select Body",
    Options = {"Inf15 Body", "R6 Body"},
    Callback = function(value)
        selectedBody = value
    end
})

Tab11:AddButton({
    Name = "Change Body",
    Callback = function()
        if selectedBody and bodyOptions[selectedBody] then
            local args = bodyOptions[selectedBody]
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(args))
        else
            warn("No body selected!")
        end
    end
})
local Section = Tab11:AddSection({"Boy Avatar"})
local selectedAvatar = nil

local avatarOptions = {
    ["Mini Man (white)"] = {
        [1] = {
            [1] = 122602157507621,
            [2] = 117079685799715,
            [3] = 81502860408959,
            [4] = 89658787394734,
            [5] = 108834379337347,
            [6] = 0
        }
    },
    ["Mini Man (grey)"] = {
        [1] = {
            [1] = 93074839269016,
            [2] = 117079685799715,
            [3] = 81502860408959,
            [4] = 89658787394734,
            [5] = 108834379337347,
            [6] = 0
        }
    },
    ["Chad King"] = {
        [1] = {
            [1] = 121532625082697,
            [2] = 119216187383922,
            [3] = 121634444400488,
            [4] = 100229264383618,
            [5] = 126161096503611,
            [6] = 0
        }
    }
}

-- إنشاء Dropdown لاختيار الشخصية
Tab11:AddDropdown({
    Name = "Select Avatar",
    Options = {"Mini Man (white)", "Mini Man (grey)", "Chad King"},
    Callback = function(value)
        selectedAvatar = value
    end
})

-- زر لتغيير الشخصية بناءً على الاختيار
Tab11:AddButton({
    Name = "Change Avatar",
    Callback = function()
        if selectedAvatar and avatarOptions[selectedAvatar] then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(avatarOptions[selectedAvatar]))
        else
            warn("Please select an avatar first.")
        end
    end
})
local Tab12 = Window:MakeTab({"Settings", "settings"})
local Section = Tab12:AddSection({"Equip Protections To protect against players"})
Tab12:AddToggle({
 Name = "Anti bang",
 Default = false,
 Callback = function(Value)
  kiudi = Value
     while kiudi and task.wait() do
       for _, player in next, game.Players:GetPlayers() do
         if player ~= game.Players.LocalPlayer and game.Workspace:FindFirstChild(player.Name) and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 10 then
           for _, anim in next, player.Character.Humanoid:GetPlayingAnimationTracks() do
              if anim.Animation.AnimationId == "rbxassetid://148840371" or anim.Animation.AnimationId == "rbxassetid://5918726674" then
    game:GetService("RunService").Heartbeat:Wait()
    last_pick_sin_mrazy = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9e8, workspace.FallenPartsDestroyHeight + 1, 9e8) 
    game:GetService("RunService").Heartbeat:Wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = last_pick_sin_mrazy
              end
           end
         end
       end
     end
   end    
})
Tab12:AddToggle({
 Name = "Anti Fling",
 Default = false,
 Callback = function(Value)
jhg = Value
     while jhg and task.wait() do
       for _, plr in next, game:GetService("Players"):GetPlayers() do
         if plr ~= game:GetService("Players").LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
for _, part in next, plr.Character:GetChildren() do
  if part:IsA("BasePart") then
 part.CanCollide = not jhg
 part.CanTouch = not jhg
 part.AssemblyLinearVelocity = Vector3.zero
 part.AssemblyAngularVelocity = Vector3.zero
 part.Velocity = Vector3.zero
 part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
  end
end
         end
       end
     end
   end    
})
Tab12:AddToggle({
 Name = "Anti Void",
 Default = false,
 Callback = function(Value)
      local function getrespawn(): Instance
  for _, part in next, workspace:GetDescendants() do
    if part:IsA("SpawnLocation") then
      return part
   end
  end
end

local thnei = Value
local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

while thnei and task.wait() do
char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
  if char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.CFrame.Y <= workspace.FallenPartsDestroyHeight + 10 then
    if getrespawn() then
 char.HumanoidRootPart.CFrame = getrespawn().CFrame
 char.HumanoidRootPart.Velocity = Vector3.zero
     else
 char.HumanoidRootPart.CFrame = CFrame.new(0, 0, 0)
 char.HumanoidRootPart.Velocity = Vector3.zero
    end
  end
end
   end    
})
Tab12:AddToggle({
 Name = "Anti sit",
 Default = false,
 Callback = function(Value)
         game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled("Seated", not Value)
   end    
})
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local antiAfkConnection = nil
local heartbeatConnection = nil
local afkRemote = ReplicatedStorage:FindFirstChild("AFKRemote") -- غيّر الاسم إن وُجد
local afkFunction = ReplicatedStorage:FindFirstChild("AFKFunction") -- غيّر الاسم إن وُجد

Tab12:AddToggle({
    Name = "Anti Afk",
    Default = false,
    Callback = function(enabled)
        if enabled then
            -- VirtualUser لمنع الخروج بسبب عدم النشاط
            antiAfkConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                print(">> Sent VirtualUser to prevent AFK")
            end)

            -- Heartbeat loop لإرسال إشارات للـ RemoteEvent/Function
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                -- Fire RemoteEvent إن وجد
                if afkRemote and afkRemote:IsA("RemoteEvent") then
                    pcall(function()
                        afkRemote:FireServer("anti_afk_ping")
                        print(">> Fired RemoteEvent")
                    end)
                end

                -- Invoke RemoteFunction إن وجد
                if afkFunction and afkFunction:IsA("RemoteFunction") then
                    pcall(function()
                        afkFunction:InvokeServer("anti_afk_check")
                        print(">> Invoked RemoteFunction")
                    end)
                end
            end)

            print("✅ ANTI-AFK Enabled.")
        else
            -- تنظيف الاتصالات عند التعطيل
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end

            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            print("❌ ANTI-AFK Disabled.")
        end
    end
})
local Section = Tab12:AddSection({"More Coming Soon..."})
