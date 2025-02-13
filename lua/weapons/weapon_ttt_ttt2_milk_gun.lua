if engine.ActiveGamemode() ~= "terrortown" then return end
if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/vgui/ttt/weapon_milk_gun.vmt")
    resource.AddFile("sound/milk.wav")
    resource.AddFile("sound/milk_altfire.wav")
end

SWEP.PrintName = "Milk Gun"
SWEP.Author = "mexikoedi"
SWEP.Contact = "Steam"
SWEP.Instructions = "You can shoot with primary attack and make a sound with secondary attack."
SWEP.Purpose = "Give milk bags to everyone."
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.Icon = "vgui/ttt/weapon_milk_gun"
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true
SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "Milk Gun",
    desc = "Shoot and play a sound with primary attack. Use secondary attack to hear a different sound."
}

SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.AutoSpawnable = false
SWEP.HoldType = "pistol"
SWEP.Primary.ClipSize = GetConVar("ttt_milkgun_clipSize"):GetInt()
SWEP.Primary.DefaultClip = GetConVar("ttt_milkgun_ammo"):GetInt()
SWEP.Primary.Automatic = GetConVar("ttt_milkgun_automaticFire"):GetBool()
SWEP.Primary.RPS = GetConVar("ttt_milkgun_rps"):GetFloat()
SWEP.Primary.Ammo = "none"
SWEP.Weight = 7
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
local ShootSound = Sound("milk.wav")
local SecondSound = Sound("milk_altfire.wav")
function SWEP:Initialize()
    if CLIENT then return end
    self.Primary.ClipSize = GetConVar("ttt_milkgun_clipSize"):GetInt()
    self.Primary.DefaultClip = GetConVar("ttt_milkgun_ammo"):GetInt()
    self.Primary.Automatic = GetConVar("ttt_milkgun_automaticFire"):GetBool()
    self.Primary.RPS = GetConVar("ttt_milkgun_rps"):GetFloat()
end

if SERVER then
    function SWEP:PrimaryAttack()
        self.currentOwner = self:GetOwner()
        if not IsValid(self.currentOwner) then return end
        self:SetNextPrimaryFire(CurTime() + 1 / self.Primary.RPS)
        if not self:CanPrimaryAttack() then return end
        self:TakePrimaryAmmo(1)
        if GetConVar("ttt_milkgun_primary_sound"):GetBool() then self.currentOwner:EmitSound(ShootSound) end
        self.currentOwner:LagCompensation(true)
        local ent = ents.Create("ent_ttt_ttt2_milk_gun")
        if not IsValid(ent) then
            self.currentOwner:LagCompensation(false)
            return
        end

        ent:SetModel("models/props_junk/garbage_milkcarton002a.mdl")
        ent:SetAngles(self.currentOwner:EyeAngles())
        ent:SetPos(self.currentOwner:EyePos() + self.currentOwner:GetAimVector() * 16)
        ent.Owner = self.currentOwner
        ent:SetOwner(self.currentOwner)
        ent:SetPhysicsAttacker(self.currentOwner)
        ent.fingerprints = self.fingerprints
        ent:Spawn()
        ent:Activate()
        util.SpriteTrail(ent, 0, Color(255, 255, 255), false, 16, 1, 6, 1 / (15 + 1) * 0.5, "trails/laser.vmt")
        local phys = ent:GetPhysicsObject()
        if not IsValid(phys) then
            ent:Remove()
            self.currentOwner:LagCompensation(false)
            return
        end

        phys:SetMass(2)
        phys:SetVelocity(self.currentOwner:GetAimVector() * 100000)
        local anglo = Angle(-10, -5, 0)
        self.currentOwner:ViewPunch(anglo)
        self.currentOwner:LagCompensation(false)
    end

    function SWEP:SecondaryAttack()
        self:SetNextSecondaryFire(CurTime() + 5)
        if GetConVar("ttt_milkgun_secondary_sound"):GetBool() then
            self.currentOwner = self:GetOwner()
            if IsValid(self.currentOwner) then self.currentOwner:EmitSound(SecondSound) end
        end
    end

    function SWEP:Holster()
        if IsValid(self.currentOwner) then self.currentOwner:StopSound(SecondSound) end
        return true
    end

    function SWEP:OnRemove()
        if IsValid(self.currentOwner) then self.currentOwner:StopSound(SecondSound) end
    end

    function SWEP:OnDrop()
        if IsValid(self.currentOwner) then self.currentOwner:StopSound(SecondSound) end
    end
end