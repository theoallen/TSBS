#===============================================================================
# STATIC VERSION - used in v1.4, can be used in v2.0 as well
#-------------------------------------------------------------------------------
TSBS::AnimLoop.merge!({ # <-- Start with this

  # Define action sequence by writing
  # "KeyName" => []
  
  "ActionKey" => [
    [:command1, 1,2,3],
    [:command2, 1,2,3],
    [:command3, 1,2,3],
  ]

}) # <-- End with this
#===============================================================================
# DYNAMIC VERSION - used in v2.0
#-------------------------------------------------------------------------------
class Game_Battler # <-- Start with this
  
  # Then create an alias method. The name of the alias method MUST be unique
  # Format:
  # alias <ALIAS NAME> action_sequence_ex
  
  alias custom_action_ex action_sequence_ex
  def action_sequence_ex(action) # <-- Then write this
    case action # <-- Add case
    when "ActionKey" # <-- Add key here
      return [
        [:command1, 1,2,3],
        [:command2, 1,2,3],
        [:command3, 1,2,3],
      ]
    when "ActionKey2" # <-- Add more key here
      return [
        [:command1, 1,2,3],
        [:command2, 1,2,3],
        [:command3, 1,2,3],
      ]
    # Add more "when" here
    
    else # <-- When you're done, add this
      custom_action_ex(action) # <-- Call your alias
    end
  end

end # <-- End with this
#-------------------------------------------------------------------------------
# End of sample sequence addon
#===============================================================================
