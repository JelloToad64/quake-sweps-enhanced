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

    draw.RoundedBox(10, (ScrW()/2)-(width/2), ScrH() - 100, width, 90, Color(50, 50, 50, 200))
    draw.SimpleText(""..client:Health(), "QuakeFontLarge", (ScrW()/2)-35, ScrH() - 55, healthcolor, 1, 0)
    draw.SimpleText(""..client:Armor(), "QuakeFontLarge", (ScrW()/2)+180, ScrH() - 55, COLOR_QUAKE, 1, 0)
    draw.SimpleText(ammotext, "QuakeFontLarge", (ScrW()/2)-180, ScrH() - 55, ammocolor, 1, 0)

    draw.SimpleText("health", "QuakeFontLarge", (ScrW()/2)-35, ScrH() - 100, healthcolor, 1, 0)
    draw.SimpleText("armor", "QuakeFontLarge", (ScrW()/2)+180, ScrH() - 100, COLOR_QUAKE, 1, 0)
    draw.SimpleText("ammo", "QuakeFontLarge", (ScrW()/2)-180, ScrH() - 100, ammocolor, 1, 0)

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
BGPanel = vgui.Create("DPanel")
BGPanel:SetPos((ScrW() / 2) + 35, ScrH() - 100)
BGPanel:SetSize(90, 90)
BGPanel:SetBackgroundColor(Color(0, 0, 0, 0))

local mdl = vgui.Create("DModelPanel", BGPanel)
mdl:SetSize(BGPanel:GetSize())

-- Turn off default rotation behavior
function mdl:LayoutEntity(ent)
    return
end

function mdl:Think()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local currentModel = ply:GetModel()

    -- Only rebuild the camera and model if the player's model actually changes
    if self.LastModel ~= currentModel then
        self:SetModel(currentModel)
        self.LastModel = currentModel

        local ent = self.Entity
        if IsValid(ent) then
            -- Safely search for the classic Source head bone
            local headBone = ent:LookupBone("ValveBiped.Bip01_Head1") or ent:LookupBone("ValveBIP01.Bip01_Head1")
            local eyepos = Vector(3, 0, 66) -- Reliable fallback height if bone isn't found immediately

            if headBone then
                eyepos = ent:GetBonePosition(headBone) + Vector(3, 0, 2)
            end

            -- Apply your exact camera placement rules relative to the head
            self:SetLookAt(eyepos)
            self:SetCamPos(eyepos - Vector(-12, 0, 0)) -- Uses your specific offset
            ent:SetEyeTarget(eyepos - Vector(-12, 0, 0))
        end
    end
end