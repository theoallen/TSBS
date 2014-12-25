#===============================================================================
# TSBS v1.4 Bugfixes
#-------------------------------------------------------------------------------
# Change Logs :
# 2014.12.25
#
#-------------------------------------------------------------------------------
# Known issues :
# - When you set an event in Troop that target all enemies (like change enemy 
#   HP / MP, hidden enemies will be revealed, but can not be targeted) (FIXED!)
#
# - When using custom collapse sequence, if you change the graphics like 
#   changing filename from battler_1.png to battler_2.png, your battler will
#   suddenly disappear (FIXED!)
#
# - Multiple Animations addon breaks the game if it's played over the animation
#   guard. An animation that played over the target when it took damage.(FIXED!)
#
# - Heavy lag issue if you set Looping_Background in config 1 to true and you
#   haven't set any background for battleback in map. (FIXED!)
#
# - Revived enemy won't collapsed twice (FIXED!)
#
# - Double resume error when using substitute not followed by yanfly script
#   (FIXED!)
#
# - Trying to show weapon icon for enemy causes crash (FIXED!)
#
# - System sound (recovery) played when using item in map/menu (FIXED!)
#
# - small issues on :sm_target and :end_action (FIXED!)
#
# - Incompatibility with YEA Active Chain Skill (FIXED!)
#
# - Incompatibility with YEA Skill Steal (On the way!)
#
# - Incompatibility with AEA Charge turn battle(?)
#-------------------------------------------------------------------------------
# To use this patch, simply put this script below implementation
#===============================================================================
class Game_Battler
  #-------------------
  # Weapon icon fix
  #-------------------
  def icon_file(index = 0)
    return @icon_file unless @icon_file.empty?
    return weapons[index].icon_file if actor? && weapons[index]
    return ''
  end
  #----------------------------------
  # System sound fix
  #----------------------------------
  def make_base_result(user, item)
    tsbs_make_base_result(user, item)
    Sound.tsbs_play_recovery if item.damage.recover? && play_sound?
    return if user == self
    return if busy?
    if item.damage.recover? || item.damage.type == 0
      self.battle_phase = :idle 
      # Refresh idle key. In case if there is any state change or 
      # HP rate change
      return
    end
    self.battle_phase = :hurt if @result.hit?
    # Automatically switch to hurt phase
    if @result.missed && play_sound?
      Sound.tsbs_play_miss
    end
    if @result.evaded
      Sound.tsbs_play_eva if item.physical? && play_sound?
      Sound.tsbs_play_magic_eva if item.magical? && play_sound?
      self.battle_phase = :evade 
      # Automatically switch to evade phase
    end
  end
  
  def play_sound?
    SceneManager.in_battle? && PlaySystemSound
  end
  #----------------------------------
  # End action fix
  #----------------------------------
  def setup_end_action
    @break_action = true
    @finish = true
    method_wait
  end
  #----------------------------------
  # Smooth move to target fix
  #----------------------------------
  def setup_smooth_move_target
    if area_flag
      size = target_array.size
      xpos = target_array.inject(0) {|r,battler| r + battler.x}/size
      ypos = target_array.inject(0) {|r,battler| r + battler.y}/size
      xpos += @acts[1]
      xpos *= -1 if flip && !@ignore_flip_point
      dur = @acts[3] || 25
      rev = @acts[4]
      rev = true if rev.nil?
      smooth_move(xpos, ypos + @acts[2], dur, rev)
      return
    end
    return unless target
    tx = @acts[1] + target.x || 0
    ty = @acts[2] + target.y || 0
    tx *= -1 if flip && !@ignore_flip_point
    dur = @acts[3] || 25
    rev = @acts[4]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  
end

class Game_Enemy
  #-------------------
  # Enemy revival
  #-------------------
  def hp=(hp)
    super
    @collapsed = false if hp > 0
  end
end

class Sprite_Battler
  #----------------------------
  # Battler visibility fix
  #----------------------------
  def init_visibility
    return if actor? && !@battler.data_battler.dead_key.empty?
    not_hidden = !@battler.hidden?
    not_collapsed = (@battler.enemy? && @battler.battle_phase != :collapse ? 
      !@battler.collapsed : true)
    @battler_visible = not_hidden && not_collapsed
    self.opacity = 0 unless @battler_visible
  end
  #----------------------------
  # Opacity refresh fix
  #----------------------------
  def update_opacity
    self.opacity = [opacity,@battler.max_opac].min
    @battler.refresh_opacity = false
  end
  
end

class Sprite_AnimGuard
  #----------------------------
  # Get battler (Multiple animation fix)
  #----------------------------
  def battler
    @spr_battler.battler
  end
end

class Spriteset_Battle
  #----------------------------
  # Looping background fix
  #----------------------------
  def battleback2_bitmap
    if battleback2_name
      Cache.battleback2(battleback2_name)
    elsif TSBS::Looping_Background
      Bitmap.new(Graphics.width, Graphics.height)
    else
      Bitmap.new(1, 1)
    end
  end
end

class Window_BattleLog
  #-----------------------------------------
  # Double resume fix in substitute
  #-----------------------------------------
  def display_substitute(sub, targ)
    return unless $imported["YEA-BattleEngine"] && 
      YEA::BATTLE::MSG_SUBSTITUTE_HIT
    add_text(sprintf(Vocab::Substitute, substitute.name, target.name))
  end
end

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
end
