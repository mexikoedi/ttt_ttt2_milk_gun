if engine.ActiveGamemode( ) != "terrortown" then return end

if SERVER then
    AddCSLuaFile( )
    resource.AddFile( "materials/vgui/ttt/weapon_milk_gun.vmt" )
    resource.AddFile( "sound/milk.wav" )
    resource.AddFile( "sound/milk_altfire.wav" )
end

SWEP.PrintName = "Milk Gun"
SWEP.Author = "mexikoedi"
SWEP.Icon = "vgui/ttt/weapon_milk_gun"
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP1

SWEP.CanBuy = { ROLE_TRAITOR }

SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true

SWEP.EquipMenuData = {
    type = "Weapon" ,
    desc = "You have too much milk."
}

SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.AutoSpawnable = false
SWEP.HoldType = "pistol"
SWEP.Primary.ClipSize = GetConVar( "ttt_milkgun_clipSize" ):GetInt( )
SWEP.Primary.DefaultClip = GetConVar( "ttt_milkgun_ammo" ):GetInt( )
SWEP.Primary.Automatic = GetConVar( "ttt_milkgun_automaticFire" ):GetBool( )
SWEP.Primary.RPS = GetConVar( "ttt_milkgun_rps" ):GetFloat( )
SWEP.Primary.Ammo = "none"
SWEP.Weight = 7
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
local ShootSound = Sound( "milk.wav" )
local SecondSound = Sound( "milk_altfire.wav" )

function SWEP:Initialize( )
    if ( CLIENT ) then return end
    self.Primary.ClipSize = GetConVar( "ttt_milkgun_clipSize" ):GetInt( )
    self.Primary.DefaultClip = GetConVar( "ttt_milkgun_ammo" ):GetInt( )
    self.Primary.Automatic = GetConVar( "ttt_milkgun_automaticFire" ):GetBool( )
    self.Primary.RPS = GetConVar( "ttt_milkgun_rps" ):GetFloat( )
end

function SWEP:PrimaryAttack( )
    self:SetNextPrimaryFire( CurTime( ) + 1 / self.Primary.RPS )
    if !self:CanPrimaryAttack( ) then return end
    self:TakePrimaryAmmo( 1 )
    self:EmitSound( ShootSound )
    if ( CLIENT ) then return end
    local ent = ents.Create( "sent_milkgun" )
    if ( !IsValid( ent ) ) then return end
    ent:SetModel( "models/props_junk/garbage_milkcarton002a.mdl" )
    ent:SetAngles( self:GetOwner( ):EyeAngles( ) )
    ent:SetPos( self:GetOwner( ):EyePos( ) + ( self:GetOwner( ):GetAimVector( ) * 16 ) )
    ent:SetOwner( self:GetOwner( ) ) // Prevents all normal phys damage to all entities for whatever reason, but we actually want this to be the case
    ent:Spawn( )
    ent.Owner = self:GetOwner( )
    ent:Activate( )
    util.SpriteTrail( ent , 0 , Color( 255 , 255 , 255 ) , false , 16 , 1 , 6 , 1 / ( 15 + 1 ) * 0.5 , "trails/laser.vmt" )
    local phys = ent:GetPhysicsObject( )

    if ( !IsValid( phys ) ) then
        ent:Remove( )

        return
    end

    phys:SetMass( 2 )
    phys:SetVelocity( self:GetOwner( ):GetAimVector( ) * 100000 )
    local anglo = Angle( -10 , -5 , 0 )
    self:GetOwner( ):ViewPunch( anglo )
end

function SWEP:SecondaryAttack( )
    self:SetNextSecondaryFire( CurTime( ) + 5 )

    if SERVER then
        self.currentOwner = self:GetOwner( )
        self:GetOwner( ):EmitSound( SecondSound )
    end
end

function SWEP:Holster( )
    if SERVER && IsValid( self.currentOwner ) then
        self.currentOwner:StopSound( "milk_altfire.wav" )
    end

    return true
end

function SWEP:OnRemove( )
    if SERVER && IsValid( self.currentOwner ) then
        self.currentOwner:StopSound( "milk_altfire.wav" )
    end
end

function SWEP:OnDrop( )
    if SERVER && IsValid( self.currentOwner ) then
        self.currentOwner:StopSound( "milk_altfire.wav" )
    end
end
