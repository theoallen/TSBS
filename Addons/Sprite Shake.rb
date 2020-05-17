# To use
# [:target_shake, <duration>, <power>]
# Example:
# [:target_shake, 30, 10]

class Game_Battler
  attr_accessor :shake_maxdur
  attr_accessor :shake_power
  attr_writer :shake_dur
  def shake_dur
    @shake_dur ||= 0
  end
  
  def shake_x
    @shake_x ||= 0
  end
  
  def shake_y
    @shake_y ||= 0
  end
  
  alias shake_update update
  def update
    shake_update
    if shake_dur > 0
      @shake_dur -= 1
      rate = @shake_dur/@shake_maxdur.to_f
      @shake_x = (rand(@shake_power)*rate*(rand > 0.5 ? 1 : -1)).round
      @shake_y = (rand(@shake_power)*rate*(rand > 0.5 ? 1 : -1)).round
    end
  end
  
  alias aed_vlambeers_on_battler custom_sequence_handler
  def custom_sequence_handler
    if @acts[0] == :target_shake
      target_array.each do |t|
        t.shake_dur = @acts[1]
        t.shake_maxdur = @acts[1]
        t.shake_power = @acts[2]
      end
    else
      aed_vlambeers_on_battler
    end
  end
  
end

class Game_Actor
  
  alias shake_screen_x screen_x
  alias shake_screen_y screen_y
  def screen_x
    shake_screen_x + shake_x
  end
  
  def screen_y
    shake_screen_y + shake_y
  end
  
end

class Game_Enemy
  
  alias shake_screen_x screen_x
  alias shake_screen_y screen_y
  def screen_x
    shake_screen_x + shake_x
  end
  
  def screen_y
    shake_screen_y + shake_y
  end
  
end
