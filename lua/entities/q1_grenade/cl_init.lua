include('shared.lua')

killicon.Add( "q1_grenade", "weapons/rock_icon", Color( 255, 80, 0, 255 ) )

function ENT:Draw()
	self:DrawModel()
	
	if FrameTime() == 0 then return end
	
	local pos = self:GetPos()

	if !self.emitter and !IsValid(self.emitter) then
		self.emitter = ParticleEmitter(pos)
	end
	if IsValid(self.emitter) then
		local particleMat = "sprites/qparticle"
		local particleMatScale = 1
		if cvars.Bool("q1_cl_software") then
			particleMat = "sprites/qpixel"
			particleMatScale = .5
		end
		
		local col = math.random(40, 160)
		local smoke = self.emitter:Add(particleMat, pos + VectorRand() * 2)
		smoke:SetGravity(Vector(0, 0, math.Rand(60, 100)))
		smoke:SetDieTime(math.Rand(.25, .5))
		smoke:SetStartAlpha(255)
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(1 * particleMatScale)
		smoke:SetEndSize(1 * particleMatScale)
		smoke:SetColor(col, col, col)
		
		self.emitter:Draw()
	end
end

function ENT:OnRemove()
	if self.emitter and IsValid(self.emitter) then
		self.emitter:Finish()
	end
end