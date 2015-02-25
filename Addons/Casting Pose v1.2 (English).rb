#==============================================================================
# TSBS Addon - Casting Pose
# Version : 1.2
# Language : English
# Requires : Theolized Sideview Battle System
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact :
#------------------------------------------------------------------------------
# *> http://www.rpgmakerid.com
# *> http://www.rpgmakervxace.net
# *> http://theolized.blogspot.com
#==============================================================================
($imported ||= {})[:TSBS_CastPose] = true
#==============================================================================
# Change Logs:
# -----------------------------------------------------------------------------
# 2014.12.06 - Casting pose for enemy
#            - Casting pose for auto battle
#            - Added persistent casting pose
# 2014.08.26 - Fixed bug where random target from default script doesn't
#              trigger casting pose
#            - Add new :cast battle phase
# 2014.08.21 - Finished script
#==============================================================================
=begin
  
  ===================
  || Introduction ||
  -------------------
  This TSBS addon will make a sprite perform casting pose after you give them
  a command. Similar with Breath of Fire 4. Best used in default turn rules.
  Not in Active time battle, Free turn battle, or Charge turn battle.
  
  =================
  || How to use ||
  -----------------
  Put this script below TSBS implementation
  To setup casting pose, simply put this following tag in skill / item notebox
  
  \castpose : Action_Key
  
  To make the casting pose persistent, i.e, it won't changed when got hurt, put
  notetag <keep cast> in skill / item notebox
  
  Side note.
  If you want to loop the casting pose at a certain point, i.e you don't want
  to loop the casting pose from the beginning, you could use this kind of
  sequence
  
  "CastingPose" => [
  [],
  [:pose...],
  [:pose...],
  [:pose...],
  [:while, "true", "CastingLoop"],
  ],
  
  So, basically the [:while, "true"] command do an invinite will loop. See
  TSBS config 2 for [:while] command information.
  
  ===================
  || Terms of use ||
  -------------------
  Credit me, TheoAllen. You are free to edit this script by your own. As long
  as you don't claim it yours. For commercial purpose, don't forget to give me
  a free copy of the game.
  
=end
#==============================================================================
# Configuration
#==============================================================================
module TSBS
  
  Default_SkillCast = "K-Cast" # Default casting pose for Skill
  Default_ItemCast  = "" # Default casting pose for Item use
  PrepWait = 0 # Frame wait before turn start
  
  # Regex for notetag check. Do not change if you don't understand
  CastPose = /\\castpose\s*:\s*(.+)/i
  
end
#==============================================================================
# End of configuration. Do not edit pass this line!
#==============================================================================
if $imported[:TSBS]
#==============================================================================
# ** RPG::UsableItem
#==============================================================================
class RPG::UsableItem
  #----------------------------------------------------------------------------
  # * Cast Pose
  #----------------------------------------------------------------------------
  attr_accessor :cast_pose
  #----------------------------------------------------------------------------
  # * Load notetag
  #----------------------------------------------------------------------------
  alias addon_cast_load_tsbs load_tsbs
  def load_tsbs
    addon_cast_load_tsbs
    @cast_pose = TSBS::Default_SkillCast if is_a?(RPG::Skill)
    @cast_pose = TSBS::Default_SkillCast if is_a?(RPG::Item)
    note.split(/[\r\n]+/).each do |line|
      @cast_pose = $1.to_s if line =~ TSBS::CastPose
    end
  end
  #----------------------------------------------------------------------------
  # * Determine if persistent
  #----------------------------------------------------------------------------
  def persistent_castpose
    note[/<keep[\s_]+cast>/i]
  end
  
end
#==============================================================================
# ** Game_Battler
#==============================================================================
class Game_Battler
  #----------------------------------------------------------------------------
  # * Cast pose key
  #----------------------------------------------------------------------------
  attr_reader :cast_pose
  #----------------------------------------------------------------------------
  # * Alias method : Clear TSBS
  #----------------------------------------------------------------------------
  alias tsbs_castpose_clear clear_tsbs
  def clear_tsbs
    tsbs_castpose_clear
    @cast_pose = ""
  end
  #----------------------------------------------------------------------------
  # * Cast Pose =
  #----------------------------------------------------------------------------
  def cast_pose=(key)
    if @cast_pose != key
      @cast_pose = key
      self.battle_phase = (key.empty? ? :idle : :cast)
    end
  end
  #----------------------------------------------------------------------------
  # * Alias method : Phase sequence
  #----------------------------------------------------------------------------
  alias tsbs_castpose_phase_sequence phase_sequence
  def phase_sequence
    castpose = {:cast => method(:cast_pose)}
    return tsbs_castpose_phase_sequence.merge(castpose)
  end
  #----------------------------------------------------------------------------
  # * Alias method : Force change battle phase
  #----------------------------------------------------------------------------
  alias tsbs_castpose_force_change_bphase force_change_battle_phase
  def force_change_battle_phase(phase)
    phase = :cast if phase == :idle && !@cast_pose.empty?
    tsbs_castpose_force_change_bphase(phase)
  end
  #----------------------------------------------------------------------------
  # * Alias method : Battle Phase =
  #----------------------------------------------------------------------------
  alias tsbs_castpose_battle_phase= battle_phase=
  def battle_phase=(phase)
    if current_action
      item = current_action.item
      return if phase == :hurt && item && item.persistent_castpose
    end
    self.tsbs_castpose_battle_phase = phase
  end
  
end
#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor
  #----------------------------------------------------------------------------
  # * Alias method : Make action
  #----------------------------------------------------------------------------
  alias tsbs_castpose_make_action make_actions
  def make_actions
    tsbs_castpose_make_action
    return unless current_action
    item = current_action.item
    if item
      self.cast_pose = item.cast_pose
    end
  end
  
end
#==============================================================================
# ** Game_Enemy
#==============================================================================
class Game_Enemy
  #----------------------------------------------------------------------------
  # * Alias method : Make action
  #----------------------------------------------------------------------------
  alias tsbs_castpose_make_action make_actions
  def make_actions
    tsbs_castpose_make_action
    return unless current_action
    item = current_action.item
    if item
      self.cast_pose = item.cast_pose
    end
  end
  
end
#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle
  #----------------------------------------------------------------------------
  # * Alias method : Command attack
  #----------------------------------------------------------------------------
  alias tsbs_castpose_command_attack command_attack
  def command_attack
    @used_item = $data_skills[BattleManager.actor.attack_skill_id]
    tsbs_castpose_command_attack
  end
  #----------------------------------------------------------------------------
  # * Alias method : Command guard
  #----------------------------------------------------------------------------
  alias tsbs_castpose_command_guard command_guard
  def command_guard
    @used_item = $data_skills[BattleManager.actor.guard_skill_id]
    set_casting_pose
    tsbs_castpose_command_guard
  end
  #----------------------------------------------------------------------------
  # * Alias method : On skill ok
  #----------------------------------------------------------------------------
  alias tsbs_castpose_on_skill_ok on_skill_ok
  def on_skill_ok
    @used_item  = @skill_window.item
    set_casting_pose unless @used_item.need_selection? || 
      $imported["YEA-BattleEngine"]
    tsbs_castpose_on_skill_ok
  end
  #----------------------------------------------------------------------------
  # * Alias method : On item ok
  #----------------------------------------------------------------------------
  alias tsbs_castpose_on_item_ok on_item_ok
  def on_item_ok
    @used_item = @item_window.item
    set_casting_pose unless @used_item.need_selection? || 
      $imported["YEA-BattleEngine"]
    tsbs_castpose_on_item_ok
  end
  #----------------------------------------------------------------------------
  # * Alias method : On enemy ok
  #----------------------------------------------------------------------------
  alias tsbs_castpose_on_enemy_ok on_enemy_ok
  def on_enemy_ok
    set_casting_pose
    tsbs_castpose_on_enemy_ok
  end
  #----------------------------------------------------------------------------
  # * Alias method : On actor ok
  #----------------------------------------------------------------------------
  alias tsbs_castpose_on_actor_ok on_actor_ok
  def on_actor_ok
    set_casting_pose
    tsbs_castpose_on_actor_ok
  end
  #----------------------------------------------------------------------------
  # * Set casting pose
  #----------------------------------------------------------------------------
  def set_casting_pose
    actor = BattleManager.actor
    actor.cast_pose = @used_item.cast_pose if @used_item && 
      actor.cast_pose.empty?
  end
  #----------------------------------------------------------------------------
  # * Alias method : Show action sequences
  #----------------------------------------------------------------------------
  alias tsbs_castpose_show_action_sequences show_action_sequences
  def show_action_sequences(targets, item, subj = @subject)
    subj.cast_pose = ""
    tsbs_castpose_show_action_sequences(targets, item, subj)
  end
  #----------------------------------------------------------------------------
  # * Alias method : Turn start
  #----------------------------------------------------------------------------
  alias tsbs_castpose_turn_start turn_start
  def turn_start
    tsbs_castpose_turn_start
    wait(TSBS::PrepWait)
  end
  
end
#==============================================================================
end # $imported[:TSBS]
#==============================================================================
