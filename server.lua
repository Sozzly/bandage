--// sozzly, 11/11/2019

--// modules
local require = require(game:GetService('ReplicatedStorage'):WaitForChild('library'))
local index = require('index')
local service = require('service')

--// tool
local tool = script.Parent.Parent
local handle = tool.Handle
local equip_sound = handle.equip
local apply_sound = handle.apply
local network = index.WaitForChild(tool, 'network')
local assets = network.assets
local config = require(network.config)

--// variables
local ht = math.max(math.min(config.heal_time, 10), 1)
local last
local heal_anim
local animation_speed
local default_ws, default_jp

tool.Activated:connect(function()
	local char = tool.Parent
	local humanoid = index.WaitForChild(char, 'Humanoid')
	
	if not apply_sound.Playing and humanoid.Health < humanoid.MaxHealth then
		last = tick()
		
		while (not last or tick() - last < (ht + animation_speed / 2)) do
			if not apply_sound.Playing then
				apply_sound:Play()
			end

			if tool.Parent:IsA('Backpack') then break end
			
			humanoid.WalkSpeed = (default_ws or 16) / 2
			humanoid.JumpPower = 0
			
			service.RunService.Stepped:wait()
		end
		
		apply_sound:Stop()
	
		if not tool.Parent:IsA('Backpack') then
			humanoid.Health = humanoid.Health + (ht * 5)
		end
		
		humanoid.WalkSpeed = default_ws or 16
		humanoid.JumpPower = default_jp or 50
		
		last = tick()
	end
end)

tool.Equipped:connect(function()
	equip_sound.PlaybackSpeed = Random.new():NextNumber(.85, 1.15)
	equip_sound:Play()
	
	if not heal_anim then
		local char = tool.Parent
		local humanoid = index.WaitForChild(char, 'Humanoid')
		
		default_ws = humanoid.WalkSpeed
		default_jp = humanoid.JumpPower
		
		heal_anim = humanoid:LoadAnimation(assets.self_heal) do --// set default
			animation_speed = heal_anim.Speed
		end
	end
end)

tool.Unequipped:connect(function()
	heal_anim = nil
end)
