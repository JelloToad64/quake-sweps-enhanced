local path = "sprites/s_explod"
EFFECT.mat = Material(path)
local exists = file.Exists("materials/"..path..".vtf", "GAME")

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	
	if cvars.Bool("q1_cl_firelight") then
		local dynlight = DynamicLight(0)
		dynlight.Pos = pos
		dynlight.Size = 128
		dynlight.Decay = 220
		dynlight.R = 255
		dynlight.G = 220
		dynlight.B = 120
		dynlight.Brightness = 6
		dynlight.DieTime = CurTime()+.5
	end	

	self.Time = 0
	self.Size = 0
	
	local emitter = ParticleEmitter(pos)
	local ply = LocalPlayer()
	local eyevec = IsValid(ply) and ply:EyeAngles():Forward() or Vector()

	if emitter:IsValid() then
		local particleMat = "sprites/qparticle"
		local particleMatScale = 1
		if cvars.Bool("q1_cl_software") then
			particleMat = "sprites/qpixel"
			particleMatScale = .5
		end
	
		local glow = emitter:Add("sprites/glow04_noz", pos - eyevec * 32)
		glow:SetVelocity(eyevec * 32)
		glow:SetDieTime(.6)
		glow:SetStartAlpha(60)
		glow:SetEndAlpha(0)
		glow:SetStartSize(180)
		glow:SetEndSize(64)
		glow:SetColor(255, 160, 0)
		
		for i = 0, 255 do
			local velNorm = norm * 64
			local velRand = VectorRand() * 256
			local dieTime = math.Rand(.4, .5)
			
			if i >= 128 then
				velNorm = velNorm * 6
				velRand = velRand * 2
				dieTime = dieTime * .75
			end
			
			local particle = emitter:Add(particleMat, pos + norm * 8 + VectorRand() * 8)
			particle:SetCollide(true)
			particle:SetAirResistance(50)
			particle:SetBounce(2)
			particle:SetVelocity(velNorm + velRand)
			particle:SetDieTime(dieTime)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2.5 * particleMatScale)
			particle:SetEndSize(2.75 * particleMatScale)
			particle:SetColor(255, math.random(120, 255), 0)		
		end

		emitter:Finish()
	end
end

function EFFECT:Think()
	self.Time = self.Time + FrameTime()
	self.Size = 110 * self.Time^.2	
	return self.Time < .6
end	

function EFFECT:Render()
	local Pos = self:GetPos() + (EyePos()-self:GetPos()):GetNormal()

	render.SetMaterial(self.mat)
	if exists then
		self.mat:SetInt("$frame", math.Clamp(math.floor(self.Time*10), 0, 5))
	end
	render.DrawSprite(Pos, self.Size, self.Size)
end