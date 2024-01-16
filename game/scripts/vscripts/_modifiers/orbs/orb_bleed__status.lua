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
  self.bloodloss = 500
  self.current_status = kv.status_amount

  self:CreatePanel()
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
  if not IsServer() then return end

  self.parent.worldPanel:Delete()
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

  local damage_result = ApplyDamage({
    attacker = attacker.unit, victim = self.parent, ability = nil,
    damage = self:GetBloodLoss(attacker.unit), damage_type = DAMAGE_TYPE_PURE,
    damage_flags = DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
  })

  self:PopupBleedDamage(math.floor(damage_result), self.parent)
  self:PlayEfxBloodLoss()
  self:Destroy()
end

function orb_bleed__status:GetBloodLoss(attacker)
  local result = CalcStatusDebuffAmp(self.bloodloss, attacker)
  result = CalcStatusResistance(result, self.parent)
  return result
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
  self.current_status = self.current_status + amount

  if self.current_status > self.max_status then
    self:ApplyBloodLoss()
    return
  end

  if self.current_status <= 0 then
    self:Destroy()
    return
  end

  self:UpdatePanel()
end

function orb_bleed__status:UpdateStatusBar()
  local old_max_status = self.max_status
  local max_status = 100

  local vit = self.parent:GetMainStat("VIT")
  if vit then max_status = vit:GetStatusBar() end

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
  self:UpdatePanel()
end

function orb_bleed__status:UpdatePanel(current_status)
  self.parent.worldPanel:SetData(
    {current_status = self.current_status, max_status = self.max_status},
    self.parent.hp_offset
  )
end

function orb_bleed__status:CreatePanel()
  self.parent.worldPanel = WorldPanels:CreateWorldPanelForAll({
    layout = "file://{resources}/layout/custom_game/worldpanels/muken_status_bar.xml",
    entity = self.parent:GetEntityIndex(),
    entityHeight = self.parent.hp_offset,
    offsetY = -50,
    data = {current_status = 0, max_status = 0}
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

	if IsServer() then self.parent:EmitSound("Generic.Bloodloss") end
end