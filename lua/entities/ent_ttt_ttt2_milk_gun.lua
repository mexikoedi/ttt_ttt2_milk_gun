if engine.ActiveGamemode() ~= "terrortown" then return end
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Milk"
ENT.Author = "mexikoedi"
ENT.Contact = "Steam"
ENT.Instructions = "Is only used for the milk gun."
ENT.Purpose = "Milk entity for the milk gun."
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AdminOnly = false
if SERVER then
    AddCSLuaFile()
    function ENT:Initialize()
        self:SetModel("models/props_junk/garbage_milkcarton002a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self.Armed = true
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetMass(5)
        end

        self:GetPhysicsObject():SetMass(2)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Think()
        self.lifetime = self.lifetime or CurTime() + 10
        if CurTime() > self.lifetime then self:Remove() end
    end

    function ENT:Disable()
        self.PhysicsCollide = function() end
        self.lifetime = CurTime() + 15
    end

    function ENT:PhysicsCollide(data)
        local hitEnt = data.HitEntity
        if not IsValid(self) or self.HasHit or not self.Armed then return end
        if not IsValid(hitEnt) or not hitEnt:IsPlayer() or not hitEnt:IsTerror() then
            self.Armed = false
            self:Disable()
            return
        end

        self.HasHit = true
        self.Armed = false
        local dmg = DamageInfo()
        local attacker = self:GetOwner()
        local inflictor = ents.Create("weapon_ttt_ttt2_milk_gun")
        if not IsValid(attacker) then attacker = self end
        dmg:SetAttacker(attacker)
        dmg:SetInflictor(inflictor)
        local r = GetConVar("ttt_milkgun_randomDamage"):GetFloat()
        local rand = math.random(-r, r)
        local dm = GetConVar("ttt_milkgun_damage"):GetInt() + rand
        dmg:SetDamage(dm > 0 and dm or 0)
        dmg:SetDamageType(DMG_GENERIC)
        hitEnt:TakeDamageInfo(dmg)
        local effectdata = EffectData()
        effectdata:SetStart(data.HitPos)
        effectdata:SetOrigin(data.HitPos)
        effectdata:SetScale(1)
        util.Effect("BloodImpact", effectdata)
        self:Disable()
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end