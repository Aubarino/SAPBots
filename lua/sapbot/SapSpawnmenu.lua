-----------------------------------------------
-- Sap SpawnMenu
--- This is where Sap's own spawnmenu resides. It's not that exciting lol
-----------------------------------------------
AddCSLuaFile()
    ENT.CurrentSpawnedProps = 0
    --ENT.CurrentSpawnedNPCS = 0
    --ENT.CurrentSpawnedSENTS = 0
    ENT.SpawnedENTS = {} -- Used to keep track of our spawned entities so we can undo them later if we want

    local IsValid = IsValid

-- function ENT:PressButton(button)

--     if button:GetClass() == "func_button" then
--         button:Fire("Press")
--     elseif button:GetClass() == "gmod_button" then
--         local ison = button:GetOn()
--         if ison then
--             button:Toggle( false, self )
--         else
--             button:Toggle( true, self )
--         end
--     elseif button:GetClass() == "gmod_wire_button" then
--         local ison = button:GetOn()
--         if ison then
--             button:Switch(false)
--         else
--             button:Switch(true)
--         end
--     end

-- end
   
function ENT:GenerateDatasetPropsAt(down,batch)
    if !(self.CanSpawnProps || self.CanSpawnLargeProps) then return end
    print("Attempting to generate from dataset props batch :"..batch)
    if (_Sapbot_PropStructureDataset[batch] != nil) then
        if (#_Sapbot_PropStructureDataset[batch] > 1) then --must be a reasonable size
            local tempPosTable = {}
            for k,propV in ipairs(_Sapbot_PropStructureDataset[batch]) do --for each prop in dataset batch
                if (propV != nil) then --prop cannot contain garbage data
                    self:SpawnProp(down,propV,true)
                end
            end
        end
    end
end

function ENT:SpawnProp(down)
    self:SpawnProp(down,nil,false)
end

function ENT:SpawnProp(down,inputTable,noCast)
    if self.Building == true then return end
    if self.HoldingProp == true then return end
    if !(self.CanSpawnProps || self.CanSpawnLargeProps) then return end
    if self.CurrentSpawnedProps >= 64 then return end
    --if game.SinglePlayer() and !self:TestPVS( Entity(1) ) then return end
    self.Building = true
    local origintrace
    local prop

    DebugText('Spawnmenu: Attempting to spawn a prop')

    local z = math.random(-100,0)

    if down then
        z = -100
    end

    local rndspot = self:GetPos()+Vector(math.random(-500,500),math.random(-500,500),z)

    --self:LookAt(rndspot,'both')
    --self:GoalFaceTowards(rndspot,true)

    timer.Simple(math.random(0.5,1.5),function()
        if !IsValid(self) then self.Building = false return end

        -- ADD THIS BACK -----------------
        --self:StopLooking()
        --local attach = self:GetAttachmentPoint("eyes")

        --local angleforward = attach.Ang:Forward()
        --origintrace = util.TraceLine({start = attach.Pos,endpos = angleforward*800000,filter = self})
        origintrace = self:GetEyeTrace() -- lacks up and down angle though
        --local mins = prop:OBBMins()
        local posEnd = (origintrace.HitPos - origintrace.HitNormal) --where it will spawn
        if (noCast) then posEnd = self:GetPos() end
        self:EmitSound('ui/buttonclickrelease.wav',65)

        prop = ents.Create('prop_physics')
        if (inputTable == nil) then
            prop:SetModel(_Sapbot_PropsList[math.random(#_Sapbot_PropsList)])
            local mins = prop:OBBMins()
            prop:SetPos(posEnd)
            prop:SetAngles(self:GetAngles()+Angle(0,90,0))
        else
            prop:SetModel(inputTable.model)
            local mins = prop:OBBMins()
            prop:SetPos(posEnd + inputTable.pos)
            prop:SetAngles(inputTable.angle)
            if (inputTable.mat != nil && inputTable.mat != "" && inputTable.mat != " ") then
                prop:SetMaterial(inputTable.mat)
            end
            prop:SetColor(inputTable.color)
        end
        prop.IsSapProp = true
        prop:SetOwner(self)
        prop:SetSpawnEffect(true)
        prop:Spawn()
        self:LookAt(prop)
        prop:GetPhysicsObject():EnableMotion(false)

        -- self.achievement_Creator = self.achievement_Creator + 1
        -- if self.achievement_Creator == self.achievement_CreatorMax then
        --     self:AwardAchievement("Creator")
        -- end

        -- if self.Weapon == 'TOOLGUN' and math.random(1,2) == 1 then
        --     self:UseToolGun()
        -- end

        if SAPBOTDEBUG then
            --net.Start("sap_sendonscreenlog",true)
            --net.WriteString(self.Sap_Name..' spawned model ('..prop:GetModel()..')')
            --net.WriteColor(Color(255,255,255),false)
            --net.Broadcast()
            --MsgAll('S.A.P: ',self:GetNW2String('Sap_Name','S.A.P Bot')..' spawned model ('..prop:GetModel()..')')
        end

        local min,max = prop:GetModelBounds()
        if self.CanSpawnLargeProps then
            if max.x > 70 and max.y > 70 then
                prop:GetPhysicsObject():EnableMotion(false)
                --DebugText('Spawnmenu: Large Prop Froze '..tostring(prop)..'  Bounds of prop = '..max.x..' '..max.y..' '..max.z)
            end
        else
            if max.x > 70 and max.y > 70 or max.z > 100 then
                prop:Remove()
                --DebugText('Spawnmenu: Prop was large, Removed.')
                self.Building = false
                return
            end
        end

        -- unfroze?
        if math.random(1,2) == 1 then
            prop:GetPhysicsObject():EnableMotion(false)
        else
            timer.Simple(5,function()
                if !self:IsValid() then return end
                if !prop:IsValid() then return end
                if !prop:GetPhysicsObject():IsValid() then return end
                prop:GetPhysicsObject():EnableMotion(false)
            end)
        end

        if (!self.Building) then return end --must still be building, aka prop must be valid
        table.insert(self.SpawnedENTS,prop)
        self.CurrentSpawnedProps = self.CurrentSpawnedProps + 1

        DebugText('Spawnmenu: Created Prop. Now SAP has '..self.CurrentSpawnedProps..' Props.')

        if (SERVER) then
            prop:CallOnRemove('propcallremove'..prop:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedProps = self.CurrentSpawnedProps - 1
                table.RemoveByValue(self.SpawnedENTS,prop)
            end)
        end

        -- local sapstats = file.Read("sapbotdata/sapstats.json")

        -- if sapstats then
        --     sapstats = util.JSONToTable(sapstats)

        --     if sapstats then

        --         sapstats["spawnedpropscount"] = sapstats["spawnedpropscount"] and sapstats["spawnedpropscount"]+1 or 1

        --         SapFileWrite("sapbotdata/sapstats.json",util.TableToJSON(sapstats,true))
        --     else
        --         SapFileWrite("sapbotdata/sapstats.json","[]")
        --     end
        -- end

        
        self.Building = false
    end)




    while self.Building == true do
        coroutine.yield()
    end
    if !self.Building then
        return prop
    end
end

-- function ENT:UndoLastEnt()

--     local lastent = self.SpawnedENTS[#self.SpawnedENTS]

--     if lastent and lastent:IsValid() then
        
--         self.achievement_Remove = self.achievement_Remove + 1
--         if self.achievement_Remove == self.achievement_RemoveMax then
--             self:AwardAchievement("Remover")
--         end

--         table.RemoveByValue(self.SpawnedENTS,lastent)
--         lastent:Remove()
--         self:EmitSound('buttons/button15.wav',70)
--         DebugText('Spawnmenu: Undone '..tostring(lastent))
--     else
--         table.RemoveByValue(self.SpawnedENTS,lastent)
--         DebugText('Spawnmenu: Failed to undo a entity. Entity was not valid')
--     end

-- end





-- function ENT:SpawnMedKit(overrideCount)
--     if self.TypingInChat then return end
--     if self.Building == true then return end
--     if self.HoldingProp == true then return end
--     if GetConVar('sapbot_allowmedkits'):GetInt() == 0 then return end
--     if self.CurrentSpawnedSENTS >= GetConVar('sapbot_sentlimit'):GetInt() then return end
--     self.Building = true

--     DebugText('Spawnmenu: Attempting to spawn a medkit')

--     local rndspot = self:GetPos()+Vector(math.random(-10,10),math.random(-10,10),math.random(0,-100))

--     self:LookAt(rndspot,'both')

--     local timerName = 'saptimer_spawnmedkits_'..self:EntIndex()
--     local useToolGun = (self.Weapon == 'TOOLGUN' and math.random(1,2) == 1)
--     local spawnCount = overrideCount or math.random(1, math.max(1, math.ceil((self:GetMaxHealth()-self:Health())/25)))
--     timer.Create(timerName, 0.4, spawnCount, function()
--         if !IsValid(self) then return end
        
--         local medkit = ents.Create('item_healthkit')
--         medkit:SetModel('models/Items/HealthKit.mdl')
--         medkit:SetPos(self:GetPos()+self:GetForward()*50+Vector(0,0,5))
--         medkit.IsSapProp = true
--         medkit:SetOwner( self )
--         medkit:SetSpawnEffect( true )
        
--         if useToolGun then
--             self:UseToolGun()
--         else
--             self:EmitSound('ui/buttonclickrelease.wav',65)
--         end
        
--         if GetConVar('sapbot_consolelog'):GetInt() == 1 then
--             if GetConVar("sapbot_showsaplogonscreen"):GetInt() == 1 then
--                 net.Start("sap_sendonscreenlog",true)
--                 net.WriteString(self.Sap_Name..' spawned SENT MedKit ('..medkit:GetModel()..')')
--                 net.WriteColor(Color(255,255,255),false)
--                 net.Broadcast()
--             end
--             MsgAll('S.A.P: ',self:GetNW2String('sap_name','S.A.P Bot')..' spawned SENT MedKit ('..medkit:GetModel()..')')
--         end

--         table.insert(self.SpawnedENTS,medkit)
--         self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS + 1
--         DebugText('Spawnmenu: Created a Medkit! Now have '..self.CurrentSpawnedSENTS..' SENTs with the limit being, '..GetConVar('sapbot_sentlimit'):GetInt())
        
--         if ( SERVER ) then
--             medkit:CallOnRemove('medkitcallremove'..medkit:EntIndex(),function()
--                 if !self:IsValid() then return end
--                 self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS - 1
--                 table.RemoveByValue(self.SpawnedENTS,medkit)
--             end)
--         end

--         if timer.RepsLeft(timerName) == 0 then 
--             self:StopLooking()
--             self.Building = false 
--         end

--         medkit:Spawn()
--     end)




--     while self.Building == true do
--         coroutine.yield()
--     end
-- end



-- function ENT:SpawnArmorBattery()
--     if self.TypingInChat then return end
--     if self.Building == true then return end
--     if self.HoldingProp == true then return end
--     if GetConVar('sapbot_allowarmorbatteries'):GetInt() == 0 then return end
--     if self.CurrentSpawnedSENTS >= GetConVar('sapbot_sentlimit'):GetInt() then return end
--     self.Building = true

--     DebugText('Spawnmenu: Attempting to spawn a Battery')

--     local rndspot = self:GetPos()+Vector(math.random(-10,10),math.random(-10,10),math.random(0,-100))

--     self:LookAt(rndspot,'both')

--     local timerName = 'saptimer_spawnbatteries_'..self:EntIndex()
--     local useToolGun = (self.Weapon == 'TOOLGUN' and math.random(1,2) == 1)
--     local spawnCount = math.random(1, math.max(1, math.ceil((self.MaxArmor-self.CurrentArmor)/15)))
--     timer.Create(timerName, 0.4, spawnCount, function()
--         if !IsValid(self) then return end
        
--         local battery = ents.Create('item_battery')
--         battery:SetModel('models/Items/battery.mdl')
--         battery:SetPos(self:GetPos()+self:GetForward()*50+Vector(0,0,5))
--         battery.IsSapProp = true
--         battery:SetOwner( self )
--         battery:SetSpawnEffect( true )
        
--         if useToolGun then
--             self:UseToolGun()
--         else
--             self:EmitSound('ui/buttonclickrelease.wav',65)
--         end
        
--         if GetConVar('sapbot_consolelog'):GetInt() == 1 then
--             if GetConVar("sapbot_showsaplogonscreen"):GetInt() == 1 then
--                 net.Start("sap_sendonscreenlog",true)
--                 net.WriteString(self.Sap_Name..' spawned SENT Armor Battery ('..battery:GetModel()..')')
--                 net.WriteColor(Color(255,255,255),false)
--                 net.Broadcast()
--             end
--             MsgAll('S.A.P: ',self:GetNW2String('sap_name','S.A.P Bot')..' spawned SENT Armor Battery ('..battery:GetModel()..')')
--         end
        
--         table.insert(self.SpawnedENTS,battery)
--         self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS + 1
--         DebugText('Spawnmenu: Created a Armor Battery! Now have '..self.CurrentSpawnedSENTS..' SENTs with the limit being, '..GetConVar('sapbot_sentlimit'):GetInt())
        
--         if ( SERVER ) then
--             battery:CallOnRemove('batterycallremove'..battery:EntIndex(),function()
--                 if !self:IsValid() then return end
--                 self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS - 1
--                 table.RemoveByValue(self.SpawnedENTS,battery)
--             end)
--         end

--         if timer.RepsLeft(timerName) == 0 then 
--             self:StopLooking()
--             self.Building = false 
--         end

--         battery:Spawn()
--     end)




--     while self.Building == true do
--         coroutine.yield()
--     end
-- end





-- function ENT:SpawnNPC()
--         if self.TypingInChat then return end
--         if self.Building == true then return end
--         if self.HoldingProp == true then return end
--         if GetConVar('sapbot_allownpcs'):GetInt() == 0 then return end
--         if !self.ValidNPCS then print('WARNING: S.A.P VALID NPCS IS NOT VALID!') return end
--         if self.CurrentSpawnedNPCS >= GetConVar('sapbot_npclimit'):GetInt() then DebugText('Spawnmenu: NPC Limit Reached!') return end
--         self.Building = true
--         local origintrace

--         DebugText('Spawnmenu: Attempting to spawn a NPC')

--         local class = self.ValidNPCS[math.random(#self.ValidNPCS)]
        
    
--         local rndspot = self:GetPos()+Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(0,-50))
    
--         self:LookAt(rndspot,'both')
    
--         timer.Simple(math.random(0.5,1.5),function()
--             if !self:IsValid() then self.Building = false return end
    
    
    
--             self:StopLooking()
--             local attach = self:GetAttachmentPoint("eyes")

--                 local angleforward = attach.Ang:Forward()
--                 origintrace = util.TraceLine({start = attach.Pos,endpos = angleforward*800000,filter = self})

    
--             local npc = ents.Create(class)

--             if !npc:IsValid() then
--                 self.Building = false
--                 return
--             end

--             self:EmitSound('ui/buttonclickrelease.wav',65)
--             npc:SetPos(origintrace.HitPos+origintrace.Normal*-50)

--             if ( SERVER ) then
--                 if GetConVar('sapbot_removepropsondeath'):GetInt() == 1 then
--                 self:CallOnRemove('sapremoveondelete' .. npc:EntIndex(),function()
--                     if npc:IsValid() then
--                         npc:Remove()
--                     end
--                 end)
--                 end
--             end
            
--             npc.IsSapProp = true
--             npc:SetSpawnEffect( true )
--             npc:AttemptGiveWeapons()
--             npc:Spawn()

--             local mins = npc:OBBMins()
--             local pos = npc:GetPos()

--             pos.z = pos.z - mins.z 

--             npc:SetPos(pos)

--             self.achievement_ProCreator = self.achievement_ProCreator + 1

--             if self.achievement_ProCreator == self.achievement_ProCreatorMax then
--                 self:AwardAchievement("ProCreator")
--             end

--             if self.Weapon == 'TOOLGUN' and math.random(1,2) == 1 then
--                 self:UseToolGun()
--             end

--             if GetConVar('sapbot_consolelog'):GetInt() == 1 then
--                 if GetConVar("sapbot_showsaplogonscreen"):GetInt() == 1 then
--                     net.Start("sap_sendonscreenlog",true)
--                     net.WriteString(self.Sap_Name..' spawned NPC ('..npc:GetClass()..')')
--                     net.WriteColor(Color(255,255,255),false)
--                     net.Broadcast()
--                 end
--                 MsgAll('S.A.P: ',self:GetNW2String('sap_name','S.A.P Bot')..' spawned NPC ('..npc:GetClass()..')')
--             end
    
--             table.insert(self.SpawnedENTS,npc)

--             self.CurrentSpawnedNPCS = self.CurrentSpawnedNPCS + 1
--             DebugText('Spawnmenu: Created a NPC! Now have '..self.CurrentSpawnedNPCS..' NPCs with the limit being, '..GetConVar('sapbot_npclimit'):GetInt())
            
--             if ( SERVER ) then
--                 npc:CallOnRemove('npccallremove'..npc:EntIndex(),function()
--                     if !self:IsValid() then return end
--                         self.CurrentSpawnedNPCS = self.CurrentSpawnedNPCS - 1
--                     table.RemoveByValue(self.SpawnedENTS,npc)
--                 end)
--             end
    
--                 self.Building = false
--         end)
    
    
    
    
--         while self.Building == true do
--             coroutine.yield()
--         end

-- end


-- function ENT:SpawnEntity()
--     if self.TypingInChat then return end
--     if self.Building == true then return end
--     if self.HoldingProp == true then return end
--     if GetConVar('sapbot_allowentities'):GetInt() == 0 then return end
--     if !self.ValidENTS then print('WARNING: S.A.P VALID ENTITIES IS NOT VALID!') return end
--     if self.CurrentSpawnedSENTS >= GetConVar('sapbot_sentlimit'):GetInt() then DebugText('Spawnmenu: Entity Limit Reached!') return end
--     self.Building = true
--     local origintrace

--     DebugText('Spawnmenu: Attempting to spawn a Entity')

--     local class = self.ValidENTS[math.random(#self.ValidENTS)]
    

--     local rndspot = self:GetPos()+Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(0,-50))

--     self:LookAt(rndspot,'both')

--     timer.Simple(math.random(0.5,1.5),function()
--         if !self:IsValid() then self.Building = false return end



--         self:StopLooking()
--         local attach = self:GetAttachmentPoint("eyes")

--         local angleforward = attach.Ang:Forward()
--         origintrace = util.TraceLine({start = attach.Pos,endpos = angleforward*800000,filter = self})


--         local ent = ents.Create(class)

--         if !IsValid(ent) then self.Building = false return end

--         if ent:IsVehicle() then
--             if GetConVar('sapbot_allowvehicles'):GetInt() == 1 then
--             ent:SetModel('models/buggy.mdl')
--             ent:SetKeyValue('vehiclescript','scripts/vehicles/jeep_test.txt')
--             else
--                 self.Building = false
--                 ent:Remove()
--                 return
--             end
--         end

--         self:EmitSound('ui/buttonclickrelease.wav',65)

--         if ( SERVER ) then
--             if GetConVar('sapbot_removepropsondeath'):GetInt() == 1 then
--             self:CallOnRemove('sapremoveondelete' .. ent:EntIndex(),function()
--                 if ent:IsValid() then
--                     ent:Remove()
--                 end
--             end)
--             end
--         end

--         ent.IsSapProp = true
--         ent:SetSpawnEffect( true )
--         ent:Spawn()
--         if class == 'sent_ball' then 
--             ent:SetBallSize(math.random(16, 48))
--             if math.random(40) == 1 then
--                 ent:SetBallColor(Vector(1, 1, 1))
--                 self:AwardAchievement("Finally, A Grey One!")
--             end
--         end
--         local mins = ent:OBBMins()
--         ent:SetPos(origintrace.HitPos - origintrace.HitNormal * mins.z)



--         if self.Weapon == 'TOOLGUN' and math.random(1,2) == 1 then
--             self:UseToolGun()
--         end
--         if GetConVar('sapbot_consolelog'):GetInt() == 1 then
--             if GetConVar("sapbot_showsaplogonscreen"):GetInt() == 1 then
--                 net.Start("sap_sendonscreenlog",true)
--                 net.WriteString(self.Sap_Name..' spawned Entity ('..ent:GetClass()..')')
--                 net.WriteColor(Color(255,255,255),false)
--                 net.Broadcast()
--             end
--             MsgAll('S.A.P: ',self:GetNW2String('sap_name','S.A.P Bot')..' spawned Entity ('..ent:GetClass()..')')
--         end

--         table.insert(self.SpawnedENTS,ent)

--         self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS + 1
--         DebugText('Spawnmenu: Created a Entity! Now have '..self.CurrentSpawnedSENTS..' Entities with the limit being, '..GetConVar('sapbot_sentlimit'):GetInt())
        
--         if ( SERVER ) then
--             ent:CallOnRemove('entcallremove'..ent:EntIndex(),function()
--                 if !self:IsValid() then return end
--                     self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS - 1
--                 table.RemoveByValue(self.SpawnedENTS,ent)
--             end)
--         end

--             self.Building = false
--     end)




--     while self.Building == true do
--         coroutine.yield()
--     end

-- end



--[[ function ENT:UseSprayer() Old system
	if self.Building == true or self.HoldingProp == true then return end
	self.Building = true

	local lookup = self:LookupAttachment('eyes')
	local eyes = self:GetAttachment(lookup)

	local rndspot = eyes.Pos + Vector(math.random(-328, 328), math.random(-328, 328), math.random(-328, 328))
	self:LookAt(rndspot, 'both')

	timer.Simple(math.random(0.5, 1.5),function()
		if !self:IsValid() then return end
		self.Building = false
		
        // Traceline from eye to rndspot
		local lookTrace = util.TraceLine({
		start = eyes.Pos,
		endpos = rndspot,
		filter = {self},
        collisiongroup = COLLISION_GROUP_DEBRIS
		})
		if !lookTrace.Hit then return end
		
        // The folder with sprays could probably be named 'custom_sprays'
        -- Yes it will
        local images,dirs = file.Find("sapbotdata/custom_sprays/*","DATA","nameasc")
        if !images then self.Building = false return end
		local sprayImage ="../data/sapbotdata/custom_sprays/"..images[math.random(#images)]
		net.Start('sap_usesprayer',true)
			net.WriteString(sprayImage) // Spray Image Path
			net.WriteTable(lookTrace)   // TraceResult table
		net.Broadcast()

		self:EmitSound('player/sprayer.wav', 65)    // Play spray sound
		self:StopLooking()
	end)

	while self.Building == true do
		coroutine.yield()
	end
end ]]



-- function ENT:UseSprayer()
--     if self.TypingInChat then return end
-- 	if self.Building == true or self.HoldingProp == true then return end
--     if GetConVar("sapbot_allowsprays"):GetInt() == 0 then return end
-- 	self.Building = true


-- 	local eyes = self:GetAttachmentPoint("eyes")

-- 	local rndspot = eyes.Pos + Vector(math.random(-328, 328), math.random(-328, 328), math.random(-328, 328))
-- 	self:LookAt(rndspot, 'both')

-- 	timer.Simple(math.random(0.5, 1.5),function()
-- 		if !self:IsValid() then return end
-- 		self.Building = false
		
--         // Traceline from eye to rndspot
-- 		local lookTrace = util.TraceLine({
-- 		start = eyes.Pos,
-- 		endpos = rndspot,
-- 		filter = {self},
--         collisiongroup = COLLISION_GROUP_DEBRIS
-- 		})
-- 		if !lookTrace.Hit then return end
		
-- 		local sprayImage = nil

-- 		// The folder with sprays could probably be named 'custom_sprays'
-- 		-- Yes it will
-- 		local images,dirs = file.Find("sapbotdata/custom_sprays/*","DATA","nameasc")
-- 		if images and #images > 0 then sprayImage ="../data/sapbotdata/custom_sprays/"..images[math.random(#images)] end
		
-- 		// Material files support (couldn't find a way to animate them tho)
-- 		local isMaterial = -1
-- 		local textures,dirs = file.Find("sourceengine/materials/sapsprays/*","BASE_PATH","nameasc")
-- 		if textures and #textures > 0 then
-- 			for k, v in ipairs(textures) do
-- 				if !string.EndsWith(v, '.vtf') then table.remove(textures, k) continue end
-- 			end
		
-- 			if !images or #images <= 0 or math.random(1, (#images+#textures)) <= #textures then

-- 				local matPath = 'sapsprays/'..textures[math.random(#textures)]
-- 				sprayImage = string.Left(matPath, string.len(matPath) - 4)
-- 				isMaterial = self:EntIndex() + math.random(10000, 99999)
-- 			end
-- 		end
		
-- 		if sprayImage == nil then return end

--         net.Start('sap_usesprayer',true)
-- 			net.WriteString(sprayImage) // Spray Image Path
-- 			net.WriteTable(lookTrace)   // TraceResult table
--             net.WriteInt(isMaterial, 32)
-- 		net.Broadcast()

-- 		self:EmitSound('player/sprayer.wav', 65)    // Play spray sound
-- 		self:StopLooking()
-- 	end)

-- 	while self.Building == true do
-- 		coroutine.yield()
-- 	end
-- end

