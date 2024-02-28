status_bar_curse_max = class({})

function status_bar_curse_max:IsHidden() return true end
function status_bar_curse_max:IsPurgable() return false end
function status_bar_curse_max:GetTexture() return "status_curse" end

-- CONSTRUCTORS -----------------------------------------------------------

function status_bar_curse_max:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.current_status = kv.time
  self.max_status = kv.time
  self.multiplier = kv.multiplier
  self.status_name = string.sub(self:GetName(), 1, -5)

  self.init_time = GameRules:GetGameTime()

  self.parent:AddSubStats(self.ability, {max_health_percent = -50, max_mana_percent = -50})

  self.parent:UpdatePanel({
    current_status = self.current_status * self.multiplier,
    max_status = self.max_status * self.multiplier,
    status_name = self.status_name,
    max_state = 1
  })

  self:PlayEfxStart()
  self:StartIntervalThink(0.1)
end

function status_bar_curse_max:OnRefresh(kv)
end

function status_bar_curse_max:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"max_health_percent", "max_mana_percent"})
  self.parent:RemoveStatusEfx(nil, nil, "status_bar_curse_max_efx")

  local status_modifier = self.parent:FindModifierByName("status_bar_curse")

  if status_modifier then
    status_modifier.bCompleted = nil
    status_modifier:OnIntervalThink()
  else
    self.parent:RemovePanelFromList(self.status_name)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function status_bar_curse_max:OnIntervalThink()
  if not IsServer() then return 0 end
  local diff = GameRules:GetGameTime() - self.init_time

  self.current_status = self.max_status - diff

  if self.current_status <= 0 then
    self:Destroy()
  else
    self.parent:UpdatePanel({
      current_status = self.current_status * self.multiplier,
      max_status = self.max_status * self.multiplier,
      status_name = self.status_name,
      max_state = 1
    })
  end

  self:StartIntervalThink(0.1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function status_bar_curse_max:GetEffectName()
	return "particles/vulture/rot/vulture_rot.vpcf"
end

function status_bar_curse_max:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function status_bar_curse_max:GetStatusEffectName()
  return "particles/econ/items/effigies/status_fx_effigies/status_effect_aghs_standard_statue.vpcf"
end

function status_bar_curse_max:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function status_bar_curse_max:PlayEfxStart()
  self.parent:AddStatusEfx(self.caster, self.ability, "status_bar_curse_max_efx")
	self.parent:EmitSound("Hero_ShadowDemon.ShadowPoison.Release")
end