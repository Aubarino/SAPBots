AddCSLuaFile()
include("sapbot/SapUtil.lua")
AddCSLuaFile("sapbot/SapUtil.lua")
local id = "mightyBoot"
local infoAbout = 'Makes sap bots able to use the "Mighty Foot Engaged" addon'
local defaultState = false --the default checkbox state on the toolgun tool, if nil then no tickbox and always active

function MightyFootActionBoot(me) --action boot logic
    if !IsValid(me) then return end
    if IsValid(me.ActionOverrideEnt) then
        if (me:GetPos():Distance(me.ActionOverrideEnt:GetPos()) < 128) then
            local entclass = me.ActionOverrideEnt:GetClass()
            me.ActionOverride = id
        end
    end
end

function SapMightyFootAction(me) --action override code
    if !IsValid(me) then return end
    if (me.ActionOverride == id) then
        me.MFKickTime = 0 --setup for kicking
        me.MFNextKick = 0
        me.MFDrawTime = 0
        if (SAPBOTDEBUG) then
            print("S.A.P Bot "..me.Sap_Name.." attempting to use Mighty Foot Engaged action on entity")
        end
        if (IsValid(me:GetPhysicsObject())) then --avoid erroring via physics
            MightyFootEngaged(me) --the kick
        end

        while !(CurTime() > me.MFNextKick) do --wait until done with kick
            coroutine.wait(0.1)
            coroutine.yield()
        end
    end
end

if (SERVER) then --i hate the forums
    SapActionRegister(id,MightyFootActionBoot,SapMightyFootAction,infoAbout,defaultState,1987521428)
else
    SapActionRegister(id,MightyFootActionBoot,SapMightyFootAction,infoAbout,defaultState,1987521428)
end