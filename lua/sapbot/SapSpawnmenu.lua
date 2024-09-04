AddCSLuaFile()
    ENT.CurrentSpawnedProps = 0
    ENT.SpawnedENTS = {} -- Used to keep track of our spawned entities so we can undo them later if we want

    local IsValid = IsValid
    --most of the stuff in this file relates to the sap bot spawning code / how they spawn and build with props

--this builds a structure of props from a dataset batch directly
function ENT:GenerateDatasetPropsAt(down,batch)
    if !(self.CanSpawnProps || self.CanSpawnLargeProps) then return end
    if SAPBOTDEBUG then --some debug info
        print("Attempting to generate from dataset ("..self.CurrentPropDataset..") props batch :"..batch)
    end
    if (_SapbotPropDatasets[self.CurrentPropDataset] == nil) then
        print("S.A.P Bot prop dataset ("..self.CurrentPropDataset..") contains nothing, please double check if dataset is valid or working")
    else
        if (_SapbotPropDatasets[self.CurrentPropDataset][batch] != nil) then
            if (#_SapbotPropDatasets[self.CurrentPropDataset][batch] > 1) then --must be a reasonable size
                local tempPosTable = {}
                local originPos = self:GetPos() --the original standing pos
                if (self.CurrentWeapon == nil) then --put the weapon in hand
                    self:SelectWeapon("weapon_sapphysgun")
                else
                    if (self.CurrentWeapon:GetClass() != "weapon_sapphysgun") then
                        self:SelectWeapon("weapon_sapphysgun")
                    end
                end

                self:SetNW2Entity("CurrentWeapon_",self.CurrentWeapon)
                --self.Building = true

                for k,propV in ipairs(_SapbotPropDatasets[self.CurrentPropDataset][batch]) do --for each prop in dataset batch
                    if (propV != nil) then --prop cannot contain garbage data
                        self:SpawnProp(down,propV,true,originPos,false)
                        coroutine.wait(0.15)
                    end
                end
                self.Building = false
                self.HoldingProp = false

                --self.Building = false
                if (IsValid(self)) then --just incase
                    if (self.CurrentWeapon != nil) then
                        if (self.CurrentWeapon:GetClass() == "weapon_sapphysgun") then
                            if (self.LastWeapon == nil || self.LastWeapon == "") then
                                self:DeEquipWeapon()
                            else
                                self:SelectWeapon(self.LastWeapon) --reselect last weapon
                            end
                        end
                    end
                end
            end
        end
    end
    self.Building = false
    self.HoldingProp = false
end

--smaller more simple way to spawn props, but cannot control prop data table, will be random from what it can spawn
function ENT:SpawnProp(down)
    self:SpawnProp(down,nil,false,self:GetPos(),false)
end

--spawns a prop at a location, with a prop data table of my own design, originPos is the original standing location
function ENT:SpawnProp(down,inputTable,noCast,originPos,canWalkTo)
    self.Building = true
    if (self.Building) then
        local startTimeSafer = 0
        while (self.HoldingProp && self.Building && startTimeSafer < 512) do
            startTimeSafer = startTimeSafer + 1
            if (startTimeSafer > 510) then
                print("UH OH, issue with sap prop spawning?")
            end
            coroutine.wait(0.1)
            coroutine.yield()
        end
    end
    if !self.Building then return end

    if !(self.CanSpawnProps || self.CanSpawnLargeProps) then return end
    if self.CurrentSpawnedProps >= self.SapPropLimit then
        self.Building = false
        return
    end

    local origintrace
    local prop

    --DebugText('S.A.P Spawnmenu: Attempting to spawn a prop')
    local z = math.random(-100,0)
    if down then
        z = -100
    end

    if (originPos == nil) then originPos = self:GetPos() end
    local rndspot = originPos + Vector(math.random(-500,500),math.random(-500,500),z)

    timer.Simple(math.random(0.5,1.5),function()
        if !IsValid(self) then self.Building = false return end
        -- ADD THIS BACK ME!-----------------
        --self:StopLook()

        origintrace = self:GetEyeTrace() -- lacks up and down angle though
        local posEnd = (origintrace.HitPos - origintrace.HitNormal) --where it will spawn
        local angleEnd = self:GetAngles()+Angle(0,90,0)
        local angleMulti = 0
        local posMulti = 0
        if (noCast) then posEnd = originPos end
        self:EmitSound('ui/buttonclickrelease.wav',65)

        prop = ents.Create('prop_physics')
        if (inputTable == nil) then --spawn random prop simply
            prop:SetModel(_Sapbot_PropsList[math.random(#_Sapbot_PropsList)])
            local mins = prop:OBBMins()

        else --spawn prop based on input table data of prop
            prop:SetModel(inputTable.model)
            local mins = prop:OBBMins()
            posEnd = posEnd + inputTable.pos --update the end pos of where the prop must go
            angleEnd = inputTable.angle

            if (inputTable.mat != nil && inputTable.mat != "" && inputTable.mat != " ") then
                prop:SetMaterial(inputTable.mat)
            end
            prop:SetColor(inputTable.color)
        end
        local partialPos = self:GetPos() + ((posEnd - self:GetPos()) * 0.65) + Vector(0,0,32) --partial towards end location, relative to self

        if (canWalkTo) then --walk to the prop spawned? weirdass choice on my part, but gg, will refine later
            local options = {}
            local path = Path( "Follow" )
            path:SetMinLookAheadDistance( options.lookahead or 300 )
            path:SetGoalTolerance( options.tolerance or 20 )
            self.Walking = true
            self.loco:SetDesiredSpeed( 200 )
            self.loco:SetAcceleration(800)
            self:GoalFaceTowards(posEnd,false)
            path:Compute(self, posEnd)
            self.LastTargetPos = posEnd
            path:Update(self)
            self:LocoInterjection(path)
            if (self.Fun_ActivePathingMode) then
                self:FunActivePathing()
            end
            if (SAPBOTDEBUG) then path:Draw() end
        else --cannot walk while building, just incase
            self.Walking = false
        end

        prop.IsSapProp = true
        prop:SetOwner(self)
        prop:SetSpawnEffect(true)
        prop:SetPos(partialPos)
        prop:Spawn()
        self.CurrentSpawnedProps = self.CurrentSpawnedProps + 1
        self.HoldingPropEnt = prop

        self:SetNW2Vector("HoldingPropEnt_",self.HoldingPropEnt:GetPos())

        prop:GetPhysicsObject():EnableMotion(false) --freeze
        self:LookAt(prop)
        local moveToSpawn = true --defines if when spawned the prop must be moved to location, or spawns there.

        local min,max = prop:GetModelBounds() --stuff relating to if the prop is large or not!

        if max.x > 64 && max.y > 64 || max.z > 64 then
            if self.CanSpawnLargeProps then
                prop:GetPhysicsObject():EnableMotion(false)
                moveToSpawn = false
                --DebugText('Spawnmenu: Large Prop Froze '..tostring(prop)..'  Bounds of prop = '..max.x..' '..max.y..' '..max.z)
            else
                prop:Remove()
                --DebugText('Spawnmenu: Prop was large, Removed.')
                self.Building = false
                moveToSpawn = false
            end
        end

        if (inputTable != nil) then --just to be safe
            --defines certain hard-coded props to be spawned at-pos instead of moving to
            if (inputTable.model == "models/props_c17/oildrum001_explosive.mdl") then moveToSpawn = false end
        end

        if (moveToSpawn) then
            local timername = self.Sap_Name.."BuildingTimer"
            timer.Create(timername, 0, 256, function() --move towards location, first rotate and then move it
                if (!IsValid(self)) then
                    timer.Stop(self.Sap_Name.."BuildingTimer")
                    timer.Remove(self.Sap_Name.."BuildingTimer")
                    return
                end
                self.Building = true
                self.HoldingProp = true

                self:SetNW2Bool("HoldingProp_",self.HoldingProp)

                if !((angleMulti < 0.97 || posMulti < 0.97) && IsValid(self)) then
                    prop:SetPos(posEnd)
                    prop:SetAngles(angleEnd)
                    if (SAPBOTDEBUG) then
                        print(self.Sap_Name.." Placed Prop "..prop:GetModel().." At "..tostring(posEnd))
                    end
                    self.HoldingProp = false
                    self.Building = false
                    self:SetNW2Bool("HoldingProp_",self.HoldingProp)

                    timer.Stop(self.Sap_Name.."BuildingTimer")
                    timer.Remove(self.Sap_Name.."BuildingTimer")
                end
                prop:SetPos(LerpVector(posMulti, partialPos, posEnd))
                prop:SetAngles(LerpAngle(angleMulti, self:GetAngles() + Angle(0,90,0), angleEnd))
                self:SetNW2Vector("HoldingPropEnt_",self.HoldingPropEnt:GetPos())
                
                if (angleMulti < 0.97) then
                    angleMulti = angleMulti + 0.07
                else
                    posMulti = posMulti + 0.05
                end
            end)
        else
            self.HoldingProp = false
            prop:SetPos(posEnd)
            prop:SetAngles(angleEnd)
        end
        

        if SAPBOTDEBUG then
            --add some more debug info later
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

        if SAPBOTDEBUG then
            print('SAP Spawnmenu: Created Prop. Now SAP has '..self.CurrentSpawnedProps..' Prop(s)')
        end

        if (SERVER) then
            prop:CallOnRemove('propcallremove'..prop:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedProps = self.CurrentSpawnedProps - 1
                table.RemoveByValue(self.SpawnedENTS,prop)
            end)
        end

        self.Building = false
    end) --end of timed build event thingy

    --lock-in time stuff for building, and returns
    while self.Building do
        coroutine.yield()
    end
    if !self.Building then
        return prop
    end
end
