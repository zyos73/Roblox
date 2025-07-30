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


	DynamicFolders = {} -- this is intended to be used by other APIs / Developers who want to control values which need to be saved in runtime
}

return API
