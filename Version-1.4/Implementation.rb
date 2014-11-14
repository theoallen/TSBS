# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.4ob1 (Open Beta)
# Language : English
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact :
#------------------------------------------------------------------------------
# *> http://www.rpgmakerid.com
# *> http://www.rpgmakervxace.net
# *> http://theolized.blogspot.com
# =============================================================================
# Last updated : 2014.10.28
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5b
# >> Basic Functions 
# >> Movement
# >> Core Result
# >> Core Fade
# >> Clone Image
# >> Rotate Image
# >> Smooth Movement
# -----------------------------------------------------------------------------
# This section is mainly aimed for scripters. There's nothing to do unless
# you know what you're doing. I told ya. It's for your own good 
# =============================================================================
($imported ||= {})[:TSBS] = '1.4.0'  # <-- don't edit this line ~
# =============================================================================
module TSBS
  # --------------------------------------------------------------------------
  # Constantas. For a shake of God, please do not touch these!
  # --------------------------------------------------------------------------
  BusyPhases = [:intro, :skill, :prepare, :collapse, :forced, :return]
  # Phase that considered as busy and wait for finish. Do not change!
  
  Temporary_Phase = [:hurt, :evade, :return, :intro, :counter, :collapse]
  # Phase that will be replaced by :idle when finished. Do not change!
  
  EmptyTone = Tone.new(0,0,0,0)
  # Tone that replace the battler tone if battler has no state tone
  # Do not change!
  
  EmptyColor = Color.new(0,0,0,0)
  # Color that replace the battler color blend if battler has no state color
  # Do not change!
  # ---------------------------------------------------------------------------
  # Sequence Constants. Want to simplify the command call? edit this section
  # ---------------------------------------------------------------------------
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
  SEQUENCE_LOCK_Z           = :lock_z         # Lock shadow (and Z)
  SEQUENCE_ICON             = :icon           # Show icon
  SEQUENCE_SOUND            = :sound          # Play SE
  SEQUENCE_IF               = :if             # Set Branched condition
  SEQUENCE_TIMED_HIT        = :timed_hit      # Trigger timed hit function
  SEQUENCE_SCREEN           = :screen         # Setup screen
  SEQUENCE_ADD_STATE        = :add_state      # Add state
  SEQUENCE_REM_STATE        = :rem_state      # Remove state
  SEQUENCE_CHANGE_TARGET    = :change_target  # Change current target
  SEQUENCE_TARGET_MOVE      = :target_move    # Force move target
  SEQUENCE_TARGET_SLIDE     = :target_slide   # Force slide target
  SEQUENCE_TARGET_RESET     = :target_reset   # Force target to return
  SEQUENCE_BLEND            = :blend          # Setup battler blending
  SEQUENCE_FOCUS            = :focus          # Setup focus effect
  SEQUENCE_UNFOCUS          = :unfocus        # Remove focus effect
  SEQUENCE_TARGET_LOCK_Z    = :target_lock_z  # Lock target shadow (and Z)
  # ---------------------------------------------------------------------------
  # Update v1.1
  # ---------------------------------------------------------------------------
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
  # ---------------------------------------------------------------------------
  # Update v1.2
  # ---------------------------------------------------------------------------
  SEQUENCE_LOGWINDOW        = :log        # Display battle log
  SEQUENCE_LOGCLEAR         = :log_clear  # Clear battle log
  SEQUENCE_AFTINFO          = :aft_info   # Change afterimage
  SEQUENCE_SMMOVE           = :sm_move    # Smooth move
  SEQUENCE_SMSLIDE          = :sm_slide   # Smooth slide
  SEQUENCE_SMTARGET         = :sm_target  # Smooth move to target
  SEQUENCE_SMRETURN         = :sm_return  # Smooth return
  # ---------------------------------------------------------------------------
  # Update v1.3
  # ---------------------------------------------------------------------------
  SEQUENCE_LOOP             = :loop         # Loop in n times
  SEQUENCE_WHILE            = :while        # While loop
  SEQUENCE_COLLAPSE         = :collapse     # Perform collapse effect  
  SEQUENCE_FORCED           = :forced       # Force change action key to target
  SEQUENCE_ANIMBOTTOM       = :anim_bottom    # Play anim behind battler
  SEQUENCE_CASE             = :case           # Case switch
  SEQUENCE_INSTANT_RESET    = :instant_reset  # Instant reset
  SEQUENCE_ANIMFOLLOW       = :anim_follow    # Animation follow the battler
  SEQUENCE_CHANGE_SKILL     = :change_skill   # Change carried skill
  # v1.3b
  SEQUENCE_CHECKCOLLAPSE    = :check_collapse # Check collapse for target
  SEQUENCE_RESETCOUNTER     = :reset_counter  # Reset damage counter
  SEQUENCE_FORCEHIT         = :force_hit      # Toggle force to always hit
  SEQUENCE_SLOWMOTION       = :slow_motion    # Slow Motion effect
  SEQUENCE_TIMESTOP         = :timestop       # Timestop effect
  # v1.3c
  SEQUENCE_ONEANIM          = :one_anim       # One Anim Flag
  SEQUENCE_PROJ_SCALE       = :proj_scale     # Scale damage for projectile
  SEQUENCE_COMMON_EVENT     = :com_event      # Call common event
  SEQUENCE_GRAPHICS_FREEZE  = :scr_freeze     # Freeze the graphic
  SEQUENCE_GRAPHICS_TRANS   = :scr_trans      # Transition
  # ---------------------------------------------------------------------------
  # Update v1.4
  # ---------------------------------------------------------------------------
  SEQUENCE_FORCEDODGE       = :force_evade    # Force target to evade
  SEQUENCE_FORCEREFLECT     = :force_reflect  # Force target to reflect magic
  SEQUENCE_FORCECOUNTER     = :force_counter  # Force target to counter
  SEQUENCE_FORCECRITICAL    = :force_critical # Force criticaly hit to target
  SEQUENCE_FORCEMISS        = :force_miss     # Force miss target
  SEQUENCE_BACKDROP         = :backdrop       # Change Battleback
  SEQUENCE_BACKTRANS        = :back_trans     # Backdrop Change transition
  SEQUENCE_REVERT_BACKDROP  = :reset_backdrop # Reset battleback
  SEQUENCE_TARGET_FOCUS     = :target_focus   # Custom target focus
  SEQUENCE_SCREEN_FADEOUT   = :scr_fadeout    # Fadeout screen
  SEQUENCE_SCREEN_FADEIN    = :scr_fadein     # Fadein screen
  SEQUENCE_CHECK_COVER      = :check_cover    # Check battler cover
  SEQUENCE_STOP_MOVEMENT    = :stop_move      # Stop all movement
  SEQUENCE_ROTATION         = :rotate         # Rotate battler
  SEQUENCE_FADEIN           = :fadein         # Self fadein
  SEQUENCE_FADEOUT          = :fadeout        # Self fadeout
  SEQUENCE_IMMORTALING      = :immortal       # Immortal flag
  SEQUENCE_END_ACTION       = :end_action     # Force end action
  SEQUENCE_SHADOW_VISIBLE   = :shadow         # Shadow visibility
  SEQUENCE_AUTOPOSE         = :autopose       # Automatic pose
  SEQUENCE_ICONFILE         = :icon_file      # Set icon file
  SEQUENCE_IGNOREFLIP       = :ignore_flip    # Ignore flip reverse point
  # ---------------------------------------------------------------------------
  
  # Screen sub-modes
  Screen_Tone       = :tone       # Set screen tone
  Screen_Shake      = :shake      # Set screen shake
  Screen_Flash      = :flash      # Set screen flash
  Screen_Normalize  = :normalize  # Normalize screen
  
  # Projectile setup
  PROJ_START          = :start      # Initial starting (head, mid, feet)
  PROJ_END            = :end        # Initial end position (head, mid, feet)
  PROJ_STARTPOS       = :start_pos  # Relative starting coordinate 
  PROJ_ENDPOS         = :end_pos    # Relative end position
  PROJ_REVERSE        = :reverse    # Reverse flag
  PROJ_POSITION_HEAD  = :head       # Position : head
  PROJ_POSITION_MID   = :middle     # Position : middle
  PROJ_POSITION_FEET  = :feet       # Position : feet
  PROJ_POSITION_NONE  = :none       # Position : none
  PROJ_POSITION_SELF  = :self       # Position : self (put only in PROJ_END)
  PROJ_DAMAGE_EXE     = :damage     # Damage execution after hit
  PROJ_ANIMSTART      = :anim_start # Custom animation on start
  PROJ_ANIMEND        = :anim_end   # Custom animation on start
  PROJ_ANIMPOS        = :anim_pos   # Animation position
  PROJ_ANIMDEFAULT    = :default    # Default animation
  PROJ_ANIMHIT        = :anim_hit   # Play animation only if hit
  PROJ_SCALE          = :scale      # Damage Scale
  PROJ_PIERCE         = :pierce     # Piercing flag
  PROJ_BOOMERANG      = :boomerang  # Boomerang flag
  PROJ_AFTERIMAGE     = :aftimg     # Afterimage flag
  PROJ_AFTOPAC        = :aft_opac   # Afterimage opacity easing
  PROJ_AFTRATE        = :aft_rate   # Afterimage clone rate
  PROJ_ANGLE          = :angle      # Starting angle
  PROJ_WAITCOUNT      = :wait       # Wait frame before throws
  PROJ_CHANGE         = :change     # Change flag
  PROJ_FLASH_REF      = :flash      # Animation flash references
  PROJ_RESET          = :reset      # Reset command
  
  # Damage setup for projectile
  # [-1: Damage on start][0: No damage][1: Damage on end] 
  
  # Default projectile setup (version 1.4)
  PROJECTILE_DEFAULT = {
    PROJ_START      => PROJ_POSITION_MID, # Done ~ !
    PROJ_END        => PROJ_POSITION_MID, # Done ~ !
    PROJ_STARTPOS   => [0,0,0], # Done ~ !
    PROJ_ENDPOS     => [0,0,0], # Done ~ !
    PROJ_REVERSE    => false, # Not tested!
    PROJ_SCALE      => 1.0,   # Done ~ !
    PROJ_DAMAGE_EXE => 1,     # Not tested!
    PROJ_PIERCE     => false, # Done ~ !
    PROJ_BOOMERANG  => false, # Done ~ !
    PROJ_AFTERIMAGE => false, # Done ~ !
    PROJ_AFTOPAC    => 17,    # Done ~ !
    PROJ_AFTRATE    => 1,     # Done ~ !
    PROJ_ANIMSTART  => nil,   # Done ~ !
    PROJ_ANIMEND    => nil,   # Done ~ !
    PROJ_ANIMPOS    => 0,     # Done ~ !
    PROJ_ANIMHIT    => false, # Done ~ !
    PROJ_ANGLE      => 0.0,   # Done ~ !
    PROJ_WAITCOUNT  => 0,     # Done ~ !
    PROJ_FLASH_REF  => [false, false], # Done ~ !
  }
  # Default afterimage setting
  AFTIMG_OPACITY_EASE = 20  # opacity easing
  AFTIMG_IMAGE_RATE   = 2   # image cloning rate
  
  # Default setting for balloon
  BALLOON_SPEED = 3 # Balloon change speed.
  BALLOON_WAIT  = 4 # Wait count in last frame
  
  # Backdrop constant
  BACKDROP_SWITCH   = :switch
  BACKDROP_DURATION = :duration
  BACKDROP_NAME     = :name
  BACKDROP_VAGUE    = :vague
  
  # Backdrop transition default setting
  BACKDROP_TRANS_DEFAULT = {
    BACKDROP_SWITCH   => true,
    BACKDROP_DURATION => 45,
    BACKDROP_NAME     => "",
    BACKDROP_VAGUE    => 120,
  }
  
  TSBS_END_SEQUENCE_WAIT = 30 
  # Frame wait after perform sequence
  CONVERT_DRAIN = true 
  # When magic reflected, drain damage type will be converted to normal damage
  
  TIMED_HIT_BUTTON_SYMBOL = :button
  TIMED_HIT_TIMING_SYMBOL = :timing
  TIMED_HIT_ANIME_SYMBOL  = :anim
  TIMED_HIT_ANIME_FOLLOW  = :follow
  TIMED_HIT_DEFAULT_BUTTON = :C
  
  TIMED_HIT_SETUP = {
    TIMED_HIT_BUTTON_SYMBOL => [TIMED_HIT_DEFAULT_BUTTON],
    TIMED_HIT_TIMING_SYMBOL => 0,
    TIMED_HIT_ANIME_SYMBOL => TimedHit_Anim,
    TIMED_HIT_ANIME_FOLLOW => true,
  }
  
  # Not yet implemented
  FOCUS_TYPE_FADES    = :fade
  FOCUS_TYPE_BLACKOUT = :blackout
  FOCUS_BLACKOUT_DEFAULT_COLOR = Color.new(0,0,0,150)
  
  # -------------------------------------------------------------------------
  # Regular Expression (REGEXP) Constants. Want to simplify notetags? edit 
  # this section. If only you understand the ruby regular expression
  # -------------------------------------------------------------------------
  AnimGuard = /<anim[_\s]+guard\s*:\s*(\d+)>/i
  # Notetag for animation guard

  SkillGuard = /<skill[_\s]+guard\s*:\s*(\d+)>/i
  # Notetag for skill guard
  
  SGRange = /<sg[\s_]+range\s*:\s*(\d+)>/i
  # Skill Guard range
  
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
  
  NoShadowTAG = /<no[\s_]+shadow>/i
  # Tag for no shadow for actor/enemy
  
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
  
  AnimBehind = /<anim[\s_]+behind>/i
  # State Animation behind flag
  
  CollapSound = /<collapsound\s*:\s*(.+)\s*,\s*(\d+)\s*,\s*(\d+)\s*>/i
  # Collapse sound effect 
  
  OneAnimation = /<one[\s_]+animation>/i
  # One Animation tag
  
  FolderRef = /<folder\s*:\s*(.+)>/i
  # Battler folder reference
  
  CustomShadow = /<shadow\s*:\s*(.+)>/i
  # Custom battler shadow
  
  ShadowYPOS = /<shadow\s+pos\s*:\s*(-|\+*)(.+)>/i
  # Shadow Y Position
  
  CustomFlip = /<custom[\s_]+flip>/i
  # Custom Flip flag
  
  ClassChangeName = /<classname\s*:\s*(.+)>/i
  # Class change battler graphics
  
  IconFile = /<iconfile\s*:\s*(.+)>/i
  # Icon file graphics for weapons
  
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
  # Error Handler. Because I don't want to be the one who blamed ~
  # -------------------------------------------------------------------------
  ErrorSound = RPG::SE.new("Buzzer1",100,100)
  def self.error(symbol, params, seq)
    ErrorSound.play
    text = "Sequence : #{seq}\n" +
    "#{symbol} mode needs at least #{params} parameters"
    msgbox text
    exit
  end
  #============================================================================
  # * Screen_Point class used to screen reposition (Battle Camera)
  # ---------------------------------------------------------------------------
  class Screen_Point
    attr_accessor :x
    attr_accessor :y
    #--------------------------
    include THEO::Movement  
    include Smooth_Slide
    #--------------------------
    def initialize(x = 0, y = 0)
      set(x,y)
      set_obj(self)
      init_smove
    end
    #--------------------------
    # Set at once
    #--------------------------
    def set(x,y)
      @x = x
      @y = y
    end
    #--------------------------
    # Update move
    #--------------------------
    def update_move
      super
      update_smove
    end
    #--------------------------
    def clear_move_info
      @move_obj.clear_move_info
    end
    #--------------------------
    alias screen_x x
    alias screen_y y
  end
  #============================================================================
  # * Afterimage sprite
  # ---------------------------------------------------------------------------
  class Afterimage < Sprite
    def initialize(vport = nil)
      super
      @screen_point = Screen_Point.new
    end
    # -------------------------------------------------------------------------
    # * Refresh point value
    # -------------------------------------------------------------------------
    def refresh_point(x, y)
      @screen_point.x = x
      @screen_point.y = y
      update_point_placement
    end
    # -------------------------------------------------------------------------
    # * Update
    # -------------------------------------------------------------------------
    def update   
      super
      update_point_placement
      self.zoom_x = self.zoom_y = $tsbs_camera.zoom
    end
    # -------------------------------------------------------------------------
    # * Update point placement
    # -------------------------------------------------------------------------
    def update_point_placement
      self.x = @screen_point.screen_x
      self.y = @screen_point.screen_y
    end
  end
end
#===============================================================================
# Glitch fix from Theo - Basic Module rotation. I know, most of people hate to
# constantly update the basic module. So I put the patch here <(")
#-------------------------------------------------------------------------------
module Theo
  module Rotation
    def update_rotation
      return unless @rotating
      @degree += @rotate_speed
      new_angle = @degree.round
      self.angle = new_angle % 360.0
      if new_angle == @target_degree
        init_rotate
      end
    end
  end
end
#===============================================================================
# * Rewrite module for afterimage. Used to reposition the afterimages in
# battle camera
#-------------------------------------------------------------------------------
module TSBS_Afterimages
  
  def clone_class
    return TSBS::Afterimage
  end
  
  def updating_afterimages? 
    return $imported[:TSBS_Camera]
  end
  
  def on_after_cloning(cloned)
    super(cloned)
    if self.is_a?(Sprite_Battler)
      cloned.refresh_point(@battler.x, @battler.y - oy)
    elsif self.is_a?(Sprite_Projectile)
      cloned.refresh_point(@point.x, @point.y)
    elsif self.is_a?(Sprite_BattlerIcon)
      cloned.refresh_point(@screen_point.x, @screen_point.y)
    else
      cloned.refresh_point(x,y)
    end
  end
  
end

#===============================================================================
# * Database module for battler (RPG::Actor / RPG::Enemy). If both actor or 
# enemy has similar database, edit this section
#-------------------------------------------------------------------------------

module TSBS_BattlerDB
  #-----------------------------------------------------------------------------
  # New public accessor
  #-----------------------------------------------------------------------------
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
  attr_accessor :counter_skill  # Counterattack skill ID
  attr_accessor :use_sprite     # Use sprite flag (always true for Actor)
  attr_accessor :reflect_anim   # Reflect animation
  attr_accessor :no_shadow      # No shadow flag
  attr_accessor :folder_ref     # Folder as reference
  attr_accessor :custom_shadow  # Custom Shadow tag
  attr_accessor :shadow_y       # Shadow Y reposition
  attr_accessor :shadow_resize  # Resize flag
  #-----------------------------------------------------------------------------
  # Load TSBS
  #-----------------------------------------------------------------------------
  def load_tsbs
    @idle_key = TSBS::Default_Idle
    @critical_key = TSBS::Default_Critical
    @evade_key = (self.class == RPG::Enemy ? TSBS::Default_Evade_E :
      TSBS::Default_Evade_A)
    @hurt_key = TSBS::Default_Hurt
    @return_key = TSBS::Default_Return
    @dead_key = TSBS::Default_Dead
    @escape_key = TSBS::Default_Escape
    @victory_key = TSBS::Default_Victory
    @intro_key = TSBS::Default_Intro
    @counter_key = (self.class == RPG::Enemy ? TSBS::Default_ECounter : 
      TSBS::Default_ACounter)
    @collapse_key = ""
    @counter_skill = 1
    @reflect_anim = TSBS::Reflect_Guard
    @use_sprite = (self.class == RPG::Enemy ? false : true)
    @no_shadow = false
    @folder_ref = ""
    @custom_shadow = "Shadow"
    @shadow_y = 4
    @shadow_resize = true
    @load_tsbs = false
    self.note.split(/[\r\n]+/).each do |line|
      read_tsbs(line)
    end
  end
  #-----------------------------------------------------------------------------
  # Read notetags
  #-----------------------------------------------------------------------------
  def read_tsbs(line)
    case line
    when TSBS::NoShadowTAG
      @no_shadow = true 
    when TSBS::ReflectAnim
      @reflect_anim = $1.to_i
    when TSBS::CounterSkillID
      @counter_skill = $1.to_i
    when TSBS::FolderRef
      @folder_ref = $1.to_s
    when TSBS::CustomShadow
      @custom_shadow = $1.to_s
      @shadow_resize = false
    when TSBS::ShadowYPOS
      @shadow_y = ($1.to_s == "-" ? -$2.to_i : $2.to_i)
    end
    return unless @load_tsbs
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
    when TSBS::SBS_Escape
      @escape_key = $1.to_s
    when TSBS::SBS_Win
      @victory_key = $1.to_s
    end
  end
  
  def custom_flip?
    !note[TSBS::CustomFlip].nil?
  end
  
end
#===============================================================================
# * Rewrite module for how animation is handled in TSBS
#-------------------------------------------------------------------------------
# Put it inside any subclass of Sprite_Base. Don't forget to add @anim_top
# within the class. The rules are:
# ------------------------------------------------------------------------------
# [-1: Anim Behind][0: Depends on Z position][1: Always on top]
#-------------------------------------------------------------------------------
module TSBS_AnimRewrite
  #---------------------------------------------------------------------------
  # Overwrite method : animation set sprites
  #---------------------------------------------------------------------------
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
      zoom = (camera_animation_zoom? ? $tsbs_camera.zoom : 1.0)
      if @ani_mirror
        sprite.x = @ani_ox - (cell_data[i, 1] * zoom)
        sprite.y = @ani_oy + (cell_data[i, 2] * zoom)
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + (cell_data[i, 1] * zoom)
        sprite.y = @ani_oy + (cell_data[i, 2] * zoom)
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      # ---------------------------------------------
      # If animation position is to screen || on top?
      # ---------------------------------------------
      if (@animation.position == 3 && !@anim_top == -1) || @anim_top == 1
        sprite.z = self.z + Graphics.height + i  # Always display on top
      elsif @anim_top == -1
        sprite.z = 3 + i
      else
        sprite.z = self.z + 3 + i
      end
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = (cell_data[i, 3] / 100.0) * zoom
      sprite.zoom_y = (cell_data[i, 3] / 100.0) * zoom
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  #----------------------------------------------------------------------------
  # * Zoom animation?
  #----------------------------------------------------------------------------
  def camera_animation_zoom?
    return false if @animation.position == 3
    return true if $imported[:TSBS_Camera] && TSBS::CAMERA_ANIMATION_ZOOM
    return false
  end
  #----------------------------------------------------------------------------
  # * Fix animation sprites for camera
  #----------------------------------------------------------------------------
  def fix_animation_sprites
    return unless $imported[:TSBS_Camera]
    return unless @ani_sprites && @animation
    if (@animation.position == 3 && !@anim_top == -1) || @anim_top == 1
      z_val = self.z + Graphics.height
    elsif @anim_top == -1
      z_val = 3
    else
      z_val = self.z + 3
    end
    frame = @animation.frames[frame_index]
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      next unless sprite.visible
      sprite.z = z_val + i
      next unless camera_animation_zoom?
      sprite.zoom_x = (cell_data[i, 3] / 100.0) * $tsbs_camera.zoom
      sprite.zoom_y = (cell_data[i, 3] / 100.0) * $tsbs_camera.zoom
    end
  end
  #----------------------------------------------------------------------------
  # * Overwrite update
  #----------------------------------------------------------------------------
  def update_animation
    super
    fix_animation_sprites
  end
  #----------------------------------------------------------------------------
  # * Frame Index
  #----------------------------------------------------------------------------
  def frame_index
    return @animation.frame_max - (@ani_duration + @ani_rate - 1) / @ani_rate
  end
  
end
# ----------------------------------------------------------------------------
# Custom get scene method
# ----------------------------------------------------------------------------
def get_scene
  SceneManager.scene
end
# ----------------------------------------------------------------------------
# Custom get spriteset method
# ----------------------------------------------------------------------------
def get_spriteset
  get_scene.instance_variable_get("@spriteset")
end
# ----------------------------------------------------------------------------
# Custom chance method
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
# Altered basic modules
# ----------------------------------------------------------------------------
module THEO
  module Movement
    class Move_Object
      attr_reader :x_speed
      attr_reader :y_speed
      attr_reader :real_y
    end
    def real_ypos
      return @move_obj.real_y if @move_obj.real_y > 0
      return self.y
    end
  end
end

#==============================================================================
# Added dummy update method for Plane
#==============================================================================

class Plane
  
  unless method_defined?(:update)
  def update
  end
  end
  
end

#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================

class << SceneManager
  
  def in_battle?
    scene_is?(Scene_Battle)
  end
  
end

#==============================================================================
# ** Sound
#------------------------------------------------------------------------------
#  This module plays sound effects. It obtains sound effects specified in the
# database from the global variable $data_system, and plays them.
#==============================================================================

class << Sound
  #----------------------------------------------------------------------------
  # Deleted all sounds. Since I don't want to overwrite Window_BattleLog
  #----------------------------------------------------------------------------
  alias tsbs_play_eva play_evasion
  def play_evasion
    return if SceneManager.in_battle?
    tsbs_play_eva
  end
  
  alias tsbs_play_magic_eva play_magic_evasion
  def play_magic_evasion
    return if SceneManager.in_battle?
    tsbs_play_magic_eva
  end
  
  alias tsbs_play_enemycollapse play_enemy_collapse
  def play_enemy_collapse
    return if SceneManager.in_battle?
    tsbs_play_enemycollapse
  end
  
  alias tsbs_play_recovery play_recovery
  def play_recovery
    return if SceneManager.in_battle?
    tsbs_play_recovery
  end

  alias tsbs_play_miss play_miss
  def play_miss
    return if SceneManager.in_battle?
    tsbs_play_miss
  end

  alias tsbs_play_reflection play_reflection
  def play_reflection
    return if SceneManager.in_battle?
    tsbs_play_reflection
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
      swindow = get_scene.get_status_window
      if swindow 
        swindow.open 
        swindow.refresh
      end
      # Open status window if encounter message is disabled
    end
    get_scene.wait_for_sequence 
    # wait for intro sequence
  end
  # --------------------------------------------------------------------------
  # Alias method : process victory
  # --------------------------------------------------------------------------
  alias tsbs_process_victory process_victory
  def process_victory
    $game_party.alive_members.each do |member|
      member.battle_phase = :victory unless member.victory_key.empty?
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
    if SceneManager.in_battle?
      get_scene.all_battle_members.each do |member|
        get_scene.check_collapse(member)
      end
      get_scene.wait_for_sequence 
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
  attr_accessor :classname
  # --------------------------------------------------------------------------
  # New method : load TSBS notetags
  # --------------------------------------------------------------------------
  def load_tsbs
    @attack_id = 0
    @guard_id = 0
    @classname = ''
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when TSBS::DefaultATK
        @attack_id = $1.to_i
      when TSBS::DefaultDEF
        @guard_id = $1.to_i
      when TSBS::ClassChangeName
        @classname = $1.to_s
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
  attr_accessor :icon_file
  attr_accessor :attack_id
  attr_accessor :guard_id
  # --------------------------------------------------------------------------
  # New method : load TSBS notetags
  # --------------------------------------------------------------------------
  def load_tsbs
    @icon_file = ''
    @attack_id = 0
    @guard_id = 0
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when TSBS::DefaultATK
        @attack_id = $1.to_i
      when TSBS::DefaultDEF
        @guard_id = $1.to_i
      when TSBS::IconFile
        @icon_file = $1.to_s
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
  attr_accessor :sg_range       # Skill Guard maximum range effect
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
    @sg_range = 0
    @max_opac = 255
    @sequence = ""
    @state_anim = 0
    @trans_name = ''
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
      when TSBS::SGRange
        @sg_range = $1.to_i
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
  # --------------------------------------------------------------------------
  # New method : Anim Behind?
  # --------------------------------------------------------------------------
  def anim_behind?
    !note[TSBS::AnimBehind].nil?
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
  # --------------------------------------------------------------------------
  # New method : Determine if skill has one animation flag
  # --------------------------------------------------------------------------
  unless $imported["YEA-BattleEngine"]
  def one_animation
    !note[TSBS::OneAnimation].nil?
  end
  end
end

#==============================================================================
# ** RPG::Actor
#------------------------------------------------------------------------------
#  This class handles actors database
#==============================================================================

class RPG::Actor < RPG::BaseItem
  # --------------------------------------------------------------------------
  # Import Battler DB module
  # --------------------------------------------------------------------------
  include TSBS_BattlerDB
  # --------------------------------------------------------------------------
  # New public accessors
  # --------------------------------------------------------------------------
  attr_accessor :battler_name   # Battler name
  attr_accessor :attack_id      # Attack skill ID
  attr_accessor :guard_id       # Guard skill ID
  # --------------------------------------------------------------------------
  # New method : load TSBS notetags
  # --------------------------------------------------------------------------
  def load_tsbs
    @battler_name = @name.clone
    @attack_id = 0
    @guard_id = 0
    super
  end
  # --------------------------------------------------------------------------
  # New method : Read TSBS
  # --------------------------------------------------------------------------
  def read_tsbs(line)
    case line
    when TSBS::DefaultATK
      @attack_id = $1.to_i
    when TSBS::DefaultDEF
      @guard_id = $1.to_i
    when TSBS::SBS_Start
      @load_tsbs = true
    when TSBS::SBS_Start_S
      @load_tsbs = true
      @battler_name = $1.to_s
    when TSBS::SBS_End
      @load_tsbs = false
    end
    super(line)
  end
end

#==============================================================================
# ** RPG::Enemy
#------------------------------------------------------------------------------
#  This class handles enemies database
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  # --------------------------------------------------------------------------
  # Import Battler DB module
  # --------------------------------------------------------------------------
  include TSBS_BattlerDB
  # --------------------------------------------------------------------------
  # New public accessors
  # --------------------------------------------------------------------------
  attr_accessor :sprite_name    # Sprite name
  attr_accessor :collapsound    # Collapse sound effect
  # --------------------------------------------------------------------------
  # New method : load TSBS notetags
  # --------------------------------------------------------------------------
  def load_tsbs
    @sprite_name = ""
    @collapsound = $data_system.sounds[11]
    super
  end
  # --------------------------------------------------------------------------
  # New method : Read TSBS
  # --------------------------------------------------------------------------
  def read_tsbs(line)
    case line
    when TSBS::CollapSound
      @collapsound = RPG::SE.new($1.to_s,$2.to_i,$3.to_i)
    when TSBS::SBS_Start_S
      @load_tsbs = true
      @use_sprite = true
      @sprite_name = $1.to_s
    when TSBS::SBS_Start
      @load_tsbs = true
    when TSBS::SBS_End
      @load_tsbs = false
    end
    super(line)
  end
  
end

#==============================================================================
# ** Game_Backdrop
#------------------------------------------------------------------------------
#  This class handles battleback metadata to simulate battleback replacement.
# Instance of this class included within the Game_Temp class
#==============================================================================

class Game_Backdrop
  # --------------------------------------------------------------------------
  # * Public accessors
  # --------------------------------------------------------------------------
  attr_accessor :trans_flag   # Transition flag
  attr_accessor :transition   # Transition image name
  attr_accessor :duration     # Transition duration
  attr_accessor :trans_vague  # Transition vaguity
  attr_accessor :name_1       # Battleback 1 name
  attr_accessor :name_2       # Battleback 2 name
  # --------------------------------------------------------------------------
  # * Import constantas
  # --------------------------------------------------------------------------
  include TSBS
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize
    reset_transition_flags
    clear_all
    @point1 = Screen_Point.new(*initpos_1)
    @point2 = Screen_Point.new(*initpos_2)
  end
  # --------------------------------------------------------------------------
  # * Clear all backdrops data
  # --------------------------------------------------------------------------
  def clear_all
    @name_1 = ""
    @name_2 = ""
    @ori_backdrop1 = ""
    @ori_backdrop2 = ""
  end
  # --------------------------------------------------------------------------
  # * Reset transition to default value
  # --------------------------------------------------------------------------
  def reset_transition_flags
    @trans_flag   = BACKDROP_TRANS_DEFAULT[BACKDROP_SWITCH]
    @transition   = BACKDROP_TRANS_DEFAULT[BACKDROP_NAME]
    @duration     = BACKDROP_TRANS_DEFAULT[BACKDROP_DURATION]
    @trans_vague  = BACKDROP_TRANS_DEFAULT[BACKDROP_VAGUE]
  end
  # --------------------------------------------------------------------------
  # * Setup transition
  # --------------------------------------------------------------------------
  def trans_setup(hash_setup)
    @trans_flag   = hash_setup[BACKDROP_SWITCH]
    @transition   = hash_setup[BACKDROP_NAME]
    @duration     = hash_setup[BACKDROP_DURATION]
    @trans_vague  = hash_setup[BACKDROP_VAGUE]
  end
  # --------------------------------------------------------------------------
  # * Set backdrop image names
  # --------------------------------------------------------------------------
  def set(name1, name2)
    @name_1 = @ori_backdrop1 = name1
    @name_2 = @ori_backdrop2 = name2
  end
  # --------------------------------------------------------------------------
  # * Revert to original names
  # --------------------------------------------------------------------------
  def revert
    @name_1 = @ori_backdrop1
    @name_2 = @ori_backdrop2
  end
  # --------------------------------------------------------------------------
  # * Zoom value for backdrop 1
  # --------------------------------------------------------------------------
  def zoom_1
    return 1.0
  end
  # --------------------------------------------------------------------------
  # * Zoom value for backdrop 2
  # --------------------------------------------------------------------------
  def zoom_2
    return 1.0
  end
  # --------------------------------------------------------------------------
  # * Initial position of backdrop 1
  # --------------------------------------------------------------------------
  def initpos_1
    return [0,0]
  end
  # --------------------------------------------------------------------------
  # * Initial position of backdrop 2
  # --------------------------------------------------------------------------
  def initpos_2
    return [0,0]
  end
  # --------------------------------------------------------------------------
  # * looping backdrop reposition case
  # --------------------------------------------------------------------------
  def looping_position_check(bitmap, point1)
    if Looping_Background
      plus_x = (Graphics.width - bitmap.width)/2
      plus_y = (Graphics.height - bitmap.height)/2
    else
      plus_x = Graphics.width / 2
      plus_y = Graphics.height / 2
    end
    if point1
      @point1.set(*initpos_1)
      @point1.x += plus_x
      @point1.y += plus_y
    else
      @point2.set(*initpos_2)
      @point2.x += plus_x
      @point2.y += plus_y
    end
  end
  # --------------------------------------------------------------------------
  # * Screen axis series for camera
  # --------------------------------------------------------------------------
  def screen_x1; @point1.screen_x;  end
  def screen_y1; @point1.screen_y;  end
  def screen_x2; @point2.screen_x;  end
  def screen_y2; @point2.screen_y;  end
  # --------------------------------------------------------------------------
  # * Update (just in case)
  # --------------------------------------------------------------------------
  def update
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
  attr_accessor :actors_fiber       # Store actor Fibers thread
  attr_accessor :enemies_fiber      # Store enemy Fibers thread
  attr_accessor :battler_targets    # Store current targets
  attr_accessor :anim_top           # Store anim top flag
  attr_accessor :global_freeze      # Global freeze flag
  attr_accessor :anim_follow        # Store anim follow flag
  attr_accessor :slowmotion_frame   # Total frame for slowmotion
  attr_accessor :slowmotion_rate    # Framerate for slowmotion
  attr_accessor :one_animation_id   # One Animation ID Display
  attr_accessor :one_animation_flip # One Animation flip flag
  attr_accessor :one_animation_flag # One Animation assign flag
  attr_accessor :tsbs_event         # TSBS common event play
  attr_accessor :shadow_visible     # Shadow visibility flag
  attr_reader :backdrop
  # --------------------------------------------------------------------------
  # Alias method : Initialize
  # --------------------------------------------------------------------------
  alias tsbs_init initialize
  def initialize
    tsbs_init
    @backdrop = Game_Backdrop.new
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
    @slowmotion_frame = 0
    @slowmotion_rate = 2
    @one_animation_id = 0
    @one_animation_flip = false
    @one_animation_flag = false
    @tsbs_event = 0
    @shadow_visible = true
    @backdrop.clear_all
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
  # --------------------------------------------------------------------------
  # Public accessor
  # --------------------------------------------------------------------------
  attr_accessor :reflected
  attr_accessor :tsbs_yea_compatible
  # --------------------------------------------------------------------------
  # Alias method : Initialize
  # --------------------------------------------------------------------------
  alias tsbs_init initialize
  def initialize(battler)
    @tsbs_yea_compatible = false
    tsbs_init(battler)
    clear_tsbs_overall_result
  end
  # --------------------------------------------------------------------------
  # Alias method : Clear
  # --------------------------------------------------------------------------
  alias tsbs_clear clear
  def clear
    tsbs_clear
    @reflected = false
  end
  # --------------------------------------------------------------------------
  # alias method : clear damage values
  # --------------------------------------------------------------------------
  alias tsbs_clear_damage clear_damage_values
  def clear_damage_values
    return if tsbs_yea_compatible
    tsbs_clear_damage
  end
  # --------------------------------------------------------------------------
  # New method : Clear overall result
  # --------------------------------------------------------------------------
  def clear_tsbs_overall_result
    @tsbs_overall_hp = 0
    @tsbs_overall_mp = 0
    @tsbs_overall_tp = 0
    @tsbs_overall_hp_drain = 0
    @tsbs_overall_mp_drain = 0
    @tsbs_critical = false
  end
  # --------------------------------------------------------------------------
  # New method : Record result
  # --------------------------------------------------------------------------
  def record_result_tsbs
    @tsbs_overall_hp += @hp_damage
    @tsbs_overall_mp += @mp_damage
    @tsbs_overall_tp += @tp_damage
    @tsbs_overall_hp_drain += @hp_drain
    @tsbs_overall_mp_drain += @mp_drain
    @tsbs_critical = true if critical
  end
  # --------------------------------------------------------------------------
  # New method : Restore result
  # --------------------------------------------------------------------------
  def restore_result_tsbs
    @hp_damage = @tsbs_overall_hp
    @mp_damage = @tsbs_overall_mp
    @tp_damage = @tsbs_overall_tp
    @hp_drain = @tsbs_overall_hp_drain
    @mp_drain = @tsbs_overall_mp_drain
    @critical = @tsbs_critical
  end
  # --------------------------------------------------------------------------
  # New method : Double check missed and evaded
  # --------------------------------------------------------------------------
  def double_check
    if any_damage?
      @used = true
      @missed = false
      @evaded = false
    end
  end
  # --------------------------------------------------------------------------
  # New method : Is there any damage?
  # --------------------------------------------------------------------------
  def any_damage? 
    [@hp_damage, @mp_damage, @tp_damage, @hp_drain, @mp_drain].any? do |result|
      result != 0
    end
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
    candidate = alive_members.shuffle.sort {|a,b| b.tgr <=> a.tgr}
    return candidate[0, number] || []
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
  include Theo::Rotation  # Import rotation function
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
  attr_accessor :afopac             # Afterimage opacity fade speed
  attr_accessor :afrate             # Afterimage show rate
  attr_accessor :forced_act         # Force action
  attr_accessor :force_hit          # Force always hit flag
  # --------- Update V1.4 --------- #
  attr_accessor :force_evade        # Force evade flag
  attr_accessor :force_reflect      # Force reflect
  attr_accessor :force_counter      # Force counter
  attr_accessor :force_critical     # Force critical hit
  attr_accessor :force_miss         # Force miss
  attr_accessor :balloon_speed      # Balloon speed
  attr_accessor :balloon_wait       # Balloon wait
  attr_accessor :cover_battler      # Substitue / cover battler
  attr_accessor :covering           # Covering flag
  attr_accessor :angle              # Angle rotation
  attr_accessor :immortal           # Immortal flag
  attr_accessor :break_action       # Break action
  # --------------------------------------------------------------------------
  # New public attributes (access only)
  # --------------------------------------------------------------------------
  attr_reader :target         # Current target
  attr_reader :target_array   # Overall target
  attr_reader :battle_phase   # Battle Phase
  attr_reader :blend          # Blend
  attr_reader :acts           # Used action
  attr_reader :shadow_point   # Shadow Point
  # --------------------------------------------------------------------------
  # Alias method : initialize
  # --------------------------------------------------------------------------
  alias theo_tsbs_batt_init initialize
  def initialize(*args)
    @shadow_point = Screen_Point.new
    theo_tsbs_batt_init(*args)
    set_obj(self)
    clear_tsbs
  end
  # --------------------------------------------------------------------------
  # New method : Icon File
  # --------------------------------------------------------------------------
  def icon_file(index = 0)
    return @icon_file unless @icon_file.empty?
    return weapons[index].icon_file if weapons[index]
    return ''
  end
  # --------------------------------------------------------------------------
  # New method : Default Flip
  # --------------------------------------------------------------------------
  def default_flip
    return false
  end
  # --------------------------------------------------------------------------
  # New method : Custom Flip
  # --------------------------------------------------------------------------
  def custom_flip?
    return data_battler.custom_flip?
  end
  # --------------------------------------------------------------------------
  # New method : Final Flip result
  # --------------------------------------------------------------------------
  def battler_flip
    (custom_flip? ? false : @flip)
  end
  # --------------------------------------------------------------------------
  # New method : finish
  # --------------------------------------------------------------------------
  def finish
    @finish || @break_action
  end
  # --------------------------------------------------------------------------
  # New method : sprite
  # --------------------------------------------------------------------------
  unless method_defined?(:sprite)
  def sprite
    get_spriteset.get_sprite(self)
  end
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
  # New method : Relative X position from center (used for camera)
  # --------------------------------------------------------------------------
  def rel_x
    return x - Graphics.width/2
  end
  # --------------------------------------------------------------------------
  # New method: Relative Y position from center (used for camera)
  # --------------------------------------------------------------------------
  def rel_y
    return y - Graphics.height/2
  end
  # --------------------------------------------------------------------------
  # New method: Distance between the shadow and the battler
  # --------------------------------------------------------------------------
  def height
    return @shadow_point.y - self.y
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
    @ori_target = nil # Store original target. Do not change!
    @target_array = []
    @ori_targets = [] # Store original target array. Do not change!
    @item_in_use = nil  
    @visible = true
    @flip = default_flip
    @area_flag = false
    @afterimage = false
    @proj_icon = 0
    @refresh_opacity = false
    @lock_z = false
    @icon_key = ""
    @acts = []
    @blend = 0
    @used_sequence = "" # Record the used sequence for error handling
    @sequence_stack = []  # Used sequence stack trace for error handling
    @balloon_id = 0
    @balloon_speed = BALLOON_SPEED
    @balloon_wait = BALLOON_WAIT
    @anim_guard = 0
    @anim_guard_mirror =  false
    @forced_act = ""
    @proj_setup = copy(PROJECTILE_DEFAULT)
    @focus_target = 0
    @covering = false
    @shadow_point.x = @shadow_point.y = 0
    @angle = 0.0
    @immortal = false
    @break_action = false
    @autopose = []
    @icon_file = ''
    reset_force_result
    reset_aftinfo
    reset_timed_hit
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Goto (basic module)
  # --------------------------------------------------------------------------
  def goto(x, y, dur, jump, height = 0)
    super(x, y, dur, jump)
    height = [height, 0].max
    y = @shadow_point.y if @lock_z
    @shadow_point.goto(x, y + height, dur, 0)
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Slide (basic module)
  # --------------------------------------------------------------------------
  def slide(x, y, dur, jump, height = 0)
    slide_x = self.x + x
    slide_y = self.y + y
    goto(slide_x, slide_y, dur, jump, height) unless moving?
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Smooth move (basic module)
  # --------------------------------------------------------------------------
  def smooth_move(x, y, dur, reverse = false)
    super(x,y,dur,reverse)
    @shadow_point.smooth_move(x,y,dur,reverse)
  end
  # --------------------------------------------------------------------------
  # New method : Battler update
  # --------------------------------------------------------------------------
  def update
    return if $game_temp.global_freeze && battle_phase != :skill
    update_move           # Update movements (Basic Modules)
    update_smove          # Update smooth movement (Basic Modules)
    update_rotation       # Update rotation
    @shadow_point.update_move # Shadow reposition
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
    if actor? && !@immortal && dead? && PlaySystemSound
      Sound.play_actor_collapse 
    end
    fiber = Fiber.new { tsbs_main_fiber }
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
    @shadow_point.y = y
    @shadow_point.x = x
    @result.clear_tsbs_overall_result
    self.battle_phase = :idle unless battle_phase == :intro
  end
  # --------------------------------------------------------------------------
  # New method : Store fiber in $game_temp
  # --------------------------------------------------------------------------
  def insert_fiber(fiber)
    if actor?
      $game_temp.actors_fiber[id] = fiber
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
      :idle => method(:idle_key),
      :victory => method(:victory_key),
      :hurt => method(:hurt_key),
      :skill => method(:skill_key),
      :evade => method(:evade_key),
      :return => method(:return_key),
      :escape => method(:escape_key),
      :prepare => method(:prepare_key),
      :intro => method(:intro_key),
      :counter => method(:counter_key),
      :collapse => method(:collapse_key),
      :forced => method(:forced_act),
      :covered => method(:covered_key),
    }
    return hash
  end
  # --------------------------------------------------------------------------
  # New method : Idle sequence key
  # --------------------------------------------------------------------------
  # Idle key sequence contains several sequence keys. Include dead sequence,
  # state sequence, critical sequence,and normal sequence. Dead key sequence
  # has the top priority over others. Just look at the below
  # --------------------------------------------------------------------------
  def idle_key
    return data_battler.dead_key if !@immortal && dead? && actor?
    return state_sequence if state_sequence
    return data_battler.critical_key if critical? && 
      !data_battler.critical_key.empty?
    return data_battler.idle_key
  end
  # --------------------------------------------------------------------------
  # New method : Skill sequence key
  # Must be called when item_in_use isn't nil
  # --------------------------------------------------------------------------
  def skill_key
    return item_in_use.seq_key[rand(item_in_use.seq_key.size)]
  end
  # --------------------------------------------------------------------------
  # New method : Return sequence key
  # Must be called when item_in_use isn't nil
  # --------------------------------------------------------------------------
  def return_key
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
  # Miscellaneous keys
  # --------------------------------------------------------------------------
  def escape_key;   data_battler.escape_key;    end
  def victory_key;  data_battler.victory_key;   end
  def hurt_key;     data_battler.hurt_key;      end
  def evade_key;    data_battler.evade_key;     end
  def intro_key;    data_battler.intro_key;     end
  def counter_key;  data_battler.counter_key;   end
  def collapse_key; data_battler.collapse_key;  end
  def covered_key;  evade_key;                  end
  # --------------------------------------------------------------------------
  # New method : Refresh action key
  # --------------------------------------------------------------------------
  def refresh_action_key
    if phase_sequence[battle_phase].call != @used_sequence
      self.battle_phase = battle_phase
    end
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
  def tsbs_main_fiber
    
    # ----- Start ------ #
    @finish = false
    unless @animation_array[0].all?{|init| [nil,false,true,:ori].include?(init)}
      ErrorSound.play
      text = "Sequence : #{@used_sequence}\nYou miss the initial setup"
      msgbox text
      exit
    end
    flip_val = @animation_array[0][2] # Flip Value
    @flip = flip_val if !flip_val.nil?
    @flip = default_flip if flip_val == :ori || (flip_val.nil? && 
      battle_phase != :skill)
    # If battle phase isn't :skill, nil flip value will return the battler
    # flip into default one
    
    @afterimage = @animation_array[0][1]
    tsbs_battler_start
    setup_instant_reset if battle_phase == :intro
    
    # --- Main Loop thread --- #
    loop do
      @acts = animloop
      execute_sequence # Execute sequence array
      end_sequence  # Do end ~
    end
    # --- Main Loop thread --- #
  end
  # --------------------------------------------------------------------------
  # New method : Start
  # --------------------------------------------------------------------------
  def tsbs_battler_start
    reset_force_result
    reset_aftinfo
    reset_timed_hit
    @proj_setup = copy(PROJECTILE_DEFAULT)
    @focus_target = 0
    @autopose = []
    @icon_file = ''
    @ignore_flip_point = false
  end
  # --------------------------------------------------------------------------
  # New method : Reset force result
  # --------------------------------------------------------------------------
  def reset_force_result
    @force_hit = false
    @force_evade = false
    @force_reflect = false
    @force_counter = false
    @force_critical = false
    @force_miss = false
  end
  # --------------------------------------------------------------------------
  # New method : Reset afterimage info
  # --------------------------------------------------------------------------
  def reset_aftinfo
    @afopac = AFTIMG_OPACITY_EASE
    @afrate = AFTIMG_IMAGE_RATE
  end  
  # --------------------------------------------------------------------------
  # New method : Reset timed hit
  # --------------------------------------------------------------------------
  def reset_timed_hit
    @timed_hit = nil
    @timed_hit_setup = TIMED_HIT_SETUP.clone
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
    when SEQUENCE_LOCK_Z;             @lock_z = @acts[1]
    when SEQUENCE_ICON;               setup_icon
    when SEQUENCE_SOUND;              setup_sound
    when SEQUENCE_IF;                 setup_branch
    when SEQUENCE_TIMED_HIT;          setup_timed_hit
    when SEQUENCE_SCREEN;             setup_screen
    when SEQUENCE_ADD_STATE;          setup_add_state
    when SEQUENCE_REM_STATE;          setup_rem_state  
    when SEQUENCE_CHANGE_TARGET;      setup_change_target
    when SEQUENCE_TARGET_MOVE;        setup_target_move
    when SEQUENCE_TARGET_SLIDE;       setup_target_slide
    when SEQUENCE_TARGET_RESET;       setup_target_reset
    when SEQUENCE_BLEND;              @blend = @acts[1]
    when SEQUENCE_FOCUS;              setup_focus
    when SEQUENCE_UNFOCUS;            setup_unfocus
    when SEQUENCE_TARGET_LOCK_Z;      setup_target_z
      # New update list v1.1
    when SEQUENCE_ANIMTOP;            setup_anim_top
    when SEQUENCE_FREEZE;             $game_temp.global_freeze = @acts[1]
    when SEQUENCE_CSTART;             setup_cutin
    when SEQUENCE_CFADE;              setup_cutin_fade
    when SEQUENCE_CMOVE;              setup_cutin_slide
    when SEQUENCE_TARGET_FLIP;        setup_targets_flip
    when SEQUENCE_PLANE_ADD;          setup_add_plane
    when SEQUENCE_PLANE_DEL;          setup_del_plane
    when SEQUENCE_BOOMERANG;          @proj_setup[PROJ_BOOMERANG] = true
    when SEQUENCE_PROJ_AFTERIMAGE;    @proj_setup[PROJ_AFTERIMAGE] = true
    when SEQUENCE_BALLOON;            setup_balloon_icon
      # New update list v1.2
    when SEQUENCE_LOGWINDOW;          setup_log_message
    when SEQUENCE_LOGCLEAR;           get_scene.log_window.clear
    when SEQUENCE_AFTINFO;            setup_aftinfo
    when SEQUENCE_SMMOVE;             setup_smooth_move
    when SEQUENCE_SMSLIDE;            setup_smooth_slide
    when SEQUENCE_SMTARGET;           setup_smooth_move_target
    when SEQUENCE_SMRETURN;           setup_smooth_return
      # New update list v1.3 + v1.3b + v1.3c
    when SEQUENCE_LOOP;               setup_loop
    when SEQUENCE_WHILE;              setup_while
    when SEQUENCE_COLLAPSE;           tsbs_perform_collapse_effect
    when SEQUENCE_FORCED;             setup_force_act
    when SEQUENCE_ANIMBOTTOM;         setup_anim_bottom
    when SEQUENCE_CASE;               setup_switch_case
    when SEQUENCE_INSTANT_RESET;      setup_instant_reset
    when SEQUENCE_ANIMFOLLOW;         setup_anim_follow
    when SEQUENCE_CHANGE_SKILL;       setup_change_skill
    when SEQUENCE_CHECKCOLLAPSE;      setup_check_collapse
    when SEQUENCE_RESETCOUNTER;       get_scene.damage.reset_value
    when SEQUENCE_FORCEHIT;           @force_hit = default_true
    when SEQUENCE_SLOWMOTION;         setup_slow_motion
    when SEQUENCE_TIMESTOP;           setup_timestop
    when SEQUENCE_ONEANIM;            $game_temp.one_animation_flag = true
    when SEQUENCE_PROJ_SCALE;         setup_proj_scale
    when SEQUENCE_COMMON_EVENT;       setup_tsbs_common_event
    when SEQUENCE_GRAPHICS_FREEZE;    Graphics.freeze
    when SEQUENCE_GRAPHICS_TRANS;     setup_transition
      # New update list v1.4
    when SEQUENCE_FORCEDODGE;         @force_evade = default_true
    when SEQUENCE_FORCEREFLECT;       @force_reflect = default_true
    when SEQUENCE_FORCECOUNTER;       @force_counter = default_true
    when SEQUENCE_FORCECRITICAL;      @force_critical = default_true
    when SEQUENCE_FORCEMISS;          @force_miss = default_true
    when SEQUENCE_BACKDROP;           setup_backdrop
    when SEQUENCE_BACKTRANS;          setup_backdrop_transition
    when SEQUENCE_REVERT_BACKDROP;    $game_temp.backdrop.revert;Fiber.yield
    when SEQUENCE_TARGET_FOCUS;       @focus_target = @acts[1]
    when SEQUENCE_SCREEN_FADEOUT;     setup_screen_fadeout
    when SEQUENCE_SCREEN_FADEIN;      setup_screen_fadein
    when SEQUENCE_CHECK_COVER;        setup_check_cover
    when SEQUENCE_STOP_MOVEMENT;      stop_all_movements
    when SEQUENCE_ROTATION;           setup_rotation
    when SEQUENCE_FADEIN;             setup_fadein
    when SEQUENCE_FADEOUT;            setup_fadeout
    when SEQUENCE_IMMORTALING;        setup_immortaling
    when SEQUENCE_END_ACTION;         setup_end_action
    when SEQUENCE_SHADOW_VISIBLE;     $game_temp.shadow_visible = default_true
    when SEQUENCE_AUTOPOSE;           setup_autopose
    when SEQUENCE_ICONFILE;           @icon_file = @acts[1] || ''
    when SEQUENCE_IGNOREFLIP;         @ignore_flip_point = default_true
      # Interesting on addons?
    else;                             custom_sequence_handler
    end
  end
  # --------------------------------------------------------------------------
  # New method : Default true
  # --------------------------------------------------------------------------
  def default_true
    return (@acts[1].nil? ? true : @acts[1])
  end
  # --------------------------------------------------------------------------
  # New method : End fiber loop phase
  # --------------------------------------------------------------------------
  def end_sequence
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
    if @anim_cell.is_a?(Array)
      row = (@anim_cell[0] - 1) * MaxRow
      col = @anim_cell[1] - 1
      @anim_cell = row + col
    end
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
    stop_all_movements
    goto(@acts[1], @acts[2], @acts[3], @acts[4], @acts[5] || 0)
  end
  # --------------------------------------------------------------------------
  # New method : Setup slide [:slide,]
  # --------------------------------------------------------------------------
  def setup_slide
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    stop_all_movements
    xpos = (flip && !@ignore_flip_point ? -@acts[1] : @acts[1])
    ypos = @acts[2]
    slide(xpos, ypos, @acts[3], @acts[4], @acts[5] || 0)
  end
  # --------------------------------------------------------------------------
  # New method : Setup reset [:goto_oripost,]
  # --------------------------------------------------------------------------
  def setup_reset
    stop_all_movements
    goto(@ori_x, @ori_y, @acts[1], @acts[2])
  end
  # --------------------------------------------------------------------------
  # New method : Setup move to target [:move_to_target,]
  # --------------------------------------------------------------------------
  def setup_move_to_target
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    stop_all_movements
    if area_flag
      size = target_array.size
      xpos = target_array.inject(0) {|r,battler| r + battler.x}/size
      ypos = target_array.inject(0) {|r,battler| r + battler.y}/size
      xpos += @acts[1]
      xpos *= -1 if flip && !@ignore_flip_point
      # Get the center coordinate of enemies
      goto(xpos, ypos + @acts[2], @acts[3], @acts[4])
      return
    end
    xpos = target.x + (flip ? -@acts[1] : @acts[1])
    ypos = target.y + @acts[2]
    goto(xpos, ypos, @acts[3], @acts[4], @acts[5] || 0)
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
    msgbox result
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
    return if item_in_use.nil?
    item = copy(item_in_use) 
    # Copy item. In case if you want to modify anything
    
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
        get_scene.tsbs_invoke_item(target, item, self)
        # Check animation guard
        if !item.ignore_anim_guard? && item.parallel_anim?
          target.anim_guard = target.anim_guard_id
          target.anim_guard_mirror = target.flip
        end
      end
    elsif target
      # Damage to single target
      get_scene.tsbs_invoke_item(target, item, self)
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
    sprite.setup_new_animation
  end
  # --------------------------------------------------------------------------
  # New method : Setup animation [:show_anim,]
  # --------------------------------------------------------------------------
  def setup_anim
    if $game_temp.one_animation_flag || (@acts[1].nil? && item_in_use &&
        item_in_use.one_animation)
      handler = get_spriteset.one_anim
      size = target_array.size
      xpos = target_array.inject(0) {|r,battler| r + battler.x}/size
      ypos = target_array.inject(0) {|r,battler| r + battler.y}/size
      zpos = target_array.inject(0) {|r,battler| r + battler.screen_z}/size
      handler.set_position(xpos, ypos, zpos)
      sprites = target_array.collect {|t| t.sprite}
      handler.target_sprites = sprites
      anim_id = (@acts[1].nil? ? item_in_use.animation_id : @acts[1])
      anim_id = atk_animation_id1 if anim_id == -1 && actor?
      mirror = flip || @acts[2]
      $game_temp.one_animation_id = anim_id
      $game_temp.one_animation_flip = mirror
      $game_temp.one_animation_flag = false
    elsif area_flag
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
    target.sprite.setup_new_animation
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
      break if @break_action
    end
    @sequence_stack.pop
    @used_sequence = @sequence_stack[-1]
  end
  # --------------------------------------------------------------------------
  # New method : Setup projectile [:proj_setup,]
  # --------------------------------------------------------------------------
  def setup_projectile
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    
    # Compatibility with previous version 1.3c or older
    prev_setup = [PROJ_POSITION_HEAD, PROJ_POSITION_MID, PROJ_POSITION_FEET]
    if prev_setup.include?(@acts[1])
      return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
      @proj_setup[PROJ_START] = @acts[1]
      @proj_setup[PROJ_END] = @acts[2]
      
    # Reset projectile setup
    elsif @acts[1] == PROJ_RESET
      @proj_setup = copy(PROJECTILE_DEFAULT)
      
    # If it's not hash?
    elsif !@acts[1].is_a?(Hash)
      ErrorSound.play
      text = "Sequence Error on : #{@used_sequence}\n" +
      "#{SEQUENCE_PROJECTILE_SETUP}'s parameter should be hash {}"
      msgbox text
      exit
      
    # Projectile setup for version 1.4
    else
      hash_setup = (@acts[1][PROJ_CHANGE] ? @proj_setup : PROJECTILE_DEFAULT)
      @proj_setup = hash_setup.merge(@acts[1])
    end
  end
  # --------------------------------------------------------------------------
  # New method : Show projectile [:projectile,]
  # --------------------------------------------------------------------------
  def show_projectile
    return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
    if $game_temp.one_animation_flag || item_in_use.one_animation
      t = (area_flag ? target_array : [target])
      get_spriteset.add_projectile(make_projectile(t))
      $game_temp.one_animation_flag = false
    elsif area_flag
      target_array.uniq.each do |target|
        get_spriteset.add_projectile(make_projectile(target))
      end
    else
      get_spriteset.add_projectile(make_projectile(target))
    end
  end
  # --------------------------------------------------------------------------
  # New method : Make Projectile
  # --------------------------------------------------------------------------
  def make_projectile(target)
    spr_self = self.sprite
    proj = Sprite_Projectile.new
    
    # Assign the basic carried information for projectile
    proj.subject = self
    proj.target = target
    
    # Modify carried item
    proj_item = copy(item_in_use)
    scale = @proj_setup[PROJ_SCALE]
    if scale.is_a?(String)
      proj_item.damage.formula = scale
    elsif scale.is_a?(Numeric)
      proj_item.damage.formula = "(#{proj_item.damage.formula})*#{scale}"
    end
    proj.item = proj_item
    
    # Check icon use
    ico = @acts[4]
    icon_index = 0
    begin
      icon_index = (ico.is_a?(String) ? eval(ico) : (ico.nil? ? 0 : ico))
    rescue StandardError => err
      display_error("[#{SEQUENCE_PROJECTILE},]",err)
    end
    proj.icon = icon_index
    proj.setup = @proj_setup.clone
    
    # Add extra information before return
    anim = $data_animations[@acts[1]]
    dur = @acts[2]
    jump = @acts[3] || 0
    proj.dur = dur
    proj.jump = jump
    proj.angle_speed = @acts[5] || 0
    proj.boomerang = @proj_setup[PROJ_BOOMERANG]
    proj.afterimage = @proj_setup[PROJ_AFTERIMAGE]
    proj.start_projectile
    proj.start_animation(anim)
    
    # Returning the projectile sprite
    return proj
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
  # New method : Setup conditional branch [:if,]
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
  # New method : Setup timed hit system (BETA) [:timed_hit,]
  # Will expand it later. I hope ~
  # --------------------------------------------------------------------------
  def setup_timed_hit
    @timed_hit = nil
    if @acts[1].class == Hash
      @timed_hit_setup = TIMED_HIT_SETUP.merge(@acts[1])
      return
    end
    @timed_hit_setup[TIMED_HIT_TIMING_SYMBOL] = @acts[1]
    button = (@acts[2].nil? ? [TIMED_HIT_DEFAULT_BUTTON] : @acts[2])
    button = [button] unless button.is_a?(Array)
    @timed_hit_setup[TIMED_HIT_BUTTON_SYMBOL] = button
    @timed_hit_setup[TIMED_HIT_ANIME_SYMBOL] = @acts[3] || TimedHit_Anim
    @timed_hit_setup[TIMED_HIT_ANIME_FOLLOW] = (@acts[4].nil? ? true : @acts[4])
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
        cx = c # Chance extra
        if !@acts[3]
          cx *= target.state_rate(@acts[1]) if opposite?(self)
          cx *= target.luk_effect_rate(self) if opposite?(self)
        end
        if chance(cx)
          t.add_state(@acts[1]) 
          get_scene.tsbs_redraw_status(t)
        end
      end
      return
    end
    return unless target
    if !@acts[3]
      c *= target.state_rate(@acts[1]) if opposite?(self)
      c *= target.luk_effect_rate(self) if opposite?(self)
    end
    if chance(c)
      target.add_state(@acts[1]) 
      get_scene.tsbs_redraw_status(target)
    end
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
        if chance(c)
          t.remove_state(@acts[1])
          get_scene.tsbs_redraw_status(t)
        end
      end
      return
    end
    return unless target
    if chance(c)
      target.remove_state(@acts[1])
      get_scene.tsbs_redraw_status(target)
    end
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
      @target_array = [@target]
      $game_temp.battler_targets += [@target]
    # -------------------
    when 8  # Next random ally
      self.area_flag = false
      @target = friends_unit.random_target
      @target_array = [@target]
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
      @target_array = [@target]
      $game_temp.battler_targets += [@target]
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup target movement [:target_move,]
  # --------------------------------------------------------------------------
  def setup_target_move
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    args = [@acts[1], @acts[2], @acts[3], @acts[4], @acts[5] || 0]
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
    args = [@acts[1], @acts[2], @acts[3], @acts[4], @acts[5] || 0]
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
    case @focus_target
    when 1; eval_target = "opponents_unit.members.include?(spr.battler)";
    when 2; eval_target = "friends_unit.members.include?(spr.battler)";
    when 3; eval_target = "true";
    else;   eval_target = "target_array.include?(spr.battler)";
    end
    sprset = get_spriteset
    rect = sprset.focus_bg.bitmap.rect
    color = @acts[2] || Focus_BGColor
    sprset.focus_bg.bitmap.fill_rect(rect,color)  # Recolor focus background
    sprset.focus_bg.fadein(@acts[1])        # Trigger fadein
    sprset.battler_sprites.select do |spr|
      !spr.battler.nil? # Select avalaible battler
    end.each do |spr|
      if spr.battler != self && (spr.battler.actor? ? true : spr.battler.alive?)
        check = eval(eval_target)
        spr.fadeout(@acts[1]) if !check
        spr.fadein(@acts[1]) if check
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
    batch = sprset.battler_sprites.select do |spr|
      !spr.battler.nil? # Select avalaible battler
    end
    batch.each do |spr|
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
  # New method : Setup anim top [:anim_top]
  # --------------------------------------------------------------------------
  def setup_anim_top
    $game_temp.anim_top = (@acts[1] == true || @acts[1].nil? ? 1 : 0)
  end
  # --------------------------------------------------------------------------
  # New method : Setup anim bottom [:anim_bottom]
  # --------------------------------------------------------------------------
  def setup_anim_bottom
    $game_temp.anim_top = (@acts[1] == true || @acts[1].nil? ? -1 : 0)
  end
  # --------------------------------------------------------------------------
  # New method : Setup anim follow [:anim_follow]
  # --------------------------------------------------------------------------
  def setup_anim_follow
    $game_temp.anim_follow = default_true
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
    z = (@acts[4] ? Graphics.height + 10 : 4)
    dur = @acts[5] || 2
    opac = @acts[6] || 255
    get_spriteset.battle_plane.set(file,sox,soy,z,dur,opac)
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
  # New method : Setup balloon icon [:balloon]
  # --------------------------------------------------------------------------
  def setup_balloon_icon
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    @balloon_id = @acts[1]
    @balloon_speed = @acts[2] || BALLOON_SPEED
    @balloon_wait = @acts[3] || BALLOON_WAIT
  end
  # --------------------------------------------------------------------------
  # New method : Setup Log Message Window [:log,]
  # --------------------------------------------------------------------------
  def setup_log_message
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    text = @acts[1].gsub(/<name>/i) { self.name }
    text.gsub!(/<target>/) { target.name rescue "" }
    get_scene.log_window.add_text(text)
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
      xpos += @acts[1]
      xpos *= -1 if flip && !@ignore_flip_point
      rev = @acts[3]
      rev = true if rev.nil?
      smooth_move(xpos, ypos + @acts[2], @acts[3])
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
    is_string = action_key.is_a?(String)
    count.times do
      if is_string
        @acts = [:action, action_key]
        execute_sequence
        break if @break_action
      else
        begin
          action_key.each do |action|
            @acts = action
            execute_sequence
            break if @break_action
          end
        rescue
          ErrorSound.play
          text = "Wrong [:loop] parameter!"
          msgbox text
          exit
        end
      end
      break if @break_action
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup 'while' mode loop [:while]
  # --------------------------------------------------------------------------
  def setup_while
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    cond = @acts[1]
    action_key = @acts[2]
    actions = (action_key.class == String ? TSBS::AnimLoop[action_key] :
      action_key)
    if actions.nil?
      show_action_error(action_key)
    end
    begin
      while eval(cond)
        exe_act = actions.clone
        until exe_act.empty? || @break_action
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
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    skill = $data_skills[@acts[1]]
    return unless skill
    self.item_in_use = copy(skill)
  end
  # --------------------------------------------------------------------------
  # New method : Setup check collapse [:check_collapse,]
  # --------------------------------------------------------------------------
  def setup_check_collapse
    target_array.each do |tar|
      tar.target = self
      get_scene.check_collapse(tar)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup check collapse [:slow_motion,]
  # --------------------------------------------------------------------------
  def setup_slow_motion
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    $game_temp.slowmotion_frame = @acts[1]
    $game_temp.slowmotion_rate = @acts[2]
  end
  # --------------------------------------------------------------------------
  # New method : Setup timestop [:timestop,]
  # --------------------------------------------------------------------------
  def setup_timestop
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    @acts[1].times { Graphics.update }
  end
  # --------------------------------------------------------------------------
  # New method : Setup Projectile Damage Scale [:proj_scale,]
  # --------------------------------------------------------------------------
  def setup_proj_scale
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    @proj_setup[PROJ_SCALE] = @acts[1]
  end
  # --------------------------------------------------------------------------
  # New method : Setup common event [:com_event,]
  # --------------------------------------------------------------------------
  def setup_tsbs_common_event
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    @acts[1] = 0 unless @acts[1].is_a?(Numeric)
    $game_temp.tsbs_event = @acts[1]
    Fiber.yield
  end
  # --------------------------------------------------------------------------
  # New method : Setup graphics transition [:scr_trans,]
  # --------------------------------------------------------------------------
  def setup_transition
    return TSBS.error(@acts[0], 2, @used_sequence) if @acts.size < 3
    Fiber.yield
    name = "Graphics/Pictures/" + @acts[1]
    dur = @acts[2]
    vague = @acts[3] || 40
    Graphics.transition(dur, name, vague)
  end
  # --------------------------------------------------------------------------
  # New method : Setup graphics transition [:backdrop,]
  # --------------------------------------------------------------------------
  def setup_backdrop
    $game_temp.backdrop.name_1 = @acts[1] if @acts[1]
    $game_temp.backdrop.name_2 = @acts[2] if @acts[2]
    get_spriteset.update_backdrops
  end
  # --------------------------------------------------------------------------
  # New method : Setup backdrop transition [:back_trans,]
  # --------------------------------------------------------------------------
  def setup_backdrop_transition
    hash_setup = BACKDROP_TRANS_DEFAULT.merge(@acts[1])
    $game_temp.backdrop.trans_setup(hash_setup)
  end
  # --------------------------------------------------------------------------
  # New method : Setup screen fadeout [:scr_fadeout,]
  # --------------------------------------------------------------------------
  def setup_screen_fadeout
    $game_troop.screen.start_fadeout(@acts[1] || 30)
  end
  # --------------------------------------------------------------------------
  # New method : Setup screen fadein [:scr_fadein,]
  # --------------------------------------------------------------------------
  def setup_screen_fadein
    $game_troop.screen.start_fadein(@acts[1] || 30)
  end
  # --------------------------------------------------------------------------
  # New method : Setup check cover [:check_cover,]
  # --------------------------------------------------------------------------
  def setup_check_cover
    return if area_flag
    get_scene.tsbs_apply_substitute(target, item_in_use, self)
  end
  # --------------------------------------------------------------------------
  # New method : Stop all movement [:stop_move]
  # --------------------------------------------------------------------------
  def stop_all_movements
    @move_obj.clear_move_info
    @shadow_point.clear_move_info
    end_smooth_slide
    @shadow_point.end_smooth_slide
  end
  # --------------------------------------------------------------------------
  # New method : Setup rotation [:rotate]
  # --------------------------------------------------------------------------
  def setup_rotation
    return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
    @angle = @acts[1]
    change_angle(@acts[2], @acts[3])
  end
  # --------------------------------------------------------------------------
  # New method : Self fadein [:fadein,]
  # --------------------------------------------------------------------------
  def setup_fadein
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    sprite.fadein(@acts[1])
  end
  # --------------------------------------------------------------------------
  # New method : Self fadeout [:fadeout,]
  # --------------------------------------------------------------------------
  def setup_fadeout
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    sprite.fadeout(@acts[1])
  end
  # --------------------------------------------------------------------------
  # New method : Setup immortaling [:immortal,]
  # --------------------------------------------------------------------------
  def setup_immortaling
    target_array.each do |targ|
      targ.immortal = true
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup break action [::end_action,]
  # --------------------------------------------------------------------------
  def setup_end_action
    @break_action = true
    @finish = true
  end
  # --------------------------------------------------------------------------
  # New method : Setup autopose [:autopose,]
  # --------------------------------------------------------------------------
  def setup_autopose
    return TSBS.error(@acts[0], 3, @used_sequence) if @acts.size < 4
    @battler_index = @acts[1]
    initial_cell = (@acts[2] - 1) * MaxRow
    @autopose.clear
    MaxCol.times do |i|
      @autopose += Array.new(@acts[3]) { initial_cell + i}
    end
  end
  # --------------------------------------------------------------------------
  # New method : Method for wait [:wait,]
  # --------------------------------------------------------------------------
  def method_wait
    Fiber.yield
    @anim_cell = @autopose.shift unless @autopose.empty?
    update_timed_hit if @timed_hit_setup[:timing] > 0
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
    @timed_hit_setup[TIMED_HIT_BUTTON_SYMBOL].each do |button|
      if Input.trigger?(button)
        @timed_hit = button
        @timed_hit_setup[TIMED_HIT_TIMING_SYMBOL] = 1
        anim = $data_animations[@timed_hit_setup[TIMED_HIT_ANIME_SYMBOL]]
        follow = $game_temp.anim_follow
        $game_temp.anim_follow = @timed_hit_setup[TIMED_HIT_ANIME_FOLLOW]
        sprite.start_animation(anim, flip)
        $game_temp.anim_follow = follow
        on_timed_hit_success
        break
      end
    end
    @timed_hit_setup[TIMED_HIT_TIMING_SYMBOL] -= 1
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
    get_animloop_array[0][0] && @battle_phase != :covered
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
    msgbox result
    exit
  end
  # --------------------------------------------------------------------------
  # New method : Action call error handler
  # --------------------------------------------------------------------------
  def show_action_error(string)
    ErrorSound.play
    text = "Sequence key : #{phase_sequence[battle_phase].call}\n" + 
    "Uninitalized Constant for #{string} in :action command"
    msgbox text
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
    Sound.tsbs_play_recovery if item.damage.recover? && PlaySystemSound
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
    if @result.missed && PlaySystemSound
      Sound.tsbs_play_miss
    end
    if @result.evaded
      Sound.tsbs_play_eva if item.physical? && PlaySystemSound
      Sound.tsbs_play_magic_eva if item.magical? && PlaySystemSound
      self.battle_phase = :evade 
      # Automatically switch to evade phase
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : item apply
  # --------------------------------------------------------------------------
  alias tsbs_apply_item item_apply
  def item_apply(user, item)
    if dead? && !item.for_dead_friend? && KeepCountingDamage
      make_damage_value(user, item)
      if $imported["YEA-BattleEngine"] || $imported["YES-BattlePopup"]
        @result.tsbs_yea_compatible = true
        make_damage_popups(user)
        @result.tsbs_yea_compatible = false
      end
      return 
    end
    tsbs_apply_item(user, item)
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
    result = []
    states.each do |state|
      next unless state.skill_guard > 0
      result << [$data_skills[state.skill_guard], state.sg_range]
    end
    return result.uniq
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
  # New method : Anim Behind?
  # --------------------------------------------------------------------------
  def anim_behind?
    states.each do |state|
      return state.anim_behind? if state.state_anim > 0
    end
    return false
  end  
  # --------------------------------------------------------------------------
  # New method : Screen Z
  # --------------------------------------------------------------------------
  def screen_z
    [screen_z_formula,3].max
  end
  # --------------------------------------------------------------------------
  # New method : Screen Z Formula
  # --------------------------------------------------------------------------
  def screen_z_formula
    @shadow_point.screen_y + additional_z
    # Real Y position (without jumping) + Additional Z value
  end
  # --------------------------------------------------------------------------
  # New method : Additional Z Formula
  # --------------------------------------------------------------------------
  def additional_z
    return 0 if [:idle, :hurt, :covered].include?(battle_phase) 
    return 1 if covering
    return 2
    # Active battler displayed above another (increment by 2)
  end
  # --------------------------------------------------------------------------
  # Alias method : Dead?
  # --------------------------------------------------------------------------
  alias tsbs_battler_dead? dead?
  def dead?
    return @hp <= 0 if @immortal
    return tsbs_battler_dead?
  end
  # --------------------------------------------------------------------------
  # Alias method : Alive?
  # --------------------------------------------------------------------------
  alias tsbs_alive? alive?
  def alive?
    return @hp > 0 if @immortal
    return tsbs_alive?
  end
  # --------------------------------------------------------------------------
  # Alias method : Alive?
  # --------------------------------------------------------------------------
  alias tsbs_refresh refresh
  def refresh
    tsbs_refresh
    if @immortal && @hp == 0
      clear_states
      clear_buffs
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : Add state
  # --------------------------------------------------------------------------
  alias tsbs_add_state add_state
  def add_state(state_id)
    return if @immortal && state_id == death_state_id
    tsbs_add_state(state_id)
    refresh_action_key if battle_phase == :idle 
    # Refresh action key if changed
    @refresh_opacity = true 
    # Refresh max opacity
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
    @result.clear_tsbs_overall_result
    if $game_party.in_battle
      reset_pos(10, 0)
      # Automatically reset position on turn end
      get_scene.check_collapse(self) 
      # Check collapse for self
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : On Action End
  # --------------------------------------------------------------------------
  alias tsbs_action_end on_action_end
  def on_action_end
    tsbs_action_end
    @result.clear_tsbs_overall_result
    if $game_party.in_battle
      get_scene.check_collapse(self) 
      # Check collapse for self
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Counterattack rate
  # --------------------------------------------------------------------------
  alias tsbs_counter item_cnt
  def item_cnt(user, item)
    return 0 if item.anti_counter? || user.battle_phase == :counter || 
      covering || dead? || user.area_flag
    return 1 if user.force_counter && self.cnt > 0
    tsbs_counter(user, item)
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Reflection
  # --------------------------------------------------------------------------
  alias tsbs_reflect item_mrf
  def item_mrf(user, item)
    return 0 if item.anti_reflect? || user == self
    return 1 if user.force_reflect
    tsbs_reflect(user, item)
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Evasion
  # --------------------------------------------------------------------------
  alias tsbs_eva item_eva
  def item_eva(user, item)
    return 0 if user.force_hit
    return 0 if item.always_hit?
    return 0 if covering
    return 1 if user.force_evade
    tsbs_eva(user, item)
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Hit
  # --------------------------------------------------------------------------
  alias tsbs_hit item_hit
  def item_hit(user, item)
    return 1 if user.force_hit
    return 1 if item.always_hit?
    return 0 if user.force_miss
    tsbs_hit(user, item)
  end
  # --------------------------------------------------------------------------
  # Alias method : Item Critical
  # --------------------------------------------------------------------------
  alias tsbs_cri item_cri
  def item_cri(user, item)
    return 1 if user.force_critical
    tsbs_cri(user, item)
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
  # --------------------------------------------------------------------------
  # New method : Target real range (pixel)
  # --------------------------------------------------------------------------
  def target_range(trg = @target)
    return 9999 if target.nil?
    return 0 if area_flag
    rx = (self.x - trg.x).abs
    ry = (self.y - trg.y).abs
    return Math.sqrt((rx**2) + (ry**2))
  end
  # --------------------------------------------------------------------------
  # New method : Is event running?
  # --------------------------------------------------------------------------
  def event_running?
    get_scene.event_running?
  end
  # --------------------------------------------------------------------------
  # New method : Shadow position X
  # --------------------------------------------------------------------------
  def shadow_x
    @shadow_point.screen_x
  end
  # --------------------------------------------------------------------------
  # New method : Shadow position Y
  # --------------------------------------------------------------------------
  def shadow_y
    return screen_z - additional_z
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party)
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
    @base_battler_name = data_battler.battler_name
  end
  # --------------------------------------------------------------------------
  # New Method : Clear TSBS
  # --------------------------------------------------------------------------
  def clear_tsbs
    super
    @ori_x = 0
    @ori_y = 0
  end
  # --------------------------------------------------------------------------
  # Overwrite method : Fiber object thread
  # --------------------------------------------------------------------------
  def fiber_obj
    $game_temp.actors_fiber[id]
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
    ActorPos[index][0] || 0 rescue 0
  end
  # --------------------------------------------------------------------------
  # New method : Original Y position
  # --------------------------------------------------------------------------
  def original_y
    ActorPos[index][1] || 0 rescue 0
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
  # New method : Base battler name
  # --------------------------------------------------------------------------
  def base_battler_name
    @base_battler_name
  end
  # --------------------------------------------------------------------------
  # New method : Actor's battler bame
  # Base Name + State Name + _index 
  # --------------------------------------------------------------------------
  def battler_name
    classname = self.class.classname
    name = "#{base_battler_name+classname+state_trans_name}_#{battler_index}"
    unless data_battler.folder_ref.empty?
      name = data_battler.folder_ref + "/" + name
    end
    if flip && custom_flip?
      name += "_flip"
    end
    return name
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
  # Redefine methods : Just to make sure the original method in case if anyone
  # messed up with screen position. e.g, "Luna Engine"
  # --------------------------------------------------------------------------
  def screen_x; @screen_x; end
  def screen_y; @screen_y; end
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
    @shadow_point.x = ($game_troop.troop.members[index].x rescue 0)
    @shadow_point.y = ($game_troop.troop.members[index].y rescue 0)
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
    if data_battler.use_sprite
      name = "#{data_battler.sprite_name + state_trans_name}_#{battler_index}" 
    else
      name = tsbs_ename + state_trans_name
    end
    unless data_battler.folder_ref.empty?
      name = data_battler.folder_ref + "/" + name
    end
    if flip && custom_flip?
      name += "_flip"
    end
    return name
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
  # --------------------------------------------------------------------------
  # Re-alias method : Perform Collapse effect. Well....
  # --------------------------------------------------------------------------
  alias tsbs_collapsound_effect tsbs_perform_collapse_effect
  def tsbs_perform_collapse_effect
    tsbs_collapsound_effect
    data_battler.collapsound.play
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
# ** Game_BattleEvent
#------------------------------------------------------------------------------
#  This class handles common events call in battle scene. It's used within
# Scene_Battle and TSBS wait function.
#==============================================================================

class Game_BattleEvent
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if @event
      @interpreter = Game_Interpreter.new
      @interpreter.setup(@event.list) 
      @event = nil
    else
      @interpreter = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if @interpreter
      @interpreter.update
      unless @interpreter.running?
        @interpreter = nil 
        status_window = get_scene.get_status_window
        status_window.open if status_window 
        # Just in case if someone delete status window :v
      end
    else
      update_tsbs_event
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update_tsbs_event
    if $game_temp.tsbs_event > 0
      id = $game_temp.tsbs_event
      @event = $data_common_events[id]
      $game_temp.tsbs_event = 0
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Active?
  #--------------------------------------------------------------------------
  def active?
    !@interpreter.nil? && @interpreter.running?
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
  include TSBS_AnimRewrite
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
    src_rect.set(@spr_battler.src_rect)
    self.ox = width/2
    self.oy = height
    update_position
    update_state_anim
    update_visibility
  end
  # --------------------------------------------------------------------------
  # * Update sprite position
  # --------------------------------------------------------------------------
  def update_position
    return unless @spr_battler.battler
    move_animation(diff_x, diff_y)
    self.x = @spr_battler.x
    self.y = @spr_battler.y + @spr_battler.oy
    self.z = @spr_battler.z + (anim_behind? ? -2 : 2)
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
    (@spr_battler.y + @spr_battler.oy) - y
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
      zoom = (camera_animation_zoom? ? $tsbs_camera.zoom : 1.0)
      if @ani_mirror
        sprite.x = @ani_ox - (cell_data[i, 1] * zoom)
        sprite.y = @ani_oy + (cell_data[i, 2] * zoom)
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + (cell_data[i, 1] * zoom)
        sprite.y = @ani_oy + (cell_data[i, 2] * zoom)
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + (anim_behind? ? -16 : 1)
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = (cell_data[i, 3] / 100.0) * zoom
      sprite.zoom_y = (cell_data[i, 3] / 100.0) * zoom
      sprite.opacity = cell_data[i, 6] * @spr_battler.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  # --------------------------------------------------------------------------
  # * Fix animation sprites
  # --------------------------------------------------------------------------
  def fix_animation_sprites
    return unless @ani_sprites && @animation
    frame = @animation.frames[frame_index]
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      next unless sprite.visible
      sprite.z = self.z + (anim_behind? ? -16 : 1)
      if camera_animation_zoom? && cell_data[i, 3]
        sprite.zoom_x = (cell_data[i, 3] / 100.0) * $tsbs_camera.zoom
        sprite.zoom_y = (cell_data[i, 3] / 100.0) * $tsbs_camera.zoom
      end
    end
  end
  # --------------------------------------------------------------------------
  # * Redirect flash
  # --------------------------------------------------------------------------
  def flash(*args)
    @spr_battler.flash(*args)
  end
  # --------------------------------------------------------------------------
  # * Anim Behind?
  # --------------------------------------------------------------------------
  def anim_behind?
    return false unless @spr_battler.battler
    return @spr_battler.battler.anim_behind?
  end
  
end

#==============================================================================
# ** Sprite_AnimGuard
#------------------------------------------------------------------------------
#  This sprite handles battler animation guard. It's a simply dummy sprite that
# created from Sprite_Base just for play an animation. Used within the 
# Sprite_Battler class
#==============================================================================

class Sprite_AnimGuard < Sprite_Base
  include TSBS_AnimRewrite
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
    self.oy = height/2
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
      zoom = (camera_animation_zoom? ? $tsbs_camera.zoom : 1.0)
      if @ani_mirror
        sprite.x = @ani_ox - (cell_data[i, 1] * zoom)
        sprite.y = @ani_oy + (cell_data[i, 2] * zoom)
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + (cell_data[i, 1] * zoom)
        sprite.y = @ani_oy + (cell_data[i, 2] * zoom)
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 1 #+ i
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = (cell_data[i, 3] / 100.0) * zoom
      sprite.zoom_y = (cell_data[i, 3] / 100.0) * zoom
      sprite.opacity = cell_data[i, 6] * @spr_battler.opacity / 255.0
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
  # * Overwrite flash
  # --------------------------------------------------------------------------
  def flash(*args)
    @spr_battler.flash(*args)
  end
  # --------------------------------------------------------------------------
  # * Fix animation sprites
  # --------------------------------------------------------------------------
  def fix_animation_sprites
    return unless @ani_sprites && @animation
    frame = @animation.frames[frame_index]
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      next unless sprite.visible
      sprite.z = self.z + 1
      if camera_animation_zoom?
        sprite.zoom_x = (cell_data[i, 3] / 100.0) * $tsbs_camera.zoom
        sprite.zoom_y = (cell_data[i, 3] / 100.0) * $tsbs_camera.zoom
      end
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
  include TSBS_Afterimages
  include TSBS_AnimRewrite
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
    @spr_icon = Sprite_BattlerIcon.new(self,viewport)
    @anim_cell = -1
    @anim_origin = Screen_Point.new
  end
  # --------------------------------------------------------------------------
  # New method : Camera reposition case?
  # --------------------------------------------------------------------------
  def camera_reposition_case?
    $imported[:TSBS_Camera] && @animation.position != 3
  end
  # --------------------------------------------------------------------------
  # Alias method : Set animation origin
  # --------------------------------------------------------------------------
  alias tsbs_set_anim_origin set_animation_origin
  def set_animation_origin
    unless camera_reposition_case?
      tsbs_set_anim_origin
      return
    end
    @anim_origin.x = @battler.x - ox + width / 2
    @anim_origin.y = @battler.y - oy
    if @animation.position == 0
      @anim_origin.y -= height / 2
    elsif @animation.position == 2
      @anim_origin.y += height / 2
    end
    update_anim_origin_reference
  end
  # --------------------------------------------------------------------------
  # New method : Update Animation Origin Reference
  # --------------------------------------------------------------------------
  def update_anim_origin_reference
    @ani_ox = @anim_origin.screen_x
    @ani_oy = @anim_origin.screen_y
  end
  # --------------------------------------------------------------------------
  # Alias method : Start Animation
  # --------------------------------------------------------------------------
  alias tsbs_start_anim start_animation
  def start_animation(anim, mirror = false)
    @anim_top = $game_temp.anim_top
    @anim_follow = $game_temp.anim_follow
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
    src_rect.y = (@anim_cell / MaxCol) * height
    src_rect.x = (@anim_cell % MaxCol) * width
    self.mirror = @battler.battler_flip
  end
  # --------------------------------------------------------------------------
  # Overwrite method : update position
  # --------------------------------------------------------------------------
  def update_position
    self.x = @battler.screen_x
    self.y = @battler.screen_y - (oy * zoom_y)
    self.z = @battler.screen_z
  end
  # --------------------------------------------------------------------------
  # Overwrite method : update origin
  # --------------------------------------------------------------------------
  def update_origin
    if bitmap
      unless @battler && @battler.data_battler.use_sprite
        self.ox = bitmap.width / 2
        self.oy = bitmap.height / 2
      else
        if @anim_cell != @battler.anim_cell
          @anim_cell = @battler.anim_cell
          src_rect.y = (@anim_cell / MaxCol) * height
          src_rect.x = (@anim_cell % MaxCol) * width
        end
        self.ox = src_rect.width/2
        self.oy = height/2
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
    update_tsbs_extras
    update_balloon
    if @battler
      update_anim_position
      update_tsbs_battler_references
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
  # New method : Battler is busy? (for skill)
  # --------------------------------------------------------------------------
  def skill_busy?
    @battler && (BusyPhases - [:collapse]).any? do |phase|
      phase == @battler.battle_phase
    end && !@battler.finish || (@battler && @battler.moving?)
  end
  # --------------------------------------------------------------------------
  # New method : update battler references
  # --------------------------------------------------------------------------
  def update_tsbs_battler_references
    self.visible = @battler.visible
    self.mirror = @battler.battler_flip
    self.tone.set(@battler.state_tone)
    self.angle = @battler.angle
  end
  # --------------------------------------------------------------------------
  # New method : update battler color
  # --------------------------------------------------------------------------
  def update_color
    self.color.set(@battler.state_color) if @color_flash.alpha == 0
    # Note: @color_flash taken from my Basic Modules v1.5b (Clone image)
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
  # New method : update tsbs extras
  # --------------------------------------------------------------------------
  def update_tsbs_extras
    @anim_state.update
    @anim_guard.update
    @shadow.update
    @spr_icon.update
  end
  # --------------------------------------------------------------------------
  # New method : update start balloon
  # --------------------------------------------------------------------------
  def update_start_balloon
    if @battler.balloon_id > 0
      @balloon_id = @battler.balloon_id
      @battler.balloon_id = 0
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
    Sound.play_boss_collapse2 if @effect_duration % 20 == 19
  end
  # --------------------------------------------------------------------------
  # Alias method : dispose
  # --------------------------------------------------------------------------
  alias tsbs_dispose dispose
  def dispose
    tsbs_dispose
    dispose_bitmaps
    @anim_state.dispose
    @anim_guard.dispose
    @shadow.dispose
    @spr_icon.dispose
    @balloon_sprite.dispose if @balloon_sprite
  end
  # --------------------------------------------------------------------------
  # Alias method : dispose
  # --------------------------------------------------------------------------
  def dispose_bitmaps
    @used_bitmap.compact.each do |bmp|
      bmp.dispose unless bmp.disposed?
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
        @balloon_sprite.y = y - oy
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
    return (@battler.nil? ? BALLOON_SPEED : @battler.balloon_speed)
  end
  #--------------------------------------------------------------------------
  # New Method : Wait Time for Last Frame of Balloon
  #--------------------------------------------------------------------------
  def balloon_wait
    return (@battler.nil? ? BALLOON_WAIT : @battler.balloon_wait)
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
    if @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # New Method : Move animation alongside battler (camera relative)
  # --------------------------------------------------------------------------
  def move_animation_camera_relative_follow
    if @animation.position != 3
      last_screen_x = @anim_origin.screen_x
      last_screen_y = @anim_origin.screen_y
      @anim_origin.x = @battler.x
      @anim_origin.y = @battler.y - oy
      update_anim_origin_reference
      dx = (@ani_ox - last_screen_x).round
      dy = (@ani_oy - last_screen_y).round
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  # --------------------------------------------------------------------------
  # New Method : Move animation static (camera relative)
  # --------------------------------------------------------------------------
  def move_animation_camera_relative_static
    if @animation.position != 3
      last_screen_x = @ani_ox
      last_screen_y = @ani_oy
      update_anim_origin_reference
      dx = (@ani_ox - last_screen_x).round
      dy = (@ani_oy - last_screen_y).round
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
    return unless @animation
    camera = $imported[:TSBS_Camera]
    if @anim_follow && !camera
      move_animation(diff_x, diff_y)
    elsif @anim_follow && camera
      move_animation_camera_relative_follow
    elsif camera
      move_animation_camera_relative_static
    end
  end
  # --------------------------------------------------------------------------
  # Alias Method : Flash
  # --------------------------------------------------------------------------
  alias tsbs_color_flash flash
  def flash(color, duration)
    self.color.set(EmptyColor)
    tsbs_color_flash(color, duration)
    @spr_icon.flash(color, duration)
  end
  # --------------------------------------------------------------------------
  # New Method : Is collapsing?
  # --------------------------------------------------------------------------
  def collapsing?
    @effect_type == :collapse
  end
  # --------------------------------------------------------------------------
  # New Method : Update collapse opacity (to prevent rare case bug)
  # --------------------------------------------------------------------------
  def update_collapse_opacity
    self.opacity = 256 - (48 - @effect_duration) * 6
  end
  
end

#==============================================================================
# ** Sprite_Projectile
#------------------------------------------------------------------------------
#  This sprite is used to display projectile. This class is used within the
# Spriteset_Battle class
#==============================================================================
  
class Sprite_Projectile < Sprite_Base
  #============================================================================
  # * Import TSBS constantas
  #----------------------------------------------------------------------------
  include TSBS_Afterimages
  include TSBS_AnimRewrite
  include TSBS
  #============================================================================
  # * Inner sprite class which handles start and end animation
  #----------------------------------------------------------------------------
  class Sprite_ProjAnim < Sprite_Base
    attr_accessor :anim_top
    attr_accessor :target_sprite
    # -------------------------------------------------------------------------
    # * Rewrite animation module
    # -------------------------------------------------------------------------
    include TSBS_AnimRewrite
    # -------------------------------------------------------------------------
    # * Initialize
    # -------------------------------------------------------------------------
    def initialize
      super(nil)
      @anim_top = 0
      @target_sprite = []
      @screen_point = TSBS::Screen_Point.new
      @anim_origin = TSBS::Screen_Point.new
    end
    # -------------------------------------------------------------------------
    # * Set point at once
    # -------------------------------------------------------------------------
    def set_point(x,y,z)
      @screen_point.x = x
      @screen_point.y = y
      self.x = @screen_point.screen_x
      self.y = @screen_point.screen_y
      self.z = z
    end
    # -------------------------------------------------------------------------
    # * Update animation origin reference
    # -------------------------------------------------------------------------
    def update_anim_origin_reference
      @ani_ox = @anim_origin.screen_x
      @ani_oy = @anim_origin.screen_y
    end
    # -------------------------------------------------------------------------
    # * Camera reposition case?
    # -------------------------------------------------------------------------
    def camera_reposition_case?
      $imported[:TSBS_Camera] && @animation.position != 3
    end
    # -------------------------------------------------------------------------
    # * Set animation origin
    # -------------------------------------------------------------------------
    def set_animation_origin
      unless camera_reposition_case?
        super
        return
      end
      @anim_origin.x = @screen_point.x 
      @anim_origin.y = @screen_point.y
      if @animation.position == 0
        @anim_origin.y -= height / 2
      elsif @animation.position == 2
        @anim_origin.y += height / 2
      end
      update_anim_origin_reference
    end
    # -------------------------------------------------------------------------
    # * Move animation camera relative
    # -------------------------------------------------------------------------
    def move_animation_camera_relative_static
      if @animation && @animation.position != 3
        last_screen_x = @ani_ox
        last_screen_y = @ani_oy
        update_anim_origin_reference
        dx = (@ani_ox - last_screen_x).round
        dy = (@ani_oy - last_screen_y).round
        @ani_sprites.each do |sprite|
          sprite.x += dx
          sprite.y += dy
        end
      end
    end
    # -------------------------------------------------------------------------
    # * Update
    # -------------------------------------------------------------------------
    def update
      super
      move_animation_camera_relative_static if $imported[:TSBS_Camera]
    end
    # -------------------------------------------------------------------------
    # * Redirect flash
    # -------------------------------------------------------------------------
    def flash(*args)
      @target_sprite.each {|t| t.sprite.flash(*args)}
    end
  end
  #============================================================================
  # * Dummy Coordinate for measuring screen position
  #----------------------------------------------------------------------------
  class Projectile_Point < Screen_Point
    # -------------------------------------------------------------------------
    # * Public accessor
    # -------------------------------------------------------------------------
    attr_accessor :continue # Continue flag
    attr_accessor :wait     # Wait count
    # -------------------------------------------------------------------------
    # * Initialize
    # -------------------------------------------------------------------------
    def initialize
      super
      @continue = false
      @wait = 0
      @x_speed = 0.0
      @y_speed = 0.0
    end
    # -------------------------------------------------------------------------
    # * Update move
    # -------------------------------------------------------------------------
    def update_move
      if @wait > 0
        @wait -= 1
        return
      end
      if @continue && !moving?
        @x += @x_speed
        @y += @y_speed
        return
      end
      super
    end
    # -------------------------------------------------------------------------
    # * Goto position
    # -------------------------------------------------------------------------
    def goto(xpos, ypos, dur, jump)
      super
      @x_speed = @move_obj.x_speed
      @y_speed = @move_obj.y_speed
    end
  end
  #============================================================================
  # ---------------------------------------------------------------------------
  # * Public accessors
  # ---------------------------------------------------------------------------
  attr_accessor :subject      # Battler subject
  attr_accessor :target       # Battler target
  attr_accessor :item         # Carried item / skill
  attr_accessor :angle_speed  # Angle speed rotation
  attr_accessor :target_aim   # Target Aim
  attr_accessor :boomerang    # Boomerang Flag
  attr_accessor :setup        # Setup hash
  attr_accessor :dur          # Duration
  attr_accessor :jump         # Jump peak  
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize
    super(nil)
    @point = Projectile_Point.new
    @angle = 0.0
    @return = false
    @afterimage_opac = PROJECTILE_DEFAULT[PROJ_AFTOPAC]
    @afterimage_rate = PROJECTILE_DEFAULT[PROJ_AFTRATE]
    @anim_top = PROJECTILE_DEFAULT[PROJ_ANIMPOS]
    @afterimage_dispose = false
    @anim_start = Sprite_ProjAnim.new
    @anim_end = Sprite_ProjAnim.new
  end
  # --------------------------------------------------------------------------
  # * Set viewport
  # --------------------------------------------------------------------------
  def viewport=(vport)
    super
    @anim_start.viewport = @anim_end.viewport = vport
    if @ani_sprites
      @ani_sprites.each {|sprite|  sprite.viewport = vport}
    end
  end
  # --------------------------------------------------------------------------
  # * Set point
  # --------------------------------------------------------------------------
  def set_point(x,y)
    @point.x = x
    @point.y = y
    update_placement
    @anim_start.set_point(x,y,y)
    @anim_start.anim_top = @setup[PROJ_STARTPOS][2] || 0
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
    @anim_start.update
    @anim_end.update
    return wait_for_dispose if @afterimage_dispose || @anim_end_dispose ||
      @pierce_dispose
    @angle += angle_speed unless @point.wait > 0
    self.angle = @angle
    process_dispose if need_dispose?
  end
  # --------------------------------------------------------------------------
  # * Alias method : update movement
  # --------------------------------------------------------------------------
  def update_move
    update_last_coordinate
    @point.update_move
    update_placement
    move_animation(diff_x, diff_y)
  end
  # --------------------------------------------------------------------------
  # * Update placement
  # --------------------------------------------------------------------------
  def update_placement
    self.x = @point.screen_x
    self.y = @point.screen_y
    self.z = @point.real_ypos + additional_z
  end
  # --------------------------------------------------------------------------
  # * Additional Z
  # --------------------------------------------------------------------------
  def additional_z
    init = 5
    if @target.is_a?(Array)
      size = @target.size
      zpos = @target.inject(0) {|r,battler| r + battler.screen_z}/size
      return init + zpos
    end
    case @setup[PROJ_END]
    when PROJ_POSITION_HEAD; init += @target.sprite.height
    when PROJ_POSITION_MID;  init += @target.sprite.height/2
    end
    return init
  end
  # --------------------------------------------------------------------------
  # * Need dispose flag
  # --------------------------------------------------------------------------
  def need_dispose?
    !@point.moving?
  end
  # --------------------------------------------------------------------------
  # * Disposing sprite
  # --------------------------------------------------------------------------
  def process_dispose
    if !target.is_a?(Array) && rand < target.item_mrf(@subject, item) && 
      !@return
      # If not multitargets and target has magic reflection
      target.animation_id = target.data_battler.reflect_anim
      target.result.reflected = true
      get_scene.damage.display_reflect(target)
      repel  # Repel the projectile back to caster
    else
      # If not ~
      if @return # If current projectile is back to caster
        dispose_method
      else
        # If multi targets
        if target.is_a?(Array)
          target.each {|trg| apply_item(trg, false)} 
          unless @setup[PROJ_ANIMEND]
            handler = get_spriteset.one_anim
            size = target.size
            xpos = target.inject(0) {|r,battler| r + battler.screen_x}/size
            ypos = target.inject(0) {|r,battler| r + battler.screen_y}/size
            zpos = target.inject(0) {|r,battler| r + battler.screen_z}/size
            handler.set_position(xpos, ypos, zpos)
            sprites = target.collect {|t| t.sprite}
            handler.target_sprites = sprites
            anim_id = (@setup[PROJ_ANIMEND].nil? ? item.animation_id :
              @setup[PROJ_ANIMEND])
            mirror = subject.flip
            $game_temp.one_animation_id = anim_id
            $game_temp.one_animation_flip = mirror
          end
        else # If single target
          apply_item(target, true)
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
  # * Apply item
  # --------------------------------------------------------------------------
  def apply_item(trg, animation)
    trg = get_scene.tsbs_apply_substitute(trg, item, subject)
    if !@target.is_a?(Array) && @target != trg
      @target = trg 
      @anim_end.target_sprite = [trg]
    end
    get_scene.tsbs_apply_item(trg, item, subject) if 
      @setup[PROJ_DAMAGE_EXE] == 1
    @pierce_dispose = true if @point.continue
    if @setup[PROJ_ANIMEND]
      if @setup[PROJ_ANIMEND] == PROJ_ANIMDEFAULT
        anim = $data_animations[item.animation_id] 
      else
        anim = $data_animations[@setup[PROJ_ANIMEND]]
      end
      @anim_end.start_animation(anim, @subject.flip)
      @anim_end_dispose = true
      return
    end
    return if @setup[PROJ_ANIMHIT] && !trg.result.hit?
    anim_id = trg.anim_guard_id
    cond = anim_id > 0 && !item.damage.recover? && !item.ignore_anim_guard? && 
      !item.parallel_anim?
    if animation
      trg.animation_id = (cond ? anim_id : item.animation_id)
      trg.animation_mirror = subject.flip
    end
    if item.parallel_anim?
      trg.anim_guard = anim_id 
      trg.anim_guard_mirror = trg.flip
    end
  end
  # --------------------------------------------------------------------------
  # * Disposal method
  # --------------------------------------------------------------------------
  def dispose_method
    if @afterimage && !@point.continue
      @afterimage = false
      @afterimage_dispose = true
    elsif !@anim_end_dispose && !@point.continue
      dispose 
    end
  end
  # --------------------------------------------------------------------------
  # * Dispose self until ready for disposed
  # --------------------------------------------------------------------------
  def wait_for_dispose
    self.opacity = (@point.continue ? 255 : 0)
    @afterimage = false if out_of_screen?
    return unless @afterimages.empty?
    return if @anim_end.animation?
    return if @point.continue && !out_of_screen?
    dispose
  end
  # --------------------------------------------------------------------------
  # * Out of screen?
  # --------------------------------------------------------------------------
  def out_of_screen?
    self.x < 0 || self.x > Graphics.width
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
  # --------------------------------------------------------------------------
  # * Overwrite method : goto (Basic Module)
  # --------------------------------------------------------------------------
  def goto(xpos, ypos, dur, jump)
    @point.goto(xpos,ypos,dur,jump)
    @dur = dur
    @jump = jump
  end
  # --------------------------------------------------------------------------
  # * Make aim
  # --------------------------------------------------------------------------
  def make_aim(dur, jump)
    if @target.is_a?(Array)
      size = @target.size
      xpos = @target.inject(0) {|r,battler| r + battler.screen_x}/size 
      ypos = @target.inject(0) {|r,battler| r + battler.screen_y}/size 
      case @setup[PROJ_END] 
      when PROJ_POSITION_NONE; xpos = ypos = 0
      when PROJ_POSITION_SELF
        xpos = @point.x 
        ypos = @point.y
      end
      xpos += @setup[PROJ_ENDPOS][0]
      ypos += @setup[PROJ_ENDPOS][1]
      @anim_end.target_sprite = @target if @setup[PROJ_FLASH_REF][1]
    else
      targ = (@setup[PROJ_REVERSE] ? @subject : @target)
      spr_target = targ.sprite
      xpos = targ.x + @setup[PROJ_ENDPOS][0]
      case @setup[PROJ_END]
      when PROJ_POSITION_HEAD; ypos = targ.y - spr_target.height
      when PROJ_POSITION_MID;  ypos = targ.y - spr_target.height/2
      when PROJ_POSITION_FEET; ypos = targ.y
      when PROJ_POSITION_NONE; ypos = xpos = 0
      when PROJ_POSITION_SELF
        xpos = @point.x + @setup[PROJ_ENDPOS][0]
        ypos = @point.y
      end
      ypos += @setup[PROJ_ENDPOS][1]
      @anim_end.target_sprite = [targ] if @setup[PROJ_FLASH_REF][1]
    end
    @anim_end.set_point(xpos, ypos, ypos)
    @anim_end.anim_top = @setup[PROJ_ENDPOS][2] || 0
    @point.wait = @setup[PROJ_WAITCOUNT]
    goto(xpos,ypos,dur,jump)
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
    @ani_sprites.each {|s| s.dispose }
    make_animation_sprites
    animation_set_sprites(@animation.frames[0])
  end
  # --------------------------------------------------------------------------
  # * Random Reflection?
  # --------------------------------------------------------------------------
  def random_reflect?
    item.random_reflect?
  end
  # --------------------------------------------------------------------------
  # * Start
  # --------------------------------------------------------------------------
  def start_projectile
    subj = (@setup[PROJ_REVERSE] ? @target : @subject)
    subj = @subject if @target.is_a?(Array)
    spr_subj = subj.sprite
    xpos = subj.x + @setup[PROJ_STARTPOS][0]
    case @setup[PROJ_START]
    when PROJ_POSITION_HEAD; ypos = subj.y - spr_subj.height
    when PROJ_POSITION_MID;  ypos = subj.y - spr_subj.height/2
    when PROJ_POSITION_FEET; ypos = subj.y
    when PROJ_POSITION_NONE; ypos = xpos = 0
    else; ypos = subj.y;
    end
    ypos += @setup[PROJ_STARTPOS][1]
    @angle = (self.mirror ? 360 - @setup[PROJ_ANGLE] : @setup[PROJ_ANGLE])
    set_point(xpos, ypos)
    @point.continue = @setup[PROJ_PIERCE]  
    @afterimage_opac = @setup[PROJ_AFTOPAC]
    @afterimage_rate = @setup[PROJ_AFTRATE]
    @anim_top = @setup[PROJ_ANIMPOS]
    if @setup[PROJ_ANIMSTART]
      if @setup[PROJ_ANIMSTART] == PROJ_ANIMDEFAULT
        anim = $data_animations[item.animation_id] 
      else
        anim = $data_animations[@setup[PROJ_ANIMSTART]]
      end
      @anim_start.start_animation(anim,subj.flip)
    end
    @anim_start.target_sprite = [subj.sprite] if @setup[PROJ_FLASH_REF][0]
    apply_item(target, target.is_a?(Array)) if @setup[PROJ_DAMAGE_EXE] == -1
    make_aim(@dur, @jump)
  end
  # --------------------------------------------------------------------------
  # * Dispose
  # --------------------------------------------------------------------------
  def dispose
    super
    @anim_start.dispose
    @anim_end.dispose
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
    update_shadow
    update
  end
  # --------------------------------------------------------------------------
  # * Data Battler
  # --------------------------------------------------------------------------
  def data_battler
    return nil unless @sprite_battler.battler
    return @sprite_battler.battler.data_battler
  end
  # --------------------------------------------------------------------------
  # * Update Size
  # --------------------------------------------------------------------------
  def update_size
    return unless bitmap
    if data_battler && data_battler.shadow_resize
      zoom_x = @sprite_battler.width.to_f / bitmap.width.to_f 
      zoom_y = @sprite_battler.height.to_f / bitmap.height.to_f 
      self.zoom_x = zoom_x * ($imported[:TSBS_Camera] ? $tsbs_camera.zoom : 1.0)
      self.zoom_y = zoom_y * ($imported[:TSBS_Camera] ? $tsbs_camera.zoom : 1.0)
    else
      self.zoom_x = self.zoom_y = 1.0 * ($imported[:TSBS_Camera] ? 
        $tsbs_camera.zoom : 1.0)
    end
    self.ox = width/2
    self.oy = height
  end
  # --------------------------------------------------------------------------
  # * Update position
  # --------------------------------------------------------------------------
  def update_position
    if @sprite_battler.battler
      self.x = @sprite_battler.battler.shadow_x
      self.y = @sprite_battler.battler.shadow_y + shift_y
    end
    self.z = 3
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
    self.visible = (data_battler && !data_battler.no_shadow) && 
      @sprite_battler.visible && TSBS::UseShadow && $game_temp.shadow_visible
  end
  # --------------------------------------------------------------------------
  # * Update Shadow
  # --------------------------------------------------------------------------
  def update_shadow
    if data_battler
      @shadow_name = @sprite_battler.battler.data_battler.custom_shadow
      self.bitmap = Cache.system(@shadow_name)
    end
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
    update_shadow
  end
  # --------------------------------------------------------------------------
  # * Shift Y
  # --------------------------------------------------------------------------
  def shift_y
    return data_battler.shadow_y if data_battler
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
  #============================================================================
  # Dummy Coordinate Class for icon movement
  #----------------------------------------------------------------------------
  class Coordinate
    attr_accessor :x
    attr_accessor :y
    include THEO::Movement  # Import core movement
    # ------------------------------------------------------------------------
    # * Initialize
    # ------------------------------------------------------------------------
    def initialize
      @x = 0
      @y = 0
      set_obj(self)
    end
    # ------------------------------------------------------------------------
  end  
  #============================================================================
  include TSBS              # Import TSBS constantas
  include TSBS_Afterimages  # Afterimage rewrite
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(spr_battler, viewport = nil)
    super(viewport)
    @spr_battler = spr_battler
    @afterimage_opac = 20
    @afterimage_rate = 1
    @dummy = Coordinate.new
    @screen_point = Screen_Point.new
    @above_char = false
    @used_key = ""
    self.anchor = 0
    self.icon_index = 0
  end
  # --------------------------------------------------------------------------
  # * Icon afterimage flag
  # --------------------------------------------------------------------------
  def afterimage
    battler.afterimage rescue false
  end
  # --------------------------------------------------------------------------
  # * Get Battler
  # --------------------------------------------------------------------------
  def battler
    return @spr_battler.battler
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
    if index < 0
      battler = @spr_battler.battler
      name = battler.icon_file(index + 1)
      if name.empty?
        index = index.abs - 3
        self.icon_index = (battler.weapons[index].icon_index rescue 0)
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
  # --------------------------------------------------------------------------
  # * Overwrite bitmap=
  # --------------------------------------------------------------------------
  def bitmap=(bmp)
    super
    update_anchor(@anchor_origin)
  end
  # --------------------------------------------------------------------------
  # * Update anchor origin
  # --------------------------------------------------------------------------
  def update_anchor(value)
    return unless bitmap
    case value
    when 0 # Center
      self.ox = bitmap.width/2
      self.oy = bitmap.height/2
    when 1 # Upper Left
      self.ox = self.oy = 0
    when 2 # Upper Right
      self.ox = bitmap.width
      self.oy = 0
    when 3 # Bottom Left
      self.ox = 0
      self.oy = bitmap.height
    when 4 # Bottom Right
      self.ox = bitmap.width
      self.oy = bitmap.height
    end
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    super
    @dummy.update_move
    return unless battler
    update_placement
    update_afterimage_reference
    update_effects
    update_key unless battler.icon_key.empty?
  end
  # --------------------------------------------------------------------------
  # * Update placement related to battler
  # --------------------------------------------------------------------------
  def update_placement
    @screen_point.x = battler.x + @dummy.x
    @screen_point.y = battler.y + @dummy.y
    self.x = @screen_point.screen_x
    self.y = @screen_point.screen_y
    self.z = battler.screen_z + (@above_char ? 1 : -1)
    sprset = get_spriteset
    self.opacity = @spr_battler.opacity if sprset.class ==
      Spriteset_Battle rescue return
  end
  # --------------------------------------------------------------------------
  # * Update afterimage reference
  # --------------------------------------------------------------------------
  def update_afterimage_reference
    @afterimage_opac = battler.afopac
    @afterimage_rate = battler.afrate
  end
  # --------------------------------------------------------------------------
  # * Update effects
  # --------------------------------------------------------------------------
  def update_effects
    self.tone.set(battler.state_tone)
    self.color.set(battler.state_color) if @color_flash.alpha == 0
  end
  # --------------------------------------------------------------------------
  # * Update icon key
  # --------------------------------------------------------------------------
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
    if array[7].is_a?(String)
      icon_index = (eval(array[7]) rescue 0)
    elsif array[7] >= 0
      icon_index = array[7]
    elsif !array[7].nil?
      if array[7] == -1 # First weapon ~
        icon_index = (battler.weapons[0].icon_index rescue 0)
      elsif array[7] == -2 # Second weapon ~
        icon_index = (battler.weapons[1].icon_index rescue 
          (battler.weapons[0].icon_index rescue 0))
      elsif array[7] <= -3 # Custom icon graphic
        icon_index = -1  
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
  # --------------------------------------------------------------------------
  # * Icon Error Recognition
  # --------------------------------------------------------------------------
  def icon_error
    ErrorSound.play
    text = "Undefined icon key : #{@used_key}"
    msgbox text
    exit
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
# ** Sprite_OneAnim
#------------------------------------------------------------------------------
#  This sprite handles one animation display for area attack
#==============================================================================

class Sprite_OneAnim < Sprite_Base
  attr_accessor :target_sprites
  attr_reader :screen_point
  include TSBS_AnimRewrite
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------
  def initialize(viewport)
    @multianimes = []
    @target_sprites = []
    @screen_point = TSBS::Screen_Point.new
    @anim_origin = TSBS::Screen_Point.new
    super(viewport)
  end
  # --------------------------------------------------------------------------
  # New method : Camera reposition case?
  # --------------------------------------------------------------------------
  def camera_reposition_case?
    $imported[:TSBS_Camera] && @animation.position != 3
  end
  # --------------------------------------------------------------------------
  # Alias method : Set animation origin
  # --------------------------------------------------------------------------
  def set_animation_origin
    unless camera_reposition_case?
      super
      return
    end
    @anim_origin.x = @screen_point.x
    @anim_origin.y = @screen_point.y
    if @animation.position == 0
      @anim_origin.y -= height / 2
    elsif @animation.position == 2
      @anim_origin.y += height / 2
    end
    update_anim_origin_reference
  end
  # --------------------------------------------------------------------------
  # New method : Update Animation Origin Reference
  # --------------------------------------------------------------------------
  def update_anim_origin_reference
    @ani_ox = @anim_origin.screen_x
    @ani_oy = @anim_origin.screen_y
  end
  # --------------------------------------------------------------------------
  # * Start Animation
  # --------------------------------------------------------------------------
  def start_animation(anime, flip = false)
    if $imported[:TSBS_MultiAnime]
      spr_anim = Sprite_MultiAnime.new(viewport, self, anime, flip)
      @multianimes.push(spr_anim)
      return
    end
    @anim_top = $game_temp.anim_top
    super(anime, flip)
  end
  # --------------------------------------------------------------------------
  # * Set Position
  # --------------------------------------------------------------------------
  def set_position(x,y,z)
    @screen_point.x = x
    @screen_point.y = y
    self.x = @screen_point.screen_x
    self.y = @screen_point.screen_y
    self.z = z
  end
  # --------------------------------------------------------------------------
  # * Update
  # --------------------------------------------------------------------------
  def update
    super
    update_one_anim
    @multianimes.delete_if do |anime|
      anime.update
      anime.disposed?
    end
  end
  # --------------------------------------------------------------------------
  # * Update one animation starting flag
  # --------------------------------------------------------------------------
  def update_one_anim
    if $game_temp.one_animation_id > 0
      anim = $data_animations[$game_temp.one_animation_id]
      flip = $game_temp.one_animation_flip
      start_animation(anim, flip)
      $game_temp.one_animation_id = 0
      $game_temp.one_animation_flip = false
    end
  end
  # --------------------------------------------------------------------------
  # * Dispose
  # --------------------------------------------------------------------------
  def dispose
    super
    @multianimes.each do |anime|
      anime.dispose
    end
  end
  # --------------------------------------------------------------------------
  # * Animation?
  # --------------------------------------------------------------------------
  def animation?
    return !@multianimes.empty? if $imported[:TSBS_MultiAnime]
    return super
  end
  # --------------------------------------------------------------------------
  # * Update animation
  # --------------------------------------------------------------------------
  alias tsbs_update_one_anim update_animation
  def update_animation
    return if $imported[:TSBS_MultiAnime]
    tsbs_update_one_anim
  end  
  # --------------------------------------------------------------------------
  # * Overwrite flash
  # --------------------------------------------------------------------------
  def flash(*args)
    @target_sprites.each {|trg| trg.flash(*args)}
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
    init_fade_members
    setfade_obj(self)
    @scroll_ox = 0.0
    @scroll_oy = 0.0
    reset_oxoy
  end
  # --------------------------------------------------------------------------
  # * Reset ori oxoy
  # --------------------------------------------------------------------------
  def reset_oxoy
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
  def set(file, sox, soy, z, show_dur, max_opac = 255)
    self.bitmap = Cache.picture(file)
    reset_oxoy
    @scroll_ox = sox
    @scroll_oy = soy
    self.z = z
    self.opacity = 0
    fade(max_opac, show_dur)
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
  attr_reader :one_anim       # One Animation Sprite
  # --------------------------------------------------------------------------
  # Alias method : Initialize
  # --------------------------------------------------------------------------
  alias tsbs_init initialize
  def initialize
    @projectiles = []
    @backdrop_name1 = battleback1_name
    @backdrop_name2 = battleback2_name
    $game_temp.backdrop.set(@backdrop_name1, @backdrop_name2)
    tsbs_init
  end
  # --------------------------------------------------------------------------
  # Alias method : Create viewports
  # --------------------------------------------------------------------------
  alias tsbs_icon_create_viewport create_viewports
  def create_viewports
    tsbs_icon_create_viewport
    create_focus_sprite
    create_cutin_sprite
    create_battle_planes
    create_oneanim_sprite
  end  
  #--------------------------------------------------------------------------
  # Alias method Create Battle Background (Floor) Sprite
  #--------------------------------------------------------------------------
  alias tsbs_backdrop_1 create_battleback1
  def create_battleback1
    if TSBS::Looping_Background
      @back1_sprite = Plane.new(@viewport1)
      @back1_sprite.bitmap = battleback1_bitmap
      @back1_sprite.z = 0
      return
    end
    tsbs_backdrop_1
  end
  #--------------------------------------------------------------------------
  # Alias method : Create Battle Background (Wall) Sprite
  #--------------------------------------------------------------------------
  alias tsbs_backdrop_2 create_battleback2
  def create_battleback2
    if TSBS::Looping_Background
      @back2_sprite = Plane.new(@viewport1)
      @back2_sprite.bitmap = battleback2_bitmap
      @back2_sprite.z = 1
      return
    end
    tsbs_backdrop_2
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
  # New method : Create one animation dummy sprite (for handler)
  # --------------------------------------------------------------------------
  def create_oneanim_sprite
    @one_anim = Sprite_OneAnim.new(@viewport1)
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
  # New method : spriteset is busy? (for skill)
  # --------------------------------------------------------------------------
  def skill_busy?
    (@enemy_sprites + @actor_sprites).any? do |sprite|
      sprite.skill_busy?
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
    update_backdrops
  end
  # --------------------------------------------------------------------------
  # New method : update tsbs extra graphics
  # --------------------------------------------------------------------------
  def update_tsbs_extra
    @focus_bg.update
    @cutin.update
    @battle_plane.update
    @one_anim.update
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
  # New method : update battlebacks
  # --------------------------------------------------------------------------
  def update_backdrops
    $game_temp.backdrop.looping_position_check(@back1_sprite.bitmap, true)
    $game_temp.backdrop.looping_position_check(@back2_sprite.bitmap, false)
    if TSBS::Looping_Background
      @back1_sprite.ox = -$game_temp.backdrop.screen_x1 
      @back2_sprite.ox = -$game_temp.backdrop.screen_x2 
      @back1_sprite.oy = -$game_temp.backdrop.screen_y1 
      @back2_sprite.oy = -$game_temp.backdrop.screen_y2
    else
      @back1_sprite.x = $game_temp.backdrop.screen_x1
      @back2_sprite.x = $game_temp.backdrop.screen_x2
      @back1_sprite.y = $game_temp.backdrop.screen_y1
      @back2_sprite.y = $game_temp.backdrop.screen_y2
    end
    @back1_sprite.zoom_x = @back1_sprite.zoom_y = $game_temp.backdrop.zoom_1
    @back2_sprite.zoom_x = @back2_sprite.zoom_y = $game_temp.backdrop.zoom_2
    if backdrop_changed?
      Graphics.freeze if $game_temp.backdrop.trans_flag
      @backdrop_name1 = $game_temp.backdrop.name_1
      @backdrop_name2 = $game_temp.backdrop.name_2
      @back1_sprite.bitmap = Cache.battleback1(@backdrop_name1)
      @back2_sprite.bitmap = Cache.battleback2(@backdrop_name2)
      if TSBS::Looping_Background
        $game_temp.backdrop.looping_position_check(@back1_sprite.bitmap, true)
        $game_temp.backdrop.looping_position_check(@back2_sprite.bitmap, false)
        @back1_sprite.ox = -$game_temp.backdrop.screen_x1 
        @back1_sprite.oy = -$game_temp.backdrop.screen_y1 
        @back2_sprite.ox = -$game_temp.backdrop.screen_x2 
        @back2_sprite.oy = -$game_temp.backdrop.screen_y2
      else
        center_sprite(@back1_sprite)
        center_sprite(@back2_sprite)
      end
      name = $game_temp.backdrop.transition
      name = "Graphics/System/" + name unless name.empty?
      if $game_temp.backdrop.trans_flag
        Graphics.transition($game_temp.backdrop.duration,name,
          $game_temp.backdrop.trans_vague) 
      end
      $game_system.backdecor_refresh[:notrans] = false if 
        $imported[:TSBS_BattleDecor]
    end
  end
  # --------------------------------------------------------------------------
  # New method : Backdrop changed?
  # --------------------------------------------------------------------------
  def backdrop_changed?
    @backdrop_name1 != $game_temp.backdrop.name_1 ||
      @backdrop_name2 != $game_temp.backdrop.name_2
  end
  # --------------------------------------------------------------------------
  # New method : add projectiles
  # --------------------------------------------------------------------------
  def add_projectile(proj)
    proj.viewport = @viewport1
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
    battler_sprites.find {|spr| spr.battler == battler }
  end
  # --------------------------------------------------------------------------
  # Alias method : Dispose
  # --------------------------------------------------------------------------
  alias tsbs_dispose dispose
  def dispose
    (@projectiles + [@focus_bg, @cutin, @one_anim]).each do |extra|
      extra.dispose unless extra.disposed?
    end
    @battle_plane.dispose
    tsbs_dispose
  end
  # --------------------------------------------------------------------------
  # New method : Prevent collapse glitch for slow motion effect
  # --------------------------------------------------------------------------
  def prevent_collapse_glitch
    battler_sprites.each do |spr|
      next unless spr.collapsing?
      spr.update_collapse_opacity
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : Animation?
  # --------------------------------------------------------------------------
  alias tsbs_animation? animation?
  def animation?
    tsbs_animation? || @one_anim.animation?
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
  attr_reader :help_window
  # --------------------------------------------------------------------------
  # Alias method : start
  # --------------------------------------------------------------------------
  alias tsbs_start start
  def start
    tsbs_start
    @damage = DamageResults.new(@viewport)
    @battle_event = Game_BattleEvent.new
    @cover_battlers = {}
  end
  # --------------------------------------------------------------------------
  # New method : get status window
  # --------------------------------------------------------------------------
  def get_status_window
    return @status_window if @status_window.is_a?(Window_BattleStatus)
    return nil
  end
  # --------------------------------------------------------------------------
  # New method : Is event running?
  # --------------------------------------------------------------------------
  def event_running?
    @battle_event.active?
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
  # New method : Perform slowmotion
  # Why no Graphics.frame_rate = n ? It makes the graphics screen not 
  # responsive. So, I decided to make this one
  # --------------------------------------------------------------------------
  def perform_slowmotion
    if $game_temp.slowmotion_frame > 0
      ($game_temp.slowmotion_rate - 1).times do
        @spriteset.prevent_collapse_glitch 
        # Just kill weird glitch for collapse effect
        Graphics.update
      end
      $game_temp.slowmotion_frame -= 1
    end
  end
  # --------------------------------------------------------------------------
  # Alias method : update basic
  # --------------------------------------------------------------------------
  alias theo_tsbs_update_basic update_basic
  def update_basic
    perform_slowmotion
    all_battle_members.each do |batt_member|
      if batt_member.actor? && !$game_party.battle_members.include?(batt_member)
        next
      end
      batt_member.update
    end 
    theo_tsbs_update_basic
    $game_temp.backdrop.update
    @damage.update
  end
  # --------------------------------------------------------------------------
  # Overwrite method : use item
  # Compatibility? I will think that later ~
  # --------------------------------------------------------------------------
  def use_item
    item = @subject.current_action.item
    @log_window.display_use_item(@subject, item)
    @subject.use_item(item)
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:before, item, @subject, @subject)
    end
    refresh_status
    targets = @subject.current_action.make_targets.compact
    show_action_sequences(targets, item, @subject)
  end
  # --------------------------------------------------------------------------
  # New method : Wait method exclusively for TSBS
  # --------------------------------------------------------------------------
  def tsbs_wait_update
    update_for_wait
    @battle_event.update
  end
  # --------------------------------------------------------------------------
  # New method : wait for sequence
  # --------------------------------------------------------------------------
  def wait_for_sequence
    tsbs_wait_update
    tsbs_wait_update while @spriteset.busy?
  end
  # --------------------------------------------------------------------------
  # New method : wait for sequence
  # --------------------------------------------------------------------------
  def wait_for_skill_sequence
    tsbs_wait_update
    tsbs_wait_update while @spriteset.skill_busy?
  end
  # --------------------------------------------------------------------------
  # New method : show action sequence
  # --------------------------------------------------------------------------
  def show_action_sequences(targets, item, subj)
    tsbs_action_init(targets, item, subj)
    tsbs_action_pre(targets, item, subj)
    tsbs_action_main(targets, item, subj)
    tsbs_action_post(targets, item, subj)
    tsbs_action_end(targets, item, subj)
    $game_temp.backdrop.reset_transition_flags
    wait(tsbs_wait_dur)
  end
  # --------------------------------------------------------------------------
  # New method : wait duration
  # --------------------------------------------------------------------------
  def tsbs_wait_dur
    return TSBS::TSBS_END_SEQUENCE_WAIT
  end
  # --------------------------------------------------------------------------
  # New method : action initialize
  # --------------------------------------------------------------------------
  def tsbs_action_init(targets, item, subj)
    $game_temp.battler_targets = targets.clone
    subj.target_array = targets
    subj.item_in_use = copy(item)
    if TSBS::AutoImmortal
      all_battle_members.each do |batt|
        next unless batt.exist?
        batt.immortal = true
      end
    end
  end
  # --------------------------------------------------------------------------
  # New method : action preparation sequence
  # --------------------------------------------------------------------------
  def tsbs_action_pre(targets, item, subj)
    # Show preparation sequence ~
    if !item.prepare_key.empty?
      subj.target = targets[0] if targets.size == 1
      subj.battle_phase = :prepare
      wait_for_sequence
    end    
  end
  # --------------------------------------------------------------------------
  # New method : main action sequence
  # --------------------------------------------------------------------------
  def tsbs_action_main(targets, item, subj)
    # Determine if item is not AoE ~
    if !item.area?
      subj.area_flag = false
      # Repeat item sequence for target number times
      targets.each do |target|
        # Change target if the target is currently dead
        if target.dead? && !item.for_dead_friend? 
          target = subj.opponents_unit.random_target
          break if target.nil?
          # Break if there is no target avalaible or force break action
        end
        target = @cover_battlers[target] if @cover_battlers[target]
        # Do sequence
        subj.target = target
        subj.battle_phase = :skill
        wait_for_skill_sequence
        break if [:forced, :idle].include?(subj.battle_phase) || 
          subj.break_action
      end
    # If item is area of effect damage. Do sequence skill only once
    else
      subj.area_flag = true
      subj.battle_phase = :skill
      wait_for_skill_sequence
      subj.area_flag = false
    end
  end
  # --------------------------------------------------------------------------
  # New method : post action execution
  # --------------------------------------------------------------------------
  def tsbs_action_post(targets, item, subj)
    # Determine if item has no return sequence
    subj.break_action = false if subj.break_action
    unless item.no_return? || subj.battle_phase == :forced
      subj.battle_phase = :return 
    else
      subj.battle_phase = :idle
    end
    wait_for_sequence
  end
  # --------------------------------------------------------------------------
  # New method : action ending
  # --------------------------------------------------------------------------
  def tsbs_action_end(targets, item, subj)
    # Clear pointer
    subj.item_in_use = nil
    subj.target = nil
    # Compatibility with YEA Lunatic Object
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:after, item, subj, subj)
    end
    # Show message log if sequence has been finished
    $game_temp.battler_targets += [subj] + @cover_battlers.values
    $game_temp.battler_targets.uniq.compact.each do |target|
      target.result.restore_result_tsbs
      target.result.double_check
      @log_window.display_action_results(target, item)
      target.battle_phase = :idle if target.battle_phase == :covered
      target.reset_pos(15) # Reset battler to current position
      target.result.clear
      target.result.clear_tsbs_overall_result
      check_collapse(target)
      target.refresh_action_key if target.battle_phase == :idle 
    end
    all_battle_members.each do |batt|
      # Reset break action (just to ensure)
      batt.break_action = false
      # Reset immortal
      if TSBS::AutoImmortal
        batt.immortal = false 
      end
    end
    @cover_battlers.each_value {|cb| cb.reset_pos(7); cb.covering = false}
    @cover_battlers.clear
    # Reset damage value
    @damage.reset_value
  end
  # --------------------------------------------------------------------------
  # New method : check collapse
  # --------------------------------------------------------------------------
  def check_collapse(target)
    if target.immortal
      target.immortal = false
      target.refresh
    end
    return if target.actor? && target.collapse_key.empty?
    if target.state?(target.death_state_id) || 
      ($imported["YEA-BattleEngine"] && target.can_collapse?)
      target.target = @subject
      target.perform_collapse_effect 
    end
  end
  # --------------------------------------------------------------------------
  # New method : Invoke item for TSBS
  # --------------------------------------------------------------------------
  def tsbs_invoke_item(target, item, subj = @subject)
    return if item.nil?
    if rand < target.item_cnt(subj, item)
      tsbs_invoke_counter(target, item)
    elsif rand < target.item_mrf(subj, item)
      tsbs_invoke_mreflect(target, item)
    else
      tsbs_apply_item(tsbs_apply_substitute(target, item, subj), item, subj)
    end
  end
  # --------------------------------------------------------------------------
  # New method : Apply subtitue for TSBS
  # --------------------------------------------------------------------------
  def tsbs_apply_substitute(target, item, subj)
    return target if subj.area_flag # Can not subtitue area attack
    return target if target.covering
    return @cover_battlers[target] if @cover_battlers[target]
    if check_substitute(target, item)      
      cover = target.friends_unit.substitute_battler
      if cover && target != cover
        @log_window.display_substitute(cover, target)
        target.battle_phase = :covered unless 
          target.battle_phase == :covered
        target.cover_battler = cover # Change target ...
        @cover_battlers[target] = cover
        subj.target = cover if subj.target != cover
        unless cover.covering
          cover.covering = true
          cover.goto(target.x, target.y, 1, 0)
          cover.update_move
          cover.sprite.opacity = 255 if cover.sprite.opacity < 255
          @damage.display_cover(target)
        end
        return cover
      end
    end
    target
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
    item.damage.type = 1 if item.damage.type == 5 && TSBS::CONVERT_DRAIN
    item.damage.type = 2 if item.damage.type == 6 && TSBS::CONVERT_DRAIN
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
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:prepare, item, subj, target)
      target.item_apply(subj, item)
      lunatic_object_effect(:during, item, subj, target)
    else
      target.item_apply(subj, item)
    end
    return if (item.is_a?(RPG::Skill) && item.id == target.guard_skill_id)
    check_skill_guard(target, item) unless item.is_a?(RPG::Item)
    @damage.start(target.result)
    tsbs_redraw_status(subj)
    tsbs_redraw_status(target) unless target == subj
  end
  # --------------------------------------------------------------------------
  # New method : TSBS redraw status
  # --------------------------------------------------------------------------
  def tsbs_redraw_status(target)
    if $imported["YEA-BattleEngine"]
      status_redraw_target(target)
    elsif target.actor?
      refresh_status
    end
  end
  # --------------------------------------------------------------------------
  # New method : Check skill guard
  # --------------------------------------------------------------------------
  def check_skill_guard(target, item)
    return unless @subject
    return if target == @subject
    return if @subject.friends_unit.members.include?(target)
    return if item.ignore_skill_guard?
    target.skills_guard.each do |sg|
      next if sg[1] > 0 && target.target_range(@subject) < sg[1]
      @subject.item_apply(target, sg[0])
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
    sprite = battler.sprite
    self.x = sprite.x
    self.y = sprite.y - sprite.oy
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
  # Check if use damage counter
  # ---------------------------------------------------------------
    @damage_text.visible = @damage.visible = @hit_text.visible = 
      @hit.visible = TSBS::UseDamageCounter
  # ---------------------------------------------------------------
    update
  end
  # --------------------------------------------------------------------------
  # * Start showing number
  # --------------------------------------------------------------------------
  def start(result)
    result.record_result_tsbs
    @value += result.hp_damage
    @value += result.mp_damage
    @hit_count += 1 if result.hit?
    @damage.start(@value) if @value > 0
    @hit.start(@hit_count)
  end
  # --------------------------------------------------------------------------
  # * Start showing counter
  # --------------------------------------------------------------------------
  def display_counter(battler)
    reset_value
    @result_text.update_position(battler)
    @result_text.start(TSBS::CounterAttack)
  end
  # --------------------------------------------------------------------------
  # * Start showing reflect
  # --------------------------------------------------------------------------
  def display_reflect(battler)
    @result_text.update_position(battler)
    @result_text.start(TSBS::Magic_Reflect)
  end
  # --------------------------------------------------------------------------
  # * Start showing cover
  # --------------------------------------------------------------------------
  def display_cover(battler)
    @result_text.update_position(battler)
    @result_text.start(TSBS::Covered)
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

#==============================================================================
# BELOW THIS LINE ARE SUPPORTED SCRIPT PATCHES!
#==============================================================================
if $imported["YEA-BattleEngine"]
class Scene_Battle
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
  
end
end
#==============================================================================
# YES Damage popup / Luna Engine patch!
#==============================================================================

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
