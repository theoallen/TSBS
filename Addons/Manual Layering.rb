#===============================================================================
# TSBS Addon - Manual Layering
# Requires : TSBS v1.4 and up
#-------------------------------------------------------------------------------
# This script enable you to set battler layer to always in front or always
# behind.
#-------------------------------------------------------------------------------
# To use this script, put this script below TSBS implementation. You have to 
# understand how to make custom sequence using Theolized Sideview Battle System.
#-------------------------------------------------------------------------------
# Put [:layer, n] where n is a number 0 / 1 / 2
# > 0 = automatic layer (TSBS default feature)
# > 1 = always behind. This makes the attacker always behind all battlers from
#       its Y position
# > 2 = always in front. This makes the attacker always behind all battlers from
#       its Y position
#===============================================================================

class Game_Battler
  attr_reader :layer
  
  alias tsbs_manual_layer_clear clear_tsbs
  def clear_tsbs
    tsbs_manual_layer_clear
    @layer = 0
  end
  
  alias tsbs_manual_layer_handler custom_sequence_handler
  def custom_sequence_handler
    tsbs_manual_layer_handler
    if @acts[0] == :layer
      @layer = @acts[1]
    end
  end
  
  alias tsbs_manual_layer_screen_z screen_z
  def screen_z
    return 4 if layer == 1
    return Graphics.height if @layer == 2
    return tsbs_manual_layer_screen_z
  end
  
end
