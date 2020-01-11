#==============================================================================
# Theolized Sideview Battle System (TSBS) - Sprite Commands
  TSBS.versions[:sprite] = '2.0.0'
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
# SPRITE COMMANDS
# > blend, visibility, shadow, flip, opacity
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# These are sprite control command to control various sprite properties. Such 
# as changing the visibility, sprite effect, and many things.
#==============================================================================
# *> Toggles
#------------------------------------------------------------------------------
  SQV1_VISIBLE = :visible       # Toggle visibility
  SQV1_FLIP = :flip             # Toggle flip
  SQV1_LOCK_Z = :lock_shadow    # Toggle lock shadow Y position
  SQV1_SHADOW = :shadow         # Toggle shadow visibility
#------------------------------------------------------------------------------
# Usage: [<select command above>, true/false/:toggle]
# Example: [:flip, true]
#
# Note:
# When shadow is locked, it will only move horizontally, not vertically. You
# can simulate flying by using this
#------------------------------------------------------------------------------
# *> Afterimage effect
#------------------------------------------------------------------------------
  SQV1_AFTERIMAGE = :afterimage  
#------------------------------------------------------------------------------
# Usage: [:afterimage, { options }]
# Example:
# [:afterimage, {
#   :on => true,
#   :ease => 20,
#   :rate => 1,
# }]
#
# Explanation:
# This command is to enable the afterimage effect. There're three options you
# can put. None of them are mandatory, however, if you want to enable the
# effect, you have to put {:on => true}
#
# All others options are
# :ease => How fast it's fading. Putting 20 means, per frame, the opacity is
#          reduced by 20
# :rate => How often the after image is being shown. Putting 2 means it will
#          create clone image for every 2 frames
#
# You can set the default afterimage configuration here if you want when the
# option is ommited
#------------------------------------------------------------------------------
  AFTIMG_OPACITY_EASE = 20  # opacity easing
  AFTIMG_IMAGE_RATE   = 1   # image cloning rate
#------------------------------------------------------------------------------
# *> Blend effect
#------------------------------------------------------------------------------  
  SQV1_BLEND = :blend 
#------------------------------------------------------------------------------
# Usage: [:blend, 0/1/2]
# Example: [:blend, 0],
#
# Change the blending method of the sprite
# 0: Default
# 1: Addition type blending (Will look transparent light)
# 2: Substraction type blending (Will look transparent dark)
#------------------------------------------------------------------------------
# *> Fadeout / Fadein
#------------------------------------------------------------------------------
  SQV1_FADEIN = :fadein
  SQV1_FADEOUT = :fadeout
#------------------------------------------------------------------------------
# Usage:
# 1. [:fadein, <duration>]
# 2. [:fadeout, <duration>]
#
# Example
# > [:fadein, 30],
# > [:fadeout, 30],
#
# This command makes the action subject's sprite fading in/out. Specify the
# duration to completely fading in/out then give it time by adding wait timing.
#------------------------------------------------------------------------------
# *> Collapse effect
#------------------------------------------------------------------------------
  SQV1_COLLAPSE = :collapse 
#------------------------------------------------------------------------------
# Usage: [:collapse]
# 
# This command performs collapse effect like the default effect when an enemy
# is defeated. ONLY USE THIS COMMAND IN CUSTOM COLLAPSE EFFECT SEQUENCE TO 
# AVOID UNINTENDED GLITCHES!
#------------------------------------------------------------------------------
# *> Sprite Rotation
#------------------------------------------------------------------------------
  SQV1_ROTATION = :rotate 
#------------------------------------------------------------------------------
# Usage: [:rotate, <start angle>, <target degree>, <duration>]
# Example: [:rotate, 0, 360, 30],
# 
# This command is to perform rotation. Specify the start angle to target angle
# then specify the duration needed
#------------------------------------------------------------------------------
# *> Show balloon icon
#------------------------------------------------------------------------------
  SQV1_BALLOON = :balloon
#------------------------------------------------------------------------------
# Usage: [:balloon, <choice>]
# Example: [:balloon, :ex]
#
# Choices are
# 1. :ex, :exclamation
# 2. :question
# 3. :music, :note
# 4. :heart
# 5. :anger
# 6. :sweat
# 7. :cobweb
# 8. :silent, :silence
# 9. :light, :bulb, :lightbulb
# 10. :zzz, :sleep
#------------------------------------------------------------------------------
end
#==============================================================================
#
#                           END OF SPRITE COMMAND
#
#==============================================================================
