local COLOR_QUAKE  = Color(131, 82, 22)
local COLOR_RED    = Color(131, 23, 23)
local COLOR_GREEN  = Color(0, 255, 0) -- test color
local COLOR_HUD_BG  = Color(90, 90, 90)
local COLOR_HUD_BG_ALT  = Color(100, 100, 100)
local COLOR_HUD_TRANS  = Color(0, 0, 0, 0)

function HUD()    
    local client = LocalPlayer()
    local width = 740
    local activeWeapon = client:GetActiveWeapon()
    local ammotext = "0"

    -- if !client:Alive() then
    --     return 
    -- end
    
    if IsValid(activeWeapon) and activeWeapon:GetPrimaryAmmoType() > -1 then
        ammotext = tostring(client:GetAmmoCount(activeWeapon:GetPrimaryAmmoType()))
    end 
    
    local healthcolor = COLOR_QUAKE
    local ammocolor = COLOR_QUAKE

    if client:Health() <= 20 then
        healthcolor = COLOR_RED
    end

    if IsValid(activeWeapon) and client:GetAmmoCount(activeWeapon:GetPrimaryAmmoType()) <= 20 then
        ammocolor = COLOR_RED
    end

    draw.RoundedBox(0, (ScrW()/2)-(width/2), ScrH() - 100, width, 90, COLOR_HUD_BG)
    draw.SimpleText(""..client:Health(), "QuakeFontLarge", (ScrW()/2)+40, ScrH() - 55, healthcolor, 1, 0)
    draw.SimpleText(""..client:Armor(), "QuakeFontLarge", (ScrW()/2)-205, ScrH() - 55, COLOR_QUAKE, 1, 0)
    draw.SimpleText(ammotext, "QuakeFontLarge", (ScrW()/2)+290, ScrH() - 55, ammocolor, 1, 0)

    draw.SimpleText("health", "QuakeFontLarge", (ScrW()/2)+40, ScrH() - 100, healthcolor, 1, 0)
    draw.SimpleText("armor", "QuakeFontLarge", (ScrW()/2)-205, ScrH() - 100, COLOR_QUAKE, 1, 0)
    draw.SimpleText("ammo", "QuakeFontLarge", (ScrW()/2)+290, ScrH() - 100, ammocolor, 1, 0)

end
hook.Add("HUDPaintBackground", "Hud", HUD)

function HideHud(name)
    for k, v in pairs ({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
        if name == v then
            return false
        end
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)

-- vgui for player model

PMPanel = vgui.Create("DPanel")
PMPanel:SetPos((ScrW() / 2) - 130, ScrH() - 100)
PMPanel:SetSize(90, 90)
PMPanel:SetBackgroundColor(COLOR_HUD_TRANS)

local stephMDL = vgui.Create("DModelPanel", PMPanel)
stephMDL:SetSize(PMPanel:GetSize())
stephMDL:SetCamPos(Vector(20, 0.5, 69))   -- Camera position (X, Y, Z)
stephMDL:SetLookAt(Vector(0, 0, 65))    -- Where the camera points (X, Y, Z)
stephMDL:SetFOV(45)                     -- FOV (Lower = closer)
stephMDL:SetModel("models/akuld/qeranger/qeranger.mdl")

local stephENT = stephMDL.Entity
if IsValid(stephENT) then
    stephENT:SetEyeTarget(Vector(12, 0, 64))
end

function stephMDL:LayoutEntity(stephENT) return end

local meruMDL = vgui.Create("DModelPanel", PMPanel)
meruMDL:SetSize(PMPanel:GetSize())
meruMDL:SetCamPos(Vector(20, 1, 65))   -- Camera position (X, Y, Z)
meruMDL:SetLookAt(Vector(0, 0, 67.5))    -- Where the camera points (X, Y, Z)
meruMDL:SetFOV(45)                     -- FOV (Lower = closer)
meruMDL:SetModel("models/alvaroports/samzan/merusuccubuspm.mdl")

local meruENT = meruMDL.Entity
if IsValid(meruENT) then
    meruENT:SetEyeTarget(Vector(12, 0, 64))
end

function meruMDL:LayoutEntity(meruENT) return end

PMPanel.Think = function(self)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    if GetGlobalInt("meru_active") == 1 then
        stephMDL:SetVisible(false)
        meruMDL:SetVisible(true)
    else
        stephMDL:SetVisible(true)
        meruMDL:SetVisible(false)
    end
end


-- vgui for armor
ArmPanel = vgui.Create("DPanel")
ArmPanel:SetPos((ScrW() / 2) -370, ScrH() - 100)
ArmPanel:SetSize(90, 90)
ArmPanel:SetBackgroundColor(COLOR_HUD_TRANS)

local armor = vgui.Create("DModelPanel", ArmPanel)
armor:SetSize(ArmPanel:GetSize())
armor:SetAmbientLight(Color(255, 255, 255))
armor:SetVisible(true)

armor:SetCamPos(Vector(-90, 0, 50))   -- Camera position (X, Y, Z)
armor:SetLookAt(Vector(64, 0, 0))    -- Where the camera points (X, Y, Z)
armor:SetFOV(25)  

local armortype = {
    [0] = "",
    [1] = "models/items/quake1/armor1.mdl",
    [2] = "models/items/quake1/armor2.mdl",
    [3] = "models/items/quake1/armor3.mdl"
}

function armor:Think()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local armorTier = ply:GetNWInt("ArmorTier", 0)
    local targetModel = armortype[armorTier] or ""

    armor:SetModel(targetModel)
end
-- vgui for ammo
AmmoPanel = vgui.Create("DPanel")
AmmoPanel:SetPos((ScrW() / 2) + 120, ScrH() - 100)
AmmoPanel:SetSize(90, 90)
AmmoPanel:SetBackgroundColor(COLOR_HUD_TRANS)

local ammo = vgui.Create("DModelPanel", AmmoPanel)
ammo:SetSize(ArmPanel:GetSize())
ammo:SetAmbientLight(Color(255, 255, 255))
ammo:SetModel("models/items/quake1/ammo_shell0.mdl")
ammo:SetVisible(true)

ammo:SetCamPos(Vector(-90, 0, 30))   -- Camera position (X, Y, Z)
ammo:SetLookAt(Vector(90, 0, 0))    -- Where the camera points (X, Y, Z)
ammo:SetFOV(30)

local ammotype = {
    [-1] = "",
    [44] = "models/items/quake1/ammo_shell0.mdl",
    [41] = "models/items/quake1/ammo_nail0.mdl",
    [43] = "models/items/quake1/ammo_rock0.mdl",
    [38] = "models/items/quake1/ammo_batt0.mdl"
}

function ammo:Think()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local ammoID = LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()
    local targetModel = ammotype[ammoID]

    ammo:SetModel(targetModel)
end