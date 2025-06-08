--[[
Author: Zyos
Date: 06/07/2025 DD/MM/YY
Description: Module that contains the dataTree for dataService (script.Parent)
Info: Put this inside of dataService.lua
]]

--Module
local dataTree = {
	["DataStoreName"] = "Test",
	["Folders"] = {
		[1] = {
			["Name"] = "leaderstats",
			["Values"] = {
				[1] = {
					["Instance"] = "NumberValue",
					["StartValue"] = 0,
					["Save"] = true,
					["Name"] = "x"
				}
			}
		}

	}
}	

return dataTree