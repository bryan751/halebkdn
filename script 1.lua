local OrionLib = loadstring(game:HttpGet(('https://pastebin.com/raw/WRUyYTdY')))()

local Window = OrionLib:MakeWindow({
    Name = "ANIMAL SIMULATOR - SPARKKGM🇧🇷",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "Nothing"
})

local FarmTab = Window:MakeTab({
    Name = "Farm 👊",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


local autoCollectCoins = false
local coinLoop

FarmTab:AddToggle({
	Name = "Auto Coletar Coins🪙",
	Default = false,
	Callback = function(state)
		autoCollectCoins = state

		if autoCollectCoins and not coinLoop then
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local coinEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CoinEvent")

			coinLoop = task.spawn(function()
				while autoCollectCoins and task.wait(0.3) do
					pcall(function()
						coinEvent:FireServer()
					end)
				end
				coinLoop = nil
			end)
		elseif not autoCollectCoins and coinLoop then
			-- O loop será finalizado naturalmente pela condição no while
		end
	end
})

----- AUTO FARM DUMMY🕴️ NORMAL E 5K AUTOMÁTICO COM O LEVEL
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Eventos
local DamageRemote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local FireballRemote = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")

local dummyLoop = nil
local magicName = "NewFireball"

-- Remove efeitos visuais da Fireball
local function removeVisualEffects()
	local prefab = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("HitFX"):FindFirstChild(magicName)
	if prefab then
		for _, obj in pairs(prefab:GetDescendants()) do
			if obj:IsA("ParticleEmitter") or obj:IsA("Light") or obj:IsA("Attachment") then
				obj:Destroy()
			end
		end
	end
end
removeVisualEffects()

-- Farm principal
local function autoFarmByLevel()
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local HRP = Character:WaitForChild("HumanoidRootPart")

	local levelValue = LocalPlayer:WaitForChild("leaderstats"):FindFirstChild("Level")
	if not levelValue then return end

	local selectedGroupName = tonumber(levelValue.Value) >= 5000 and "5k_dummies" or "dummies"
	local originalWalkSpeed = Humanoid.WalkSpeed
	local originalJumpPower = Humanoid.JumpPower

	while task.wait(0.1) do
		if not dummyLoop then break end

		local group = Workspace:WaitForChild("MAP"):FindFirstChild(selectedGroupName)
		if not group then continue end

		local targetDummy = nil
		for _, dummy in ipairs(group:GetChildren()) do
			if dummy:FindFirstChild("Humanoid") and dummy:FindFirstChild("HumanoidRootPart") and dummy.Humanoid.Health > 0 then
				targetDummy = dummy
				break
			end
		end

		if targetDummy then
			local humanoid = targetDummy:FindFirstChild("Humanoid")
			local root = targetDummy:FindFirstChild("HumanoidRootPart")
			local damageType = selectedGroupName == "5k_dummies" and 2 or 1

			HRP.CFrame = root.CFrame + Vector3.new(0, 0, -2)
			Humanoid.WalkSpeed = 0
			Humanoid.JumpPower = 0

			while humanoid and humanoid.Health > 0 and dummyLoop do
				pcall(function()
					DamageRemote:FireServer(humanoid, damageType)
					FireballRemote:FireServer(root.Position, magicName)
				end)
				task.wait(0.15)
			end
		end
	end

	-- Restaurar movimento
	Humanoid.WalkSpeed = originalWalkSpeed
	Humanoid.JumpPower = originalJumpPower
end

FarmTab:AddToggle({
	Name = "Auto farm dummy + fireball🟠",
	Default = false,
	Callback = function(state)
		if state then
			if not dummyLoop then
				dummyLoop = true
				task.spawn(autoFarmByLevel)
			end
		else
			dummyLoop = nil
		end
	end
})


local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local leaderstats = player:WaitForChild("leaderstats")
local level = leaderstats:WaitForChild("Level")

local DamageRemote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local FireballRemote = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")

local magicName = "NewFireball"
local damageType = 5

local toggleConnection
local attacking = false
local originalCFrame

FarmTab:AddToggle({
	Name = "Auto farm dummy + fireball 2🟠",
	Default = false,
	Callback = function(state)
		attacking = state

		if state then
			-- Salva a posição original pra restaurar depois
			originalCFrame = hrp.CFrame

			-- Define Dummy correto
			local dummy
			if level.Value >= 5000 then
				dummy = Workspace:WaitForChild("MAP"):WaitForChild("5k_dummies"):WaitForChild("Dummy2")
			else
				dummy = Workspace:WaitForChild("MAP"):WaitForChild("dummies"):WaitForChild("Dummy")
			end

			local dummyHRP = dummy:WaitForChild("HumanoidRootPart")
			local dummyHumanoid = dummy:WaitForChild("Humanoid")
			local fixedPosition = dummyHRP.Position - Vector3.new(0, 14, 0)

			-- Travar personagem
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
			humanoid.PlatformStand = true

			-- Fixar no chão
			toggleConnection = RunService.Heartbeat:Connect(function()
				if not attacking then return end
				hrp.Velocity = Vector3.new(0, 0, 0)
				hrp.RotVelocity = Vector3.new(0, 0, 0)
				hrp.CFrame = CFrame.new(fixedPosition)
			end)

			-- Loop de ataque
			coroutine.wrap(function()
				while attacking and dummyHumanoid and dummyHumanoid.Health > 0 do
					pcall(function()
						DamageRemote:FireServer(dummyHumanoid, damageType)
						FireballRemote:FireServer(dummyHRP.Position, magicName)
					end)
					task.wait(0.15)
				end
			end)()

		else
			-- Desativa e restaura estado
			if toggleConnection then toggleConnection:Disconnect() end
			humanoid.PlatformStand = false
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
			if originalCFrame then
				hrp.CFrame = originalCFrame
			end
		end
	end
})


--BOSS TAB🔥🔥🔥
-- BOSS TAB 🔥
local BossTab = Window:MakeTab({
	Name = "Boss",
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
		task.wait(0.4)
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


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local attackEvent = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")

local BossFarmAtivo = false
local bossLoop -- armazenar o loop para controle

local function getAllBosses()
	local bosses = {}
	local npcFolder = workspace:FindFirstChild("NPC")
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

BossTab:AddToggle({
	Name = "Auto Kill Todos Bosses 💀",
	Default = false,
	Callback = function(Value)
		BossFarmAtivo = Value

		if BossFarmAtivo then
			if bossLoop then task.cancel(bossLoop) end -- evita duplicar loops
			bossLoop = task.spawn(function()
				while BossFarmAtivo do
					local bosses = getAllBosses()
					for _, humanoid in ipairs(bosses) do
						pcall(function()
							attackEvent:FireServer(humanoid, 7)
						end)
					end
					task.wait(0.3)
				end
			end)
		else
			if bossLoop then
				task.cancel(bossLoop)
				bossLoop = nil
			end
		end
	end
})


local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ocultarRecompensas = false

-- Atualiza o estado da GUI se ela existir
local function atualizarRecompensaGui()
	local gui = playerGui:FindFirstChild("newRewardGui")
	if gui then
		gui.Enabled = not ocultarRecompensas
	end
end

-- Sempre que algo for adicionado ao PlayerGui, verifica se é o reward
playerGui.ChildAdded:Connect(function(child)
	if child.Name == "newRewardGui" then
		task.wait(0.1) -- pequeno delay pra garantir que o GUI esteja pronto
		atualizarRecompensaGui()
	end
end)

BossTab:AddToggle({
	Name = "Ocultar Recompensas Exp⚡",
	Default = false,
	Callback = function(Value)
		ocultarRecompensas = Value
		atualizarRecompensaGui()
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
		task.wait(0.3) -- sem delay
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


local EventosTab = Window:MakeTab({
	Name = "Eventos💯",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

EventosTab:AddButton({
	Name = "Coletar Puzzles de Páscoa🐇",
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local remote = game:GetService("ReplicatedStorage"):WaitForChild("Easter2025"):WaitForChild("RemoteEvent")

		local questFolder = workspace:WaitForChild("Easter2025"):WaitForChild("Quest")
		local piecesFolder = questFolder:WaitForChild("PuzzlePieces")
		local ownedPuzzleFolder = questFolder:WaitForChild("Puzzle")
		local workspacePlayer = workspace:WaitForChild(player.Name)

		local function alreadyHasPiece(pieceName)
			local ownedPart = ownedPuzzleFolder:FindFirstChild(pieceName)
			if ownedPart and ownedPart:IsA("Part") then
				local decal = ownedPart:FindFirstChildOfClass("Decal")
				if decal and decal.Transparency == 0 then
					return true
				end
			end
			return false
		end

		local function waitForPickup(pieceName, timeout)
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

		local function waitForPut(pieceName, timeout)
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

		task.spawn(function()
			for _, piece in ipairs(piecesFolder:GetChildren()) do
				if piece:IsA("Part") and not alreadyHasPiece(piece.Name) then
					-- Coletar peça
					remote:FireServer({
						action = "pick_up",
						puzzle_name = piece.Name
					})

					if waitForPickup(piece.Name, 3) then
						-- Entregar peça corretamente
						remote:FireServer({
							action = "put",
							puzzle_name = piece.Name
						})

						waitForPut(piece.Name, 5)
						task.wait(0.5)
					end
				end
			end
		end)
	end    
})

-- EVENTO DAS GALINHAS 🐔🐔
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local chickenEvent = ReplicatedStorage:WaitForChild("ChickenEvent"):WaitForChild("RemoteEvent")

--  SkinList como string
local skinListValue = game:GetService("Players").LocalPlayer.otherstats:WaitForChild("SkinList")

--  Combos de elementos
local combos = {
	{}, -- Ovo normal
	{"Ice"},
	{"Grass"},
	{"Fire"},
	{"Fire", "Ice", "Grass"} -- Galinha rara
}

--  Lista das galinhas que queremos garantir
local galinhasAlvo = {
	"CHKN8", "CHKN9", "CHKN10", "CHKN11",
	"CHKN12", "CHKN13", "CHKN14", "CHKN15", "CHKN16"
}

--  Função que verifica se já temos todas
local function temTodasAsGalinhas()
	local lista = skinListValue.Value
	for _, id in ipairs(galinhasAlvo) do
		if not lista:find(id) then
			return false
		end
	end
	return true
end

--  Função para tentar pegar as galinhas até conseguir todas
local function coletarTodasGalinhas()
	if temTodasAsGalinhas() then return end

	while not temTodasAsGalinhas() do
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
			task.wait(0.01)
		end
	end
end

-- Adicionando botão no GUI
EventosTab:AddButton({
	Name = "Coletar Galinhas🐔",
	Callback = function()
		coletarTodasGalinhas()
	end
})


---- COLETAR PEGASUSEVENT

-- Referência dos serviços e valores
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local skinListValue = Players.LocalPlayer.otherstats:WaitForChild("SkinList")
local Remote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("PegasusQuestEvent")

-- Skins alvo
local skinsPegasus = { "Hor11", "Hor12" }

-- Função para checar se o jogador já tem ambas as skins
local function temSkinsPegasus()
	local lista = skinListValue.Value
	for _, id in ipairs(skinsPegasus) do
		if not lista:find(id) then
			return false
		end
	end
	return true
end

-- Função para executar o evento
local function executarPegasusEvent()
	if temSkinsPegasus() then return end

	pcall(function()
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
	end)
end

-- Botão na aba EventosTab
EventosTab:AddButton({
	Name = "Coletar PegasusEvent",
	Callback = function()
		executarPegasusEvent()
	end
})


EventosTab:AddButton({
	Name = "Unlock All Skins Events",
	Callback = function()
		local player = game:GetService("Players").LocalPlayer
		local starterGui = game:GetService("StarterGui")
		local templates = starterGui:WaitForChild("newRewardGui"):WaitForChild("NewFrame"):WaitForChild("Templates")
		local skinListValue = player.otherstats:WaitForChild("SkinList")

		local skinsFound = {}

		for _, folder in pairs(templates:GetChildren()) do
			if folder:IsA("Folder") then
				for _, imageLabel in pairs(folder:GetChildren()) do
					if imageLabel:IsA("ImageLabel") then
						table.insert(skinsFound, imageLabel.Name)
					end
				end
			end
		end

		skinListValue.Value = ", " .. table.concat(skinsFound, ", ")
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


ExtrasTab:AddToggle({
	Name = "Fireball🟠",
	Default = false,
	Callback = function(Value)
		local Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Debris = game:GetService("Debris")
		local player = Players.LocalPlayer
		local mouse = player:GetMouse()
		local RemoteEvent = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")
		local DamageIndicatorEvent = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("DamageIndicatorEvent")

		local toolName = "Fireball"
		local tool = player.Backpack:FindFirstChild(toolName) or player.Character and player.Character:FindFirstChild(toolName)

		-- Função para criar a fireball com visual igual a original (incluindo HitAtt)
		local function createFireball(position)
			local fireball = Instance.new("Part")
			fireball.Name = "NewFireBall"
			fireball.Shape = Enum.PartType.Ball
			fireball.Size = Vector3.new(2, 2, 2)
			fireball.Position = position
			fireball.Anchored = false
			fireball.CanCollide = false
			fireball.Material = Enum.Material.Neon
			fireball.BrickColor = BrickColor.new("Bright red")
			fireball.Transparency = 1
			fireball.TopSurface = Enum.SurfaceType.Smooth
			fireball.BottomSurface = Enum.SurfaceType.Smooth

			-- Adiciona o HitAtt com os efeitos visuais
			local hitAtt = Instance.new("Attachment")
			hitAtt.Name = "HitAtt"
			hitAtt.Position = Vector3.new(0, 0, 0)
			hitAtt.Parent = fireball

			-- Efeitos visuais (exemplo usando ParticleEmitter)
			local particle = Instance.new("ParticleEmitter")
			particle.Texture = "rbxassetid://11097304483" -- textura da bola de fogo original
			particle.Size = NumberSequence.new(1.5)
			particle.Color = ColorSequence.new(Color3.new(1, 0.4, 0.2))
			particle.Lifetime = NumberRange.new(0.3)
			particle.Rate = 50
			particle.Speed = NumberRange.new(0)
			particle.Rotation = NumberRange.new(0, 360)
			particle.RotSpeed = NumberRange.new(100)
			particle.LightEmission = 1
			particle.Parent = hitAtt

			-- Luz
			local light = Instance.new("PointLight", fireball)
			light.Color = Color3.new(1, 0.3, 0.3)
			light.Range = 10
			light.Brightness = 2

			-- Movimento
			local velocity = Instance.new("BodyVelocity")
			velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			velocity.Velocity = Vector3.zero
			velocity.Parent = fireball

			-- Detecção de impacto
			local touchedConn
			touchedConn = fireball.Touched:Connect(function(hit)
				if hit and hit.Parent and hit.Parent ~= player.Character then
					DamageIndicatorEvent:FireServer(hit.Position, 10)
					touchedConn:Disconnect()
					fireball:Destroy()
				end
			end)

			return fireball, velocity
		end

		-- Ativa ou desativa o tool da fireball
		if Value then
			if not tool then
				tool = Instance.new("Tool")
				tool.Name = toolName
				tool.RequiresHandle = false
				tool.CanBeDropped = false
				tool.Parent = player:WaitForChild("Backpack")

				tool.Activated:Connect(function()
					local character = player.Character
					if not character then return end

					local head = character:FindFirstChild("Head")
					if not head then return end

					local origin = head.Position
					local mousePos = mouse.Hit.Position
					local direction = (mousePos - origin).Unit

					local fireball, velocity = createFireball(origin + direction * 3)
					fireball.Parent = workspace

					velocity.Velocity = direction * 100

					Debris:AddItem(fireball, 5)

					RemoteEvent:FireServer(mousePos, "NewFireball")
				end)
			end
		else
			if tool then
				tool:Destroy()
			end
		end
	end
})


ExtrasTab:AddToggle({
	Name = "LightningBall🔵",
	Default = false,
	Callback = function(Value)
		local Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Debris = game:GetService("Debris")
		local player = Players.LocalPlayer
		local mouse = player:GetMouse()
		local RemoteEvent = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")
		local DamageIndicatorEvent = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("DamageIndicatorEvent")
		local LightningballTemplate = ReplicatedStorage:WaitForChild("SkillsInRS").HitFX:WaitForChild("NewLightningball")

		local toolName = "Lightningball"
		local tool = player.Backpack:FindFirstChild(toolName) or player.Character and player.Character:FindFirstChild(toolName)

		local function createLightningball(position)
			local lightningball = LightningballTemplate:Clone()
			lightningball.Name = "LightningBall"
			lightningball.CFrame = CFrame.new(position)
			lightningball.Anchored = false
			lightningball.CanCollide = false

			-- Velocidade e impacto
			local velocity = Instance.new("BodyVelocity")
			velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			velocity.Parent = lightningball

			local touchedConn
			touchedConn = lightningball.Touched:Connect(function(hit)
				if hit and hit.Parent and hit.Parent ~= player.Character then
					DamageIndicatorEvent:FireServer(hit.Position, 10)
					touchedConn:Disconnect()
					lightningball:Destroy()
				end
			end)

			return lightningball, velocity
		end

		if Value then
			if not tool then
				tool = Instance.new("Tool")
				tool.Name = toolName
				tool.RequiresHandle = false
				tool.CanBeDropped = false
				tool.Parent = player:WaitForChild("Backpack")

				tool.Activated:Connect(function()
					local character = player.Character
					if not character then return end

					local head = character:FindFirstChild("Head")
					if not head then return end

					local origin = head.Position
					local mousePos = mouse.Hit.Position
					local direction = (mousePos - origin).Unit

					local lightningball, velocity = createLightningball(origin + direction * 3)
					lightningball.Parent = workspace

					velocity.Velocity = direction * 100

					Debris:AddItem(lightningball, 5)

					RemoteEvent:FireServer(mousePos, "NewLightningball")
				end)
			end
		else
			if tool then
				tool:Destroy()
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


local HumanoidTab = Window:MakeTab({
	Name = "Humanoid",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local function applyStats(speed, jump)
	local char = game.Players.LocalPlayer.Character
	if not char then return end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if speed then
		humanoid.WalkSpeed = speed
	end
	if jump then
		humanoid.JumpPower = jump
	end
end

HumanoidTab:AddTextbox({
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

HumanoidTab:AddTextbox({
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

TeleportTab = Window:MakeTab({
	Name = "Teleports",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


TeleportTab:AddButton({
	Name = "Teleport Safezone🛡️",
	Callback = function()
		local lp = game:GetService("Players").LocalPlayer
		local char = lp.Character or lp.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")

		local destino = workspace.SpawnLocation:FindFirstChild("SpawnLocation")
		if destino then
			root.CFrame = destino.CFrame + Vector3.new(0, 5, 0) -- adiciona um pouco de altura pra não bugar no chão
		end
	end
})


TeleportTab:AddButton({
	Name = "Teleport Volcano🌋",
	Callback = function()
		local lp = game:GetService("Players").LocalPlayer
		local char = lp.Character or lp.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")
		local destino = workspace.MAP["new map"].graveyard["Meshes/PolygonDungeon_Environments_01_SM_Env_Rock_Flat_01"]
		root.CFrame = destino.CFrame + Vector3.new(0, 5, 0)
	end
})


TeleportTab:AddButton({
	Name = "Teleport Desert🏜️",
	Callback = function()
		local lp = game:GetService("Players").LocalPlayer
		local char = lp.Character or lp.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")
		local destino = workspace.MAP.western.base
		root.CFrame = destino.CFrame + Vector3.new(0, 5, 0)
	end
})


TeleportTab:AddButton({
	Name = "Teleport Beach🏖️",
	Callback = function()
		local lp = game:GetService("Players").LocalPlayer
		local char = lp.Character or lp.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")

		local destino = workspace.MAP["low poly rocks"]:GetChildren()[31]
		if destino and destino:IsA("BasePart") then
			root.CFrame = destino.CFrame + Vector3.new(0, 5, 0)
		else
			warn("Destino inválido")
		end
	end
})


TeleportTab:AddButton({
	Name = "Teleport Snow❄️",
	Callback = function()
		local lp = game:GetService("Players").LocalPlayer
		local char = lp.Character or lp.CharacterAdded:Wait()
		local root = char:WaitForChild("HumanoidRootPart")
		local destino = workspace.MAP["new map"].ground:GetChildren()[37]
		root.CFrame = destino.CFrame + Vector3.new(0, 5, 0)
	end
})