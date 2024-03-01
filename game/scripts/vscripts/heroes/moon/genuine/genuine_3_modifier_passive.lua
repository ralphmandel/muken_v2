genuine_3_modifier_passive = class({})

function genuine_3_modifier_passive:IsHidden() return true end
function genuine_3_modifier_passive:IsPurgable() return false end
function genuine_3_modifier_passive:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_3_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function genuine_3_modifier_passive:OnRefresh(kv)
end

function genuine_3_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function genuine_3_modifier_passive:CheckState()
	local state = {
    [MODIFIER_STATE_STUNNED] = false,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = false,
	}

	return state
end

function genuine_3_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end

function genuine_3_modifier_passive:OnOrder(keys)
  if not IsServer() then return end

	if keys.unit ~= self.parent then return end
  if self.parent:HasModifier("genuine_3_modifier_travel") == false then return end

  if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION and self.ability.projectileData
  and self.ability:GetSpecialValueFor("special_move") == 1 and self.ability:IsCooldownReady() then
    local travelled_distance = (self.ability.projectileData.origin - self.ability.projectileData.location):Length2D()
    self.ability:DestroyOrb(false)
    self.ability:CreateOrb(keys.new_pos, travelled_distance, false)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------