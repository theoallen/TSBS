#===============================================================================
# TSBS Addon - Grid Battle System (Alpha)
#-------------------------------------------------------------------------------
# DEPENDENCIES (no plan to remove the dependencies at the moment) :
# - YEA Battle Engine
# - YEA Free Turn Battle
# - Theolized SBS
#-------------------------------------------------------------------------------
# * Configuration part
#===============================================================================

module Grid
  #============================================================================
    MaxRow = 3
    MaxCol = 8
  #----------------------------------------------------------------------------
  # Set the maximum rows (Up/Down) and Column (Left/Right) here.
  #============================================================================
  
  #============================================================================
    Position =  [ # <-- Don't touch this
  #----------------------------------------------------------------------------
  # Set position here. If you are using 3x6 grid, then you need to format it
  # this way
  #  X ------------------------------------> 6 Columns
  #  | [x,y],[x,y],[x,y],[x,y],[x,y],[x,y],
  #  | [x,y],[x,y],[x,y],[x,y],[x,y],[x,y],
  #  | [x,y],[x,y],[x,y],[x,y],[x,y],[x,y],
  #  V
  # 3 Rows
  #----------------------------------------------------------------------------
[88,170],[140,170],[192,170],[246,170],[300,170],[352,170],[406,170],[460,170],
[77,206],[132,206],[188,206],[244,206],[302,206],[356,206],[414,206],[471,206],
[55,236],[114,236],[180,236],[240,236],[306,236],[364,236],[430,236],[493,236],
]
  #============================================================================
    EnemySpaces = [0,1,2,3,8,9,10,11,16,17,18,19]
    ActorSpaces = [4,5,6,7,12,13,14,15,19,20,21,22,23]
  #----------------------------------------------------------------------------
  # Each grid has index. Started from top left being index 0
  # If you're using 3x6, the grid index is going to be like this
  #
  #  X -------------------------------> 6 Columns
  #  | [ 0],[ 1],[ 2],[ 3],[ 4],[ 5],
  #  | [ 6],[ 7],[ 8],[ 9],[10],[11],
  #  | [12],[13],[14],[15],[16],[17],
  #  V
  # 3 Rows
  #
  # Means if you set EnemySpaces to = [0,1,2,6,7,8,12,13,14]
  # They will only move on that area
  #
  # Or you can try to show the index by setting ShowIndex below to true.
  # Remember that it needs to set to false in final game deployment.
  #----------------------------------------------------------------------------
    ShowIndex = true
  #============================================================================
  # DON'T TOUCH THIS
  #----------------------------------------------------------------------------
    Movement = [1,2,3,4,6,7,8,9]
  #============================================================================
end

#===============================================================================
# * Move animation sequence when move to another grid
#===============================================================================

TSBS::Temporary_Phase.push(:move) # <-- don't remove this
TSBS::AnimLoop.merge!(
  {
    "MOVE" => [
    [],
    [:goto_oripost, 15, 10],
    [:wait, 20],
    ],
  }
)
#===============================================================================
# End of basic module editable area
#===============================================================================
# * Grid Module
#===============================================================================

class << Grid
  #----------------------------------------------------------------------------
  # * Grid direction rules
  #----------------------------------------------------------------------------
  # 2 = DOWN
  # 4 = LEFT
  # 6 = RIGHT
  # 8 = UP
  
  # 1 = DOWN-LEFT
  # 3 = DOWN-RIGHT
  # 7 = UP-LEFT
  # 9 = UP-RIGHT
  #----------------------------------------------------------------------------
  # * Get neighbor grid
  #----------------------------------------------------------------------------
  def neighbor(index, dir, times = 1)
    if times > 1
      index = neighbor(index, dir, times - 1)
    end
    return nil unless index
    coordinate = index
    coordinate = point(index) unless index.is_a?(Array)
    case dir
    when 2; coordinate[1] += 1  # DOWN
    when 4; coordinate[0] -= 1  # FORWARD
    when 6; coordinate[0] += 1  # BACKWARD
    when 8; coordinate[1] -= 1  # UP
      
    # Diagonal direction
    when 1
      coordinate[0] -= 1
      coordinate[1] += 1
    when 3
      coordinate[0] += 1
      coordinate[1] += 1
    when 7
      coordinate[0] -= 1
      coordinate[1] -= 1
    when 9
      coordinate[0] += 1
      coordinate[1] -= 1
    end
    return cell(*coordinate)
  end
  
  #-----------------------------------------------------------------------------
  # Translate point coordinate [x,y] into Cell Index
  # > Column equal as X axis
  # > Row equal as Y axis
  #-----------------------------------------------------------------------------
  def cell(col, row)
    return nil if out_of_bound?(row, 0, Grid::MaxRow - 1)
    return nil if out_of_bound?(col, 0, Grid::MaxCol - 1)
    return (Grid::MaxCol * row) + col
  end
  
  #-----------------------------------------------------------------------------
  # * Translate cell index into point [x,y]
  #-----------------------------------------------------------------------------
  def point(index)
    return [index % Grid::MaxCol, index / Grid::MaxCol]
  end
  
  #-----------------------------------------------------------------------------
  # * Simply check if the value is out of bound
  #-----------------------------------------------------------------------------
  def out_of_bound?(value, min, max)
    return value > max || value < min
  end
  
  #-----------------------------------------------------------------------------
  # * Max Index
  #-----------------------------------------------------------------------------
  def max_index
    Grid::MaxRow * Grid::MaxCol
  end
  
  #-----------------------------------------------------------------------------
  #                           TARGETING PART!
  #-----------------------------------------------------------------------------
  # * Surrounding grid
  #-----------------------------------------------------------------------------
  def surrounding(index, directions = Grid::Movement, compact = true)
    result = directions.collect {|dir| neighbor(index, dir)} + [index]
    return result.compact.uniq if compact
    return result.uniq
  end
  
  #-----------------------------------------------------------------------------
  # * Spread search. Expand node using BFS iteration
  #-----------------------------------------------------------------------------
  def spread(index, directions = Grid::Movement,limit = 1,compact = true)
    return [] unless index
    return [] if limit < 0
    i = 0
    result = [index]
    iteration = [index]
    until i == limit
      temp_res = []
      iteration.each do |it| 
        cells = surrounding(it, directions, compact)
        cells.delete_if {|c| result.include?(c)}
        temp_res += cells
      end
      temp_res.uniq!
      iteration = temp_res
      result += temp_res
      i += 1
    end
    return result.compact.uniq if compact
    return result.uniq
  end
  
  #-----------------------------------------------------------------------------
  # * Linear repeated search
  #-----------------------------------------------------------------------------
  def linear(index, directions = Grid::Movement,limit = 1,compact = true)
    result = []
    directions.each do |dir|
      result += spread(index, [dir], limit, compact)
    end
    return result.uniq
  end
  
  #-----------------------------------------------------------------------------
  # * Random grid drop
  #-----------------------------------------------------------------------------
  def random_grid(index = nil)
    return rand(max_index) unless index
    result = nil
    result = rand(max_index) until result != index
    return result
  end
  
  #-----------------------------------------------------------------------------
  # * Horizontal line
  #-----------------------------------------------------------------------------
  def horizontal(index, limit = Grid::MaxCol)
    linear(index, [4,6], limit)
  end
  
  #-----------------------------------------------------------------------------
  # * Vertical line
  #-----------------------------------------------------------------------------
  def vertical(index, limit = Grid::MaxRow)
    linear(index, [2,8], limit)
  end
  #-----------------------------------------------------------------------------
  # * Eight direction spread
  #-----------------------------------------------------------------------------
  def dir8(index, limit = 1)
    spread(index, [1,2,3,4,6,7,8,9], limit)
  end
  
  #-----------------------------------------------------------------------------
  # * Four direction spread
  #-----------------------------------------------------------------------------
  def dir4(index, limit = 1)
    spread(index, [2,4,6,8], limit)
  end
  
  #-----------------------------------------------------------------------------
  # * Cross shaped area
  #-----------------------------------------------------------------------------
  def cross_shape(index, limit = 1)
    linear(index, [1,3,7,9], limit)
  end
  
  #-----------------------------------------------------------------------------
  # * Plus shaped area
  #-----------------------------------------------------------------------------
  def plus_shape(index, limit = 1)
    linear(index, [2,4,6,8], limit)
  end
  
  #-----------------------------------------------------------------------------
  # * All area
  #-----------------------------------------------------------------------------
  def all_area
    Array.new(Grid::MaxRow * Grid::MaxCol) {|i| i }
  end
  
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def start_row(index)
    linear(index, [4], Grid::MaxRow).min
  end
  
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def start_col(index)
    linear(index, [8], Grid::MaxCol).min
  end
  
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def distance_to_start_row(index)
    linear(index, [4], Grid::MaxRow).size - 1
  end
  
  #----------------------------------------------------------------------------
  # * 
  #----------------------------------------------------------------------------
  def range(a,b,opposite = true)
    a = a.grid_pos if a.is_a?(Game_Battler)
    b = b.grid_pos if b.is_a?(Game_Battler)
    if opposite
      row_distance = distance_to_start_row(a) + distance_to_start_row(b) + 1
      col_distance = (point(a)[1] - point(b)[1]).abs
      return row_distance + col_distance
    else
      point_a = point(a)
      point_b = point(b)
      return (point_b[0] - point_a[0]).abs + (point_b[1] - point_a[1]).abs
    end
  end
  
end
#-------------------------------------------------------------------------------
# Validity check
#-------------------------------------------------------------------------------
max_index = Grid::MaxRow * Grid::MaxCol
if max_index > Grid::Position.size
  msgbox "You need to define more grid position"
  exit
end

if Grid::Position.any? {|arr| !arr.is_a?(Array)}
  msgbox "Invalid position data type"
  exit
elsif Grid::Position.any? {|arr| arr.size < 2}
  msgbox "Invalid position data type"
  exit
end
#-------------------------------------------------------------------------------
#===============================================================================
# Display grid index
#===============================================================================
if Grid::ShowIndex

class Grid_Debug < Sprite
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  def initialize(viewport, index)
    super(viewport)
    @index = index
    self.bitmap = Bitmap.new(32,32)
    self.bitmap.entire_fill(Color.new(255,255,255,32))
    self.bitmap.border_fill(Color.new(255,255,255,255))
    self.bitmap.draw_text(bitmap.rect, index, 1)
    self.x = Grid::Position[index][0]
    self.y = Grid::Position[index][1]
    self.z = 4
    self.ox = self.oy = 16
  end
  
end

class Spriteset_Grid_Debug
  
  def initialize(vport)
    @grids = []
    Grid.max_index.times do |i|
      @grids << Grid_Debug.new(vport, i)
    end
  end
  
  def update
    @grids.each {|g| g.update }
  end
  
  def dispose
    @grids.each {|g| g.dispose }
  end
  
end
  
class Spriteset_Battle

  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  alias tsbs_grid_debug_init initialize
  def initialize
    tsbs_grid_debug_init
    @debug_grid = Spriteset_Grid_Debug.new(@viewport1)
  end
  #----------------------------------------------------------------------------
  # * Update
  #----------------------------------------------------------------------------
  alias tsbs_grid_debug_update update
  def update
    tsbs_grid_debug_update
    @debug_grid.update if @debug_grid
  end
  #----------------------------------------------------------------------------
  # * Dispose
  #----------------------------------------------------------------------------
  alias tsbs_grid_debug_dispose dispose
  def dispose
    tsbs_grid_debug_dispose
    @debug_grid.dispose
  end
  
end

end
