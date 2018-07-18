class Game_Enemy
  #----------------------------------------------------------------------------
  # Set all enemy AI here use "case when" (sorry for being tedious)
  #----------------------------------------------------------------------------
  # We will not use built-in action pattern in database. All conditions and 
  # such will be written here
  #
  # To make move, call grid_move(new_position)
  # To make action, call make_grid_action(skill_id, target_grid)
  #
  # To decide target grid you have to make your own if else condition like when 
  # the target is on the same line, within x range, etc. Unfortunatelly, 
  # there is no easy way yet to check these condition. I will try to make it 
  # easier later. just state what kind of conditions that you want. I can't 
  # think one at the moment.
  #
  # P.S: Confusion state action is not supported yet.
  #----------------------------------------------------------------------------
  def prepare_grid_action
    freegrid = Grid.all_area - $game_party.restricted_grid - 
      $game_troop.occupied_grid - [@grid_pos]
    case @enemy_id
    when 1 
      if rand > 0.5
        make_grid_action(1, $game_party.members[0].grid_pos)
      else
        index = (freegrid).shuffle.first
        grid_move(index)
      end
    end
  end
  
  #---------------------------------------------------------------------------
  # Call this method when you want to move enemy to specific grid position
  #---------------------------------------------------------------------------
  def grid_move(new_grid_pos)
    @grid_pos = new_grid_pos
    @ori_x = original_x
    @ori_y = original_y
    self.battle_phase = :move
  end
  
  #---------------------------------------------------------------------------
  # Call this method when you want an enemy to perform a specific action
  # > Skill ID      = carried skill when enemy perform a move.
  # > target_grid   = self explanatory. Basically center target grid
  # > target_type   = basically target opponents or friends
  #---------------------------------------------------------------------------
  def make_grid_action(skill_id, target_grid, target_type = 0)
    current_action.set_skill(skill_id)
    set_target_grid(target_grid, [target_grid], target_type)
  end
  
end

class Scene_Battle
  
  #---------------------------------------------------------------------------
  # Checking AI action might be different when using different turn system.
  # However, I believe this is the most general method to make it compatible
  # with most of turn system
  #---------------------------------------------------------------------------
  def process_action
    return if scene_changing?
    if !@subject || !@subject.current_action
      @subject = BattleManager.next_subject
    end
    return turn_end unless @subject
    
    # This is where AI is checked
    @subject.prepare_grid_action if @subject.enemy?
    
    # If @subject is just moving around, update move
    if @subject.battle_phase == :move
      tsbs_wait_update while @subject.battle_phase == :move
      @subject.remove_current_action
      
    # if @subject make action like attacking or defending
    elsif @subject.current_action
      if @subject.current_action.valid?
        @status_window.open
        execute_action
      end
      @subject.remove_current_action
    end
    
    # Terminate action
    process_action_end unless @subject.current_action
  end
  
end
