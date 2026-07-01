local COLOR_QUAKE  = Color(220, 140, 40, 255)
local COLOR_RED    = Color(255, 0, 0, 255)

function HUD()
    local client = LocalPlayer()
    local width = 750
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

    draw.RoundedBox(10, (ScrW()/2)-(width/2), ScrH() - 100, width, 90, Color(50, 50, 50, 200))
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
mdl:SetModel("models/akuld/qeranger/qeranger.mdl")

mdl:SetCamPos(Vector(20, 0.5, 69))   -- Camera position (X, Y, Z)
mdl:SetLookAt(Vector(0, 0, 65))    -- Where the camera points (X, Y, Z)
mdl:SetFOV(45)                     -- FOV (Lower = closer)

local ent = mdl.Entity
if IsValid(ent) then
    ent:SetEyeTarget(Vector(12, 0, 64))
end

function mdl:LayoutEntity(ent) return end

-- vgui for armor
ArmPanel = vgui.Create("DPanel")
ArmPanel:SetPos((ScrW() / 2) + 280, ScrH() - 100)
ArmPanel:SetSize(90, 90)
ArmPanel:SetBackgroundColor(Color(0, 255, 0))

local armor = vgui.Create("DModelPanel", ArmPanel)
armor:SetSize(ArmPanel:GetSize())
armor:SetModel("models/items/quake1/armor1.mdl")
armor:SetVisible(true)

armor:SetCamPos(Vector(-90, 0, 50))   -- Camera position (X, Y, Z)
armor:SetLookAt(Vector(64, 0, 0))    -- Where the camera points (X, Y, Z)
armor:SetFOV(25)  

function armor:Think()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    -- 1. Get the raw value
    local activeTier = ply:GetNWInt("QuakeArmorTier", 0)
    
    -- 2. Defensive check: If armor > 0 but Tier is 0, something is broken. 
    -- Force a refresh or default to Tier 1 if the player has armor but no tier is set.
    if ply:Armor() > 0 and activeTier == 0 then
        activeTier = 1 
    end

    -- 3. Calculate model path safely
    local models = {
        [1] = "models/items/quake1/armor1.mdl",
        [2] = "models/items/quake1/armor2.mdl",
        [3] = "models/items/quake1/armor3.mdl"
    }
    local targetModel = models[activeTier] or models[1]

    -- 4. Only update if the entity is actually valid and needs a change
    if self.CurrentModel ~= targetModel then
        self:SetModel(targetModel)
        self.CurrentModel = targetModel
        
        -- Reset the entity view if it exists
        if IsValid(self.Entity) then
            self.Entity:SetAngles(Angle(0, 45, 0)) -- Set a standard rotation
        end
    end
    
    -- 5. Visibility toggle
    self:SetVisible(ply:Armor() > 0)
end

-- vgui for ammo
AmmoPanel = vgui.Create("DPanel")
AmmoPanel:SetPos((ScrW() / 2) - 370, ScrH() - 100)
AmmoPanel:SetSize(90, 90)
AmmoPanel:SetBackgroundColor(Color(0, 255, 0))

local ammo = vgui.Create("DModelPanel", AmmoPanel)
ammo:SetSize(ArmPanel:GetSize())
ammo:SetModel("models/items/quake1/armor1.mdl")
ammo:SetVisible(true)

ammo:SetCamPos(Vector(-90, 0, 50))   -- Camera position (X, Y, Z)
ammo:SetLookAt(Vector(64, 0, 0))    -- Where the camera points (X, Y, Z)
ammo:SetFOV(25)  