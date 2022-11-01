AddCSLuaFile()
include("sapbot/SapUtil.lua")
AddCSLuaFile("sapbot/SapUtil.lua")

SAPBOTDEBUG = false --debug mode
_Sapbot_WeaponBlacklist = {} --weapons to not spawn with or use

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.VJ_AddEntityToSNPCAttackList = true

if CLIENT then
    language.Add('sap_bot', "S.A.P Bot")
end

ENT.Sap_id = 0
ENT.Sap_Intelligence = "" --1 to 100
ENT.Sap_Chaos = "" -- 1 to 10
ENT.Sap_DefaultTrustFactor = 2

--0 to 1 and inbetween
--ones with 1 minus means ya gotta do 1 - it to get the real outcome

--sap information processing filter information
ENT.Sap_IPF_chill = ""
ENT.Sap_IPF_strict = ""
ENT.Sap_IPF_calm = "" --1 minus
ENT.Sap_IPF_paranoid = "" --1 minus

--situation management - personality
ENT.Sap_SM_innocence = ""
ENT.Sap_SM_corruption = ""
ENT.Sap_SM_openminded = ""
ENT.Sap_SM_closeminded = ""

ENT.Sap_WanderRange = 256

--random information
ENT.Sap_Name = ""
ENT.Sap_Model = ""

ENT.SpawnDone = true --done spawn
ENT.SapSpawnOverride = false --if true then don't do the cool spawn animation thing
ENT.ColorOverride = nil
ENT.MatOverride = nil
ENT.Jumping = true --do later
ENT.Stepsounds = true --do later
ENT.VertVel = 0 --carryover for later
ENT.Walking = false --is walking / moving or not
ENT.ThinkingProc = false --is having thinking process
ENT.Stress = 0 --active stress that changes over time
ENT.EmotionExpression = "load" --emotion display
ENT.EmotionEnabled = false --override emotion expression with code-managed output automatically bla bla

ENT.Living = true 
ENT.Dead = false --same as living but inverse, used cause source is weird and this is a workaround
ENT.Spawning = true --used cause source is weird and this is a workaround
ENT.ChatSent = ""
ENT.SAPCached = false

ENT.NPCMenuSpawned = true --defaults to true, false once toolgun application, is true for first tick

--tts and dialog
ENT.TTSspeaking = false
ENT.TTStruespeak = false
ENT.TTStimefornext = 0
ENT.TTScurrent_phoneme = ""
ENT.TTScurrent_num = 0
ENT.TTSscripttable = {}
ENT.TTSname = "" --heavy_tf2
ENT.SapSoundboard = ""
ENT.SapSoundboardOn = false
ENT.SapSoundboardMode = 0
ENT.SapSoundboardRate = 0
ENT.SapSoundboardCurrent = false
ENT.SapSoundboardMusic = false
ENT.DialogSet = "main"
ENT.TTSenabled = false
ENT.TTStextform = ""
ENT.SapCacheSay = ""
ENT.SapCacheSayTime = 0

--combat
ENT.IsAttacking = false -- is attacking or not
ENT.AttackMode = 0 --0 is normal shooting in general direction, 1 is hunting and actively following, 2 is strafe, 3 is retreating 
ENT.EquipWeapons = false
ENT.AdminWeapons = false
ENT.CurrentWeapon = nil

--"fun"
ENT.Fun_AggressionMode = false

local switch = function(condition, results)
    local exists = results[condition] or results["default"]
    if type(exists) == "function" then
        return exists()
    end
    return exists
end

ENT.OpinionOnEnts = {}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Player Type Function Emulation, for things like Weapons to avoid conflictions
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function ENT:GetShootPos() --the general direction ya shooting in in worldspace via a position... ikr, weird
    return(self:GetPos() + self:GetHeadHeightVector() + self:GetForward())
end

function ENT:ViewPunch() --used commonly by guns 'n such for recoil lol
end

function ENT:SetEyeAngles() --eh
end

function ENT:GetActiveWeapon() --eh..
    return(self.CurrentWeapon)
end

function ENT:GetAimVector() --aiming direction seemingly
    return(self:GetForward())
end

function ENT:AccountID()
    return("[U:1:165067711]")
end

function ENT:DrawWorldModel() --eh....
end

function ENT:SetViewEntity() --eh......
end

function ENT:SteamID64() --nice
    return(69)
end

ENT.dt = "" --idfk

function ENT:GetViewModel() --eh....
    return(self)
end

function ENT:Alive()
    return(true)
end

function ENT:GetViewEntity() --eh....
    return(self)
end

function ENT:SetNoTarget() --eh...
end

function ENT:ViewPunchReset() --eh...
end

function ENT:GetAmmoCount() --eh...
    return (69)
end

function ENT:GetViewPunchAngles()
    return(Angle(0,0,0))
end

function ENT:GetEyeTrace()
    local tracedata = {}
    tracedata["start"] = self:GetHeadHeightVector() + self:GetPos()
    tracedata["endpos"] = tracedata["start"] + (self:GetForward() * 1024)
    tracedata["filter"] = self
    return(util.TraceLine(tracedata))
end

function ENT:GetEyeTraceNoCursor()
    return(self:GetEyeTrace())
end

function ENT:GetViewOffset()
    return(self:GetHeadHeightVector())
end

function ENT:RemoveAmmo()
end

function ENT:IsNPC()
    return(false)
end

function ENT:IsPlayer()
    return(true)
end

function ENT:GetName()
    return(self.Sap_Name)
end
function ENT:Name()
    return(self.Sap_Name)
end

function ENT:DoAttackEvent()
end
function ENT:DoSecondaryAttack()
end
function ENT:DoReloadEvent()
end

function ENT:UniqueID()
    return(math.Rand(0,999))
end

function ENT:GetInfoNum(cVarName,default)
    return(0)
end

function ENT:ConCommand()
end

function ENT:SetRunSpeed(speed)
    self:SetWalkSpeed(speed)
end
function ENT:SetWalkSpeed(speed)
    self.loco:SetDesiredSpeed(speed)
end

function ENT:SendHint(name,delay)
end
function ENT:SendLua(script) --would execute lua on a player normally, used seemingly be many weapon mods
end
function ENT:Send()
end

function ENT:AddDeaths(count)
end
function ENT:AddFrozenPhysicsObject(ent, physobj)
end
function ENT:AddPlayerOption(name,timeout,vote_callback,draw_callback)
end

function ENT:AllowFlashlight(canFlashlight)
end

function ENT:Armor()
    return(100)
end

function ENT:Ban(minutes,kick)
end

function ENT:Crouching()
    return(false)
end

function ENT:GetInfo(cVarName)
    return("")
end

function ENT:KeyDown(key)
    return(true)
end

function ENT:KeyPressed(key)
    return(true)
end

function ENT:ChatPrint(message)
end

function ENT:Say(text,teamOnly)
end

function ENT:PrintMessage(type,message)
end

function ENT:AddVCDSequenceToGestureSlot()
end

function ENT:WorldModelOffsets()
    return(Vector(0,0,0))
end

function ENT:StripWeapon()
    self:DeEquipWeapon()
end

function ENT:GetEnemy()
    return(self.BadNearEnt)
end

function ENT:SetActiveWeapon(weapon)
    if (weapon != NULL and weapon != nil) then
        self:SelectWeapon(weapon.ClassName)
    else
        self:StripWeapon()
    end
end

function ENT:SelectWeapon(className)
    self.EquipWeapons = true
    if (self.CurrentWeapon != nil) then
    self:DeEquipWeapon()
    end
    local handpoint = self:LookupAttachment('anim_attachment_RH')
    local handattach = self:LookupAttachment("hand")
    self.CurrentWeapon = ents.Create(className)
    self.CurrentWeapon:SetOwner(self)
    self.CurrentWeapon:DeleteOnRemove(self.CurrentWeapon)
    self.CurrentWeapon:AddEffects(EF_BONEMERGE)
    self.CurrentWeapon:SetMoveType(MOVETYPE_NONE)

    local matrix = self:GetBoneMatrix(handattach)
    local pos = matrix:GetTranslation()
    local ang = matrix:GetAngles()
    self.CurrentWeapon:SetPos(pos)
    self.CurrentWeapon:SetAngles(ang)
    self.CurrentWeapon:SetParent(self, handpoint)

    self.CurrentWeapon:SetModel("models/food/burger.mdl") --BURGER

    if (self.CurrentWeapon.HoldType != nil) then --determine and set HoldType of the current weapon
        self.CurWeaponHT = self.CurrentWeapon.HoldType
    else
        self.CurWeaponHT = WMtoHoldType(self.CurrentWeapon.WorldModel)
    end
end

function ENT:TimeConnected()
    return(0)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function ENT:GetHeadHeightVector()
    local posModelOffsetMin, posModelOffsetMax = self:GetModelBounds()
    return(Vector(0,0,posModelOffsetMax.z - 16))
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--true first boot 'n initialization
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function ENT:Initialize()
    self.TTStimefornext = CurTime() + 0.1
    self.Spawning = true
    self.UpdatePhys = CurTime() + 0.1
    --cool spawn effect
    if (GetConVar("sapbot_debugmode") == nil) then --DEBUG MODE TOGGLE CODE
        SAPBOTDEBUG = false
    else
        SAPBOTDEBUG = GetConVar("sapbot_debugmode"):GetBool()
    end

    if (SERVER) then
        self:SetNW2String("Sap_Name", self.Sap_Name)
        if (!_SapbotDG_DialogSetMainLoaded) then --load main dialog set if it isn't loaded
            GatherAllTTS()
            BuildDialogTreeSet("main",_SapbotDG_ToxicToEntity,_SapbotDG_LoveEntity,_SapbotDG_LikeEntity,_SapbotDG_DislikeEntity,_SapbotDG_HateEntity,_SapbotDG_ConversationNormal,_SapbotDG_IdleNormal)
            _SapbotDG_DialogSetMainLoaded = true
        end
    end
    if (CLIENT) then
        if (!self.SapSpawnOverride) then
            local toprint = ""
            if (self:GetNW2String("Sap_Name") == "") then
                toprint = "S.A.P Bot"
                if (table.Count(_SAPBOTS) < 3) then --first sap bot message warning thing
                    chat:AddText(Color(0,0,0,255), "-={[ ", Color(0,255,0,255), "S.A.P Bots are best spawned via the ", Color(255,255,255,255),"S.A.P Bot Creator tool", Color(0,0,0,255), " ]}=-")
                end
            else
                toprint = "S.A.P Bot ("..self:GetNW2String("Sap_Name")..")"
            end
            chat:AddText(Color(150,255,150,255),toprint.." has joined the game")
        end
    end
    self:SetMaterial("models/weapons/v_slam/new light2")
    self:SetColor(Color(0, 255, 0, 255))
    self:SetModel("models/player/skeleton.mdl")

    self.Sap_id = math.Round(math.Rand( 0, 9999999 ))
    self.Living = true
    self.Dead = false
    self.ThinkingProc = false
    self:SetNW2Bool("sap_thinkcarover", false)
    self:SetNW2String("sap_emotexpress", "load")

    self:AddFlags(FL_OBJECT+FL_NPC+FL_FAKECLIENT)
    if (!self.SapSpawnOverride) then
        self:SetCollisionBounds(Vector(-10,-10,0),Vector(10,10,72))
    end
    self:PhysicsInitShadow()

    self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)

    self:AddCallback('PhysicsCollide',function(self,data)
        self:HandleCollision(data)
    end)

    self:InitRelaHooks() -- relationship shit mostly
end

function ENT:BodyUpdate()
    self:BodyMoveXY(0,0) --it just works :)
end

function ENT:GetPlayerRelation(npc)
    if !isfunction(npc.Disposition) then return end
    local players = player.GetAll()
    local ply = players[math.random(1,#players)]
    if !IsValid(ply) then return D_HT end
    local disp = npc:Disposition(ply)
    return disp
end

function ENT:InitRelaHooks() --relations
    local entIndex = self:EntIndex()
    
    local function ExecuteVJBaseTweaks(npc)
        local npcID = npc:EntIndex()
        if npc.IsVJBaseSNPC_Human == true and npc.HasMeleeAttack == true then
            hook.Add('Think', npcID..'_DontMeleeAttackSap', function()
                if !IsValid(npc) then hook.Remove('Think', npcID..'_DontMeleeAttackSap') return end
                if CurTime() > npc.NextProcessT then 
                    if IsValid(npc:GetEnemy()) and npc:GetEnemy():GetClass() == 'sap_bot' then
                        npc.HasMeleeAttack = false
                    else
                        npc.HasMeleeAttack = true
                    end
                end
            end)
        end
        
        if npc.BecomeEnemyToPlayer == true then
            hook.Add('EntityTakeDamage', npcID..'_TurnAgainstAgroSap', function(ent, dmginfo)
                if !IsValid(npc) then hook.Remove('EntityTakeDamage', npcID..'_TurnAgainstAgroSap') return end
                if npc != ent or npc.VJ_IsBeingControlled or !(dmginfo:GetAttacker().Sap_id != nil and dmginfo:GetAttacker().Sap_id != NULL) then return end
                
                local attacker = dmginfo:GetAttacker()
                local disp = attacker:GetVJSNPCRelationship(npc)
                
                if disp != D_LI then return end
        
                npc.AngerLevelTowardsPlayer = npc.AngerLevelTowardsPlayer + 1
                if npc.AngerLevelTowardsPlayer > npc.BecomeEnemyToPlayerLevel then
                    if disp != D_HT then
                        npc:CustomWhenBecomingEnemyTowardsPlayer(dmginfo, 0)
                        npc.VJ_AddCertainEntityAsEnemy[#npc.VJ_AddCertainEntityAsEnemy+1] = attacker
                        npc.CurrentPossibleEnemies[#npc.CurrentPossibleEnemies+1] = attacker
                        npc:AddEntityRelationship(attacker,D_HT,99)
                        npc.TakingCoverT = CurTime() + 2
                        if !IsValid(npc:GetEnemy()) then
                            npc:StopMoving()
                            npc:SetTarget(attacker)
                            npc:VJ_TASK_FACE_X("TASK_FACE_TARGET")
                        end
                        npc:PlaySoundSystem("BecomeEnemyToPlayer")
                    end
                    npc.Alerted = true
                end
            end)
        end
    end

    hook.Add('OnEntityCreated', 'saprelationshipdat'..entIndex, function(ent) --carry over from zeta players mod, editted to work, rework later X_X
        if !IsValid(self) then hook.Remove('OnEntityCreated', 'saprelationshipdat'..entIndex) return end
        if !IsValid(ent) or !ent:IsNPC() then return end

        local disp = self:GetPlayerRelation(ent)
        if disp == D_HT and isfunction(ent.AddEntityRelationship) then
            ent:AddEntityRelationship(self,D_HT)
        end
        --vj stuff
        if ent.IsVJBaseSNPC then
            timer.Simple(ent.NextProcessTime, function()
                if !IsValid(self) or !IsValid(ent) then return end
                if self:GetVJSNPCRelationship(ent) == D_HT then
                    if ent.VJ_AddCertainEntityAsEnemy then
                      table.insert(ent.VJ_AddCertainEntityAsEnemy, self)
                    end
                    if ent.CurrentPossibleEnemies then
                      table.insert(ent.CurrentPossibleEnemies, self)
                    end
                    ent:AddEntityRelationship(self,D_HT)
                end
  
                ent.HookedBySap = ent.HookedBySap or false
                if !ent.HookedBySap then --damn var out of nowhere, cool
                    ent.HookedBySap = true
                    ExecuteVJBaseTweaks(ent)
                end
            end)
        end
    end)
  
    for _, npc in ipairs(ents.FindByClass('npc_*')) do
        local disp = self:GetPlayerRelation(npc)
        if disp == D_HT and isfunction(npc.AddEntityRelationship) then
            npc:AddEntityRelationship(self,D_HT)
        end
  
        if npc.IsVJBaseSNPC then 
            if self:GetVJSNPCRelationship(npc) == D_HT then
                table.ForceInsert(npc.VJ_AddCertainEntityAsEnemy, self)
                table.ForceInsert(npc.CurrentPossibleEnemies, self)
                npc:AddEntityRelationship(self,D_HT)
            end
  
            npc.HookedBySap = npc.HookedBySap or false
            if !npc.HookedBySap  then
                npc.HookedBySap = true
                ExecuteVJBaseTweaks(npc)
            end
        end
    end
end

function ENT:ConstructInitOpinion(inputentity)
    local buildopinion = {GetDefaultOpinion(inputentity,self.Sap_DefaultTrustFactor) - (((1 - self.Sap_IPF_paranoid) * math.Rand(1,4)) - 1), CurTime()}
    return(buildopinion)
end

-- -- -- -- -- -- -- -- -- -- --
--take damage and collision stuff
-- -- -- -- -- -- -- -- -- -- --
function ENT:OnTakeDamage( dmginfo )
	-- Make sure we're not already applying damage a second time
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		self:TakeDamageInfo( dmginfo )
        local AttackerName = GetBestName(dmginfo:GetAttacker())
        if (SAPBOTDEBUG and dmginfo:GetAttacker() == nil or dmginfo:GetAttacker() == NULL) then print("S.A.P Attacker Not Found") end
        if (self.OpinionOnEnts[AttackerName] == nil) then
            if (self.Fun_AggressionMode) then
                self.OpinionOnEnts[AttackerName] = {-99,CurTime()}
            else
                self.OpinionOnEnts[AttackerName] = self:ConstructInitOpinion(dmginfo:GetAttacker()) --build init opinion of entity with no opinion
            end
        else
            local tempthingy = self.OpinionOnEnts[AttackerName]
            if (self.Dead) then
                self.OpinionOnEnts[AttackerName] = (tempthingy)
            else
                self.OpinionOnEnts[AttackerName] = {(tempthingy[1] - (((1 - self.Sap_IPF_paranoid) + (self.Sap_IPF_strict)) * (dmginfo:GetDamage() / 20))),CurTime()}
            end
        end

        if (AttackerName != nil) then
            self:OpinionChangeRemark(self.OpinionOnEnts[AttackerName][1],AttackerName)
        end

        if (SAPBOTDEBUG) then print("S.A.P Bot Attacked by "..AttackerName..", "..AttackerName.." opinion at "..self.OpinionOnEnts[AttackerName][1]) end
		self.m_bApplyingDamage = false

        self.Stress = self.Stress + ((1 - self.Sap_IPF_paranoid) * 0.7 + (self.Sap_IPF_strict * 0.7)) -- stress gain
        -- note to self : really should make stress relative to damage gained instead of just whenever hurt

        if (self.Dead) then
            self.EmotionEnabled = false
            self.EmotionExpression = "dead"
            self:SetNW2String("sap_emotexpress", "dead")
            self:SetNW2Float("sap_emoexpTime", CurTime())
        end
	end
end

-- idfk, dissolve the sap bot i guess- once it has been shot with a combine ball thingy
function MakeDissolver( ent, position, attacker, dissolveType )

    local Dissolver = ents.Create( "env_entity_dissolver" )
    timer.Simple(5, function()
        if IsValid(Dissolver) then
            Dissolver:Remove() -- backup edict save on error
        end
    end)

    Dissolver.Target = "dissolve"..ent:EntIndex()
    Dissolver:SetKeyValue( "dissolvetype", dissolveType )
    Dissolver:SetKeyValue( "magnitude", 0 )
    Dissolver:SetPos( position )
    Dissolver:SetPhysicsAttacker( attacker )
    Dissolver:Spawn()

    ent:SetName( Dissolver.Target )

    Dissolver:Fire( "Dissolve", Dissolver.Target, 0 )
    Dissolver:Fire( "Kill", "", 0.1 )

    return Dissolver
end

-- -- -- -- -- -- -- -- -- --
--collision!
-- -- -- -- -- -- -- -- -- --
function ENT:HandleCollision(data)
    local collider = data.HitEntity
    if !IsValid(collider) then return end
    local class = collider:GetClass()

    if (class == "prop_combine_ball") then
        if self:IsFlagSet(FL_DISSOLVING) then return end
        local damage = DamageInfo()
        local owner = collider:GetPhysicsAttacker( 1 ) 
        MakeDissolver( self, self:GetPos(), owner, 0 )
        damage:SetAttacker(IsValid(owner) and owner or collider)
        damage:SetInflictor(collider)
        damage:SetDamage(1000)
        damage:SetDamageType(DMG_DISSOLVE)
        damage:SetDamageForce(collider:GetVelocity())
        self:TakeDamageInfo(damage)  
        collider:EmitSound("NPC_CombineBall.KillImpact")

    elseif isfunction(collider.CustomOnDoDamage_Direct) then
        local owner = collider:GetOwner()
        local dmgPos = (data != nil and data.HitPos) or collider:GetPos()
        collider:CustomOnDoDamage_Direct(data, phys, self)
        local damagecode = DamageInfo()
        damagecode:SetDamage(collider.DirectDamage)
        damagecode:SetDamageType(collider.DirectDamageType)
        damagecode:SetDamagePosition(dmgPos)
        damagecode:SetAttacker((IsValid(owner) and owner or collider))
        damagecode:SetInflictor((IsValid(owner) and owner or collider))
        self:TakeDamageInfo(damagecode, collider)

    elseif (collider != self.PhysgunnedENT) then
        local mass = data.HitObject:GetMass() or 500
        local impactdmg = (data.TheirOldVelocity:Length()*mass)/1000
        if impactdmg > 10 then
            local info = DamageInfo()
            info:SetAttacker(collider)
            if IsValid(collider:GetPhysicsAttacker()) then
                info:SetAttacker(collider:GetPhysicsAttacker())
            elseif collider:IsVehicle() and IsValid(collider:GetDriver()) then
                info:SetAttacker(collider:GetDriver())
                info:SetDamageType(DMG_VEHICLE)     
            end
            info:SetInflictor(collider)
            info:SetDamage(impactdmg)
            info:SetDamageType(DMG_CRUSH)
            info:SetDamageForce(data.TheirOldVelocity)
            self.loco:SetVelocity(self.loco:GetVelocity()+data.TheirOldVelocity)
            self:TakeDamageInfo(info)
        end
    end
end

--opinion code 'n such
function ENT:ScanEntities() --generally scans entity in a radius and does opinion stuff to be used later
    --local nearnextbot = NULL
    --local lastdist = math.huge
    -- entsnear = FindEntsInVision(self,
    --     512, function(ent)
    --     return (IsValid(ent) and !ent.IsZetaPlayer and ent:IsNextBot() and (isfunction(ent.AttackNearbyTargets) or ent.IsDrGNextbot))
    --     end
    -- )
    -- for i = 1, #entsnear do
    --     local distanc = self:GetRangeSquaredTo(entsnear[i])
    --     if distanc < lastdist then
    --         nearnextbot = entsnear[i]
    --         lastdist = distanc
    --     end
    -- end
    -- if IsValid(nearnextbot)

	local _ents = ents.FindInSphere( self:GetPos(), 1000 )
    local mostbad = 0
    local mostbad_ent
    local mostgood = 0
    local mostgood_ent
	for k,v in ipairs( _ents ) do --scans all entities in a radious, checks their reputation / my opinion, then outputs some data
		if (v != self) then

            local FoundEntName = GetBestName(v)

            if (self.OpinionOnEnts[FoundEntName] == nil or FoundEntName == " " or FoundEntName == "" or FoundEntName == ",") then
                if (FoundEntName != nil and FoundEntName != " " and FoundEntName != "") then
                    if (!v:IsWeapon() and v:IsSolid() and (v:IsNPC() or v:IsPlayer() or v:IsNextBot())) then
                        if (self.Fun_AggressionMode) then
                            self.OpinionOnEnts[FoundEntName] = {-99,CurTime()}
                        else
                            self.OpinionOnEnts[FoundEntName] = self:ConstructInitOpinion(v)
                        end
                    else
                            self.OpinionOnEnts[FoundEntName] = {self.Sap_DefaultTrustFactor,CurTime()}
                    end
                    if (SAPBOTDEBUG) then print("S.A.P Bot building opinion for "..FoundEntName) end
                else

                end
            else
                if (self.OpinionOnEnts[FoundEntName][1] > mostgood) then
                    mostgood_ent = v
                    mostgood = self.OpinionOnEnts[FoundEntName][1]
                    --if (SAPBOTDEBUG) then print("S.A.P Bot opinion of "..FoundEntName.." cached") end
                end
                if (self.OpinionOnEnts[FoundEntName][1] < mostbad) then
                    mostbad_ent = v
                    mostbad = self.OpinionOnEnts[FoundEntName][1]
                    --if (SAPBOTDEBUG) then print("S.A.P Bot opinion of "..FoundEntName.." cached") end
                end
            end
		end
	end	
	
    if (mostbad_ent != nil) then
        self.BadNearEnt = mostbad_ent
        self.BadNearEntRep =  mostbad
    else
        self.BadNearEnt = nil
        self.BadNearEntRep = 0
    end
    if (mostgood_ent != nil) then
        self.GoodNearEnt = mostgood_ent
        self.GoodNearEntRep = mostgood
    else
        self.GoodNearEnt = nil
        self.GoodNearEntRep = 0
    end

    if (mostbad_ent != nil or mostgood_ent != nil) then
        return(true)
    else
        return(false)
    end        
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--cool player selection hud thing for when you hover over a sap bot
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
hook.Add( "HUDPaint", "CoolSAPHoverDrawHook", function()
    local scrw, scrh = ScrW(), ScrH()
    if (_SAPBOTS != nil) then
        for k,v in pairs(_SAPBOTS) do
            if (IsValid(v) and v != nil) then
                local rawrenderpos = v:GetPos()
                local DistanceTo3D = (LocalPlayer():GetPos():Distance(rawrenderpos))
                if (DistanceTo3D < 800) then
                    local sapname = v:GetNW2String("Sap_Name")
                    local saphealthperce = math.floor((v:GetNW2Float("Sap_Health") / v:GetNW2Float("Sap_HealthMax")) * 100)
                    local saphealthfivfiv = (saphealthperce * 2.55)
                    local saphealthcolour = Color(255 - saphealthfivfiv,saphealthfivfiv,0)
                    local saphealthbossvo = Color(math.Clamp(saphealthcolour.r - 100,0,255),math.Clamp(saphealthcolour.g - 100,0,255),0)
                    
                    local posModelOffsetMin, posModelOffsetMax = v:GetCollisionBounds()
                    local renderpos = Vector(rawrenderpos.x,rawrenderpos.y,rawrenderpos.z + (posModelOffsetMax.z * 0.75))
                    renderpos = renderpos:ToScreen()
                    if (Vector(renderpos.x,renderpos.y,0):Distance(Vector(scrw / 2,scrh / 2,0)) < (35000 / DistanceTo3D)) then
                        draw.SimpleText(sapname, "HudSelectionText", renderpos.x + 1.5, renderpos.y + 1.5, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                        draw.SimpleText(sapname, "HudSelectionText", renderpos.x, renderpos.y, Color( 0, 255, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

                        if (!(v:GetNW2Float("Sap_HealthMax") > 500)) then
                            draw.SimpleText(saphealthperce..[[%]], "DefaultSmall", renderpos.x + 1.5, renderpos.y + 16.5, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                            draw.SimpleText(saphealthperce..[[%]], "DefaultSmall", renderpos.x, renderpos.y + 15, saphealthcolour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                        end
                    end
                    if (v:GetNW2Float("Sap_HealthMax") > 500) then
                        draw.RoundedBox(5, renderpos.x - 86.5, renderpos.y - 99, 175, 13, saphealthbossvo)
                        draw.RoundedBox(5, renderpos.x - 87.5, renderpos.y - 100, saphealthperce * 1.75, 12, saphealthcolour)
                        draw.SimpleText(v:GetNW2Float("Sap_Health"), "Default", renderpos.x - 1.5, renderpos.y - 96.5, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                        draw.SimpleText(v:GetNW2Float("Sap_Health"), "Default", renderpos.x + 1.5, renderpos.y - 93.5, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                        draw.SimpleText(v:GetNW2Float("Sap_Health"), "Default", renderpos.x + 1.5, renderpos.y - 96.5, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                        draw.SimpleText(v:GetNW2Float("Sap_Health"), "Default", renderpos.x - 1.5, renderpos.y - 93.5, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                        draw.SimpleText(v:GetNW2Float("Sap_Health"), "Default", renderpos.x, renderpos.y - 95, saphealthcolour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                    end
                    local TTSText = v:GetNW2String("TTStextform")
                    if (TTSText != "" and TTSText != nil) then
                        local ttstextpos = Vector(rawrenderpos.x,rawrenderpos.y,rawrenderpos.z + (posModelOffsetMax.z * 0.98))
                        ttstextpos = ttstextpos:ToScreen()
                        local lines = SplitToMultipleLines('"'..TTSText..'"',30)
                        for li,line in pairs(lines) do
                            draw.SimpleText(line, "DebugOverlay", ttstextpos.x + 1, ttstextpos.y + 1 + ((li - 1) * 10), Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                            draw.SimpleText(line, "DebugOverlay", ttstextpos.x, ttstextpos.y + ((li - 1) * 10), Color( 0, 255, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                        end
                    end
                end
                if (SAPBOTDEBUG) then
                    local posModelOffsetMin, posModelOffsetMax = v:GetCollisionBounds()
                    local renderpos = Vector(rawrenderpos.x,rawrenderpos.y,rawrenderpos.z + (posModelOffsetMax.z * 0.88))
                    renderpos = renderpos:ToScreen()
                    draw.SimpleText("S.A.P ("..k..")", "DebugOverlay", renderpos.x + 2, renderpos.y + 2, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                    draw.SimpleText("S.A.P ("..k..")", "DebugOverlay", renderpos.x, renderpos.y, Color( 79, 247, 84 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                end
            end
        end
    end
end)

--gather all weapons i can use in the game and put them into the table
function ENT:CollectAllWeapons()
    local WepCarryOver = {}
    for k,Wep in ipairs( weapons.GetList() ) do
        if (Wep.AdminOnly) then
            if (self.AdminWeapons) then
                table.insert(WepCarryOver, Wep)
            end
        else
            table.insert(WepCarryOver, Wep)
        end
    end
    self.AllSwepWeapons = WepCarryOver
    --AdminOnly
end

function ENT:DeEquipWeapon()
    if (self.CurrentWeapon != nil and IsValid(self.CurrentWeapon)) then
        self.CurrentWeapon:Remove()
        self.CurrentWeapon = nil
        self.CurWeaponHT = "normal"
    end
end

function ENT:EquipWeapon(weaponnum) --equip a weapon by number from the AllSwepWeapons var on this entity, from WepCarryOver, inside CollectAllWeapons
    if (self.CurrentWeapon != nil) then
    self:DeEquipWeapon()
    end
    local handpoint = self:LookupAttachment('anim_attachment_RH')
    local handattach = self:LookupAttachment("hand")
    self.CurrentWeapon = ents.Create(self.AllSwepWeapons[weaponnum].ClassName)
    self.CurrentWeapon:SetOwner(self)
    self.CurrentWeapon:DeleteOnRemove(self.CurrentWeapon)
    self.CurrentWeapon:AddEffects(EF_BONEMERGE)
    self.CurrentWeapon:SetMoveType(MOVETYPE_NONE)

    local matrix = self:GetBoneMatrix(handattach)
    local pos = matrix:GetTranslation()
    local ang = matrix:GetAngles()
    self.CurrentWeapon:SetPos(pos)
    self.CurrentWeapon:SetAngles(ang)
    self.CurrentWeapon:SetParent(self, handpoint)

    self.CurrentWeapon:SetModel("models/food/burger.mdl") --BURGER

    if (self.CurrentWeapon.HoldType != nil) then --determine and set HoldType of the current weapon
        self.CurWeaponHT = self.CurrentWeapon.HoldType
    else
        self.CurWeaponHT = WMtoHoldType(self.CurrentWeapon.WorldModel)
    end
    --self.CurrentWeapon:SendWeaponAnim(ACT_VM_RELOAD)
    --self:SetNW2Entity("sapweapon", self.CurrentWeapon)
end

function ENT:SapBotDeregister()
    _SAPBOTS[self] = nil
    sap_lastleftsatbot = self:GetNW2String("Sap_Name")
end

function ENT:ProcessMention(sourceent,text,offense)
    local howoffend = (offense * self.Sap_IPF_strict)
    local ToSay = ""
    local targname = ""
    if (sourceent == nil) then
        targname = "you"
    else
        targname = GetBestName(sourceent)
    end
    if (howoffend > 1) then --if offended
        if (self.Sap_SM_corruption > 0.8) then
            ToSay = "toxic_to_ent"
        elseif(self.Sap_SM_corruption > 0.6) then
            ToSay = "hate_ent"
        else
            ToSay = "dislike_ent"
        end
        self.OpinionOnEnts[targname] = {self.OpinionOnEnts[targname][1] - (offense * 0.75),CurTime()}
        self.SapCacheSay = GenerateDialog(_SapbotDG_DialogSetTrees[self.DialogSet][ToSay],targname)
    else --if not offended
        self.SapCacheSay = GenerateDialog(_SapbotDG_DialogSetTrees[self.DialogSet]["convo_norm"]["Reply"],targname)
    end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SAY ANYTHING INTO CHAT AND TTS
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
function ENT:Say(texttosay,soundboardsoun) -- forcedialog is to override soundboard
    if (self.SapSoundboardOn and (math.random(0,self.SapSoundboardRate) == 0) and !self.TTStruespeak and !(GetResSoundboarders(self,3000) and soundboardsoun == 1) and !(soundboardsoun == 1 and !self.SapSoundboardMusic)) then -- then do soundboard
        self.SapSoundboardCurrent = true
        self.SapSoundboardMode = soundboardsoun --carry over for the type such as sound effect or music, 1 is music, 0 is sound
        self:TTSSpeak(texttosay)
    else
        table.insert(_Sapbot_Chatlog,self:GetName()..": "..texttosay)
        self:SetNW2String("sap_lastchatlog", (texttosay))
        self:TTSSpeak(texttosay)
        SapProcessChatText(self,texttosay) --process this dialog in the server for others to react to
    end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

function ENT:OpinionChangeRemark(opinionamt,entname) -- their reaction to a CHANGE in opinion on something
    if (SERVER) then
        if (self.TTSspeaking == false and (self.TTStimefornext + 1) < CurTime()) then
            local DoSay = false
            local ToSay = ""
            if (opinionamt > 1.9) then
                if (self.Sap_SM_innocence > 0.75) then
                    ToSay = "love_ent"
                    DoSay = true
                else
                    ToSay = "like_ent"
                    DoSay = true
                end
            elseif (opinionamt < -0.2) then
                if (self.Sap_SM_corruption > 0.75) then
                    ToSay = "hate_ent"
                    DoSay = true
                else
                    ToSay = "dislike_ent"
                    DoSay = true
                end
            elseif (opinionamt < -2) then
                if (self.Sap_SM_corruption > 0.8) then
                    ToSay = "toxic_to_ent"
                    DoSay = true
                else
                    ToSay = "dislike_ent"
                    DoSay = true
                end
            end

            if (DoSay) then
            self:Say(GenerateDialog(_SapbotDG_DialogSetTrees[self.DialogSet][ToSay],entname),0)
            end
        end
    end
end

function ENT:IdleDialog()
    if (SERVER) then
        if (self.TTSspeaking == false and (self.TTStimefornext + 10) < CurTime()) then
            self:Say(GenerateDialog(_SapbotDG_DialogSetTrees[self.DialogSet]["idle_norm"],self:GetName()),1)
        end
    end
end

function ENT:TTSSpeak(ttstext)
    local lowerver = string.lower(ttstext) --sorry for the giant mess here, i could have used a table but it would have had the same result either way, honestly this is more optimized
    --as it doesn't use a loop, not very nice on the eyes though, but it does what its gotta, its actually r ather simplistic, text filtering shit
    lowerver = string.gsub(lowerver, "gm", "gee em")
    lowerver = string.gsub(lowerver, "cmon", "come on")
    lowerver = string.gsub(lowerver, "fnaf", "five nights at freddy's")
    lowerver = string.gsub(lowerver, "ngl", "not gonna lie")
    lowerver = string.gsub(lowerver, "fr", "for real")
    lowerver = string.gsub(lowerver, "haha", "ha ha")
    lowerver = string.gsub(lowerver, "youtube", "you tube")
    lowerver = string.gsub(lowerver, "yt", "you tube")
    lowerver = string.gsub(lowerver, "tv", "tee vee")
    lowerver = string.gsub(lowerver, "rip", "rest in piece")
    lowerver = string.gsub(lowerver, "lmao", "laughing my ass off")
    lowerver = string.gsub(lowerver, "kys", "kill yourself")
    lowerver = string.gsub(lowerver, "omg", "oh my god")
    lowerver = string.gsub(lowerver, "_", "underscore ")
    lowerver = string.gsub(lowerver, "900", "nine hundred ")
    lowerver = string.gsub(lowerver, "800", "eight hundred ")
    lowerver = string.gsub(lowerver, "700", "seven hundred ")
    lowerver = string.gsub(lowerver, "600", "six hundred ")
    lowerver = string.gsub(lowerver, "500", "five hundred ")
    lowerver = string.gsub(lowerver, "450", "four hundred and fifty ")
    lowerver = string.gsub(lowerver, "400", "four hundred ")
    lowerver = string.gsub(lowerver, "350", "three hundred and fifty")
    lowerver = string.gsub(lowerver, "300", "three hundred ")
    lowerver = string.gsub(lowerver, "250", "two hundred and fifty ")
    lowerver = string.gsub(lowerver, "200", "two hundred ")
    lowerver = string.gsub(lowerver, "190", "one hundred and ninety ")
    lowerver = string.gsub(lowerver, "180", "one hundred and eighty ")
    lowerver = string.gsub(lowerver, "170", "one hundred and seventy ")
    lowerver = string.gsub(lowerver, "160", "one hundred and sixty ")
    lowerver = string.gsub(lowerver, "150", "one hundred and fifty ")
    lowerver = string.gsub(lowerver, "140", "one hundred and forty ")
    lowerver = string.gsub(lowerver, "135", "one hundred and thirty five ")
    lowerver = string.gsub(lowerver, "130", "one hundred and thirty ")
    lowerver = string.gsub(lowerver, "125", "one hundred and twenty five ")
    lowerver = string.gsub(lowerver, "120", "one hundred and twenty ")
    lowerver = string.gsub(lowerver, "115", "one hundred and fifteen ")
    lowerver = string.gsub(lowerver, "110", "one hundred and ten ")
    lowerver = string.gsub(lowerver, "105", "one hundred and five ")
    lowerver = string.gsub(lowerver, "100", "one hundred ")
    lowerver = string.gsub(lowerver, "90", "ninety ")
    lowerver = string.gsub(lowerver, "80", "eighty ")
    lowerver = string.gsub(lowerver, "70", "seventy ")
    lowerver = string.gsub(lowerver, "60", "sixty ")
    lowerver = string.gsub(lowerver, "50", "fifty ")
    lowerver = string.gsub(lowerver, "40", "forty ")
    lowerver = string.gsub(lowerver, "30", "thirty ")
    lowerver = string.gsub(lowerver, "29", "twenty nine ")
    lowerver = string.gsub(lowerver, "28", "twenty eight ")
    lowerver = string.gsub(lowerver, "27", "twenty seven ")
    lowerver = string.gsub(lowerver, "26", "twenty six ")
    lowerver = string.gsub(lowerver, "25", "twenty five ")
    lowerver = string.gsub(lowerver, "24", "twenty four ")
    lowerver = string.gsub(lowerver, "23", "twenty three ")
    lowerver = string.gsub(lowerver, "22", "twenty two ")
    lowerver = string.gsub(lowerver, "21", "twenty one ")
    lowerver = string.gsub(lowerver, "20", "twenty ")
    lowerver = string.gsub(lowerver, "19", "nineteen ")
    lowerver = string.gsub(lowerver, "18", "eighteen ")
    lowerver = string.gsub(lowerver, "17", "seventeen ")
    lowerver = string.gsub(lowerver, "16", "sixteen ")
    lowerver = string.gsub(lowerver, "15", "fifteen ")
    lowerver = string.gsub(lowerver, "14", "fourteen ")
    lowerver = string.gsub(lowerver, "13", "thirteen ")
    lowerver = string.gsub(lowerver, "12", "twelve ")
    lowerver = string.gsub(lowerver, "11", "eleven ")
    lowerver = string.gsub(lowerver, "10", "ten ")
    lowerver = string.gsub(lowerver, "1", "one ")
    lowerver = string.gsub(lowerver, "2", "two ")
    lowerver = string.gsub(lowerver, "3", "three ")
    lowerver = string.gsub(lowerver, "4", "four ")
    lowerver = string.gsub(lowerver, "5", "five ")
    lowerver = string.gsub(lowerver, "6", "six ")
    lowerver = string.gsub(lowerver, "7", "seven ")
    lowerver = string.gsub(lowerver, "8", "eight ")
    lowerver = string.gsub(lowerver, "9", "nine ")
    lowerver = string.gsub(lowerver, "%p", ",")

    local ttsscri = ToTTSscript(lowerver,_SapbotDG_TTSSets[self.TTSname])
    --print(ttsscri)
    self:RawTTSSpeak(SplitTTSscript(ttsscri),ttstext)
end

function ENT:RawTTSSpeak(ttstable,ttsnormaltext)
    self.TTScurrent_phoneme = ""
    self.TTStimefornext = 0
    self.TTScurrent_num = 0
    self.TTSscripttable = ttstable
    self.TTSspeaking = true
    self.TTStextform = ttsnormaltext
    if (SERVER) then
        self:SetNW2String("TTStextform",ttsnormaltext)
    end
end

function ENT:SpeakManage() --manages tts stuff
    if (self.TTSspeaking) then
        if (self.TTStimefornext < CurTime()) then
        self.TTScurrent_num = self.TTScurrent_num + 1
            if (self.SapSoundboardCurrent) then --Do Soundboard Sound
                if (self.TTScurrent_num == -1) then --cannot play sound more then once, if so- end shit and give way for new shit to happen
                    self.TTSspeaking = false
                    self.TTScurrent_num = 0
                    self.TTStimefornext = CurTime()
                    self.TTScurrent_phoneme = ""
                    self.TTSscripttable = {}
                    if (SERVER) then
                    self:SetNW2String("TTStextform","")
                    end
                    self.SapSoundboardCurrent = false
                else --do soundboard shit
                    self.TTSspeaking = true
                    self.TTScurrent_num = 0
                    self.TTSscripttable = {}
                    self.TTScurrent_phoneme = ""

                    local soundboard = _SapbotDG_Soundboards[self.SapSoundboard]
                    local constructsoun = "nice" --build dir name via toxic or not
                    local textprevname = "sound"
                    if (self.Sap_SM_corruption > 0.5) then
                        constructsoun = "toxic"
                    end

                    if (self.SapSoundboardMode == 1) then --combine dir name with build name
                        constructsoun = "music"..constructsoun
                        textprevname = "music"
                    else
                        constructsoun = "sounds"..constructsoun
                    end

                    if (SERVER) then
                        self:SetNW2String("TTStextform"," ~ "..textprevname.." ~ ")
                    end

                    local cliptoplay = ""
                    for c,cliprand in RandomPairs(soundboard[constructsoun]) do
                        cliptoplay = cliprand
                        break
                    end

                    self:EmitSound( string.Trim(cliptoplay,"%s"), 100, math.Rand( 99, 101 ), 1, CHAN_VOICE )

                    self.TTStimefornext = CurTime() + SoundDuration(string.Trim(cliptoplay,"%s"))
                    self.TTScurrent_num = -2
                end
            else --Do TTS Stuff
                if (self.TTScurrent_num > #self.TTSscripttable) then
                    self.TTStruespeak = false
                    self.TTSspeaking = false
                    self.TTScurrent_num = 0
                    self.TTStimefornext = CurTime()
                    self.TTScurrent_phoneme = ""
                    self.TTSscripttable = {}
                    if (SERVER) then
                    self:SetNW2String("TTStextform","")
                    end
                    self.SapSoundboardCurrent = false
                else
                    self.TTStruespeak = true
                    self.TTScurrent_phoneme = self.TTSscripttable[self.TTScurrent_num]
                    local adddirection = 0.1
                    if (self.TTScurrent_phoneme != "_wait_") then --play the audio
                        local ttsset = _SapbotDG_TTSSets[self.TTSname]
                        if (self.TTSenabled) then
                            self:EmitSound( string.Trim("sapbot_tts_"..ttsset["name"].."_"..self.TTScurrent_phoneme,"%s"), 100, math.Rand( 99, 101 ), 1, CHAN_VOICE )
                        end
                        adddirection = SoundDuration(string.Trim("sapbot_tts_"..ttsset["name"].."_"..self.TTScurrent_phoneme,"%s")) * 0.95
                    end
                    self.TTStimefornext = CurTime() + adddirection
                end
            end
        end
    end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Enemy Reaction Code, for stuff like running away from an enemy or chasing an enemy 'n combat.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--ENT.AttackTarget = nil -- entity that is attacking
--ENT.IsAttacking = false -- is attacking or not
function ENT:EnemyReaction()
    if (self:ScanEntities()) then --check for if should run from enemy or etc
        if (self.BadNearEnt != nil) then
            local oldthinkproc = self.ThinkingProc
            self.ThinkingProc = false
            self:SetNW2Bool("sap_thinkcarover", self.ThinkingProc)
            --running away from an entity or attacking
            local entitytarget = self.BadNearEnt --by setting this here to a local var, avoids this being nil when BadNearEnt is nil
            local distancemulti = -1

            if (entitytarget == nil or entitytarget == NULL or !IsValid(entitytarget)) then
                if (SAPBOTDEBUG) then print("S.A.P Bot running from ent is nil, ??") end

            else
                local isalready = self.Walking
                if (SAPBOTDEBUG) then print("S.A.P Bot Reacting low opinion of "..entitytarget:GetName()) end

                local options = {}
                local path = Path( "Follow" )
                local maxrange = 512
                local posgoaladditi = (entitytarget:GetPos() - self:GetPos()) * distancemulti
                local posgoal = self:GetPos() + posgoaladditi
                path:SetMinLookAheadDistance( options.lookahead or 300 )
                path:SetGoalTolerance( options.tolerance or 20 )
                path:Compute(self, posgoal)
        
                --if ( !path:IsValid() ) then return "fuck" end
        
                if (!isalready) then
                    self:StartActivity( HTgetAnimRun(self.CurWeaponHT) )
                    self.Walking = true
                end
                self.loco:SetDesiredSpeed( 400 )
                self.loco:SetAcceleration(800) --run drifting gotta make sense lol
                local TargetInRange = self:ScanEntities()

                self.AttackMode = 0
                local AltDelay = CurTime() + math.Rand(0.5,10)
                while ( path:IsValid() and (math.abs(self:GetPos():Distance(posgoal)) > 16) and TargetInRange and (self.BadNearEnt != nil) 
                    and !(entitytarget == nil or entitytarget == NULL or !entitytarget:IsValid())) do
                    local comlogSimple = ((self.Sap_SM_corruption > 0.75) and (self.Stress > 3)) --attacking comprehension
                    local comlogComple = ((self.Sap_SM_corruption > 0.5) and (self.Sap_SM_corruption < 0.75) and (self.Stress < 3))

                    self.IsAttacking = (comlogSimple or comlogComple and self.EquipWeapons) --outcome attacking comprehension

                    if (self.Stress < 10) then
                    self.Stress = self.Stress + ((1 - self.Sap_IPF_paranoid) * 0.01 + (self.Sap_IPF_strict * 0.01)) -- stress gain
                    end
                    if ((self.IsAttacking or self.Fun_AggressionMode) and self.CurrentWeapon != nil and self.CurrentWeapon != NULL) then --attacking code
                        local wep = self.CurrentWeapon
                        local targetpos = entitytarget:GetPos()
                        local eyetrace = self:GetEyeTrace()
                        local attackrange = 200
                        local holdtypeforat = wep:GetHoldType()
                        if (holdtypeforat == "melee" or holdtypeforat == "melee2" or holdtypeforat == "knife" or holdtypeforat == "normal") then
                            attackrange = 32
                        end

                        if ((math.abs(self:GetPos():Distance(targetpos)) > attackrange) or eyetrace["HitWorld"]) then --follow code
                            if (self.AttackMode != 1 and self.AttackMode != 2) then
                                self.AttackMode = 1
                                path:Compute(self, targetpos)
                            end
                        else
                            if (self.AttackMode == 1 or self.AttackMode == 2) then
                                self.AttackMode = 0
                            end
                        end

                        if (eyetrace["HitWorld"] or (math.abs(self:GetPos():Distance(targetpos)) > 1024)) then
                            TargetInRange = self:ScanEntities()
                        elseif(eyetrace["Entity"] != NULL) then
                            if (wep:GetNextPrimaryFire() + math.Rand(0.01,0.1) < CurTime()) then
                                if (wep:Clip1() < 1) then
                                    wep:SetClip1(wep:GetMaxClip1())
                                    wep:Reload()
                                    --wep:DefaultReload(ACT_RELOAD)
                                end

                                local suck, err = pcall(wep.PrimaryAttack, wep)
                                if (!suck) then
                                    table.insert(_Sapbot_WeaponBlacklist,wep.ClassName)
                                    self:EquipRandomWeapon()
                                    if (SAPBOTDEBUG) then
                                        print("S.A.P Bot Weapon "..wep.ClassName.." blacklisted due to autodetected issues :")
                                        print([[    "]]..err..[["]])
                                        print("")
                                    end
                                end
                            end

                            if (wep:GetNextSecondaryFire() + math.Rand(0.01,0.1) < CurTime() and AltDelay < CurTime()) then
                                AltDelay = CurTime() + math.Rand(0.5,10)
                                if (wep:Clip2() < 1) then
                                    wep:SetClip2(wep:GetMaxClip2())
                                end

                                local suck, err = pcall(wep.SecondaryAttack, wep)
                                if (!suck) then
                                    table.insert(_Sapbot_WeaponBlacklist,wep.ClassName)
                                    self:EquipRandomWeapon()
                                    if (SAPBOTDEBUG) then
                                        print("S.A.P Bot Weapon "..wep.ClassName.." blacklisted due to autodetected issues :")
                                        print([[    "]]..err..[["]])
                                        print("")
                                    end
                                end
                            end
                        end

                        -- if (!eyetrace["HitWorld"]) then
                        --     local wep = self.CurrentWeapon
                        --     if (wep:GetNextPrimaryFire() > CurTime()) then
                        --         wep:SetClip1(wep:GetMaxClip1())
                        --         wep:PrimaryAttack()
                        --     end
                        -- end

                        if (self.AttackMode == 1 or self.AttackMode == 2) then --follow moving
                            if (path:GetAge() > 0.5) then
                                path:Compute(self, targetpos)
                            end
                            path:Update(self)
                        end

                        self.loco:FaceTowards(targetpos)
                    else --running code
                        local posgoaladditi = (entitytarget:GetPos() - self:GetPos()) * distancemulti
                        local posgoal = self:GetPos() + posgoaladditi
            
                        if (path:GetAge() > 0.5) then
                            path:Compute(self, posgoal) --calc some shit, cmon baby, you got this, cmon, work dammit!
                        end
                        path:Update(self)
                        
                        if (SAPBOTDEBUG) then path:Draw() end
                        -- if ( self.loco:IsStuck() ) then
                        -- end
                        TargetInRange = self:ScanEntities()
                    end
                    coroutine.yield()
                end
                self.IsAttacking = false
                self.AttackMode = 0

                if (!isalready) then
                    self.Walking = false
                    self:StartActivity( HTgetAnimIdle(self.CurWeaponHT) )
                end
            end
            self.ThinkingProc = oldthinkproc
            self:SetNW2Bool("sap_thinkcarover", self.ThinkingProc)
            return(true)
        else
            return(false)
        end
    else
        return(false)
    end
end

function ENT:EquipRandomWeapon() --equip random weapon, obviously, you fucking moron
    if (self.EquipWeapons) then
        for j,WepToPick in RandomPairs(self.AllSwepWeapons) do
            local wepcanusethis = true
            for k, wepblack in ipairs(_Sapbot_WeaponBlacklist) do
                if (WepToPick == wepblack) then
                    wepcanusethis = false
                    break
                end
            end
            if (wepcanusethis == true) then
                self:EquipWeapon(j)
                --self:SelectWeapon(WepToPick)
                break
            end
        end
    else
        self.CurWeaponHT = "normal"
    end
end

--the main code 'n such i guess, THE BRAIN kinda
function ENT:RunBehaviour()
    if ((self.TTSname == "") or (self.TTSname == nil) or (self.TTSname == 0)) then
        self.TTSname = "main"
    end
    if ((self.SapSoundboard == "") or (self.SapSoundboard == nil) or (self.SapSoundboard == 0)) then
        self.SapSoundboard = "common"
    end
    if (SERVER) then
        if (_Sapbot_Playermodels == nil or !IsValid(_Sapbot_Playermodels)) then
            CacheAllPlayerModels()
        end
    end
    if (self.Sap_Model == "random") then
        for j,newmodel in RandomPairs(player_manager.AllValidModels()) do
            self.Sap_Model = newmodel
            break
        end
    end
    self.EmotionEnabled = false
    self.Living = true
    self.Dead = false
    self.loco:SetJumpHeight(70)
    self.loco:SetAvoidAllowed(true)
    self.loco:SetDeathDropHeight(200)
    self.loco:SetGravity(GetConVar("sv_gravity"):GetFloat())
    self.loco:SetDesiredSpeed( 200 )
    self.loco:SetAcceleration(800)
    self.loco:SetJumpGapsAllowed(true)
	self.LoseTargetDist	= 2000
	self.SearchRadius = 1000
    self:StartActivity( ACT_HL2MP_IDLE )
    if (self.SapSpawnOverride) then
        self:EmitSound( string.Trim("custom/sap/saptransmute.wav","%s"), 100, math.Rand( 95, 110 ), 1, CHAN_ITEM )
    else
        self:EmitSound( string.Trim("custom/sap/sapspawns.wav","%s"), 100, math.Rand( 95, 110 ), 1, CHAN_ITEM )
    end
    spawnpartic = ParticleEffect( "vortigaunt_beam", self:GetPos() + Vector(0, 0, 50), Angle( 0, 0, 0 ), self )

    if (self.SAPCached == false or self.SAPCached == nil) then
        table.insert(_SAPBOTS,self)
        --if (SAPBOTDEBUG and SERVER) then print("S.A.P Bot Cached with ID "..#_SAPBOTS.." into _SAPBOTS") end
        self.SAPCached = true
    end

    coroutine.wait(0.15)
    self:CallOnRemove("SapBotDeregister", function(ent) ent:SapBotDeregister() end)
    --nil carry-over avoidancedsg
    if ((self.Sap_Intelligence == "") or (self.Sap_Intelligence == nil) or (self.Sap_Intelligence == 0)) then --for non-creator tool spawned sap bots, aka npc tab or etc, or if there is an error via server v client issues
        self.TTSname = "main"
        self.SapSoundboard = "common"
        self.Sap_Intelligence = 50
        self.Sap_WanderRange = 256
        self.Sap_Chaos = 1
        self.Sap_IPF_chill = 0.5
        self.Sap_IPF_strict = 0.5
        self.Sap_IPF_calm = 0.5
        self.Sap_IPF_paranoid = 0.5
        self.Sap_SM_innocence = 0.5
        self.Sap_SM_corruption = 0.5
        self.Sap_SM_openminded = 0.5
        self.Sap_SM_closeminded = 0.5
        self.Sap_Name = "S.A.P Bot"
        self.Sap_Model = "models/player/Group01/male_09.mdl"
        self.TTSenabled = true
        self.SapSoundboardOn = false
        self.SapSoundboardRate = 2
        self.EquipWeapons = false
        self.AdminWeapons = false
        self.SapSoundboardMusic = true
        self:SetHealth(100)
        self:SetMaxHealth(100)
    end

    if (self.EquipWeapons) then --store all weapons i can use in the game
        self:CollectAllWeapons()
    end

    self.EmotionExpression = "wakeup"
    self:SetNW2String("sap_emotexpress", "wakeup")
	self:SetModel( self.Sap_Model )
    if (!self.SapSpawnOverride) then --cool spawn effect override stuff
        self:SetMaterial("")
        self:SetColor(Color(255, 255, 255, 255))
    else
        self:SetMaterial(self.MatOverride)
        self:SetColor(self.ColorOverride)

        local posModelOffsetMin, posModelOffsetMax = self:GetModelBounds()
        local posmodAddin = (posModelOffsetMin.z * -1)
        self:SetCollisionBounds(Vector(posModelOffsetMin.x,posModelOffsetMin.y,posModelOffsetMin.z),Vector(posModelOffsetMax.x,posModelOffsetMax.y,posModelOffsetMax.z))
        self:SetPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z + posmodAddin))
    end
    if (SERVER) then
        self:SetNW2String("Sap_Name", self.Sap_Name)
    end
    self.Spawning = false
    
    self:EquipRandomWeapon()

    self:StartActivity( HTgetAnimIdle(self.CurWeaponHT) )

    undo.Create( 'S.A.P Bot' )
    undo.AddEntity(self)
    undo.SetPlayer(self:GetCreator())
    undo.SetCustomUndoText( 'Undone S.A.P Bot ('..self.Sap_Name..')' )
	undo.Finish('S.A.P Bot ('..self.Sap_Name..')')
    coroutine.wait(0.2)
    --self:TTSSpeak("i am heavy weapons dick and this is my new weapon, anyway i'm going to kill you and kill you and each my sandwich all day on your rotting corpse baby")
    self.EmotionEnabled = true
	while ( true ) do --look of stuff that happens in this function forever
        self.Walking = true
        self:StartActivity(HTgetAnimIdle(self.CurWeaponHT)) --start running animation

        --
        local options = {}
        local path = Path( "Follow" )
        local maxrange = 512
        local posgoal = (self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.Sap_WanderRange)
        path:SetMinLookAheadDistance( options.lookahead or 300 )
        --path:SetGoalTolerance( options.tolerance or 20 )
        path:Compute(self, posgoal)
        --if ( !path:IsValid() ) then return "fuck" end
        self.loco:SetDesiredSpeed( 200 )
        self.loco:SetAcceleration(800) --walk drifting

        self.Walking = true
        self:StartActivity( HTgetAnimRun(self.CurWeaponHT) )
        local WalkOverride = false
        while (path:IsValid() and (self:GetPos():Distance(posgoal)) > 16 and !WalkOverride) do --running around and such 
            if ( path:GetAge() > 0.75 ) then
                if (!util.IsInWorld(path:GetAllSegments()[#path:GetAllSegments()]["pos"])) then
                    posgoal = (self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.Sap_WanderRange)
                end
                path:Compute(self, posgoal) --running to a spot 'n such
                local EnemReac = self:EnemyReaction()
                if (EnemReac) then
                    posgoal = (self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.Sap_WanderRange)
                    self.loco:SetDesiredSpeed(200)
                    self.loco:SetAcceleration(800)
                    WalkOverride = true
                end
            end
            path:Update( self )
            if (SAPBOTDEBUG) then path:Draw() end
            coroutine.yield()
        end
        self.Walking = false
        self:StartActivity( HTgetAnimIdle(self.CurWeaponHT) )

        self:ThinkingProcess()

		coroutine.yield()
	end
end

function ENT:ThinkingProcess() --when they are thinking
    self.ThinkingProc = true
    self:SetNW2Bool("sap_thinkcarover", self.ThinkingProc)
    local thinking_endtime = CurTime() + math.Rand(0.1,6)
    local thinking_tick = CurTime() + 0.5
    while (CurTime() < thinking_endtime) do
        if (CurTime() > thinking_tick) then --every blabla seconds do a thing, optimization
            thinking_tick = CurTime() + 0.5
            if (self:ScanEntities()) then --thinking or running away from enemy
                if (self.BadNearEnt != nil) then
                    self:EnemyReaction()
                end
            end
        end
        coroutine.yield()
    end
    self.ThinkingProc = false
    self:SetNW2Bool("sap_thinkcarover", self.ThinkingProc)
end

local EmotionPossibilities = {}
function ENT:EmotManagAddPosible(possible)
    if (!IsValid(EmotionPossibilities) and EmotionPossibilities == nil) then
        EmotionPossibilities[1] = possible
    else
        EmotionPossibilities[#EmotionPossibilities + 1] = possible
    end
end

function ENT:EmotionManagement() --I KNOW THIS LOOKS HORRIBLE, but this is a TON of logic, any better way? tell me!
    EmotionPossibilities = {}
    if (self.EmotionEnabled) then
        if ((self.Stress < 1) and (self.Sap_IPF_chill > 0.75) and (self.Sap_SM_innocence > 0.5)) then
            self:EmotManagAddPosible("chill")
        end
        if ((self.Stress < 2) and ((1 - self.Sap_SM_closeminded) > 0.75)) then
            self:EmotManagAddPosible("closeminded")
        end
        if ((self.Stress < 2) and ((self.Sap_SM_corruption > 0.75))) then
            self:EmotManagAddPosible("corrupted")
        end
        if ((self.Stress > 2) and (self.Stress < 4) and ((self.Sap_SM_corruption < 0.6) and ((1 - self.Sap_IPF_paranoid) < 0.65))) then
            self:EmotManagAddPosible("frazeled")
        end
        if ((self.Stress > 3.5) and ((self.Sap_IPF_strict < 0.6) and (self.Sap_SM_corruption < 0.4))) then
            self:EmotManagAddPosible("freakout")
        end
        if ((self.Stress > 0) and (self.Stress < 3) and ((self.Sap_IPF_strict > 0.5) and (self.Sap_IPF_strict < 0.77) and (self.Sap_SM_corruption > 0.3))) then
            self:EmotManagAddPosible("grumpy")
        end
        if ((self.Stress < 1) and (((1 - self.Sap_IPF_calm) > 0.75) and (self.Sap_SM_innocence > 0.5))) then
            self:EmotManagAddPosible("happy")
        end
        if ((self.Stress < 2) and (((1 - self.Sap_IPF_calm) > 0.5) and (self.Sap_SM_innocence > 0.5))) then
            self:EmotManagAddPosible("happymid")
        end
        if ((self.Stress < 3) and (((1 - self.Sap_IPF_calm) > 0.5) and (self.Sap_SM_innocence > 0.5))) then
            self:EmotManagAddPosible("happylow")
        end
        if ((self.Stress > 3.6) and ((self.Sap_IPF_strict > 0.5) and (self.Sap_SM_corruption > 0.7))) then
            self:EmotManagAddPosible("mad")
        end
        if ((self.Stress > 2) and (((1 - self.Sap_IPF_paranoid) > 0.4) and (self.Sap_SM_innocence > 0.5))) then
            self:EmotManagAddPosible("nervous")
        end
        if ((self.Stress < 2) and (((1 - self.Sap_IPF_calm) > 0.6) and (self.Sap_IPF_chill > 0.6) and ((1 - self.Sap_SM_openminded) > 0.8) and (self.Sap_SM_innocence > 0.5))) then
            self:EmotManagAddPosible("openminded")
        end
        if ((self.Stress > 1) and ((1 - self.Sap_IPF_paranoid) > 0.85)) then
            self:EmotManagAddPosible("paranoid")
        end
        if ((self.Stress < 2) and ((1 - self.Sap_IPF_paranoid) < 0.8) and (self.Sap_IPF_chill > 0.5) and (self.Sap_SM_corruption > 0.5)) then
            self:EmotManagAddPosible("shades")
        end
        if ((self.Stress > 1) and (self.Sap_IPF_chill > 0.85) and ((1 - self.Sap_IPF_calm) > 0.6) and (self.Sap_SM_innocence > 0.87)) then
            self:EmotManagAddPosible("shy")
        end
        if ((self.Stress > 1) and ((1 - self.Sap_IPF_paranoid) < 0.6) and ((1 - self.Sap_IPF_paranoid) > 0.4) and (self.Sap_SM_corruption > 0.5) and ((1 - self.Sap_SM_closeminded) > 0.5)) then
            self:EmotManagAddPosible("thelook")
        end
        self:EmotManagAddPosible("eh")
        self.EmotionExpression = EmotionPossibilities[1]
    end

    if ( SERVER ) then
        if (self.EmotionExpression != self:GetNW2String("sap_emotexpress")) then
            self:SetNW2String("sap_emotexpress", self.EmotionExpression)
        end
        if (self.Stress > 0) then
            self.Stress = self.Stress - 0.005
        end
    end
end

function ENT:OnKilled(dmginfo)
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

    self.Living = false
    self.Dead = true
    self.ThinkingProc = false
    self:SetNW2Bool("sap_thinkcarover", false)

    if (self.CurrentWeapon != nil) then
        self.CurrentWeapon:Remove()
    end
    if (IsValid(dmginfo:GetAttacker())) then
        if (SAPBOTDEBUG) then print("S.A.P Bot "..self.Sap_Name.." Killed by "..dmginfo:GetAttacker():GetName()) end
    else
        if (SAPBOTDEBUG) then print("S.A.P Bot "..self.Sap_Name.." Killed.") end
    end

    local deathsounds = _SapbotDG_TTSSets[self.TTSname]["deaths"]
    if (deathsounds != nil and !table.IsEmpty(deathsounds)) then
        local pickeddeath = ""
        for d,curdeath in RandomPairs(deathsounds) do
            pickeddeath = curdeath
            break
        end
        --EmitSound(pickeddeath["name"], Vector(0,0,0), self:EntIndex(), CHAN_VOICE, 1, SNDLVL_IDLE, SND_NOFLAGS)
        self:EmitSound(pickeddeath["name"])
    end

	self:BecomeRagdoll(dmginfo)
end

function ENT:Think()
    if (SERVER) then --think update server stuff, bla bla
        self:IdleDialog()
        self:SpeakManage()
    end

    if self.InAir then --falling carry over
        self.FallVelocity = -self:GetVelocity().z --used later in falling calc math
    end

    if (CLIENT) then
        if (self.SAPCached == false or self.SAPCached == nil) then
            table.insert(_SAPBOTS,self)
            --if (SAPBOTDEBUG) then print("S.A.P Bot Cached with ID "..#_SAPBOTS.." into _SAPBOTS") end
            self.SAPCached = true
        end
    end

    if CurTime() > self.SapCacheSayTime then
        self.SapCacheSayTime = CurTime() + math.Rand(1,3)
        --say carryover event, maybe mention, with delay
        if (self.SapCacheSay != "") then
            self:Say(self.SapCacheSay,0)
            self.SapCacheSay = ""
        end
    end

    if CurTime() > self.UpdatePhys then --simple phys update clock


        self.UpdatePhys = CurTime() + 0.1

        if (SERVER) then
            self:SetNW2Float("Sap_Health",self:Health())
            self:SetNW2Float("Sap_HealthMax",self:GetMaxHealth())

            local tr = self:GetEyeTrace()
            local ent = tr.Entity
            if IsValid(ent) then
                if (self:GetPos():Distance(ent:GetPos()) < 200) then
                    ent:Fire("Open")
                end
            end
        end

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            if self:WaterLevel() == 0 then -- use later
                phys:SetPos(self:GetPos())
                phys:SetAngles(self:GetAngles())
            else
                phys:UpdateShadow(self:GetPos(), self:GetAngles(), 0)
            end
        end
    end

    if ((self.Dead and !self.Spawning) and (self:GetNW2Float("sap_emoexpTime", 0) > 0) and (CurTime() - self:GetNW2Float("sap_emoexpTime", 0)) > 0.25) then
        self:Remove()
    end

    self:EmotionManagement() --do emotion expression stuff for the rendering to carry over

    if ( CLIENT ) then
        if (!(self.ChatSent == (self:GetNW2String("sap_lastchatlog")))) then
            chat:AddText(Color(0,255,0,255), self:GetNW2String("Sap_Name"), Color(255,255,255,255), ": "..self:GetNW2String("sap_lastchatlog"))--sdfsf
            table.insert(_Sapbot_Chatlog,(self:GetNW2String("Sap_Name")..": "..self:GetNW2String("sap_lastchatlog")))
            self.ChatSent = self:GetNW2String("sap_lastchatlog")
        end

        hook.Add('PreDrawEffects','sapThinkingEffect'..self:EntIndex(),function()
            if !IsValid(self) then hook.Remove('PreDrawEffects','sapThinkingEffect'..self:EntIndex()) return end
                local posModelOffsetMin, posModelOffsetMax = self:GetCollisionBounds()
                local pos = self:GetPos() + Vector(0,0,posModelOffsetMax.z + 15)
                local normal = EyePos() - pos
                local scaling = 10 + (math.sin(CurTime() * 5) * 1.4)

                local TTSText = self:GetNW2String("TTStextform")
                local rendering = false
                if (TTSText != "" and TTSText != nil) then --talking overlay
                    rendering = true
                    render.SetMaterial(Material("custom/sap/talking"))

                elseif (self:GetNW2Bool("sap_thinkcarover")) then --if not talking, can be thinking maybe
                    rendering = true
                    render.SetMaterial(Material("custom/sap/thinking"))
                end
                if (rendering == true) then --render the thinking or talking
                    normal:Normalize()
                    local xyNormal = Vector(normal.x, normal.y, 0)
                    xyNormal:Normalize()

                    local pitch = math.acos(math.Clamp(normal:Dot(xyNormal), -1, 1))
                    local cos = math.cos(pitch)
                    normal = Vector( xyNormal.x * cos, xyNormal.y * cos, math.sin(pitch))
                    render.DrawQuadEasy(pos, normal, scaling, scaling,color_white, 180)
                end
        end)
        hook.Add('PreDrawEffects','sapEmotExpress'..self:EntIndex(),function()
            if !IsValid(self) then hook.Remove('PreDrawEffects','sapEmotExpress'..self:EntIndex()) return end
            render.SetMaterial(Material("custom/sap/sapemot_"..self:GetNW2String("sap_emotexpress")))

            local posModelOffsetMin, posModelOffsetMax = self:GetCollisionBounds()
            local pos = self:GetPos() + Vector(0,0,posModelOffsetMax.z + 6)
            local normal = EyePos() - pos
            local scaling = 0
            if (self:GetNW2Float("sap_emoexpTime", 0) > 0) then
                scaling = 12 - ((CurTime() - self:GetNW2Float("sap_emoexpTime", 0)) * 7)
            else
            scaling = 12
            end
            normal:Normalize()
            local xyNormal = Vector(normal.x, normal.y, 0)
            xyNormal:Normalize()

            local pitch = math.acos(math.Clamp(normal:Dot(xyNormal), -1, 1))
            local cos = math.cos(pitch)
            normal = Vector( xyNormal.x * cos, xyNormal.y * cos, math.sin(pitch))
            render.DrawQuadEasy(pos, normal, scaling, scaling,color_white, 180)
        end)
    end
end

list.Set( "NPC", "S.A.P Bot", {
	Name = "S.A.P Bot",
	Class = "sap_bot",
	Category = "S.A.P Bots | Adaptive Friends"
})