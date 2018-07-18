#===============================================================================
# PLACEHOLDER INDEX (for search) -  These need to be finished in final version
# > GRID::001 (possible grid)
# > GRID::002 (avalaible target)
# > GRID::003 (Command)
# > GRID::004 (Enemy positioning)
# > GRID::005 (Actor positioning)
#===============================================================================
# Instructions
#===============================================================================
=begin

  ----------------------------------------------------------------------------
  * Skill Notetags
  ----------------------------------------------------------------------------
  
  <null target>
  Allow player to target an empty grid
  
  <null grid>
  When an item / skill is tagged using this tag, and has area effect damage,
  playing the animation will also play animation on an empty grid. If an item 
  tagged as <null target>, you don't need to put this tag
  
  <grid target: method_name>
  <grid aoe: method_name>
  
  <highlight only>
  
  ----------------------------------------------------------------------------
  * Sequence commands (detailed instruction later)
  ----------------------------------------------------------------------------
  
  1)  :grid_save    >> Save current target grid
  2)  :grid_load    >> Load last saved target grid
  3)  :grid_restore >> Reset back to original target grid   
  4)  :grid_change  >> Change target grid
  5)  :grid_add     >> Add grid, cover more area damage
  6)  :grid_rem     >> Remove grid, cover less area damage
  7)  :grid_move    >> Move @center_grid to other position
  8)  :grid_setup   >> Modify current grid setup
  
  How things works
  
  There's one variable named @center_grid. It's the center of all everything.
  @center_grid set when you select an initial grid during targeting phase
  which later being used to be a relative position for adding, removing, or
  changing target grid for Area damage like splash damage etc.

=end
#===============================================================================
# End of instructions
#-------------------------------------------------------------------------------
# Customization part
#===============================================================================
module Grid
  #=============================================================================
  # ATTENTION! This field requires a bit of Ruby scripting knowledge. But I'll
  # try my best to try to explain
  #----------------------------------------------------------------------------
  # * Some of things to remember :
  #----------------------------------------------------------------------------
  # * Grid direction rules
  #----------------------------------------------------------------------------
  # 2 = DOWN
  # 4 = LEFT
  # 6 = RIGHT
  # 8 = UP
  #
  # 1 = DOWN-LEFT
  # 3 = DOWN-RIGHT
  # 7 = UP-LEFT
  # 9 = UP-RIGHT
  #----------------------------------------------------------------------------
  # * Grid methods (You can expand grid based on these)
  #----------------------------------------------------------------------------
  # Representation of grid index
  #  X -------------------------------> 
  #  | [ 0],[ 1],[ 2],[ 3],[ 4],[ 5],
  #  | [ 6],[ 7],[ 8],[ 9],[10],[11],
  #  | [12],[13],[14],[15],[16],[17],
  #  V
  #----------------------------------------------------------------
  # > Grid.neighbor(index, direction, (times))
  #   Get grid index relatively based on initial index
  #
  #   Ex.
  #   Grid.neighbor(8, 6) -> 9
  #   Grid.neighbor(8, 4) -> 7
  #   Grid.neighbor(8, 6, 2) -> 10 (two times to right)
  #
  #------------------------------------------------------------------
  # > Grid.surrounding(index, direction)
  #   Get all grid index relatively based on initial index
  #   Direction can be ommited
  #
  #   Ex.
  #   Grid.surrounding(8) -> [1,2,3,7,9,13,14,15]
  #   Grid.surrounding(8, [2,4,6,8]) -> [2,7,9,14] (only 4 direction)
  #   Grid.surrounding(0, [2,4,6,8]) -> [6,1] (other 2 dir are empty)
  #=============================================================================
  # Config available grid to target here.
  #
  # By default, all skills targeting area is all area. Means a skill is 
  #-----------------------------------------------------------------------------
  module Targeting
    
    # Target all area (Default target, do not remove!)
    def self.all_area(user)
      return Grid.all_area
    end
    
    # Only target linear
    def self.linear(user)
      return Grid.linear(Grid.neighbor(user.grid_pos, 6), [6], 8)
    end
    
    # Check surrounding
    def self.surrounding(user)
      return Grid.surrounding(user.grid_pos, [1,2,3,4,6,7,8,9], true)
    end
    
  end
  #=============================================================================
  # Config area of effect here
  #
  #-----------------------------------------------------------------------------
  module Area
    # Single Grid target (Default Area Effect, do not remove!
    def self.single(index)
      return [index]
    end
  end
end
#===============================================================================
# End of config
#===============================================================================
module Grid
  module REGEX
    Offgrid     = /<off[\s_]grid>/i
    NullTarget  = /<null[\s_]target>/i
    NullGrid    = /<null[\s_]grid>/i
    HighLight   = /<highlight[\s_]only>/i
    Target      = /<grid[\s_]+target\s*:\s*(.+)>/i
    AoE         = /<grid[\s_]+aoe\s*:\s*(.+)>/i
  end
  
  COMMAND_SAVE      = :grid_save
  COMMAND_LOAD      = :grid_reset
  COMMAND_RESTORE   = :grid_restore
  COMMAND_CHANGE    = :grid_change
  COMMAND_ADD       = :grid_add
  COMMAND_REMOVE    = :grid_rem
  COMMAND_MOVE      = :grid_move
  COMMAND_ANIMATION = :grid_anim
  COMMAND_SETUP     = :grid_setup
  COMMAND_REMSAVED  = :saved_grid
  
end
#===============================================================================
# * DataManager
#===============================================================================
class << DataManager
  
  alias tsbs_grid_create_game_objects create_game_objects
  def create_game_objects
    tsbs_grid_create_game_objects
    $game_all_units = Game_AllUnits.new
  end
  
end
#===============================================================================
# * Item / Skill Database
#===============================================================================

class RPG::UsableItem
  
  alias grid_load_tsbs load_tsbs
  def load_tsbs
    grid_load_tsbs
    @aoe_grid = "single"
    @target_grid = "all_area"
    note.split(/[\r\n]+/).each do |line|
      case line
      when Grid::REGEX::AoE
        @aoe_grid = $1.to_s
      when Grid::REGEX::Target
        @target_grid = $1.to_s
      end
    end
  end
  
  #----------------------------------------------------------------------------
  # * Grid area (For AoE)
  #----------------------------------------------------------------------------
  def grid_area(index)
    return Grid::Area.method(@aoe_grid).call(index)
  end
  
  #----------------------------------------------------------------------------
  # * Possible Grid (for targeting) - Set to all area. Need to be changed later
  # INDEX : GRID::001
  #----------------------------------------------------------------------------
  def possible_grid(user)
    return Grid::Targeting.method(@target_grid).call(user)
  end
  
  #----------------------------------------------------------------------------
  # * Grid area only for highlighting. Actual target only single grid
  #----------------------------------------------------------------------------
  def aoe_highlight_only?
    note[Grid::REGEX::HighLight]
  end
  
  #----------------------------------------------------------------------------
  # * Can target empty grid?
  #----------------------------------------------------------------------------
  def null_target?
    note[Grid::REGEX::NullTarget]
  end
  
  #----------------------------------------------------------------------------
  # * Play animation on empty grid?
  #----------------------------------------------------------------------------
  def null_grid?
    return true if null_target?
    return note[Grid::REGEX::NullGrid]
  end
  
  #----------------------------------------------------------------------------
  # * Off targeting
  #----------------------------------------------------------------------------
  def can_off?
    !note[Grid::REGEX::Offgrid].nil?
  end
  
  #----------------------------------------------------------------------------
  # * Is target avalaible? - Need to be changed later
  # INDEX : GRID::002
  #----------------------------------------------------------------------------
  def target_avalaible?(user)
    return true if null_target? || scope == 11
    grids = possible_grid(user)
    if for_opponent?
      return !user.opponents_unit.members_in_grid(*grids).compact.empty?
    else
      return !user.friends_unit.members_in_grid(*grids).compact.empty?
    end
  end
  
end

#===============================================================================
# * Database module for battler (RPG::Actor / RPG::Enemy).
#===============================================================================

module TSBS_BattlerDB
  attr_accessor :move_key
  #----------------------------------------------------------------------------
  # * Load TSBS
  #----------------------------------------------------------------------------
  
  alias tsbs_grid_load load_tsbs
  def load_tsbs
    tsbs_grid_load
    @move_key = "MOVE"
  end
  
  #----------------------------------------------------------------------------
  # * Read notetag
  #----------------------------------------------------------------------------
  alias tsbs_grid_read read_tsbs
  def read_tsbs(line)
    tsbs_grid_read(line)
  end
  
end

#===============================================================================
# * Game_Battler
#===============================================================================

class Game_BattlerBase
  #----------------------------------------------------------------------------
  # * Item usable? check if item has target
  #----------------------------------------------------------------------------
  alias tsbs_grid_item_usable? usable?
  def usable?(item)
    targ = item && SceneManager.in_battle? ? item.target_avalaible?(self) : true
    tsbs_grid_item_usable?(item) && targ
  end
  
end

#===============================================================================
# * Game_Battler
#===============================================================================

class Game_Battler
  #----------------------------------------------------------------------------
  # * Public Attributes
  #----------------------------------------------------------------------------
  attr_accessor :target_grid
  attr_reader :grid_pos
  
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  alias tsbs_grid_init initialize
  def initialize
    @grid_pos = 0
    tsbs_grid_init
  end
  
  #----------------------------------------------------------------------------
  # * Clear TSBS
  #----------------------------------------------------------------------------
  alias tsbs_grid_clear clear_tsbs
  def clear_tsbs
    tsbs_grid_clear
    @center_grid = -1
    @center_grid_ori = -1
    @target_grid = []
    @target_grid_backup = []
    @target_grid_ori = []
    @grid_setup = default_grid_setup
    @target_type = 0
    @target_type_ori = 0
    @user_grid_ori = 0
    @user_grid = 0
  end
  
  #----------------------------------------------------------------------------
  # * Battler Start
  #----------------------------------------------------------------------------
  alias tsbs_grid_battler_start tsbs_battler_start
  def tsbs_battler_start
    tsbs_grid_battler_start
    @grid_setup = default_grid_setup
  end
  
  #----------------------------------------------------------------------------
  # Grid setting
  # :null => refers to null_target (true = animation at empty grid)
  #
  # :center => true  = move battler to @center_grid during the move to target
  #                    command.
  #            false = move battler to the center of targets
  #
  # :pivot => :target = use @center_grid as pivot for relative post
  #           :user = use user as pivot for relative post
  #           any number = use specific grid index as pivot for relative post
  #----------------------------------------------------------------------------
  def default_grid_setup
    return {
      :center => true, # Not yet implemented
      :null => item_in_use ? item_in_use.null_grid? : false,
      :pivot => :target
    }
  end
  
  #----------------------------------------------------------------------------
  # * Pivot grid
  #----------------------------------------------------------------------------
  def pivot_grid
    pivot = @grid_setup[:pivot]
    if pivot == :target
      return @center_grid
    elsif pivot == :user
      return @user_grid
    elsif pivot.is_a?(Numeric)
      return pivot
    else
      ErrorSound.play
      msgbox "Wrong pivot value!"+
      "Are you trying to break the game!?"
      exit
    end
  end
  
  #----------------------------------------------------------------------------
  # * Set target grid
  #----------------------------------------------------------------------------
  def set_target_grid(center_grid, target_grid, target_type)
    @center_grid_ori = @center_grid = center_grid
    @user_grid_ori = @user_grid = @grid_pos
    @target_grid = target_grid
    @target_grid_backup = target_grid.clone
    @target_grid_ori = target_grid.clone
    @target_type = target_type
    @target_type_ori = target_type
    record_target
  end
  
  #----------------------------------------------------------------------------
  # * Record target
  #----------------------------------------------------------------------------
  def record_target
    unit = target_unit
    $game_temp.battler_targets += unit.members_in_grid(*@target_grid).compact
    $game_temp.battler_targets.uniq!
  end
  
  #----------------------------------------------------------------------------
  # * Target in grid
  #----------------------------------------------------------------------------
  def target
    target_unit.member_in_grid(@target_grid[0]) || target_null
  end
  
  #----------------------------------------------------------------------------
  # * All targets
  #----------------------------------------------------------------------------
  def target_array
    target_unit.include_null = @grid_setup[:null]
    target_unit.members_in_grid(*@target_grid).compact
  end
  
  #----------------------------------------------------------------------------
  # * Get target unit
  #----------------------------------------------------------------------------
  def target_unit
    case @target_type
    when 0
      opponents_unit
    when 1
      friends_unit
    when 2
      $game_all_units
    else
      opponents_unit
    end
  end
  
  #----------------------------------------------------------------------------
  # * Area flag
  #----------------------------------------------------------------------------
  def area_flag
    return @target_grid.size > 1
  end
  
  #----------------------------------------------------------------------------
  # * Get Target null / in empty grid
  #----------------------------------------------------------------------------
  def target_null
    unit = target_unit
    unit.include_null = true
    result = unit.member_in_grid(@target_grid[0])
    unit.include_null = false
    return result
  end
  
  #----------------------------------------------------------------------------
  # * Set grid position
  #----------------------------------------------------------------------------
  def grid_pos=(pos)
    if $TEST && pos > Grid.max_index-1
      ErrorSound.play
      msgbox "Wrong grid Position #{pos} on \n"+
      "#{self.class}, ID #{data_battler.id}"
      exit
    end
    @grid_pos = pos
  end
  
  #----------------------------------------------------------------------------
  # * Grid reference
  #----------------------------------------------------------------------------
  def grid_ref
    Grid::Position
  end
  
  #----------------------------------------------------------------------------
  # * Original X Position
  #----------------------------------------------------------------------------
  def original_x
    grid_ref[@grid_pos][0]
  end
  
  #----------------------------------------------------------------------------
  # * Original Y Position
  #----------------------------------------------------------------------------
  def original_y
    grid_ref[@grid_pos][1]
  end
  
  #----------------------------------------------------------------------------
  # * Phase sequence
  #----------------------------------------------------------------------------
  alias tsbs_grid_phase_sequence phase_sequence
  def phase_sequence
    tsbs_grid_phase_sequence.merge({:move => method(:move_key)})
  end
  
  #----------------------------------------------------------------------------
  # * Move key
  #----------------------------------------------------------------------------
  def move_key
    data_battler.move_key
  end
  
  #----------------------------------------------------------------------------
  # * Custom sequence for grid
  #----------------------------------------------------------------------------
  alias tsbs_grid_custom_sequence_handler custom_sequence_handler
  def custom_sequence_handler
    tsbs_grid_custom_sequence_handler
    case @acts[0]
    when Grid::COMMAND_SAVE;      grid_command_save
    when Grid::COMMAND_LOAD;      grid_command_load
    when Grid::COMMAND_RESTORE;   grid_command_restore
    when Grid::COMMAND_CHANGE;    grid_command_change
    when Grid::COMMAND_ADD;       grid_command_add
    when Grid::COMMAND_REMOVE;    grid_command_remove
    when Grid::COMMAND_MOVE;      grid_command_move
    when Grid::COMMAND_ANIMATION; grid_command_animation
    when Grid::COMMAND_SETUP;     grid_command_setup
    end
  end
  
  #----------------------------------------------------------------------------
  # * Saved last target grid [:grid_save]
  #----------------------------------------------------------------------------
  def grid_command_save
    @target_grid_backup = @target_grid.clone
  end
  
  #----------------------------------------------------------------------------
  # * Load last saved grid [:grid_load]
  #----------------------------------------------------------------------------
  def grid_command_load
    @target_grid = @target_grid_backup.clone
    @center_grid = @center_grid_ori
    record_target
  end
  
  #----------------------------------------------------------------------------
  # * Restore original target [:grid_restore]
  #----------------------------------------------------------------------------
  def grid_command_restore
    set_target_grid(@center_grid_ori, @target_grid_ori, @target_type_ori)
  end
  
  #----------------------------------------------------------------------------
  # * Change target grid [:grid_change]
  #----------------------------------------------------------------------------
  def grid_command_change
    @target_grid = make_grid
    record_target
  end
  
  #----------------------------------------------------------------------------
  # * Add more target grid [:grid_add]
  #----------------------------------------------------------------------------
  def grid_command_add
    @target_grid += make_grid
    @target_grid.uniq!
    record_target
  end
  
  #----------------------------------------------------------------------------
  # * Remove target grid [:grid_rem]
  #----------------------------------------------------------------------------
  def grid_command_remove
    if @acts[1] == :center
      @target_grid -= [@center_grid]
      return
    elsif @acts[1] == Grid::COMMAND_REMSAVED
      @target_grid -= @target_grid_backup
      return
    end
    @target_grid -= make_grid
    record_target
  end
  
  #----------------------------------------------------------------------------
  # * Move center grid [:grid_move]
  #----------------------------------------------------------------------------
  def grid_command_move
    pivot = @grid_setup[:pivot]
    if pivot == :target
      @center_grid = Grid.neighbor(@center_grid, @acts[1])
    elsif pivot == :user
      @user_grid = Grid.neighbor(@user_grid, @acts[1])
    end
    record_target
  end
  
  #----------------------------------------------------------------------------
  # * Play animation at specific grid [:grid_anim]
  #----------------------------------------------------------------------------
  def grid_command_animation
    unit = target_unit
    target_unit.null_targets.each do |null_target|
      next unless @target_grid.include?(null_target.grid_pos)
      null_target.animation_id = @acts[1] || item_in_use.animation_id
      null_target.animation_mirror = @acts[2]
      null_target.sprite.setup_new_animation
    end
  end
  
  #----------------------------------------------------------------------------
  # * Change grid setup [:grid_setup]
  #----------------------------------------------------------------------------
  def grid_command_setup
    @grid_setup = default_grid_setup.merge(@acts[1])
  end
  
  #-----------------------------------------------
  # 1 = method
  # 2 = args
  # 3 = limit
  #-----------------------------------------------
  def make_grid
    method = Grid.method(@acts[1])
    args = [pivot_grid, @acts[2], @acts[3]].compact
    return method.call(*args)
  end
  
end

#===============================================================================
# * Game_Actor
#===============================================================================

class Game_Actor
  #----------------------------------------------------------------------------
  # * Original X Position
  #----------------------------------------------------------------------------
  def original_x
    super
  end
  #----------------------------------------------------------------------------
  # * Original Y Position
  #----------------------------------------------------------------------------
  def original_y
    super
  end
  
  #----------------------------------------------------------------------------
  # * Determine if attac usable (overwrite)
  #----------------------------------------------------------------------------
  def attack_usable?
    usable?($data_skills[attack_skill_id]) && has_attack_target?
  end
  
  #----------------------------------------------------------------------------
  # * Exclusively written for Halal
  #----------------------------------------------------------------------------
  def has_attack_target?
    $data_skills[attack_skill_id].target_avalaible?(self)
  end
  
end

#===============================================================================
# * Game_Enemy
#===============================================================================

class Game_Enemy
  #----------------------------------------------------------------------------
  # * Init grid position
  #----------------------------------------------------------------------------
  def init_grid_position
    self.x = @ori_x = original_x
    self.y = @ori_y = original_y
  end
end

#===============================================================================
# ** Game_GridBattler
#  Used as placeholder battler for null target
#===============================================================================

class Game_GridBattler < Game_Battler
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  def initialize(index)
    super()
    @grid_pos = index
  end
  
  #----------------------------------------------------------------------------
  # * Remove fiber
  #----------------------------------------------------------------------------
  def insert_fiber(fiber)
  end
  
  #----------------------------------------------------------------------------
  # * Remove goto
  #----------------------------------------------------------------------------
  def goto(*args)
  end
  
  #----------------------------------------------------------------------------
  # * Remove smooth
  #----------------------------------------------------------------------------
  def smooth_move(*args)
  end
  
  #----------------------------------------------------------------------------
  # * Remove effect
  #----------------------------------------------------------------------------
  def item_user_effect(user, item)
  end
  
  #----------------------------------------------------------------------------
  # * Fixed reference
  #----------------------------------------------------------------------------
  def x; Grid::Position[@grid_pos][0];end
  def y; Grid::Position[@grid_pos][1];end
  def x=(x);end;
  def y=(y);end;
    
  #----------------------------------------------------------------------------
  # * Aliased x y
  #----------------------------------------------------------------------------
  alias screen_y y
  alias screen_x x
  
  #----------------------------------------------------------------------------
  # * Fixed Z
  #----------------------------------------------------------------------------
  def screen_z
    return y
  end
  
  #----------------------------------------------------------------------------
  # * Get sprite
  #----------------------------------------------------------------------------
  def sprite
    spr = get_spriteset.null_grid[@grid_pos]
    spr.battler = self
    spr.update_position
    return spr
  end
  
  #----------------------------------------------------------------------------
  # * Remove change battle phase
  #----------------------------------------------------------------------------
  def force_change_battle_phase(phase)
  end
  
  #----------------------------------------------------------------------------
  # * Remove use sprite
  #----------------------------------------------------------------------------
  def use_sprite?
    return false
  end
  
  #----------------------------------------------------------------------------
  # * Data battler
  #----------------------------------------------------------------------------
  def data_battler
    return $data_actors[1]
  end
  
#~   #----------------------------------------------------------------------------
#~   # * Remove result
#~   #----------------------------------------------------------------------------
#~   def result
#~     r = super
#~     r.clear
#~     r
#~   end
  
  #----------------------------------------------------------------------------
  # * Remove execute damage
  #----------------------------------------------------------------------------
  def execute_damage(user)
  end
  
end

#===============================================================================
# * Game_Unit
#===============================================================================

class Game_Unit
  attr_accessor :include_null
  #----------------------------------------------------------------------------
  # * Members in grid
  #----------------------------------------------------------------------------
  def members_in_grid(*indexes)
    result = indexes.collect {|i| member_in_grid(i)}
    return result
  end
  
  #----------------------------------------------------------------------------
  # * Member in grid
  #----------------------------------------------------------------------------
  def member_in_grid(index, alive_only = false)
    return nil unless index
    mem = alive_only ? alive_members : members
    result = mem.find {|m| m.grid_pos == index }
    return result if result 
    return null_targets[index] if include_null
    return nil
  end
  
  #----------------------------------------------------------------------------
  # * Occupied grid
  #----------------------------------------------------------------------------
  def occupied_grid
    alive_members.collect {|m| m.grid_pos }
  end
  
  #----------------------------------------------------------------------------
  # * Grid reference
  #----------------------------------------------------------------------------
  def grid_ref
    return Grid::Position
  end
  
  #----------------------------------------------------------------------------
  # * Get null targets
  #----------------------------------------------------------------------------
  def null_targets
    $game_all_units.null_targets
  end
  
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def restricted_grid
    return []
  end
  
end

#===============================================================================
# * Game_Party
#===============================================================================

class Game_Party
  attr_reader :member_pos
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  alias tsbs_grid_init initialize
  def initialize
    tsbs_grid_init
    @member_pos = [13] # Will be used for initial position
  end
  
  #----------------------------------------------------------------------------
  # * Setup grid position
  #----------------------------------------------------------------------------
  def setup_grid_position
    members.each_with_index do |m,i| 
      m.grid_pos = @member_pos[i]
      m.init_oripost
    end
  end
  
  #----------------------------------------------------------------------------
  # * Get grid sprites
  #----------------------------------------------------------------------------
  def grid_sprites
    return get_spriteset.party_grid
  end
  
  #----------------------------------------------------------------------------
  # * To restrict movement for party
  #----------------------------------------------------------------------------
  def restricted_grid
    return Grid::EnemySpaces
  end
end

#===============================================================================
# * Game_Troop
#===============================================================================

class Game_Troop
  #----------------------------------------------------------------------------
  # * Setup (overwrite)
  # THIS MIGHT NEED TO BE CHANGED LATER
  # INDEX : GRID::004
  #----------------------------------------------------------------------------
  def setup(troop_id)
    clear
    @troop_id = troop_id
    @enemies = []
    # Reserve
    available_grid = Grid::EnemySpaces
    troop.members.each do |member|
      next unless $data_enemies[member.enemy_id]
      enemy = Game_Enemy.new(@enemies.size, member.enemy_id)
      enemy.hide if member.hidden
      # Random position
      enemy.grid_pos = available_grid[rand(available_grid.size - 1)]
      available_grid.delete(enemy.grid_pos)
      enemy.init_grid_position
      @enemies.push(enemy)
    end
    init_screen_tone
    make_unique_names
  end

  #----------------------------------------------------------------------------
  # * Get grid sprites
  #----------------------------------------------------------------------------
  def grid_sprites
    return get_spriteset.troop_grid
  end
  
  #----------------------------------------------------------------------------
  # * To restrict movement for troop
  #----------------------------------------------------------------------------
  def restricted_grid
    return Grid::ActorSpaces
  end
  
end

#===============================================================================
# * Game_AllUnits
#===============================================================================

class Game_AllUnits < Game_Unit
  #----------------------------------------------------------------------------
  # * Members
  #----------------------------------------------------------------------------
  def members
    $game_party.members + $game_troop.members
  end
  
  #----------------------------------------------------------------------------
  # * Member in grid
  #----------------------------------------------------------------------------
  def member_in_grid(index)
    return nil unless index
    result = members.find {|m| m.grid_pos }
    return result if result 
    return null_targets[index] if include_null
    return nil
  end
  
  #----------------------------------------------------------------------------
  # * Occupied grid
  #----------------------------------------------------------------------------
  def occupied_grid
    members.collect {|m| m.grid_pos }
  end
  
  #----------------------------------------------------------------------------
  # * Occupied grid
  #----------------------------------------------------------------------------
  def null_targets
    return @null_targets if @null_targets
    @null_targets = []
      Grid.max_index.times do |i|
        @null_targets << Game_GridBattler.new(i)
      end
    return @null_targets
  end
end

#===============================================================================
# * Sprite_Grid (to play animation)
#===============================================================================

class Sprite_Grid < Sprite_Battler
  attr_accessor :battler
  attr_reader :index
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  def initialize(viewport, array, index)
    super(viewport)
    @index = index
    self.x = array[index][0]
    self.y = array[index][1]
    self.z = 4
  end
  #----------------------------------------------------------------------------
  # * Remove update bitmap
  #----------------------------------------------------------------------------
  def update_bitmap
  end
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def update
    return if disposed?
    super
    dispose unless animation?
  end
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def setup_new_animation
    anim_id = battler.animation_id 
    mirror = battler.animation_mirror
    start_animation($data_animations[anim_id], mirror)
    @battler.animation_id = 0
    @battler.animation_mirror = false
  end
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def update_position
    self.x = @battler.screen_x
    self.y = @battler.screen_y - (oy * zoom_y)
    self.z = @battler.screen_z
  end
  
end

#===============================================================================
# * Grid_DummyBattlers
#===============================================================================

class Grid_DummyBattlers
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def initialize(vport, reference)
    @vport = vport
    @reference = reference
    @sprites = {}
  end
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def [](index)
    @sprites[index] ||= Sprite_Grid.new(@vport, @reference, index)
  end
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def update
    @sprites.each_value do |spr|
      spr.update
      @sprites.delete(spr.index) if spr.disposed?
    end
  end
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def dispose
    @sprites.each_value {|spr| spr.dispose}
  end
  
end

#===============================================================================
# * Spriteset_Battle
#===============================================================================

class Spriteset_Battle
  attr_reader :null_grid
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  alias tsbs_grid_init initialize
  def initialize
    tsbs_grid_init
    @null_grid = Grid_DummyBattlers.new(@viewport1, Grid::Position)
  end
  #----------------------------------------------------------------------------
  # * Update
  #----------------------------------------------------------------------------
  alias tsbs_grid_update update
  def update
    tsbs_grid_update
    @null_grid.update if @null_grid
  end
  #----------------------------------------------------------------------------
  # * Dispose
  #----------------------------------------------------------------------------
  alias tsbs_grid_dispose dispose
  def dispose
    tsbs_grid_dispose
    @null_grid.dispose
  end
  
end

#===============================================================================
# * Sprite_GridPointer
#===============================================================================

class Sprite_GridPointer < Sprite
  #----------------------------------------------------------------------------
  # * Public Accessor
  #----------------------------------------------------------------------------
  attr_accessor :possible_grid
  attr_accessor :grid_ref
  attr_accessor :on_ok
  attr_accessor :on_cancel
  attr_reader :grid_pos
  
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  def initialize
    super(nil)
    init_members
    init_bitmap
    update_flip
  end
  
  #----------------------------------------------------------------------------
  # * Init members
  #----------------------------------------------------------------------------
  def init_members
    @active = false
    @grid_ref = nil
    @possible_grid = []
    @grid_pos = 0
    @ignore_off = false
    @input = :default
  end
  
  #----------------------------------------------------------------------------
  # * Init bitmap
  #----------------------------------------------------------------------------
  def init_bitmap
    icon_bitmap = Cache.system("Iconset")
    index = 211
    rect = Rect.new(index % 16 * 24, index / 16 * 24, 24, 24)
    bmp = Bitmap.new(24,24)
    bmp.blt(0, 0, icon_bitmap, rect, 255)
    self.bitmap = bmp
    self.oy = height
  end
  
  #----------------------------------------------------------------------------
  # * Inverted?
  #----------------------------------------------------------------------------
  def inverted?
    return false
    #@grid_ref == Grid::Troop
  end
  
  #----------------------------------------------------------------------------
  # * Per frame update
  #----------------------------------------------------------------------------
  def update
    super
    if @grid_ref
      self.x = @grid_ref[@grid_pos][0]
      self.y = @grid_ref[@grid_pos][1]
    end
    update_flip
    self.visible = @active
    return unless @active
    update_input
  end
  
  #----------------------------------------------------------------------------
  # * Update Flip
  #----------------------------------------------------------------------------
  def update_flip
    if !inverted?
      self.mirror = true
      self.ox = width
    else
      self.mirror = false
      self.ox = 0
    end
  end
  
  #----------------------------------------------------------------------------
  # * Update Input
  #----------------------------------------------------------------------------
  def update_input
    if Input.trigger?(:C)
      @on_ok.call 
      return
    elsif Input.trigger?(:B)
      @on_cancel.call
      return
    end
    default_input_mode
  end
  
  #----------------------------------------------------------------------------
  # * Default input
  #----------------------------------------------------------------------------
  def default_input_mode
    dir = nil
    dir = 2 if Input.repeat?(:DOWN)
    dir = 4 if Input.repeat?(:LEFT)
    dir = 6 if Input.repeat?(:RIGHT)
    dir = 8 if Input.repeat?(:UP)
    return unless dir
    next_grid = Grid.neighbor(@grid_pos, dir)
    if next_grid && selection_possible?(next_grid)
      @grid_pos = next_grid
      Sound.play_cursor
    else
      Sound.play_buzzer
    end
  end
  
  #----------------------------------------------------------------------------
  # * Is selection possible?
  #----------------------------------------------------------------------------
  def selection_possible?(next_grid)
    return @possible_grid.include?(next_grid) unless @ignore_off && @area
    return !(@area.call(next_grid) & @possible_grid).empty?
  end
  
  #----------------------------------------------------------------------------
  # * Start Selection
  #----------------------------------------------------------------------------
  def start_selection(grid_ref, grid_pos, setup = {})
    setup = default_selection.merge(setup)
    @active = true
    @grid_ref = grid_ref
    @grid_pos = grid_pos
    @ignore_off = setup[:off]
    @area = setup[:area]
    @possible_grid = setup[:pos_grid]
    @input = setup[:input]
    @grid_pos = @possible_grid[rand(@possible_grid.size)] unless @grid_pos
    sprset = get_spriteset
  end
  
  #----------------------------------------------------------------------------
  # * Default selection setup
  #----------------------------------------------------------------------------
  def default_selection
    hash = {
      :off => false, 
      :pos_grid => Grid.all_area,
      :area => nil,
      :input => :default
    }
    return hash
  end
  
  #----------------------------------------------------------------------------
  # * Deactivate
  #----------------------------------------------------------------------------
  def deactivate
    @active = false
  end
  
end

#===============================================================================
# * Window_ActorCommand
#===============================================================================

class Window_ActorCommand
  #----------------------------------------------------------------------------
  # * THIS NEED TO BE ALIASED LATER!
  # INDEX : GRID::003
  #----------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    add_attack_command
    add_skill_commands
    add_move_command
    add_guard_command
    add_item_command
  end
  #----------------------------------------------------------------------------
  # * Add command move
  #----------------------------------------------------------------------------
  def add_move_command
    add_command("Move", :move, true)
  end
  
end

#===============================================================================
# * Scene_Battle
#===============================================================================

class Scene_Battle
  #----------------------------------------------------------------------------
  # * Start
  #----------------------------------------------------------------------------
  alias tsbs_grid_start start
  def start
    tsbs_grid_start
    @grid_pointer = Sprite_GridPointer.new
    @actor_command_window.set_handler(:move, method(:command_move))
  end
  
  #----------------------------------------------------------------------------
  # * Post start
  #----------------------------------------------------------------------------
  alias tsbs_grid_post_start post_start
  def post_start
    $game_party.setup_grid_position
    tsbs_grid_post_start
  end
  
  #----------------------------------------------------------------------------
  # * Command move
  #----------------------------------------------------------------------------
  def command_move
    poss_grid = Grid.all_area - $game_troop.restricted_grid
    poss_grid = Grid.surrounding(BattleManager.actor.grid_pos) - poss_grid
    @grid_pointer.start_selection(Grid::Position, BattleManager.actor.grid_pos,
    {:pos_grid => poss_grid})
    @grid_pointer.on_ok = method(:on_grid_move)
    @grid_pointer.on_cancel = method(:on_move_cancel)
  end
  #----------------------------------------------------------------------------
  # * Update Basic
  #----------------------------------------------------------------------------
  alias tsbs_grid_update_basic update_basic
  def update_basic
    tsbs_grid_update_basic
    @grid_pointer.update
  end
  
  #----------------------------------------------------------------------------
  # * On move ok
  #----------------------------------------------------------------------------
  def on_grid_move
    Sound.play_ok
    @grid_pointer.deactivate
    actor = BattleManager.actor
    actor.grid_pos = @grid_pointer.grid_pos
    actor.init_oripost
    actor.battle_phase = :move
    tsbs_wait_update while actor.battle_phase == :move
    @actor_command_window.activate
    @actor_command_window.refresh
  end
  
  #----------------------------------------------------------------------------
  # * On move cancel
  #----------------------------------------------------------------------------
  def on_move_cancel
    Sound.play_cancel
    @actor_command_window.activate
    @grid_pointer.deactivate
  end
  
  #----------------------------------------------------------------------------
  # * Select enemy selection (Overwrite)
  #----------------------------------------------------------------------------
  def select_enemy_selection(pos = nil, setup = {})
    actor = BattleManager.actor
    item = item_in_use
    default_setup = {
      :off => item.can_off?,
      :pos_grid => item.possible_grid(actor),
      :area => item.method(:grid_area),
    }
    default_setup.merge!(setup)
    @grid_pointer.start_selection(Grid::Position, pos, default_setup)
    @grid_pointer.on_ok = method(:on_grid_enemy_ok)
    @grid_pointer.on_cancel = method(:on_grid_enemy_cancel)
  end
  
  #----------------------------------------------------------------------------
  # * Select actor selection (Overwrite)
  #----------------------------------------------------------------------------
  def select_actor_selection(pos = $game_party.alive_members[0].grid_pos)
    @grid_pointer.start_selection(Grid::Position, pos)
    @grid_pointer.on_ok = method(:on_grid_actor_ok)
    @grid_pointer.on_cancel = method(:on_grid_actor_cancel)
  end
  
  #----------------------------------------------------------------------------
  # * Get currently item in use
  #----------------------------------------------------------------------------
  def item_in_use
    @skill || @item
  end
  
  #----------------------------------------------------------------------------
  # * On Grid Enemy OK
  #----------------------------------------------------------------------------
  def on_grid_enemy_ok
    $game_temp.battle_aid = nil if $imported['YEA-BattleEngine']
    enemy = $game_troop.member_in_grid(@grid_pointer.grid_pos)
    unless enemy || item_in_use.null_target?
      Sound.play_buzzer
      select_enemy_selection(@grid_pointer.grid_pos)
      return
    end
    center_grid = @grid_pointer.grid_pos
    target_grid = item_in_use.grid_area(center_grid)
    BattleManager.actor.set_target_grid(center_grid, target_grid, 0)
    @skill_window.hide
    @item_window.hide
    @grid_pointer.deactivate
    next_command
  end
  
  #----------------------------------------------------------------------------
  # * On Grid Actor OK
  #----------------------------------------------------------------------------
  def on_grid_actor_ok
    $game_temp.battle_aid = nil
    actor = $game_party.member_in_grid(@grid_pointer.grid_pos)
    unless actor
      Sound.play_buzzer
      select_actor_selection
      return
    end
    center_grid = @grid_pointer.grid_pos
    target_grid = item_in_use.grid_area(center_grid)
    BattleManager.actor.set_target_grid(center_grid, target_grid, 1)
    @actor_window.hide
    @skill_window.hide
    @item_window.hide
    @grid_pointer.deactivate
    next_command
    @status_window.show
    if $imported["YEA-BattleCommandList"] && !@confirm_command_window.nil?
      @actor_command_window.visible = !@confirm_command_window.visible
    else
      @actor_command_window.show
    end
    @status_aid_window.hide
  end
  
  #----------------------------------------------------------------------------
  # * On Grid enemy cancel
  #----------------------------------------------------------------------------
  def on_grid_enemy_cancel
    Sound.play_cancel
    on_enemy_cancel
    @grid_pointer.deactivate
  end
  
  #----------------------------------------------------------------------------
  # * On Grid enemy cancel
  #----------------------------------------------------------------------------
  def on_grid_actor_cancel
    Sound.play_cancel
    on_actor_cancel
    @grid_pointer.deactivate
  end
  
  #----------------------------------------------------------------------------
  # * Command attack
  #----------------------------------------------------------------------------
  alias tsbs_grid_command_attack command_attack
  def command_attack
    @skill = $data_skills[BattleManager.actor.attack_skill_id]
    tsbs_grid_command_attack
  end
  
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  alias tsbs_grid_command_guard command_guard
  def command_guard
    actor = BattleManager.actor
    actor.set_target_grid(actor.grid_pos, [actor.grid_pos], 1)
    tsbs_grid_command_guard
  end
  
end
