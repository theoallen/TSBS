#===============================================================================
# TSBS Addon - Animated Actor on Menu
# Version : 1.0b
# Language : English
#-------------------------------------------------------------------------------
# Requires : 
# > Theolized SBS version 1.4 or more
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact :
#-------------------------------------------------------------------------------
# *> http://www.rpgmakerid.com
# *> http://www.rpgmakervxace.net
# *> http://www.theolized.com
#===============================================================================
($imported ||= {})[:TSBS_ActorMenu] = true
#===============================================================================
# Change Logs:
#-------------------------------------------------------------------------------
# 2015.02.01 - Fixed glicth where the actors appeared in item menu.
# 2015.01.30 - Initiali Release
#===============================================================================
=begin

  =====================
  *) Introduction :
  ---------------------
  I noticed some of people want to display animated actor on the menu. So I 
  made this script
  
  =====================
  *) How to use :
  ---------------------
  Put this script below TSBS. Actor will use the default idle animation
  This script will works in default menu. I havent tested yet in various 
  custom menu script. Well, as long as they use the default function in 
  default script, it should works

=end
#===============================================================================
# * Configuration
#===============================================================================
module TSBS
  #-----------------------------------------------------------------------------
  # These position are relative to the menu cursor. Where the center / anchor
  # points are on the left top of the menu cursor. 
  #-----------------------------------------------------------------------------
  ActorMenu_X = 96 - 16
  ActorMenu_Y = 96
  
end
#===============================================================================
# * End of configuration
#===============================================================================
if $imported[:TSBS]
#===============================================================================
# ** Game_Actor
#===============================================================================
class Game_Actor
  #---------------------------------------------------------------------------
  # * Alias X=
  #---------------------------------------------------------------------------
  alias tsbs_animmenu_x= x=
  def x=(x)
    self.tsbs_animmenu_x = x
    @shadow_point.x = x unless SceneManager.in_battle?
  end
  
  #---------------------------------------------------------------------------
  # * Alias Y=
  #---------------------------------------------------------------------------
  alias tsbs_animmenu_y= y=
  def y=(y)
    self.tsbs_animmenu_y = y
    @shadow_point.y = y unless SceneManager.in_battle?
  end
  
end
#===============================================================================
# ** Window_MenuStatus
#===============================================================================
class Window_MenuStatus
  #---------------------------------------------------------------------------
  # * Alias Initialize
  #---------------------------------------------------------------------------
  alias tsbs_animmenu_init initialize
  def initialize(x,y)
    tsbs_animmenu_init(x,y)
    @inner_viewport = Viewport.new
    @inner_viewport.z = 200
    @inner_sprites = $game_party.members.collect do |actor|
      actor.battle_phase = :idle 
      Sprite_Battler.new(@inner_viewport, actor)
    end
    update_viewport
    update_sprites
  end
  
  #---------------------------------------------------------------------------
  # * Alias update
  #---------------------------------------------------------------------------
  alias tsbs_animmenu_update update
  def update
    tsbs_animmenu_update
    update_viewport
    update_sprites
  end
  
  #---------------------------------------------------------------------------
  # * New update viewport
  #---------------------------------------------------------------------------
  def update_viewport
    return unless @inner_viewport # just in case
    args = [global_x + standard_padding, global_y+standard_padding, 
      width-standard_padding*2,height-standard_padding*2]
    @inner_viewport.rect.set(*args)
    @inner_viewport.ox = self.ox
    @inner_viewport.oy = self.oy
  end
  
  #---------------------------------------------------------------------------
  # * New update sprites
  #---------------------------------------------------------------------------
  def update_sprites
    return unless @inner_sprites # just in case
    $game_party.members.each_with_index do |m,i| 
      rect = item_rect(i)
      m.x = rect.x + TSBS::ActorMenu_X
      m.y = rect.y + TSBS::ActorMenu_Y
      m.update
    end
    @inner_sprites.each {|spr| spr.update; spr.visible = visible_case}
  end
  
  #---------------------------------------------------------------------------
  # * Visible case
  #---------------------------------------------------------------------------
  def visible_case
    visible && open
  end
  
  #---------------------------------------------------------------------------
  # * Global X position in screen
  #---------------------------------------------------------------------------
  def global_x
    viewport ? viewport.x + x : x
  end
  
  #---------------------------------------------------------------------------
  # * Global Y position in screen
  #---------------------------------------------------------------------------
  def global_y
    viewport ? viewport.y + y : y
  end
  
  #---------------------------------------------------------------------------
  # * Alias dispose
  #---------------------------------------------------------------------------
  alias tsbs_animmenu_dispose dispose
  def dispose
    tsbs_animmenu_dispose
    @inner_sprites.each {|spr| spr.dispose}
    @inner_viewport.dispose
  end
  
end

end # End $imported
