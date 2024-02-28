status_bar_curse = class({})

function status_bar_curse:IsHidden() return true end
function status_bar_curse:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function status_bar_curse:OnCreated(kv)
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.status_amount = {}
  self.status_degen = 2
  self.curse_duration = 7.5

  self.caster = EntIndexToHScript(kv.inflictor)
  self.current_status = kv.status_amount --self.caster:GetDebuffPower(kv.status_amount, self.parent)
  self.status_name = self:GetName()

  if self.parent:IsMagicImmune() then self.current_status = 1 end

  self:StartIntervalThink(0.1)
  self:AddEntityAmount(kv.inflictor, kv.status_amount)
  self:UpdateStatusBar()
end

function status_bar_curse:OnRefresh(kv)
  if not IsServer() then return end

  self.caster = EntIndexToHScript(kv.inflictor)

  self:AddEntityAmount(kv.inflictor, kv.status_amount)
  self:AddCurrentStatus(kv.status_amount)
end

function status_bar_curse:OnRemoved()
  if not IsServer() then return end

  if self.bCompleted == nil then
    self.parent:RemovePanelFromList(self.status_name)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function status_bar_curse:OnIntervalThink()
  if not IsServer() then return end

  local interval = 0.1

  self:ReduceAmount(self.status_degen * interval)
  self:StartIntervalThink(interval)
end

-- UTILS -----------------------------------------------------------

function status_bar_curse:ReduceAmount(amount)
  for ent_index, table in pairs(self.status_amount) do
    self:AddEntityAmount(ent_index, amount / #self.status_amount)
  end

  self:AddCurrentStatus(-amount)
end

function status_bar_curse:ApplyCurseState()
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

  self.current_status = self.current_status - self.max_status

  self:StartIntervalThink(-1)

  self.bCompleted = self.parent:AddNewModifier(attacker.unit, self.ability, "status_bar_curse_max", {
    time = attacker.unit:GetDebuffPower(self.curse_duration, nil),
    multiplier = 100 / self.curse_duration
  })

  if self.current_status <= 0 then self:Destroy() end
end

function status_bar_curse:AddEntityAmount(ent_index, amount)
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

function status_bar_curse:AddCurrentStatus(amount)
  if self.parent:IsMagicImmune() and amount > 0 then amount = 0 end
  self.current_status = self.current_status + amount

  print("K2", self.current_status)

  if self.current_status > self.max_status then
    self:ApplyCurseState()
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

function status_bar_curse:UpdateStatusBar()
  local old_max_status = self.max_status
  self.max_status = self.parent:GetResistance(self.status_name)

  print("K1", self.current_status)

  if old_max_status == nil then
    if self.current_status > self.max_status then
      self:ApplyCurseState()
      return
    end
  else
    local percent = self.current_status / old_max_status
    self.current_status = self.max_status * percent
  end

  self.parent:UpdatePanel({
    current_status = self.current_status,
    max_status = self.max_status,
    status_name = self.status_name,
    entities = self.status_amount,
    max_state = 0
  })
end

-- EFFECTS -----------------------------------------------------------