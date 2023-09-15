dasdingo_3__fire = class({})
LinkLuaModifier("dasdingo_3_modifier_passive", "heroes/dasdingo/dasdingo_3_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("dasdingo_3_modifier_fire", "heroes/dasdingo/dasdingo_3_modifier_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("dasdingo_3_modifier_ignition", "heroes/dasdingo/dasdingo_3_modifier_ignition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_movespeed_debuff", "_modifiers/_modifier_movespeed_debuff", LUA_MODIFIER_MOTION_NONE)

-- INIT

    function dasdingo_3__fire:CalcStatus(duration, caster, target)
        if caster == nil or target == nil then return duration end
        if IsValidEntity(caster) == false or IsValidEntity(target) == false then return duration end
        local base_stats = caster:FindAbilityByName("base_stats")

        if caster:GetTeamNumber() == target:GetTeamNumber() then
            if base_stats then duration = duration * (1 + base_stats:GetBuffAmp()) end
        else
            if base_stats then duration = duration * (1 + base_stats:GetDebuffAmp()) end
            duration = duration * (1 - target:GetStatusResistance())
        end
        
        return duration
    end

    function dasdingo_3__fire:AddBonus(string, target, const, percent, time)
        local base_stats = target:FindAbilityByName("base_stats")
        if base_stats then base_stats:AddBonusStat(self:GetCaster(), self, const, percent, time, string) end
    end

    function dasdingo_3__fire:RemoveBonus(string, target)
        local stringFormat = string.format("%s_modifier_stack", string)
        local mod = target:FindAllModifiersByName(stringFormat)
        for _,modifier in pairs(mod) do
            if modifier:GetAbility() == self then modifier:Destroy() end
        end
    end

    function dasdingo_3__fire:GetRank(upgrade)
        local caster = self:GetCaster()
		if caster:IsIllusion() then return end
		if caster:GetUnitName() ~= "npc_dota_hero_shadow_shaman" then return end

		local base_hero = caster:FindAbilityByName("base_hero")
        if base_hero then return base_hero.ranks[3][upgrade] end
    end

    function dasdingo_3__fire:OnUpgrade()
        local caster = self:GetCaster()
        if caster:IsIllusion() then return end
        if caster:GetUnitName() ~= "npc_dota_hero_shadow_shaman" then return end

        local base_hero = caster:FindAbilityByName("base_hero")
        if base_hero then
            base_hero.ranks[3][0] = true
            if self:GetLevel() == 1 then base_hero:CheckSkills(1, self) end
        end

        local charges = 1
        self:SetCurrentAbilityCharges(charges)
    end

    function dasdingo_3__fire:Spawn()
        self:SetCurrentAbilityCharges(0)
    end

-- SPELL START

    function dasdingo_3__fire:GetIntrinsicModifierName()
        return "dasdingo_3_modifier_passive"
    end

    function dasdingo_3__fire:GetManaCost(iLevel)
        local manacost = self:GetSpecialValueFor("manacost")
        local level = (1 + ((self:GetLevel() - 1) * 0.05))
        if self:GetCurrentAbilityCharges() == 0 then return 0 end
        return manacost * level
    end

    function dasdingo_3__fire:Explode(target, lines)
        local caster = self:GetCaster()
        local particle_line = "particles/dasdingo/requiem/dasdingo_requiemofsouls_line.vpcf"
        local line_length = 600
        local width_start = 50
        local width_end = 50
        local line_speed = 750

        local initial_angle_deg = target:GetAnglesAsVector().y
        local delta_angle = 360/lines
        for i=0,lines-1 do
            -- Determine velocity
            local facing_angle_deg = initial_angle_deg + delta_angle * i
            if facing_angle_deg>360 then facing_angle_deg = facing_angle_deg - 360 end
            local facing_angle = math.rad(facing_angle_deg)
            local facing_vector = Vector( math.cos(facing_angle), math.sin(facing_angle), 0 ):Normalized()
            local velocity = facing_vector * line_speed
    
            -- create projectile
            local info = {
                Source = caster,
                Ability = self,
                EffectName = particle_line,
                vSpawnOrigin = target:GetOrigin(),
                fDistance = line_length,
                vVelocity = velocity,
                fStartRadius = width_start,
                fEndRadius = width_end,
                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_SPELL_IMMUNE_ENEMIES,
                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                bReplaceExisting = false,
                bProvidesVision = false,
            }

            info.ExtraData = {source = target:entindex()}
            ProjectileManager:CreateLinearProjectile(info)

            -- Create the particle
            local particle_lines_fx = ParticleManager:CreateParticle(particle_line, PATTACH_ABSORIGIN, target)
            ParticleManager:SetParticleControl(particle_lines_fx, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_lines_fx, 1, velocity)
            ParticleManager:SetParticleControl(particle_lines_fx, 2, Vector(0, (line_length / line_speed), 0))
            ParticleManager:ReleaseParticleIndex(particle_lines_fx)
        end
    
        self:PlayEfxExplosion(target, lines)
    end

    function dasdingo_3__fire:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
        local source = EntIndexToHScript(ExtraData.source)
        if hTarget == nil then return end
        if hTarget == source then return end

        local caster = self:GetCaster()
        local damageTable = {
            victim = hTarget,
            attacker = caster,
            damage = 100,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }

        ApplyDamage(damageTable)
        if IsServer() then hTarget:EmitSound("Hero_Clinkz.SearingArrows.Impact") end
    end

-- EFFECTS

    function dasdingo_3__fire:PlayEfxExplosion(target, lines)
        local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
        local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(effect_cast, 1, Vector( lines, 0, 0 ))
        ParticleManager:SetParticleControlForward(effect_cast, 2, target:GetForwardVector())
        ParticleManager:ReleaseParticleIndex(effect_cast)

        if IsServer() then target:EmitSound("Ability.LightStrikeArray") end
    end