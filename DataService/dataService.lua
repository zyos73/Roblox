--[[
Author: Zyos
Date: 06/07/2025 DD/MM/YY
Description: Module that manages data for players
]]

--Services
--Events
--Modules
--Variables
--Settings

--Main
local dataService = {}

--Services & Data Tree
local dataTree = require(script.dataTree)
local DSS = game:GetService("DataStoreService")

--Initialize Player
function dataService:initPlayer(plr)
	local data = dataService:_loadPlayerData(plr)

	for i, folder in dataTree.Folders do
		dataService:_createFolder(plr, folder, data)
	end
end

--Load Player Data
function dataService:_loadPlayerData(plr)
	if not dataTree.DataStoreName then return end
	
	local success, result = pcall(function()
		return DSS:GetDataStore(dataTree.DataStoreName):GetAsync(plr.UserId)
	end)
	
	return success and result or {}
end

--Create Player Data Folders
function dataService:_createFolder(plr, folderDef, data)
	local newFolder = Instance.new("Folder")
	newFolder.Name = folderDef.Name
	newFolder.Parent = plr
	
	for i, value in folderDef.Values do
		dataService:_createValue(value, newFolder, data)
	end
end


--Create Player Data Values
function dataService:_createValue(valueDef, newFolder, data)
	local value = Instance.new(valueDef.Instance)
	value.Name = valueDef.Name
	
	if data and valueDef.Save and data[valueDef.Name] then
		value.Value = data[valueDef.Name]
	else
		value.Value = valueDef.StartValue
	end
	
	value.Parent = newFolder
end



--Save Data
function dataService.dataSave(plr)
	if not dataTree.DataStoreName then return end

	local ds = DSS:GetDataStore(dataTree.DataStoreName)
	local saveData = dataService:_collectSaveData(plr)

	local success, err = pcall(function()
		ds:SetAsync(plr.UserId, saveData)
	end)

	if not success then
		warn("Save failed for", plr.Name, err)
	end

	task.wait()
end

--Collect Data to Save
function dataService:_collectSaveData(plr)
	local saveData = {}

	for _, child in plr:GetChildren() do
		local folderDef = dataService:_getFolderDefinitionByName(child.Name)
		if not folderDef then continue end

		local valuesToSave = dataService:_getValuesToSave(child, folderDef)

		for key, value in valuesToSave do
			saveData[key] = value
		end
	end

	return saveData
end

--Check if the folder is in the dataTree
function dataService:_getFolderDefinitionByName(name)
	for _, folder in dataTree.Folders do
		if folder.Name == name then
			return folder
		end
	end
	return nil
end

--Get values which needs to be saved
function dataService:_getValuesToSave(child, folderDef)
	local result = {}

	for _, valueDef in folderDef.Values do
		if not dataService:_shouldSaveValue(child, valueDef) then return end
		
		result[valueDef.Name] = child[valueDef.Name].Value
	end

	return result
end

--Check if value needs to be saved
function dataService:_shouldSaveValue(child, valueDef)
	return valueDef.Save and child:FindFirstChild(valueDef.Name)
end

return dataService