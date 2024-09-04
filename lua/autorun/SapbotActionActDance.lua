AddCSLuaFile()
include("sapbot/SapUtil.lua")
AddCSLuaFile("sapbot/SapUtil.lua")
local id = "actDance"
local infoAbout = 'Makes sap bots able to dance according to their mood'
local defaultState = true --the default checkbox state on the toolgun tool, if nil then no tickbox and always active

local dances = {
    ACT_GMOD_SHOWOFF_STAND_01,
    ACT_GMOD_SHOWOFF_STAND_02,
    ACT_GMOD_SHOWOFF_STAND_03,
    ACT_GMOD_SHOWOFF_STAND_04,
    ACT_GMOD_TAUNT_ROBOT,
    ACT_GMOD_TAUNT_DANCE,
    ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
    ACT_GMOD_TAUNT_LAUGH,
    ACT_GMOD_TAUNT_CHEER,
    ACT_GMOD_TAUNT_MUSCLE,
    ACT_GMOD_TAUNT_PERSISTENCE,
    ACT_GMOD_GESTURE_BOW,
    ACT_GMOD_TAUNT_SALUTE,
    ACT_GMOD_GESTURE_AGREE
}

local function ActDanceActionBoot(me) --action boot logic
    if !IsValid(me) then return end
    if (math.random(0,100) == 0 && (me.Stress < 0.5 || (me.Stress > 2 && (me.Sap_IPF_strict > 0.5) && (me.Sap_SM_corruption > 0.7)))) then
        me.ActionOverride = id
    end
end

local function SapActDanceAction(me) --action override code
    if !IsValid(me) then return end
    if (me.ActionOverride == id) then
        local toDance = ACT_GMOD_TAUNT_DANCE
        for c,danceRand in RandomPairs(dances) do
            toDance = danceRand
            break
        end
        if (SAPBOTDEBUG) then
            print("S.A.P Bot "..me.Sap_Name.." attempting to dance using Action Override, dance ID : "..toDance)
        end

        me:DoAnimationEvent(toDance,5,false)
        coroutine.wait(4)
    end
end

if (SERVER) then --i hate the forums
    SapActionRegister(id,ActDanceActionBoot,SapActDanceAction,infoAbout,defaultState)
else
    SapActionRegister(id,ActDanceActionBoot,SapActDanceAction,infoAbout,defaultState)
end