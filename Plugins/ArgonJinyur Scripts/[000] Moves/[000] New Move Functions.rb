
#===============================================================================
# Flush Fang
#===============================================================================
# Removes Target Item, x1.5 Damage when doing so. May Flinch
#-------------------------------------------------------------------------------
class Battle::Move::RemoveTargetItemAndFlinch < Battle::Move::RemoveTargetItem
  def flinchingMove?; return true; end
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target, 10)
    return if chance == 0
    target.pbFlinch(user) if @battle.pbRandom(100) < chance
  end
end

#===============================================================================
# Crab Rave
#===============================================================================
# Increases the user's Attack, Accuracy and Speed by 1 stage each.
#-------------------------------------------------------------------------------
class Battle::Move::RaiseUserAtkAccSpd1 < Battle::Move::MultiStatUpMove
  def initialize(battle, move)
    super
    @statUp = [:ATTACK, 1, :ACCURACY, 1, :SPEED, 1]
  end
end

#===============================================================================
# Petal Wind
#===============================================================================
# User switches out and flinches if they are faster.
#-------------------------------------------------------------------------------
class Battle::Move::FlinchSwitchOutUserDamagingMove < Battle::Move::SwitchOutUserDamagingMove
def flinchingMove?; return true; end
  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbFlinch(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbFlinch(user)
  end
end

#===============================================================================
# Heat Bunker
#===============================================================================
# Protects User this turn, burns on physical contact, recovers 1/4 HP
#-------------------------------------------------------------------------------
class Battle::Move::ProtectUserHeatBunker < Battle::Move::ProtectMove
 def initialize(battle, move)
   super
#@effect = PBEffects::BurningBulwark
 end

  def pbChangeUsageCounters(user, specialUsage)
    oldVal = user.effects[PBEffects::ProtectRate]
    super
    user.effects[PBEffects::ProtectRate] = oldVal
  end
  def healingMove?;       return true; end
 # def pbHealAmount(user); return 1;    end
  def canSnatch?;         return true; end

  def pbMoveFailed?(user, targets)
    if @sidedEffect
      if user.pbOwnSide.effects[@effect]
        user.effects[PBEffects::ProtectRate] = 1
        @battle.pbDisplay(_INTL("But it failed!"))
        return true
      end
    elsif user.effects[@effect]
      user.effects[PBEffects::ProtectRate] = 1
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if (!@sidedEffect || Settings::MECHANICS_GENERATION <= 5) &&
       user.effects[PBEffects::ProtectRate] > 1 &&
       @battle.pbRandom(user.effects[PBEffects::ProtectRate]) != 0
      user.effects[PBEffects::ProtectRate] = 1
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if pbMoveFailedLastInRound?(user)
      user.effects[PBEffects::ProtectRate] = 1
      return true
    end
    return false
    if user.hp == user.totalhp
      @battle.pbDisplay(_INTL("{1}'s HP is full!", user.pbThis))
      return true
    end
	return false
  end
  
  def pbHealAmount(user)
    return (user.totalhp / 4.0).round
end
  
#	amt = pbHealAmount(user)
 #  user.pbRecoverHP(amt)
 #   @battle.pbDisplay(_INTL("{1}'s HP was restored.", user.pbThis))
	
  # return false

  def pbAdditionalEffect(user, target)

    return if chance == 0
	if @battle.pbRandom(100) < chance
    @effect = PBEffects::BurningBulwark 
	
end
end

 def pbEffectGeneral(user)
    if @sidedEffect
      user.pbOwnSide.effects[@effect] = true
    else
      user.effects[@effect] = true
    end
    user.effects[PBEffects::ProtectRate] *= (Settings::MECHANICS_GENERATION >= 6) ? 3 : 2
    pbProtectMessage(user)
	 amt = pbHealAmount(user)
    user.pbRecoverHP(amt)
   @battle.pbDisplay(_INTL("{1}'s HP was restored.", user.pbThis))
 end

end
#===============================================================================
# Dry Ice
#===============================================================================
# Causes Frostbite
#-------------------------------------------------------------------------------
class Battle::Move::FrostbiteTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanFrostbite?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbFrostbite(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbFrostbite(user) if target.pbCanFrostbite?(user, false, self)
  end
end

#===============================================================================
# Coin Hurl
#===============================================================================
# Payday+if user is from Meowth Line, Type is Meowth Type
#-------------------------------------------------------------------------------
class Battle::Move::TypeIsUserFistTypeAwardMoney < Battle::Move::AddMoneyGainedFromBattle
  def pbBaseType(user)
  userIsMeowth=false
  if user.isSpecies?(:MEOWTH) || user.isSpecies?(:PERSIAN) || user.isSpecies?(:PERRSERKER)
	userIsMeowth=true
	end
    return @type if userIsMeowth == false
    userTypes = user.pokemon.types
	
    return userTypes[1] || userTypes[0] || @type

  end
 
   def pbBaseDamage(baseDmg, user, target)
   #hardcoding chance for now
   chance = 50
   if @battle.pbRandom(100) < chance

      baseDmg = (baseDmg * 1.5).round 
    end
    return baseDmg
 end
 #i dont care about anims and frankly idk what this actually affects here
 # def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
#	case pbBaseType(user)
#	when :FIGHTING then hitNum = 1
#	when :FIRE     then hitNum = 2
#	when :WATER    then hitNum = 3
#	else                hitNum = 0
#	end
 #   super
  #end
end

