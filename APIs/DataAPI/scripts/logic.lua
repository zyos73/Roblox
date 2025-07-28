--[[
Credits : zyos73
]]--

-- === Services ===
local DSS = game:GetService("DataStoreService")

-- === Modules ===
local dataTree = require(script.Parent.dataTree)

local API = {}

function API.retrievePlayerData(player)
	if not dataTree.DataStoreName then return end

	local success, result = pcall(function()
		return DSS:GetDataStore(dataTree.DataStoreName):GetAsync(player.UserId)
	end)

	return success and result or {}
end

function API.createFolder(player, folderDef, data)
	local newFolder = Instance.new("Folder")
	newFolder.Name = folderDef.Name
	newFolder.Parent = player

	for i, value in folderDef.Values do
		API.createValue(value, newFolder, data)
	end
end

function API.createValue(valueDef, newFolder, data)
	local value = Instance.new(valueDef.Instance)
	value.Name = valueDef.Name

	if data and valueDef.Save and data[valueDef.Name] then
		value.Value = data[valueDef.Name]
	else
		value.Value = valueDef.StartValue
	end

	value.Parent = newFolder
end

function API.collectSaveData(player)
	local saveData = {}

	for _, child in player:GetChildren() do
		local folderDef = API.getFolderDefinitionByName(child.Name)
		if not folderDef then continue end

		local valuesToSave = API.getValuesToSave(child, folderDef)
		if not valuesToSave then continue end

		for key, value in valuesToSave do
			saveData[key] = value
		end
	end

	return saveData
end

function API.getFolderDefinitionByName(name)
	for _, folder in dataTree.Folders do
		if folder.Name == name then return folder end
	end

	for _, namespaceFolders in pairs(dataTree.DynamicFolders) do
		for _, folder in namespaceFolders do
			if folder.Name == name then return folder end
		end
	end

	return nil
end

function API.getValuesToSave(child, folderDef)
	local result = {}

	for _, valueDef in folderDef.Values do
		if not API.shouldSaveValue(child, valueDef) then return end

		result[valueDef.Name] = child[valueDef.Name].Value
	end

	return result
end

function API.shouldSaveValue(child, valueDef)
	return valueDef.Save and child:FindFirstChild(valueDef.Name)
end

return API
