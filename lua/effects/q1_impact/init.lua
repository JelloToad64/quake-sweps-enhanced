function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local ent = data:GetEntity()
	local blood = false
	
	if IsValid(ent) then
		blood = ent:GetBloodColor()
	end

	local emitter = ParticleEmitter(pos)

	if emitter:IsValid() then
		local particleMat = "sprites/qparticle"
		local particleMatScale = 1
		if cvars.Bool("q1_cl_software") then
			particleMat = "sprites/qpixel"
			particleMatScale = .5
		end
		
		for i = 0, 8 do
			local particle = emitter:Add(particleMat, pos + VectorRand() * 8)
			particle:SetAirResistance(0)
			particle:SetGravity(Vector(0, 0, -64))
			particle:SetDieTime(math.Rand(.15, .45))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(1.5 * particleMatScale)
			particle:SetEndSize(1.5 * particleMatScale)
			particle:SetRoll(0)
			particle:SetRollDelta(math.Rand(-.2, .2))
			particle:SetBounce(.5)
			if blood and blood >= 0 then
				if blood == 0 then
					particle:SetColor(math.random(40, 160), 0, 0)
				else
					local col = math.random(50, 180)
					particle:SetColor(col, col, 0)
				end
			else
				local col = math.random(10, 180)
				particle:SetColor(col, col, col)
			end
		end

		emitter:Finish()
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end