--// TPS FUTEBOL DE RUA SCRIPT + WHITELIST
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Pega whitelist do Pastebin
local success, data = pcall(function()
    return game:HttpGet("https://pastebin.com/raw/hAZFndq7")
end)

if not success or not data then
    LocalPlayer:Kick("Erro ao carregar whitelist!")
    return
end

local whitelist = {}
pcall(function()
    whitelist = HttpService:JSONDecode(data)
end)

-- Função para verificar
local function IsWhitelisted(player)
    for _, v in ipairs(whitelist) do
        if v == player.Name or v == player.UserId then
            return true
        end
    end
    return false
end

-- Checagem
if not IsWhitelisted(LocalPlayer) then
    LocalPlayer:Kick("SparkkGM: not whitelisted!")
    return -- PARA o script aqui
end

--// SE PASSAR DAQUI, ESTÁ NA WHITELIST //--

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = LocalPlayer
local reach = 5
local ball = Workspace:WaitForChild("TPSSystem"):WaitForChild("TPS")
local legParts = {}

-- Detecta pernas
local function refreshLegs()
    legParts = {}
    local char = player.Character
    if not char then return end

    if char:FindFirstChild("LeftUpperLeg") then -- R15
        local names = {"LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}
        for _, name in ipairs(names) do
            local part = char:FindFirstChild(name)
            if part then table.insert(legParts, part) end
        end
    elseif char:FindFirstChild("Left Leg") then -- R6
        local names = {"Left Leg","Right Leg"}
        for _, name in ipairs(names) do
            local part = char:FindFirstChild(name)
            if part then table.insert(legParts, part) end
        end
    end
end

-- Tocar bola
local function touchBall()
    if #legParts == 0 then refreshLegs() end
    if #legParts == 0 then return end

    for _, leg in ipairs(legParts) do
        local distance = (leg.Position - ball.Position).Magnitude
        if distance <= reach then
            pcall(function()
                local ti = leg:FindFirstChildWhichIsA("TouchTransmitter", true)
                if ti then
                    firetouchinterest(ball, ti.Parent, 0)
                    firetouchinterest(ball, ti.Parent, 1)
                end
            end)
        end
    end
end

-- Cria GUI estilizada em roxo com seu nome
local function createGUI()
    if gui then gui:Destroy() end -- Remove antiga se existir
    gui = Instance.new("ScreenGui")
    gui.Name = "TPSS"
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(0.22, 0.12) -- aumentei altura para caber o nome
    frame.Position = UDim2.fromScale(0.05, 0.05)
    frame.BackgroundTransparency = 0
    frame.BackgroundColor3 = Color3.fromRGB(35,25,55) -- roxo escuro suave
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0,0)
    frame.Parent = gui

    -- Sombra da frame
    local shadow = Instance.new("UIStroke")
    shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    shadow.Color = Color3.fromRGB(60,40,80)
    shadow.Thickness = 2
    shadow.Parent = frame

    -- Nome do jogador no topo
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.25,0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.Text = "SparkkGM"
    nameLabel.TextScaled = true
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(230,230,255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame

    -- Label do Reach
    label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0.25,0)
    label.Position = UDim2.new(0,0,0.25,0)
    label.Text = "Reach: "..reach
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230,230,255)
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame

    local function makeButton(text, pos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.4,0,0.25,0)
        btn.Position = pos
        btn.Text = text
        btn.TextScaled = true
        btn.BackgroundColor3 = Color3.fromRGB(120,80,180) -- roxo médio
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Parent = frame

        -- Gradiente suave
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(140,100,200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100,60,160))
        })
        grad.Rotation = 45
        grad.Parent = btn

        -- Sombra do botão
        local btnShadow = Instance.new("UIStroke")
        btnShadow.Color = Color3.fromRGB(60,40,80)
        btnShadow.Thickness = 2
        btnShadow.Parent = btn

        -- Hover animation
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(150,100,210)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(120,80,180)
        end)

        btn.MouseButton1Click:Connect(callback)
    end

    makeButton("-", UDim2.new(0,0,0.5,0), function()
        reach = math.max(1, reach-1)
        label.Text = "Reach: "..reach
    end)

    makeButton("+", UDim2.new(0.6,0,0.5,0), function()
        reach = math.min(14, reach+1)
        label.Text = "Reach: "..reach
    end)
end

-- Hitbox da bola
local reachSphere = Instance.new("Part")
reachSphere.Name = "TPSS"
reachSphere.Shape = Enum.PartType.Ball
reachSphere.Anchored = true
reachSphere.CanCollide = false
reachSphere.Transparency = 0.6
reachSphere.Material = Enum.Material.ForceField
reachSphere.Color = Color3.fromRGB(0,150,255)
reachSphere.Size = Vector3.new(reach*2, reach*2, reach*2)
reachSphere.Parent = Workspace

-- Atualiza hitbox
RunService.RenderStepped:Connect(function()
    if ball then
        reachSphere.Position = ball.Position
        reachSphere.Size = Vector3.new(reach*2, reach*2, reach*2)
    end
end)

-- Loop principal leve
RunService.Heartbeat:Connect(touchBall)

-- Respawn
player.CharacterAdded:Connect(function()
    task.wait(1)
    refreshLegs()
    createGUI() -- recria GUI ao respawn
end)

-- Inicial
refreshLegs()
createGUI()
