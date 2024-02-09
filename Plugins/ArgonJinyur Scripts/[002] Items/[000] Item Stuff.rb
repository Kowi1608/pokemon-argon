Battle::PokeBallEffects::ModifyCatchRate.add(:PRIDEBALL, proc { |ball, catchRate, battle, battler|
  battle.allSameSideBattlers.each do |b|
    next if b.species != battler.species
    next if b.gender != battler.gender || b.gender == 2 || battler.gender == 2
    catchRate *= 8
    break
  end
  next [catchRate, 255].min
})