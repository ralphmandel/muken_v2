orb_ice__status = class({})

function orb_ice__status:IsHidden() return false end
function orb_ice__status:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_ice__status:OnCreated(kv)
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.caster = EntIndexToHScript(kv.inflictor)
  self.status_amount = {}
  self.status_degen = 4
  self.bloodloss = 500
  self.current_status = kv.status_amount

  self:AddEntityAmount(kv.inflictor, kv.status_amount)
  self:UpdateStatusBar()
  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(1)

  AddStatusEfx(nil, "orb_ice__status_efx", self.caster, self.parent)
end

function orb_ice__status:OnRefresh(kv)
  if not IsServer() then return end

  self.caster = EntIndexToHScript(kv.inflictor)

  self:AddEntityAmount(kv.inflictor, kv.status_amount)
  self:AddCurrentStatus(kv.status_amount)
  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(1)
end

function orb_ice__status:OnRemoved()
  if not IsServer() then return end

  self.parent:RemovePanelFromList(self:GetName())

  RemoveStatusEfx(nil, "orb_ice__status_efx", self.caster, self.parent)
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_ice__status:OnIntervalThink()
  if not IsServer() then return end

  local interval = 0.1
  local degen = self.status_degen * interval

  for ent_index, table in pairs(self.status_amount) do
    self:AddEntityAmount(ent_index, degen / #self.status_amount)
  end

  self:AddCurrentStatus(-degen)

  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(interval)
end

-- UTILS -----------------------------------------------------------

function orb_ice__status:ApplyFrozenState()
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

  self.parent:RemoveAllModifiersOfName("orb_ice_debuff")

  self:Destroy()
end

function orb_ice__status:AddEntityAmount(ent_index, amount)
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

function orb_ice__status:AddCurrentStatus(amount)
  self.current_status = self.current_status + amount

  if self.current_status > self.max_status then
    self:ApplyFrozenState()
    return
  end

  if self.current_status <= 0 then
    self:Destroy()
    return
  end

  self.parent:UpdatePanel({
    current_status = self.current_status,
    max_status = self.max_status,
    status_name = self:GetName(),
    entities = self.status_amount
  })
end

function orb_ice__status:UpdateStatusBar()
  local old_max_status = self.max_status
  local max_status = 100

  local vit = self.parent:GetMainStat("VIT")
  if vit then max_status = vit:GetStatusBar() end

  if old_max_status == nil then
    if self.current_status > max_status then
      self:ApplyFrozenState()
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
    status_name = self:GetName(),
    entities = self.status_amount
  })
end

-- EFFECTS -----------------------------------------------------------

function orb_ice__status:GetStatusEffectName()
	return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function orb_ice__status:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end