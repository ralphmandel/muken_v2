trickster_1_modifier_passive = class({})

function trickster_1_modifier_passive:IsHidden() return true end
function trickster_1_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_1_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.doubled = false

  --self.time = GameRules:GetGameTime()
end

function trickster_1_modifier_passive:OnRefresh(kv)
end

function trickster_1_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_1_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function trickster_1_modifier_passive:OnAttackLanded(keys)
  if keys.attacker ~= self.parent then return end
  --print("kuboo", GameRules:GetGameTime() - self.time, self.parent:GetAttackAnimationPoint())
  --self.time = GameRules:GetGameTime()
  if self.doubled == true then self.doubled = false return end
  if self.parent:PassivesDisabled() then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("chance") then
    Timers:CreateTimer(0.2, function()
      self.parent:AttackNoEarlierThan((1 / (self.parent:GetAttacksPerSecond() + 0.5)) - 0.1, 1)
      self.doubled = true
      -- self.parent:FadeGesture(ACT_DOTA_ATTACK)
      -- self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 6)

      if self.parent:IsAlive() and self.parent:IsStunned() == false and self.parent:IsHexed() == false
      and self.parent:IsFrozen() == false and self.parent:IsOutOfGame() == false then
        if keys.target then
          if IsValidEntity(keys.target) then
            if keys.target:IsAlive() then
              MainStats(self.parent, "str"):SetForceCrit(0, nil)
              self.parent:PerformAttack(keys.target, false, true, true, false, false, false, true)
            end
          end
        end
      end
    end)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------