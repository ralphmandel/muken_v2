_modifier_force_attack = class({})

function _modifier_force_attack:IsPurgable() return false end
function _modifier_force_attack:IsHidden() return false end
function _modifier_force_attack:GetTexture() return "_modifier_force_attack" end
function _modifier_force_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function _modifier_force_attack:OnCreated(kv)
  if not IsServer() then return end

  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.target = EntIndexToHScript(kv.target)
  self.parent:SetForceAttackTarget(self.target)
end

function _modifier_force_attack:OnRefresh(kv)
end

function _modifier_force_attack:OnRemoved(kv)
  if not IsServer() then return end

  local data = {}
  local modifiers = self.parent:FindAllModifiersByName(self:GetName())

  for _,modifier in pairs(modifiers) do
    if modifier.target then
      if IsValidEntity(modifier.target) then
        if data.time then
          if modifier:GetCreationTime() > data.time then
            data.target = modifier.target
            data.time = modifier:GetCreationTime()
          end
        end
      end
    end
  end

  self.parent:SetForceAttackTarget(data.target)
end

--------------------------------------------------------------------------------

function _modifier_force_attack:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

--------------------------------------------------------------------------------
