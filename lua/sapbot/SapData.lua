AddCSLuaFile()

_Sapbot_WeaponBlacklist = {} --weapons to not spawn with or use

function verifyJsonFile(nameString) --create and/or get data from data json
    if !(file.Exists('sapbot','DATA')) then file.CreateDir('sapbot') end --confirm the dir

    if !(file.Exists("sapbot/"..nameString,'DATA')) then --if it does not exist, replace with default contents
        file.Write("sapbot/"..nameString,file.Read('data/sapbot/'..nameString,'GAME'))
    end
    print("Loaded ("..nameString..") from file")
    return (util.JSONToTable(file.Read("sapbot/"..nameString))) --return any resulting value in file
end

function confirmSaveData() --save dataset changes to the dataset, will override data if not set correctly!!?
    if (SERVER) then
        if (_Sapbot_PropStructureDataset != nil) then
            file.Write("sapbot/propDataset.json",util.TableToJSON(_Sapbot_PropStructureDataset,true))
        end
    end
end

function confirmData()
    if (SERVER) then
        if ((_Sapbot_PropsList) == nil) then --props list table, loads from json
            _Sapbot_PropsList = verifyJsonFile('prop.json')
        end
        if ((_Sapbot_PropStructureDataset) == nil) then --dataset of prop positions, models, colors, angles, creation id's, and batches (lossy value defining if they are grouped together or not) and their weld connections???
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
            _Sapbot_PropStructureDataset = verifyJsonFile('propDataset.json')
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
        if (_Sapbot_PropStructureDataset[owner] != nil) then
            for k,v in ipairs(_Sapbot_PropStructureDataset[owner]) do --double checking with the data in the tables and the actual data of the prop
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
                    table.insert(_Sapbot_PropStructureDataset[owner], propTable)
                else
                    _Sapbot_PropStructureDataset[owner][replaceposint] = propTable --replace data in already pre-existing
                end

                if (!propEnt.SapDataLogged) then propEnt.SapDataBatch = owner end
                propEnt.SapDataLogged = true
                propEnt.SapDataLastPos = propEnt.SapDataLogged
                confirmSaveData()
                --if (SAPBOTDEBUG) then print("New Prop Structure Dataset data collected, of S.A.P Bots observing player buildings. Subject Batch:"..owner.." ID:"..propEnt:GetCreationID()) end
            end
        else
            if (propEnt.SapDataLogged) then return end --cannot already be logged, if you want to make a entie new subject batch entry
            local nestedTable = {}
            table.insert(nestedTable,propTable) --put it another layer deep
            propEnt.SapDataLogged = true
            propEnt.SapDataBatch = owner
            propEnt.SapDataLastPos = propEnt.SapDataLogged
            
            _Sapbot_PropStructureDataset[owner] = nestedTable
            if (SAPBOTDEBUG) then print("created new batch entry for dataset of props of owner "..owner.." host prop model of the first is "..propEnt:GetModel()) end
        end
    end
end

function ENT:observeSurroundings()

end