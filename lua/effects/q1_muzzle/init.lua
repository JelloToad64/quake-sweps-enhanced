function EFFECT:Init(data)
	if !cvars.Bool("q1_cl_firelight") then return end
	local dynlight = DynamicLight(self:EntIndex())
	dynlight.Pos = data:GetOrigin()
	dynlight.Size = 128
	dynlight.Decay = 2000
	dynlight.R = 255
	dynlight.G = 200
	dynlight.B = 80
	dynlight.Brightness = 5
	dynlight.DieTime = CurTime()+.05
end

function EFFECT:Render()
end