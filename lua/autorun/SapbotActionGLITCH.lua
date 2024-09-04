AddCSLuaFile()
include("sapbot/SapUtil.lua")
AddCSLuaFile("sapbot/SapUtil.lua")
local id = "GLITCH"
local infoAbout = 'Applies the effect of the "GLITCH" addon to the sap bot'
local defaultState = false --the default checkbox state on the toolgun tool, if nil then no tickbox and always active

function glitchActionBoot(me) --action glitch start
    if !IsValid(me) then return end
    if (!me.glitched) then
        StartPlayerGlitch(me)
        --ApplyGlitchEffect(me)
        me.glitched = true
    end
end

function SapglitchAction(me) --action glitch filler code
    if !IsValid(me) then return end
end

if (SERVER) then --i hate the forums
    SapActionRegister(id,glitchActionBoot,SapglitchAction,infoAbout,defaultState,3318033710)
else
    SapActionRegister(id,glitchActionBoot,SapglitchAction,infoAbout,defaultState,3318033710)
end