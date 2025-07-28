--[[
Credits : zyos73
Version : DataAPI 1.0

===IMPORTANT
===IMPORTANT
===IMPORTANT

* Childs:

logic.lua
dataTree.lua

* Parent:

ServerScriptService

===IMPORTANT
===IMPORTANT
===IMPORTANT
]]--

-- === Services ===
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- === Modules ===
local dataTree = require(script.dataTree)
local logic = require(script.logic)

local API = {}

--[=[
<strong>This is supposed to be run wehn the game starts.</strong>


<strong>Example</strong>
```lua
game.Players.PlayerAdded:Connect(function(player)
	DataAPI.setup(player)
end)
```
]=]
function API.load(player : Player)
	local data = logic.retrievePlayerData(player)

	for _, folder in dataTree.Folders do
		logic.createFolder(player, folder, data)
	end
end

--[=[
<strong>This is supposed to be run wehn a player leaves.</strong>


<strong>Example</strong>
```lua
game.Players.PlayerRemoving:Connect(function(player)
	DataAPI.dataSave(player)
end)
```
]=]
function API.save(player)
	if not dataTree.DataStoreName then return end

	local ds = DataStoreService:GetDataStore(dataTree.DataStoreName)
	local saveData = logic.collectSaveData(player)

	local success, err = pcall(function()
		ds:SetAsync(player.UserId, saveData)
	end)

	if not success then
		warn("Save failed for", player.Name, err)
	end
end

--[=[
<strong>This is supposed to be run once wehn the server starts.</strong>


<strong>Example</strong>
```lua
DataAPI.autoSave(60)
```
]=]
function API.autoSave(time : number)
	task.spawn(function()
		while task.wait(time) do
			for _, player in Players:GetPlayers() do
				API.save(player)
			end
		end
	end)
end

return API