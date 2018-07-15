#===============================================================================
# TSBS v1.4 Bugfixes
#-------------------------------------------------------------------------------
# Change Logs :
# 2018.07.15 - Fixed bug where random reflect didn't kill victim
# 2015.05.01 - Fixed hide target in animation crash
#            - Fixed accessing sprite when escape battle crash (detail below)
# 2015.03.25 - Added patch to work with TSBS in game editor
# 2015.03.06 - Fixed forced act bug for area target
# 2015.02.04 - Fixed Smooth return typo that cause fatal crash
#            - Fixed Show icon index
# 2015.01.09 - Added compatibility with YEA Steal Item
# 2015.01.08 - Added compatibility with YEA Party Command
# 2015.01.06 - Added fix for default flip
#            - Change how update key work in battler icon
#            - Added move to target fix
# 2015.01.01 - Added YEA skill steal compatibility
# 2014.12.25 - Release date
#
#-------------------------------------------------------------------------------
# Known issues :
#-------------------------------------------------------------------------------
# - When a projectile is reflected to friends unit, and it reaches zero didn't 
#   kill it. If actor is the victim, it may crash. (FIXED!)
#
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
# - Enemy Default flip doesn't work (FIXED!)
#
# - Move to target + area tag + flipped battler cause the battler go off screen
#   (FIXED!)
#
# - When you're using :sm_return, it will cause crash due to typo (FIXED!)
# 
# - When you're using index -3 in icon settings. Unless you give the notetag
#   <iconfile: name> you cant show icon. It should display default icon instead
#   of displaying nothing. No wonder some people keep asking me "how to show
#   weapon icon?" (FIXED!)
#
# - When you're using [:forced] in area skill, it will produce error (FIXED!)
#
# - When you're going to use hide target in animation. It produces error pointed
#   to basic modules (FIXED!)
#
# - When you define your own escape sequence, and you put a command that
#   modifies the actor sprite (e.g, [:fadeout]) it produces error (FIXED!)
#-------------------------------------------------------------------------------
# Known incompatibilities :
#-------------------------------------------------------------------------------
# - Incompatibility with YEA Active Chain Skill (FIXED!)
#
# - Incompatibility with YEA Skill Steal (FIXED!)
#
# - Incompatibility with AEA Charge turn battle(?)
#
# - Incompatibility with YEA Party Command (FIXED!)
#
# - Incompatibility with YEA Steal Item (FIXED!)
#
#-------------------------------------------------------------------------------
# To use this patch, simply put this script below implementation
#===============================================================================

#===============================================================================
# ** Game_Battler
#===============================================================================

class Game_Battler
  #----------------------------------
  # * Weapon icon fix
  #----------------------------------
  def icon_file(index = 0)
    return @icon_file unless @icon_file.empty?
    return weapons[index].icon_file if actor? && weapons[index]
    return ''
  end
  
  #----------------------------------
  # * System sound fix
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
  # * End action fix
  #----------------------------------
  def setup_end_action
    @break_action = true
    @finish = true
    method_wait
  end
  
  #----------------------------------
  # * Smooth move to target fix
  #----------------------------------
  def setup_smooth_move_target
    if area_flag
      size = target_array.size
      xpos = target_array.inject(0) {|r,battler| r + battler.x}/size
      ypos = target_array.inject(0) {|r,battler| r + battler.y}/size
      xpos += @acts[1] * (flip && !@ignore_flip_point ? -1 : 1)
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
  
  #----------------------------------
  # * Move to target flip fix
  #----------------------------------
  def setup_move_to_target
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    stop_all_movements
    if area_flag
      size = target_array.size
      xpos = target_array.inject(0) {|r,battler| r + battler.x}/size
      ypos = target_array.inject(0) {|r,battler| r + battler.y}/size
      xpos += @acts[1] * (flip && !@ignore_flip_point ? -1 : 1)
      # Get the center coordinate of enemies
      goto(xpos, ypos + @acts[2], @acts[3], @acts[4])
      return
    end
    xpos = target.x + (flip ? -@acts[1] : @acts[1])
    ypos = target.y + @acts[2]
    goto(xpos, ypos, @acts[3], @acts[4], @acts[5] || 0)
  end
  
  #-----------------------------------
  # * Smooth return patch
  #-----------------------------------
  def setup_smooth_return
    tx = @ori_x
    ty = @ori_y
    dur = @acts[1] || 25
    rev = @acts[2]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  
  #-----------------------------------
  # * forced acts patch
  #-----------------------------------
  def setup_force_act
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    act_key = @acts[1]
    if area_flag
      target_array.each do |target|
        target.forced_act = act_key
        target.force_change_battle_phase(:forced)
      end
    else
      target.forced_act = act_key
      target.force_change_battle_phase(:forced)
    end
  end
  
  #============================================================================
  # ** Patch for implementation to work with in game editor
  # Some commands that had been fixed
  # - [:focus, ...]
  # - [:screen, :tone, ...]
  # - [:screen, :color, ...]
  #============================================================================
  def setup_focus
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    case @focus_target
    when 1; eval_target = lambda{|s|opponents_unit.members.include?(s.battler)};
    when 2; eval_target = lambda{|s|friends_unit.members.include?(s.battler)};
    when 3; eval_target = lambda{|s|true};
    else;   eval_target = lambda{|s|target_array.include?(s.battler)};
    end
    sprset = get_spriteset
    rect = sprset.focus_bg.bitmap.rect
    color = @acts[2] || Focus_BGColor
    color = Color.new(*color) if color.is_a?(Array)
    sprset.focus_bg.bitmap.fill_rect(rect,color)  # Recolor focus background
    sprset.focus_bg.fadein(@acts[1])        # Trigger fadein
    sprset.battler_sprites.select do |spr|
      !spr.battler.nil? # Select avalaible battler
    end.each do |spr|
      if spr.battler != self && (spr.battler.actor? ? true : spr.battler.alive?)
        check = eval_target.call(spr)
        spr.fadeout(@acts[1]) if !check
        spr.fadein(@acts[1]) if check
      end
    end
  end
  
  #------------------------------------------------------
  # * Fix for auto-generated sequence from in game editor
  #------------------------------------------------------
  def setup_screen
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    screen = $game_troop.screen
    case @acts[1]
    when Screen_Tone
      return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
      tone = @acts[2].is_a?(Array) ? Tone.new(*@acts[2]) : @acts[2]
      duration = @acts[3]
      screen.start_tone_change(tone, duration)
    when Screen_Shake
      return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
      power = @acts[2]
      speed = @acts[3]
      duration = @acts[4]
      screen.start_shake(power, speed, duration)
    when Screen_Flash
      return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
      color = @acts[2].is_a?(Array) ? Color.new(*@acts[2]) : @acts[2]
      duration = @acts[3]
      screen.start_flash(color, duration)
    when Screen_Normalize
      return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
      tone = Tone.new
      duration = @acts[2]
      screen.start_tone_change(tone, duration)
    end
  end
  
end

#===============================================================================
# ** Game_Enemy
#===============================================================================

class Game_Enemy
  #-------------------
  # Enemy revival fix
  #-------------------
  def hp=(hp)
    super
    @collapsed = false if hp > 0
  end
  
  #-------------------
  # Default flip fix
  #-------------------
  def default_flip
    result = TSBS::Enemy_Default_Flip
    toggler = (!data_battler.note[DefaultFlip].nil? rescue false)
    result = !result if toggler
    return result
  end
  
end

#===============================================================================
# ** Sprite_Battler
#===============================================================================

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

#===============================================================================
# ** Sprite_AnimGuard
#===============================================================================

class Sprite_AnimGuard
  #----------------------------
  # Get battler (Multiple animation fix)
  #----------------------------
  def battler
    @spr_battler.battler
  end
  
end

#===============================================================================
# ** Sprite_BattlerIcon
#===============================================================================

class Sprite_BattlerIcon
  #--------------------------------------
  # Iconfix
  #--------------------------------------
  def icon_index=(index)
    @icon_index = index
    if index < 0
      battler = @spr_battler.battler
      name = battler.icon_file(index + 1)
      if name.empty?
        index = index.abs - 3
        self.icon_index = (battler.weapons[index].icon_index rescue (
          battler.weapons[index + 1].icon_index) rescue 0)
        return
      else
        bmp = Cache.system(name)
        self.bitmap = bmp
        return
      end
    end
    icon_bitmap = Cache.system("Iconset")
    rect = Rect.new(index % 16 * 24, index / 16 * 24, 24, 24)
    bmp = Bitmap.new(24,24)
    bmp.blt(0, 0, icon_bitmap, rect, 255)
    self.bitmap = bmp
  end
  
  #----------------------------------
  # Change update key for icon
  #----------------------------------
  def update_key
    actor = battler # Just make alias
    @used_key = battler.icon_key
    array = Icons[@used_key]
    return icon_error unless array
    self.anchor = array[0]
    @dummy.x = (battler.flip ? -array[1] : array[1])
    @dummy.y = array[2]
    @above_char = array[3]
    update_placement
    self.angle = array[4]
    target = array[5]
    duration = array[6]
    icon_index = (eval(array[7]) rescue 0) if array[7].is_a?(String)
    if array[7] >= 0
      icon_index = array[7]
    elsif !array[7].nil?
      if array[7] == -1 # First weapon ~
        icon_index = (battler.weapons[0].icon_index rescue 0)
      elsif array[7] == -2 # Second weapon ~
        icon_index = (battler.weapons[1].icon_index rescue 
          (battler.weapons[0].icon_index rescue 0))
      elsif array[7] <= -3 # Custom icon graphic
        icon_index = array[7] + 2
      end
    end
    self.mirror = (array[8].nil? ? false : array[8])
    if array[9] && array[10] && array[11]
      @dummy.slide(array[9], array[10], array[11])
    end
    icon_index = icon_index || 0
    self.icon_index = icon_index
    change_angle(target, duration)
    battler.icon_key = ""
  end
end

#===============================================================================
# ** Projectile Reflect Fix
#===============================================================================

class Sprite_Projectile
  def repel
    temp = subject
    if random_reflect? # Random target reflect if skill/item allow to do so
      temp = temp.friends_unit.alive_members.shuffle[0]
      $game_temp.battler_targets << temp # <-- Add to refresh
    end
    self.subject = target
    self.target = temp
    # Invert setup as well ~
    start = @setup[PROJ_START]
    start_p = @setup[PROJ_STARTPOS]
    @setup[PROJ_START] = @setup[PROJ_END]
    @setup[PROJ_STARTPOS] = @setup[PROJ_ENDPOS]
    @setup[PROJ_END] = start
    @setup[PROJ_ENDPOS] = start_p
    self.mirror = !self.mirror
    # Re-start projectile
    start_projectile
    start_animation(@animation, !@mirror)
  end
end

#===============================================================================
# ** Spriteset_Battle
#===============================================================================

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

#===============================================================================
# ** Window_BattleLog
#===============================================================================

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

#===============================================================================
# ** Accessing spriteset fix
#===============================================================================

class Scene_Battle
  #----------------------------------------------------------------------------
  # Store spriteset as global variable in case if SceneManager.scene returns
  # a nilclass, but spriteset still exist / not disposed yet. The question
  # come up, how could we access the spriteset then?
  #----------------------------------------------------------------------------
  alias lazy_fix_start start
  def start
    lazy_fix_start
    $sprset = @spriteset
  end
end

class Game_Actor
  #----------------------------------------------------------------------------
  # * Change how to access sprite
  #----------------------------------------------------------------------------
  def sprite
    $sprset.get_sprite(self)
  end
  
end

#===============================================================================
# ** Hide target fix in animation
#===============================================================================

class Sprite
  #----------------------------------------------------------------------------
  # * Change how my basic module works
  #----------------------------------------------------------------------------
  def flash(color, duration)
    theo_clonesprites_flash(color, duration)
    @dur_flash = duration
    @color_flash = color.clone if color
    @alpha_val = @color_flash.alpha.to_f
    @alpha_ease = @alpha_val / duration
  end
end

class Sprite_Battler
  #----------------------------------------------------------------------------
  # * Change alias to super. The next ruby version should consider alias as
  # super -_-
  #----------------------------------------------------------------------------
  def flash(color, duration)
    self.color.set(EmptyColor)
    super(color, duration)
    @spr_icon.flash(color, duration)
    @shadow.flash(color, duration) unless color
  end
end



#===============================================================================
# ** Scene_Battle
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

end

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
