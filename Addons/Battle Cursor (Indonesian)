# =============================================================================
# Theolized Sideview Battle System (TSBS) - Cursor Addon
# Version : 1.1
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# (This script documentation is written in informal indonesian language)
# -----------------------------------------------------------------------------
# Requires :
# >> Theolized SBS
# >> YEA - Battle Engine
# =============================================================================
($imported ||= {})[:TSBS_Cursor] = true
# =============================================================================
# Change Logs:
# -----------------------------------------------------------------------------
# 2014.05.02 - Added flash function beside hightlight
# 2014.04.25 - Prevent error when finishing battle test
# 2014.01.16 - Finished script
# =============================================================================
=begin

  Perkenalan :
  Script ini adalah addon untuk nampilin kursor pada TSBS. Dan hanya berfungsi
  jika kamu menggunakan YEA - Battle Engine dan TSBS
  
  Cara penggunaan :
  Taruh script ini di bawah semua script TSBS namun di atas main
  Taruh cursor dengan ukuran gambar 1x3 pada Graphics/system dan namakan
  filenya dengan "cursor.png"

=end
# =============================================================================
# Configuration
# =============================================================================
module TSBS
  module Cursor
    
    HighLight     = false  # Highlight battler?
    Refresh_Rate  = 5      # Refresh rate untuk cursor
    
    FlashColor = Color.new(255,255,255,150)
    FlashDur = 15
    
  end
end
# =============================================================================
# End of config
# =============================================================================
class Game_Battler
  attr_writer :selected
  
  def selected
    @selected && exist?
  end
  
end

class Game_Actor
  def selected
    super || (BattleManager.actor == self && 
      SceneManager.scene.actor_active_case) rescue false
  end
end

class Window_BattleEnemy
  # --------------------------------------------------------------------------
  # Overwrite window battle enemy
  # --------------------------------------------------------------------------
  def update
    super
    unless active
      for en in $game_troop.alive_members
        en.selected = false
      end
      return
    end
    if select_all?
      for en in $game_troop.alive_members
        en.selected = true
      end
    else
      enemy.selected = true
      for en in $game_troop.alive_members
        next if en == enemy
        en.selected = false
      end
    end
  end
  
end

class Window_BattleActor
  
  alias tsbs_yeabe_cursor_addon_update update
  def update
    tsbs_yeabe_cursor_addon_update
    unless active
      for ac in $game_party.members
        ac.selected = false
      end
      return
    end
    if @cursor_all
      for ac in $game_party.members
        ac.selected = true
      end
    else
      actor.selected = true
      for ac in $game_party.members
        next if ac == actor
        ac.selected = false
      end
    end
  end
    
end

class Sprite_CursorAid < Sprite
  attr_reader :sprite_battler
  Cursor_Patt = [0,1,2,1]
  
  def initialize(sprite_battler, viewport = nil)
    super(viewport)
    @sprite_battler = sprite_battler
    self.bitmap = Cache.system("cursor")
    @count = 0
    @pattern = 1
    src_rect.height = bitmap.height / 3
    update
  end
  
  def update
    super
    update_visibility
    update_src_rect
    return unless visible
    update_mirror
    update_placement
  end
  
  def update_mirror
    self.mirror = sprite_battler.battler.enemy? if sprite_battler.battler
  end
  
  def update_placement
    self.x = xpos_case
    self.y = sprite_battler.y - sprite_battler.height
    self.z = sprite_battler.z + 100
  end
  
  def update_visibility
    self.visible = sprite_battler.selected && !BattleManager.in_turn?
  end
  
  def update_src_rect
    @count += 1
    if @count % TSBS::Cursor::Refresh_Rate == 0
      @pattern += 1
      patt = Cursor_Patt[@pattern % Cursor_Patt.size]
      src_rect.y = patt
    end
  end
  
  def xpos_case
    return 0 unless sprite_battler.battler
    return sprite_battler.x + sprite_battler.width/2 if 
      sprite_battler.battler.enemy?
    return sprite_battler.x - sprite_battler.width/2 - width
  end
  
end

class Sprite_Battler
  attr_accessor :selected
  
  alias tsbs_yeabe_cursor_addon_init initialize
  def initialize(*args)
    tsbs_yeabe_cursor_addon_init(*args)
    @cursor_viewport = Viewport.new
    @cursor_viewport.z = 300
    @cursor = Sprite_CursorAid.new(self,@cursor_viewport)
    @selected = false
    @select_dur = 0
  end
  
  alias tsbs_yeabe_cursor_addon_update update
  def update
    tsbs_yeabe_cursor_addon_update
    update_selection
    update_cursor_selection
  end
  
  def update_selection
    return unless @battler
    @selected = @battler.selected
    @select_dur -= 1
    if @selected && TSBS::Cursor::HighLight
      @battler.sprite_effect_type = :whiten if !(@effect_type == :appear)
    end
    if @selected && TSBS::Cursor::FlashColor && @select_dur <= 0
      col = TSBS::Cursor::FlashColor
      @select_dur = dur = TSBS::Cursor::FlashDur
      self.flash(col,dur)
    end
  end
  
  def update_cursor_selection
    @cursor.update
  end
  
  alias tsbs_yeabe_cursor_addon_dispose dispose
  def dispose
    tsbs_yeabe_cursor_addon_dispose
    @cursor.dispose
    @cursor_viewport.dispose
  end
  
end

class Scene_Base
  def actor_active_case
    return false
  end
end

class Scene_Battle
  
  def actor_active_case
    @actor_command_window.active || @skill_window.active || @item_window.active
  end
  
end
