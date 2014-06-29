# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.3
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# (English Language)
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5b
# >> Basic Functions 
# >> Movement
# >> Core Result
# >> Core Fade
# >> Clone Image
# >> Rotate Image
# >> Smooth Movement
# =============================================================================
# Script info :
# -----------------------------------------------------------------------------
# Known Compatibility :
# >> YEA - Core Engine
# >> YEA - Battle Engine (RECOMMENDED!)
# >> MOG Battle HUD
# >> Sabakan - Ao no Kiseki
# >> Fomar ATB
# >> EST - Ring System
# >> AEA - Charge Turn Battle
# -----------------------------------------------------------------------------
# Known Incompatibility :
# >> YEA - Lunatic Object
# >> Maybe, most of battle related scripts
# >> MOG Breathing script
# -----------------------------------------------------------------------------
# This section is mainly aimed for scripters. There's nothing to do unless
# you know what you're doing. I told ya. It's for your own good 
# =============================================================================
module TSBS
  # --------------------------------------------------------------------------
  # Constantas
  # --------------------------------------------------------------------------
  
  BusyPhases = [:intro, :skill, :prepare, :collapse, :forced]
  # Phase that considered as busy and wait for finish
  
  Temporary_Phase = [:hurt, :evade, :return, :intro, 
    :counter, :collapse,]
  # Phase that will be replaced by :idle when finished
  
  EmptyTone = Tone.new(0,0,0,0)
  # Tone that replace the battler tone if battler has no state tone
  
  EmptyColor = Color.new(0,0,0,0)
  # Color that replace the battler color blend if battler has no state color

  # -------------------------------------------------------------------------
  # Sequence Constants. Want to simplify the mode symbols? edit this section
  # -------------------------------------------------------------------------
  
  # Initial Release v1.0
  SEQUENCE_POSE             = :pose           # set pose
  SEQUENCE_MOVE             = :move           # trigger move     
  SEQUENCE_SLIDE            = :slide          # trigger slide
  SEQUENCE_RESET            = :goto_oripost   # trigger back to original post
  SEQUENCE_MOVE_TO_TARGET   = :move_to_target # trigger move to target
  SEQUENCE_SCRIPT           = :script         # call script function
  SEQUENCE_WAIT             = :wait           # wait for x frames
  SEQUENCE_DAMAGE           = :target_damage  # Apply skill/item to target
  SEQUENCE_SHOW_ANIMATION   = :show_anim      # Show animation on target
  SEQUENCE_CAST             = :cast           # Show animation on self
  SEQUENCE_VISIBLE          = :visible        # Toggle visibility
  SEQUENCE_AFTERIMAGE       = :afterimage     # Toggle afterimage effect
  SEQUENCE_FLIP             = :flip           # Toggle flip / mirror sprite
  SEQUENCE_ACTION           = :action         # Call predefined action
  SEQUENCE_PROJECTILE       = :projectile     # Show projectile
  SEQUENCE_PROJECTILE_SETUP = :proj_setup     # Setup projectile
  SEQUENCE_USER_DAMAGE      = :user_damage    # User damage
  SEQUENCE_LOCK_Z           = :lock_z         # Lock shadow (and Z)
  SEQUENCE_ICON             = :icon           # Show icon
  SEQUENCE_SOUND            = :sound          # Play SE
  SEQUENCE_IF               = :if             # Set Branched condition
  SEQUENCE_TIMED_HIT        = :timed_hit      # Trigger timed hit function
  SEQUENCE_SCREEN           = :screen         # Setup screen
  SEQUENCE_ADD_STATE        = :add_state      # Add state
  SEQUENCE_REM_STATE        = :rem_state      # Remove state
  SEQUENCE_CHANGE_TARGET    = :change_target  # Change current target
  SEQUENCE_SHOW_PICTURE     = :show_pic       # Show picture
  SEQUENCE_TARGET_MOVE      = :target_move    # Force move target
  SEQUENCE_TARGET_SLIDE     = :target_slide   # Force slide target
  SEQUENCE_TARGET_RESET     = :target_reset   # Force target to return
  SEQUENCE_BLEND            = :blend          # Setup battler blending
  SEQUENCE_FOCUS            = :focus          # Setup focus effect
  SEQUENCE_UNFOCUS          = :unfocus        # Remove focus effect
  SEQUENCE_TARGET_LOCK_Z    = :target_lock_z  # Lock target shadow (and Z)
  # -------------------------------------------
  # Update v1.1
  # -------------------------------------------
  SEQUENCE_ANIMTOP          = :anim_top     # Flag animation in always on top    
  SEQUENCE_FREEZE           = :freeze       # Freeze the screen (not tested)    
  SEQUENCE_CSTART           = :cutin_start  # Start cutin graphic)
  SEQUENCE_CFADE            = :cutin_fade   # Fade cutin graphic
  SEQUENCE_CMOVE            = :cutin_slide  # Slide cutin graphic
  SEQUENCE_TARGET_FLIP      = :target_flip  # Flip target
  SEQUENCE_PLANE_ADD        = :plane_add    # Show looping image
  SEQUENCE_PLANE_DEL        = :plane_del    # Delete looping image
  SEQUENCE_BOOMERANG        = :boomerang    # Flag projectile as boomerang
  SEQUENCE_PROJ_AFTERIMAGE  = :proj_afimage # Set afterimage for projectile
  SEQUENCE_BALLOON          = :balloon      # Show balloon icon
  # -------------------------------------------
  # Update v1.2
  # -------------------------------------------
  SEQUENCE_LOGWINDOW        = :log        # Display battle log
  SEQUENCE_LOGCLEAR         = :log_clear  # Clear battle log
  SEQUENCE_AFTINFO          = :aft_info   # Change afterimage
  SEQUENCE_SMMOVE           = :sm_move    # Smooth move
  SEQUENCE_SMSLIDE          = :sm_slide   # Smooth slide
  SEQUENCE_SMTARGET         = :sm_target  # Smooth move to target
  SEQUENCE_SMRETURN         = :sm_return  # Smooth return
  # -------------------------------------------
  # Update v1.3
  # -------------------------------------------
  SEQUENCE_LOOP             = :loop         # Loop in n times
  SEQUENCE_WHILE            = :while        # While loop
  SEQUENCE_COLLAPSE         = :collapse     # Perform collapse effect  
  SEQUENCE_FORCED           = :forced       # Force change action key to target
  SEQUENCE_ANIMBOTTOM       = :anim_bottom  # Play anim behind battler
  SEQUENCE_CASE             = :case         # Case switch
  SEQUENCE_INSTANT_RESET    = :instant_reset  # Instant reset
  SEQUENCE_ANIMFOLLOW       = :anim_follow  # Animation follow the battler
  SEQUENCE_CHANGE_SKILL     = :change_skill # Change carried skill
  
  # Screen sub-modes
  Screen_Tone       = :tone       # Set screen tone
  Screen_Shake      = :shake      # Set screen shake
  Screen_Flash      = :flash      # Set screen flash
  Screen_Normalize  = :normalize  # Normalize screen
  
  # Projectile setup
  ProjSetup_Feet    = :feet   # Set target projectile to feet
  ProjSetup_Middle  = :middle # Set target projectile to body
  ProjSetup_Head    = :head   # Set target projectile to head
  
  # -------------------------------------------------------------------------
  # Regular Expression (REGEXP) Constants. Want to simplify notetags? edit 
  # this section. If only you understand the ruby regular expression
  # -------------------------------------------------------------------------
  
  AnimGuard = /<anim[_\s]+guard\s*:\s*(\d+)>/i
  # Notetag for animation guard
  
  SkillGuard = /<skill[_\s]+guard\s*:\s*(\d+)>/i
  # Notetag for skill guard
  
  IgnoreSkillGuard = /<ignore[-\s]skill[-\s]guard>/i
  # Notetag for skill that ignore state skill guard
  
  IgnoreAnimGuard = /<ignore[-\s]anim[-\s]guard>/i
  # Notetag for skill that ignore state skill guard
  
  ParallelTAG = /<parallel[\s_]+anim>/i
  # Pararrel tag to plays animation and anim guard simultaneously
  
  StateOpacity = /<opacity\s*:\s*(\d+)>/i
  # Notetag for state Opacity
  
  SequenceREGX = /\\sequence\s*:\s*(.+)/i
  # Action sequence notetag in skill
  
  PrepareREGX = /\\preparation\s*:\s*(.+)/i
  # Preparation move for skill
  
  ReturnREGX = /\\return\s*:\s*(.+)/i
  # Return sequence movement for each skill
  
  ReflectAnim = /<reflect[_\s]+anim\s*:\s*(\d+)>/i
  # Reflect animation for skill
  
  AreaTAG = /<area>/i
  # Tag for area skill
  
  NoReturnTAG = /<no[\s_]+return>/i
  # Tag for no return sequence for skill
  
  AbsoluteTarget = /<abs[-_\s]+target>/i
  # Tag for absolute targeting
  
  StateAnim = /<animation\s*:\s*(\d+)/i
  # State Animation ID notetag
  
  AlwaysHit = /<always[_\s]+hit>/i
  # Always hit tag
  
  AntiCounter = /<anti[_\s]+counter>/i
  # Anti counter attack
  
  AntiReflect = /<anti[_\s]+reflect>/i
  # Anti magic reflect
  
  CounterSkillID = /<counter[_\s]+skill\s*:\s*(\d+)>/i
  # Counter Skill ID
  
  RandomReflect = /<random[_\s]+reflect>/i
  # Random magic reflection
  
  Transform = /<transform\s*:\s*(.+)>/i
  # Transform State
  
  DefaultFlip = /<flip>/i
  # Default flip for enemies
  
  DefaultATK = /<attack[\s_]*:\s*(\d+)>/i
  DefaultDEF = /<guard[\s_]*:\s*(\d+)>/i
  # Default basic actions
  
  ToneREGX = 
  /<tone:\s*(-|\+*)(\d+),\s*(-|\+*)(\d+),\s*(-|\+*)(\d+),\s*(-|\+*)(\d+)>/i
  # Regular expression for state tone tag
  
  ColorREGX =
  /<color:\s*(-|\+*)(\d+),\s*(-|\+*)(\d+),\s*(-|\+*)(\d+),\s*(-|\+*)(\d+)>/i
  # Regular expression for state color blend
  
  SBS_Start   = /<sideview>/i             # Starting Sideview Tag
  SBS_Start_S = /<sideview\s*:\s*(.+)>/i  # Starting with string
  SBS_End     = /<\/sideview>/i           # End of sideview tag
  
  # ---------------------------------------------
  # Sideview tags
  # ---------------------------------------------
  
  SBS_Idle      = /\s*idle\s*:\s*(.+)/i
  SBS_Critical  = /\s*critical\s*:\s*(.+)/i
  SBS_Evade     = /\s*evade\s*:\s*(.+)/i
  SBS_Hurt      = /\s*hurt\s*:\s*(.+)/i
  SBS_Return    = /\s*return\s*:\s*(.+)/i
  SBS_Dead      = /\s*dead\s*:\s*(.+)/i
  SBS_Escape    = /\s*escape\s*:\s*(.+)/i
  SBS_Win       = /\s*victory\s*:\s*(.+)/i
  SBS_Intro     = /\s*intro\s*:\s*(.+)/i
  SBS_Counter   = /\s*counter\s*:\s*(.+)/i
  SBS_Collapse  = /\s*collapse\s*:\s*(.+)/i
  
  # -------------------------------------------------------------------------
  # Error Handler. Because I don't want to be blamed ~
  # -------------------------------------------------------------------------
  
  ErrorSound = RPG::SE.new("Buzzer1",100,100)
  def self.error(symbol, params, seq)
    ErrorSound.play
    text = "Sequence : #{seq}\n" +
    "#{symbol} mode needs at least #{params} parameters"
    raise text
    exit
  end
  
end
# ----------------------------------------------------------------------------
# Kernel method to get scene spriteset
# ----------------------------------------------------------------------------
def get_spriteset
  SceneManager.scene.instance_variable_get("@spriteset")
end
# ----------------------------------------------------------------------------
# Kernel method for chance
# ----------------------------------------------------------------------------
def chance(c)
  return rand < c
end
# ----------------------------------------------------------------------------
# Copy method
# ----------------------------------------------------------------------------
def copy(object)
  Marshal.load(Marshal.dump(object))
end
# ----------------------------------------------------------------------------
# Altered basic module
# ----------------------------------------------------------------------------
module THEO
  module Movement
    class Move_Object
      attr_reader :real_y
    end
    def real_ypos
      return @move_obj.real_y if @move_obj.real_y > 0
      return self.y
    end
  end
end

#==============================================================================
# ** Sound
#------------------------------------------------------------------------------
#  This module plays sound effects. It obtains sound effects specified in the
# database from the global variable $data_system, and plays them.
#==============================================================================

class << Sound
  
  # Delete play evasion ~
  alias tsbs_play_eva play_evasion
  def play_evasion
  end
  
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the 
# global variables used by the game are initialized by this module.
#==============================================================================

class << DataManager
  # --------------------------------------------------------------------------
  # Alias method : load database
  # --------------------------------------------------------------------------
  alias theo_tsbs_load_db load_database
  def load_database
    theo_tsbs_load_db
    load_tsbs
  end
  # --------------------------------------------------------------------------
  # New Method : Load TSBS caches
  # --------------------------------------------------------------------------
  def load_tsbs
    ($data_skills + $data_items + $data_states + $data_classes + 
      $data_weapons + $data_actors + $data_enemies).compact.each do |item|
      item.load_tsbs
    end
  end  
end

#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  This module manages battle progress.
#==============================================================================

class << BattleManager
  # --------------------------------------------------------------------------
  # Alias method : Battle Start
  # --------------------------------------------------------------------------
  alias tsbs_battle_start battle_start
  def battle_start
    tsbs_battle_start
    if ($imported["YEA-BattleEngine"] && !YEA::BATTLE::MSG_ENEMY_APPEARS) ||
        !$game_message.busy?
      swindow = SceneManager.scene.instance_variable_get("@status_window")
      if swindow 
        swindow.open 
        swindow.refresh
      end
      # Open status window if encounter message is disabled
    end
    SceneManager.scene.wait_for_sequence 
    # wait for intro sequence
  end
  # --------------------------------------------------------------------------
  # Alias method : process victory
  # --------------------------------------------------------------------------
  alias tsbs_process_victory process_victory
  def process_victory
    $game_party.alive_members.each do |member|
      member.battle_phase = :victory
    end
    tsbs_process_victory
  end
  # ---------------------------------------------------------------------------
  # Overwrite method : process escape
  # ---------------------------------------------------------------------------
  def process_escape
    $game_message.add(sprintf(Vocab::EscapeStart, $game_party.name))
    success = @preemptive ? true : (rand < @escape_ratio)
    Sound.play_escape
    if success
      process_abort
      $game_party.alive_members.each do |member|
        member.battle_phase = :escape
      end
    else
      @escape_ratio += 0.1
      $game_message.add('\.' + Vocab::EscapeFailure)
      $game_party.clear_actions
    end
    wait_for_message
    return success
  end
  # --------------------------------------------------------------------------
  # Alias method : Judge win loss
  # It seems if I don't add these lines. Enemy battler won't collapsed when
  # K.O by slip damage
  # --------------------------------------------------------------------------
  alias tsbs_judge_win_loss judge_win_loss
  def judge_win_loss
    if SceneManager.scene_is?(Scene_Battle)
      SceneManager.scene.all_battle_members.each do |member|
        SceneManager.scene.check_collapse(member)
      end
      SceneManager.scene.wait_for_sequence 
    end
    tsbs_judge_win_loss
  end
  
end

#==============================================================================
# ** RPG::Class
#------------------------------------------------------------------------------
#  This class handles database for classes
#==============================================================================

class RPG::Class < RPG::BaseItem
  attr_accessor :attack_id
  attr_accessor :guard_id
  
  def load_tsbs
    @attack_id = 0
    @guard_id = 0
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when TSBS::DefaultATK
        @attack_id = $1.to_i
      when TSBS::DefaultDEF
        @guard_id = $1.to_i
      end
    end
  end
end

#==============================================================================
# ** RPG::Weapon
#------------------------------------------------------------------------------
#  This class handles database for weapons
#==============================================================================

class RPG::Weapon < RPG::EquipItem
  attr_accessor :attack_id
  attr_accessor :guard_id
  
  def load_tsbs
    @attack_id = 0
    @guard_id = 0
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when TSBS::DefaultATK
        @attack_id = $1.to_i
      when TSBS::DefaultDEF
        @guard_id = $1.to_i
      end
    end
  end
  
end

#==============================================================================
# ** RPG::State
#------------------------------------------------------------------------------
#  This class handles database for states
#==============================================================================

class RPG::State < RPG::BaseItem
  # --------------------------------------------------------------------------
  # New public accessors
  # --------------------------------------------------------------------------
  attr_accessor :tone           # State Tone
  attr_accessor :color          # State Color
  attr_accessor :anim_guard     # Animation Guard
  attr_accessor :skill_guard    # Skill Guard
  attr_accessor :max_opac       # Max Opacity
  attr_accessor :sequence       # State sequence
  attr_accessor :state_anim     # State animation
  attr_accessor :trans_name     # Transform Name
  attr_accessor :attack_id      # Default attack
  attr_accessor :guard_id       # Default guard
  # --------------------------------------------------------------------------
  # New method : load TSBS notetags
  # --------------------------------------------------------------------------
  def load_tsbs
    @anim_guard = 0
    @skill_guard = 0
    @max_opac = 255
    @sequence = ""
    @state_anim = 0
    @trans_name = ""
    @color = nil
    @attack_id = 0
    @guard_id = 0
    note.split(/[\r\n]+/).each do |line|
      case line
      when TSBS::ToneREGX
        @tone = Tone.new
        @tone.red = $2.to_i * ($1.to_s == "-" ? -1 : 1)
        @tone.green = $4.to_i * ($3.to_s == "-" ? -1 : 1)
        @tone.blue = $6.to_i * ($5.to_s == "-" ? -1 : 1)
        @tone.gray = $8.to_i * ($7.to_s == "-" ? -1 : 1)
      when TSBS::ColorREGX
        @color = Color.new
        @color.red = $2.to_i * ($1.to_s == "-" ? -1 : 1)
        @color.green = $4.to_i * ($3.to_s == "-" ? -1 : 1)
        @color.blue = $6.to_i * ($5.to_s == "-" ? -1 : 1)
        @color.alpha = $8.to_i * ($7.to_s == "-" ? -1 : 1)
      when TSBS::AnimGuard
        @anim_guard = $1.to_i
      when TSBS::SkillGuard
        @skill_guard = $1.to_i
      when TSBS::StateOpacity
        @max_opac = $1.to_i
      when TSBS::SequenceREGX
        @sequence = $1.to_s
      when TSBS::StateAnim
        @state_anim = $1.to_i
      when TSBS::Transform
        @trans_name = $1.to_s
      when TSBS::DefaultATK
        @attack_id = $1.to_i
      when TSBS::DefaultDEF
        @guard_id = $1.to_i
      end
    end
  end
  
end

#==============================================================================
# ** RPG::UsableItem
#------------------------------------------------------------------------------
#  This class handles database for skills and items
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  # --------------------------------------------------------------------------
  # New public accessors
  # --------------------------------------------------------------------------
  attr_accessor :seq_key        # Sequence keys
  attr_accessor :prepare_key    # Preparation keys
  attr_accessor :return_key     # Return key sequence
  attr_accessor :reflect_anim   # Reflect animations
  # --------------------------------------------------------------------------
  # New method : load TSBS notetags
  # --------------------------------------------------------------------------
  def load_tsbs
    @seq_key = TSBS::Default_SkillSequence
    @seq_key = TSBS::Default_ItemSequence if is_a?(RPG::Item)
    @prepare_key = ""
    @return_key = ""
    @reflect_anim = animation_id
    first_time = true
    note.split(/[\r\n]+/).each do |line|
      case line 
      when TSBS::SequenceREGX
        if first_time
          @seq_key = [$1.to_s]
          first_time = false
        else
          @seq_key.push($1.to_s)
        end
      when TSBS::PrepareREGX
        @prepare_key = $1.to_s
      when TSBS::ReturnREGX
        @return_key = $1.to_s
      when TSBS::ReflectAnim
        @reflect_anim = $1.to_i
      end
    end
  end
  # --------------------------------------------------------------------------
  # New method : Determine if item / skill is area attack
  # --------------------------------------------------------------------------
  def area?
    !note[TSBS::AreaTAG].nil?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if item / skill doesn't require subject to return
  # --------------------------------------------------------------------------
  def no_return?
    !note[TSBS::NoReturnTAG].nil?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if item / skill has absolute target
  # --------------------------------------------------------------------------
  def abs_target?
    !note[TSBS::AbsoluteTarget].nil? && for_random?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if skill is ignoring skill guard effect
  # --------------------------------------------------------------------------
  def ignore_skill_guard?
    !note[TSBS::IgnoreSkillGuard].nil?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if skill is ignoring anim guard effect
  # --------------------------------------------------------------------------
  def ignore_anim_guard?
    !note[TSBS::IgnoreAnimGuard].nil?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if skill anti counter attack
  # --------------------------------------------------------------------------
  def anti_counter?
    !note[TSBS::AntiCounter].nil?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if skill is anti magic reflection
  # --------------------------------------------------------------------------
  def anti_reflect?
    !note[TSBS::AntiReflect].nil?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if skill is always hit
  # --------------------------------------------------------------------------
  def always_hit?
    !note[TSBS::AlwaysHit].nil?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if skill is plays parallel animation
  # --------------------------------------------------------------------------
  def parallel_anim?
    !note[TSBS::ParallelTAG].nil?
  end
  # --------------------------------------------------------------------------
  # New method : Determine if skill is randomly select target during magic
  # reflection
  # --------------------------------------------------------------------------
  def random_reflect?
    !note[TSBS::RandomReflect].nil?
  end
end

#==============================================================================
# ** RPG::Actor
#------------------------------------------------------------------------------
#  This class handles actors database
#==============================================================================

class RPG::Actor < RPG::BaseItem
  # --------------------------------------------------------------------------
  # New public accessors
  # --------------------------------------------------------------------------
  attr_accessor :idle_key       # Idle key sequence
  attr_accessor :critical_key   # Critical key sequence
  attr_accessor :evade_key      # Evade key sequence
  attr_accessor :hurt_key       # Hurt key sequence
  attr_accessor :return_key     # Return key sequence
  attr_accessor :dead_key       # Dead key sequence
  attr_accessor :escape_key     # Escape key sequence
  attr_accessor :victory_key    # Victory key sequence
  attr_accessor :intro_key      # Intro key sequence
  attr_accessor :counter_key    # Counterattack key sequence
  attr_accessor :collapse_key   # Collapse key sequence
  attr_accessor :battler_name   # Battler name
  attr_accessor :counter_skill  # Counterattack skill ID
  attr_accessor :use_sprite     # Use sprite flag (always true)
  attr_accessor :reflect_anim   # Reflect animation
  attr_accessor :attack_id      # Attack skill ID
  attr_accessor :guard_id       # Guard skill ID
  # --------------------------------------------------------------------------
  # New method : load TSBS notetags
  # --------------------------------------------------------------------------
  def load_tsbs
    @idle_key = TSBS::Default_Idle
    @critical_key = TSBS::Default_Critical
    @evade_key = TSBS::Default_Evade
    @hurt_key = TSBS::Default_Hurt
    @return_key = TSBS::Default_Return
    @dead_key = TSBS::Default_Dead
    @escape_key = TSBS::Default_Escape
    @victory_key = TSBS::Default_Victory
    @intro_key = TSBS::Default_Intro
    @counter_key = TSBS::Default_ACounter
    @collapse_key = ""
    @battler_name = @name.clone
    @counter_skill = 1
    @reflect_anim = TSBS::Reflect_Guard
    @use_sprite = true
    @attack_id = 0
    @guard_id = 0
    load_sbs = false
    note.split(/[\r\n]+/).each do |line|
      # -- Non TSBS sideview tag ---
      case line
      when TSBS::DefaultATK
        @attack_id = $1.to_i
      when TSBS::DefaultDEF
        @guard_id = $1.to_i
      when TSBS::ReflectAnim
        @reflect_anim = $1.to_i
      when TSBS::CounterSkillID
        @counter_skill = $1.to_i
      end
      # -- TSBS sideview tag ---
      if line =~ TSBS::SBS_Start
        load_sbs = true
      elsif line =~ TSBS::SBS_Start_S
        load_sbs = true
        @battler_name = $1.to_s
      elsif line =~ TSBS::SBS_End
        load_sbs = false
      end
      # -- End ---
      next unless load_sbs
      case line
      when TSBS::SBS_Idle
        @idle_key = $1.to_s
      when TSBS::SBS_Critical
        @critical_key = $1.to_s
      when TSBS::SBS_Evade
        @evade_key = $1.to_s
      when TSBS::SBS_Hurt
        @hurt_key = $1.to_s
      when TSBS::SBS_Return
        @return_key = $1.to_s
      when TSBS::SBS_Dead
        @dead_key = $1.to_s
      when TSBS::SBS_Escape
        @escape_key = $1.to_s
      when TSBS::SBS_Win
        @victory_key = $1.to_s
      when TSBS::SBS_Intro
        @intro_key = $1.to_s
      when TSBS::SBS_Counter
        @counter_key = $1.to_s
      when TSBS::SBS_Collapse
        @collapse_key = $1.to_s
      end
    end
  end
end

#==============================================================================
# ** RPG::Enemy
#------------------------------------------------------------------------------
#  This class handles enemies database
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  # --------------------------------------------------------------------------
  # New public accessors
  # --------------------------------------------------------------------------
  attr_accessor :idle_key       # Idle key sequence
  attr_accessor :critical_key   # Critical key sequence
  attr_accessor :evade_key      # Evade key sequence
  attr_accessor :hurt_key       # Hurt key sequence
  attr_accessor :return_key     # Return key sequence
  attr_accessor :dead_key       # Dead key sequence
  attr_accessor :intro_key      # Intro key sequence
  attr_accessor :counter_key    # Counterattack key sequence
  attr_accessor :collapse_key   # Collapse key sequence
  attr_accessor :use_sprite     # Use sprite flag (true/false)
  attr_accessor :sprite_name    # Sprite name
  attr_accessor :counter_skill  # Counter skill ID
  attr_accessor :reflect_anim   # Reflect animation
  # --------------------------------------------------------------------------
  # New method : load TSBS notetags
  # --------------------------------------------------------------------------
  def load_tsbs
    @idle_key = TSBS::Default_Idle
    @critical_key = TSBS::Default_Critical
    @evade_key = TSBS::Default_Evade
    @hurt_key = TSBS::Default_Hurt
    @return_key = TSBS::Default_Return
    @dead_key = TSBS::Default_Dead
    @intro_key = TSBS::Default_Intro
    @reflect_anim = TSBS::Reflect_Guard
    @counter_key = TSBS::Default_ECounter
    @collapse_key = ""
    @sprite_name = ""
    @counter_skill = 1
    @use_sprite = false
    load_sbs = false
    note.split(/[\r\n]+/).each do |line|
      if line =~ TSBS::SBS_Start_S
        load_sbs = true
        @use_sprite = true
        @sprite_name = $1.to_s
      elsif line =~ TSBS::SBS_Start
        load_sbs = true
      elsif line =~ TSBS::SBS_End
        load_sbs = false
      end
      if line =~ TSBS::ReflectAnim
        @reflect_anim = $1.to_i
      elsif line =~ TSBS::CounterSkillID
        @counter_skill = $1.to_i
      end
      next unless load_sbs
      case line
      when TSBS::SBS_Idle
        @idle_key = $1.to_s
      when TSBS::SBS_Critical
        @critical_key = $1.to_s
      when TSBS::SBS_Evade
        @evade_key = $1.to_s
      when TSBS::SBS_Hurt
        @hurt_key = $1.to_s
      when TSBS::SBS_Return
        @return_key = $1.to_s
      when TSBS::SBS_Dead
        @dead_key = $1.to_s
      when TSBS::SBS_Intro
        @intro_key = $1.to_s
      when TSBS::SBS_Counter
        @counter_key = $1.to_s
      when TSBS::SBS_Collapse
        @collapse_key = $1.to_s
      end
    end
  end
  
end

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
# The instance of this class is referenced by $game_temp.
#==============================================================================

class Game_Temp
  # --------------------------------------------------------------------------
  # New public accessors
  # --------------------------------------------------------------------------
  attr_accessor :actors_fiber     # Store actor Fibers thread
  attr_accessor :enemies_fiber    # Store enemy Fibers thread
  attr_accessor :battler_targets  # Store current targets
  attr_accessor :anim_top         # Store anim top flag
  attr_accessor :global_freeze    # Global freeze flag
  attr_accessor :anim_follow      # Store anim follow flag
  # --------------------------------------------------------------------------
  # Alias method : Initialize
  # --------------------------------------------------------------------------
  alias tsbs_init initialize
  def initialize
    tsbs_init
    clear_tsbs
  end
  # --------------------------------------------------------------------------
  # New method : clear TSBS infos
  # --------------------------------------------------------------------------
  def clear_tsbs
    @actors_fiber = {}
    @enemies_fiber = {}
    @battler_targets = []
    @anim_top = 0
    @global_freeze = false
    @anim_follow = false
  end
  
end

#==============================================================================
# ** Game_Action
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_Action
  # --------------------------------------------------------------------------
  # Alias method : targets for opponents
  # --------------------------------------------------------------------------
  alias tsbs_trg_for_opp targets_for_opponents
  def targets_for_opponents
    return abs_target if item.abs_target?
    return tsbs_trg_for_opp
  end
  # --------------------------------------------------------------------------
  # New method : Absolute target
  # --------------------------------------------------------------------------
  def abs_target
    opponents_unit.abs_target(item.number_of_targets)
  end
end

#==============================================================================
# ** Game_ActionResult
#------------------------------------------------------------------------------
#  This class handles the results of battle actions. It is used internally for
# the Game_Battler class. 
#==============================================================================

class Game_ActionResult
  attr_accessor :reflected  # Reflected flag. Purposely used for :if mode
  # --------------------------------------------------------------------------
  # Alias method : Clear
  # --------------------------------------------------------------------------
  alias tsbs_clear clear
  def clear
    tsbs_clear
    @reflected = false
  end

end

#==============================================================================
# ** Game_Unit
#------------------------------------------------------------------------------
#  This class handles units. It's used as a superclass of the Game_Party and
# and Game_Troop classes.
#==============================================================================

class Game_Unit
  # --------------------------------------------------------------------------
  # New method : Make absolute target candidate
  # --------------------------------------------------------------------------
  def abs_target(number)
    candidate = alive_members.shuffle
    ary = []
    [number,candidate.size].min.times do 
      ary.push(candidate.shift) if !candidate[0].nil?
    end
    return ary
  end
  
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================

class Game_Battler < Game_BattlerBase
  # --------------------------------------------------------------------------
  # Basic modules
  # --------------------------------------------------------------------------
  include THEO::Movement  # Import basic module for battler movements
  include TSBS            # Import constantas
  include Smooth_Slide    # Import smooth sliding module
  # --------------------------------------------------------------------------
  # New public attributes
  # --------------------------------------------------------------------------
  attr_accessor :animation_array    # Store animation sequence
  attr_accessor :battler_index      # Store battler filename index
  attr_accessor :anim_index         # Pointer for animation array
  attr_accessor :anim_cell          # Battler image index
  attr_accessor :item_in_use        # Currently used item
  attr_accessor :visible            # Visible flag
  attr_accessor :flip               # Mirror flag
  attr_accessor :area_flag          # Area damage flag
  attr_accessor :afterimage         # Afterimage flag
  attr_accessor :refresh_opacity    # Refresh opacity flag
  attr_accessor :icon_key           # Store icon key
  attr_accessor :lock_z             # Lock Z flag
  attr_accessor :balloon_id         # Balloon ID for battler
  attr_accessor :anim_guard         # Anim Guard ID
  attr_accessor :anim_guard_mirror  # Mirror Flag
  attr_accessor :afopac             # Afterimage ppacity fade speed
  attr_accessor :afrate             # Afterimage show rate
  attr_accessor :forced_act         # Force action
  # --------------------------------------------------------------------------
  # New public attributes (access only)
  # --------------------------------------------------------------------------
  attr_reader :target         # Current target
  attr_reader :target_array   # Overall target
  attr_reader :battle_phase   # Battle Phase
  attr_reader :finish         # Sequence finish flag
  attr_reader :blend          # Blend
  # --------------------------------------------------------------------------
  # Alias method : initialize
  # --------------------------------------------------------------------------
  alias theo_tsbs_batt_init initialize
  def initialize(*args)
    theo_tsbs_batt_init(*args)
    set_obj(self)
    clear_tsbs
  end
  # --------------------------------------------------------------------------
  # New method : default flip
  # --------------------------------------------------------------------------
  def default_flip
    return false
  end
  # --------------------------------------------------------------------------
  # New method : Store targets in array
  # --------------------------------------------------------------------------
  def target_array=(targets)
    @target_array = targets
    @ori_targets = targets.clone
  end
  # --------------------------------------------------------------------------
  # New method : Store current target
  # --------------------------------------------------------------------------
  def target=(target)
    @target = target
    @ori_target = target
  end
  # --------------------------------------------------------------------------
  # New method : Reset to original position
  # --------------------------------------------------------------------------
  def reset_pos(dur = 30, jump = 0)
    goto(@ori_x, @ori_y, dur, jump)
  end
  # --------------------------------------------------------------------------
  # New method : Clear TSBS infos
  # --------------------------------------------------------------------------
  def clear_tsbs
    @animation_array = []
    @finish = false
    @anim_index = 0
    @anim_cell = 0
    @battler_index = 1
    @battle_phase = nil
    @target = nil
    @ori_target = nil
    @target_array = []
    @ori_targets = []
    @item_in_use = nil
    @visible = true
    @flip = default_flip
    @area_flag = false
    @afterimage = false
    @proj_start = :middle
    @proj_end = :middle
    @proj_icon = 0
    @refresh_opacity = false
    @screen_z = 0
    @lock_z = false
    @icon_key = ""
    @timed_hit = false
    @timed_hit_count = 0
    @acts = []
    @blend = 0
    @used_sequence = ""
    @sequence_stack = []
    @boomerang = false
    @proj_afimg = false
    @balloon_id = 0
    @anim_guard = 0
    @anim_guard_mirror =  false
    @forced_act = ""
    reset_aftinfo
  end
  # --------------------------------------------------------------------------
  # New method : Reset afterimage info
  # --------------------------------------------------------------------------
  def reset_aftinfo
    @afopac = 20
    @afrate = 3
  end
  # --------------------------------------------------------------------------
  # New method : Battler update
  # --------------------------------------------------------------------------
  def update
    return if $game_temp.global_freeze && battle_phase != :skill
    update_move           # Update movements (Basic Module)
    update_smove          # Update smooth movement (Basic Module)
    if fiber_obj
      fiber_obj.resume  # Update Fiber thread
    end
  end
  # --------------------------------------------------------------------------
  # New method : Fiber object
  # --------------------------------------------------------------------------
  def fiber_obj
    return nil
  end
  # --------------------------------------------------------------------------
  # New method : Force change battle phase
  # --------------------------------------------------------------------------
  def force_change_battle_phase(phase)
    @battle_phase = phase
    @used_sequence = phase_sequence[phase].call
    @sequence_stack = [@used_sequence]
    @anim_index = 0
    @anim_index = rand(get_animloop_array.size - 1) if phase == :idle
    @finish = false
    @animation_array = get_animloop_array.dup
    fiber = Fiber.new { update_anim_index }
    insert_fiber(fiber)
  end
  # --------------------------------------------------------------------------
  # New method : Set battle phase
  # --------------------------------------------------------------------------
  def battle_phase=(phase)
    return if (phase == :idle || phase == :hurt) && 
      [:evade, :counter].any? { |temp| battle_phase == temp }
    return if phase == :hurt && (dead? || battle_phase == :forced)
    force_change_battle_phase(phase)
  end
  # --------------------------------------------------------------------------
  # Alias method : On battle start
  # --------------------------------------------------------------------------
  alias theo_on_bs_start on_battle_start
  def on_battle_start
    theo_on_bs_start
    @screen_z = screen_z_formula
    self.battle_phase = :idle unless battle_phase == :intro
  end
  # --------------------------------------------------------------------------
  # New method : Store fiber in $game_temp
  # --------------------------------------------------------------------------
  def insert_fiber(fiber)
    if actor?
      $game_temp.actors_fiber[index] = fiber
    else
      $game_temp.enemies_fiber[index] = fiber
    end
  end
  # --------------------------------------------------------------------------
  # New method : Refers to battler database
  # --------------------------------------------------------------------------
  def data_battler
    return nil
  end
  # --------------------------------------------------------------------------
  # New method : Determine if battler is in critical condition
  # --------------------------------------------------------------------------
  def critical?
    hp_rate <= Critical_Rate
  end
  # --------------------------------------------------------------------------
  # New method : Phase sequence key
  # --------------------------------------------------------------------------
  def phase_sequence
    hash = {
      :idle => method(:idle),
      :victory => method(:victory),
      :hurt => method(:hurt),
      :skill => method(:skill),
      :evade => method(:evade),
      :return => method(:return),
      :escape => method(:escape_key),
      :prepare => method(:prepare_key),
      :intro => method(:intro_key),
      :counter => method(:counter_key),
      :collapse => method(:collapse_key),
      :forced => method(:forced_act)
    }
    return hash
  end
  # --------------------------------------------------------------------------
  # New method : Idle sequence key
  # --------------------------------------------------------------------------
  # Idle key sequence contains several sequence key. Include dead sequence,
  # state sequence, critical sequence,and normal sequence. Dead key sequence
  # has the top priority over others. Just look at the below
  # --------------------------------------------------------------------------
  def idle
    return data_battler.dead_key if dead? && actor?
    return state_sequence if state_sequence
    return data_battler.critical_key if critical? && 
      !data_battler.critical_key.empty?
    return data_battler.idle_key
  end
  # --------------------------------------------------------------------------
  # New method : Escape sequence key
  # --------------------------------------------------------------------------
  def escape_key
    return data_battler.escape_key
  end
  # --------------------------------------------------------------------------
  # New method : Victory sequence key
  # --------------------------------------------------------------------------
  def victory
    return data_battler.victory_key
  end
  # --------------------------------------------------------------------------
  # New method : Hurt sequence key
  # --------------------------------------------------------------------------
  def hurt
    return data_battler.hurt_key
  end
  # --------------------------------------------------------------------------
  # New method : Skill sequence key
  # Must be called when item_in_use isn't nil
  # --------------------------------------------------------------------------
  def skill
    return item_in_use.seq_key[rand(item_in_use.seq_key.size)]
  end
  # --------------------------------------------------------------------------
  # New method : Evade sequence key
  # --------------------------------------------------------------------------
  def evade
    return data_battler.evade_key
  end
  # --------------------------------------------------------------------------
  # New method : Return sequence key
  # Must be called when item_in_use isn't nil
  # --------------------------------------------------------------------------
  def return
    return item_in_use.return_key if !item_in_use.return_key.empty?
    return data_battler.return_key
  end
  # --------------------------------------------------------------------------
  # New method : Preparation key
  # Must be called when item_in_use isn't nil
  # --------------------------------------------------------------------------
  def prepare_key
    return item_in_use.prepare_key
  end
  # --------------------------------------------------------------------------
  # New method : Intro sequence key
  # --------------------------------------------------------------------------
  def intro_key
    return data_battler.intro_key
  end
  # --------------------------------------------------------------------------
  # New method : Counter sequence key
  # --------------------------------------------------------------------------
  def counter_key
    return data_battler.counter_key
  end
  # --------------------------------------------------------------------------
  # New method : Collapse sequence key
  # --------------------------------------------------------------------------
  def collapse_key
    return data_battler.collapse_key
  end
  # --------------------------------------------------------------------------
  # Debug only : print current action sequence
  # --------------------------------------------------------------------------
  def print_current_action
    p phase_sequence[battle_phase].call
  end
  # --------------------------------------------------------------------------
  # Main animation sequence goes here
  # --------------------------------------------------------------------------
  def update_anim_index
    
    # ----- Start ------ #
    @finish = false
    flip_val = @animation_array[0][2] # Flip Value
    @flip = flip_val if !flip_val.nil?
    @flip = default_flip if flip_val == :ori || (flip_val.nil? && 
      battle_phase != :skill)
    # If battle phase isn't :skill, nil flip value will return the battler
    # flip into default one
    
    @afterimage = @animation_array[0][1]
    @timed_hit = false    # Timed hit flag
    @timed_hit_count = 0  # Timed hit count
    reset_aftinfo
    setup_instant_reset if battle_phase == :intro
    # ----- Start ---- #
    
    tsbs_battler_post_start
    
    # --- Main Loop thread --- #
    loop do
      @acts = animloop
      @screen_z = screen_z_formula unless @lock_z  # update screen z
      execute_sequence # Execute sequence array
      end_phase  # Do end ~
    end
    # --- Main Loop thread --- #
  end
  # --------------------------------------------------------------------------
  # New method : Post Start (empty)
  # --------------------------------------------------------------------------
  def tsbs_battler_post_start
  end
  # --------------------------------------------------------------------------
  # New method : Execute Sequence array
  # --------------------------------------------------------------------------
  def execute_sequence
    case @acts[0]
    when SEQUENCE_POSE;               setup_pose
    when SEQUENCE_MOVE;               setup_move
    when SEQUENCE_SLIDE;              setup_slide
    when SEQUENCE_RESET;              setup_reset
    when SEQUENCE_MOVE_TO_TARGET;     setup_move_to_target
    when SEQUENCE_SCRIPT;             setup_eval_script
    when SEQUENCE_WAIT;               @acts[1].times { method_wait }
    when SEQUENCE_DAMAGE;             setup_damage
    when SEQUENCE_CAST;               setup_cast
    when SEQUENCE_VISIBLE;            @visible = @acts[1]
    when SEQUENCE_SHOW_ANIMATION;     setup_anim
    when SEQUENCE_AFTERIMAGE;         @afterimage = @acts[1]
    when SEQUENCE_FLIP;               setup_flip
    when SEQUENCE_ACTION;             setup_action
    when SEQUENCE_PROJECTILE_SETUP;   setup_projectile
    when SEQUENCE_PROJECTILE;         show_projectile
    when SEQUENCE_USER_DAMAGE;        setup_user_damage
    when SEQUENCE_LOCK_Z;             @lock_z = @acts[1]
    when SEQUENCE_ICON;               setup_icon
    when SEQUENCE_SOUND;              setup_sound
    when SEQUENCE_IF;                 setup_branch
    when SEQUENCE_TIMED_HIT;          setup_timed_hit
    when SEQUENCE_SCREEN;             setup_screen
    when SEQUENCE_ADD_STATE;          setup_add_state
    when SEQUENCE_REM_STATE;          setup_rem_state  
    when SEQUENCE_CHANGE_TARGET;      setup_change_target
    when SEQUENCE_SHOW_PICTURE;       setup_show_picture
    when SEQUENCE_TARGET_MOVE;        setup_target_move
    when SEQUENCE_TARGET_SLIDE;       setup_target_slide
    when SEQUENCE_TARGET_RESET;       setup_target_reset
    when SEQUENCE_BLEND;              @blend = @acts[1]
    when SEQUENCE_FOCUS;              setup_focus
    when SEQUENCE_UNFOCUS;            setup_unfocus
    when SEQUENCE_TARGET_LOCK_Z;      setup_target_z
      # New update list v1.1
    when SEQUENCE_ANIMTOP;            $game_temp.anim_top = 1
    when SEQUENCE_FREEZE;             $game_temp.global_freeze = @acts[1]
    when SEQUENCE_CSTART;             setup_cutin
    when SEQUENCE_CFADE;              setup_cutin_fade
    when SEQUENCE_CMOVE;              setup_cutin_slide
    when SEQUENCE_TARGET_FLIP;        setup_targets_flip
    when SEQUENCE_PLANE_ADD;          setup_add_plane
    when SEQUENCE_PLANE_DEL;          setup_del_plane
    when SEQUENCE_BOOMERANG;          @boomerang = true
    when SEQUENCE_PROJ_AFTERIMAGE;    @proj_afimg = true
    when SEQUENCE_BALLOON;            self.balloon_id = @acts[1]
      # New update list v1.2
    when SEQUENCE_LOGWINDOW;          setup_log_message
    when SEQUENCE_LOGCLEAR;           SceneManager.scene.log_window.clear
    when SEQUENCE_AFTINFO;            setup_aftinfo
    when SEQUENCE_SMMOVE;             setup_smooth_move
    when SEQUENCE_SMSLIDE;            setup_smooth_slide
    when SEQUENCE_SMTARGET;           setup_smooth_move_target
    when SEQUENCE_SMRETURN;           setup_smooth_return
      # New update list v1.3
    when SEQUENCE_LOOP;               setup_loop
    when SEQUENCE_WHILE;              setup_while
    when SEQUENCE_COLLAPSE;           tsbs_perform_collapse_effect
    when SEQUENCE_FORCED;             setup_force_act
    when SEQUENCE_ANIMBOTTOM;         $game_temp.anim_top = -1
    when SEQUENCE_CASE;               setup_switch_case
    when SEQUENCE_INSTANT_RESET;      setup_instant_reset
    when SEQUENCE_ANIMFOLLOW;         $game_temp.anim_follow = true
    when SEQUENCE_CHANGE_SKILL;       setup_change_skill
      # Interesting on addons?
    else;                             custom_sequence_handler
    end
  end
  # --------------------------------------------------------------------------
  # New method : End fiber loop phase
  # --------------------------------------------------------------------------
  def end_phase
    next_anim_index
    @finish = @anim_index == 0
    if temporary_phase? && @finish
      self.force_change_battle_phase(:idle)
    end
    Fiber.yield while @finish && !loop? 
    # Forever wait if finished and not loop
  end
  # --------------------------------------------------------------------------
  # New method : Setup pose [:pose,]
  # --------------------------------------------------------------------------
  def setup_pose
    return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
    @battler_index = @acts[1]         # Battler index
    @anim_cell = @acts[2]             # Change cell
    @icon_key = @acts[4] if @acts[4]  # Icon call
    @icon_key = @acts[5] if @acts[5] && flip  # Icon call
    @acts[3].times do                 # Wait time
      method_wait
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup movement [:move,]
  # --------------------------------------------------------------------------
  def setup_move
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    @move_obj.clear_move_info
    goto(@acts[1], @acts[2], @acts[3], @acts[4])
  end
  # --------------------------------------------------------------------------
  # New method : Setup slide [:slide,]
  # --------------------------------------------------------------------------
  def setup_slide
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    @move_obj.clear_move_info
    xpos = (flip ? -@acts[1] : @acts[1])
    ypos = @acts[2]
    slide(xpos, ypos, @acts[3], @acts[4])
  end
  # --------------------------------------------------------------------------
  # New method : Setup reset [:goto_oripost,]
  # --------------------------------------------------------------------------
  def setup_reset
    @move_obj.clear_move_info
    goto(@ori_x, @ori_y, @acts[1], @acts[2])
  end
  # --------------------------------------------------------------------------
  # New method : Setup move to target [:move_to_target,]
  # --------------------------------------------------------------------------
  def setup_move_to_target
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    @move_obj.clear_move_info
    if area_flag
      size = target_array.size
      xpos = target_array.inject(0) {|r,battler| r + battler.x}/size
      ypos = target_array.inject(0) {|r,battler| r + battler.y}/size
      xpos *= -1 if flip
      # Get the center coordinate of enemies
      goto(xpos, ypos, @acts[3], @acts[4])
      return
    end
    xpos = target.x + (flip ? -@acts[1] : @acts[1])
    ypos = target.y
    goto(xpos, ypos, @acts[3], @acts[4])
  end
  # --------------------------------------------------------------------------
  # New method : Display Error
  # --------------------------------------------------------------------------
  def display_error(mode,err)
    ErrorSound.play
    id = data_battler.id
    seq_key = phase_sequence[battle_phase].call
    phase = (dead? ? :dead : battle_phase)
    klass = data_battler.class
    result = "Theolized SBS : "+
    "Error occured on #{klass} in ID #{id}\n" +
    "Sequence key \"#{seq_key}\" In script call #{mode}.\n\n " +
    "#{err.to_s}\n\n" +
    "Check your script call. If you still have no idea, ask for support " +
    "in RPG Maker forums"
    raise result
    exit
  end
  # --------------------------------------------------------------------------
  # New method : Setup eval script [:script,]
  # --------------------------------------------------------------------------
  def setup_eval_script
    begin
      eval(@acts[1])
    rescue StandardError => err
      display_error("[#{SEQUENCE_SCRIPT},]",err)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup damage [:target_damage,]
  # --------------------------------------------------------------------------
  def setup_damage
    item = copy(item_in_use) 
    # Copy item. In case if you want to modify anything :P
    
    # ----- Evaluate skill ------- #
    if @acts[1].is_a?(String) # Change formula? No prob ~
      item.damage.formula = @acts[1]
    elsif @acts[1].is_a?(Integer) # Skill link? No prob ~
      item = $data_skills[@acts[1]]
    elsif @acts[1].is_a?(Float) # Rescale damage? No prob ~
      item.damage.formula = "(#{item.damage.formula}) * #{@acts[1]}"
    end
    
    # ------- Check target scope ------- #
    if area_flag && target_array
      # Damage to all targets ~
      target_array.uniq.each do |target|
        SceneManager.scene.tsbs_invoke_item(target, item)
        # Check animation guard
        if !item.ignore_anim_guard? && item.parallel_anim?
          target.anim_guard = target.anim_guard_id
          target.anim_guard_mirror = target.flip
        end
      end
    elsif target
      # Damage to single target
      SceneManager.scene.tsbs_invoke_item(target, item)
      # Check animation guard
      if !item.ignore_anim_guard? && item.parallel_anim?
        target.anim_guard = target.anim_guard_id
        target.anim_guard_mirror = target.flip
      end
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup cast [:cast,]
  # --------------------------------------------------------------------------
  def setup_cast
    self.animation_id = @acts[1] || item_in_use.animation_id
    self.animation_mirror = (@acts[2].nil? ? flip : @acts[2])
  end
  # --------------------------------------------------------------------------
  # New method : Setup animation [:show_anim,]
  # --------------------------------------------------------------------------
  def setup_anim
    if area_flag
      target_array.uniq.each do |target|
        setup_target_anim(target, @acts)
      end
    else
      setup_target_anim(target, @acts)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup target animation
  # --------------------------------------------------------------------------
  def setup_target_anim(target, ary)
    return unless target
    anim_id = target.anim_guard_id  # Animation guard
    is_self = target == self        # Determine if self
    # ------------------------------------------------------------------------
    # Animation guard activation conditions
    # ------------------------------------------------------------------------
    condition = !is_self && anim_id > 0 && !item_in_use.damage.recover? &&
      !item_in_use.ignore_anim_guard? && !ary[3] && !item_in_use.parallel_anim?
    # ------------------------------------------------------------------------
    # Condition list :
    # > Animation guard won't be played to self targeting
    # > Animation guard won't be played if the index is 0 or less
    # > Animation guard won't be played if item/skill is recovery
    # > Animation guard won't be played if item/skill ignores it
    # > Animation guard won't be played if explicitly ignores in sequence
    # > Animation guard won't be played if item is parallel animation. Instead,
    #   it will be played simultaneously when [:target_damage,] is triggered
    # ------------------------------------------------------------------------
    # If anim_id explicitly given
    if ary[1]
      result_anim = (condition && ary[1] > 0 ? anim_id : ary[1])
      target.animation_id = result_anim
      target.animation_mirror = flip || ary[2]
    # If self is an Actor and skill/item use normal attack animation
    elsif self.is_a?(Game_Actor) && item_in_use.animation_id == -1
      result_anim = (condition ? anim_id : atk_animation_id1)
      target.animation_id = result_anim
      target.animation_mirror = flip || ary[2]
    # If anything ...
    else
      result_anim = (condition ? anim_id : item_in_use.animation_id)
      target.animation_id = result_anim
      target.animation_mirror = flip || ary[2]
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup battler flip [:flip,]
  # --------------------------------------------------------------------------
  def setup_flip
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    if @acts[1] == :toggle
      @flip = !@flip 
    elsif @acts[1] == :ori
      @flip = default_flip
    else
      @flip = @acts[1]
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup actions [:action,]
  # --------------------------------------------------------------------------
  def setup_action
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    actions = TSBS::AnimLoop[@acts[1]]
    if actions.nil?
      show_action_error(@acts[1])
    end
    @sequence_stack.push(@acts[1])
    @used_sequence = @acts[1]
    actions.each do |acts|
      @acts = acts
      execute_sequence
    end
    @sequence_stack.pop
    @used_sequence = @sequence_stack[-1]
  end
  # --------------------------------------------------------------------------
  # New method : Setup projectile [:proj_setup,]
  # --------------------------------------------------------------------------
  def setup_projectile
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    @proj_start = @acts[1]
    @proj_end = @acts[2]
  end
  # --------------------------------------------------------------------------
  # New method : Show projectile [:projectile,]
  # --------------------------------------------------------------------------
  def show_projectile
    return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
    if area_flag
      target_array.uniq.each do |target|
        get_spriteset.add_projectile(make_projectile(target))
      end
    else
      get_spriteset.add_projectile(make_projectile(target))
    end
    # Turn off extra projectile flag
    @boomerang = false
    @proj_afimg = false
  end
  # --------------------------------------------------------------------------
  # New method : Make Projectile
  # --------------------------------------------------------------------------
  def make_projectile(target)
    spr_self = get_spriteset.get_sprite(self)
    proj = Sprite_Projectile.new
    proj.x = self.screen_x
    case @proj_start
    when :feet
      proj.y = self.screen_y
    when :middle
      proj.y = self.screen_y - spr_self.height/2
    when :head
      proj.y = self.screen_y - spr_self.height
    end
    proj.subject = self
    proj.target = target
    proj.item = item_in_use
    ico = @acts[4]
    icon_index = 0
    begin
      icon_index = (ico.is_a?(String) ? eval(ico) : (ico.nil? ? 0 : ico))
    rescue StandardError => err
      display_error("[#{SEQUENCE_PROJECTILE},]",err)
    end
    proj.icon = icon_index
    tx = target.x
    anim = $data_animations[@acts[1]]
    dur = @acts[2]
    jump = @acts[3]
    proj.angle_speed = @acts[5] || 0
    proj.boomerang = @boomerang
    proj.afterimage = @proj_afimg
    proj.target_aim = @proj_end
    proj.make_aim(dur, jump)
    proj.start_animation(anim)
    return proj
  end
  # --------------------------------------------------------------------------
  # New method : User damage [:user_damage]
  # TBH, I think it's not really necessary since you could change the target
  # to self by adding [:change_target, 11],  :/
  # --------------------------------------------------------------------------
  def setup_user_damage
    item = item_in_use
    if @acts[1].is_a?(String)
      item.damage.formula = @acts[1]
    elsif @acts[1].is_a?(Integer)
      item = $data_skills[@acts[1]]
    elsif @acts[1].is_a?(Float)
      item.damage.formula = "(#{item.damage.formula}) * #{@acts[1]}"
    end
    SceneManager.scene.tsbs_invoke_item(self, item)
  end
  # --------------------------------------------------------------------------
  # New method : Setup weapon icon [:icon,]
  # --------------------------------------------------------------------------
  def setup_icon
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    @icon_key = @acts[1]
    @icon_key = @acts[2] if @acts[2] && flip
  end
  # --------------------------------------------------------------------------
  # New method : Setup sound [:sound,]
  # --------------------------------------------------------------------------
  def setup_sound
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    name = @acts[1]
    vol = @acts[2] || 100
    pitch = @acts[3] || 100
    RPG::SE.new(name,vol,pitch).play
  end
  # --------------------------------------------------------------------------
  # New method : Setup conditional branch
  # --------------------------------------------------------------------------
  def setup_branch
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    act_true = @acts[2]
    act_false = @acts[3]
    bool = false
    begin # Test the script call condition
      bool = eval(@acts[1])
    rescue StandardError => err
      # Blame the script user if error :v
      display_error("[#{SEQUENCE_IF},]",err)
    end
    act_result = (bool ? act_true : (!act_false.nil? ? act_false: nil))
    if act_result
      is_array = act_result.is_a?(Array)
      if is_array && act_result[0].is_a?(Array)
        act_result.each do |action|
          next unless action.is_a?(Array)
          @acts = action
          execute_sequence
        end
      elsif is_array
        @acts = act_result
        execute_sequence
      else
        @acts = [:action, act_result]
        execute_sequence
      end
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup timed hit system (BETA)
  # Will expand it later. I hope ~
  # --------------------------------------------------------------------------
  def setup_timed_hit
    @timed_hit = false
    @timed_hit_count = @acts[1]
  end
  # --------------------------------------------------------------------------
  # New method : Setup screen
  # --------------------------------------------------------------------------
  def setup_screen
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    screen = $game_troop.screen
    case @acts[1]
    when Screen_Tone
      return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
      tone = @acts[2]
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
      color = @acts[2]
      duration = @acts[3]
      screen.start_flash(color, duration)
    when Screen_Normalize
      return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
      tone = Tone.new
      duration = @acts[2]
      screen.start_tone_change(tone, duration)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup add state [:add_state,]
  # --------------------------------------------------------------------------
  def setup_add_state
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    c = @acts[2] || 100
    c = c/100.0 if c.integer?
    if area_flag
      target_array.each do |t|
        cx = c
        if !@acts[3]
          cx *= target.state_rate(@acts[1]) if opposite?(self)
          cx *= target.luk_effect_rate(self) if opposite?(self)
        end
        t.add_state(@acts[1]) if chance(cx)
      end
      return
    end
    return unless target
    if !@acts[3]
      c *= target.state_rate(@acts[1]) if opposite?(self)
      c *= target.luk_effect_rate(self) if opposite?(self)
    end
    target.add_state(@acts[1]) if chance(c)
  end
  # --------------------------------------------------------------------------
  # New method : Setup remove state [:rem_state,]
  # --------------------------------------------------------------------------
  def setup_rem_state
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    c = @acts[2] || 100
    c = c/100.0 if c.integer?
    if area_flag
      target_array.each do |t|
        t.remove_state(@acts[1]) if chance(c)
      end
      return
    end
    target.remove_state(@acts[1]) if chance(c)
  end
  # --------------------------------------------------------------------------
  # New method : Setup change target [:change_target,]
  # --------------------------------------------------------------------------
  def setup_change_target
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    case @acts[1]
    # --------------------
    when 0  # Original Target
      self.area_flag = item_in_use.area?
      @target = @ori_target
      @target_array = @ori_targets.clone
    # -------------------
    when 1  # All Battler
      self.area_flag = true
      t = $game_party.alive_members + $game_troop.alive_members
      @target_array = t
      $game_temp.battler_targets += t
    # -------------------
    when 2  # All Battler except user
      self.area_flag = true
      t = $game_party.alive_members + $game_troop.alive_members
      t -= [self]
      @target_array = t
      $game_temp.battler_targets += t
    # -------------------
    when 3  # All Enemies
      self.area_flag = true
      t = opponents_unit.alive_members
      @target_array = t
      $game_temp.battler_targets += t
    # -------------------
    when 4  # All Enemies except current target
      self.area_flag = true
      t = opponents_unit.alive_members
      t -= [target]
      @target_array = t
      $game_temp.battler_targets += t
    # -------------------
    when 5  # All Allies
      self.area_flag = true
      t = friends_unit.alive_members
      @target_array = t
      $game_temp.battler_targets += t
    # -------------------
    when 6  # All Allies except user
      self.area_flag = true
      t = friends_unit.alive_members
      t -= [self]
      @target_array = t
      $game_temp.battler_targets += t
    # -------------------
    when 7  # Next random enemy
      self.area_flag = false
      @target = opponents_unit.random_target
      $game_temp.battler_targets += [@target]
    # -------------------
    when 8  # Next random ally
      self.area_flag = false
      @target = friends_unit.random_target
      $game_temp.battler_targets += [@target]
    # -------------------
    when 9  # Absolute Targets (Enemies)
      self.area_flag = true
      @target_array = opponents_unit.abs_target(@acts[2])
      @target_array -= [target] if @acts[3]
      $game_temp.battler_targets += @target_array
    # -------------------
    when 10 # Absolute Target (Allies)
      self.area_flag = true
      @target_array = friends_unit.abs_target(@acts[2])
      @target_array -= [target] if @acts[3]
      $game_temp.battler_targets += @target_array
    # -------------------
    when 11 # self
      self.area_flag = false
      @target = self
      $game_temp.battler_targets += [@target]
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup new picture (not tested) [:show_pic,]
  # Seriously, it's not tested yet. I just looked at the default script, how
  # to call picture. And I merely put the method here without testing
  # --------------------------------------------------------------------------
  def setup_show_picture
    pictures = $game_troop.screen.pictures
    id = @acts[1]
    name = @acts[2]
    ori = @acts[3]
    xpos = @acts[4]
    ypos = @acts[5]
    zx = @acts[6]
    zy = @acts[7]
    op = @acts[8]
    blend = @acts[9]
    args = [name, ori, xpos, ypos, zx, zy, op, blend]
    pictures[id].show(*args)
  end
  # --------------------------------------------------------------------------
  # New method : Setup target movement [:target_move,]
  # --------------------------------------------------------------------------
  def setup_target_move
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    args = [@acts[1], @acts[2], @acts[3], @acts[4]]
    if area_flag
      target_array.each do |target|
        target.goto(*args)
      end
      return
    end
    target.goto(*args)
  end
  # --------------------------------------------------------------------------
  # New method : Setup target slide [:target_slide,]
  # --------------------------------------------------------------------------
  def setup_target_slide
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    args = [@acts[1], @acts[2], @acts[3], @acts[4]]
    if area_flag
      target_array.each do |target|
        target.slide(*args)
      end
      return
    end
    target.slide(*args)
  end
  # --------------------------------------------------------------------------
  # New method : Setup target reset [:target_reset]
  # --------------------------------------------------------------------------
  def setup_target_reset
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    if area_flag
      target_array.each do |target|
        target.reset_pos(@acts[1],@acts[2])
      end
      return
    end
    target.reset_pos(@acts[1],@acts[2])
  end
  # --------------------------------------------------------------------------
  # New method : Setup focus [:focus,]
  # --------------------------------------------------------------------------
  def setup_focus
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    sprset = get_spriteset
    rect = sprset.focus_bg.bitmap.rect
    color = @acts[2] || Focus_BGColor
    sprset.focus_bg.bitmap.fill_rect(rect,color)  # Recolor focus background
    sprset.focus_bg.fadein(@acts[1])        # Trigger fadein
    sprset.battler_sprites.select do |spr|
      !spr.battler.nil? # Select avalaible battler
    end.each do |spr|
      if spr.battler != self && (spr.battler.actor? ? true : spr.battler.alive?)
        spr.fadeout(@acts[1]) if !target_array.include?(spr.battler)
        spr.fadein(@acts[1]) if target_array.include?(spr.battler)
      end
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup unfocus [:unfocus,]
  # --------------------------------------------------------------------------
  def setup_unfocus
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    sprset = get_spriteset
    sprset.focus_bg.fadeout(@acts[1])
    sprset.battler_sprites.select do |spr|
      !spr.battler.nil? # Select avalaible battler
    end.each do |spr|
      spr.fadein(@acts[1]) if spr.battler.alive? || spr.battler.actor?
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup target lock Z [:target_lock_z,]
  # --------------------------------------------------------------------------
  def setup_target_z
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    if area_flag
      target_array.each do |target|
        target.lock_z = @acts[1]
      end
      return
    end
    target.lock_z = @acts[1]
  end
  # --------------------------------------------------------------------------
  # New method : Cutin Start [:cutin_start,]
  # --------------------------------------------------------------------------  
  def setup_cutin
    return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
    #-------------------------------------------------------------------------
    file = @acts[1]         # Filename
    x = @acts[2]            # X Position
    y = @acts[3]            # Y Position
    opa = @acts[4] || 255   # Opacity (default: 255)
    zx = @acts[5] || 1.0    # Zoom X  (default: 1.0)
    zy = @acts[6] || 1.0    # Zoom Y  (default: 1.0)
    #-------------------------------------------------------------------------
    get_spriteset.cutin.start(file,x,y,opa,zx,zy)
  end
  # --------------------------------------------------------------------------
  # New method : Cutin Fade [:cuitn_fade,]
  # --------------------------------------------------------------------------  
  def setup_cutin_fade
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    get_spriteset.cutin.fade(@acts[1], @acts[2])
  end
  # --------------------------------------------------------------------------
  # New method : Cutin Slide [:cutin_slide,]
  # --------------------------------------------------------------------------  
  def setup_cutin_slide
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    get_spriteset.cutin.slide(@acts[1], @acts[2], @acts[3])
  end
  # --------------------------------------------------------------------------
  # New method : Setup Targets flip [:target_flip,]
  # --------------------------------------------------------------------------  
  def setup_targets_flip
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    if area_flag
      target_array.each do |target|
        target.flip = @acts[1]
      end
      return
    end
    target.flip = @acts[1]
  end
  # --------------------------------------------------------------------------
  # New method : Setup Add Plane [:plane_add,]
  # --------------------------------------------------------------------------    
  def setup_add_plane
    return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 3
    file = @acts[1]
    sox = @acts[2] # Scroll X
    soy = @acts[3] # Scroll Y 
    z = (@acts[4] ? 400 : 4)
    dur = @acts[5] || 2
    get_spriteset.battle_plane.set(file,sox,soy,z,dur)
  end
  # --------------------------------------------------------------------------
  # New method : Setup Delete Plane [:plane_del,]
  # --------------------------------------------------------------------------    
  def setup_del_plane
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    fade = @acts[1]
    get_spriteset.battle_plane.fadeout(fade)
  end
  # --------------------------------------------------------------------------
  # New method : Setup Log Message Window [:log,]
  # --------------------------------------------------------------------------
  def setup_log_message
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    text = @acts[1].gsub(/<name>/i) { self.name }
    text.gsub!(/<target>/) { target.name rescue "" }
    SceneManager.scene.log_window.add_text(text)
  end
  # --------------------------------------------------------------------------
  # New method : Setup Afterimage Information [:aft_info,]
  # --------------------------------------------------------------------------
  def setup_aftinfo
    @afrate = @acts[1] || 3
    @afopac = @acts[2] || 20
  end
  # --------------------------------------------------------------------------
  # New method : Smooth Moving [:sm_move,]
  # --------------------------------------------------------------------------
  def setup_smooth_move
    tx = @acts[1] || x
    ty = @acts[2] || y
    dur = @acts[3] || 25
    rev = @acts[4]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  # --------------------------------------------------------------------------
  # New method : Smooth Sliding [:sm_slide,]
  # --------------------------------------------------------------------------
  def setup_smooth_slide
    tx = @acts[1] + x || 0
    ty = @acts[2] + y || 0
    dur = @acts[3] || 25
    rev = @acts[4]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  # --------------------------------------------------------------------------
  # New method : Smooth Move to target [:sm_target,]
  # --------------------------------------------------------------------------
  def setup_smooth_move_target
    if area_flag
      size = target_array.size
      xpos = target_array.inject(0) {|r,battler| r + battler.x}/size
      ypos = target_array.inject(0) {|r,battler| r + battler.y}/size
      xpos *= -1 if flip
      rev = @acts[3]
      rev = true if rev.nil?
      smooth_move(xpos, ypos, @acts[3])
      return
    end
    return unless target
    tx = @acts[1] + target.x || 0
    ty = @acts[2] + target.y || 0
    tx *= -1 if flip
    dur = @acts[3] || 25
    rev = @acts[4]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  # --------------------------------------------------------------------------
  # New method : Smooth return [:sm_return,]
  # --------------------------------------------------------------------------
  def setup_smooth_return
    tx = @ori_x
    ty = @ori_y
    dur = @act[1] || 25
    rev = @acts[2]
    rev = true if rev.nil?
    smooth_move(tx,ty,dur,rev)
  end
  # --------------------------------------------------------------------------
  # New method : Setup loop [:loop,]
  # --------------------------------------------------------------------------
  def setup_loop
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    count = @acts[1]
    action_key = @acts[2]
    count.times do
      @acts = [:action, action_key]
      execute_sequence
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup 'while' mode loop [:while]
  # --------------------------------------------------------------------------
  def setup_while
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    cond = @acts[1]
    action_key = @acts[2]
    actions = TSBS::AnimLoop[action_key]
    if actions.nil?
      show_action_error(action_key)
    end
    begin
      while eval(cond)
        exe_act = actions.clone
        until exe_act.empty?
          @acts = exe_act.shift
          execute_sequence
        end
      end
    rescue StandardError => err
      display_error("[#{SEQUENCE_WHILE},]",err)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Force action [:forced,]
  # --------------------------------------------------------------------------
  def setup_force_act
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    act_key = @acts[1]
    target.forced_act = act_key
    target.force_change_battle_phase(:forced)
  end
  # --------------------------------------------------------------------------
  # New method : Setup Switch Case [:case,]
  # --------------------------------------------------------------------------
  def setup_switch_case
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    act_result = nil
    act_hash = @acts[1]
    
    # Get valid action key
    act_hash.each do |cond, action_key|
      bool = false
      begin
        # Try to evaluate script
        bool = eval(cond)
      rescue StandardError => err
        # Blame script user if error :v
        display_error("[#{SEQUENCE_CASE},]",err)
      end
      next unless bool # If condition valid
      act_result = action_key # Assign action key
      break # Break loop checking
    end
    # Evaluate action key
    return unless act_result
    is_array = act_result.is_a?(Array)
    # If nested array (triggered if first element is array)
    if is_array && act_result[0].is_a?(Array)
      act_result.each do |action|
        next unless action.is_a?(Array)
        @acts = action
        execute_sequence
      end
    # If normal array
    elsif is_array
      @acts = act_result
      execute_sequence
    else
      @acts = [:action, act_result]
      execute_sequence
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup Instant Reset [:instant_reset,]
  # --------------------------------------------------------------------------
  def setup_instant_reset
    reset_pos(1)  # Reset position
    update_move   # Update move as well
  end
  # --------------------------------------------------------------------------
  # New method : Setup change carried skill [:change_skill,]
  # --------------------------------------------------------------------------
  def setup_change_skill
    skill = $data_skills[@acts[1]]
    return unless skill
    self.item_in_use = copy(skill)
  end
  # --------------------------------------------------------------------------
  # New method : Method for wait [:wait,]
  # --------------------------------------------------------------------------
  def method_wait
    Fiber.yield
    @screen_z = screen_z_formula unless @lock_z
    update_timed_hit if @timed_hit_count > 0
  end
  # --------------------------------------------------------------------------
  # New method : Get next symbol (not used)
  # --------------------------------------------------------------------------
  def next_is?(symbol)
    next_ary = animation_array[@anim_index + 2]
    return next_ary[0] == symbol
  end
  # --------------------------------------------------------------------------
  # New method : Forward sequence pointer
  # --------------------------------------------------------------------------
  def next_anim_index
    @anim_index = (@anim_index + 1) % (@animation_array.size - 1)
  end
  # --------------------------------------------------------------------------
  # New method : Update for timed hit
  # --------------------------------------------------------------------------
  def update_timed_hit
    if Input.trigger?(:C)
      @timed_hit = true
      @timed_hit_count = 1
      self.animation_id = TimedHit_Anim
      on_timed_hit_success
    end
    @timed_hit_count -= 1
  end
  # --------------------------------------------------------------------------
  # New method : On timed hit success ( I don't have any idea yet )
  # --------------------------------------------------------------------------
  def on_timed_hit_success
  end
  # --------------------------------------------------------------------------
  # New method : Determine if current phase is temporary phase
  # --------------------------------------------------------------------------
  def temporary_phase?
    Temporary_Phase.any? do |phase|
      battle_phase == phase
    end
  end
  # --------------------------------------------------------------------------
  # New method : Get animation sequence
  # --------------------------------------------------------------------------
  def get_animloop_array
    result = AnimLoop[phase_sequence[battle_phase].call]
    return result if result
    return rescued_error
  end
  # --------------------------------------------------------------------------
  # New method : Get current action
  # --------------------------------------------------------------------------
  def animloop
    animation_array[@anim_index + 1]
  end
  # --------------------------------------------------------------------------
  # New method : Loop?
  # --------------------------------------------------------------------------
  def loop?
    get_animloop_array[0][0]
  end
  # --------------------------------------------------------------------------
  # New method : Addons... if anyone is interested
  # --------------------------------------------------------------------------
  def custom_sequence_handler
    # For addon ...
  end
  # --------------------------------------------------------------------------
  # New method : User error handler
  # Because I don't want to be the one who is being blamed because if your
  # obvious fault
  # --------------------------------------------------------------------------
  def rescued_error
    ErrorSound.play
    id = data_battler.id
    seq_key = phase_sequence[battle_phase].call
    phase = (dead? ? :dead : battle_phase)
    klass = data_battler.class
    result = "Theolized SBS : \n"+
      "Error occured on #{klass} in ID #{id}\n" +
      "Undefined sequence key \"#{seq_key}\" for #{phase} phase\n\n" +
      "This is your fault. Not this script error!"
    raise result
    exit
  end
  # --------------------------------------------------------------------------
  # New method : Action call error handler
  # --------------------------------------------------------------------------
  def show_action_error(string)
    ErrorSound.play
    text = "Sequence key : #{phase_sequence[battle_phase].call}\n" + 
    "Uninitalized Constant for #{string} in :action mode"
    raise text
    exit
  end
  # --------------------------------------------------------------------------
  # New method : Determine if battler is busy
  # --------------------------------------------------------------------------
  def busy?
    BusyPhases.any? {|phase| battle_phase == phase }
  end
  # --------------------------------------------------------------------------
  # Alias method : Make base result (Basic Module - Core Result)
  # --------------------------------------------------------------------------
  alias tsbs_make_base_result make_base_result
  def make_base_result(user, item)
    tsbs_make_base_result(user, item)
    return unless data_battler.use_sprite
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
    if @result.evaded
      Sound.tsbs_play_eva
      self.battle_phase = :evade 
      # Automatically switch to evade phase
    end
  end
  # --------------------------------------------------------------------------
  # New method : Get state tone
  # --------------------------------------------------------------------------
  def state_tone
    result = nil
    states.each do |state|
      result = state.tone if state.tone
    end
    return result || EmptyTone
  end
  # --------------------------------------------------------------------------
  # New method : Get state color
  # --------------------------------------------------------------------------
  def state_color
    result = nil
    states.each do |state|
      result = state.color if state.color
    end
    return result || EmptyColor
  end
  # --------------------------------------------------------------------------
  # New method : Get animation guard
  # --------------------------------------------------------------------------
  def anim_guard_id
    states.each do |state|
      return state.anim_guard if state && state.anim_guard > 0
    end
    return 0
  end
  # --------------------------------------------------------------------------
  # New method : Get skills guard
  # --------------------------------------------------------------------------
  def skills_guard
    skill_guard = []
    states.each do |state|
      skill_guard.push(state.skill_guard) if state.skill_guard > 0
    end
    skill_guard.uniq.collect {|skill_id| $data_skills[skill_id]}
  end
  # --------------------------------------------------------------------------
  # New method : Get maximum opacity
  # --------------------------------------------------------------------------
  def max_opac
    unless states.empty?
      return states.collect do |state|
        state.max_opac
      end.min
    end
    return 255
  end
  # --------------------------------------------------------------------------
  # New method : State Animation
  # --------------------------------------------------------------------------
  def state_anim
    states.each do |state|
      return state.state_anim if state.state_anim > 0
    end
    return 0
  end
  # --------------------------------------------------------------------------
  # New method : Screen Z
  # --------------------------------------------------------------------------
  def screen_z
    [@screen_z,3].max
  end
  # --------------------------------------------------------------------------
  # New method : Screen Z Formula
  # --------------------------------------------------------------------------
  def screen_z_formula
    return real_ypos + additional_z rescue 0
    # Real Y position (without jumping) + Additional Z value
  end
  # --------------------------------------------------------------------------
  # New method : Additional Z Formula
  # --------------------------------------------------------------------------
  def additional_z
    battle_phase == :idle || battle_phase == :hurt ?  0 : 1
    # Action battler displayed above another (increment by 1)
  end
  # --------------------------------------------------------------------------
  # Alias method : Add state
  # --------------------------------------------------------------------------
  alias tsbs_add_state add_state
  def add_state(state_id)
    tsbs_add_state(state_id)
    if battle_phase == :idle && @used_sequence != phase_sequence[:idle].call
      self.battle_phase = :idle
      # Refresh action key if changed
    end
    @refresh_opacity = true # Refrech max opacity
  end
  # --------------------------------------------------------------------------
  # Alias method : Remove state
  # --------------------------------------------------------------------------
  alias tsbs_rem_state remove_state
  def remove_state(state_id)
    tsbs_rem_state(state_id)
    if battle_phase == :idle && @used_sequence != phase_sequence[:idle].call
      self.battle_phase = :idle
      # Refresh action key if changed
    end
    @refresh_opacity = true # Refresh max opacity
  end
  # --------------------------------------------------------------------------
  # New method : State Sequence
  # --------------------------------------------------------------------------
  def state_sequence
    states.each do |state|
      return state.sequence unless state.sequence.empty?
    end
    return nil
  end
  # --------------------------------------------------------------------------
  # Alias method : On Turn End
  # --------------------------------------------------------------------------
  alias tsbs_turn_end on_turn_end
  def on_turn_end
    tsbs_turn_end
    if $game_party.in_battle
      reset_pos(10, 0)
      # Automatically reset position on turn end
      SceneManager.scene.check_collapse(self) 
      # Check collapse for self
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : On Action End
  # --------------------------------------------------------------------------
  alias tsbs_action_end on_action_end
  def on_action_end
    tsbs_action_end
    if $game_party.in_battle
      SceneManager.scene.check_collapse(self) 
      # Check collapse for self
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Counterattack rate
  # --------------------------------------------------------------------------
  alias tsbs_counter item_cnt
  def item_cnt(user, item)
    return 0 if item.anti_counter? || dead?
    tsbs_counter(user, item)
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Reflection
  # --------------------------------------------------------------------------
  alias tsbs_reflect item_mrf
  def item_mrf(user, item)
    return 0 if item.anti_reflect? || user == self
    tsbs_reflect(user, item)
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Evasion
  # --------------------------------------------------------------------------
  alias tsbs_eva item_eva
  def item_eva(user, item)
    return 0 if item.always_hit?
    tsbs_eva(user, item)
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Hit
  # --------------------------------------------------------------------------
  alias tsbs_hit item_hit
  def item_hit(user, item)
    return 1 if item.always_hit?
    tsbs_hit(user, item)
  end
  # --------------------------------------------------------------------------
  # New method : Counter skill id
  # Stored in array for future use. In case if you want to make addon (or such)
  # For randomized counterattack skill
  # --------------------------------------------------------------------------
  def counter_skills_id
    [data_battler.counter_skill]
  end
  # --------------------------------------------------------------------------
  # New method : Counter skill
  # --------------------------------------------------------------------------
  def make_counter_skill
    skill_id = counter_skills_id[rand(counter_skills_id.size)]
    return $data_skills[skill_id]
  end
  # --------------------------------------------------------------------------
  # New method : State Transformation Name
  # --------------------------------------------------------------------------
  def state_trans_name
    states.each do |state|
      return state.trans_name unless state.trans_name.empty?
    end
    return ""
  end
  
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  # --------------------------------------------------------------------------
  # Public instance variables. Compatibility with Basic Movement
  # --------------------------------------------------------------------------
  attr_accessor :x
  attr_accessor :y
  # --------------------------------------------------------------------------
  # Alias method : setup
  # --------------------------------------------------------------------------
  alias theo_tsbs_actor_setup setup
  def setup(id)
    self.x = 0
    self.y = 0
    theo_tsbs_actor_setup(id)
    @battler_name = data_battler.battler_name
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Fiber object thread
  # --------------------------------------------------------------------------
  def fiber_obj
    $game_temp.actors_fiber[index]
  end
  # --------------------------------------------------------------------------
  # Alias method : On Battle Start
  # --------------------------------------------------------------------------
  alias tsbs_on_bs_start on_battle_start
  def on_battle_start
    self.x = @ori_x
    self.y = @ori_y
    if data_battler.intro_key.empty?
      reset_pos(1) 
      update_move
    end
    tsbs_on_bs_start
  end
  # --------------------------------------------------------------------------
  # New method : Original X position
  # --------------------------------------------------------------------------
  def original_x
    ActorPos[index][0]
  end
  # --------------------------------------------------------------------------
  # New method : Original Y position
  # --------------------------------------------------------------------------
  def original_y
    ActorPos[index][1]
  end
  # --------------------------------------------------------------------------
  # New method : Screen X
  # Define sprite reposition formula here. Such as camera
  # Do not ever change the :x
  # --------------------------------------------------------------------------
  def screen_x
    return x
  end
  # --------------------------------------------------------------------------
  # New method : Screen Y
  # Define sprite reposition formula here. Such as camera
  # Do not ever change the :y
  # --------------------------------------------------------------------------
  def screen_y
    return y
  end
  # --------------------------------------------------------------------------
  # New method : Screen Z
  # --------------------------------------------------------------------------
  def screen_z
    super
  end
  # --------------------------------------------------------------------------
  # Overwrite method : use sprite
  # --------------------------------------------------------------------------
  def use_sprite?
    return true
  end
  # --------------------------------------------------------------------------
  # New method : Actor's battler bame
  # Base Name + State Name + _index 
  # --------------------------------------------------------------------------
  def battler_name
    return "#{@battler_name+state_trans_name}_#{battler_index}"
  end
  # --------------------------------------------------------------------------
  # New method : Actor's Hue
  # --------------------------------------------------------------------------
  def battler_hue
    return 0
  end
  # --------------------------------------------------------------------------
  # New method : Data Battler
  # --------------------------------------------------------------------------
  def data_battler
    actor
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Remove perform damage effect
  # --------------------------------------------------------------------------
  def perform_damage_effect
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Remove perform collapse effect
  # --------------------------------------------------------------------------
  alias tsbs_perform_collapse_effect perform_collapse_effect
  def perform_collapse_effect
    if !collapse_key.empty?
      self.battle_phase = :collapse
    end
  end
  # --------------------------------------------------------------------------
  # New method : init oripost
  # --------------------------------------------------------------------------
  def init_oripost
    @ori_x = original_x
    @ori_y = original_y
  end
  # --------------------------------------------------------------------------
  # Alias method : Attack skill ID
  # --------------------------------------------------------------------------
  alias tsbs_atk_id attack_skill_id
  def attack_skill_id
    return sort_states.find {|state| $data_states[state].attack_id > 0} if 
      sort_states.any?{ |state| $data_states[state].attack_id > 0}
    return weapons[0].attack_id if weapons[0] ? weapons[0].attack_id > 0 : 
      false
    return $data_classes[class_id].attack_id if 
      $data_classes[class_id].attack_id > 0
    return $data_actors[id].attack_id if $data_actors[id].attack_id > 0
    return tsbs_atk_id
  end
  # --------------------------------------------------------------------------
  # Alias method : Guard skill ID
  # --------------------------------------------------------------------------
  alias tsbs_grd_id guard_skill_id
  def guard_skill_id
    return sort_states.find {|state| $data_states[state].guard_id > 0} if 
       sort_states.any? { |state| $data_states[state].guard_id > 0}
    return $data_classes[class_id].guard_id if 
    $data_classes[class_id].guard_id > 0
    return $data_actors[id].guard_id if $data_actors[id].guard_id > 0
    return tsbs_grd_id
  end
  
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  attr_reader :collapsed
  # --------------------------------------------------------------------------
  # Alias methods : Compatibility with Basic Movement
  # --------------------------------------------------------------------------
  alias x screen_x
  alias y screen_y
  # --------------------------------------------------------------------------
  # Alias method : Initialize
  # --------------------------------------------------------------------------
  alias tsbs_enemy_init initialize
  def initialize(index, enemy_id)
    tsbs_enemy_init(index, enemy_id)
    @flip = default_flip
  end
  # --------------------------------------------------------------------------
  # Alias method : On Battle Start
  # --------------------------------------------------------------------------
  alias tsbs_on_bs_start on_battle_start
  def on_battle_start
    tsbs_on_bs_start
    @ori_x = x
    @ori_y = y
    return unless data_battler.use_sprite
    @anim_index = rand(get_animloop_array.size - 1) rescue rescued_error
    @collapsed = false
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Fiber object thread
  # --------------------------------------------------------------------------
  def fiber_obj
    $game_temp.enemies_fiber[index]
  end
  # --------------------------------------------------------------------------
  # New method : Set X Position
  # --------------------------------------------------------------------------
  def x=(x)
    @screen_x = x
  end
  # --------------------------------------------------------------------------
  # New method : Set Y Position
  # --------------------------------------------------------------------------
  def y=(y)
    @screen_y = y
  end
  # --------------------------------------------------------------------------
  # New method : Data Battler
  # --------------------------------------------------------------------------
  def data_battler
    enemy
  end
  # --------------------------------------------------------------------------
  # Alias method : Battler Name
  # --------------------------------------------------------------------------
  alias tsbs_ename battler_name
  def battler_name
    return "#{data_battler.sprite_name + state_trans_name}_#{battler_index}" if 
      data_battler.use_sprite
    return tsbs_ename + state_trans_name
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Screen Z
  # --------------------------------------------------------------------------
  def screen_z
    super
  end
  # --------------------------------------------------------------------------
  # New method : Default flip
  # --------------------------------------------------------------------------
  def default_flip
    result = TSBS::Enemy_Default_Flip
    toggler = (!data_battler.note[DefaultFlip].nil? rescue result)
    result = !result if toggler != result
    return result
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Delete perform damage effect
  # --------------------------------------------------------------------------
  def perform_damage_effect
  end  
  # --------------------------------------------------------------------------
  # Alias method : Perform Collapse effect.
  # --------------------------------------------------------------------------
  alias tsbs_perform_collapse_effect perform_collapse_effect
  def perform_collapse_effect
    return if @collapsed
    if !collapse_key.empty?
      self.battle_phase = :collapse
    else
      tsbs_perform_collapse_effect
    end
    @collapsed = true
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles parties. Information such as gold and items is included.
# Instances of this class are referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  # --------------------------------------------------------------------------
  # Overwrite method : actor maximum battle members
  # --------------------------------------------------------------------------
  def max_battle_members
    TSBS::ActorPos.size
  end
end

#==============================================================================
# ** Sprite_Base
#------------------------------------------------------------------------------
#  A sprite class with animation display processing added.
#==============================================================================

class Sprite_Base
  # --------------------------------------------------------------------------
  # Alias method : Update Animation
  # --------------------------------------------------------------------------  
  alias tsbs_update_anim update_animation
  def update_animation
    return if $game_temp.global_freeze
    tsbs_update_anim
  end
  
end

#==============================================================================
# ** Sprite_AnimState
#------------------------------------------------------------------------------
#  This sprite is used to display battlers state animation. It's a simply
# dummy sprite that created from Sprite_Base just for play an animation. Used
# within the Sprite_Battler class
#==============================================================================

class Sprite_AnimState < Sprite_Base
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(sprite_battler, viewport = nil)
    super(viewport)
    @spr_battler = sprite_battler
    update_position
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    super
    update_position
    src_rect.set(@spr_battler.src_rect)
    self.ox = width/2
    self.oy = height
    update_state_anim
    update_visibility
  end
  # --------------------------------------------------------------------------
  # * Update sprite position
  # --------------------------------------------------------------------------
  def update_position
    move_animation(diff_x, diff_y)
    self.x = @spr_battler.x
    self.y = @spr_battler.y
    self.z = @spr_battler.z + 2
  end
  # --------------------------------------------------------------------------
  # * Update state animation
  # --------------------------------------------------------------------------
  def update_state_anim
    return if !@spr_battler.battler || animation?
    anim = $data_animations[@spr_battler.battler.state_anim]
    start_animation(anim)
  end
  # --------------------------------------------------------------------------
  # * Update animation visibility
  # --------------------------------------------------------------------------
  def update_visibility
    @ani_sprites.each do |ani_spr|
      ani_spr.visible = visible_case
    end if @ani_sprites
  end
  # --------------------------------------------------------------------------
  # * Get difference of X position
  # --------------------------------------------------------------------------
  def diff_x
    @spr_battler.x - x
  end
  # --------------------------------------------------------------------------
  # * Get difference of Y position
  # --------------------------------------------------------------------------
  def diff_y
    @spr_battler.y - y
  end
  # --------------------------------------------------------------------------
  # * Move animation alongside battler
  # --------------------------------------------------------------------------
  def move_animation(dx, dy)
    if @animation && @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # * End animation
  # --------------------------------------------------------------------------
  def end_animation
    anim = $data_animations[@spr_battler.battler.state_anim]
    if anim == @animation
      @ani_duration = @animation.frame_max * @ani_rate + 1
      @ani_sprites.each {|s| s.dispose }
      make_animation_sprites
      animation_set_sprites(@animation.frames[0])
    elsif !anim.nil?
      start_animation(anim)
    else
      super
    end
  end
  # --------------------------------------------------------------------------
  # * Visibility case
  # --------------------------------------------------------------------------
  def visible_case
    @spr_battler.opacity > 0 && @spr_battler.visible
  end
  # --------------------------------------------------------------------------
  # * Overwrite animation set sprites
  # --------------------------------------------------------------------------
  def animation_set_sprites(frame)
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @ani_bitmap1 : @ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @ani_mirror
        sprite.x = @ani_ox - cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 1 #+ i
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  # --------------------------------------------------------------------------
  # * Overwrite animation process timing
  # --------------------------------------------------------------------------
  def animation_process_timing(timing)
    timing.se.play unless @ani_duplicated
    case timing.flash_scope
    when 1
      @spr_battler.flash(timing.flash_color, timing.flash_duration * @ani_rate)
    when 2
      if viewport && !@ani_duplicated
        viewport.flash(timing.flash_color, timing.flash_duration * @ani_rate)
      end
    when 3
      @spr_battler.flash(nil, timing.flash_duration * @ani_rate)
    end
  end
  
end

#==============================================================================
# ** Sprite_AnimGuard
#------------------------------------------------------------------------------
#  This sprite handles battler animation guard. It's a simply
# dummy sprite that created from Sprite_Base just for play an animation. Used
# within the Sprite_Battler class
#==============================================================================

class Sprite_AnimGuard < Sprite_Base
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(sprite_battler, viewport = nil)
    super(viewport)
    @spr_battler = sprite_battler
    update_position
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    super
    update_position
    src_rect.set(@spr_battler.src_rect)
    self.ox = width/2
    self.oy = height
    update_anim_guard
  end
  # --------------------------------------------------------------------------
  # * Update Position
  # --------------------------------------------------------------------------
  def update_position
    move_animation(diff_x, diff_y)
    self.x = @spr_battler.x
    self.y = @spr_battler.y
    self.z = @spr_battler.z + 2
  end
  # --------------------------------------------------------------------------
  # * Update Animation Guard
  # --------------------------------------------------------------------------
  def update_anim_guard
    if @spr_battler.battler && @spr_battler.battler.anim_guard != 0
      anim_guard = @spr_battler.battler.anim_guard
      anim_mirror = @spr_battler.battler.anim_guard_mirror
      start_animation($data_animations[anim_guard],anim_mirror)
      @spr_battler.battler.anim_guard = 0
      @spr_battler.battler.anim_guard_mirror = false
    end
  end
  # --------------------------------------------------------------------------
  # * Overwrite animation set sprites
  # --------------------------------------------------------------------------
  def animation_set_sprites(frame)
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @ani_bitmap1 : @ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @ani_mirror
        sprite.x = @ani_ox - cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 1 #+ i
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  # --------------------------------------------------------------------------
  # * Get difference of X position
  # --------------------------------------------------------------------------
  def diff_x
    @spr_battler.x - x
  end
  # --------------------------------------------------------------------------
  # * Get difference of Y position
  # --------------------------------------------------------------------------
  def diff_y
    @spr_battler.y - y
  end
  # --------------------------------------------------------------------------
  # * Move animation alongside battler
  # --------------------------------------------------------------------------
  def move_animation(dx, dy)
    if @animation && @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # * Overwrite animation process timing
  # --------------------------------------------------------------------------
  def animation_process_timing(timing)
    timing.se.play unless @ani_duplicated
    case timing.flash_scope
    when 1
      @spr_battler.flash(timing.flash_color, timing.flash_duration * @ani_rate)
    when 2
      if viewport && !@ani_duplicated
        viewport.flash(timing.flash_color, timing.flash_duration * @ani_rate)
      end
    when 3
      @spr_battler.flash(nil, timing.flash_duration * @ani_rate)
    end
  end
  
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display battlers. It observes an instance of the
# Game_Battler class and automatically changes sprite states.
#==============================================================================

class Sprite_Battler < Sprite_Base
  include TSBS
  # --------------------------------------------------------------------------
  # Alias method : Initialize
  # --------------------------------------------------------------------------
  alias tsbs_init initialize
  def initialize(*args)
    tsbs_init(*args)
    @balloon_duration = 0
    @used_bitmap = []
    @anim_state = Sprite_AnimState.new(self,viewport)
    @shadow = Sprite_BattlerShadow.new(self,viewport)
    @anim_guard = Sprite_AnimGuard.new(self,viewport)
    @anim_cell = -1
  end
  # --------------------------------------------------------------------------
  # Alias method : Start Animation
  # --------------------------------------------------------------------------
  alias tsbs_start_anim start_animation
  def start_animation(anim, mirror = false)
    @anim_top = $game_temp.anim_top
    @anim_follow = $game_temp.anim_follow
    $game_temp.anim_follow = $game_temp.anim_top = false
    tsbs_start_anim(anim, mirror)
  end
  # --------------------------------------------------------------------------
  # New method : Sprite is an actor?
  # --------------------------------------------------------------------------
  def actor?
    @battler && @battler.is_a?(Game_Actor)
  end
  # --------------------------------------------------------------------------
  # Alias method : bitmap=
  # --------------------------------------------------------------------------
  alias tsbs_bitmap= bitmap=
  def bitmap=(bmp)
    self.tsbs_bitmap = bmp
    @used_bitmap.push(bmp)
    @used_bitmap.uniq!
    return unless @battler && @battler.data_battler.use_sprite && bitmap
    wr = bitmap.width / self.class::MaxCol
    hr = bitmap.height / self.class::MaxRow
    yr = 0
    xr = 0
    src_rect.set(xr,yr,wr,hr)
    update_flip
  end
  # --------------------------------------------------------------------------
  # Overwrite method : update origin
  # --------------------------------------------------------------------------
  def update_origin
    if bitmap
      unless @battler && @battler.data_battler.use_sprite
        self.ox = bitmap.width / 2
        self.oy = bitmap.height
      else
        if @anim_cell != @battler.anim_cell
          @anim_cell = @battler.anim_cell
          src_rect.y = (@anim_cell / MaxCol) * height
          src_rect.x = (@anim_cell % MaxCol) * width
        end
        self.ox = src_rect.width/2
        self.oy = height
      end
    end
  end
  # --------------------------------------------------------------------------
  # Overwrite method : revert to normal
  # --------------------------------------------------------------------------
  def revert_to_normal
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 255
    update_origin
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Init visibility
  # --------------------------------------------------------------------------
  def init_visibility
    return if actor? && !@battler.data_battler.dead_key.empty?
    @battler_visible = !@battler.hidden? && (@battler.enemy? ? 
      !@battler.collapsed : true)
    self.opacity = 0 unless @battler_visible
  end
  # --------------------------------------------------------------------------
  # Overwrite method : afterimage
  # --------------------------------------------------------------------------
  def afterimage
    super || @battler.afterimage rescue false
  end
  # --------------------------------------------------------------------------
  # New method : update afterimage info
  # --------------------------------------------------------------------------
  def update_afterimage_info
    if @battler
      @afterimage_opac = @battler.afopac
      @afterimage_rate = @battler.afrate
      return
    end
    @afterimage_opac = 20
    @afterimage_rate = 3
  end
  # --------------------------------------------------------------------------
  # Alias method : update
  # --------------------------------------------------------------------------
  alias theo_tsbs_update update
  def update
    theo_tsbs_update
    update_afterimage_info
    update_anim_state
    update_anim_guard
    update_shadow
    update_balloon
    if @battler
      update_anim_position
      update_visible
      update_flip
      update_tone
      update_start_balloon
      update_color unless effect?
      update_opacity if @battler.refresh_opacity
      update_blending if (@effect_type.nil? || @effect_type == :whiten)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Battler is busy?
  # --------------------------------------------------------------------------
  def busy?
    @battler && BusyPhases.any? do |phase|
      phase == @battler.battle_phase
    end && !@battler.finish || (@battler && @battler.moving?)
  end
  # --------------------------------------------------------------------------
  # New method : update visibility
  # --------------------------------------------------------------------------
  def update_visible
    self.visible = @battler.visible
  end
  # --------------------------------------------------------------------------
  # New method : update flip
  # --------------------------------------------------------------------------
  def update_flip
    self.mirror = @battler.flip
  end
  # --------------------------------------------------------------------------
  # New method : update battler tone
  # --------------------------------------------------------------------------
  def update_tone
    self.tone.set(@battler.state_tone)
  end
  # --------------------------------------------------------------------------
  # New method : update battler color
  # --------------------------------------------------------------------------
  def update_color
    self.color.set(@battler.state_color) if @color_flash.alpha == 0
  end
  # --------------------------------------------------------------------------
  # New method : update battler opacity
  # --------------------------------------------------------------------------
  def update_opacity
    self.opacity = @battler.max_opac
    @battler.refresh_opacity = false
  end
  # --------------------------------------------------------------------------
  # New method : update battler blend
  # --------------------------------------------------------------------------
  def update_blending
    self.blend_type = @battler.blend
  end
  # --------------------------------------------------------------------------
  # New method : update anim aid
  # --------------------------------------------------------------------------
  def update_anim_state
    @anim_state.update
  end
  # --------------------------------------------------------------------------
  # New method : update anim guard
  # --------------------------------------------------------------------------
  def update_anim_guard
    @anim_guard.update
  end
  # --------------------------------------------------------------------------
  # New method : update shadow
  # --------------------------------------------------------------------------
  def update_shadow
    @shadow.update
  end
  # --------------------------------------------------------------------------
  # New method : update start balloon
  # --------------------------------------------------------------------------  
  def update_start_balloon
    if !@balloon_sprite && @battler.balloon_id > 0
      @balloon_id = @battler.balloon_id
      start_balloon
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : Opacity=
  # --------------------------------------------------------------------------
  alias tsbs_opacity= opacity=
  def opacity=(value)
    result = [value, max_opac].min
    self.tsbs_opacity = result
  end
  # --------------------------------------------------------------------------
  # New method : Maximum opacity
  # --------------------------------------------------------------------------
  def max_opac
    return @battler.max_opac if @battler
    return 255
  end
  # --------------------------------------------------------------------------
  # Alias method : update boss collapse
  # --------------------------------------------------------------------------
  alias tsbs_boss_collapse update_boss_collapse
  def update_boss_collapse
    return tsbs_boss_collapse unless @battler && @battler.use_sprite?
    alpha = (@effect_duration * 120 / height rescue 0)
    self.ox = width / 2 + @effect_duration % 2 * 4 - 2
    self.blend_type = 1
    self.color.set(255, 255, 255, 255 - alpha)
    self.opacity = alpha
#~     self.src_rect.height -= 0.5
    Sound.play_boss_collapse2 if @effect_duration % 20 == 19
  end
  # --------------------------------------------------------------------------
  # Alias method : dispose
  # --------------------------------------------------------------------------
  alias tsbs_dispose dispose
  def dispose
    tsbs_dispose
    @used_bitmap.compact.each do |bmp|
      bmp.dispose unless bmp.disposed?
    end
    @anim_state.dispose
    @anim_guard.dispose
    @shadow.dispose
    @balloon_sprite.dispose if @balloon_sprite
  end
  # --------------------------------------------------------------------------
  # Overwrite method : animation set sprites
  # --------------------------------------------------------------------------
  def animation_set_sprites(frame)
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @ani_bitmap1 : @ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @ani_mirror
        sprite.x = @ani_ox - cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      # ---------------------------------------------
      # If animation position is to screen || on top?
      # ---------------------------------------------
      if (@animation.position == 3 && !@anim_top == -1) || @anim_top == 1
        sprite.z = self.z + 400 + i  # Always display in top
      elsif @anim_top == -1
        sprite.z = 3 + i
      else
        sprite.z = self.z + 2 + i
      end
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  #--------------------------------------------------------------------------
  # New Method : Start Balloon
  #--------------------------------------------------------------------------
  def start_balloon
    dispose_balloon
    @balloon_duration = 8 * balloon_speed + balloon_wait
    @balloon_sprite = ::Sprite.new(viewport)
    @balloon_sprite.bitmap = Cache.system("Balloon")
    @balloon_sprite.ox = 16
    @balloon_sprite.oy = 32
    update_balloon
  end
  #--------------------------------------------------------------------------
  # New Method : Free Balloon Icon
  #--------------------------------------------------------------------------
  def dispose_balloon
    if @balloon_sprite
      @balloon_sprite.dispose
      @balloon_sprite = nil
    end
  end
  #--------------------------------------------------------------------------
  # New Method : Update Balloon Icon
  #--------------------------------------------------------------------------
  def update_balloon
    if @balloon_duration > 0
      @balloon_duration -= 1
      if @balloon_duration > 0
        @balloon_sprite.x = x
        @balloon_sprite.y = y - height
        @balloon_sprite.z = z + 200
        sx = balloon_frame_index * 32
        sy = (@balloon_id - 1) * 32
        @balloon_sprite.src_rect.set(sx, sy, 32, 32)
      else
        end_balloon
      end
    end
  end
  #--------------------------------------------------------------------------
  # New Method : End Balloon Icon
  #--------------------------------------------------------------------------
  def end_balloon
    dispose_balloon
    @battler.balloon_id = 0
  end
  #--------------------------------------------------------------------------
  # New Method : Balloon Icon Display Speed
  #--------------------------------------------------------------------------
  def balloon_speed
    return 4
  end
  #--------------------------------------------------------------------------
  # New Method : Wait Time for Last Frame of Balloon
  #--------------------------------------------------------------------------
  def balloon_wait
    return 3
  end
  #--------------------------------------------------------------------------
  # New Method : Frame Number of Balloon Icon
  #--------------------------------------------------------------------------
  def balloon_frame_index
    return 7 - [(@balloon_duration - balloon_wait) / balloon_speed, 0].max
  end
  # --------------------------------------------------------------------------
  # New Method : Get difference of X position
  # --------------------------------------------------------------------------
  def diff_x
    @battler.screen_x - x
  end
  # --------------------------------------------------------------------------
  # New Method : Get difference of Y position
  # --------------------------------------------------------------------------
  def diff_y
    @battler.screen_y - y
  end
  # --------------------------------------------------------------------------
  # New Method : Move animation alongside battler
  # --------------------------------------------------------------------------
  def move_animation(dx, dy)
    if @animation && @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # New Method : Update Animation Position
  # --------------------------------------------------------------------------
  def update_anim_position
    return unless @anim_follow
    move_animation(diff_x, diff_y)
    self.x = @battler.screen_x
    self.y = @battler.screen_y
  end
  
  alias tsbs_color_flash flash
  def flash(color, duration)
    self.color.set(EmptyColor)
    tsbs_color_flash(color, duration)
  end
  
end

#==============================================================================
# ** Sprite_Projectile
#------------------------------------------------------------------------------
#  This sprite is used to display projectile. This class is used within the
# Spriteset_Battle class
#==============================================================================

class Sprite_Projectile < Sprite_Base
  # --------------------------------------------------------------------------
  # * Public accessors
  # --------------------------------------------------------------------------
  attr_accessor :subject      # Battler subject
  attr_accessor :target       # Battler target
  attr_accessor :item         # Carried item / skill
  attr_accessor :angle_speed  # Angle speed rotation
  attr_accessor :target_aim   # Target Aim
  attr_accessor :boomerang    # Boomerang Flag
  # --------------------------------------------------------------------------
  # * Import TSBS constantas
  # --------------------------------------------------------------------------
  include TSBS
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(viewport = nil)
    super
    @angle = 0.0
    @return = false
    @afterimage_opac = 17
    @afterimage_rate = 1
    @afterimage_dispose = false
  end
  # --------------------------------------------------------------------------
  # * Set icon
  # --------------------------------------------------------------------------
  def icon=(icon_index)
    icon_bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    bmp = Bitmap.new(24,24)
    bmp.blt(0, 0, icon_bitmap, rect, 255)
    self.bitmap = bmp
    self.ox = width/2
    self.oy = height/2
  end
  # --------------------------------------------------------------------------
  # * Record last coordinate
  # --------------------------------------------------------------------------
  def update_last_coordinate
    @last_x = x
    @last_y = y
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    return if $game_temp.global_freeze
    super
    return afimg_dispose if @afterimage_dispose
    @angle += angle_speed
    self.angle = @angle
    process_dispose if need_dispose?
  end
  # --------------------------------------------------------------------------
  # * Alias method : update movement
  # --------------------------------------------------------------------------
  def update_move
    update_last_coordinate
    super
    move_animation(diff_x, diff_y)
  end
  # --------------------------------------------------------------------------
  # * Need dispose flag
  # --------------------------------------------------------------------------
  def need_dispose?
    !moving?
  end
  # --------------------------------------------------------------------------
  # * Disposing sprite
  # --------------------------------------------------------------------------
  def process_dispose
    if rand < target.item_mrf(@subject, item) && !@return
      # If target has magic reflection ~
      target.animation_id = target.data_battler.reflect_anim
      target.result.reflected = true
      SceneManager.scene.damage.display_reflect(target)
      repel  # Repel the projectile back to caster
    else
      # If not ~
      if @return # If current projectile is back to caster
        dispose_method
      else
        SceneManager.scene.tsbs_apply_item(target, item, subject) # Do damage
        anim_id = target.anim_guard_id
        cond = anim_id > 0 && !item.damage.recover? && 
          !item.ignore_anim_guard? && !item.parallel_anim?
        target.animation_id = (cond ? anim_id : item.animation_id)
        target.animation_mirror = subject.flip
        if item.parallel_anim?
          target.anim_guard = anim_id 
          target.anim_guard_mirror = target.flip
        end
        if boomerang
          @jump = @jump * -1
          @return = true
          repel
        else
          dispose_method
        end
      end
    end
  end
  # --------------------------------------------------------------------------
  # * Disposal method
  # --------------------------------------------------------------------------  
  def dispose_method
    if @afterimage
       @afterimage = false
       @afterimage_dispose = true
    else
       dispose 
    end
  end
  # --------------------------------------------------------------------------
  # * Dispose self until afterimage is empty
  # --------------------------------------------------------------------------
  def afimg_dispose
    self.opacity = 0
    return unless @afterimages.empty?
    dispose
  end
  # --------------------------------------------------------------------------
  # * Difference from last X coordinate
  # --------------------------------------------------------------------------
  def diff_x
    self.x - @last_x
  end
  # --------------------------------------------------------------------------
  # * Difference from last Y coordinate
  # --------------------------------------------------------------------------
  def diff_y
    self.y - @last_y
  end
  # --------------------------------------------------------------------------
  # * Move animation
  # --------------------------------------------------------------------------
  def move_animation(dx, dy)
    if @animation && @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # * Repel projectiles for magic reflect
  # --------------------------------------------------------------------------
  def repel
    temp = subject
    if random_reflect? # Random target reflect if skill/item allow to do so
      temp = temp.friends_unit.alive_members.shuffle[0]
    end
    self.subject = target
    self.target = temp
    make_aim(@dur, @jump)
    start_animation(@animation, !@mirror)
  end
  # --------------------------------------------------------------------------
  # * Overwrite method : goto (Basic Module)
  # --------------------------------------------------------------------------
  def goto(xpos,ypos,dur=60,jump=0)
    super(xpos,ypos,dur,jump)
    @dur = dur
    @jump = jump
  end
  # --------------------------------------------------------------------------
  # * Make aim
  # --------------------------------------------------------------------------
  def make_aim(dur, jump)
    spr_target = get_spriteset.get_sprite(target)
    tx = target.screen_x
    case target_aim
    when :feet
      ty = target.screen_y
    when :middle
      ty = target.screen_y - spr_target.height/2
    when :head
      ty = target.screen_y - spr_target.height
    end
    goto(tx,ty,dur,jump)
  end
  # --------------------------------------------------------------------------
  # * Start Animation
  # --------------------------------------------------------------------------
  def start_animation(anim, mirror = false)
    @mirror = mirror
    super(anim, mirror)
  end
  # --------------------------------------------------------------------------
  # * Make Animation Loops
  # --------------------------------------------------------------------------
  def end_animation
    @ani_duration = @animation.frame_max * @ani_rate + 1
  end
  # --------------------------------------------------------------------------
  # * Random Reflection?
  # --------------------------------------------------------------------------
  def random_reflect?
    item.random_reflect?
  end
  
end

#==============================================================================
# ** Sprite_BattlerShadow
#------------------------------------------------------------------------------
#  This sprite is used to display battler's shadow. 
#==============================================================================

class Sprite_BattlerShadow < Sprite
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(sprite_battler, viewport = nil)
    @sprite_battler = sprite_battler
    super(viewport)
    self.bitmap = Cache.system("Shadow")
    update
  end
  # --------------------------------------------------------------------------
  # * Update Size
  # --------------------------------------------------------------------------
  def update_size
    self.zoom_x = @sprite_battler.width.to_f / bitmap.width.to_f 
    self.zoom_y = @sprite_battler.height.to_f / bitmap.height.to_f 
    self.ox = width/2
    self.oy = height
  end
  # --------------------------------------------------------------------------
  # * Update position
  # --------------------------------------------------------------------------
  def update_position
    if @sprite_battler.battler
      self.x = @sprite_battler.battler.screen_x
      self.y = @sprite_battler.battler.screen_z + shift_y - 
        @sprite_battler.battler.additional_z
    end
    self.z = @sprite_battler.z - 2
  end
  # --------------------------------------------------------------------------
  # * Update opacity
  # --------------------------------------------------------------------------
  def update_opacity
    self.opacity = @sprite_battler.opacity
  end
  # --------------------------------------------------------------------------
  # * Update opacity
  # --------------------------------------------------------------------------
  def update_visible
    self.visible = @sprite_battler.visible && TSBS::UseShadow
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    super
    update_size
    update_position
    update_opacity
    update_visible
  end
  # --------------------------------------------------------------------------
  # * Shift Y
  # --------------------------------------------------------------------------
  def shift_y
    return 4
  end
end

#==============================================================================
# ** Sprite_BattlerIcon
#------------------------------------------------------------------------------
#  This sprite is used to display battler's Icon. It observes icon key from
# Game_Battler class and automatically changes sprite display when triggered.
#==============================================================================

class Sprite_BattlerIcon < Sprite_Base
  attr_reader :battler  # Battler
  include TSBS          # Import TSBS constantas
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(battler, viewport = nil)
    super(viewport)
    @battler = battler
    @afterimage_opac = 20
    @afterimage_rate = 3
    @x_plus = 0
    @y_plus = 0
    @above_char = false
    @used_key = ""
    self.anchor = 0
    self.icon_index = 0
  end
  # --------------------------------------------------------------------------
  # * Set anchor origin
  # --------------------------------------------------------------------------
  def anchor=(value)
    @anchor_origin = value
    update_anchor(value)
  end
  # --------------------------------------------------------------------------
  # * Set icon index
  # --------------------------------------------------------------------------
  def icon_index=(index)
    @icon_index = index
    icon_bitmap = Cache.system("Iconset")
    rect = Rect.new(index % 16 * 24, index / 16 * 24, 24, 24)
    bmp = Bitmap.new(24,24)
    bmp.blt(0, 0, icon_bitmap, rect, 255)
    self.bitmap = bmp
  end
  # --------------------------------------------------------------------------
  # * Overwrite bitmap=
  # --------------------------------------------------------------------------
  def bitmap=(bmp)
    update_anchor(@anchor_origin)
    super
  end
  # --------------------------------------------------------------------------
  # * Update anchor origin
  # --------------------------------------------------------------------------
  def update_anchor(value)
    case value
    when 0 # Center
      self.ox = self.oy = 12
    when 1 # Upper Left
      self.ox = self.oy = 0
    when 2 # Upper Right
      self.ox = 24
      self.oy = 0
    when 3 # Bottom Left
      self.ox = 0
      self.oy = 24
    when 4 # Bottom Right
      self.ox = self.oy = 24
    else
      point = TSBS::IconAnchor[value]
      self.ox = point[0]
      self.oy = point[1]
    end
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    super
    update_placement
    update_key unless battler.icon_key.empty?
  end
  # --------------------------------------------------------------------------
  # * Update placement related to battler
  # --------------------------------------------------------------------------
  def update_placement
    self.x = battler.screen_x + @x_plus
    self.y = battler.screen_y + @y_plus
    self.z = battler.screen_z + (@above_char ? 1 : -1)
  end
  # --------------------------------------------------------------------------
  # * Update icon key
  # --------------------------------------------------------------------------
  def update_key
    actor = battler # Just make alias
    @used_key = battler.icon_key
    array = TSBS::Icons[@used_key]
    self.anchor = array[0]
    @x_plus = (battler.flip ? -array[1] : array[1])
    @y_plus = array[2]
    @above_char = array[3]
    update_placement
    self.angle = array[4]
    target = array[5]
    duration = array[6]
    if array[7].is_a?(String)
      icon_index = eval(array[7])
    elsif array[7] >= 0
      icon_index = array[7]
    elsif !array[7].nil?
      if array[7] == -1 # First weapon ~
        icon_index = (battler.weapons[0].icon_index rescue 0)
      elsif array[7] == -2 # Second weapon ~
        icon_index = (battler.weapons[1].icon_index rescue 
          (battler.weapons[0].icon_index rescue 0))
      end
    end
    self.mirror = !array[8].nil?
    icon_index = icon_index || 0
    self.icon_index = icon_index
    change_angle(target, duration)
    battler.icon_key = ""
  end
end

#==============================================================================
# ** Sprite_BattleCutin
#------------------------------------------------------------------------------
#  This sprite handles actor cutin graphic
#==============================================================================

class Sprite_BattleCutin < Sprite
  # --------------------------------------------------------------------------
  # * Start Cutin
  # --------------------------------------------------------------------------
  def start(file, x, y, opacity, zoom_x, zoom_y)
    self.bitmap = Cache.picture(file)
    self.x = x
    self.y = y
    self.opacity = opacity
    self.zoom_x = zoom_x
    self.zoom_y = zoom_y
  end
  
end

#==============================================================================
# ** Battle_Plane
#------------------------------------------------------------------------------
#  This class handles single plane to display plane (fog/parallax) in battle
# arena. It is used within Spriteset_Battle
#==============================================================================

class Battle_Plane < Plane
  attr_accessor :scroll_ox
  attr_accessor :scroll_oy
  # --------------------------------------------------------------------------
  # * Import Core fade from Basic Module
  # --------------------------------------------------------------------------
  include THEO::FADE
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    setfade_obj(self)
    @scroll_ox = 0.0
    @scroll_oy = 0.0
    @ori_ox = 0.0
    @ori_oy = 0.0
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    update_fade
    @ori_ox += @scroll_ox
    @ori_oy += @scroll_oy
    self.ox = @ori_ox
    self.oy = @ori_oy
  end
  # --------------------------------------------------------------------------
  # * Set data
  # --------------------------------------------------------------------------
  def set(file, sox, soy, z, show_dur)
    self.bitmap = Cache.picture(file)
    @scroll_ox = sox
    @scroll_oy = soy
    self.z = z
    self.opacity = 0
    fadein(show_dur)
  end
  
end

#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within the
# Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  # --------------------------------------------------------------------------
  # Public instance method
  # --------------------------------------------------------------------------
  attr_reader :projectiles    # Projectiles array
  attr_reader :focus_bg       # Focus background
  attr_reader :cutin          # Cutin sprite
  attr_reader :battle_plane   # Battle Planes
  # --------------------------------------------------------------------------
  # Alias method : Initialize
  # --------------------------------------------------------------------------
  alias tsbs_init initialize
  def initialize
    @projectiles = []
    tsbs_init
  end
  # --------------------------------------------------------------------------
  # Alias method : Create viewports
  # --------------------------------------------------------------------------
  alias tsbs_icon_create_viewport create_viewports
  def create_viewports
    tsbs_icon_create_viewport
    create_battler_icon
    create_focus_sprite
    create_cutin_sprite
    create_battle_planes
  end
  # --------------------------------------------------------------------------
  # New method : Create battler icon
  # --------------------------------------------------------------------------  
  def create_battler_icon
    @icons = []
    battlers = $game_party.battle_members + $game_troop.members
    battlers.each do |battler|
      icon = Sprite_BattlerIcon.new(battler, @viewport1)
      @icons.push(icon)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Create focus sprite
  # --------------------------------------------------------------------------  
  def create_focus_sprite
    @focus_bg = Sprite_Screen.new(@viewport1)
    @focus_bg.bitmap.fill_rect(@focus_bg.bitmap.rect, Color.new(255,255,255))
    @focus_bg.z = 3
    @focus_bg.opacity = 0
  end
  # --------------------------------------------------------------------------
  # New method : Create cutin sprite
  # --------------------------------------------------------------------------  
  def create_cutin_sprite
    @cutin = Sprite_BattleCutin.new(@viewport2)
    @cutin.z = 999
  end
  # --------------------------------------------------------------------------
  # New method : Create cutin sprite
  # --------------------------------------------------------------------------  
  def create_battle_planes
    @battle_plane = Battle_Plane.new(@viewport1)
  end
  # --------------------------------------------------------------------------
  # New method : spriteset is busy?
  # --------------------------------------------------------------------------
  def busy?
    (@enemy_sprites + @actor_sprites).any? do |sprite|
      sprite.busy?
    end
  end
  # --------------------------------------------------------------------------
  # Overwrite method : actor sprites
  # --------------------------------------------------------------------------
  def create_actors
    @actor_sprites = Array.new($game_party.max_battle_members) do 
      Sprite_Battler.new(@viewport1)
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : update
  # --------------------------------------------------------------------------
  alias tsbs_update update
  def update
    tsbs_update
    update_tsbs_extra
    update_projectiles
    update_icons
  end
  # --------------------------------------------------------------------------
  # New method : update tsbs extra graphics
  # --------------------------------------------------------------------------
  def update_tsbs_extra
    @focus_bg.update
    @cutin.update
    @battle_plane.update
  end
  # --------------------------------------------------------------------------
  # New method : update projectiles
  # --------------------------------------------------------------------------
  def update_projectiles
    @projectiles.delete_if do |proj|
      proj.update
      proj.disposed?
    end
  end
  # --------------------------------------------------------------------------
  # New method : update icons
  # --------------------------------------------------------------------------
  def update_icons
    @icons.each do |icon|
      icon.update
    end
  end
  # --------------------------------------------------------------------------
  # New method : add projectiles
  # --------------------------------------------------------------------------
  def add_projectile(proj)
    proj.viewport = @viewport1
    proj.z = 300
    @projectiles.push(proj)
  end
  # --------------------------------------------------------------------------
  # New method : is projectile avalaible?
  # --------------------------------------------------------------------------
  def projectile?
    !projectiles.empty?
  end
  # --------------------------------------------------------------------------
  # New method : get battler sprite
  # --------------------------------------------------------------------------
  def get_sprite(battler)
    battler_sprites.each do |spr|
      return spr if spr.battler == battler
    end
    return nil
  end
  # --------------------------------------------------------------------------
  # Alias method : Dispose
  # --------------------------------------------------------------------------
  alias tsbs_dispose dispose
  def dispose
    (@icons + [@focus_bg, @cutin]).each do |extra|
      extra.dispose unless extra.disposed?
    end
    @battle_plane.dispose
    tsbs_dispose
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  attr_reader :damage
  attr_reader :log_window
  # --------------------------------------------------------------------------
  # Alias method : start
  # --------------------------------------------------------------------------
  alias tsbs_start start
  def start
    tsbs_start
    @damage = DamageResults.new(@viewport)
  end
  # --------------------------------------------------------------------------
  # Alias method : post_start
  # --------------------------------------------------------------------------
  alias tsbs_post_start post_start
  def post_start
    all_battle_members.each do |batt_member|
      if batt_member.actor? && $game_party.battle_members.include?(batt_member)
        batt_member.init_oripost 
        unless batt_member.intro_key.empty?
          batt_member.reset_pos(1)
          batt_member.update_move
          batt_member.battle_phase = :intro 
          batt_member.update
        end
      end
    end
    @spriteset.update
    tsbs_post_start
  end
  # --------------------------------------------------------------------------
  # Alias method : update basic
  # --------------------------------------------------------------------------
  alias theo_tsbs_update_basic update_basic
  def update_basic
    all_battle_members.each do |batt_member|
      if batt_member.actor? && !$game_party.battle_members.include?(batt_member)
        next
      end
      batt_member.update
    end 
    theo_tsbs_update_basic
    @damage.update
  end
  # --------------------------------------------------------------------------
  # Overwrite method : use item
  # Compatibility? well, I don't really care ~
  # --------------------------------------------------------------------------
  def use_item
    item = @subject.current_action.item
    @log_window.display_use_item(@subject, item)
    @subject.use_item(item)
    refresh_status
    targets = @subject.current_action.make_targets.compact
    show_action_sequences(targets, item)
  end
  # --------------------------------------------------------------------------
  # New method : wait for sequence
  # --------------------------------------------------------------------------
  def wait_for_sequence
    update_for_wait
    update_for_wait while @spriteset.busy?
  end
  # --------------------------------------------------------------------------
  # New method : show action sequence
  # Showing action sequence for TSBS. It's kinda prochedural. Sorry ...
  # --------------------------------------------------------------------------
  def show_action_sequences(targets, item)
    $game_temp.battler_targets = targets.clone
    @subject.target_array = targets
    @subject.item_in_use = copy(item)
    # Show preparation sequence ~
    if !item.prepare_key.empty?
      @subject.target = targets[0] if targets.size == 1
      @subject.battle_phase = :prepare
      wait_for_sequence
    end    
    # Determine if item is not AoE ~
    if !item.area?
      @subject.area_flag = false
      # Repeat item sequence for target number times
      targets.each do |target|
        break if @subject.battle_phase == :forced
        # Change target if the target is currently dead
        if target.dead? && !item.for_dead_friend? 
          target = @subject.opponents_unit.random_target
          break if target.nil? # Break if there is no target avalaible
        end
        # Do sequence
        @subject.target = target
        @subject.battle_phase = :skill
        wait_for_sequence
      end
    # If item is area of effect damage. Do sequence skill only once
    else
      @subject.area_flag = true
      @subject.battle_phase = :skill
      wait_for_sequence
      @subject.area_flag = false
    end
    # Determine if item has no return sequence
    unless item.no_return? || @subject.battle_phase == :forced
      @subject.battle_phase = :return 
      wait_for_sequence
    else
      @subject.battle_phase = :idle
    end
    # Clear pointer
    @subject.item_in_use = nil
    @subject.target = nil
    # Show message log if sequence has been finished
    $game_temp.battler_targets += [@subject]
    $game_temp.battler_targets.uniq.compact.each do |target|
      @log_window.display_action_results(target, item)
      target.reset_pos(15) # Reset battler to current position
      target.result.clear
      next if target.actor?
      check_collapse(target)
    end
    # Reset damage value
    @damage.reset_value
    wait(30)
  end
  # --------------------------------------------------------------------------
  # New method : check collapse
  # --------------------------------------------------------------------------
  def check_collapse(target)
    return if target.actor? && target.collapse_key.empty?
    target.perform_collapse_effect if target.state?(target.death_state_id) || 
      ($imported["YEA-BattleEngine"] && target.can_collapse?)
  end
  # --------------------------------------------------------------------------
  # New method : Invoke item for TSBS
  # --------------------------------------------------------------------------
  def tsbs_invoke_item(target, item, subj = @subject)
    if rand < target.item_cnt(subj, item)
      tsbs_invoke_counter(target, item)
    elsif rand < target.item_mrf(subj, item)
      tsbs_invoke_mreflect(target, item)
    else
      tsbs_apply_item(apply_substitute(target, item), item, subj)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Invoke counter for TSBS
  # --------------------------------------------------------------------------
  def tsbs_invoke_counter(target, item)
    if !target.data_battler.counter_key.empty?
      target.target_array = [@subject]
      target.target = @subject
      target.item_in_use = copy(target.make_counter_skill)
      target.battle_phase = :counter
    end
    @damage.display_counter(target)
    if $imported["YEA-BattleEngine"]
      status_redraw_target(@subject)
      status_redraw_target(target) unless target == @subject
    else
      refresh_status
    end
  end
  # --------------------------------------------------------------------------
  # New method : Invoke reflect for TSBS
  # --------------------------------------------------------------------------
  def tsbs_invoke_mreflect(target, item)
    item = copy(item)
    if item.random_reflect?
      target = target.friends_unit.members.shuffle[0]
    end
    @subject.magic_reflection = true
    target.result.reflected = true
    target.animation_id = target.data_battler.reflect_anim
    # ------------------------------------------------------
    # Convert drain damage to normal damage
    # Well, I don't like the original idea of magic reflect.
    # So, deal with it
    # ------------------------------------------------------
    item.damage.type = 1 if item.damage.type == 5
    item.damage.type = 2 if item.damage.type == 6
    # ------------------------------------------------------
    tsbs_apply_item(@subject, item, target)
    @damage.display_reflect(target)
    @subject.animation_id = item.reflect_anim
    @subject.magic_reflection = false
    if @subject.actor?
      @status_window.refresh 
    end
    if $imported["YEA-BattleEngine"]
      status_redraw_target(@subject)
      status_redraw_target(target) unless target == @subject
    else
      refresh_status
    end
  end
  # --------------------------------------------------------------------------
  # New method : Apply item for TSBS
  # --------------------------------------------------------------------------
  def tsbs_apply_item(target, item, subj = @subject)
    target.item_apply(subj, item)
    return if (item.is_a?(RPG::Skill) && item.id == target.guard_skill_id)
    check_skill_guard(target, item) unless item.is_a?(RPG::Item)
    @damage.start(target.result)
    if target.actor?
      @status_window.refresh 
    end
    if $imported["YEA-BattleEngine"]
      status_redraw_target(subj)
      status_redraw_target(target) unless target == subj
    else
      refresh_status
    end
  end
  # --------------------------------------------------------------------------
  # New method : Check skill guard
  # --------------------------------------------------------------------------
  def check_skill_guard(target, item)
    return if target == @subject
    return if @subject.friends_unit.members.include?(target)
    return if item.ignore_skill_guard?
    target.skills_guard.each do |skill|
      @subject.item_apply(target, skill)
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : terminate
  # --------------------------------------------------------------------------
  alias tsbs_terminate terminate
  def terminate
    tsbs_terminate
    @damage.dispose
    $game_temp.clear_tsbs
  end
  # --------------------------------------------------------------------------
  # For future features
  # --------------------------------------------------------------------------
  if $imported["YEA-CommandEquip"]
  alias tsbs_command_equip command_equip
  def command_equip
    tsbs_command_equip
    $game_party.battle_members[@status_window.index].battle_phase = :idle
  end
  end
end

#==============================================================================
# ** DamageResult
#------------------------------------------------------------------------------
#  This sprite is used to display damage counter result. It's used inside
# Scene_Battle. Automatically appear when triggered
#==============================================================================

class DamageResult < Sprite
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(viewport = nil)
    super
    self.bitmap = Bitmap.new(200,100)
    bitmap.font.size = 30
    set_anchor
    @value = 0
    self.opacity = 0
    @show = 0
    self.z = 250
  end
  # --------------------------------------------------------------------------
  # * Set anchor origin
  # --------------------------------------------------------------------------
  def set_anchor
    self.ox = width/2
    self.oy = height/2
  end
  # --------------------------------------------------------------------------
  # * Start showing number / Text
  # --------------------------------------------------------------------------
  def start(value)
    @value = value
    @show = 60
    self.opacity = 255
    self.zoom_x = 1.5
    self.zoom_y = 1.5
    bitmap.clear
    bitmap.draw_text(bitmap.rect, value, 1)
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    @show -= 1
    self.zoom_x = [zoom_x - 0.1, 1.0].max
    self.zoom_y = [zoom_x - 0.1, 1.0].max
    if @show < 0
      self.opacity -= 24
    end
  end
  # --------------------------------------------------------------------------
  # * Update position related to battler
  # --------------------------------------------------------------------------
  def update_position(battler)
    sprite = get_spriteset.get_sprite(battler)
    self.x = sprite.x
    self.y = sprite.y - sprite.height
  end
end

#==============================================================================
# ** DamageResults
#------------------------------------------------------------------------------
#  This class brings DamageResult instance object together in Scene_Battle
#==============================================================================

class DamageResults
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(viewport)
    @value = 0
    @hit_count = 0
  # ---------------------------------------------------------------
  # * Make damage counter
  # ---------------------------------------------------------------
    @damage_text = Sprite.new(viewport)
    @damage_text.bitmap = Bitmap.new(100,200)
    @damage_text.bitmap.font.color = TSBS::TotalDamage_Color
    @damage_text.bitmap.draw_text(0,0,100,TSBS::TotalDamage_Size,
      TSBS::TotalDamage_Vocab)
    @damage_text.y = TSBS::TotalDamage_Pos[0][0]
    @damage_text.x = TSBS::TotalDamage_Pos[0][1]
    @damage_text.opacity = 0
    @damage = DamageResult.new(viewport)
    @damage.x = TSBS::TotalDamage_Pos[1][0]
    @damage.y = TSBS::TotalDamage_Pos[1][1]
  # ---------------------------------------------------------------  
  # * Make hit counter
  # ---------------------------------------------------------------
    @hit_text = Sprite.new(viewport)
    @hit_text.bitmap = Bitmap.new(100,200)
    @hit_text.bitmap.font.color = TSBS::TotalHit_Color
    @hit_text.bitmap.draw_text(0,0,100,TSBS::TotalHit_Size,
      TSBS::TotalHit_Vocab)
    @hit_text.y = TSBS::TotalHit_Pos[0][0]
    @hit_text.x = TSBS::TotalHit_Pos[0][1]
    @hit = DamageResult.new(viewport)
    @hit.x = TSBS::TotalHit_Pos[1][0]
    @hit.y = TSBS::TotalHit_Pos[1][1]
  # ---------------------------------------------------------------
  # * Make special text result
  # ---------------------------------------------------------------
    @result_text = DamageResult.new(viewport)
    @result_text.bitmap.font.size = 24
    @result_text.bitmap.font.italic = true
  # ---------------------------------------------------------------
    update
  end
  # --------------------------------------------------------------------------
  # * Start showing number
  # --------------------------------------------------------------------------
  def start(result)
    @value += result.hp_damage
    @value += result.mp_damage
    @hit_count += 1 if result.hit?
    @damage.start(@value) if @value > 0
    @hit.start(@hit_count)
  end
  # --------------------------------------------------------------------------
  # * Start showing number
  # --------------------------------------------------------------------------
  def display_counter(battler)
    reset_value
    @result_text.update_position(battler)
    @result_text.start(TSBS::CounterAttack)
  end
  # --------------------------------------------------------------------------
  # * Start showing number
  # --------------------------------------------------------------------------
  def display_reflect(battler)
    @result_text.update_position(battler)
    @result_text.start(TSBS::Magic_Reflect)
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    @damage.update
    @hit.update
    @damage_text.opacity = @damage.opacity
    @hit_text.opacity = @hit.opacity
    @result_text.update
  end
  # --------------------------------------------------------------------------
  # * Dispose
  # --------------------------------------------------------------------------
  def dispose
    @damage.bitmap.dispose
    @damage.dispose
    @damage_text.bitmap.dispose
    @damage_text.dispose
    @hit.bitmap.dispose
    @hit.dispose
    @hit_text.bitmap.dispose
    @hit_text.dispose
    @result_text.bitmap.dispose
    @result_text.dispose
  end
  # --------------------------------------------------------------------------
  # * Reset value
  # --------------------------------------------------------------------------
  def reset_value
    @value = 0
    @hit_count = 0
  end
end
