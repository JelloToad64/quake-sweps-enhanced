EFFECT.Model = Model("models/projectiles/quake1/bolt2.mdl")
EFFECT.SpriteMaterial = Material("sprites/q1lightning")

EFFECT.ModelScale = Vector(.75, .75, .75)
EFFECT.SpinRate = 1000000--CurTime * this = spin roll
EFFECT.RandomRoll = math.Rand(0,360)--Random factor added to secondary, teriary, etc... bolt models

function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.Position = data:GetOrigin()
	self.DieTime = .125
	
	local pos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	self:SetRenderBoundsWS(pos, self.Position)
	
	self.Is2D = cvars.Bool("q1_cl_2dlightning")
	
	if !self.Is2D then
		self:SetModel(self.Model)
		self.MyRand = math.Rand(-10, 10)
		local mat = Matrix()
		mat:Scale(self.ModelScale)
		self:EnableMatrix("RenderMultiply", mat)
	end
end

function EFFECT:Think()
	self.DieTime = self.DieTime - FrameTime()
	return self.DieTime > 0
end

function EFFECT:Render()
	local pos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	
	if self.Is2D then
	
		local rot = CurTime() * 2

		render.SetMaterial(self.SpriteMaterial)
		render.DrawBeam(pos, self.Position, 15, rot, rot -1, Color(255, 255, 255, 255))
		render.DrawBeam(pos, self.Position, 25, rot, rot -2, Color(255, 255, 255, 255))
	
	else
	
		local ang = (self.Position - pos):Angle()
		local rot = CurTime()
		ang:RotateAroundAxis(ang:Forward(), rot * self.SpinRate)
		local dist = self.Position:Distance(pos)
		local totaldist = 0
		while totaldist < dist do
			math.randomseed(totaldist + self.MyRand)
			self:SetRenderOrigin(pos + ang:Forward() * totaldist)
			self:SetRenderAngles(ang)
			self:SetupBones()
			self:DrawModel()
			ang:RotateAroundAxis(ang:Forward(), rot * math.Rand(-1,1) * self.RandomRoll / 2)
			totaldist = totaldist + 32 * self.ModelScale.x
		end
		
	end
end