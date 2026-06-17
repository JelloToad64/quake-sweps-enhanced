include('shared.lua')

function ENT:EmitParticle()
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
        
        local fire = self.emitter:Add(particleMat, pos + VectorRand() * 4)
        fire:SetGravity(Vector(0, 0, math.Rand(60, 100)))
        fire:SetDieTime(math.Rand(.5, 1))
        fire:SetStartAlpha(255)
        fire:SetEndAlpha(0)
        fire:SetStartSize(2 * particleMatScale)
        fire:SetEndSize(2 * particleMatScale)
        local r, g, b = 255, math.random(150, 200), 0
        local startTime = CurTime()
        fire:SetColor(r, g, b)
        fire:SetNextThink(CurTime())
        fire:SetThinkFunction( function( p )
            local t = (CurTime() - startTime) * 30
            r = math.max(r - t, 100)
            g = math.max(g - t, 100)
            b = math.min(b + t, 100)
            p:SetColor(r, g, b)
            p:SetNextThink(CurTime())
        end )

        local col = math.random(60, 180)
        local smoke = self.emitter:Add(particleMat, pos + VectorRand() * 4)
        smoke:SetGravity(Vector(0, 0, math.Rand(60, 100)))
        smoke:SetDieTime(math.Rand(.7, 1))
        smoke:SetStartAlpha(255)
        smoke:SetEndAlpha(0)
        smoke:SetStartSize(2 * particleMatScale)
        smoke:SetEndSize(2 * particleMatScale)
        smoke:SetColor(col, col, col)

        self.emitter:Draw()
    end
end

-- Using Think for the light ensures it updates smoothly every frame
function ENT:Think()
    -- Create/Update the Dynamic Light
    local dlight = DynamicLight( self:EntIndex() )
    
    if dlight then
        dlight.pos = self:GetPos()
        dlight.r = 255
        dlight.g = 120
        dlight.b = 0
        -- Give it a subtle retro flicker to match the Quake particles
        dlight.brightness = math.Rand( 3, 4 )
        dlight.Size = math.random( 250, 300 )
        
        dlight.Decay = 1000
        dlight.DieTime = CurTime() + 0.1
        dlight.style = 0 
    end
end

function ENT:Draw()
    self:DrawModel()

    if CurTime() - self:GetCreationTime() < .04 then return end
    
    self:EmitParticle()
end

function ENT:OnRemove()
    if self.emitter and IsValid(self.emitter) then
        self.emitter:Finish()
    end
end