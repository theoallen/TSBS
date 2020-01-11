#==============================================================================
# Theolized Sideview Battle System (TSBS) - Essential Commands
  TSBS.versions[:essential] = '2.0.0'
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
# (fact: :invoke_item is the same command as :target_damage in TSBS v1.4)
#
# Note: renaming the command may make me harder to help you to debug your
# action sequence. If you do rename them, let me know in advance. 
#==============================================================================
module TSBS
#==============================================================================
# ESSENTIAL COMMANDS
# > pose, move, invoke item, play animation, wait,
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Below here are the essential commands in TSBS that you may use it often in
# your sequence. It is important to know what these command do before knowing 
# any other commands.
#==============================================================================
# *> Change the sprite pose
#------------------------------------------------------------------------------
  SQV1_POSE = :pose 
#------------------------------------------------------------------------------
# Usage: [:pose, file_index, cell, wait]
# Example: [:pose, 1, 3, 30],
# 
# Explanation:
# > file_index = The suffix number of the spriteset, e.g, "_1"
# > cell = frame number of the spriteset. If you're using 6x4, then frame 
#          number 3 is in 1st row and 4th column.
# > wait = frame wait before the next sequence. Putting 60 = 1 second
#
# Further explanation about frame cell (example, 6x4 sheet):
# These are the frame cell index you can pick
# | 0  | 1  | 2  | 3  | 4  | 5  |
# | 6  | 7  | 8  | 9  | 10 | 11 |
# | 12 | 13 | 14 | 15 | 16 | 17 |
# | 18 | 19 | 20 | 21 | 22 | 23 |
#------------------------------------------------------------------------------
# *> Movement
#------------------------------------------------------------------------------
  SQV1_MOVE2TARGET = :move_to_target
  SQV1_MOVE = :move           
  SQV1_SLIDE = :slide         
  SQV1_RETURN = :return # or :goto_oripost in v1.4
#------------------------------------------------------------------------------
# Usage: 
# Pick between [:move], [:move_to_target], [:slide], [:return]
# Then put the parameters in this following format
# <x, y, time, jump>
#
# Example:
# [:move_to_target, x, y, time, jump],
# [:move_to_target, 50, 0, 10, 1],
# 
# Parameter explanation:
# > x = X-axis displacement from the target position
# > y = Y-axis displacement from the target position
# > time = time required to move, in frames
# > jump = jump force. 0 means no jump
# 
# If you put move to target command and x = 50, it means if the target 
# x coordinate is in 120, you will be moving to x = 120 + 50 = 170.
#
# Command explanation:
# > [:move_to_target] = move to target position. If multiple target, move to 
#                       the center of the crowd
# > [:move] = Move to exact target coordinat to x,y
# > [:slide] = Slide from current position by x,y
# > [:return] = Return to original position
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# IMPORTANT NOTE:
# Movement command is a trigger. It means it will NOT move on its own. You have
# to manually put wait to allow the move animation to be played. The time 
# required for the sprite to move to the destination is defined in time 
# parameter
#------------------------------------------------------------------------------
# *> Wait 
#------------------------------------------------------------------------------
  SQV1_WAIT = :wait           
#------------------------------------------------------------------------------
# Usage: [:wait, frame]
# Example: [:wait, 45] <-- wait for 45 frames
#
# Wait command (alongside with wait function in pose command) is an important 
# command in TSBS to provide timing. The total length of your sequence is based
# on these. Other command do not provide any timing. Make sure you time your
# action sequence right!
#------------------------------------------------------------------------------
# *> Invoke item
#------------------------------------------------------------------------------
  SQV1_INVOKE = :invoke_item    
#------------------------------------------------------------------------------
# Usage: 
# 1. [:invoke_item]
# 2. [:invoke_item, { options }]
#
# Invoke item command is a command to apply item or skill to the target. 
# Options is optional parameter you can put, however you can ommit it when you
# think it is unnecessary. 
#
# To write options, use Hash format like this:
# {:param1 => value, :param2 => value}
#
# Option parameter list:
# :scale => 1.0 ~ 0.0   | Output scale
# :formula => "a.atk"   | Change damage formula
# :hit => true/false    | Force the item/skill to always hit / miss
# :crit => true/false   | Force the item/skill to always crit / never crit
# :eva => true/false    | Force the target to always evade / never evade
#
# Example on how to write options for invoke item:
# > make damage out put 150%
#   [:invoke_item, {:scale => 1.5}]
#
# > change formula
#   [:invoke_item, {:formula => "a.atk - b.def"}]
#
# > Using multiple options
#   [:invoke_item, {
#     :scale => 1.5,
#     :hit => true,
#     :crit => true,
#   }]
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# IMPORTANT NOTE:
# The change to the formula and scale is only temporary. And it is only valid
# for one instance of invoke item. If you're looking to change the item 
# property permanently for the entire action sequence, you may want to take a 
# look at Miscellaneous command > :alter_skill or :change_skill
#------------------------------------------------------------------------------
# *> Show animation
#------------------------------------------------------------------------------
  SQV2_ANIM = :anim
  SQV1_CAST = :cast
#------------------------------------------------------------------------------
# Usage: 
# 1. [:anim],
# 2. [:anim, { options }]
#
# This command is to play an animation. It has options that you can ommit if 
# you think it is unneccessary. By default if the options are ommited, it will
# play an animation based on the animation you set to the skill/item database.
#
# Options are as follow:
# :id => animation_id
# :to => :target / :self / :global
# :flip => true/false
# :follow => true/false
# :priority => :equal / :front / :back
#
# Explanation on the options:
# :id = Determine the animation ID to be played
# :to = Destination target as follow
#       > :target = play the animation at current target
#       > :self = play the animation at the user
#       > :global = one animation at the center of multiple targets

# :flip = Flips the animation horizontally
# :follow = Follows the target (if it's moving)
# :priority = Animation priority as follow
#             > :equal = has the same Z index as the battler
#             > :front = always in front of EVERY battler
#             > :back = animation is played behind the battler
#
# See on the invoke item explanation on how to write the options
#------------------------------------------------------------------------------
end
#==============================================================================
#
#                        END OF ESSENTIAL COMMAND
#
#==============================================================================
