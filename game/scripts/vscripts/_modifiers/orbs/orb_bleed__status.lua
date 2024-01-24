orb_bleed__status = class({})

function orb_bleed__status:IsHidden() return true end
function orb_bleed__status:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_bleed__status:OnCreated(kv)
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.status_amount = {}
  self.status_degen = 4
  self.bloodloss = 500

  self.caster = EntIndexToHScript(kv.inflictor)
  self.current_status = self.caster:GetDebuffPower(kv.status_amount, self.parent)
  self.status_name = string.sub(self:GetName(), 5, string.len(self:GetName()))

  if self.parent:IsMagicImmune() then self.current_status = 1 end

  self:AddEntityAmount(kv.inflictor, kv.status_amount)
  self:UpdateStatusBar()
  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(1)
end

function orb_bleed__status:OnRefresh(kv)
  if not IsServer() then return end

  self.caster = EntIndexToHScript(kv.inflictor)
  local added_amount = self.caster:GetDebuffPower(kv.status_amount, self.parent)

  self:AddEntityAmount(kv.inflictor, added_amount)
  self:AddCurrentStatus(added_amount)
  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(1)
end

function orb_bleed__status:OnRemoved()
  if not IsServer() then return end

  self.parent:RemovePanelFromList(self.status_name)
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_bleed__status:OnIntervalThink()
  if not IsServer() then return end

  local interval = 0.1
  
  self:ReduceAmount(self.status_degen * interval)
  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(interval)
end

-- UTILS -----------------------------------------------------------

function orb_bleed__status:ReduceAmount(amount)
  for ent_index, table in pairs(self.status_amount) do
    self:AddEntityAmount(ent_index, amount / #self.status_amount)
  end

  self:AddCurrentStatus(-amount)
end

function orb_bleed__status:ApplyBloodLoss()
  local attacker = {unit = nil, amount = 0}

  for ent_index, table in pairs(self.status_amount) do
    local unit = EntIndexToHScript(ent_index)
    if IsValidEntity(unit) then
      if unit:GetTeamNumber() == self.caster:GetTeamNumber() then
        if table.status_amount > attacker.amount then
          attacker.unit = unit
          attacker.amount = table.status_amount
        end
      end
    end
  end

  if attacker.unit == nil then return end

  self.parent:RemoveAllModifiersOfName("orb_bleed_debuff")

  local damage_result = ApplyDamage({
    attacker = attacker.unit, victim = self.parent, ability = nil,
    damage = attacker.unit:GetDebuffPower(self.bloodloss, nil), damage_type = DAMAGE_TYPE_PURE,
    damage_flags = DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
  })

  CallBloodLoss(damage_result, attacker.unit, self.parent)

  self:PopupBleedDamage(damage_result, self.parent)
  self:PlayEfxBloodLoss()
  self:Destroy()
end

function orb_bleed__status:AddEntityAmount(ent_index, amount)
  if IsValidEntity(EntIndexToHScript(ent_index)) == false then
    self.status_amount[ent_index] = nil
    return
  end

  if self.status_amount[ent_index] then
    self.status_amount[ent_index].status_amount = self.status_amount[ent_index].status_amount + amount
    if self.status_amount[ent_index].status_amount <= 0 then
      self.status_amount[ent_index] = nil
    end
  else
    if amount > 0 then
      self.status_amount[ent_index] = {status_amount = amount}
    end
  end
end

function orb_bleed__status:AddCurrentStatus(amount)
  if self.parent:IsMagicImmune() and amount > 0 then amount = 0 end
  self.current_status = self.current_status + amount

  if self.current_status > self.max_status then
    self:ApplyBloodLoss()
    return
  end

  if self.current_status <= 0 then
    self:Destroy()
    return
  end

  self.parent:UpdatePanel({
    current_status = self.current_status,
    max_status = self.max_status,
    status_name = self.status_name,
    entities = self.status_amount,
    max_state = 0
  })
end

function orb_bleed__status:UpdateStatusBar()
  local old_max_status = self.max_status
  local max_status = self.parent:GetResistance(self.status_name)

  if old_max_status == nil then
    if self.current_status > max_status then
      self:ApplyBloodLoss()
      return
    end
  else
    local percent = self.current_status / old_max_status
    self.current_status = max_status * percent
  end

  self.max_status = max_status
  self.parent:UpdatePanel({
    current_status = self.current_status,
    max_status = self.max_status,
    status_name = self.status_name,
    entities = self.status_amount,
    max_state = 0
  })
end

-- EFFECTS -----------------------------------------------------------

function orb_bleed__status:PlayEfxBloodLoss()
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast, 1, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect_cast)

  local particle_cast2 = "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf"
	local effect_cast2 = ParticleManager:CreateParticle(particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast2, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_cast2, 1, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect_cast2)

	self.parent:EmitSound("Generic.Bloodloss")
end