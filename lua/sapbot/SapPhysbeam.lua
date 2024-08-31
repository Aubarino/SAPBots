AddCSLuaFile()

local physbeama = Material("sprites/physbeama")
local physg_glow1 = Material("sprites/physg_glow1")
local physg_glow2 = Material("sprites/physg_glow2")

local num = 2
local frac = 1 / (num - 1)

local function DrawBeam(pos1, tangent, pos2, color)
	--color = color:ToColor()
    print("test1111111111")

	local time = CurTime()
	for j = 1, 4 do
		local w = math.random() * 4
		local t = (time + j) % 4 / 4
		render.SetMaterial(physbeama)
		render.StartBeam(num)
		for i = 0, num - 1 do
			render.AddBeam(math.QuadraticBezier(frac * i, pos1, tangent, pos2), w, t, color)
		end
		render.EndBeam()

		local s = math.random() * 8
		render.SetMaterial(physg_glow1)
		render.DrawSprite(pos2, s, s, color)

		s = math.random() * 8
		render.SetMaterial(physg_glow2)
		render.DrawSprite(pos2, s, s, color)
	end
end

-- local function FormatViewModelAttachment(origin, from)
-- 	local view = render.GetViewSetup()

-- 	local eyePos = view.origin
-- 	local eyesRot = view.angles
-- 	local offset = origin - eyePos
-- 	local forward = eyesRot:Forward()

-- 	local viewX = math.tan(view.fovviewmodel_unscaled * math.pi / 360)

-- 	if viewX == 0 then
-- 		forward:Mul(forward:Dot(offset))
-- 		eyePos:Add(forward)
-- 		return eyePos
-- 	end

-- 	local worldX = math.tan(view.fov_unscaled * math.pi / 360)

-- 	if worldX == 0 then
-- 		forward:Mul(forward:Dot(offset))
-- 		eyePos:Add(forward)
-- 		return eyePos
-- 	end

-- 	local right = eyesRot:Right()
-- 	local up = eyesRot:Up()

-- 	local factor = from and worldX / viewX or viewX / worldX

-- 	right:Mul(right:Dot(offset) * factor)
-- 	up:Mul(up:Dot(offset) * factor)
-- 	forward:Mul(forward:Dot(offset))

-- 	eyePos:Add(right)
-- 	eyePos:Add(up)
-- 	eyePos:Add(forward)

-- 	return eyePos
-- end

hook.Add("PreDrawEffects", "SapsPhysgun", function()
    if (_SAPBOTS != nil) then
        for _, ply in pairs(_SAPBOTS) do
            if (IsValid(ply) and ply != nil) then
                local rawrenderpos = ply:GetPos()
                local CurEnt = ply:GetNW2Entity("CurrentWeapon_",nil)

                local wep = ply:GetActiveWeapon()
                if (!ply:GetNW2Bool("HoldingProp_",false)) then continue end
                --if (CurEnt == nil || !IsValid(CurEnt)) then continue end
                --print(CurEnt:GetClass())
                --if (CurEnt:GetClass() != "weapon_sapphysgun") then continue end
                --print("test2")

                local ent = ply:GetNW2Vector("HoldingPropEnt_",Vector(0,0,0))
                
                --if ent == nil then continue end

                --local ent = ply.CurrentWeapon:GetGrabbedEnt()

                local bone = 0
                local lpos = Vector(0,0,0)

                --if hook.Run("DrawPhysgunBeam", ply, CurEnt, true, nil, bone, lpos) == false then continue end

                local obj = CurEnt:LookupAttachment("core")
                --if obj < 1 then continue end

                local pos1 = ply:GetHeadHeightVector() + ply:GetPos()

                --local tangent = pos1 + ply:GetAimVector() * ply.CurrentWeapon:GetGrabbedDist() / 2
                local tangent = Vector(0,0,0)

                -- local pos2
                -- if bone == 0 then
                --     pos2 = LocalToWorld(lpos, Angle(), ent, Angle(0,0,0))
                -- else
                --     --local matrix = ent:GetBoneMatrix(bone) or Matrix()
                --     --pos2 = LocalToWorld(lpos, Angle(), matrix:GetTranslation(), matrix:GetAngles())
                -- end

                DrawBeam(pos1, tangent, ent, SAPBOTCOLOR)
            end
        end
    end
end)

-- hook.Add("HUDShouldDraw", "SapsPhysgun", function(name)
-- 	if name ~= "CHudWeaponSelection" then return end

-- 	local wep = LocalPlayer():GetActiveWeapon()
-- 	if not wep:IsValid() or wep:GetClass() ~= "weapon_newtphysgun" then return end

-- 	if not wep.GetFiring or not wep:GetFiring() then return end

-- 	return false
-- end)
