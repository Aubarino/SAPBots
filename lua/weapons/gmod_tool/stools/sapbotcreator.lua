AddCSLuaFile()
include("sapbot/SapUtil.lua")
AddCSLuaFile("sapbot/SapUtil.lua")

if CLIENT then
language.Add("tool.sapbotcreator", "S.A.P Bot Creator")

language.Add("tool.sapbotcreator.name", "S.A.P Bot Creator")
language.Add("tool.sapbotcreator.desc", "Builds a S.A.P Bot with your specifications")
language.Add("tool.sapbotcreator.0", "Spawn a S.A.P Bot with your specifications or More! Read the Toolgun Screen for more information")
end

_saptoolgunconvarloaded = false

TOOL.Category = "S.A.P Bots | Adaptive Friends"
TOOL.Name = "#tool.sapbotcreator"
TOOL.ClientConVar = {
	["sapname"] = "S.A.P Bot",
	["sapmodel"] = "models/player/group01/male_07.mdl",
    ["sapnamerandom"] = "0",
    ["saphealth"] = "100",

	["sapintelligence"] = "50",
    ["tts"] = "main",
    ["ttsenable"] = "1",
    ["sapsoundboard"] = "common",
    ["sapsoundboardon"] = "0",
    ["sapsoundboardunli"] = "2",

    ["sapttsrandom"] = "0",
    ["sapsoundboardmusic"] = "1",

	["sapchaos"] = "1",

	["sapipfchill"] = "0.5",
	["sapipfstrict"] = "0.5",
	["sapipfcalm"] = "0.5",
	["sapipfparanoid"] = "0.5",

	["sapsminnocence"] = "0.5",
	["sapsmcorruption"] = "0.5",
	["sapsmopenminded"] = "0.5",
	["sapsmcloseminded"] = "0.5",

    ["sapwander"] = "256",
    --weapons
    ["sapweapons"] = "0",
    ["sapweaponsadmin"] = "0",
    --building
    ["sapspawnprops"] = "0",
    ["sapspawnlargeprops"] = "0",
    ["sapbuildprops"] = "0",
    ["sapbuild_observation"] = "0",
    ["sapbuild_comprehension"] = "0",

    ["sappropdataset"] = "none.png",
    ["sapsobserveproprange"] = "256",
    ["sapproplimit"] = "32",

    ["sapmodelrandom"] = "0",
    ["sappersonalityrandom"] = "0",

    --fun
    ["sapaggressionmode"] = "0",
    ["sapactivepathingmode"] = "0",
    ["sapignoredoormode"] = "0",
    ["sapnoantistuckmode"] = "0",
    ["sapnojumpmode"] = "0",
    ["sapainetmode"] = "0",
    ["sapainetmodekey"] = "",
    ["sapainetpersonality"] = "dynamic",
    ["sapvotekickmode"] = "0"
}

local defaultvars = {
	["sapbotcreator_sapname"] = "S.A.P Bot",
	["sapbotcreator_sapmodel"] = "models/player/group01/male_07.mdl",
    ["sapbotcreator_sapnamerandom"] = "0",
    ["sapbotcreator_saphealth"] = "100",

	["sapbotcreator_sapintelligence"] = "50",
    ["sapbotcreator_tts"] = "main",
    ["sapbotcreator_ttsenable"] = "1",
    ["sapbotcreator_sapsoundboard"] = "common",
    ["sapbotcreator_sapsoundboardon"] = "0",
    ["sapbotcreator_sapsoundboardunli"] = "2",

    ["sapbotcreator_sapttsrandom"] = "0",
    ["sapbotcreator_sapsoundboardmusic"] = "1",

	["sapbotcreator_sapchaos"] = "1",

	["sapbotcreator_sapipfchill"] = "0.5",
	["sapbotcreator_sapipfstrict"] = "0.5",
	["sapbotcreator_sapipfcalm"] = "0.5",
	["sapbotcreator_sapipfparanoid"] = "0.5",

	["sapbotcreator_sapsminnocence"] = "0.5",
	["sapbotcreator_sapsmcorruption"] = "0.5",
	["sapbotcreator_sapsmopenminded"] = "0.5",
	["sapbotcreator_sapsmcloseminded"] = "0.5",

    ["sapbotcreator_sapwander"] = "256",
    --weapons
    ["sapbotcreator_sapweapons"] = "0",
    ["sapbotcreator_sapweaponsadmin"] = "0",
    --building
    ["sapbotcreator_sapspawnprops"] = "0",
    ["sapbotcreator_sapspawnlargeprops"] = "0",
    ["sapbotcreator_sapbuildprops"] = "0",
    ["sapbotcreator_sapbuild_observation"] = "0",
    ["sapbotcreator_sapbuild_comprehension"] = "0",

    ["sapbotcreator_sappropdataset"] = "none.png",
    ["sapbotcreator_sapsobserveproprange"] = "256",
    ["sapbotcreator_sapproplimit"] = "32",

    ["sapbotcreator_sapmodelrandom"] = "0",
    ["sapbotcreator_sappersonalityrandom"] = "0",

    --fun
    ["sapbotcreator_sapaggressionmode"] = "0",
    ["sapbotcreator_sapactivepathingmode"] = "0",
    ["sapbotcreator_sapignoredoormode"] = "0",
    ["sapbotcreator_sapnoantistuckmode"] = "0",
    ["sapbotcreator_sapnojumpmode"] = "0",
    ["sapbotcreator_sapainetmode"] = "0",
    ["sapbotcreator_sapainetmodekey"] = "",
    ["sapbotcreator_sapainetpersonality"] = "dynamic",
    ["sapbotcreator_sapvotekickmode"] = "0"
}

function TOOL:DrawToolScreen( width, height )
    --cool background
    local sapColor = Color(0,255,0)
    if (GetConVar("sapbot_color_r") != nil) then
        sapColor = Color(GetConVar("sapbot_color_r"):GetInt(),GetConVar("sapbot_color_g"):GetInt(),GetConVar("sapbot_color_b"):GetInt())
    end

	surface.SetDrawColor( Color( 0, 0, 0 ) )
	surface.DrawRect( 0, 0, width, height )
    local i = 1
    local outputValL = 0
    for i=1,24,1
    do
        outputValL = (math.sin(CurTime() * 2) + 2) * i
        surface.SetDrawColor( Color( outputValL * math.Round(sapColor.r * 0.004921568627451), outputValL * math.Round(sapColor.g * 0.003921568627451), outputValL * math.Round(sapColor.b * 0.004921568627451) ) )
        surface.DrawRect( 4 * i, 4 * i, width - (8 * i), height - (8 * i) )
    end

    --"page" number
    draw.SimpleText(self:GetOwner():GetNW2Int("saptool_screen",1), "DermaLarge", 8, 8, sapColor, TEXT_ALIGN_TOP, TEXT_ALIGN_TOP )
    --cool text art effect thing via math cause math is god :)
    local CoolTx = CoolSapTextArt() --moved to util
    --page 1 readout
	draw.SimpleText(CoolTx.." S.A.P Bot "..CoolTx, "DermaLarge", width / 2, 32, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    if (tobool(self:GetClientNumber("sapnamerandom", 0))) then
        draw.SimpleText("Randomised Name", "DermaLarge", width / 2, 72, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    else
        draw.SimpleText("Name: "..self:GetClientInfo("sapname"), "DermaLarge", width / 2, 72, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    local ModelTex = ""
    if (tobool(self:GetClientNumber("sapmodelrandom", 0))) then ModelTex = "Randomised Model"
    else ModelTex = self:GetClientInfo("sapmodel")
    end
    draw.SimpleText(ModelTex, "Trebuchet24", width / 2, 100, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if (tobool(self:GetClientNumber("sappersonalityrandom", 0))) then
        draw.SimpleText("Randomised Personality", "Trebuchet24", width / 2, 124, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    --control information
    if (self:GetOwner():GetNW2Int("saptool_screen",1) == 1) then
        local buttonprevHeight = 140
        draw.SimpleText("Left Click :", "Trebuchet24", width / 2, buttonprevHeight, sapColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
        draw.SimpleText("Create "..self:GetClientInfo("sapname").."", "Trebuchet24", width / 2, buttonprevHeight + 31, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText("Right Click :", "Trebuchet24", width / 2, buttonprevHeight+39, sapColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
        draw.SimpleText("Transmute anything", "Trebuchet24", width / 2, buttonprevHeight + 72, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    elseif (self:GetOwner():GetNW2Int("saptool_screen",1) == 2) then
        local buttonprevHeight = 140
        draw.SimpleText("Left Click :", "Trebuchet24", width / 2, buttonprevHeight, sapColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
        draw.SimpleText("Transmute all in small area", "Trebuchet24", width / 2, buttonprevHeight + 31, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    draw.SimpleText("Reload : Next Mode","Trebuchet24", width / 2, 240, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function TOOL:DefinePersonality(sapentity,dorandom) --defines the personality of a sap bot provided in the sap entity var here
    if (dorandom) then --RANDOMISE PERSONALITY ON SPAWN

        sapentity.Sap_Intelligence = math.Rand(10, 90)
        sapentity.Sap_Chaos = math.Rand(1, 10)

        local ipfY = math.Rand(0, 1)
        local ipfX = math.Rand(0, 1)
        local smY = math.Rand(0, 1)
        local smX = math.Rand(0, 1)
        sapentity.Sap_IPF_chill = 1 - ipfX
        sapentity.Sap_IPF_strict = ipfX
        sapentity.Sap_IPF_calm = 1 - ipfY
        sapentity.Sap_IPF_paranoid = ipfY

        sapentity.Sap_SM_innocence = 1 - smX
        sapentity.Sap_SM_corruption = smX
        sapentity.Sap_SM_openminded = smY
        sapentity.Sap_SM_closeminded = 1 - smY
        sapentity.Sap_PersonalityRandom = true
    else --NORMAL non-random PERSONALITY CARRY-OVER INFO
        sapentity.Sap_Intelligence = self:GetClientNumber( "sapintelligence" )
        sapentity.Sap_Chaos = self:GetClientNumber( "sapchaos" )
    
        sapentity.Sap_IPF_chill = self:GetClientNumber( "sapipfchill" )
        sapentity.Sap_IPF_strict = self:GetClientNumber( "sapipfstrict" )
        sapentity.Sap_IPF_calm = self:GetClientNumber( "sapipfcalm" )
        sapentity.Sap_IPF_paranoid = self:GetClientNumber( "sapipfparanoid" )
    
        sapentity.Sap_SM_innocence = self:GetClientNumber( "sapsminnocence" )
        sapentity.Sap_SM_corruption = self:GetClientNumber( "sapsmcorruption" )
        sapentity.Sap_SM_openminded = self:GetClientNumber( "sapsmopenminded" )
        sapentity.Sap_SM_closeminded = self:GetClientNumber( "sapsmcloseminded" )
        sapentity.Sap_PersonalityRandom = false
    end
    sapentity.Sap_WanderRange = self:GetClientNumber( "sapwander" )
    sapentity.NPCMenuSpawned = false
    sapentity.Fun_AggressionMode = (tobool(self:GetClientNumber("sapaggressionmode", 0)))
    sapentity.Fun_ActivePathingMode = (tobool(self:GetClientNumber("sapactivepathingmode", 0)))
    sapentity.Fun_IgnoreDoor = (tobool(self:GetClientNumber("sapignoredoormode", 0)))
    sapentity.Fun_NoAntistuck = (tobool(self:GetClientNumber("sapnoantistuckmode", 0)))
    sapentity.Fun_NoJump = (tobool(self:GetClientNumber("sapnojumpmode", 0)))
    sapentity.UseAIServer = (tobool(self:GetClientNumber("sapainetmode", 0)))
    sapentity.Fun_Votekick = (tobool(self:GetClientNumber("sapvotekickmode", 0)))

    local sapgroqkey = self:GetClientInfo( "sapainetmodekey" )
    SAPAINETKEY = sapgroqkey
    if (self:GetClientInfo("sapainetpersonality") == "dynamic") then
        sapentity.AIServerPersonalityBase = SapLLMPersonalityGen(sapentity.Sap_SM_corruption)
    else
        sapentity.AIServerPersonalityBase = self:GetClientInfo("sapainetpersonality")
    end

    if (!_saptoolgunconvarloaded) then --just incase
        for k, v in pairs(SapActionOverride_Scripts) do
            if (GetAddonLoaded(SapActionOverride_WSID[k])) then
                if (SapActionOverride_Default[k] != nil) then
                    CreateClientConVar("sapbotcreator_sap"..k, SapActionOverride_Default[k] and "1" or "0", true, false,"",0,1)
                end
            end
        end
        if (SAPBOTDEBUG) then
            print("Toolgun created S.A.P Bot Action Override ConVars")
        end
        _saptoolgunconvarloaded = true --they have been made
    end

    for k, v in pairs(SapActionOverride_Scripts) do
        if (GetAddonLoaded(SapActionOverride_WSID[k])) then
            if (SapActionOverride_Default[k] == nil) then
                sapentity.ActionOverridesActive[k] = true
            else
                local convarAction = GetConVar("sapbotcreator_sap"..k)
                sapentity.ActionOverridesActive[k] = (tobool(convarAction:GetInt()))
                if (SAPBOTDEBUG) then
                    print("Action Override "..k.." set on fresh sap bot, contents : "..tostring(tobool(convarAction:GetInt())))
                end
            end
        end
    end
end

function TOOL:Transmute(entityinput) --transmute any object into a sap bot or update information in a sap bot by recreating it, some of this is managed inside the sap bot code itself
    if (!(entityinput:IsPlayer() or entityinput:IsFlagSet(FL_CLIENT) or (entityinput:GetModel() == nil) or entityinput:IsWeapon() or (entityinput:GetSolid() == SOLID_NONE))) then
        --grab info from entity it right clicked
        local RefEntity = entityinput
        local TRcolor = RefEntity:GetColor() --
        local TRpos = RefEntity:GetPos() --
        local TRangles = RefEntity:GetAngles()
        local TRmodel = RefEntity:GetModel() --
        local TRmodelscale = RefEntity:GetModelScale()
        local TRmaterial = RefEntity:GetMaterial()
        local sapbot = nil
        if (SERVER) then
            --delete the entity it clicked
            RefEntity:Remove()
            --create the new entity of the sap bot and copy over the stuff i guess lol
            sapbot = ents.Create("sap_bot")
            sapbot:SetPos(TRpos)
            sapbot.SapSpawnOverride = true
        end

        local sapname = ""
        if (tobool(self:GetClientNumber("sapnamerandom", 0))) then
            sapname = GenerateName() --generates procedural name, if it should
            sapbot.Sap_NameRandom = true
        else
            sapname = self:GetClientInfo( "sapname" ) != "" and self:GetClientInfo( "sapname" ) or nil
            sapbot.Sap_NameRandom = false
        end

        if (SERVER) then
            if (tobool(self:GetClientNumber("sapttsrandom", 0))) then --tts random and normal tts
                local g,fold = file.Find("sound/sapbots/tts/*", "GAME")
                local topick = "main"
                for g,v in RandomPairs(fold) do
                        topick = v
                    break
                end
                sapbot.TTSname = topick
                sapbot.TTSnameRandom = true
            else
                sapbot.TTSname = self:GetClientInfo( "tts" )
                sapbot.TTSnameRandom = false
            end
            sapbot.Sap_Name = sapname
            local healthtodo = self:GetClientInfo("saphealth")
            sapbot:SetHealth(healthtodo)
            sapbot:SetMaxHealth(healthtodo)
            sapbot.Sap_Model = TRmodel
            sapbot.ColorOverride = TRcolor
            sapbot.MatOverride = TRmaterial
            sapbot:SetModelScale(TRmodelscale)
            sapbot:SetAngles(TRangles)

            sapbot.TTSenabled = (tobool(self:GetClientNumber("ttsenable", 0)))

            sapbot.SapSoundboard = self:GetClientInfo( "sapsoundboard" )
            sapbot.SapSoundboardOn = (tobool(self:GetClientNumber("sapsoundboardon", 0)))
            sapbot.SapSoundboardRate = self:GetClientNumber( "sapsoundboardunli",0 )
            sapbot.SapSoundboardMusic = (tobool(self:GetClientNumber("sapsoundboardmusic", 0)))

            sapbot.EquipWeapons = (tobool(self:GetClientNumber("sapweapons", 0)))
            sapbot.AdminWeapons = (tobool(self:GetClientNumber("sapweaponsadmin", 0)))
            sapbot.CanSpawnProps = (tobool(self:GetClientNumber("sapspawnprops", 0)))
            sapbot.CanSpawnLargeProps = (tobool(self:GetClientNumber("sapspawnlargeprops", 0)))
            sapbot.CanBuildWithProps = (tobool(self:GetClientNumber("sapbuildprops", 0)))
            sapbot.BuildLearnFromObservation = (tobool(self:GetClientNumber("sapbuild_observation", 0)))
            sapbot.BuildFormComprehension = (tobool(self:GetClientNumber("sapbuild_comprehension", 0)))

            sapbot.CurrentPropDataset = self:GetClientInfo("sappropdataset")
            sapbot.SapPropObserveRange = self:GetClientNumber("sapsobserveproprange")
            sapbot.SapPropLimit = self:GetClientNumber("sapproplimit")

            self:DefinePersonality(sapbot,tobool(self:GetClientNumber("sappersonalityrandom", 0)))

            sapbot:Spawn()
            undo.Create( 'S.A.P Bot' )
                undo.AddEntity(sapbot)
                undo.SetPlayer(self:GetOwner())
                undo.SetCustomUndoText( 'Undone S.A.P Bot ('..sapbot.Sap_Name..')' )
            undo.Finish('Created S.A.P Bot ('..sapbot.Sap_Name..')')
        end
    end
end

function TOOL:RightClick( tr )
    if (self:GetOwner():GetNW2Int("saptool_screen",1) == 1) then
        if (IsValid(tr.Entity)) then
            self:Transmute(tr.Entity)
            return true
        else
            return false
        end
    end
end

function TOOL:Reload( tr ) --left click spawning sap bot option
    local User = self:GetOwner()
    User:EmitSound( string.Trim("custom/sap/sapmodechange.wav","%s"), 100, 100, 1, CHAN_ITEM )
    User:SetNW2Int("saptool_screen",User:GetNW2Int("saptool_screen",1) + 1)
    if (User:GetNW2Int("saptool_screen",1) > 2) then
        User:SetNW2Int("saptool_screen",1)
    end
end

function TOOL:SpawnSAPbot(pos)
    local sapbot = nil
    if (SERVER) then
        sapbot = ents.Create("sap_bot")
        sapbot:SetPos(pos)
    end

	local sapmodel = self:GetClientInfo( "sapmodel" ) != "" and self:GetClientInfo( "sapmodel" ) or nil
    local sapname = ""
    if (tobool(self:GetClientNumber("sapnamerandom", 0))) then
        sapname = GenerateName() --generates procedural name, if it should
        sapbot.Sap_NameRandom = true
    else
        sapname = self:GetClientInfo( "sapname" ) != "" and self:GetClientInfo( "sapname" ) or nil
        sapbot.Sap_NameRandom = false
    end

    --client to entity stuff
    if (SERVER) then
        sapbot.Sap_Name = sapname

        local healthtodo = self:GetClientInfo("saphealth")
        sapbot:SetHealth(healthtodo)
        sapbot:SetMaxHealth(healthtodo)

        if (tobool(self:GetClientNumber("sapttsrandom", 0))) then --tts random and normal tts
            local g,fold = file.Find("sound/sapbots/tts/*", "GAME")
            local topick = "main"
            for g,v in RandomPairs(fold) do
                    topick = v
                break
            end
            sapbot.TTSname = topick
            sapbot.TTSnameRandom = true
        else
            sapbot.TTSname = self:GetClientInfo( "tts" )
            sapbot.TTSnameRandom = false
        end

        sapbot.TTSenabled = (tobool(self:GetClientNumber("ttsenable", 0)))
        if (tobool(self:GetClientNumber("sapmodelrandom", 0))) then
            sapbot.Sap_Model = "random"
            sapbot.Sap_ModelRandom = true
        else
            sapbot.Sap_Model = sapmodel
            sapbot.Sap_ModelRandom = false
        end

        sapbot.SapSoundboard = self:GetClientInfo( "sapsoundboard" )
        sapbot.SapSoundboardOn = (tobool(self:GetClientNumber("sapsoundboardon", 0)))
        sapbot.SapSoundboardRate = self:GetClientNumber( "sapsoundboardunli",0 )
        sapbot.SapSoundboardMusic = (tobool(self:GetClientNumber("sapsoundboardmusic", 0)))

        sapbot.EquipWeapons = (tobool(self:GetClientNumber("sapweapons", 0)))
        sapbot.AdminWeapons = (tobool(self:GetClientNumber("sapweaponsadmin", 0)))
        sapbot.CanSpawnProps = (tobool(self:GetClientNumber("sapspawnprops", 0)))
        sapbot.CanSpawnLargeProps = (tobool(self:GetClientNumber("sapspawnlargeprops", 0)))
        sapbot.CanBuildWithProps = (tobool(self:GetClientNumber("sapbuildprops", 0)))
        sapbot.BuildLearnFromObservation = (tobool(self:GetClientNumber("sapbuild_observation", 0)))
        sapbot.BuildFormComprehension = (tobool(self:GetClientNumber("sapbuild_comprehension", 0)))

        sapbot.CurrentPropDataset = self:GetClientInfo("sappropdataset")
        sapbot.SapPropObserveRange = self:GetClientNumber("sapsobserveproprange")
        sapbot.SapPropLimit = self:GetClientNumber("sapproplimit")

        self:DefinePersonality(sapbot,tobool(self:GetClientNumber("sappersonalityrandom", 0)))

        sapbot:Spawn()
        undo.Create( 'S.A.P Bot' )
            undo.AddEntity(sapbot)
            undo.SetPlayer(self:GetOwner())
            undo.SetCustomUndoText( 'Undone S.A.P Bot ('..sapbot.Sap_Name..')' )
        undo.Finish('Created S.A.P Bot ('..sapbot.Sap_Name..')')
    end
end

function TOOL:LeftClick( tr ) --left click spawning sap bot option
    if (self:GetOwner():GetNW2Int("saptool_screen",1) == 1) then --normal spawn sap bot function stuff
        self:SpawnSAPbot(tr.HitPos)
        return true
    elseif (self:GetOwner():GetNW2Int("saptool_screen",1) == 2) then --transmute all in area
        local entsInArea = ents.FindInSphere( tr.HitPos, 128 )
        for k,v in ipairs( entsInArea ) do --for all the entities it found, transmute
                self:Transmute(v)
        end
        return true
    end
end

function GenConVarsForActions(panel) --generate checkboxes for action overrides currently valid via autorun
    if (!_saptoolgunconvarloaded) then
        panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
        panel:Help("- - - - - - - - - - - -Action Overrides - - - - - - - - - - ")
        panel:Help("The S.A.P Bot expanded interaction system, for mods and objects")
        panel:ControlHelp("Checkboxes will appear 'n disappear according to what")
        panel:ControlHelp("addons you have, and inbuilt support for interactions.")
        panel:ControlHelp("")
        panel:ControlHelp("You can make your own support for mods with this system!")
        panel:ControlHelp("Simply unpack the addon, and use a SapbotAction in autorun")
        panel:ControlHelp("as an example template for how to make your own support addon.")
        panel:ControlHelp("Ask on the Discord Server for more info :)")
        for k, v in pairs(SapActionOverride_Scripts) do
            if (GetAddonLoaded(SapActionOverride_WSID[k])) then
                if (SapActionOverride_Default[k] != nil) then
                    local convarName = "sapbotcreator_sap"..k
                    local convarCreated
                    if ConVarExists(convarName) then
                        convarCreated = GetConVar(convarName)
                    else
                        convarCreated = CreateClientConVar(convarName, SapActionOverride_Default[k] and "1" or "0", true, false, "", 0, 1)
                    end
                
                    if (convarCreated ~= nil and convarCreated:IsFlagSet(FCVAR_ARCHIVE)) then
                        -- Ensure convarCreated is a Lua-created ConVar
                        convarCreated:SetInt(SapActionOverride_Default[k] and 1 or 0) -- Use numbers, not strings
                    else
                        --print("Error: Failed to create or retrieve ConVar '"..convarName.."'")
                    end
                
                    panel:CheckBox('Action Override : "'..k..'"', convarName)
                    panel:ControlHelp(SapActionOverride_Info[k])
                else
                    --print("Sap Action Override default is nil, skipping "..k)
                end
            end
        end
        if (SAPBOTDEBUG) then
            print("Toolgun created S.A.P Bot Action Override ConVars")
        end
        _saptoolgunconvarloaded = true --they have been made
    end
end

function TOOL.BuildCPanel(panel)
	panel:Help('The specifications the S.A.P Bot should be created with')

	panel:Help('- - - Presets - - -')


	local convars = {}

    for k, v in pairs(defaultvars) do
        convars[#convars + 1] = k
    end

	panel:AddControl("ComboBox", {
		Options = {
			["S.A.P Bot"] = defaultvars
		},
		CVars = convars,
		Label = "",
		MenuButton = "1",
		Folder = "sapbotcreatordata"
	})
	panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    panel:TextEntry( 'Name', 'sapbotcreator_sapname' )
    panel:CheckBox('Randomize the name','sapbotcreator_sapnamerandom')
    panel:TextEntry("Model","sapbotcreator_sapmodel")
    panel:CheckBox('Randomize the model','sapbotcreator_sapmodelrandom')
    panel:NumSlider("Health", "sapbotcreator_saphealth", 0, 9999999, 2)
    panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")

    --tts voice options
    local TTSSet = panel:ComboBox("TTS Set","sapbotcreator_tts")
    panel:ControlHelp("The voice the S.A.P Bot should have")
    local g,fold = file.Find("sound/sapbots/tts/*", "GAME")
    
    for g,v in ipairs(fold) do
        TTSSet:AddChoice("(TTS) "..v,v)
    end
    panel:CheckBox("Enable TTS Voice","sapbotcreator_ttsenable")
    panel:CheckBox("Randomize the TTS Voice","sapbotcreator_sapttsrandom")
    -- -- -- --
    --soundboard options
    local SoundboardBox = panel:ComboBox("Soundboard","sapbotcreator_sapsoundboard")
    local g,foldsb = file.Find("sound/sapbots/soundboards/*", "GAME")

    for g,v in ipairs(foldsb) do
        SoundboardBox:AddChoice("(Soundboard) "..v,v)
    end
    panel:CheckBox("Use the Soundboard","sapbotcreator_sapsoundboardon")
    panel:CheckBox("Enable Soundboard Music","sapbotcreator_sapsoundboardmusic")
    panel:NumSlider("Soundboard Usage Unlikelihood", "sapbotcreator_sapsoundboardunli", 0, 20, 2)
    
    local joindistext = panel:Help(" \n ")
    local joindistexttex = vgui.Create( "RichText", joindistext )
    joindistexttex:Dock( FILL )
    joindistexttex:DockMargin(0, 0, 0, 0)
    joindistexttex:DockPadding(100, 100, 100, 100)
    joindistexttex:InsertColorChange(0, 240, 0, 255)
    joindistexttex:AppendText("Join the Discord Server for how to MAKE YOUR OWN TTS Voices, Soundboards and more!")
    panel:Help("")
    panel:Help("")
    local DiscordButton = vgui.Create( "DButton", panel )
    DiscordButton:SetText( "Join The Discord!" )
    DiscordButton:SetPos( 65, 550 )
    DiscordButton:SetSize( 103, 27 )
    DiscordButton.DoClick = function()
        gui.OpenURL("https://discord.gg/8UMuEdDYEs")
    end

    panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    -- -- -- --

    panel:NumSlider("Intelligence", "sapbotcreator_sapintelligence", 1, 100, 0)
    panel:NumSlider("Wandering Range", "sapbotcreator_sapwander", 32, 2048, 0)

    --weapons
    panel:Help("- - - - - - - - - - - - - - Weapons - - - - - - - - - - - - ")
    panel:CheckBox("Use Weapons","sapbotcreator_sapweapons")
    panel:CheckBox("Admin Weapons","sapbotcreator_sapweaponsadmin")

    panel:Help("- - - - - - - - - - - Building (EXPERIMENTAL) - - - - - - - ")
    panel:CheckBox("Can Spawn Props","sapbotcreator_sapspawnprops")
    panel:ControlHelp("Makes them build with props")
    panel:CheckBox("Can Spawn Props (Large)","sapbotcreator_sapspawnlargeprops")
    panel:ControlHelp("Makes them build with large props")
    panel:CheckBox("Can Build With Props","sapbotcreator_sapbuildprops")
    panel:ControlHelp("Makes them build with prop data from their dataset")
    panel:NumSlider("Prop Limit", "sapbotcreator_sapproplimit", 4, 256, 0)
    panel:ControlHelp("*Prop Limit is per S.A.P Bot")

    local PropDatasetBox = panel:ComboBox("Dataset","sapbotcreator_sappropdataset")
    local filesdataset,foldez = file.Find("materials/sapbot/datasets/*", "GAME")
    PropDatasetBox:AddChoice("none","none.png")
    for g,v in ipairs(filesdataset) do
        PropDatasetBox:AddChoice(string.gsub(string.gsub(v, "_", " "), ".png", ""),v)
    end
    panel:ControlHelp("The props dataset to be used")

    panel:Help("- - - - - - - Building (VERY VERY EXPERIMENTAL) - - - - - -")
    panel:CheckBox("Learn building from observation","sapbotcreator_sapbuild_observation")
    panel:ControlHelp("Makes them learn data from observing players build")
    panel:ControlHelp("Dataset must be set to 'none' or it will not save.")
    panel:NumSlider("Prop Observe Range", "sapbotcreator_sapsobserveproprange", 128, 2048, 0)
    panel:ControlHelp("How far in units can they observe player props")
    panel:CheckBox("Building form / shape comprehension","sapbotcreator_sapbuild_comprehension")
    panel:ControlHelp("Currently not fully implemented")

    local GraphWidth = 100
    local GraphHeight = 300
    panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    panel:CheckBox('Randomize and override personality information','sapbotcreator_sappersonalityrandom')
    panel:Help("Information Processing Filter Graph")
    --information processing filter 2d graph
    local IPFSlider = vgui.Create( "DSlider", ipfframe )
    IPFSlider:SetPos(GetConVar("sapbotcreator_sapipfstrict"):GetFloat() * 100,GetConVar("sapbotcreator_sapipfparanoid"):GetFloat() * 100)
    IPFSlider:SetSize( GraphWidth, GraphHeight )
    IPFSlider:SetBackground( "materials/custom/sap/ipfgraph.png" )
    panel:AddItem(IPFSlider)
    IPFSlider:SetParent(panel)
    IPFSlider:SetLockY()
    IPFSlider:SetLockX()
    IPFSlider._oOnCursorMoved = IPFSlider.OnCursorMoved --saving the DSlider OnCursorMoved code, running it, and then running my custom code, so it doesn't override
    function IPFSlider:OnCursorMoved(x, y)
        self._oOnCursorMoved(self, x, y) --setting the vars to the slider
        GetConVar("sapbotcreator_sapipfchill"):SetFloat(1 - IPFSlider:GetSlideX())
        GetConVar("sapbotcreator_sapipfstrict"):SetFloat(IPFSlider:GetSlideX())
        GetConVar("sapbotcreator_sapipfcalm"):SetFloat(1 - IPFSlider:GetSlideY())
        GetConVar("sapbotcreator_sapipfparanoid"):SetFloat(IPFSlider:GetSlideY())
    end
    function IPFSlider:Think() --setting the slider to the vars, so presets work
        IPFSlider:SetSlideY(GetConVar("sapbotcreator_sapipfparanoid"):GetFloat())
        IPFSlider:SetSlideX(GetConVar("sapbotcreator_sapipfstrict"):GetFloat())
    end
    panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    panel:Help("Situation Management - Personality Graph")
    --situation management - personality graph (2d)
    local SMSlider = vgui.Create( "DSlider", ipfframe )
    SMSlider:SetPos(GetConVar("sapbotcreator_sapsmcorruption"):GetFloat() * 100,GetConVar("sapbotcreator_sapsmopenminded"):GetFloat() * 100)
    SMSlider:SetSize( GraphWidth, GraphHeight )
    SMSlider:SetBackground( "materials/custom/sap/smgraph.png" )
    panel:AddItem(SMSlider)
    SMSlider:SetParent(panel)
    SMSlider:SetLockY()
    SMSlider:SetLockX()
    SMSlider._oOnCursorMoved = SMSlider.OnCursorMoved --saving the DSlider OnCursorMoved code, running it, and then running my custom code, so it doesn't override
    function SMSlider:OnCursorMoved(x, y) --setting the vars to the slider
        self._oOnCursorMoved(self, x, y)
        GetConVar("sapbotcreator_sapsminnocence"):SetFloat(1 - SMSlider:GetSlideX())
        GetConVar("sapbotcreator_sapsmcorruption"):SetFloat(SMSlider:GetSlideX())
        GetConVar("sapbotcreator_sapsmcloseminded"):SetFloat(1 - SMSlider:GetSlideY())
        GetConVar("sapbotcreator_sapsmopenminded"):SetFloat(SMSlider:GetSlideY())
    end
    function SMSlider:Think() --setting the slider to the vars, so presets work
        SMSlider:SetSlideY(GetConVar("sapbotcreator_sapsmopenminded"):GetFloat())
        SMSlider:SetSlideX(GetConVar("sapbotcreator_sapsmcorruption"):GetFloat())
    end
    panel:Help("- - - - - - - - - - - - - - - Fun - - - - - - - - - - - - - ")
    panel:CheckBox("Absolute Aggression Mode*","sapbotcreator_sapaggressionmode")
    panel:ControlHelp("(*they will attack things in rage ignoring all personality and reason!)")
    panel:CheckBox("Active Pathing Mode*","sapbotcreator_sapactivepathingmode")
    panel:ControlHelp("(*path without navmesh, experimental custom pathing, breaks lots)")
    panel:CheckBox("Ignore Doors Entirely*","sapbotcreator_sapignoredoormode")
    panel:ControlHelp("(*path through doors, phasing through props, for when they get stuck a lot)")
    panel:CheckBox("No Anti-stuck*","sapbotcreator_sapnoantistuckmode")
    panel:ControlHelp("(*normally they will detect when stuck, and teleport around,)")
    panel:ControlHelp("(but in small spaces, this can be an issue, so this turns it off.)")
    panel:CheckBox("No Jump Mode*","sapbotcreator_sapnojumpmode")
    panel:ControlHelp("(*makes them no longer jump around in certain conditions)")
    panel:CheckBox("AI Net Mode (groq)*","sapbotcreator_sapainetmode")
    panel:TextEntry("Groq Key", "sapbotcreator_sapainetmodekey" )
    panel:ControlHelp("(*when you provide a key and enable this, they will talk via my own implementation of the groq API. It is simular to Chat GPT but without as much usage restriction while free!!!)")
    local AINetPersonality = panel:ComboBox("Personality Base*","sapbotcreator_sapainetpersonality")
    AINetPersonality:AddChoice("Dynamic (based on personality graph)","dynamic")
    AINetPersonality:SetSortItems(false)
    AINetPersonality:AddSpacer()
    SapLLMPersLoad()
    for k,v in pairs(_SapLLMPersonality) do
        AINetPersonality:AddChoice(capitalizeWords(string.gsub(k, "_", " ")),k)
    end
    panel:ControlHelp("(*when the AI Net Mode is on, this controls how their personality prompt will generate)")

    panel:CheckBox("Can Vote Kick*","sapbotcreator_sapvotekickmode")
    panel:ControlHelp("(*Makes them able to kick each other. AI Net Mode can also woth with this, but its more rare.)")
    GenConVarsForActions(panel) --action overrides
end

hook.Add("PopulateToolMenu","SetupSapbotOptionsMenu", function()
    spawnmenu.AddToolMenuOption( "S.A.P Bots", "S.A.P Bots | Adaptive Friends", "sap_optio", "-= Settings =-", "", "", function(panel) 
        CreateConVar("sapbot_debugmode", 0)
        CreateConVar("sapbot_hideicons", 0)
        CreateConVar("sapbot_hidetext", 0)
        CreateConVar("sapbot_hidechat", 0)
        CreateConVar("sapbot_color_r", 0)
        CreateConVar("sapbot_color_g", 255)
        CreateConVar("sapbot_color_b", 0)
        panel:ControlHelp("")
        panel:ControlHelp("If you're looking at this trying to find the S.A.P Bot Creator Toolgun Tool")
        panel:ControlHelp("Then you're in the wrong place, look in the normal toolgun tools area 'n scroll down maybe.")
        panel:ControlHelp("I'm sick of people not figuring this out, it's literally right there :)")
        panel:ControlHelp("")
        panel:ControlHelp("")
        panel:CheckBox("Debug Mode","sapbot_debugmode")
        panel:ControlHelp("Is exchanged per s.a.p bot initialize yet is global. A mode that enables debug prints, s.a.p bot debug rendering, s.a.p bot ID Information and more, intended for developers")
        panel:CheckBox("Hide Icons","sapbot_hideicons")
        panel:ControlHelp("Hides icons of s.a.p bot mood / status")
        panel:CheckBox("Hide Text","sapbot_hidetext")
        panel:ControlHelp("Hides text of s.a.p bots above their heads and their health")
        panel:CheckBox("Hide Chat Messages","sapbot_hidechat")
        panel:ControlHelp("Hides the chat messages of s.a.p bots, they are still sent internally, meaning mentions of their names still get reactions")

        -- local Frame = vgui.Create("DFrame")
        -- Frame:SetParent(panel)
        -- Frame:SetSize(267,186) 	-- Good size for example
        -- Frame:Center()
        --Frame:MakePopup()

        -- local Mixer = vgui.Create("DColorMixer", Frame)
        -- Mixer:Dock(FILL)					-- Make Mixer fill place of Frame
        -- Mixer:SetPalette(true)  			-- Show/hide the palette 				DEF:true
        -- Mixer:SetAlphaBar(true) 			-- Show/hide the alpha bar 				DEF:true
        -- Mixer:SetWangs(true) 				-- Show/hide the R G B A indicators 	DEF:true
        -- Mixer:SetColor(Color(30,100,160)) 	-- Set the default color

        -- function Mixer:ValueChanged(col)
        --     print(tostring(col))
        -- end

        panel:Help("S.A.P Bot main theme color")
        panel:ControlHelp("Controls the main color used in rendering all of the text and such")
        -- Background panel
        BGPanel = vgui.Create("DPanel")
        BGPanel:SetParent(panel)
        BGPanel:SetSize(200, 200)
        panel:AddItem(BGPanel)
        --BGPanel:SetSize(200, 200)
        --BGPanel:SetPos(155, 400)
        --BGPanel:Center()

        -- Color label
        local color_label_backer = Label("Color( 255, 255, 255 )", BGPanel)
        color_label_backer:SetPos(41, 161)
        color_label_backer:SetSize(150, 20)
        color_label_backer:SetHighlight(true)
        color_label_backer:SetColor(Color(0, 127, 0))
        local color_label_backer2 = Label("Color( 255, 255, 255 )", BGPanel)
        color_label_backer2:SetPos(39, 159)
        color_label_backer2:SetSize(150, 20)
        color_label_backer2:SetHighlight(true)
        color_label_backer2:SetColor(Color(0, 127, 0))
        local color_label_backer3 = Label("Color( 255, 255, 255 )", BGPanel)
        color_label_backer3:SetPos(39, 159)
        color_label_backer3:SetSize(150, 20)
        color_label_backer3:SetHighlight(true)
        color_label_backer3:SetColor(Color(0, 127, 0))
        local color_label_backer4 = Label("Color( 255, 255, 255 )", BGPanel)
        color_label_backer4:SetPos(39, 159)
        color_label_backer4:SetSize(150, 20)
        color_label_backer4:SetHighlight(true)
        color_label_backer4:SetColor(Color(0, 127, 0))
        local color_label = Label("Color( 255, 255, 255 )", BGPanel)
        color_label:SetPos(40, 160)
        color_label:SetSize(150, 20)
        color_label:SetHighlight(true)
        color_label:SetColor(Color(0, 255, 0))

        -- Color picker
        local color_picker = vgui.Create("DRGBPicker", BGPanel)
        color_picker:SetPos(5, 5)
        color_picker:SetSize(30, 190)

        -- Color cube
        local color_cube = vgui.Create("DColorCube", BGPanel)
        color_cube:SetPos(40, 5)
        color_cube:SetSize(155, 155)

        -- When the picked color is changed...
        function color_picker:OnChange(col)
            -- Get the hue of the RGB picker and the saturation and vibrance of the color cube
            local h = ColorToHSV(col)
            local _, s, v = ColorToHSV(color_cube:GetRGB())
            
            -- Mix them together and update the color cube
            col = HSVToColor(h, s, v)
            color_cube:SetColor(col)
            
            -- Lastly, update the background color and label
            UpdateColors(col)
                
        end

        function color_cube:OnUserChanged(col)

            -- Update background color and label
            UpdateColors(col)

        end

        -- Updates display colors, label, and clipboard text
        function UpdateColors(col)
            local theText = ("RGB Value ( "..col.r..", "..col.g..", "..col.b.." )")
            color_label:SetText(theText)
            color_label_backer:SetText(theText)
            color_label_backer2:SetText(theText)
            color_label_backer3:SetText(theText)
            color_label_backer4:SetText(theText)
            color_label:SetColor(Color((col.r), (col.g), (col.b)))
            local colBacker = Color(math.Round((255 - col.r) * 0.5), math.Round((255 - col.g) * 0.5), math.Round((255 - col.b) * 0.5))
            color_label_backer:SetColor(colBacker)
            color_label_backer2:SetColor(colBacker)
            color_label_backer3:SetColor(colBacker)
            color_label_backer4:SetColor(colBacker)
            SetClipboardText(color_label:GetText())

            GetConVar("sapbot_color_r"):SetInt(math.Round(col.r))
            GetConVar("sapbot_color_g"):SetInt(math.Round(col.g))
            GetConVar("sapbot_color_b"):SetInt(math.Round(col.b))
        end

        -- local color_picker = vgui.Create("DRGBPicker", panel)
        -- color_picker:SetPos(35, 300)
        -- color_picker:SetSize(180, 180)

        -- -- When the picked color is changed...
        -- function color_picker:OnChange(col)
        --     -- Change the panel background color
        --     print(tostring(col))
        -- end
    end)
end)
