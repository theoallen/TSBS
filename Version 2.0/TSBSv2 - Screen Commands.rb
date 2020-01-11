#==============================================================================
# Theolized Sideview Battle System (TSBS) - Screen Command
  TSBS.versions[:screen] = '2.0.0'
#------------------------------------------------------------------------------
# Contact :
#------------------------------------------------------------------------------
# *> Discord @ Theo#3034
#==============================================================================
# Below here are the TSBS action command you can utilize
#------------------------------------------------------------------------------
# If you do not like the command  name, you can even rename command to whatever
# you like. 
#
# for example, you change SQV1_INVOKE from :invoke_item to :target_damage
#
# Note: renaming the command may make me harder to help you to debug your
# action sequence. If you do rename them, let me know in advance.
#==============================================================================
module TSBS
#==============================================================================
# SCREEN COMMANDS
# > focus, unfocus, change screen tint, screen shake
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# These are the command to modify the entire screen. Including making a focus
# target, shakes, changing tone, or even fading in/out
#==============================================================================
# *> Focus
#------------------------------------------------------------------------------
  SQV1_FOCUS = :focus
  SQV1_UNFOCUS = :unfocus
#------------------------------------------------------------------------------
# Usage:
# 1. [:focus, <duration>],
# 2. [:focus, <duration>, <color>],
# 3. [:unfocus, <duration>],
#
# This command will make sprites other than the target and action subject 
# disappear, essentially make the focus only on the target. The color parameter
# is optional. When the color parameter is omitted, it will use the default
# focus background color. You can change the default background color below 
# with this format = Color.new(red, gree, blue, alpha). Maximum range is 255
#
  Focus_BGColor = Color.new(0,0,0,170)
#
# Example usage:
# 1. [:focus, 30],
# 2. [:focus, 30, Color.new(r,g,b,a)]
# 3. [:unfocus, 30]
#------------------------------------------------------------------------------
# *> Target focus
#------------------------------------------------------------------------------
  SQV1_TARGET_FOCUS = :target_focus
#------------------------------------------------------------------------------
# Usage: [:target_focus, :troop / :party / :all]
# Example: 
# [:target_focus, :troop],
# [:target_focus, :party],
# [:target_focus, :all]
#
# This command specify the target focus. By default, the target focus only 
# focus on the current target and make everything disappear. By specifying 
# either troop / party / all, they will not disappear even though not being
# targetted.
#------------------------------------------------------------------------------
# *> Screen change
#------------------------------------------------------------------------------
  SQV1_SCREEN = :screen
#------------------------------------------------------------------------------
# Usage: [:screen, { options }]
# Template:
# [:screen, {
#   :flash => [Color.new(r,g,b,alpha), <duration>]
#   :tone => [Tone.new(r,g,b,gray), <duration>]
# }]
#
# Example:
# [:screen, {
#   :flash => [Color.new(255,255,255,60), 30]
#   :tone => [Tone.new(-255,255,0,128), 30]
# }]
#
# Screen commands modifies tone screen and flashing effect. Keep in mind that
# when changing the screen tone, it will stay that way forever until you change
# it back
#------------------------------------------------------------------------------
# *> Shake screen
#------------------------------------------------------------------------------
  SQV2_SHAKE = :shake
#------------------------------------------------------------------------------
# Usage: [:shake, <duration>, <power>]
# Example: [:shake, 40, 10]
#
# Shake screen command shakes the screen (well, duh!)
# Duration specify the effect duration, while the power specify the screen 
# displacement. It is advised to keep it low, more or less 10. The power also
# gradually loses it's momentum as the time passes.
#------------------------------------------------------------------------------
# *> Graphics Freeze / Transition
#------------------------------------------------------------------------------
  SQV1_GRAPHICS_FREEZE = :scr_freeze 
  SQV1_GRAPHICS_TRANS = :scr_trans 
#------------------------------------------------------------------------------
# Usage:
# [:scr_freeze]
# <other commands that modifies the entire screen>
# [:scr_trans]
#
# Both commands are used together to create a transition effect. Calling the
# screen freeze make the Game.exe window by not updating the graphics, 
# essentially freeze the screen. However, the background process is still being 
# processed. When you call the [:scr_trans] command, the screen will be 
# unfreeze by doing a transition
#------------------------------------------------------------------------------
# *> Screen Fadein / Fadeout
#------------------------------------------------------------------------------
  SQV1_SCREEN_FADEOUT = :scr_fadeout  
  SQV1_SCREEN_FADEIN = :scr_fadein 
#------------------------------------------------------------------------------
# Usage:
# 1. [:scr_fadeout, <duration>]
# 2. [:scr_fadein, <duration>]
#
# Example:
# [:scr_fadeout, 45],
#
# This command make the screen fading in/out. Specify the duration requires to
# fading in/out completely 
#------------------------------------------------------------------------------
end
