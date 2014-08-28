#==============================================================================
# TSBS Addon - Battle Camera
# Version : 0.8
# Language : English
# Requires : Theolized SBS version 1.3c
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact :
#------------------------------------------------------------------------------
# *> http://www.rpgmakerid.com
# *> http://www.rpgmakervxace.net
# *> http://theolized.blogspot.com
#==============================================================================
($imported = {})[:TSBS_Camera] = true
#==============================================================================
# Change Logs:
# -----------------------------------------------------------------------------
# 2013.08.28 - Finished initial version 0.8
#==============================================================================
=begin

  ===================
  || Introduction ||
  -------------------
  This script adds battle camera effect where you could move the camera focus
  or even zoom the battle screen.
  
  =================
  || How to use ||
  -----------------
  Put this script below TSBS implementation part.
  To call the camera effect, select one of these command format.
  
  1st Format --> [:camera, scope, [x, y], dur, zoom, (method)],
  2nd Format --> [:camera, "Camera Key"],
  
  Note if you use the first format :
  > Scope   : Scope position where camera should focus. There're 5 avalaible
              options can be used. They're 
              [0: Target] [1: Self] [2: All Enemies] [3: All Allies] 
              [4: Everyone] [5: Screen]
              
  > [x, y]  : Relative position from the scope
  > dur     : Camera move duration in frame
  > zoom    : Camera zoom value. Should filled by float. e.g, 1.0 or 1.5
  > method  : Movement method. Choose between :linear, :circle, or :cubic
  
  Example :
  [:camera, 0, [0, 0], 56, 1.15],
  [:camera, 0, [0, 0], 56, 1.15, :cubic],
  
  Note if you use the second format :
  "Camera Key" is similar as action key. It stored in CAM_PRESETUP in 
  configuration part below.
  
  To reset the position of camera, call this command
  Format --> [:cam_reset, dur, (method)],
  
  =====================
  || Developer note ||
  ---------------------
  > May have a glitch if used together with realistic shadow
  > Not yet tested with extensive testing. So, it might has glitches or bugs
  > May continue to develop this script after upgrading TSBS to the next 
    version. Since the current structure of TSBS version(1.3c) isn't good 
    enough.
  
  ===================
  || Terms of use ||
  -------------------
  Credit me, TheoAllen. You are free to edit this script by your own. As long
  as you don't claim it yours. For commercial purpose, don't forget to give me
  a free copy of the game.

  =====================
  || Special Thanks ||
  ---------------------
  - Galenmereth / Tor Damian Design for easing movement algorithm
  - Journey Battle System / Tankentai VXA as inspiration
  - Anyone who requested this feature
  
=end
#==============================================================================
# * Editable region
#==============================================================================
module TSBS # <-- Do not touch
 #============================================================================
  DEFAULT_CAM_METHOD = :cubic
 #----------------------------------------------------------------------------
 # Default camera movement method. There're three avalaible movement methods.
 # Choose between them
 # > :linear 
 # > :cubic
 # > :circle
 # 
 # For constant movement, choose :linear
 # For smoother movement, choose either :cubic or :circle
 #============================================================================
 # Camera pre setup. Made for easier call
 #============================================================================
  CAM_PRESETUP = {
# "Camera Key"  => [scope,[x, y], dur, zoom, (method)]
  "Everyone"    => [4    ,[0, 0],  56,  1.0],
  "Screen"      => [5    ,[0, 0],  56,  1.0],
 
  } # <-- don't touch
 
 #============================================================================
 # Camera command call. Used to call camera function like [:camera, ...]
 #----------------------------------------------------------------------------
  CAMERA_MOVE     = :camera
  CAMERA_RESET    = :cam_reset
 #============================================================================= 
end # <-- Do not touch
#==============================================================================
# * End of editable region
#------------------------------------------------------------------------------
# Below this line may dangerous to enter. There're many monster inside. Do not
# enter unless you're pretty confident or have sufficient skills.
#==============================================================================
module TSBS
#==============================================================================
# ** TSBS::Camera
#------------------------------------------------------------------------------
#  This class handles camera metadata
#==============================================================================
  class Camera
    attr_accessor :zoom
    attr_accessor :x
    attr_accessor :y
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    def initialize
      reset_camera
      clear_movement_flag
    end
    #--------------------------------------------------------------------------
    # * Reset camera metadata
    #--------------------------------------------------------------------------
    def reset_camera
      @zoom = 1.0
      @x = 0.0
      @y = 0.0
    end
    #--------------------------------------------------------------------------
    # * Clear movement flag
    #--------------------------------------------------------------------------
    def clear_movement_flag
      @fiber = nil
      @total_dur = 0
      @duration = 0
      @ori_x = 0.0
      @ori_y = 0.0
      @ori_zoom = 0.0
      @target_x = 0.0
      @target_y = 0.0
      @target_zoom = 0.0
    end
    #--------------------------------------------------------------------------
    # * Move camera
    #--------------------------------------------------------------------------
    def move_camera(battlers, x, y, dur, zoom, method)
      clear_movement_flag
      @duration = dur
      if battlers
        size = battlers.size
        point_x = battlers.inject(0) {|r, battler| r + battler.rel_x}.to_f/size
        point_y = battlers.inject(0) {|r, battler| r + battler.rel_y}.to_f/size
      else
        point_x = 0
        point_y = 0
      end
      @ori_x = @x
      @ori_y = @y
      @ori_zoom = @zoom
      @target_x = (point_x + x).to_f 
      @target_y = (point_y + y).to_f
      @target_zoom = zoom
      @fiber = Fiber.new { update_camera(method) }
    end
    #--------------------------------------------------------------------------
    # * The adjustment position of X for an object
    #--------------------------------------------------------------------------
    def adjust_x(obj)
      dist = Graphics.width/2 - obj.x
      return (@x * @zoom) + (dist * (@zoom - 1.0))
    end
    #--------------------------------------------------------------------------
    # * The adjustment position of Y for an object
    #--------------------------------------------------------------------------
    def adjust_y(obj)
      dist = Graphics.height/2 - obj.y
      return (@y * @zoom) + (dist * (@zoom - 1.0))
    end
    #--------------------------------------------------------------------------
    # * Update. Called once per frame
    #--------------------------------------------------------------------------
    def update
      @fiber.resume if @fiber
    end
    #--------------------------------------------------------------------------
    # * Update camera movement
    #--------------------------------------------------------------------------
    def update_camera(method_name)
      @duration.times do |t|
        @x = send(method_name, t, @ori_x, @target_x - @ori_x, @duration)
        @y = send(method_name, t, @ori_y, @target_y - @ori_y, @duration)
        @zoom = send(method_name, t, @ori_zoom, @target_zoom - @ori_zoom, 
          @duration)
        Fiber.yield
      end
      @x = @target_x
      @y = @target_y
      @zoom = @target_zoom
      clear_movement_flag
    end
    # -------------------------------------------------------------------------
    # * Easing movement method : Linear
    # -------------------------------------------------------------------------
    def linear(time, start, change, total_time)
      return change * time / total_time + start
    end
    # -------------------------------------------------------------------------
    # * Easing movement method : Circle
    # -------------------------------------------------------------------------
    def circle(time, start, change, total_time)
      return change * Math.sqrt(1 - (time=time/total_time.to_f-1)*time) + start
    end
    # -------------------------------------------------------------------------
    # * Easing movement method : Cubic
    # -------------------------------------------------------------------------
    def cubic(time, start, change, total_time)
      time /= total_time.to_f
      time -= 1
      return change*(time*time*time + 1) + start
    end
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
  # Alias method : Create game objects
  # --------------------------------------------------------------------------  
  alias tsbs_cam_create_obj create_game_objects
  def create_game_objects
    tsbs_cam_create_obj
    $tsbs_camera = TSBS::Camera.new
  end
  
end

#==============================================================================
# ** Game_BattleBack
#------------------------------------------------------------------------------
#  This class handles battleback metadata to simulate battleback replacement.
# Instance of this class included within the Game_Temp class
#==============================================================================

class Game_BattleBack
  attr_accessor :x
  attr_accessor :y
  # --------------------------------------------------------------------------
  # * Initialize
  # --------------------------------------------------------------------------  
  def initialize
    @x = Graphics.width/2
    @y = Graphics.height/2
  end
  # --------------------------------------------------------------------------
  # * Screen X display
  # --------------------------------------------------------------------------
  def screen_x
    @x - $tsbs_camera.adjust_x(self)
  end
  # --------------------------------------------------------------------------
  # * Screen Y display
  # --------------------------------------------------------------------------
  def screen_y
    @y - $tsbs_camera.adjust_y(self)
  end
  
end

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
# The instance of this class is referenced by $game_temp.
#==============================================================================

class Game_Temp
  attr_reader :battleback
  # --------------------------------------------------------------------------
  # Alias method : Initialize
  # --------------------------------------------------------------------------
  alias tsbs_cam_init initialize
  def initialize
    tsbs_cam_init
    @battleback = Game_BattleBack.new
  end
  
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================

class Game_Battler
  # --------------------------------------------------------------------------
  # New method : Relative X position from center
  # --------------------------------------------------------------------------
  def rel_x
    return x - Graphics.width/2
  end
  # --------------------------------------------------------------------------
  # New method: Relative Y position from center
  # --------------------------------------------------------------------------
  def rel_y
    return y - Graphics.height/2
  end
  # --------------------------------------------------------------------------
  # Alias method : Custom sequence handler
  # --------------------------------------------------------------------------
  alias tsbs_cam_custom_sequence custom_sequence_handler
  def custom_sequence_handler
    tsbs_cam_custom_sequence
    case @acts[0]
    when CAMERA_MOVE;   setup_camera_move
    when CAMERA_RESET;  setup_camera_reset
    end
  end
  # --------------------------------------------------------------------------
  # New method : Setup camera move
  # --------------------------------------------------------------------------
  def setup_camera_move
    if @acts[1].is_a?(String)
      camera = CAM_PRESETUP[@acts[1]]
      if camera.nil?
        ErrorSound.play
        text = "Camera error on : #{@used_sequence}\n" + 
        "Uninitialized camera constant \"#{@acts[1]}\""
        msgbox text
        exit
      end
      @acts = @act[0] + camera
    end
    return TSBS.error(@acts[0], 4, @used_sequence) if @acts.size < 5
    case @acts[1]
    when 0 # Current target
      battlers = target_array
    when 1 # Self
      battlers = [self]
    when 2 # All Enemies
      battlers = opponents_unit.alive_members
    when 3 # All Allies
      battlers = friends_unit.alive_members
    when 4 # Everyone
      battlers = opponents_unit.alive_members + friends_unit.alive_members
    when 5 # Screen
      battlers = nil
    else
      battlers = nil
    end
    unless @acts[2].is_a?(Array)
      ErrorSound.play
      msgbox "Camera error on : #{@used_sequence}\n" + 
      "Second parameter should be array"
      exit
    end
    point_x = @acts[2][0]
    point_y = @acts[2][1]
    dur = @acts[3]
    zoom = @acts[4]
    method = @acts[5] || DEFAULT_CAM_METHOD
    unless $tsbs_camera.respond_to?(method)
      ErrorSound.play
      msgbox "Camera error on : #{@used_sequence}\nWrong method name"
      exit
    end
    $tsbs_camera.move_camera(battlers, point_x, point_y, dur, zoom, method)
  end
  # --------------------------------------------------------------------------
  # New method : Setup camera reset
  # --------------------------------------------------------------------------
  def setup_camera_reset
    return TSBS.error(@acts[0], 1, @used_sequence) if @acts.size < 2
    $tsbs_camera.move_camera(nil, 0, 0, @acts[1], 1.0, @acts[2] || 
      DEFAULT_CAM_METHOD)
  end
  # --------------------------------------------------------------------------
  # Alias method : Shadow Y positioning
  # --------------------------------------------------------------------------
  alias tsbs_cam_shadow_y shadow_y
  def shadow_y
    tsbs_cam_shadow_y - $tsbs_camera.adjust_y(self)
  end
  
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party)
#==============================================================================

class Game_Actor
  alias tsbs_cam_screen_x screen_x
  alias tsbs_cam_screen_y screen_y
  # --------------------------------------------------------------------------
  # Alias method : Screen X
  # --------------------------------------------------------------------------
  def screen_x
    tsbs_cam_screen_x - $tsbs_camera.adjust_x(self)
  end
  # --------------------------------------------------------------------------
  # Alias method : Screen Y
  # --------------------------------------------------------------------------
  def screen_y
    tsbs_cam_screen_y - $tsbs_camera.adjust_y(self)
  end
  
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class 
# ($game_troop).
#==============================================================================

class Game_Enemy
  alias tsbs_cam_screen_x screen_x
  alias tsbs_cam_screen_y screen_y
  # --------------------------------------------------------------------------
  # Alias method : Screen X
  # --------------------------------------------------------------------------
  def screen_x
    tsbs_cam_screen_x - $tsbs_camera.adjust_x(self)
  end
  # --------------------------------------------------------------------------
  # Alias method : Screen Y
  # --------------------------------------------------------------------------
  def screen_y
    tsbs_cam_screen_y - $tsbs_camera.adjust_y(self)
  end
  
end

#==============================================================================
# ** Sprite_BattlerIcon
#------------------------------------------------------------------------------
#  This sprite is used to display battler's Icon. It observes icon key from
# Game_Battler class and automatically changes sprite display when triggered.
#==============================================================================

class Sprite_BattlerIcon
  # --------------------------------------------------------------------------
  # Alias method : Update
  # --------------------------------------------------------------------------
  alias tsbs_cam_update update
  def update
    tsbs_cam_update
    self.zoom_x = self.zoom_y = $tsbs_camera.zoom
  end
  
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display battlers. It observes an instance of the
# Game_Battler class and automatically changes sprite states.
#==============================================================================

class Sprite_Battler
  # --------------------------------------------------------------------------
  # Alias method : Update
  # --------------------------------------------------------------------------
  alias tsbs_cam_update update
  def update
    tsbs_cam_update
    zoom = $tsbs_camera.zoom
    self.zoom_x = zoom
    self.zoom_y = zoom
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
  # Alias method : Update
  # --------------------------------------------------------------------------
  alias tsbs_cam_update update
  def update
    tsbs_cam_update
    @back1_sprite.x = @back2_sprite.x = $game_temp.battleback.screen_x
    @back1_sprite.y = @back2_sprite.y = $game_temp.battleback.screen_y
    @back1_sprite.zoom_x = @back2_sprite.zoom_x = $tsbs_camera.zoom
    @back1_sprite.zoom_y = @back2_sprite.zoom_y = $tsbs_camera.zoom
  end
  
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  # --------------------------------------------------------------------------
  # Alias method : Update basic
  # --------------------------------------------------------------------------
  alias tsbs_cam_update_basic update_basic
  def update_basic
    tsbs_cam_update_basic
    $tsbs_camera.update
  end
  
end
