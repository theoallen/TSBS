#===============================================================================
# TSBS Bugfix - Opacity Error
#-------------------------------------------------------------------------------
# This error came up when you set the enemies in appear halfway, and you set an
# event which changes HP/MP for all entire enemies in troop. The enemy appears
# but can not targeted.
#
# This bug present in both version 1.3c and 1.4
# Thanks for mr. anonimous who reported this bug
#===============================================================================
class Sprite_Battler
  
  alias tsbs_opacity_patch update_opacity
  def update_opacity
    tsbs_opacity_patch
    init_visibility
  end
  
end
