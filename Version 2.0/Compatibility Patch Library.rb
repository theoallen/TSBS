#===============================================================================
# TSBS v2.0 Compatibility Patch Library
#-------------------------------------------------------------------------------
#===============================================================================
class Scene_Battle
  #-----------------------------------------
  # YEA - Active Chain Skill
  #-----------------------------------------
  def show_action_sequences(targets, item, subj)
    tsbs_action_init(targets, item, subj)
    tsbs_action_pre(targets, item, subj)
    tsbs_action_main(targets, item, subj)
    unless $imported["YEA-ActiveChainSkills"] && @active_chain_skill &&
        @active_chain_skill > 0
      tsbs_action_post(targets, item, subj)
      tsbs_action_end(targets, item, subj)
      $game_temp.backdrop.reset_transition_flags
      wait(tsbs_wait_dur)
    end
  end
  
  #-----------------------------------------
  # YEA - Skill Steal patch
  #-----------------------------------------
  if $imported["YEA-SkillSteal"]
  alias tsbs_skill_steal_apply_item tsbs_apply_item
  def tsbs_apply_item(target, item, subj = @subject)
    tsbs_skill_steal_apply_item(target, item, subj)
    tsbs_skill_steal(target, item, subj)
  end
  
  def tsbs_skill_steal(target, item, subj)
    return unless item.skill_steal
    return if target.actor?
    return unless subj.actor?
    for skill in target.stealable_skills
      next if subj.skill_learn?(skill)
      @subject.learn_skill(skill.id)
      string = YEA::SKILL_STEAL::MSG_SKILL_STEAL
      skill_text = sprintf("\\i[%d]%s", skill.icon_index, skill.name)
      text = sprintf(string, @subject.name, skill_text, target.name)
      @stolen_skills << text
    end
  end
  
  alias tsbs_skill_steal_action_init tsbs_action_init
  def tsbs_action_init(targets, item, subj)
    tsbs_skill_steal_action_init(targets, item, subj)
    @stolen_skills = []
  end
  
  alias tsbs_skill_steal_action_end tsbs_action_end
  def tsbs_action_end(targets, item, subj)
    tsbs_skill_steal_action_end(targets, item, subj)
    @stolen_skills.each do |text_skill|
      @log_window.add_text(text_skill)
      YEA::SKILL_STEAL::MSG_DURATION.times { tsbs_wait_update }
      @log_window.back_one
    end
  end
  end # YEA SKILL STEAL
  
  #-----------------------------------------
  # YEA - Command Equip
  #-----------------------------------------
  if $imported["YEA-CommandEquip"]
  alias tsbs_command_equip command_equip
  def command_equip
    tsbs_command_equip
    $game_party.battle_members[@status_window.index].battle_phase = :idle
  end
  end # YEA COMMAND EQUIP
  
  #-----------------------------------------
  # YEA - Steal Item patch
  #-----------------------------------------
  if $imported["YEA-StealItems"]
  alias tsbs_steal_item_apply_item tsbs_apply_item
  def tsbs_apply_item(target, item, subj = @subject)
    tsbs_steal_item_apply_item(target, item, subj)
    tsbs_apply_steal_results(target, item, subj)
  end
  
  def tsbs_apply_steal_results(target, item, subj)
    return if target.actor?
    return if item.steal_type.nil?
    if target.stealable_items.empty?
      fmt = YEA::STEAL::STEAL_EMPTY_TEXT
      text = sprintf(fmt, target.name)
    elsif target.result.stolen_item.nil?
      fmt = YEA::STEAL::STEAL_FAIL_TEXT
      text = sprintf(fmt, subj.name)
    else
      fmt = YEA::STEAL::STEAL_SUCCESS_TEXT
      actor = subj.name
      item = stolen_item_text(target)
      enemy = target.name
      text = sprintf(fmt, actor, item, enemy)
    end
    @stolen_items << text
  end
  
  alias tsbs_steal_item_action_init tsbs_action_init
  def tsbs_action_init(targets, item, subj)
    tsbs_steal_item_action_init(targets, item, subj)
    @stolen_items = []
  end
  
  alias tsbs_steal_item_action_end tsbs_action_end
  def tsbs_action_end(targets, item, subj)
    tsbs_steal_item_action_end(targets, item, subj)
    @stolen_items.each do |text_item|
      @log_window.add_text(text_item)
      60.times { tsbs_wait_update }
      @log_window.back_one
    end
  end
  end # YEA STEAL ITEM

  #-----------------------------------------
  # YEA - Battle Engine
  #-----------------------------------------
  if $imported["YEA-BattleEngine"]
  # Overwrite heal party
  def debug_heal_party
    Sound.tsbs_play_recovery
    for member in $game_party.battle_members
      member.recover_all
    end
    @status_window.refresh
  end
  # Overwrite fill TP
  def debug_fill_tp
    Sound.tsbs_play_recovery
    for member in $game_party.alive_members
      member.tp = member.max_tp
    end
    @status_window.refresh
  end
  end # YEA Battle Engine

end

# YEA COMMAND PARTY
if $imported["YEA-CommandParty"]
class Game_Party
  alias tsbs_set_party_cooldown set_party_cooldown
  def set_party_cooldown
    tsbs_set_party_cooldown
    battle_members.each do |m|
      m.init_oripost
      m.setup_instant_reset
      m.sprite.start_effect(:appear)
    end
  end
end
end # YEA COMMAND PARTY

# LUNA ENGINE PATCH
if defined?(Sprite_PopupLuna)
class Sprite_PopupLuna < Sprite
  
  # Make alias name and delete the update_move 
  alias update_move_luna update_move
  def update_move
  end
  
  # Overwrites
  def update
    super
    update_zoom
    update_move_luna # Rename
    update_opacity
    update_effect
  end
  
end
end
