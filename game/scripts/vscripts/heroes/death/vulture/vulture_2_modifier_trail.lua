vulture_2_modifier_trail = class({})

function vulture_2_modifier_trail:IsHidden() return false end
function vulture_2_modifier_trail:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function vulture_2_modifier_trail:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
    self:PlayEfxStart()
  end


end



function vulture_2_modifier_trail:OnRefresh(kv)
 
end

function vulture_2_modifier_trail:OnRemoved()

end

-- API FUNCTIONS -----------------------------------------------------------

function vulture_2_modifier_trail:OnIntervalThink()
 
end

function vulture_2_modifier_trail:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true,
	}

	return state
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function vulture_2_modifier_trail:PlayEfxStart()

end


-- function vulture_2_modifier_trail:GetEffectName()
-- 	return ""
-- end

-- function vulture_2_modifier_trail:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end