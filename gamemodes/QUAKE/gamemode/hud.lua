local COLOR_QUAKE  = Color(220, 140, 40, 255)
local COLOR_RED    = Color(255, 0, 0, 255)

function HUD()
    local client = LocalPlayer()
    local width = 500
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

    -- draw.RoundedBox(10, (ScrW()/2)-(width/2), ScrH() - 100, width, 90, Color(50, 50, 50, 200))
    draw.SimpleText(""..client:Health(), "QuakeFontLarge", (ScrW()/2)-35, ScrH() - 55, healthcolor, 1, 0)
    draw.SimpleText(""..client:Armor(), "QuakeFontLarge", (ScrW()/2)+220, ScrH() - 55, COLOR_QUAKE, 1, 0)
    draw.SimpleText(ammotext, "QuakeFontLarge", (ScrW()/2)-220, ScrH() - 55, ammocolor, 1, 0)

    draw.SimpleText("health", "QuakeFontLarge", (ScrW()/2)-35, ScrH() - 100, healthcolor, 1, 0)
    draw.SimpleText("armor", "QuakeFontLarge", (ScrW()/2)+220, ScrH() - 100, COLOR_QUAKE, 1, 0)
    draw.SimpleText("ammo", "QuakeFontLarge", (ScrW()/2)-220, ScrH() - 100, ammocolor, 1, 0)

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
PMPanel:SetPos((ScrW() / 2) + 35, ScrH() - 100)
PMPanel:SetSize(90, 90)
PMPanel:SetBackgroundColor(Color(0, 255, 0, 255))

local mdl = vgui.Create("DModelPanel", PMPanel)
mdl:SetSize(PMPanel:GetSize())
mdl:SetModel("models/player/quakeguy.mdl")

mdl:SetCamPos(Vector(12, 0, 64))   -- Camera position (X, Y, Z)
mdl:SetLookAt(Vector(0, 0, 64))    -- Where the camera points (X, Y, Z)
mdl:SetFOV(90)                     -- FOV (Lower = closer)

local ent = mdl.Entity
if IsValid(ent) then
    ent:SetEyeTarget(Vector(12, 0, 64))
end

function mdl:LayoutEntity(ent) return end

-- vgui for armor
ArmPanel = vgui.Create("DPanel")
ArmPanel:SetPos((ScrW() / 2) + 280, ScrH() - 100)
ArmPanel:SetSize(90, 90)
ArmPanel:SetBackgroundColor(Color(0, 255, 0, 0))

local armor = vgui.Create("DModelPanel", ArmPanel)
armor:SetSize(ArmPanel:GetSize())
armor:SetModel("models/items/quake1/armor1.mdl")
armor:SetVisible(false)

armor:SetCamPos(Vector(-90, 0, 50))   -- Camera position (X, Y, Z)
armor:SetLookAt(Vector(64, 0, 0))    -- Where the camera points (X, Y, Z)
armor:SetFOV(25)  

function armor:Think()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local currentArmor = ply:Armor()

    -- If armor is 0, turn the panel off completely
    if currentArmor <= 0 then
        if self:IsVisible() then self:SetVisible(false) end
        return
    else
        if not self:IsVisible() then self:SetVisible(true) end
    end

    -- Check what tier the player has active
    local activeTier = ply:GetNWInt("QuakeArmorTier", 1)
    local targetModel = "models/items/quake1/armor1.mdl" -- Default Green

    if activeTier == 2 then
        targetModel = "models/items/quake1/armor2.mdl" -- Yellow
    elseif activeTier == 3 then
        targetModel = "models/items/quake1/armor3.mdl" -- Red
    end

    -- Only update the model if it actually changed to save performance
    if self.CurrentModel ~= targetModel then
        self:SetModel(targetModel)
        self.CurrentModel = targetModel
    end
end