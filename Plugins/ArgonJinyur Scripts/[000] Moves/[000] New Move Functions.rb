
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
    @effect = PBEffects::HeatBunker
  end
  
  def healingMove?;       return true; end
  def pbHealAmount(user); return 1;    end
  def canSnatch?;         return true; end

  def pbMoveFailed?(user, targets)
  super
    if user.hp == user.totalhp
      @battle.pbDisplay(_INTL("{1}'s HP is full!", user.pbThis))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
  super
    amt = pbHealAmount(user)
    user.pbRecoverHP(amt)
    @battle.pbDisplay(_INTL("{1}'s HP was restored.", user.pbThis))
  end
  def pbHealAmount(user)
    return (user.totalhp / 4.0).round
end