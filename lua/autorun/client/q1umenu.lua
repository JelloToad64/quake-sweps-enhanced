local function Q1_SettingsPanel(Panel)
	Panel:AddControl("Label", {Text = "Server"})
	Panel:AddControl("CheckBox", {Label = "HQ Sounds", Command = "q1_sv_hqsounds"})
	Panel:AddControl("CheckBox", {Label = "Impact Particles", Command = "q1_sv_impactparticles"})
	Panel:AddControl("CheckBox", {Label = "Player Sounds", Command = "q1_sv_playersounds"})
	Panel:AddControl("CheckBox", {Label = "Unlimited Ammo", Command = "q1_sv_unlimitedammo"})
	Panel:AddControl("Label", {Text = "Client"})
	Panel:AddControl("CheckBox", {Label = "View Bobbing", Command = "q1_cl_viewbob"})
	Panel:AddControl("CheckBox", {Label = "Fire Lighting", Command = "q1_cl_firelight"})
	Panel:AddControl("CheckBox", {Label = "Software skins", Command = "q1_cl_software"})
	Panel:AddControl("CheckBox", {Label = "2D Lightning", Command = "q1_cl_2dlightning"})
	Panel:AddControl("Slider", {Label = "Bobbing style", Command = "q1_cl_bobstyle", Type = "Integer", Min = 0, Max = 2})
	Panel:AddControl("Slider", {Label = "Crosshair", Command = "q1_cl_crosshair", Type = "Integer", Min = 0, Max = 2})
end

local function Q1_PopulateToolMenu()
	spawnmenu.AddToolMenuOption("Utilities", "Quake", "Q1Settings", "Quake 1", "", "", Q1_SettingsPanel)
end

hook.Add("PopulateToolMenu", "Q1_PopulateToolMenu", Q1_PopulateToolMenu)