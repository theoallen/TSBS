#==============================================================================
# Theolized Sideview Battle System (TSBS) - Dynamic Commands
  TSBS.versions[:dynamic] = '2.0.0'
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
# DYNAMIC COMMANDS
# > if, case, script call, method call, loop, while loop, end action
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# These are dynamic control command in which you can alter the action sequence
# dynamically such as flow control to execute a certain chain of command when
# the condition is true. Or dynamically changing the parameter using script
# call or method call. 
#
# Some of these are advanced commands and you're required to understand how to 
# write script in Ruby Language. 
#==============================================================================
# *> Call another action sequence
#------------------------------------------------------------------------------
  SQV1_ACTION = :action 
#------------------------------------------------------------------------------
# Usage: [:action, "ActionKey"]
#
# This command is to call another action sequence based on its key so you can
# split them into your own category if you want to make them more modular
#------------------------------------------------------------------------------
# *> Script call / Method call
#------------------------------------------------------------------------------
  SQV1_SCRIPT = :script      
  SQV2_METHOD = :method
#------------------------------------------------------------------------------
# Usage:
# 1. [:script, "eval string"]
# 2. [:method, :method_name]
# 3. [:method, :method_name, [param1, param2, param3]]
# 
# Explanation (On using script call):
# The string must be a valid ruby code just like how you put damage formula in 
# the skill/item damage formula text field
#
# Explanation (On using method call): 
# The method name MUST EXIST in Game_Battler. The context of the Game_Battler 
# is the user, not the target. So if you're using a method call example below, 
# you're adding state 30 to the subject who's doing the action.
#
# > [:method, :add_state, [30]]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Tip on using method call:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# You can define your own method call in Game_Battler by adding a new script
# slot and begin to write:
#
# class Game_Battler
#   def your_method(param1, param2, param3)
#     <your code logic>
#   end
# end
#
# You can also manipulate action sequence this way by using these lines in your
# method call:
#
# @acts = [:command, param1, param2, param3]
# execute_sequence
#------------------------------------------------------------------------------
# *> Flow control (if, else, case)
#------------------------------------------------------------------------------
  SQV1_IF = :if             
  SQV1_CASE = :case           
#------------------------------------------------------------------------------
# Usage: 
# 1. [:if, "script call condition", <output true>, <output false>]
# 2. [:case, {
#       "script call condition 1" => <output if true>,
#       "script call condition 2" => <output if true>,
#       "script call condition 3" => <output if true>,
#       "script call condition 4" => <output if true>,
#       "true" => <output if everything else fails>,
#    }]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Explanation (On using IF flow control):
# This command is for a simple binary branch flow control,if true do a 
# certain action or when it fails, do a certain action. False branch (when the
# condition is not true) is OPTIONAL. You can omit it when you don't want them.
#
# The output parameter is explained below after the CASE flow control 
# explanation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Explanation (On using CASE flow control):
# Case control command is when you have multiple conditions that binary branch
# does not satisfy your need. The anatomy of the case control goes like this
#
# {"Script call 1" => <output>,
#  "Script call 2" => <output>,
#  "true" => <output if everything else fails>}
#
# The system will evaluate the condition from the top to bottom. Which mean if
# two or more condition is true, the former will get the priority. Putting 
# the condition as "true" will make the system execute the output. 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Explanation (On the output type):
# There're three types of output type you can use.
# 1. Action key
# 2. Single action
# 3. Multiple actions
#
# 1. On action key
# You just need to put an action key as the output of the flow control.
# For example, [:if, "hp_rate > 0.5", "ActionTrue", "ActionFalse"],
#
# 2 On single action
# You put a single action command in the output
# For example, [:if, "hp_rate > 0.5", [:cast, 100]],
#
# 3. On multiple actions
# You put a multiple actions in a nested array
# For example, 
# [:if, "hp_rate > 0.5",
#   [
#   [:command1, 1, 2, 3],
#   [:command2, 1, 2, 3],
#   [:command3, 1, 2, 3],
#   [:command4, 1, 2, 3],
#   ]
# ],
#------------------------------------------------------------------------------
# *> Loop control
#------------------------------------------------------------------------------
  SQV1_LOOP = :loop         
  SQV1_WHILE = :while 
#------------------------------------------------------------------------------
# Usage: 
# 1. [:loop, 10, <output>]
# 2. [:loop, "eval script", <output>]
# 3. [:while, "eval script", <output>]
#
# These commands are useful if you want to repeat the same action x times or
# while the condition is true
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Explanation (On using loop):
# For the first parameter (loop times), you have two kind of parameters.
# 1. Fixed number
# 2. Eval string that returns number
#
# For the second parameter (output), you only have TWO types of output
# 1. Action Key
# 2. Multiple Actions
#
# Please refers to the flow control for output type. Single action is NOT 
# supported in loop control
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Explanation (On using while)
# The first parameter on while loop command only accepts a valid eval string 
# that returns either true/false. The loop will be executed and re-evaluated
# once the action loop ends (not during)
#
# For the second parameter (output), you only have TWO types of output
# 1. Action Key
# 2. Multiple Actions
#------------------------------------------------------------------------------
# *> Exit action
#------------------------------------------------------------------------------
  SQV1_END_ACTION = :end_action 
#------------------------------------------------------------------------------
# Usage: [:end_action]
#
# This action ends the current action sequence even if it's in the middle of
# action sequence.
#------------------------------------------------------------------------------
end
