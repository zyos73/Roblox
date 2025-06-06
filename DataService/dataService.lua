local dataService = {}

--Services & Data Tree
local dataTree = require(script.Parent.dataTree)
local DSS = game:GetService("DataStoreService")

--initialize Player (Load Data)
function dataService:initPlayer(plr)
	local data
	
	if dataTree.DataStoreName then
		local success, result = pcall(function()
			return DSS:GetDataStore(dataTree.DataStoreName):GetAsync(plr.UserId)
		end)

		data = success and result or {}
	end
	for i, folder in dataTree.Folders do
		local newFolder = Instance.new("Folder")
		newFolder.Name = folder.Name
		newFolder.Parent = plr

		for j, v in folder.Values do
			local NewValue = Instance.new(v.Instance)
			NewValue.Name = v.Name
			if data and v.Save then
				if data[v.Name] then
					NewValue.Value = data[v.Name]
				else
					NewValue.Value = v.StartValue
				end
			else
				NewValue.Value = v.StartValue
			end
			NewValue.Parent = newFolder
		end
	end
end

--Save Data
function dataService.dataSave(plr)
	if dataTree.DataStoreName then
		local ds = DSS:GetDataStore(dataTree.DataStoreName)
		
		local savedata = {}
		
		for i, child in plr:GetChildren() do
			for j, folder in dataTree.Folders do
				if folder.Name ==  child.Name then
					for i, v in folder.Values do
						if v.Save then
							savedata[v.Name] = child[v.Name].Value
						end
					end
				end
			end
		end

		local success, err = pcall(function()
			ds:SetAsync(plr.UserId, savedata)
		end)

		if not success then
			warn("Save failed for", plr.Name, err)
		end
	end
	task.wait()
end

return dataService