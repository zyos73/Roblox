# Hierarchie
![Preview](Hierarchie.png)

# Documentation:
## Data Tree
```lua
local API = {
	DataStoreName = "dataAPI",


	Folders = {
		{
			Name = "leaderstats",
			Values = {
				{ 
					Instance = "NumberValue", 
					StartValue = 0, Save = true, 
					Name = "temp" 
				}
			}
		}
	},


	DynamicFolders = {}
}
```

```lua
dataTree.DataStoreName -- is the name under which the datastore saves  
dataTree.Folders[i] --is the location to create your folders  
dataTree.Folders[i].Name --is the folders name  
dataTree.Folders[i].Values --is the folders values  

dataTree.Folders[i].Values[i] --is the location to create your values  
dataTree.Folders[i].Values[i].Instance --is the value type  
dataTree.Folders[i].Values[i].StartValue -- is the value with which it starts  
dataTree.Folders[i].Values[i].Save  --decides if the value saves  
dataTree.Folders[i].Values[i].Name --is the name of the value

dataTree.DynamicFolders
--[[ 
this is intended to be used by other APIs / Developers  
who want to control values which need to be saved  
in runtime (view example)  
]]
```

## Logic
Inside of [DataAPI.lua](./scripts/DataAPI.lua)

## Examples  
### Saving:
```lua
local DataAPI = require(script.Parent.DataAPI)

game.Players.PlayerAdded:Connect(function(player)
	DataAPI.load(player)
end)

game.Players.PlayerRemoving:Connect(function(player)
	DataAPI.save(player)
end)

DataAPI.autoSave(60)
```

### Creating your own dynamic folders:
```lua
local DataAPI = require(script.Parent.DataAPI)

local newFolders = {
	{
		Name = "test",
		Values = {
			{ 
                Instance = "IntValue",
                StartValue = 0,
                Save = true,
                Name = "test" 
            }
		}
	},
	{
		Name = "test2",
		Values = {
			{ 
                Instance = "IntValue",
                StartValue = 0,
                Save = true,
                Name = "test2" 
            }
		}
	}

}
DataAPI.register(newFolders)

local newFolder = {
	{
		Name = "test",
		Values = {
			{ 
                Instance = "IntValue",
                StartValue = 0,
                Save = true,
                Name = "test" a
            },
            { 
                Instance = "IntValue",
                StartValue = 0,
                Save = true,
                Name = "test2" 
            }
		}
	}
}
DataAPI.register(newFolder)
```

# Software:
[Scripts](./scripts)  
[Roblox Model](https://create.roblox.com/store/asset/115458272351878/DataAPI)