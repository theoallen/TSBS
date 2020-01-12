#==============================================================================
# Theolized Sideview Battle System (TSBS) - Target Commands
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
# TARGET COMMANDS
# > target move, target slide, change target, forced action
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# These are target related commands. Do something to the target, etc
#==============================================================================
# *> Do something to target
#------------------------------------------------------------------------------
  SQV2_TARGET = :target
#------------------------------------------------------------------------------
# Usage: 
# [:target, { options }]
#
# Template:
# [:target, {
#   :do => <something>,
#   :param => <something>,
#   :if => <script call>
# }]
#
# Example:
# Slide the target if the target get hits
  [:target, {
    :do => :slide,
    :param => [-50,0,5,0],
    :if => lambda {|a,b| b.result.hit? } # a = user, b = target
  }]
  
# Add state by 50% chance
  [:target, {
    :do => :add_state,
    :param => 10,
    :if => "rand > 0.5" # Script call
  }]
#
# Explanation:
# This command is to do something to the target. Options are mandatory to fill,
# otherwise it will not do anything. The option anatomy goes like this.
#
# :do     = What you want to do to the target?
# :param  = Parameters to what to do
# :if     = Condition check, can be a script call or lambda object. Can be 
#           omitted if you don't want a requirement.
#
# List on what you can do to the target
# 1. :move
# Parameter = [x, y, time, jump]
# Move the target to the destination
# Example:
  [:target, {:do => :move, :param => [-50,0,5,0]}]

# 2. :slide
# Parameter = [x, y, time, jump]
# Slide the target by x, y
# Example:
  [:target, {:do => :slide, :param => [-50,0,5,0]}]
  
# 3. :action
# Parameter = "ActionKey"
# The target do an action sequence.
# Example:
  [:target, {:do => :action, :param => "ActionKey"}]
# 
# 4. :func
# Parameter = Proc object
# Basically a script call to enable more flexible action
# Example:
  [:target, {:do => :func, :param => Proc.new {|a,b| b.die }}]
  
# 5. :flip
# Parameter = true/false/:toggle
# Flips the battler. :toggle parameter switches true to false and vice versa
# Example:
  [:target, {:do => :flip, :param => :toggle]
  
# 6. :lock_shadow
# Parameter = true/false/:toggle
# Lock battler shadow. :toggle parameter switches true to false and vice versa
# Example:
  [:target, {:do => :lock_shadow, :param => true]
  
# 7. :add_state
# 8. :remove_state
# Parameter = State ID
# Add / Remove state
# Example:
  [:target, {:do => :add_state, :param => 10]
  [:target, {:do => :remove_state, :param => 10]
  
#------------------------------------------------------------------------------
# *> Change target
#------------------------------------------------------------------------------
  SQV1_CHANGE_TARGET = :change_target
#------------------------------------------------------------------------------
# Usage: 
# [:change_target, <options>]
#
# Example:
  [:change_target, :random_enemy]
  [:change_target, :enemies]
  [:change_target, :allies]
#
# Explanation:
# This command is to change the target (duh!). Pick these options to change
# the target. Except :dead_allies, all options here are based on alive battle
# members
#
# 1. :ori, :ori_target 
#    Revert target to the original target
#
# 2. :all
#    Select all battlers. Enemies and allies alike (include self)
#
# 3. :all_except_user
#    Select all battlers. Enemies and allies alike (exclude self)
#
# 4. :enemies
#    Select all enemies
#
# 5. :enemies_min_target
#    Select all enemies, exclude the current target
#
# 6. :allies
#    Select all allies
#
# 7. :allies_min_target
#    Select all allies, excluse the current target
#
# 8. :allies_min_user
#    Select all allies, exclude the user
#
# 9. :random_enemy
#    Select random enemy (still influenced by TGR)
#
# 10. :random_ally
#    Select random enemy (still influenced by TGR)
#
# 11. :user
#     Select the user / self
#
# 12. :dead_allies
#     Select dead allies
#
# 13. :select
#     Special case if you want your own filter and any of above options do not
#     have the option you wanted.
#
# Explanation on use :select
# When you opt'ed to use :select, you have to input the second parameter. The
# second parameter uses { options } format, which the template is
# [:change_target, :select, {
#   :scope => :enemies / :allies / :all
#   :dead => true / false
#   :method => Lambda object
# }]
#
# For example, you want to select every battler that has state id 10
  [:change_target, :select, {
    :scope => :enemies,
    :dead => false,
    :method => lambda {|a,b| b.state?(10)}
  }]
# This means it checks ALL ALIVE ENEMIES and select ONLY that has state id 10.
# The variables are:
# a = user
# b = target
#------------------------------------------------------------------------------
# *> Check collapse
#------------------------------------------------------------------------------
  SQV1_CHECKCOLLAPSE = :check_collapse
#------------------------------------------------------------------------------
# Usage:
  [:check_collapse]
#
# This method check if the target is dead. By default, all of the battler are
# immortal during action sequence. In other word, death state ID is not applied
# during the action sequence. The death state ID only applied AFTER the 
# sequence. If you wish to check it, you put this command. It will also perform
# the collapse sequence.
#==============================================================================
#
#                           END OF TARGET COMMAND
#
#==============================================================================
