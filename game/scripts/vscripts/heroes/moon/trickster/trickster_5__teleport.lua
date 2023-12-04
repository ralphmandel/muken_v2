trickster_5__teleport = class({})
LinkLuaModifier("trickster_5_modifier_teleport", "heroes/moon/trickster/trickster_5_modifier_teleport", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function trickster_5__teleport:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
    local point = Vector(RandomInt(-3200, 3200), RandomInt(-3200, 3200), 0)

    if target:TriggerSpellAbsorb(self) then return end

    if IsServer() then caster:EmitSound("Trickster.Teleport") end

    caster:AttackNoEarlierThan(0.47, 20)
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)

    local caster_point = point + RandomVector(50)
    local direction = (point - caster_point):Normalized()
    local target_point = caster_point + (point - caster_point):Normalized() * 100

    FindClearSpaceForUnit(caster, caster_point, true)
    FindClearSpaceForUnit(target, target_point, true)

    caster:SetForwardVector(direction)

		if caster:GetPlayerOwnerID() then CenterCameraOnUnit(caster:GetPlayerOwnerID(), caster) end
		if target:GetPlayerOwnerID() then CenterCameraOnUnit(target:GetPlayerOwnerID(), target) end

    if IsServer() then target:EmitSound("Trickster.Teleport") end
	end

-- EFFECTS