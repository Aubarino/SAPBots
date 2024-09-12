AddCSLuaFile()

_Sapbot_WeaponBlacklist = {} --weapons to not spawn with or use
_SapbotPropDatasets = {}

local tableDataTemp = {}
function SapBotToData(sap) --turns a sap bot into a table of data
    tableDataTemp = {
        ["Sap_id"] = sap.Sap_id,
        ["Sap_Intelligence"] = sap.Sap_Intelligence,
        ["Sap_Chaos"] = sap.Sap_Chaos,
        ["Sap_DefaultTrustFactor"] = sap.Sap_DefaultTrustFactor,

        ["Sap_IPF_chill"] = sap.Sap_IPF_chill,
        ["Sap_IPF_strict"] = sap.Sap_IPF_strict,
        ["Sap_IPF_calm"] = sap.Sap_IPF_calm,
        ["Sap_IPF_paranoid"] = sap.Sap_IPF_paranoid,
        ["Sap_SM_innocence"] = sap.Sap_SM_innocence,
        ["Sap_SM_corruption"] = sap.Sap_SM_corruption,
        ["Sap_SM_openminded"] = sap.Sap_SM_openminded,
        ["Sap_SM_closeminded"] = sap.Sap_SM_closeminded,

        ["Sap_WanderRange"] = sap.Sap_WanderRange,

        --random information
        ["Sap_Name"] = sap.Sap_Name,
        ["Sap_Model"] = sap.Sap_Model,

        ["Sap_PersonalityRandom"] = sap.Sap_PersonalityRandom,
        ["Sap_NameRandom"] = sap.Sap_NameRandom,
        ["Sap_ModelRandom"] = sap.Sap_ModelRandom,
        ["TTSnameRandom"] = sap.TTSnameRandom,

        ["SpawnDone"] = sap.SpawnDone,
        ["SapSpawnOverride"] = sap.SapSpawnOverride,
        ["ColorOverride"] = sap.ColorOverride,
        ["MatOverride"] = sap.MatOverride,
        ["Jumping"] = sap.Jumping,
        ["Stepsounds"] = sap.Stepsounds,
        ["Stress"] = sap.Stress,
        ["EmotionEnabled"] = sap.EmotionEnabled,

        ["Spawning"] = sap.Spawning,
        ["ChatSent"] = sap.ChatSent,
        ["SAPCached"] = sap.SAPCached,

        ["NPCMenuSpawned"] = sap.NPCMenuSpawned,

        --tts and dialog
        ["TTSspeaking"] = sap.TTSspeaking,
        ["TTStruespeak"] = sap.TTStruespeak,
        ["TTStimefornext"] = sap.TTStimefornext,
        ["TTSname"] = sap.TTSname,
        ["SapSoundboard"] = sap.SapSoundboard,
        ["SapSoundboardOn"] = sap.SapSoundboardOn,
        ["SapSoundboardMode"] = sap.SapSoundboardMode,
        ["SapSoundboardRate"] = sap.SapSoundboardRate,
        ["SapSoundboardCurrent"] = sap.SapSoundboardCurrent,
        ["SapSoundboardMusic"] = sap.SapSoundboardMusic,
        ["DialogSet"] = sap.DialogSet,
        ["TTSenabled"] = sap.TTSenabled,
        ["TTStextform"] = sap.TTStextform,
        ["SapCacheSay"] = sap.SapCacheSay,
        ["SapCacheSaySubject"] = sap.SapCacheSaySubject,
        ["SapCacheSaySubjectInfo"] = sap.SapCacheSaySubjectInfo,
        ["SapCacheSayTime"] = sap.SapCacheSayTime,

        --combat
        ["EquipWeapons"] = sap.EquipWeapons,
        ["EquipWeapons"] = sap.AdminWeapons,

        --"fun"
        ["EquipWeapons"] = sap.Fun_AggressionMode,
        ["Fun_ActivePathingMode"] = sap.Fun_ActivePathingMode,
        ["Fun_IgnoreDoor"] = sap.Fun_IgnoreDoor,
        ["Fun_NoAntistuck"] = sap.Fun_NoAntistuck,
        ["Fun_NoJump"] = sap.Fun_NoJump,
        ["Fun_Votekick"] = sap.Fun_Votekick,

        --actions
        ["ActionOverridesActive"] = sap.ActionOverridesActive,

        --building relating stuff
        ["CanSpawnProps"] = sap.CanSpawnProps,
        ["CanSpawnLargeProps"] = sap.CanSpawnLargeProps,
        ["CanBuildWithProps"] = sap.CanBuildWithProps,
        ["BuildLearnFromObservation"] = sap.BuildLearnFromObservation,
        ["BuildFormComprehension"] = sap.BuildFormComprehension,
        ["CurrentPropDataset"] = sap.CurrentPropDataset,
        ["SapPropObserveRange"] = sap.SapPropObserveRange,
        ["SapPropLimit"] = sap.SapPropLimit,

        --ai net stuff / llm groq stuff
        ["UseAIServer"] = sap.UseAIServer,
        ["AIServerPersonalityBase"] = sap.AIServerPersonalityBase,

        --other
        ["OpinionOnEnts"] = sap.OpinionOnEnts,
        ["MaxHealth"] = sap:GetMaxHealth()
    }
    return(tableDataTemp)
end

function DataToSapBot(dataTable,sap,ignoreCertainValues) --turns a table of raw data into the data on a sap bot entity
    sap.Sap_id = dataTable.Sap_id
    sap.Sap_DefaultTrustFactor = dataTable.Sap_DefaultTrustFactor

    if ((dataTable.Sap_PersonalityRandom && ignoreCertainValues) || !dataTable.Sap_PersonalityRandom) then
        sap.Sap_Intelligence = dataTable.Sap_Intelligence
        sap.Sap_Chaos = dataTable.Sap_Chaos
        sap.Sap_IPF_chill = dataTable.Sap_IPF_chill
        sap.Sap_IPF_strict = dataTable.Sap_IPF_strict
        sap.Sap_IPF_calm = dataTable.Sap_IPF_calm
        sap.Sap_IPF_paranoid = dataTable.Sap_IPF_paranoid
        sap.Sap_SM_innocence = dataTable.Sap_SM_innocence
        sap.Sap_SM_corruption = dataTable.Sap_SM_corruption
        sap.Sap_SM_openminded = dataTable.Sap_SM_openminded
        sap.Sap_SM_closeminded = dataTable.Sap_SM_closeminded
    else
        sap.Sap_Intelligence = math.Rand(10, 90)
        sap.Sap_Chaos = math.Rand(1, 10)
        local ipfY = math.Rand(0, 1)
        local ipfX = math.Rand(0, 1)
        local smY = math.Rand(0, 1)
        local smX = math.Rand(0, 1)
        sap.Sap_IPF_chill = 1 - ipfX
        sap.Sap_IPF_strict = ipfX
        sap.Sap_IPF_calm = 1 - ipfY
        sap.Sap_IPF_paranoid = ipfY
        sap.Sap_SM_innocence = 1 - smX
        sap.Sap_SM_corruption = smX
        sap.Sap_SM_openminded = smY
        sap.Sap_SM_closeminded = 1 - smY
    end
    
    sap.Sap_WanderRange = dataTable.Sap_WanderRange

    sap.Sap_PersonalityRandom = dataTable.Sap_PersonalityRandom
    sap.Sap_NameRandom = dataTable.Sap_NameRandom
    sap.Sap_ModelRandom = dataTable.Sap_ModelRandom
    sap.TTSnameRandom = dataTable.TTSnameRandom

    if ((dataTable.Sap_NameRandom && ignoreCertainValues) || !dataTable.Sap_NameRandom) then
        sap.Sap_Name = dataTable.Sap_Name
    else
        sap.Sap_Name = GenerateName()
    end
    if ((dataTable.Sap_ModelRandom && ignoreCertainValues) || !dataTable.Sap_ModelRandom) then
        sap.Sap_Model = dataTable.Sap_Model
    else
        sap.Sap_Model = "random"
    end

    sap.SpawnDone = dataTable.SpawnDone
    sap.SapSpawnOverride = dataTable.SapSpawnOverride
    sap.ColorOverride = dataTable.ColorOverride
    sap.MatOverride = dataTable.MatOverride

    sap.Jumping = dataTable.Jumping
    sap.Stepsounds = dataTable.Stepsounds
    sap.Stress = dataTable.Stress
    sap.EmotionEnabled = dataTable.EmotionEnabled

    sap.Spawning = dataTable.Spawning
    sap.ChatSent = dataTable.ChatSent
    sap.SAPCached = dataTable.SAPCached

    sap.NPCMenuSpawned = dataTable.NPCMenuSpawned

    sap.TTSspeaking = dataTable.TTSspeaking
    sap.TTStruespeak = dataTable.TTStruespeak
    sap.TTStimefornext = dataTable.TTStimefornext
    if ((dataTable.TTSnameRandom && ignoreCertainValues) || !dataTable.TTSnameRandom) then
        sap.TTSname = dataTable.TTSname
    else
        local g,fold = file.Find("sound/sapbots/tts/*", "GAME")
        for g,v in RandomPairs(fold) do
            sap.TTSname = v
            break
        end
    end
    sap.SapSoundboard = dataTable.SapSoundboard
    sap.SapSoundboardOn = dataTable.SapSoundboardOn
    sap.SapSoundboardMode = dataTable.SapSoundboardMode
    sap.SapSoundboardRate = dataTable.SapSoundboardRate
    sap.SapSoundboardCurrent = dataTable.SapSoundboardCurrent
    sap.SapSoundboardMusic = dataTable.SapSoundboardMusic
    sap.DialogSet = dataTable.DialogSet
    sap.TTSenabled = dataTable.TTSenabled
    sap.TTStextform = dataTable.TTStextform
    sap.SapCacheSay = dataTable.SapCacheSay
    sap.SapCacheSaySubject = dataTable.SapCacheSaySubject
    sap.SapCacheSaySubjectInfo = dataTable.SapCacheSaySubjectInfo
    sap.SapCacheSayTime = dataTable.SapCacheSayTime

    sap.EquipWeapons = dataTable.EquipWeapons
    sap.AdminWeapons = dataTable.AdminWeapons

    sap.Fun_AggressionMode = dataTable.Fun_AggressionMode
    sap.Fun_ActivePathingMode = dataTable.Fun_ActivePathingMode
    sap.Fun_IgnoreDoor = dataTable.Fun_IgnoreDoor
    sap.Fun_NoAntistuck = dataTable.Fun_NoAntistuck
    sap.Fun_NoJump = dataTable.Fun_NoJump
    sap.Fun_Votekick = dataTable.Fun_Votekick

    sap.ActionOverridesActive = dataTable.ActionOverridesActive

    sap.CanSpawnProps = dataTable.CanSpawnProps
    sap.CanSpawnLargeProps = dataTable.CanSpawnLargeProps
    sap.CanBuildWithProps = dataTable.CanBuildWithProps
    sap.BuildLearnFromObservation = dataTable.BuildLearnFromObservation
    sap.BuildFormComprehension = dataTable.BuildFormComprehension
    sap.CurrentPropDataset = dataTable.CurrentPropDataset
    sap.SapPropObserveRange = dataTable.SapPropObserveRange
    sap.SapPropLimit = dataTable.SapPropLimit

    sap.UseAIServer = dataTable.UseAIServer
    sap.AIServerPersonalityBase = dataTable.AIServerPersonalityBase

    sap.OpinionOnEnts = dataTable.OpinionOnEnts
end

function verifyJsonFile(nameString,default) --create and/or get data from data json, not datasets from datasets folder
    if !(file.Exists('sapbot','DATA')) then file.CreateDir('sapbot') end --confirm the dir

    if !(file.Exists("sapbot/"..nameString..".png",'DATA')) then --if it does not exist, replace with default contents
        file.Write("sapbot/"..nameString..".png",util.Compress(util.TableToJSON(default)))
    end
    print("Loaded ("..nameString..".png) from file")

    return (util.JSONToTable(util.Decompress(file.Read("sapbot/"..nameString..".png",'DATA')))) --return any resulting value in file
end

function readDatasetFile(nameString)
    if !(file.Exists('sapbot','DATA')) then file.CreateDir('sapbot') end --confirm the dir
    --if !(file.Exists('sapbot/datasets','DATA')) then file.CreateDir('sapbot/datasets') end --confirm the dir of datasets
    --local returnVal
    --if !(file.Exists('sapbot/datasets','DATA')) then file.CreateDir('sapbot') end

    return (util.JSONToTable(util.Decompress(file.Read("materials/sapbot/datasets/"..nameString,'GAME')))) --return any resulting value in file
end

function confirmSaveData(isNone) --save dataset changes to the dataset, will override data if not set correctly!!?
    if (SERVER) then
        if (!isNone) then
            print("- - - S.A.P Bot Dataset Issue - - -")
            print("S.A.P Bot trying to save props dataset file, when dataset not set to the default of none.")
            print("This means that you are currently selecting another dataset, and you must switch the S.A.P Bot's")
            print("dataset back to none, so it can save its changes.")
            print("If you wish to edit the current dataset instead, then simply move it so it replaces propdataset.png")
            print("It cannot edit a dataset that is not this file.")
            print("When done editting, rename your file and move it into the datasets folder. to use it without editting.")
            print("- - - - - - - - - - - - - - - - - -")
        else
            if (_SapbotPropDatasets["none.png"] != nil && _SapbotPropDatasetLast != _SapbotPropDatasets["none.png"]) then
                if !(file.Exists('sapbot','DATA')) then file.CreateDir('sapbot') end --confirm the dir
                _SapbotPropDatasetLast = _SapbotPropDatasets["none.png"]
                if (SAPBOTDEBUG) then print("Saving Prop Dataset to file...") end
                file.Write("sapbot/propDataset.png",util.Compress(util.TableToJSON(_SapbotPropDatasets["none.png"],true)))
            end
        end
    end
end

--_Sapbot_PropStructureDataset

function confirmData()
    if (SERVER) then
        declareDefaultData()
        if ((_Sapbot_PropsList) == nil) then --props list table, loads from json
            _Sapbot_PropsList = verifyJsonFile('prop',SapDefaultPropsWhitelist)
        end
        if ((_SapbotPropDatasets["none.png"]) == nil) then --dataset of prop positions, models, colors, angles, creation id's, and batches (lossy value defining if they are grouped together or not) and their weld connections???
            local testTable = { --test table, for manual code testing
                ["batch0"] = {
                    {
                        ["creationID"] = 0,
                        ["model"] = "models/props_junk/metal_paintcan001b.mdl",
                        ["pos"] = Vector(0,0,0),
                        ["angle"] = Angle(0,0,0),
                        ["color"] = Color(0,0,0),
                        ["mat"] = ""
                    },
                    {
                        ["creationID"] = 1,
                        ["model"] = "models/props_c17/chair02a.mdl",
                        ["pos"] = Vector(32,0,0),
                        ["angle"] = Angle(45,0,0),
                        ["color"] = Color(255,0,0),
                        ["mat"] = ""
                    }
                },
                ["batch1"] = {
                    {
                        ["creationID"] = 3,
                        ["model"] = "models/props_c17/furniturebed001a.mdl",
                        ["pos"] = Vector(0,0,0),
                        ["angle"] = Angle(45,0,45),
                        ["color"] = Color(0,0,255),
                        ["mat"] = ""
                    },
                    {
                        ["creationID"] = 4,
                        ["model"] = "models/props_c17/gravestone_cross001b.mdl",
                        ["pos"] = Vector(0,64,0),
                        ["angle"] = Angle(0,45,0),
                        ["color"] = Color(0,255,0),
                        ["mat"] = ""
                    }
                }
            }

            _SapbotPropDatasets["none.png"] = verifyJsonFile('propDataset',testTable)
            GatherAllPropDatasets()
        end
    end
end

function ENT:PropDetected(propEnt)
    if !(self.BuildLearnFromObservation) then return end

    if (propEnt:GetClass() != "prop_physics") then return end
    if (propEnt.IsSapProp) then return end --cannot get dataset data from sap bots, would feedback loop

    if (IsValid(propEnt:GetCreator())) then
        local owner = GetBestName(propEnt:GetCreator()).."|"..GetCurTimeBatch() --get ideal clean name of prop owner, and some batch variation
        if (propEnt.SapDataLogged) then owner = propEnt.SapDataBatch end --if it is already logged, then it must already have a batch
        local viable = true
        local replaceposint = -1
        local propTable = {
            ["creationID"] = propEnt:GetCreationID(),
            ["model"] = propEnt:GetModel(),
            ["pos"] = propEnt:GetPos() - self:GetPos(), --relative to sap bot?? maybe change this if it causes lag issues cause the updates of rel pos offsets
            ["angle"] = propEnt:GetAngles(),
            ["color"] = propEnt:GetColor(),
            ["mat"] = propEnt:GetMaterial()
        }
        if (_SapbotPropDatasets[self.CurrentPropDataset] == nil) then
            print("S.A.P Bot prop dataset ("..self.CurrentPropDataset..") contains nothing, please double check if dataset is valid or working")
        else
            if (_SapbotPropDatasets[self.CurrentPropDataset][owner] != nil) then
                for k,v in ipairs(_SapbotPropDatasets[self.CurrentPropDataset][owner]) do --double checking with the data in the tables and the actual data of the prop
                    if (v.creationID == propTable.creationID) then
                        viable = false
                        if (v.pos != propTable.pos) then
                            replaceposint = k
                            viable = true
                        end
                        if (propEnt.SapDataLogged) then
                            if (propEnt.SapDataLastPos != propTable.pos) then
                                replaceposint = k
                                viable = true
                            end
                        end
                    end
                end

                --triple checking with now all the data of the stored data on the prop, and its actual prop data currently
                if (propEnt.SapDataLogged) then
                    if (propEnt.SapDataLastPos == propTable.pos) then --it has not moved, ignore the viable value, force stop logic
                        viable = false
                    end
                end

                if (viable) then
                    if (replaceposint == -1) then
                        table.insert(_SapbotPropDatasets[self.CurrentPropDataset][owner], propTable)
                    else
                        _SapbotPropDatasets[self.CurrentPropDataset][owner][replaceposint] = propTable --replace data in already pre-existing
                    end

                    if (!propEnt.SapDataLogged) then propEnt.SapDataBatch = owner end
                    propEnt.SapDataLogged = true
                    propEnt.SapDataLastPos = propEnt.SapDataLogged
                    confirmSaveData((self.CurrentPropDataset == "none.png"))
                    --if (SAPBOTDEBUG) then print("New Prop Structure Dataset data collected, of S.A.P Bots observing player buildings. Subject Batch:"..owner.." ID:"..propEnt:GetCreationID()) end
                end
            else
                if (propEnt.SapDataLogged) then return end --cannot already be logged, if you want to make a entie new subject batch entry
                local nestedTable = {}
                table.insert(nestedTable,propTable) --put it another layer deep
                propEnt.SapDataLogged = true
                propEnt.SapDataBatch = owner
                propEnt.SapDataLastPos = propEnt.SapDataLogged
                
                _SapbotPropDatasets[self.CurrentPropDataset][owner] = nestedTable
                _SapbotPropDatasetLast = nil
                if (SAPBOTDEBUG) then print("Created new batch entry for dataset ("..self.CurrentPropDataset..") of props of owner "..owner.." host prop model of the first is "..propEnt:GetModel()) end
                confirmSaveData((self.CurrentPropDataset == "none.png"))
            end
        end
    end
end

function GatherAllPropDatasets() --collect all datasets in the sub data datasets folder, for non-direct editting
    if !(file.Exists('sapbot','DATA')) then file.CreateDir('sapbot') end --confirm the dir
    --if !(file.Exists('materials/sapbot/datasets','GAME')) then file.CreateDir('sapbot/datasets') end --confirm the dir of datasets

    if (file.Exists( "materials/sapbot/datasets", "GAME" )) then
        local files, directories = file.Find("materials/sapbot/datasets/*", "GAME")
        for k,file in pairs(files) do --turn each file into a dataset table
            if (SAPBOTDEBUG) then
                print("S.A.P Bots Loading dataset ("..file..") from datasets data folder")
            end
            _SapbotPropDatasets[file] = readDatasetFile(file)
        end
    else
        print("S.A.P Bots Unable to Locate Datasets Dir??")
    end
end

function declareDefaultData()
    if (SapDefaultPropsWhitelist == nil) then
        SapDefaultPropsWhitelist = {
            "models/cranes/crane_frame.mdl",
            "models/props_borealis/mooring_cleat01.mdl",                                 
            "models/props_borealis/door_wheel001a.mdl",                               
            "models/props_borealis/borealis_door001a.mdl",
            "models/props_borealis/bluebarrel001.mdl",
            "models/props_building_details/storefront_template001a_bars.mdl",
            "models/props_c17/canister01a.mdl",
            "models/props_c17/canister02a.mdl",
            "models/props_c17/canister_propane01a.mdl",
            "models/props_c17/bench01a.mdl",
            "models/props_c17/chair02a.mdl",
            "models/props_c17/column02a.mdl",
            "models/props_c17/concrete_barrier001a.mdl",
            "models/props_c17/display_cooler01a.mdl",
            "models/props_c17/door01_left.mdl",
            "models/props_c17/door02_double.mdl",
            "models/props_c17/fence01a.mdl",
            "models/props_c17/fence01b.mdl",
            "models/props_c17/fence02a.mdl",
            "models/props_c17/fence02b.mdl",
            "models/props_c17/fence03a.mdl",
            "models/props_c17/fence04a.mdl",
            "models/props_c17/fountain_01.mdl",
            "models/props_c17/furniturebathtub001a.mdl",
            "models/props_c17/furniturebed001a.mdl",
            "models/props_c17/furnitureboiler001a.mdl",
            "models/props_c17/furnitureshelf002a.mdl",
            "models/props_c17/furnitureshelf001a.mdl",
            "models/props_c17/furnituredrawer001a_chunk01.mdl",
            "models/props_c17/furnituredrawer001a_chunk02.mdl",
            "models/props_c17/furnituredrawer001a_chunk03.mdl",
            "models/props_c17/furnituredrawer001a_chunk06.mdl",
            "models/props_c17/furnitureradiator001a.mdl",
            "models/props_c17/gate_door01a.mdl",
            "models/props_c17/furnitureshelf001b.mdl",
            "models/props_c17/gravestone001a.mdl",
            "models/props_c17/gravestone003a.mdl",
            "models/props_c17/gravestone004a.mdl",
            "models/props_c17/gaspipes006a.mdl",
            "models/props_c17/gravestone002a.mdl",
            "models/props_c17/gravestone_cross001a.mdl",
            "models/props_junk/plasticcrate01a.mdl",
            "models/props_c17/gate_door02a.mdl",
            "models/props_c17/gravestone_coffinpiece001a.mdl",
            "models/props_c17/gravestone_coffinpiece002a.mdl",
            "models/props_junk/plasticcrate01a.mdl",
            "models/props_junk/plasticcrate01a.mdl",
            "models/props_junk/plasticcrate01a.mdl",
            "models/props_junk/plasticcrate01a.mdl",
            "models/props_c17/gravestone_cross001b.mdl",
            "models/props_c17/gravestone_statue001a.mdl",
            "models/props_c17/lampshade001a.mdl",
            "models/props_c17/lockers001a.mdl",
            "models/props_c17/metalladder001.mdl",
            "models/props_c17/metalladder002.mdl",
            "models/props_c17/metalladder002b.mdl",
            "models/props_c17/metalladder003.mdl",
            "models/props_c17/oildrum001.mdl",
            "models/props_c17/oildrum001_explosive.mdl",
            "models/props_c17/pulleyhook01.mdl",
            "models/props_c17/pulleywheels_large01.mdl",
            "models/props_c17/signpole001.mdl",
            "models/props_c17/trappropeller_blade.mdl",
            "models/props_canal/bridge_pillar02.mdl",
            "models/props_canal/canal_cap001.mdl",
            "models/props_citizen_tech/windmill_blade002a.mdl",
            "models/props_citizen_tech/windmill_blade004a.mdl",
            "models/props_combine/breenchair.mdl",
            "models/props_combine/breendesk.mdl",
            "models/props_combine/breenglobe.mdl",
            "models/props_combine/combine_barricade_short02a.mdl",
            "models/props_combine/combine_bridge_b.mdl",
            "models/props_combine/combine_fence01a.mdl",
            "models/props_combine/combine_fence01b.mdl",
            "models/props_combine/combine_window001.mdl",
            "models/props_combine/headcrabcannister01a.mdl",
            "models/props_combine/weaponstripper.mdl",
            "models/props_debris/metal_panel01a.mdl",
            "models/props_debris/metal_panel02a.mdl",
            "models/props_docks/channelmarker_gib01.mdl",
            "models/props_docks/channelmarker_gib02.mdl",
            "models/combine_helicopter/helicopter_bomb01.mdl",
            "models/props_docks/channelmarker_gib03.mdl",
            "models/props_docks/channelmarker_gib04.mdl",
            "models/props_docks/dock01_cleat01a.mdl",
            "models/props_docks/dock01_pole01a_128.mdl",
            "models/props_docks/dock01_pole01a_256.mdl",
            "models/props_docks/dock02_pole02a.mdl",
            "models/props_docks/dock02_pole02a_256.mdl",
            "models/props_docks/dock03_pole01a.mdl",
            "models/props_docks/dock03_pole01a_256.mdl",
            "models/props_doors/door03_slotted_left.mdl",
            "models/props_foliage/tree_poplar_01.mdl",
            "models/props_interiors/bathtub01a.mdl",
            "models/props_interiors/elevatorshaft_door01a.mdl",
            "models/props_interiors/furniture_chair03a.mdl",
            "models/props_trainstation/mount_connection001a.mdl",
            "models/props_trainstation/pole_448connection002b.mdl",
            "models/props_lab/lockerdoorleft.mdl",
            "models/props_trainstation/benchoutdoor01a.mdl",
            "models/props_trainstation/bench_indoor001a.mdl",
            "models/props_trainstation/ceiling_arch001a.mdl",
            "models/props_trainstation/clock01.mdl",
            "models/props_trainstation/column_arch001a.mdl",
            "models/props_interiors/furniture_vanity01a.mdl",
            "models/props_interiors/pot01a.mdl",
            "models/props_interiors/furniture_shelf01a.mdl",
            "models/props_wasteland/wheel02b.mdl",
            "models/props_wasteland/wheel03b.mdl",
            "models/props_wasteland/wheel01.mdl",
            "models/props_trainstation/pole_448connection001a.mdl",
            "models/props_interiors/pot02a.mdl",
            "models/props_interiors/radiator01a.mdl",
            "models/props_interiors/refrigerator01a.mdl",
            "models/props_interiors/refrigeratordoor01a.mdl",
            "models/props_interiors/refrigeratordoor02a.mdl",
            "models/props_interiors/sinkkitchen01a.mdl",
            "models/props_interiors/vendingmachinesoda01a.mdl",
            "models/props_interiors/vendingmachinesoda01a_door.mdl",
            "models/props_junk/cardboard_box003a.mdl",
            "models/props_junk/cardboard_box002a.mdl",
            "models/props_junk/cardboard_box004a.mdl",
            "models/props_junk/cinderblock01a.mdl",
            "models/props_junk/gascan001a.mdl",
            "models/props_junk/harpoon002a.mdl",
            "models/props_junk/ibeam01a_cluster01.mdl",
            "models/props_junk/ibeam01a.mdl",
            "models/props_junk/meathook001a.mdl",
            "models/props_junk/metal_paintcan001a.mdl",
            "models/props_junk/metalbucket01a.mdl",
            "models/props_junk/metalbucket02a.mdl",
            "models/props_junk/metalgascan.mdl",
            "models/props_junk/plasticbucket001a.mdl",
            "models/props_junk/popcan01a.mdl",
            "models/props_junk/propane_tank001a.mdl",
            "models/props_junk/propanecanister001a.mdl",
            "models/props_junk/pushcart01a.mdl",
            "models/props_junk/ravenholmsign.mdl",
            "models/props_junk/sawblade001a.mdl",
            "models/props_junk/trashbin01a.mdl",
            "models/props_junk/trafficcone001a.mdl",
            "models/props_junk/trashdumpster02b.mdl",
            "models/props_junk/trashdumpster01a.mdl",
            "models/props_junk/trashdumpster02.mdl",
            "models/props_junk/wood_crate001a_damaged.mdl",
            "models/props_junk/wood_pallet001a.mdl",
            "models/props_lab/blastdoor001a.mdl",
            "models/props_lab/blastdoor001b.mdl",
            "models/props_lab/blastdoor001c.mdl",
            "models/props_lab/filecabinet02.mdl",
            "models/props_trainstation/tracksign01.mdl",
            "models/props_trainstation/tracksign02.mdl",
            "models/props_trainstation/tracksign03.mdl",
            "models/props_trainstation/tracksign07.mdl",
            "models/props_trainstation/tracksign08.mdl",
            "models/props_trainstation/tracksign09.mdl",
            "models/props_trainstation/tracksign10.mdl",
            "models/props_trainstation/traincar_rack001.mdl",
            "models/props_trainstation/trainstation_clock001.mdl",
            "models/props_trainstation/trainstation_ornament001.mdl",
            "models/props_trainstation/trainstation_ornament002.mdl",
            "models/props_trainstation/trainstation_post001.mdl",
            "models/props_trainstation/trashcan_indoor001a.mdl",
            "models/props_trainstation/trashcan_indoor001b.mdl",
            "models/props_vehicles/tire001a_tractor.mdl",
            "models/props_vehicles/tire001b_truck.mdl",
            "models/props_vehicles/tire001c_car.mdl",
            "models/props_vehicles/apc_tire001.mdl",
            "models/props_wasteland/barricade001a.mdl",
            "models/props_wasteland/barricade002a.mdl",
            "models/props_wasteland/buoy01.mdl",
            "models/props_wasteland/cafeteria_bench001a.mdl",
            "models/props_wasteland/cafeteria_table001a.mdl",
            "models/props_wasteland/cargo_container01.mdl",
            "models/props_wasteland/cargo_container01c.mdl",
            "models/props_wasteland/cargo_container01b.mdl",
            "models/props_wasteland/controlroom_desk001a.mdl",
            "models/props_wasteland/controlroom_filecabinet001a.mdl",
            "models/props_wasteland/controlroom_chair001a.mdl",
            "models/props_wasteland/controlroom_desk001b.mdl",
            "models/props_wasteland/controlroom_filecabinet002a.mdl",
            "models/props_wasteland/controlroom_storagecloset001a.mdl",
            "models/props_wasteland/controlroom_storagecloset001b.mdl",
            "models/props_wasteland/coolingtank02.mdl",
            "models/props_wasteland/cranemagnet01a.mdl",
            "models/props_wasteland/dockplank01b.mdl",
            "models/props_wasteland/gaspump001a.mdl",
            "models/props_wasteland/horizontalcoolingtank04.mdl",
            "models/props_wasteland/interior_fence001g.mdl",
            "models/props_wasteland/interior_fence002d.mdl",
            "models/props_wasteland/interior_fence002e.mdl",
            "models/props_wasteland/wheel01a.mdl",
            "models/props_wasteland/kitchen_shelf002a.mdl",
            "models/props_wasteland/wood_fence02a.mdl",
            "models/props_wasteland/laundry_dryer001.mdl",
            "models/props_wasteland/laundry_washer001a.mdl",
            "models/props_wasteland/medbridge_base01.mdl",
            "models/props_wasteland/medbridge_strut01.mdl",
            "models/props_wasteland/prison_bedframe001b.mdl",
            "models/props_wasteland/prison_heater001a.mdl",
            "models/props_wasteland/prison_shelf002a.mdl",
            "models/props_wasteland/panel_leverhandle001a.mdl",
            "models/props_wasteland/prison_lamp001c.mdl",
            "models/props_wasteland/wheel02a.mdl",
            "models/props_wasteland/laundry_basket001.mdl",
            "models/props_wasteland/light_spotlight01_lamp.mdl",
            "models/props_wasteland/wood_fence01a.mdl",
            "models/props_wasteland/laundry_dryer002.mdl",
            "models/props_wasteland/prison_celldoor001b.mdl",
            "models/props_wasteland/wheel03a.mdl",
            "models/props_wasteland/medbridge_post01.mdl",
            "models/gibs/hgibs.mdl",
            "models/gibs/hgibs_spine.mdl",
            "models/props_c17/briefcase001a.mdl",
            "models/props_c17/bench01a.mdl",
            "models/props_c17/cashregister01a.mdl",
            "models/props_c17/chair_kleiner03a.mdl",
            "models/props_c17/chair_stool01a.mdl",
            "models/props_c17/chair_office01a.mdl",
            "models/props_c17/clock01.mdl",
            "models/props_c17/computer01_keyboard.mdl",
            "models/props_c17/consolebox01a.mdl",
            "models/props_c17/consolebox03a.mdl",
            "models/props_c17/consolebox05a.mdl",
            "models/props_c17/doll01.mdl",
            "models/props_c17/frame002a.mdl",
            "models/props_c17/furniturewashingmachine001a.mdl",
            "models/props_c17/furnituretoilet001a.mdl",
            "models/props_c17/furnituresink001a.mdl",
            "models/props_c17/lamp001a.mdl",
            "models/props_c17/metalpot001a.mdl",
            "models/props_c17/metalpot002a.mdl",
            "models/props_c17/playground_carousel01.mdl",
            "models/props_c17/playground_jungle_gym01a.mdl",
            "models/props_c17/playground_jungle_gym01b.mdl",
            "models/props_c17/playground_swingset01.mdl",
            "models/props_c17/playground_teetertoter_seat.mdl",
            "models/props_c17/playground_teetertoter_stan.mdl",
            "models/props_c17/playgroundslide01.mdl",
            "models/props_c17/playgroundtick-tack-toe_block01a.mdl",
            "models/props_c17/playgroundtick-tack-toe_post01.mdl",
            "models/props_c17/statue_horse.mdl",
            "models/props_c17/streetsign001c.mdl",
            "models/props_c17/streetsign002b.mdl",
            "models/props_c17/streetsign003b.mdl",
            "models/props_c17/streetsign004e.mdl",
            "models/props_c17/streetsign004f.mdl",
            "models/props_c17/streetsign005b.mdl",
            "models/props_c17/streetsign005c.mdl",
            "models/props_c17/streetsign005d.mdl",
            "models/props_c17/suitcase001a.mdl",
            "models/props_c17/suitcase_passenger_physics.mdl",
            "models/props_c17/tools_wrench01a.mdl",
            "models/props_c17/trappropeller_blade.mdl",
            "models/props_c17/trappropeller_engine.mdl",
            "models/props_c17/trappropeller_lever.mdl",
            "models/props_c17/tv_monitor01.mdl",
            "models/props_canal/mattpipe.mdl",
            "models/props_combine/breenbust.mdl",
            "models/props_combine/breenchair.mdl",
            "models/props_combine/combine_intmonitor001.mdl",
            "models/props_combine/combine_interface001.mdl",
            "models/props_combine/combine_monitorbay.mdl",
            "models/props_combine/combinethumper001a.mdl",
            "models/props_combine/combinethumper002.mdl",
            "models/props_combine/combinetower001.mdl",
            "models/props_combine/health_charger001.mdl",
            "models/props_combine/suit_charger001.mdl",
            "models/props_doors/door03_slotted_left.mdl",
            "models/props_interiors/furniture_chair01a.mdl",
            "models/props_interiors/furniture_chair03a.mdl",
            "models/props_interiors/furniture_couch01a.mdl",
            "models/props_interiors/furniture_couch02a.mdl",
            "models/props_interiors/furniture_desk01a.mdl",
            "models/props_interiors/furniture_lamp01a.mdl",
            "models/props_interiors/furniture_shelf01a.mdl",
            "models/props_interiors/furniture_vanity01a.mdl",
            "models/props_interiors/pot01a.mdl",
            "models/props_interiors/pot02a.mdl",
            "models/props_interiors/radiator01a.mdl",
            "models/props_interiors/refrigerator01a.mdl",
            "models/props_interiors/refrigeratordoor01a.mdl",
            "models/props_interiors/refrigeratordoor02a.mdl",
            "models/props_interiors/sinkkitchen01a.mdl",
            "models/props_interiors/vendingmachinesoda01a.mdl",
            "models/props_interiors/vendingmachinesoda01a_door.mdl",
            "models/props_junk/bicycle01a.mdl",
            "models/props_junk/garbage128_composite001a.mdl",
            "models/props_junk/garbage128_composite001b.mdl",
            "models/props_junk/garbage128_composite001c.mdl",
            "models/props_junk/garbage128_composite001d.mdl",
            "models/props_junk/garbage256_composite001a.mdl",
            "models/props_junk/garbage256_composite001b.mdl",
            "models/props_junk/garbage256_composite002a.mdl",
            "models/props_junk/garbage256_composite002b.mdl",
            "models/props_junk/garbage_bag001a.mdl",
            "models/props_junk/garbage_carboard002a.mdl",
            "models/props_junk/garbage_coffeemug001a.mdl",
            "models/props_junk/garbage_glassbottle001a.mdl",
            "models/props_junk/garbage_glassbottle002a.mdl",
            "models/props_junk/garbage_glassbottle003a.mdl",
            "models/props_junk/garbage_metalcan001a.mdl",
            "models/props_junk/garbage_metalcan002a.mdl",
            "models/props_junk/garbage_milkcarton001a.mdl",
            "models/props_junk/garbage_milkcarton002a.mdl",
            "models/props_junk/garbage_newspaper001a.mdl",
            "models/props_junk/garbage_plasticbottle001a.mdl",
            "models/props_junk/garbage_plasticbottle002a.mdl",
            "models/props_junk/garbage_plasticbottle003a.mdl",
            "models/props_junk/garbage_takeoutcarton001a.mdl",
            "models/props_junk/gascan001a.mdl",
            "models/props_junk/glassbottle01a.mdl",
            "models/props_junk/glassjug01.mdl",
            "models/props_junk/harpoon002a.mdl",
            "models/props_junk/meathook001a.mdl",
            "models/props_junk/metal_paintcan001a.mdl",
            "models/props_junk/metal_paintcan001b.mdl",
            "models/props_junk/metalbucket01a.mdl",
            "models/props_junk/metalbucket02a.mdl",
            "models/props_junk/metalgascan.mdl",
            "models/props_junk/plasticbucket001a.mdl",
            "models/props_junk/plasticcrate01a.mdl",
            "models/props_junk/popcan01a.mdl",
            "models/props_junk/ravenholmsign.mdl",
            "models/props_junk/sawblade001a.mdl",
            "models/props_junk/shovel01a.mdl",
            "models/props_junk/terracotta01.mdl",
            "models/props_junk/trashbin01a.mdl",
            "models/props_junk/trafficcone001a.mdl",
            "models/props_junk/watermelon01.mdl",
            "models/props_junk/wheebarrow01a.mdl",
            "models/props_lab/bewaredog.mdl",
            "models/props_lab/binderblue.mdl",
            "models/props_lab/binderbluelabel.mdl",
            "models/props_lab/bindergraylabel01a.mdl",
            "models/props_lab/bindergreen.mdl",
            "models/props_lab/bindergraylabel01b.mdl",
            "models/props_lab/bindergreenlabel.mdl",
            "models/props_lab/binderredlabel.mdl",
            "models/props_lab/box01a.mdl",
            "models/props_lab/box01b.mdl",
            "models/props_lab/cactus.mdl",
            "models/props_lab/citizenradio.mdl",
            "models/props_lab/clipboard.mdl",
            "models/props_lab/desklamp01.mdl",
            "models/props_lab/frame002a.mdl",
            "models/props_lab/harddrive02.mdl",
            "models/props_lab/harddrive01.mdl",
            "models/props_lab/hevplate.mdl",
            "models/props_lab/huladoll.mdl",
            "models/props_lab/jar01a.mdl",
            "models/props_lab/jar01b.mdl",
            "models/props_lab/kennel_physics.mdl",
            "models/props_lab/monitor01a.mdl",
            "models/props_lab/monitor01b.mdl",
            "models/props_lab/monitor02.mdl",
            "models/props_lab/partsbin01.mdl",
            "models/props_lab/plotter.mdl",
            "models/props_lab/reciever01a.mdl",
            "models/props_lab/reciever01b.mdl",
            "models/props_lab/reciever01c.mdl",
            "models/props_lab/reciever01d.mdl",
            "models/props_lab/reciever_cart.mdl",
            "models/props_lab/securitybank.mdl",
            "models/props_lab/servers.mdl",
            "models/props_lab/tpplug.mdl",
            "models/props_lab/tpplugholder_single.mdl",
            "models/props_lab/tpplugholder.mdl",
            "models/props_lab/workspace001.mdl",
            "models/props_lab/workspace002.mdl",
            "models/props_lab/workspace003.mdl",
            "models/props_lab/workspace004.mdl",
            "models/props_lab/harddrive02.mdl",
            "models/props_c17/furniturecouch001a.mdl",
            "models/props_c17/furnituredrawer001a.mdl",
            "models/props_c17/furnituredresser001a.mdl",
            "models/props_c17/furnituredrawer003a.mdl",
            "models/props_c17/furniturestove001a.mdl",
            "models/props_c17/furniturefridge001a.mdl",
            "models/props_c17/furniturefireplace001a.mdl",
            "models/props_c17/furnituretable001a.mdl",
            "models/props_c17/furnituretable002a.mdl",
            "models/props_c17/furnituretable003a.mdl",
            "models/props_wasteland/kitchen_counter001b.mdl",
            "models/props_wasteland/kitchen_counter001d.mdl",
            "models/props_wasteland/kitchen_shelf001a.mdl",
            "models/props_wasteland/kitchen_fridge001a.mdl",
            "models/props_wasteland/kitchen_counter001c.mdl",
            "models/props_wasteland/kitchen_counter001a.mdl",
            "models/props_wasteland/kitchen_stove001a.mdl",
            "models/props_wasteland/kitchen_stove002a.mdl",
            "models/props_wasteland/laundry_washer003.mdl",
            "models/props_wasteland/laundry_cart002.mdl",
            "models/props_wasteland/laundry_cart001.mdl",
            "models/props_c17/shelfunit01a.mdl",
            "models/props_junk/wood_crate002a.mdl",
            "models/props_junk/wood_crate001a.mdl",
            "models/maxofs2d/hover_propeller.mdl",
            "models/maxofs2d/hover_rings.mdl",
        }
    end
end