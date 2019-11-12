--// sozzly, 11/11/2019

--// modules
local require = require(game:GetService('ReplicatedStorage'):WaitForChild('library'))
local index = require('index')
local service = require('service')

--// player
local player = service.Players.LocalPlayer

--// tool
local tool = script.Parent.Parent
local network = index.WaitForChild(tool, 'network')
local assets = network.assets
local config = require(index.WaitForChild(network, 'config'))

--// animations
local heal_anim

--// variables
local ht = math.max(math.min(config.heal_time, 10), 1)
local last
local stop = false

tool.Activated:connect(function()
	local char = player.Character or player.CharacterAdded:wait()
	local humanoid = index.WaitForChild(char, 'Humanoid')
	
	if humanoid.Health < humanoid.MaxHealth and not heal_anim.IsPlaying and (not last or tick() - last >= (ht + 1)) then

		stop = false
		last = tick()
		
		heal_anim:Play(.35)
		
		while tick() - last < ht do
			if stop then heal_anim:Stop() break end
			
			if heal_anim.TimePosition >= heal_anim.Length then
				heal_anim:Play(.35)
			end
			
			service.RunService.Stepped:wait()
		end
		
		last = tick() - (ht + 2)
	end
end)

tool.Equipped:connect(function()
	local char = player.Character or player.CharacterAdded:wait()
	local humanoid = index.WaitForChild(char, 'Humanoid')
	
	heal_anim = humanoid:LoadAnimation(assets.self_heal) do --// set default
		heal_anim.Looped = false
	end
end)

tool.Unequipped:connect(function()
	stop = true
end)
