# =============================================================================
# Theolized Sideview Battle System (TSBS) - Multiple Animations
# Version : 1.1
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# (This script documentation is written in informal indonesian language)
# -----------------------------------------------------------------------------
# Requires :
# >> Theolized SBS v1.3 or more
# =============================================================================
($imported ||= {})[:TSBS_MultiAnime] = true
# =============================================================================
# Change Logs:
# -----------------------------------------------------------------------------
# 2014.06.23 - Multiple animation on anim guard
# 2014.05.13 - Fixed wrong animation flash target
# 2014.05.02 - Finished script
# =============================================================================
=begin

  Perkenalan :
  Di default script, seandainya animasi pada battler masih berjalan, jika kita
  play animasi baru, maka yang sebelumnya akan dihapus dan diganti. Script ini
  memungkinkan kalian bisa ngeplay animasi bersamaan dengan animasi sebelumnya
  yang masih berjalan.
  
  Cara penggunaan :
  Pasang script ini dibawah TSBS Implementation.
  Script ini berjalan otomatis. Jadi tidak ada konfigurasi
  
  Meski namanya multianime, tapi kamu tetap tidak bisa mengaktifasi dua animasi
  berbeda bersamaan. Script ini hanya menghandle agar animasi sebelumnya yang
  belum selesai dieksekusi agar tidak dihapus. Kalo semisal ada jeda setidaknya
  satu frame aja, bisa :D
  
  Contoh :
  [:cast, 123],
  [:wait, 1],   # <-- kasi jeda
  [:cast, 60],
  [:wait, 1],   # <-- kasi jeda
  [:cast, 23],

=end
# =============================================================================
# Tidak ada konfigurasi
# =============================================================================
class Sprite_MultiAnime < Sprite_Base
  
  def initialize(viewport, ref_sprite, anime, flip = false)
    super(viewport)
    @ref_sprite = ref_sprite
    update_reference_sprite
    start_animation(anime, flip)
  end
  
  def update
    update_anim_position
    update_reference_sprite
    super
    dispose if !animation?
  end
  
  def diff_x
    @ref_sprite.x - x
  end
  
  def diff_y
    @ref_sprite.y - y
  end
  
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
  
  def update_anim_position
    return unless @anim_follow
    move_animation(diff_x, diff_y)
  end
  
  def update_reference_sprite
    src_rect.set(@ref_sprite.src_rect)
    self.ox = @ref_sprite.ox
    self.oy = @ref_sprite.oy
    self.x = @ref_sprite.x
    self.y = @ref_sprite.y
    self.z = @ref_sprite.z
  end
  
  def start_animation(anime, flip = false)
    @anim_top = $game_temp.anim_top
    @anim_follow = $game_temp.anim_follow
    $game_temp.anim_follow = $game_temp.anim_top = false
    super(anime, flip)
  end
  
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
  
  def animation_process_timing(timing)
    timing.se.play unless @ani_duplicated
    case timing.flash_scope
    when 1
      @ref_sprite.flash(timing.flash_color, timing.flash_duration * @ani_rate)
    when 2
      if viewport && !@ani_duplicated
        viewport.flash(timing.flash_color, timing.flash_duration * @ani_rate)
      end
    when 3
      @ref_sprite.flash(nil, timing.flash_duration * @ani_rate)
    end
  end
  
end

class Sprite_Battler
  attr_reader :multianimes
  
  alias tsbs_multianim_init initialize
  def initialize(viewport, battler = nil)
    @multianimes = []
    tsbs_multianim_init(viewport, battler)
  end
  
  def start_animation(anime, flip = false)
    spr_anim = Sprite_MultiAnime.new(viewport, self, anime, flip)
    multianimes.push(spr_anim)
  end
  
  alias tsbs_multianim_update update
  def update
    tsbs_multianim_update
    multianimes.delete_if do |anime|
      anime.update
      anime.disposed?
    end
  end
  
  alias tsbs_multianim_dispose dispose
  def dispose
    tsbs_multianim_dispose
    multianimes.each do |anime|
      anime.dispose
    end
  end
  
  def animation?
    !multianimes.empty?
  end
  
  def update_animation
  end  
  
end

class Sprite_AnimGuard
  attr_reader :multianimes
  
  alias tsbs_multianim_init initialize
  def initialize(spr_battler, vport = nil)
    @multianimes = []
    tsbs_multianim_init(spr_battler, vport)
  end
  
  def start_animation(anime, flip = false)
    spr_anim = Sprite_MultiAnime.new(viewport, self, anime, flip)
    multianimes.push(spr_anim)
  end
  
  alias tsbs_multianim_update update
  def update
    tsbs_multianim_update
    multianimes.delete_if do |anime|
      anime.update
      anime.disposed?
    end
  end
  
  alias tsbs_multianim_dispose dispose
  def dispose
    tsbs_multianim_dispose
    multianimes.each do |anime|
      anime.dispose
    end
  end
  
  def animation?
    !multianimes.empty?
  end
  
  def update_animation
  end  
  
end
