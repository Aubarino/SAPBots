AddCSLuaFile()
include("sapbot/SapUtil.lua")
AddCSLuaFile("sapbot/SapUtil.lua")

if CLIENT then
language.Add("tool.sapbotspawnercreator", "S.A.P Bot Spawner Creator")

language.Add("tool.sapbotspawnercreator.name", "S.A.P Bot Spawner Creator")
language.Add("tool.sapbotspawnercreator.desc", "Creates a Spawn Point for S.A.P Bot(s) with your specifications")
language.Add("tool.sapbotspawnercreator.0", "Create a Spawn Point for S.A.P Bot(s) with your specifications")
end

_saptoolgunconvarloaded = false

TOOL.Category = "S.A.P Bots | Adaptive Friends"
TOOL.Name = "#tool.sapbotspawnercreator"
TOOL.ClientConVar = {
    ["sapspawnwithrandom"] = "0",
    ["sapspawnertable"] = "",
    ["sapspawnneweachtime"] = "1"
}
local sapspawnertableConvar = CreateClientConVar("sapbotspawnercreator_sapspawnertable", "")
local sapspawnwithrandomConvar = CreateClientConVar("sapbotspawnercreator_sapspawnwithrandom", "0")
local sapspawnneweachtimeConvar = CreateClientConVar("sapbotspawnercreator_sapspawnneweachtime", "1")

local spawnerTable = nil
local spawnerFullTable = nil
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
    for i=1,24,1 do
        outputValL = (math.sin(CurTime() * 2) + 2) * i
        surface.SetDrawColor( Color( outputValL * math.Round(sapColor.r * 0.004921568627451), outputValL * math.Round(sapColor.g * 0.003921568627451), outputValL * math.Round(sapColor.b * 0.004921568627451) ) )
        surface.DrawRect( 4 * i, 4 * i, width - (8 * i), height - (8 * i) )
    end

    local CoolTx = CoolSapTextArt() --moved to util
	draw.SimpleText(CoolTx.." S.A.P Spawnpoint "..CoolTx, "DermaLarge", width / 2, 32, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    spawnerTable = self:GetClientInfo("sapspawnertable")
    local spawnwithrandom = tobool(self:GetClientNumber("sapspawnwithrandom", 0))
    local sapspawnneweachtime = tobool(self:GetClientNumber("sapspawnneweachtime", 0))
    if (spawnwithrandom) then
        draw.SimpleText("Values random", "DermaLarge", width / 2, 72, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText("Values static", "DermaLarge", width / 2, 72, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    if (spawnerTable != nil && spawnerTable != "") then
        spawnerFullTable = util.JSONToTable(spawnerTable)
        if (spawnerFullTable != nil) then
            draw.SimpleText("[S.A.P Data Linked]", "DermaLarge", width / 2, 130, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            if (spawnerFullTable.Sap_NameRandom && spawnwithrandom) then
                draw.SimpleText("Name Random", "DermaLarge", width / 2, 160, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("Name: "..spawnerFullTable.Sap_Name, "DermaLarge", width / 2, 160, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("Multiple of the same","Trebuchet24", width / 2, 181, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("name can cause errors","Trebuchet24", width / 2, 194, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
    if (sapspawnneweachtime) then
        draw.SimpleText("New ID each time", "DermaLarge", width / 2, 215, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText("Static ID", "DermaLarge", width / 2, 215, sapColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function TOOL:LeftClick(tr)
    if (tr.Hit) then
        if (tr.HitNormal != nil && tr.HitNormal.z >= 0.5) then
            local tableOut = util.JSONToTable(sapspawnertableConvar:GetString("sapspawnertable"))
                if (tableOut != nil) then
                local User = self:GetOwner()
                User:EmitSound( string.Trim("custom/sap/sapspawnerspawn.wav","%s"), 100, 100, 1, CHAN_ITEM )
                local sapbotspawner = ents.Create("sap_spawner")
                sapbotspawner:SetPos(tr.HitPos)
                sapbotspawner.SapDataTable = tableOut
                if (sapspawnneweachtimeConvar:GetBool()) then
                    sapbotspawner.SapDataTable.Sap_id = math.Round(math.Rand(0, 9999999))
                end
                sapbotspawner.ignoreCertainValues = !sapspawnwithrandomConvar:GetBool()
                sapbotspawner.NormalAngle = tr.HitNormal
                sapbotspawner:Spawn()

                undo.Create( 'S.A.P Bot Spawner' )
                undo.AddEntity(sapbotspawner)
                undo.SetPlayer(User)
                undo.SetCustomUndoText( 'Undone S.A.P Bot Spawner ('..tableOut.Sap_Name..')' )
                undo.Finish('Created S.A.P Bot Spawner ('..tableOut.Sap_Name..')')
            end
        end
    end
end

function TOOL:RightClick(tr)
    if (tr.Hit) then
        if (IsValid(tr.Entity)) then
            if (tr.Entity:GetClass() == "sap_bot") then
                local sap = tr.Entity
                sapspawnertableConvar:SetString(util.TableToJSON(SapBotToData(sap)))
                local User = self:GetOwner()
                User:EmitSound( string.Trim("custom/sap/saplink.wav","%s"), 100, 100, 1, CHAN_ITEM )
            end
        end
    end
end

function TOOL:Reload(tr)
    local User = self:GetOwner()
    User:EmitSound( string.Trim("custom/sap/sapmodechange.wav","%s"), 100, 100, 1, CHAN_ITEM )
    sapspawnwithrandomConvar:SetBool(not sapspawnwithrandomConvar:GetBool())
end

function TOOL:Think()
    local User = self:GetOwner()
    if (IsValid(User)) then
        if (User:Alive()) then
            local tr = User:GetEyeTrace()
            if (tr.Hit) then
                User:SetNW2Vector("sapbotspawnercreator_pos",tr.HitPos)
                User:SetNW2Vector("sapbotspawnercreator_nor",tr.HitNormal)
                User:SetNW2Float("sapbotspawnercreator_time",CurTime())
            else
                User:SetNW2Vector("sapbotspawnercreator_pos",User:GetPos())
                User:SetNW2Vector("sapbotspawnercreator_nor",Vector(0,0,0))
            end
        end
    end
    if ( CLIENT ) then
        hook.Add('PreDrawEffects','sapbotspawnercreator_hoverrender'..User:EntIndex(),function()
            if !IsValid(User) then hook.Remove('PreDrawEffects','sapbotspawnercreator_hoverrender'..User:EntIndex()) return end
            if !User:Alive() then hook.Remove('PreDrawEffects','sapbotspawnercreator_hoverrender'..User:EntIndex()) return end

            render.SetMaterial(Material("custom/sap/sapspawner"))
    
            local pos = User:GetNW2Vector("sapbotspawnercreator_pos",Vector(0,0,0))
            local tim = User:GetNW2Float("sapbotspawnercreator_time",0)
            local normal = User:GetNW2Vector("sapbotspawnercreator_nor",Vector(0,0,0))
            local col = nil
            if (spawnerFullTable != nil) then
                col = spawnerFullTable.TeamColor
            end
            if (col == nil) then --lazy fallback
                col = SAPBOTCOLOR
            end

            local scaling = 64
    
            if (normal != nil && normal != Vector(0,0,0) && tim >= CurTime() - 0.1) then
                if (normal.z >= 0.5) then
                    render.DrawQuadEasy(pos + (normal * (math.sin(CurTime() * 4) + 1) * 4), normal, scaling, scaling,col, 180)

                    local colorchanges = nil
                    local amt = 50
                    local total = 5
                    local smallering = 0
                    local funnyValue = (math.sin(CurTime() * 0.5) + 2) * 0.5
                    for i = 0,5,1 do 
                        smallering = (i / total)
                        colorchanges = Color(math.Clamp(col.r + (i * amt),0,255),col.g + (i * amt),col.b + (i * amt),(1 - smallering) * 255)
                        scaling = ((1 - smallering) + 0.5) * 30
                        render.DrawQuadEasy(pos + (normal * (math.sin((CurTime() + (i * funnyValue)) * 4) + 1) * 4) + (normal * 40 * smallering), normal, scaling, scaling, colorchanges, 180)
                    end
                end
            end
        end)
    end
end

function TOOL.BuildCPanel(panel)
	panel:Help('Creates S.A.P Bot spawn points, for specific or multiple')
    panel:Help('with values that can variate, or remain static,')
    panel:Help('maintaining opinion and personality data on respawn.')
	panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    panel:CheckBox('Randomize already static data','sapbotspawnercreator_sapspawnwithrandom')
    panel:ControlHelp("data such as the name, if randomized in the original's creation, will randomize here when respawning")
    panel:CheckBox('New ID each time','sapbotspawnercreator_sapspawnneweachtime')
    panel:ControlHelp("each S.A.P Bot spawner you make will have a unique S.A.P Bot ID, instead of using the same S.A.P Bot ID as the data's origin, meaning that they will spawn independently of each other")
    panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    panel:Help('Right Click a S.A.P Bot to link')
    panel:Help('Left Click to create a S.A.P Bot Spawner')
    panel:Help('Reload Key to toggle between random')

    panel:Help("")
    local joindistext = panel:Help(" \n ")
    local joindistexttex = vgui.Create( "RichText", joindistext )
    joindistexttex:Dock( FILL )
    joindistexttex:DockMargin(0, 0, 0, 0)
    joindistexttex:DockPadding(100, 100, 100, 100)
    joindistexttex:InsertColorChange(0, 150, 0, 255)
    joindistexttex:AppendText("Join the Discord Server for how to MAKE YOUR OWN TTS Voices, Soundboards and more!")
    local DiscordButton = vgui.Create( "DButton", panel )
    panel:AddItem(DiscordButton)
    DiscordButton:SetText( "Join The Discord!" )
    --DiscordButton:SetPos( 65, 1040 )
    DiscordButton:SetSize( 103, 27 )
    DiscordButton.DoClick = function()
        gui.OpenURL("https://discord.gg/8UMuEdDYEs")
    end
    panel:Help("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
end