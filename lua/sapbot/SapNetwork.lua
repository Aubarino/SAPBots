-- -- -- -- -- -- -- -- -- --
-- S.A.P Bot Network related code - net. table overrides, to make them think saps are player with a networkable setup -- -- --
-- -- -- -- -- -- -- -- -- --
AddCSLuaFile()

-- net related stuff
local originalNetSend = net.Send
local originalNetStart = net.Start
local originalNetReceive = net.Receive
local originalNetWriteEnt = net.WriteEntity
local originalNetReadEnt = net.ReadEntity
local originalNetBroadcast = net.Broadcast
local originalNetWriteString = net.WriteString
local originalNetReadString = net.ReadString
sapNetSapBot = nil -- overrides net stuff
sapNetMessageActive = false --kinda useless
sapNetText = ""
sapNetString = ""
sapNetListeningFunction = sapNetListeningFunction or {}
sapNetExecuteFunction = sapNetExecuteFunction or {}
sapNetEntity = nil

-- Secure command function to be executed on the server
if SERVER then
    util.AddNetworkString("sap_custom_net_command")
    concommand.Add("sap_custom_net_command", function(ply, cmd, args)
        if not args[1] or not args[2] then return end
        local messageName = args[1]
        local serializedData = args[2]
        --print("sap receive get for ("..messageName..")")
        if #serializedData > 2048 then return end  -- Prevent large data
        local data = util.JSONToTable(serializedData)
        --print("sap receive get 2ndary for ("..serializedData..")")
        if not data then return end
        if sapNetListeningFunction[messageName] then
            --print("Triggering client function for message: " .. messageName)
            sapNetListeningFunction[messageName](data)  -- Process the data with the original callback
        end
    end)
end

function net.Send(plys)
    if not sapNetMessageActive then return end
    local players = istable(plys) and plys or {plys}
    for _, ply in ipairs(players) do
        if IsValid(ply) and ply:IsPlayer() then
            if ply:GetClass() != "sap_bot" then
                sapNetSapBot = nil
                --print("Sent to player: " .. ply:Nick())
                originalNetSend({ply})
            else
                sapNetSapBot = ply  -- Custom net.Send function called for sap_bot
                --print("Sent to sap bot: " .. ply:Nick())
            end
        end
    end
end


function net.Start(messageName)
    net.Start(messageName, false)
end

function net.Start(messageName, unreliable)
    sapNetString = ""
    if (sapNetSapBot != nil) then
        sapNetSapBot = nil
        sapNetEntity = nil
    end
    if (sapNetText == messageName) then net.Abort() end --already active
    sapNetMessageActive = true
    sapNetText = messageName
    if (sapNetText != nil) then
        if (sapNetListeningFunction[sapNetText] != nil) then --doesn't work for now
            --print("Starting net message: " .. sapNetText)
            sapNetListeningFunction[sapNetText]()
        end
    end
    originalNetStart(messageName, unreliable)
end

function net.WriteEntity(ply)
    if ply:GetClass() == "sap_bot" then
        sapNetEntity = ply
        sapNetSapBot = ply
    end
    originalNetWriteEnt(ply)
end

function net.ReadEntity()
    if (sapNetSapBot != nil) then
        return(sapNetEntity)
    else
        return originalNetReadEnt()
    end
end

function net.Broadcast()
    if sapNetMessageActive then
        if (sapNetText != nil) then
            if (sapNetListeningFunction[sapNetText] != nil) then
                --print("Broadcasting net message: " .. sapNetText)
                sapNetListeningFunction[sapNetText]()
            end
        end
    end
    originalNetBroadcast()
end

function net.Receive(messageName, callback)
    sapNetExecuteFunction[messageName] = callback
    --print("net function set for " .. messageName)
    if (CLIENT) then
        sapNetListeningFunction[messageName] = function()
            local receivedData = {}
            while true do
                local chunk = net.ReadString()
                if not chunk or chunk == "" then break end
                table.insert(receivedData, chunk)
            end
            local data = table.concat(receivedData)
            local serializedData = util.TableToJSON({data})
            LocalPlayer():ConCommand("sap_custom_net_command " .. messageName .. " " .. serializedData)
            --print("sap receive net registered for (" .. messageName .. ")")
        end
    end
    originalNetReceive(messageName, callback)
end

function net.WriteString(stringIn)
    sapNetString = stringIn
    originalNetWriteString(stringIn)
end

function net.ReadString()
    if (sapNetSapBot != nil) then
        print("oop sap net active")
        return(sapNetString)
    end
    return originalNetReadString()
end