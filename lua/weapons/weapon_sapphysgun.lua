--AddCSLuaFile()
AddCSLuaFile()

SWEP.PrintName = "S.A.P Internal Physics Gun"
SWEP.Category = "Other"
SWEP.Author = "Aubarino"
SWEP.Purpose = "A dummy physgun swep that S.A.P Bots use, not intended for players"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"

if CLIENT then
	--SWEP.WepSelectIcon = surface.GetTextureID( "entities/weapon_sapphysgun" )
	SWEP.IconOverride = "materials/entities/weapon_sapphysgun.png"
	--killicon.Add( "mc_weapon_axe_diamond", "mc/hud/weapons/axe/diamond", Color( 255, 255, 255, 255 ) )
end

--SWEP.Base = "weapon_base"
SWEP.HoldType = "physgun"

SWEP.DrawAmmo = false
SWEP.Slot = 0
SWEP.SlotPos = 3

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Primary.Damage = 0
SWEP.Primary.Power = 0
SWEP.Primary.Speed = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.UseHands = true

-- function SWEP:SetupDataTables()
-- 	self:NetworkVar("Bool", 0, "Firing")
-- 	self:NetworkVar("Entity", 0, "GrabbedEnt")
-- 	self:NetworkVar("Int", 0, "GrabbedBone")
-- 	self:NetworkVar("Vector", 0, "GrabbedLocalPos")
-- 	self:NetworkVar("Float", 0, "GrabbedDist")
-- end

function SWEP:Initialize()
	self:SetHoldType("physgun")
	self:SetWeaponHoldType( "physgun" )
	self:SetSkin(1)
end

function SWEP:GetName()
	return("S.A.P Internal Physics Gun")
end

function SWEP:Deploy()
	--self:SetHoldType( "physgun" )
	self:SetWeaponHoldType( "physgun" )
	--self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
end

function SWEP:Reload()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:SecondaryAttack() end

function SWEP:OnDrop()
	self:SetFiring(false)
	self:SetGrabbedEnt()
end

list.Set( "WEAPON", "S.A.P Internal Physics Gun", {
	Name = "S.A.P Internal Physics Gun",
	Class = "weapon_sapphysgun",
	Category = "Other"
})

