--[[
Credits : zyos73
Version : DataAPI 1.1

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

local API = {
	dataTree = require(script.dataTree),
	logic = require(script.logic)
}

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
	local data = API.logic.retrievePlayerData(player)

	for _, folder in API.dataTree.Folders do
		API.logic.createFolder(player, folder, data)
	end

	for _, namespaceFolders in API.dataTree.DynamicFolders do
		for _, folder in namespaceFolders do
			API.logic.createFolder(player, folder, data)
		end
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
	if not API.dataTree.DataStoreName then return end

	local ds = DataStoreService:GetDataStore(API.dataTree.DataStoreName)
	local saveData = API.logic.collectSaveData(player)

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

function API.register(folders)
	for i, folderDef in folders do
		if not API.dataTree.DynamicFolders[folderDef.Name] then
			API.dataTree.DynamicFolders[folderDef.Name] = {}
		end

		table.insert(API.dataTree.DynamicFolders[folderDef.Name], folderDef)
	end
end

return API