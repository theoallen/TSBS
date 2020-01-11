#==============================================================================
# Theolized Sideview Battle System (TSBS) - Default Action
  TSBS.versions[:default_action] = '2.0.0'
#------------------------------------------------------------------------------
# Contact :
#------------------------------------------------------------------------------
# *> Discord @ Theo#3034
#==============================================================================
#------------------------------------------------------------------------------
# Requires : 
# > Theo - Basic Modules v1.5b
# > Sprite Extension
#==============================================================================
# Terms of Use :
#------------------------------------------------------------------------------
# Credit me, TheoAllen. You are free to edit this script by your own. As long 
# as you don't claim it yours. For commercial purpose, don't forget to give me 
# a free copy of the game.
#==============================================================================
%Q{
  
  All of the default action behavior is defined here. Which mean, literally
  all actors will use the same sequence by default.
  
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  There're 10 types of the behaviors:
  
  1. Idle 
  Idle sequence is played when... idle, duh!
  
  2. Pinch
  Pinch sequence is played when the actor is in the critical condition. You can
  specify the critical condition by configuring the rate in "System Parameter"
  part of the script.
  
  3. Dodge
  Dodge sequence is automatically played when the action sequence actor tried
  to invoke item/skill to their target but it triggers evasion
  
  4. Hurt
  Hurt sequence is automatically played when the target battler get hits. This
  does not automaticallly being played when the item/skill is HP heals
  
  5. Skill Action
  Skill action is an action sequence that is played when you're using a skill.
  The default action for EVERY skill is defined here. However, you can change
  the default action to something else by giving notetag
  <sequence: key>
  
  6. Item Action
  Item action is an action sequence that is played when you're using an item.
  The default action for EVERY item is defined here. However, you can change
  the default action to something else by giving notetag
  <sequence: key>
  
  7. Post Action
  Post action is an action sequence that is played when the skill/item action
  is done.
  
  8. Dead
  Dead sequence is an idle sequence that is played when the actor is having a
  death state ID
  
  9. Victory
  Victory sequence is an action sequence that is played when the actor party
  win the battle
  
  10. Escape
  Escape sequence is an action sequence that is played when the player choose
  to escape the battle AND success.
  
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  The anatomy of action sequence:
  
  The action sequence consist of two things.
  > Action Key = The identity of the action sequence
  > Action Commands = A serial of commands to be executed
  
  >>>>>>>>>>>>>>>>>>>>>>>>>>>
  On defining the action key:
  Action Key must be in string format. e.g, "AwesomeMove"
  
  On defining the action commands
  Action commands must be defined in nested Array:
  For example
  [
    [:command_name, param1, param2, param3], <-- The comma is important!
    [:command_name, param1, param2, param3],
    [:command_name, param1, param2, param3],
    [:command_name, param1, param2, param3], 
  ]
  
  You have to replace the :command_name with an actual commands. These commands
  are listed in "Commands" section of the script. The parameter (param1, param2,
  param3, etc) are the command parameter. Different command requires different
  parameters you need to input. Make sure you pay attention to it.
  
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Defining your own action sequence:
  
  To define your own action sequence, you have to create it in your own script
  slot BELOW TSBS SCRIPT. Instruction on how to create your own action sequence
  is written in "Sample Sequence" part of the script. You can even paste them
  in a script slot and begin to modify it. 
  
  Do note that creating STATIC and DYNAMIC action sequence requires a different
  structure. Creating STATIC is easier for beginner since it's easier to grasp.
  However, DYNAMIC action offers more possibility if you know how to code Ruby.
  
}
#==============================================================================
# *> Set the default action below
#==============================================================================
class Game_Battler
  def action_sequence(action)
    case action
    # Define default idle sequence here 
    # (Do note that the idle starting sequence is randomized!)
    when DefaultIdle
      return [
        [:pose, 1, 0, 12],
        [:pose, 1, 1, 12],
        [:pose, 1, 2, 12],
        [:pose, 1, 3, 12],
      ]
    # Define default pinch sequence here
    when DefaultCritical
      return [
        [:pose, 1, 4, 12],
        [:pose, 1, 5, 12],
        [:pose, 1, 6, 12],
        [:pose, 1, 7, 12],
      ]
    # Define default evasion sequence for actor here
    when DefaultEvadeActor
      return [
        [:slide, 20, 0, 5, 6],
        [:wait, 7],
        [:return, 0, 0, 7, 0],
        [:wait, 7],      
      ]
    # Define default evasion sequence for enemy here
    when DefaultEvadeEnemy
      return [
        [:slide, -20, 0, 5, 6],
        [:wait, 7],
        [:return, 0, 0, 7, 0],
        [:wait, 7],
      ]
    # Define default taking damage sequence here
    when DefaultHurt
      return [
        [:pose, 1, 8, 15],
      ]
    # Define default post action (after using skill) sequence here
    when DefaultPostAction
      return [
        [:visible, true],
        [:unfocus, 30],
        [:if, "@ori_x != x || @ori_y != y", # If location changed?
          [
          [:return, 0, 0, 16, 10],
          [:pose, 1, 22, 17],
          ],
        ],
      ]
    # Define default knocked out sequence here
    when DefaultDead
      return [
        [:pose, 1, 10, 12],
      ]
    # Define default victory sequence here
    when DefaultVictory
      return [
        [:pose, 1, 12, 15],
        [:pose, 1, 13, 8],
        [:pose, 1, 14, 8],
        [:pose, 1, 15, 60],
      ]
    # Define default escape sequence here
    when DefaultEscape
      return [
        [:slide, 120, 0, 8, 24],
        [:wait, 30],
      ]
    # Define default skill sequence here
    when DefaultSkill
      return [
        [:move_to_target, 0,0,10,5],
        [:wait, 10],
        [:invoke_item],
        [:wait, 20],
      ]
    # Define default item use sequence here
    when DefaultItem
      return [
        [:move_to_target, 0,0,10,5],
        [:wait, 10],
        [:invoke_item],
        [:wait, 20],
      ]
    # DO NOT TOUCH THIS
    else
      action_sequence_ex(action)
    end
  end
end
#==============================================================================
#
#                        END OF DEFAULT ACTIONS
#
#==============================================================================
