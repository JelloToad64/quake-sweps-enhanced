include('shared.lua')

net.Receive("QuakePowerupsClient", function()
	local ply, t = net.ReadEntity(), net.ReadTable()
	if IsValid(ply) then
		ply.QuakePowerups = t
	end
end)

local function FadeBlink()
	LocalPlayer():ScreenFade(SCREENFADE.IN, Color(255, 255, 0, 30), .3, 0)
end

local function AddPowerupOverlay(pTime, col)
	local CT = CurTime()
	if pTime and pTime > CT then
		surface.SetDrawColor(col)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		
		local time = pTime - CT
		if time < 3.1 and time > 2.9 then
			FadeBlink()
		elseif time < 2.1 and time > 1.9 then
			FadeBlink()
		elseif time < 1.1 and time > 0.9 then
			FadeBlink()
		end
	end
end

local function MakeLight(ply, col)
	if !cvars.Bool("q1_cl_firelight") then return end
	local dlight = DynamicLight(ply:EntIndex())
	if dlight then
		dlight.Pos = ply:WorldSpaceCenter()
		dlight.R = col[1]
		dlight.G = col[2]
		dlight.B = col[3]
		dlight.Brightness = 5
		dlight.Decay = 512
		dlight.Size = 192
		dlight.DieTime = CurTime() + 1
	end
end

local function PowerupLights(ply)
	local t = ply.QuakePowerups
	if !t then return end
	
	if t.QuadDamage and t.QuadDamage > CurTime() then
		MakeLight(ply, {100, 100, 255})
	end
	
	if t.Pentagram and t.Pentagram > CurTime() then
		MakeLight(ply, {200, 255, 120})
	end
end

hook.Add("HUDPaintBackground", "QuakePowerupsHUD", function()
	local t = LocalPlayer().QuakePowerups
	if !t then return end
	
	AddPowerupOverlay(t.QuadDamage, Color(0, 0, 255, 50))
	AddPowerupOverlay(t.Pentagram, Color(255, 255, 0, 50))
	AddPowerupOverlay(t.Invisibility, Color(180, 180, 255, 50))
	AddPowerupOverlay(t.Biosuit, Color(0, 255, 0, 50))
end)

hook.Add("PostRender", "QuakePowerupsLight", function()
	local ply = LocalPlayer()
	if !ply:ShouldDrawLocalPlayer() then
		PowerupLights(ply)
	end
end)

hook.Add("PostPlayerDraw", "QuakePowerupsLight", function(ply)
	PowerupLights(ply)
end)

function ENT:Initialize()
	self.Rotate = 0
	self.RotateTime = CurTime()
end

function ENT:Draw()
	self:DrawModel()
	self.Rotate = (CurTime() - self.RotateTime)*100
	if self.Rotate >= 360 then
		self.RotateTime = CurTime()
	end
	self:SetAngles(Angle(0,self.Rotate,0))
end