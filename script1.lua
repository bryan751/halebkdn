local OrionLib = loadstring(game:HttpGet(('https://pastebin.com/raw/WRUyYTdY')))()

local Window = OrionLib:MakeWindow({
    Name = "ANIMAL SIMULADOR - BY SPARKKGM🇧🇷",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "Nothing"
})

local FarmTab = Window:MakeTab({
    Name = "Farm 👊",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--TOGGLE ATIVAR/DESATIVAR A COLETA DE COINS
local autoCollectCoins = false
local coinLoop

FarmTab:AddToggle({
	Name = "Auto Coletar Coins🪙",
	Default = false,
	Callback = function(state)
		autoCollectCoins = state

		if autoCollectCoins then
			print("Auto Coletar Coins ATIVADO")

			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local coinEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CoinEvent")

			coinLoop = task.spawn(function()
				while autoCollectCoins do
					pcall(function()
						coinEvent:FireServer()
					end)
					task.wait(0.2)
				end
			end)

		else
			print("Auto Coletar Coins DESATIVADO")
		end
	end
})


--TOGGLE ATIVAR/DESATIVAR COLETAR PUZZLES DE PÁSCOA 

local autoFarmPieces = false
local farmLoop = nil

-- Funções auxiliares
local function alreadyHasPiece(pieceName, ownedPuzzleFolder)
	local ownedPart = ownedPuzzleFolder:FindFirstChild(pieceName)
	if ownedPart and ownedPart:IsA("Part") then
		local decal = ownedPart:FindFirstChildOfClass("Decal")
		if decal and decal.Transparency == 0 then
			return true
		end
	end
	return false
end

local function waitForPickup(workspacePlayer, pieceName, timeout)
	local timer = 0
	repeat
		if workspacePlayer:FindFirstChild(pieceName) then
			return true
		end
		task.wait(0.1)
		timer += 0.1
	until timer >= (timeout or 5)
	return false
end

local function waitForDrop(workspacePlayer, pieceName, timeout)
	local timer = 0
	repeat
		if not workspacePlayer:FindFirstChild(pieceName) then
			return true
		end
		task.wait(0.1)
		timer += 0.1
	until timer >= (timeout or 5)
	return false
end

local function startAutoFarm()
	local player = game.Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local remote = game:GetService("ReplicatedStorage"):WaitForChild("Easter2025"):WaitForChild("RemoteEvent")

	local questFolder = workspace:WaitForChild("Easter2025"):WaitForChild("Quest")
	local piecesFolder = questFolder:WaitForChild("PuzzlePieces")
	local touchPart = questFolder:WaitForChild("TouchPart")
	local ownedPuzzleFolder = questFolder:WaitForChild("Puzzle")
	local workspacePlayer = workspace:WaitForChild(player.Name)

	farmLoop = task.spawn(function()
		while autoFarmPieces do
			for _, piece in ipairs(piecesFolder:GetChildren()) do
				if not autoFarmPieces then break end

				if piece:IsA("Part") and not alreadyHasPiece(piece.Name, ownedPuzzleFolder) then
					hrp.CFrame = piece.CFrame + Vector3.new(0, 3, 0)
					task.wait(0.5)

					remote:FireServer({
						action = "pick_up",
						puzzle_name = piece.Name
					})

					if waitForPickup(workspacePlayer, piece.Name, 3) then
						hrp.CFrame = touchPart.CFrame + Vector3.new(0, 3, 0)
						waitForDrop(workspacePlayer, piece.Name, 5)
						task.wait(0.5)
					else
						warn("Falha ao pegar a peça: " .. piece.Name)
					end
				end
			end
			task.wait(1)
		end
		farmLoop = nil
	end)
end

local function stopAutoFarm()
	autoFarmPieces = false
end

-- Toggle com o formato padrão do seu Script Hub
FarmTab:AddToggle({
	Name = "Auto Coletar Quebra-Cabeças",
	Default = false,
	Callback = function(Value)
		autoFarmPieces = Value
		if Value then
			startAutoFarm()
			print("Auto Farm Puzzles ATIVADO")
		else
			stopAutoFarm()
			print("Auto Farm Puzzles DESATIVADO")
		end
	end    
})

-- COLETAR GALINHAS
local coletarGalinhas = false
local chickenEvent = game:GetService("ReplicatedStorage"):WaitForChild("ChickenEvent"):WaitForChild("RemoteEvent")

-- Combinações: Ovo normal, cristais separados e todos juntos
local combos = {
    {}, -- Ovo normal
    {"Ice"},
    {"Grass"},
    {"Fire"},
    {"Fire", "Ice", "Grass"} -- Galinha rara
}

-- Loop para chocar as galinhas
task.spawn(function()
	while true do
		if coletarGalinhas then
			for _, combo in ipairs(combos) do
				local args = {
					[1] = {
						["action"] = "craft",
						["element_table"] = combo
					}
				}
				pcall(function()
					chickenEvent:FireServer(unpack(args))
				end)
				task.wait(0.001)
			end
		end
		task.wait(0.001)
	end
end)

-- Botão no FarmTab
FarmTab:AddToggle({
	Name = "Auto Coletar Galinhas",
	Default = false,
	Callback = function(Value)
		coletarGalinhas = Value
	end
})

local farmarPets = false
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PegasusQuestEvent")

-- Função para automatizar as etapas dos pets
local function executarEtapas()
	while farmarPets do
		local success, err = pcall(function()
			-- LEAFER
			Remote:FireServer("carry", "leaf")
			task.wait(1)
			Remote:FireServer("pass")
			task.wait(0.5)
			Remote:FireServer("claim", "leaf")
			task.wait(1.5)

			-- FEATHER
			Remote:FireServer("carry", "feather")
			task.wait(1)
			Remote:FireServer("pass")
			task.wait(0.5)
			Remote:FireServer("claim", "feather")
			task.wait(1.5)
		end)
		if not success then
			warn("Erro ao farmar pets:", err)
		end
		task.wait(0.5)
	end
end

-- Botão no FarmTab
FarmTab:AddToggle({
	Name = "Auto Coletar PegasusEvent ",
	Default = false,
	Callback = function(Value)
		farmarPets = Value
		if farmarPets then
			task.spawn(executarEtapas)
		end
	end
})

--FARM DUMMYS
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Eventos
local DamageRemote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local FireballRemote = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")

local selectedGroupName = nil
local attacking = false
local magicName = "NewFireball"

-- Remove efeitos visuais da Fireball
local function removeVisualEffects()
	local prefab = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("HitFX"):FindFirstChild("NewFireball")
	if prefab then
		for _, obj in pairs(prefab:GetDescendants()) do
			if obj:IsA("ParticleEmitter") or obj:IsA("Light") or obj:IsA("Attachment") then
				obj:Destroy()
			end
		end
	end
end

removeVisualEffects()

-- Função principal
local function attackDummyLocked()
	attacking = true

	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local HRP = Character:WaitForChild("HumanoidRootPart")

	local originalWalkSpeed = Humanoid.WalkSpeed
	local originalJumpPower = Humanoid.JumpPower

	while attacking and selectedGroupName do
		local group = Workspace:WaitForChild("MAP"):FindFirstChild(selectedGroupName)
		if not group then break end

		local targetDummy = nil
		for _, dummy in pairs(group:GetChildren()) do
			if dummy:FindFirstChild("Humanoid") and dummy:FindFirstChild("HumanoidRootPart") and dummy.Humanoid.Health > 0 then
				targetDummy = dummy
				break
			end
		end

		if targetDummy then
			local humanoid = targetDummy:FindFirstChild("Humanoid")
			local root = targetDummy:FindFirstChild("HumanoidRootPart")
			local damageType = selectedGroupName == "5k_dummies" and 2 or 1

			-- TELEPORTA e trava
			HRP.CFrame = root.CFrame + Vector3.new(0, 0, -2)
			Humanoid.WalkSpeed = 0
			Humanoid.JumpPower = 0

			-- Ataca até o Dummy morrer
			while attacking and humanoid and humanoid.Health > 0 do
				pcall(function()
					-- Ataque físico
					DamageRemote:FireServer(humanoid, damageType)

					-- Fireball (lance na posição do Dummy)
					FireballRemote:FireServer(root.Position, magicName)
				end)
				task.wait(0.15) -- mais rápido
			end
		end

		task.wait(0.1) -- intervalo entre busca de novos dummies
	end

	-- Destrava personagem
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Humanoid = Character:FindFirstChild("Humanoid")
	if Humanoid then
		Humanoid.WalkSpeed = originalWalkSpeed
		Humanoid.JumpPower = originalJumpPower
	end
end

-- Dropdown para ativar/desativar farm
FarmTab:AddDropdown({
	Name = "Auto Farm Dummy",
	Default = "Nenhum",
	Options = {"Nenhum", "5k_dummies", "dummies"},
	Callback = function(Value)
		if Value == "Nenhum" then
			selectedGroupName = nil
			attacking = false
		else
			selectedGroupName = Value
			if not attacking then
				task.spawn(attackDummyLocked)
			end
		end
	end    
})

--BOSS TAB🔥🔥🔥
-- BOSS TAB 🔥
local BossTab = Window:MakeTab({
	Name = "Boss(Teste)",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- 🔥 1. AUTO FIREBALL NO BOSS ESCOLHIDO 🔥
local selectedFireballBoss = "Nenhum"
local fireballLoop = nil

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local SkillsRS = ReplicatedStorage:WaitForChild("SkillsInRS")
local RemoteEventFB = SkillsRS:WaitForChild("RemoteEvent")
local DamageIndicatorEvent = SkillsRS:WaitForChild("DamageIndicatorEvent")

local function attackFireballBoss()
	if selectedFireballBoss == "Nenhum" then return end

	local npcFolder = Workspace:FindFirstChild("NPC")
	if not npcFolder then return end

	local boss = npcFolder:FindFirstChild(selectedFireballBoss)
	if boss and boss:FindFirstChild("HumanoidRootPart") then
		local targetPos = boss.HumanoidRootPart.Position
		RemoteEventFB:FireServer(targetPos, "NewFireball")
		task.wait(0.05)
		DamageIndicatorEvent:FireServer(targetPos)
	end
end

local function startFireballLoop()
	if fireballLoop then return end
	fireballLoop = task.spawn(function()
		while selectedFireballBoss ~= "Nenhum" do
			attackFireballBoss()
			task.wait(0.5)
		end
		fireballLoop = nil
	end)
end

local function getBossList()
	local list = { "Nenhum" }
	local npcFolder = Workspace:FindFirstChild("NPC")
	if npcFolder then
		for _, obj in ipairs(npcFolder:GetChildren()) do
			if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
				table.insert(list, obj.Name)
			end
		end
	end
	return list
end

BossTab:AddDropdown({
	Name = "Auto Farm Boss (Fireball)",
	Default = "Nenhum",
	Options = getBossList(),
	Callback = function(Value)
		selectedFireballBoss = Value
		if Value ~= "Nenhum" then
			startFireballLoop()
		end
	end
})

-- ⚔️ 2. AUTO ATTACK NO BOSS ESCOLHIDO (REMOTE EVENT) ⚔️
local selectedRemoteBoss = nil
local attackingBoss = false
local RemoteEvent = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")

local function getRemoteBoss()
	local npcFolder = Workspace:FindFirstChild("NPC")
	if npcFolder and selectedRemoteBoss then
		local boss = npcFolder:FindFirstChild(selectedRemoteBoss)
		if boss and boss:FindFirstChild("Humanoid") then
			return boss.Humanoid
		end
	end
	return nil
end

local function attackSelectedBoss()
	attackingBoss = true
	while attackingBoss and selectedRemoteBoss do
		local bossHumanoid = getRemoteBoss()
		if bossHumanoid and bossHumanoid.Health > 0 then
			pcall(function()
				RemoteEvent:FireServer(bossHumanoid, 7)
			end)
		end
		task.wait(0.2)
	end
end

BossTab:AddDropdown({
	Name = "Atacar Boss Escolhido",
	Default = "Nenhum",
	Options = getBossList(),
	Callback = function(Value)
		if Value == "Nenhum" then
			selectedRemoteBoss = nil
			attackingBoss = false
		else
			selectedRemoteBoss = Value
			if not attackingBoss then
				task.spawn(attackSelectedBoss)
			end
		end
	end
})

-- 💀 3. AUTO ATACAR TODOS OS BOSSES 💀
local BossFarmAtivo = false
local attackEvent = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")

local function getAllBosses()
	local npcFolder = workspace:FindFirstChild("NPC")
	local bosses = {}
	if npcFolder then
		for _, boss in pairs(npcFolder:GetChildren()) do
			local humanoid = boss:FindFirstChild("Humanoid")
			if humanoid and humanoid.Health > 0 then
				table.insert(bosses, humanoid)
			end
		end
	end
	return bosses
end

task.spawn(function()
	while true do
		if BossFarmAtivo then
			local bosses = getAllBosses()
			for _, humanoid in pairs(bosses) do
				pcall(function()
					attackEvent:FireServer(humanoid, 7)
				end)
			end
		end
		task.wait(0.2)
	end
end)

BossTab:AddToggle({
	Name = "Auto Kill Todos Bosses",
	Default = false,
	Callback = function(Value)
		BossFarmAtivo = Value
	end
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

BossTab:AddToggle({
	Name = "Ocultar Recompensas Exp ⚡",
	Default = false,
	Callback = function(Value)
		local gui = player:WaitForChild("PlayerGui"):FindFirstChild("newRewardGui")
		if gui then
			gui.Enabled = not Value -- true quando desativado, false quando ativado
		end
	end
})


--TAB EXTRAS😎
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Cria a aba "Extras"
local ExtrasTab = Window:MakeTab({
	Name = "Extras 😎",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Função que aplica os valores ao personagem
local function applyStats(walkSpeed, jumpPower)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if walkSpeed then humanoid.WalkSpeed = walkSpeed end
		if jumpPower then humanoid.JumpPower = jumpPower end
	end
end

-- Caixa de texto para Velocidade
ExtrasTab:AddTextbox({
	Name = "Velocidade",
	Default = "16",
	TextDisappear = true,
	Callback = function(Value)
		local num = tonumber(Value)
		if num then
			applyStats(num, nil)
			print("Velocidade definida para:", num)
		else
			warn("Digite um número válido para Velocidade.")
		end
	end	  
})

-- Caixa de texto para Pulo
ExtrasTab:AddTextbox({
	Name = "Pulo",
	Default = "50",
	TextDisappear = true,
	Callback = function(Value)
		local num = tonumber(Value)
		if num then
			applyStats(nil, num)
			print("Pulo definido para:", num)
		else
			warn("Digite um número válido para Pulo.")
		end
	end	  
})

-- Aplicar valores constantemente por segurança
task.spawn(function()
	while true do
		applyStats()
		task.wait(0.5)
	end
end)

-- Exemplo de como mudar valor do slider (se quiser usar depois)
-- SpeedSlider:Set(100)
-- JumpSlider:Set(80)

-- BOTÃO: Clonar Fireball
ExtrasTab:AddButton({
	Name = "Fireball",
	Callback = function()
		local backpack = LocalPlayer:WaitForChild("Backpack")
		local toolName = "Fireball"

		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local theirBackpack = player:FindFirstChild("Backpack")
				if theirBackpack then
					local tool = theirBackpack:FindFirstChild(toolName)
					if tool and tool:IsA("Tool") then
						local clone = tool:Clone()
						clone.Parent = backpack
						print("Fireball clonada de:", player.Name)
						break
					end
				end
			end
		end
	end
})

-- BOTÃO: Ativar Rádio (DRadio_Gui)
ExtrasTab:AddButton({
	Name = "Ativar Rádio",
	Callback = function()
		local success, err = pcall(function()
			local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
			local RadioGui = PlayerGui:WaitForChild("DRadio_Gui", 10)
			if RadioGui and not RadioGui.Enabled then
				RadioGui.Enabled = true
				print("Rádio ativado com sucesso.")
			else
				warn("Rádio já estava ativado ou não encontrado.")
			end
		end)
		if not success then
			warn("Erro ao ativar o rádio:", err)
		end
	end
})

---PVP ⚔️⚔️⚔️
local pvpTab = Window:MakeTab({
	Name = "PvP(beta)",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Remote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")

local killAuraEnabled = false

-- Função da Kill Aura
local function KillAura()
	while killAuraEnabled do
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
					local targetHumanoid = player.Character.Humanoid
					if targetHumanoid.Health > 0 then
						pcall(function()
							Remote:FireServer(targetHumanoid, 2)
						end)
					end
				end
			end
		end
		task.wait(0) -- sem delay
	end
end

-- Toggle na aba pvpTab
pvpTab:AddToggle({
	Name = "Kill Aura V1",
	Default = false,
	Callback = function(Value)
		killAuraEnabled = Value
		if Value then
			task.spawn(KillAura)
		else
			warn("Kill Aura V1 desativada.")
		end
	end
})

--- ARMAS EXTRAS
-- Pega as armas da GUI visível (PlayerGui)
local weaponsFrame = player:WaitForChild("PlayerGui")
    :WaitForChild("WeaponsGUI")
    :WaitForChild("weaponFrame")
    :WaitForChild("bodyFrame")
    :WaitForChild("body2Frame")
    :WaitForChild("scrollingFrame")

-- Prepara lista de armas
local armasLista = { "Nenhum" }
local armaMap = {}

for _, arma in pairs(weaponsFrame:GetChildren()) do
	if arma:IsA("Frame") and arma.Name ~= "" then
		local nomeExibicao = arma.Name
		if arma:FindFirstChild("gamepass") then
			nomeExibicao = nomeExibicao .. " - gamepass"
		end
		table.insert(armasLista, nomeExibicao)
		armaMap[nomeExibicao] = arma
	end
end

-- Cria o Dropdown no Hub
ExtrasTab:AddDropdown({
	Name = "Escolher Arma🗡️",
	Default = "Nenhum",
	Options = armasLista,
	Callback = function(Value)
		if Value == "Nenhum" then return end

		local armaSelecionada = armaMap[Value]
		if armaSelecionada then
			local args = { armaSelecionada.Name }
			ReplicatedStorage.Events.WeaponEvent:FireServer(unpack(args))

			if armaSelecionada:FindFirstChild("gamepass") then
				if player.Character and player.Character.Parent then
					player.Character:BreakJoints()
				end
			end
		end
	end
})

ExtrasTab:AddButton({
	Name = "Anti lag 💯",
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()

		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") or v:IsA("Trail") then
				if not v:IsDescendantOf(char) then
					pcall(function() v.Enabled = false end)
				end
			end

			if v:IsA("BasePart") and not v:IsDescendantOf(char) then
				pcall(function()
					v.Material = Enum.Material.Plastic
					v.Reflectance = 0
					v.CastShadow = false
				end)
			end

			if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
				pcall(function()
					v.Enabled = false
				end)
			end
		end

		local l = game:GetService("Lighting")
		l.GlobalShadows = false
		l.Brightness = 1
		l.FogEnd = 1e9
		l.EnvironmentDiffuseScale = 0
		l.EnvironmentSpecularScale = 0
		l.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)

		if workspace:FindFirstChildOfClass("Terrain") then
			local terrain = workspace:FindFirstChildOfClass("Terrain")
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
			terrain.WaterReflectance = 0
			terrain.WaterTransparency = 1
			terrain.Decorations = false
		end
	end
})

ExtrasTab:AddButton({
	Name = "Anti afk 💯",
	Callback = function()
		local VirtualUser = game:GetService("VirtualUser")
		game:GetService("Players").LocalPlayer.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)

		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Anti AFK loaded!",
			Text = "SparkGm Is?",
			Button1 = "Goat",
			Duration = 5
		})
	end
})