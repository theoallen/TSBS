#===============================================================================
# Display grid index
#===============================================================================

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
