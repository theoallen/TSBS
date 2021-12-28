#===============================================================================
# * TSBS Addon
# Reaction Counterattack
#-------------------------------------------------------------------------------
# The counterattack happens after the attacker finished their action
#
# How to use:
# Set the counter skill (replace n with skill ID)
# <counter skill: n>
#
# This will make the counterattacker use the skill when counterattacking
#===============================================================================
class Scene_Battle
  def tsbs_invoke_item(target, item, subj = @subject)
    return if item.nil?
    if rand < target.item_mrf(subj, item)
      tsbs_invoke_mreflect(target, item)
    else
      tsbs_apply_item(tsbs_apply_substitute(target, item, subj), item, subj)
    end
  end
  
  def tsbs_action_post(targets, item, subj)
    # Determine if item has no return sequence
    subj.break_action = false if subj.break_action
    unless item.no_return? || subj.battle_phase == :forced
      subj.battle_phase = :return 
    else
      subj.battle_phase = :idle
    end
    wait_for_sequence
    
    trigger_reaction(targets, item, subj)
  end
  
  def trigger_reaction(targets, item, subj)
    targets.each do |t|
      @damage.reset_value
      if t.trigger_counter(item, subj)
        wait_for_skill_sequence
        t.battle_phase = :return 
        wait_for_sequence
      end
    end
  end
  
end

class Game_Battler
  
  def trigger_counter(item, subj)
    return false unless item_cnt(subj, item) > rand
    self.target_array = [subj]
    self.target = subj
    self.item_in_use = copy($data_skills[data_battler.counter_skill])
    self.battle_phase = :skill
    return true
  end
  
  def item_cnt(user, item)
    return 0 unless has_counterskill?
    return 0 if restriction == 4
    return 0 if item.anti_counter? || covering || dead?
    return 1 if user.force_counter && self.cnt > 0
    tsbs_counter(user, item)
  end
  
  def has_counterskill?
    data_battler.counter_skill > 0
  end
  
end
