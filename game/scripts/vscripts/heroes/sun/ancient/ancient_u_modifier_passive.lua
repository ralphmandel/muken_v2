ancient_u_modifier_passive = class({})

function ancient_u_modifier_passive:IsHidden() return true end
function ancient_u_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_u_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

	if IsServer() then
    self:PlayEfxBuff()
		self:OnIntervalThink()
    CustomGameEventManager:Send_ServerToAllClients("update_bar_from_lua", BaseHero(self.parent):GetProgressBarInfo())
	end
end

function ancient_u_modifier_passive:OnRefresh(kv)
end

function ancient_u_modifier_passive:OnRemoved()
  if IsServer() then
    CustomGameEventManager:Send_ServerToAllClients("update_bar_from_lua", BaseHero(self.parent):GetProgressBarInfo())
	end
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_u_modifier_passive:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function ancient_u_modifier_passive:OnTakeDamage(keys)
  --if GetHeroName(self.parent) == "trickster" then return end
	if self.parent:PassivesDisabled() then return end

  if keys.inflictor == self.ability and keys.unit:IsAlive() == false
  and keys.unit:GetTeamNumber() ~= self.parent:GetTeamNumber()
  and keys.unit:IsHero() and keys.unit:IsIllusion() == false then
    self.parent:Heal(keys.damage * self.ability:GetSpecialValueFor("special_heal") * 0.01, self.ability)
  end

  if (keys.attacker == self.parent and keys.damage_type == DAMAGE_TYPE_PHYSICAL)
  or keys.unit == self.parent then
    local gain = keys.damage * self.ability:GetSpecialValueFor("energy_gain") * 0.01
    IncreaseMana(self.parent, gain)
    self.ability:UpdateParticles()
  end
end

function ancient_u_modifier_passive:OnIntervalThink()
  self.ability:UpdateParticles()

  -- if GetHeroName(self.parent) == "trickster" then
  --   if IsServer() then self:StartIntervalThink(0.1) end
  --   return
  -- end

  ReduceMana(self.parent, self.ability, 1, false)

	if IsServer() then self:StartIntervalThink(self.ability:GetSpecialValueFor("energy_loss_tick")) end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function ancient_u_modifier_passive:PlayEfxBuff()
	if self.ambient_aura then ParticleManager:DestroyParticle(self.ambient_aura, false) end
	self.ambient_aura = ParticleManager:CreateParticle("particles/ancient/ancient_aura_alt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.ambient_aura, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(self.ambient_aura, 1, Vector(0, 0, 0))
	self:AddParticle(self.ambient_aura, false, false, -1, false, false)
end

function ancient_u_modifier_passive:UpdateAmbients()
	if Cosmetics(self.parent) == nil then return end
	local ambient_back = Cosmetics(self.parent):GetAmbient("particles/ancient/ancient_back.vpcf")
	local ambient_weapon = Cosmetics(self.parent):GetAmbient("particles/ancient/ancient_weapon.vpcf")

	local value = self.parent:GetMana() * 0.7
	if self.ability.casting == true then value = 0 end

	if self.ambient_aura then ParticleManager:SetParticleControl(self.ambient_aura, 1, Vector(value, 0, 0)) end
	if ambient_back then ParticleManager:SetParticleControl(ambient_back, 20, Vector(value, 0, 0)) end
	if ambient_weapon then
		ParticleManager:SetParticleControl(ambient_weapon, 20, Vector(value, 30, 12))
		ParticleManager:SetParticleControl(ambient_weapon, 21, Vector(value * 0.01, 0, 0))
	end
end