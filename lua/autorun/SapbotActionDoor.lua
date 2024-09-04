AddCSLuaFile()
include("sapbot/SapUtil.lua")
AddCSLuaFile("sapbot/SapUtil.lua")
local id = "door"
local infoAbout = 'Makes sap bots detect and go through doors'
local defaultState = true --the default checkbox state on the toolgun tool, if nil then no tickbox and always active

function DoorActionBoot(me) --simple door opening action override boot function
    if !IsValid(me) then return end
    if IsValid(me.ActionOverrideEnt) then
        if (me:GetPos():Distance(me.ActionOverrideEnt:GetPos()) < 128) then
            local entclass = me.ActionOverrideEnt:GetClass()
            if ((entclass == "prop_door_rotating" or entclass == "func_door" or entclass == "func_door_rotating") && !me.Fun_IgnoreDoor) then
                me.ActionOverride = id
            end
        end
    end
end

function SapDoorAction(me) --simple door opening action override function
    if !IsValid(me) then return end
    if (me.ActionOverride == id && !me.Fun_IgnoreDoor) then
        me.ActionOverrideEnt:Fire("Use") --open door

        local doormodelmin, doormodelmax = me.ActionOverrideEnt:GetModelBounds()
        local doormodeloffset = doormodelmin + (doormodelmax * 0.5)
        local leavedoor = me.ActionOverrideEnt:GetPos() + (me.ActionOverrideAngle * -110) - doormodeloffset
        local prepdoor = me.ActionOverrideEnt:GetPos() + (me.ActionOverrideAngle * 110) - doormodeloffset
        local walkingintodoor = 1
        local options = {}
        local path = Path( "Follow" )
        path:SetMinLookAheadDistance( options.lookahead or 300 )
        path:SetGoalTolerance( options.tolerance or 20 )
        me.Walking = true
        me.loco:SetDesiredSpeed( 200 )
        me.loco:SetAcceleration(800)
        while (walkingintodoor != 0) do --walking through door
            me:GoalFaceTowards(leavedoor,false)
            if (walkingintodoor == 1) then --step back from door
                path:Compute(me, prepdoor)
                me.LastTargetPos = prepdoor
                walkingintodoor = 2
            end
            if (!path:IsValid()) then
                if (walkingintodoor == 2) then --step through door and leave door
                    path:Compute(me, leavedoor)
                    me.LastTargetPos = leavedoor
                    coroutine.wait(0.5)
                    walkingintodoor = 3
                elseif(walkingintodoor == 3) then --stop door stuff
                    walkingintodoor = 0
                end
            end
            path:Update(me)
            me:LocoInterjection(path)
            if (me.Fun_ActivePathingMode) then
                me:FunActivePathing()
            end
            if (SAPBOTDEBUG) then path:Draw() end
            coroutine.yield()
        end
    end
end

if (SERVER) then --i hate the forums
    SapActionRegister(id,DoorActionBoot,SapDoorAction,infoAbout,defaultState)
else
    SapActionRegister(id,DoorActionBoot,SapDoorAction,infoAbout,defaultState)
end