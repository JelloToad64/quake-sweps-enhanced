ENT.Type = "anim"
ENT.PrintName = "Nails"
ENT.Author = "upset"
ENT.Spawnable = false

local q1_cvar_impact = GetConVar("q1_sv_impactparticles")

function ENT:ImpactEffect(tr)
	if q1_cvar_impact:GetBool() and !tr.HitSky then
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos + tr.HitNormal * 4)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetEntity(tr.Entity)
		util.Effect("q1_impact", effectdata)
	else
		local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetStart(tr.StartPos)
		e:SetSurfaceProp(tr.SurfaceProps)
		e:SetDamageType(DMG_BULLET)
		e:SetHitBox(tr.HitBox)
		if CLIENT then
			e:SetEntity(tr.Entity)
		else
			e:SetEntIndex(tr.Entity:EntIndex())
		end
		util.Effect("Impact", e)
	end
end