orb_bleed__status = class({})

function orb_bleed__status:IsHidden() return false end
function orb_bleed__status:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_bleed__status:OnCreated(kv)
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.caster = EntIndexToHScript(kv.inflictor)
  self.status_amount = {}
  self.status_degen = 4
  self.current_status = kv.status_amount

  self:UpdateStatusBar()
  self:AddEntityAmount(kv.inflictor, kv.status_amount)
  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(0.3)
end

function orb_bleed__status:OnRefresh(kv)
  if not IsServer() then return end

  self.caster = EntIndexToHScript(kv.inflictor)

  self:AddCurrentStatus(kv.status_amount)
  self:AddEntityAmount(kv.inflictor, kv.status_amount)
  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(0.3)
end

function orb_bleed__status:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_bleed__status:OnIntervalThink()
  if not IsServer() then return end

  local interval = 0.1
  local degen = self.status_degen * interval

  self:AddCurrentStatus(-degen)

  for ent_index, table in pairs(self.status_amount) do
    self:AddEntityAmount(ent_index, degen / #self.status_amount)
  end

  self:SetStackCount(math.floor(self.current_status))
  self:StartIntervalThink(interval)
end

-- UTILS -----------------------------------------------------------

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
  self.current_status = self.current_status + amount

  if self.current_status > self.max_status then self.current_status = self.max_status end
  if self.current_status < 0 then self.current_status = 0 end

  CustomGameEventManager:Send_ServerToAllClients("update_status_bar_state_from_server", {
    max_status = self.max_status,
    current_status = self.current_status,
    entity = self.parent:entindex()
  })

  if self.current_status <= 0 then
    self:Destroy()
  end
end

function orb_bleed__status:UpdateStatusBar()
  local old_max_status = self.max_status
  local max_status = 100

  local vit = self.parent:GetMainStat("VIT")
  if vit then max_status = vit:GetStatusBar() end

  if old_max_status == nil then
    if self.current_status > max_status then
      self.current_status = max_status
    end
  else
    local percent = self.current_status / old_max_status
    self.current_status = max_status * percent
  end

  self.max_status = max_status

  CustomGameEventManager:Send_ServerToAllClients("update_status_bar_state_from_server", {
    max_status = self.max_status,
    current_status = self.current_status,
    entity = self.parent:entindex()
  })
end


-- EFFECTS -----------------------------------------------------------