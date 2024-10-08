AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Spawnable = true
ENT.Author = "Aubarino"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PrintName = "S.A.P Bot Spawner"
ENT.SapDataTable = nil --the table containing the sap bot data
ENT.ignoreCertainValues = false
ENT.NormalAngle = Vector(0,0,0)

if CLIENT then
    language.Add("sap_spawner", "S.A.P Bot Spawner")
end

-- list.Set( "Entity", "S.A.P Bot Spawner", {
-- 	Name = "S.A.P Bot Spawner",
-- 	Class = "sap_spawner",
-- 	Category = "other"
-- })

function ENT:Initialize()
    self:AddFlags(FL_OBJECT)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
    self:DrawShadow(false)
    if (SERVER) then
        self:SetNW2Vector("NormalAngle",self.NormalAngle)
        if (self.SapDataTable != nil) then
            if (self.SapDataTable.TeamColor != nil) then
                self:SetNW2Vector("TeamColor", Vector(self.SapDataTable.TeamColor.r,self.SapDataTable.TeamColor.g,self.SapDataTable.TeamColor.b))
            end
        end
    end
end

local sap = nil
function ENT:Think()
    if (SERVER) then
        if (self.SapDataTable != nil) then
            if (_SAPBOTSSAPIDS[self.SapDataTable.Sap_id] == nil || !IsValid(_SAPBOTSSAPIDS[self.SapDataTable.Sap_id])) then
                sap = ents.Create("sap_bot")
                sap:SetPos(self:GetPos())
                sap.Sap_Name = self.SapDataTable.Sap_Name
                sap.Sap_id = self.SapDataTable.Sap_id
                DataToSapBot(self.SapDataTable,sap,self.ignoreCertainValues)
                sap:Spawn()
                _SAPBOTSSAPIDS[self.SapDataTable.Sap_id] = sap
                DataToSapBot(self.SapDataTable,sap,self.ignoreCertainValues)
                sap:SetMaxHealth(self.SapDataTable.MaxHealth)
                sap:SetHealth(self.SapDataTable.MaxHealth)
            else
                sap = _SAPBOTSSAPIDS[self.SapDataTable.Sap_id]
                if (sap != nil && IsValid(sap) && (sap.Dead == false)) then --constantly backup the sap bot
                    self.SapDataTable = SapBotToData(sap)
                end
            end
        end
    end

    self:NextThink(CurTime() + 3)
	return(true)
end

function ENT:DrawTranslucent()
    render.SetMaterial(Material("custom/sap/sapspawner"))
    local normal = self:GetNW2Vector("NormalAngle")
    local col = self:GetNW2Vector("TeamColor", nil)
    local scaling = 32
    if (col == nil) then
        col = SAPBOTCOLOR
    end
    render.DrawQuadEasy(self:GetPos() + (normal * 2), normal, scaling, scaling,Color(col.r * 0.3,col.g * 0.3,col.b * 0.3), 180)
end

function ENT:OnRemove()
    if (SERVER) then
        if (self.SapDataTable != nil) then
            if (_SAPBOTSSAPIDS[self.SapDataTable.Sap_id] != nil && IsValid(_SAPBOTSSAPIDS[self.SapDataTable.Sap_id])) then
                if (math.random(0,8) == 0) then
                    SapObliterate(_SAPBOTSSAPIDS[self.SapDataTable.Sap_id])
                else
                    _SAPBOTSSAPIDS[self.SapDataTable.Sap_id]:Kill()
                end
            end
        end
    end
end