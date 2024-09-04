AddCSLuaFile()
include("sapbot/SapUtil.lua")
AddCSLuaFile("sapbot/SapUtil.lua")
local id = "grenadeYeet"
local infoAbout = 'Makes sap bots throw grenades back with the "[Vmanip]Grenade Throw back" addon'
local defaultState = false --the default checkbox state on the toolgun tool, if nil then no tickbox and always active

function ThrowBackActionBoot(me) --action grenade yeet boot
    if !IsValid(me) then return end
    if (GetAddonLoaded(3308229964)) then
        if ((SapCheckForGrenadeInRange(me) != nil)) then
            me.ActionOverride = id
        end
    end
end

function SapCheckForGrenadeInRange(ply)
    local grenades = nil
    local center = ply:GetPos() + ply:GetForward()*GetConVarNumber('vmanip_grenadethrowback_allowradius')
    local entities = ents.FindInSphere(center, GetConVarNumber('vmanip_grenadethrowback_allowradius') * 2)
    for _, ent in ipairs(entities) do
        if ent:IsValid() and ent:GetClass() == "npc_grenade_frag" then
            grenades = ent
        end
    end
    return grenades
end

function SapLaunchGrenadeAtPlayerDirection(grenade, direction)
    if IsValid(grenade) then
        local phys = grenade:GetPhysicsObject()
        phys:SetVelocity(direction*GetConVarNumber('vmanip_grenadethrowback_throwstrength'))
    end
end

function SapThrowGrenade(ply) --all of these functions are directly based on the grenade yeet addon thing, i simply adapted them to saps, cause its all damn local functions
    if GetConVarNumber('vmanip_grenadethrowback_enable') == 1 then
        if not ply.Vmanip_YeetGrenadeCD then
            ply.Vmanip_YeetGrenadeCD = CurTime() + 1
        end
        local grenade = SapCheckForGrenadeInRange(ply)

        if ((SapCheckForGrenadeInRange(ply) != nil) && (ply.Vmanip_YeetGrenadeCD < CurTime())) then
            ply.Vmanip_YeetGrenadeCD = CurTime() + GetConVarNumber('vmanip_grenadethrowback_cd')
            net.Start("Vmanip_YeetGrenade")
            net.Send(ply)
            ply:EmitSound('VmanipYeetGrenade_Grenade')
            ply:EmitSound('VmanipYeetGrenade_Throw')

            if IsValid(grenade) and ply:Alive() then --animation in advance
                ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_THROW)
            end
            timer.Simple(0.15, function()
                if IsValid(grenade) and ply:Alive() then
                    SapLaunchGrenadeAtPlayerDirection(grenade, ply:GetAimVector()*20+Vector(0,0,10))
                end
            end)
        end
    end
end

function SapThrowBackAction(me) --action override grenade yeet code
    if !IsValid(me) then return end
    if (me.ActionOverride == id) then
        if (SAPBOTDEBUG) then
            print("S.A.P Bot "..me.Sap_Name.." attempting to throw back grenade using Grenade Throw back addon")
        end
        SapThrowGrenade(me)
    end
end

if (SERVER) then --i hate the forums
    SapActionRegister(id,ThrowBackActionBoot,SapThrowBackAction,infoAbout,defaultState,3308229964)
else
    SapActionRegister(id,ThrowBackActionBoot,SapThrowBackAction,infoAbout,defaultState,3308229964)
end