local def = 
{
	run = 500,
	walk = 250,
	step = 18,
	jump = 200,
	
	view = Vector(0,0,64),
	viewducked = Vector(0,0,28),	
	mass = 85,
	
	min = Vector(-16, -16, 0),
	max = Vector(16, 16, 72),
	maxduck = Vector(16, 16, 36),
}

function pac.SetPlayerSize(ply, f)	
	--local TICKRATE = SERVER and 1/FrameTime() or 0
	
	if not ply.SetViewOffset then return end
	
	ply:SetViewOffset(def.view * f)
	ply:SetViewOffsetDucked(def.viewducked * f)
	
	--[[
	ply:SetModelScale(f, 0)
	
	ply:SetRunSpeed(math.max(def.run * f, TICKRATE/2))
	ply:SetWalkSpeed(math.max(def.walk * f, TICKRATE/4))
	
	ply:SetStepSize(def.step * f)
	
	ply:SetHull(def.min * f, def.max * f * (f > 1 and 0.5 or f < 1 and 1 or 1))
	ply:SetHullDuck(def.min * f, def.maxduck * f * (f > 1 and 1.25 or f < 1 and 1.5 or 1))
	
	local phys = ply:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(def.mass * f)	
	end
	

	hook.Add("UpdateAnimation", "pac_scale", function(ply, vel, max)
		if ply.pac_player_size and ply.pac_player_size ~= 1 then
			if 
				ply:GetModelScale() ~= ply.pac_player_size or
				ply:GetViewOffset() ~= def.view * ply.pac_player_size or
				ply:GetRunSpeed() ~= math.max(def.run *  ply.pac_player_size, TICKRATE/2) or
				ply:GetWalkSpeed() ~= math.max(def.walk *  ply.pac_player_size, TICKRATE/4)
			then
				pac.SetPlayerSize(ply, ply.pac_player_size)
			end
		
			ply:SetPlaybackRate(1 / ply.pac_player_size)
			return true
		end
	end)
	]]
	
	if SERVER then
		hook.Add("Think", "pac_check_scale", function()
			for key, ply in pairs(player.GetAll()) do 
				if ply.pac_player_size and ply.pac_player_size ~= 1 then
					if ply:GetViewOffset() ~= def.view * ply.pac_player_size then
						pac.SetPlayerSize(ply, ply.pac_player_size)
					end
				end
			end
		end)
	end
	
	if CLIENT and ply == LocalPlayer() then
		hook.Add("Think", "pac_check_scale", function()
			local ply = LocalPlayer()
			if ply.pac_player_size and ply.pac_player_size ~= 1 then
				if ply:GetViewOffset() ~= def.view * ply.pac_player_size then
					pac.SetPlayerSize(ply, ply.pac_player_size)
				end
			end
		end)
	end
	
	ply.pac_player_size = f
end