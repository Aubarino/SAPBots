AddCSLuaFile()

-- vote kick ui stuff
SapVoteTextures = {}
local function sapGenVoteTex(name)
    local curMat = Material("custom/sap/"..name..".png","alphatest noclamp")
    print("registered for custom/sap/"..name..".png mat "..tostring(curMat))
    SapVoteTextures[name] = curMat
end

sapVoteSlideOutTime = 0.3
sapVoteActive = false
sapVoteFinal = false
sapVoteClientVanishTime = 0
sapVoteInfo = {
    ["sapVoteReason"] = "no reason given",
    ["sapVoteYes"] = 0,
    ["sapVoteNo"] = 0,
    ["sapVoteWinner"] = "",
    ["sapVoteUser"] = "IN THE BALLS"
}
sapVoteInfoChange = {
    ["sapVoteReason"] = "no reason given",
    ["sapVoteYes"] = 0,
    ["sapVoteNo"] = 0,
    ["sapVoteWinner"] = "",
    ["sapVoteUser"] = nil
}

if (SERVER) then
    util.AddNetworkString("sapVoteStart")
    util.AddNetworkString("sapVoteYes")
    util.AddNetworkString("sapVoteNo")
    util.AddNetworkString("sapGetVoteEnd")
end

--  vote kick
function sapVoteKickStart(username)
    if (SERVER && username != nil && username != "" && !sapVoteActive) then
        net.Start("sapVoteStart")
        print("vote starting for user: "..username)
        net.WriteString(username)
        net.Broadcast()
        sapGetVoteStart(username)

        timer.Simple(10, function() --vote end, simple lazy code lol
            print("ending vote")
            net.Start("sapGetVoteEnd")
            net.Broadcast()
            sapGetVoteEnd()
        end)
    end
end

net.Receive("sapVoteStart",sapGetVoteStart)
net.Receive("sapVoteYes",sapVoteYes)
net.Receive("sapVoteNo",sapVoteNo)
net.Receive("sapGetVoteEnd",sapGetVoteEnd)

concommand.Add("sapvote_yes", function()
    sapVoteYes() --on server
    net.Start("sapVoteYes")
    net.Broadcast()
end)
concommand.Add("sapvote_no", function()
    sapVoteNo() --on server
    net.Start("sapVoteNo")
    net.Broadcast()
end)

--both client and server
function sapGetVoteStart()
    local strLen = net.ReadUInt(32) -- Read the length of the string (32 bits)
    local str = net.ReadString(strLen) -- Read the string data itself
    --print("test")
    sapGetVoteStart(str)
    -- if (CLIENT) then
    --     --print("test")
    --     local strLen = net.ReadUInt(32) -- Read the length of the string (32 bits)
    --     local str = net.ReadString(strLen) -- Read the string data itself
    --     chat.AddText( color_white, str)
    --     --print("test")
    --     sapGetVoteStart(str)
    -- else
    --     local strLen = net.ReadUInt(32) -- Read the length of the string (32 bits)
    --     local str = net.ReadString(strLen) -- Read the string data itself
    --     chat.AddText( color_white, str)
    --     --print("TEST")
    --     sapGetVoteStart(str)
    -- end
end

function sapGetVoteStart(username)
    if (!sapVoteActive) then
        local str = username
        if (CLIENT) then
            str = net.ReadString()
        end
        print("sap vote started on user: "..str)
        sapVoteInfo.sapVoteUser = str
        sapVoteInfo.sapVoteYes = 1
        sapVoteInfo.sapVoteNo = 0
        sapVoteInfo.sapVoteWinner = ""
        sapVoteInfo.sapVoteReason = "no reason given"
        sapVoteSlideOutTime = 0.3
        sapVoteActive = true
        sapVoteFinal = false
    end
end
function sapVoteYes()
    if (sapVoteActive && !sapVoteFinal) then
        print("someone voted yes")
        sapVoteInfo.sapVoteYes = sapVoteInfo.sapVoteYes + 1
    end
end
function sapVoteNo()
    if (sapVoteActive && !sapVoteFinal) then
        print("someone voted no")
        sapVoteInfo.sapVoteNo = sapVoteInfo.sapVoteNo + 1
    end
end
function sapGetVoteEnd()
    if (sapVoteActive) then
        if (sapVoteInfo.sapVoteYes > sapVoteInfo.sapVoteNo) then
            sapVoteInfo.sapVoteWinner = "yes"
            print("winner was yes")
            if (SERVER && sapVoteInfo.sapVoteUser != "" && sapVoteInfo.sapVoteUser != nil) then
                if (_SAPBOTSNAMES[sapVoteInfo.sapVoteUser] != nil && IsValid(_SAPBOTSNAMES[sapVoteInfo.sapVoteUser])) then
                    SapObliterate(_SAPBOTSNAMES[sapVoteInfo.sapVoteUser])
                end
            end
        else
            print("winner was no")
            sapVoteInfo.sapVoteWinner = "no"
        end
        sapVoteInfo.sapVoteYes = 0
        sapVoteInfo.sapVoteNo = 0
        sapVoteInfo.sapVoteReason = "no reason given"
        sapVoteActive = false
        sapVoteFinal = true
    end
end

function SapObliterate(ent) --used to kick saps from reality smh, like completely destroy, throw into the nether, cease to exist, absolute death, certain doom.
    print(ent)
    if SERVER then
        local effect = EffectData()
        effect:SetOrigin(ent:GetPos())
        util.Effect("explosion", effect)
        util.BlastDamage(ent, ent, ent:GetPos(), 100, 99999999999999999999999999999)
    end
end

-- Register the function to be accessible from the server console
concommand.Add("sap_obliterate", SapObliterate)

--vote ui
local color_offwhite = Color(245,241,238,180)
hook.Add( "HUDPaint", "SapbotVotekickHUD", function()
    if (SapVoteTextures["votekick0"] == nil) then
        sapGenVoteTex("votekick0")
        sapGenVoteTex("votekick1")
        sapGenVoteTex("votekick2")
        sapGenVoteTex("votekickpass0")
        sapGenVoteTex("votekickpass1")
    end
    if (sapVoteActive || (sapVoteInfo.sapVoteWinner != "" && sapVoteInfo.sapVoteWinner != nil)) then
        if (sapVoteSlideOutTime == 0.3) then
            surface.PlaySound("custom/sap/sap_vote_start.wav")
            sapVoteInfoChange.sapVoteYes = sapVoteInfo.sapVoteYes
            sapVoteInfoChange.sapVoteNo = sapVoteInfo.sapVoteNo
            sapVoteInfoChange.sapVoteWinner = ""
            sapVoteInfoChange.sapVoteUser = sapVoteInfo.sapVoteUser
            sapVoteInfoChange.sapVoteReason = sapVoteInfo.sapVoteReason
            sapVoteSlideOutTime = sapVoteSlideOutTime - 0.0001
        end
        if (sapVoteInfoChange.sapVoteYes != sapVoteInfo.sapVoteYes) then
            sapVoteInfoChange.sapVoteYes = sapVoteInfo.sapVoteYes
            surface.PlaySound("custom/sap/sap_vote_yes.wav")
        end
        if (sapVoteInfoChange.sapVoteNo != sapVoteInfo.sapVoteNo) then
            sapVoteInfoChange.sapVoteNo = sapVoteInfo.sapVoteNo
            surface.PlaySound("custom/sap/sap_vote_no.wav")
        end
        local offsetSlide = (math.sin(sapVoteSlideOutTime * 5) * 300)
        if (sapVoteInfo.sapVoteWinner == "" || sapVoteInfo.sapVoteWinner == nil) then
            surface.SetMaterial(SapVoteTextures["votekick0"])
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.DrawTexturedRect(1530 + offsetSlide,150,350,300)
            draw.SimpleText(sapVoteInfo.sapVoteUser or "Undefined", "CreditsText", 1660 + offsetSlide, 203, color_offwhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(sapVoteInfo.sapVoteYes, "Trebuchet24", 1597 + offsetSlide, 402, color_offwhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(sapVoteInfo.sapVoteNo, "Trebuchet24", 1704 + offsetSlide, 402, color_offwhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            surface.SetDrawColor( 255, 255, 255, 255 )
            if (sapVoteInfo.sapVoteWinner == "yes") then
                surface.SetMaterial(SapVoteTextures["votekickpass1"])
                surface.DrawTexturedRect(1530 + offsetSlide,150,350,300)
                draw.SimpleText(sapVoteInfo.sapVoteUser or "Undefined", "CreditsText", 1667 + offsetSlide, 301, color_offwhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                if (sapVoteFinal) then
                    sapVoteFinal = false
                    sapVoteClientVanishTime = CurTime() + 4
                    surface.PlaySound("custom/sap/sap_vote_done_yes.wav")
                end
                if (sapVoteClientVanishTime < CurTime()) then
                    sapVoteInfo.sapVoteWinner = ""
                end
            else
                surface.SetMaterial(SapVoteTextures["votekickpass0"])
                surface.DrawTexturedRect(1530 + offsetSlide,150,350,300)
                draw.SimpleText("Not enough to kick player: "..sapVoteInfo.sapVoteUser or "Undefined", "CreditsText", 1547 + offsetSlide, 301, color_offwhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                if (sapVoteFinal) then
                    sapVoteFinal = false
                    sapVoteClientVanishTime = CurTime() + 4
                    surface.PlaySound("custom/sap/sap_vote_done_no.wav")
                end
                if (sapVoteClientVanishTime < CurTime()) then
                    sapVoteInfo.sapVoteWinner = ""
                end
            end
        end

        if (sapVoteSlideOutTime > 0.00001) then
            sapVoteSlideOutTime = sapVoteSlideOutTime * (1 - (9 * FrameTime()))
        end
    elseif (sapVoteSlideOutTime != 0.3) then
        sapVoteSlideOutTime = 0.3
    end
	--surface.DrawRect( 50, 300, 128, 128 )
end )