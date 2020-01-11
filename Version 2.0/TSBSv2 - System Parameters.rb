#==============================================================================
# Theolized Sideview Battle System (TSBS)
  TSBS.versions[:sysparam] = '2.0.0'
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
module TSBS 
  #============================================================================
  # *> Sprite Dimension
  #----------------------------------------------------------------------------
    MaxRow = 6
    MaxCol = 4
  #----------------------------------------------------------------------------
  # Define the sprite dimension here. Putting MaxRow = 6 and MaxCol = 4 means
  # you're using 4x6 sprite size. This is essential to let the script know what
  # kind of sprite sheet you're using. 
  #
  # Once you have decide the dimension, ALL SPRITES MUST FOLLOW THE SAME RULES
  #============================================================================
    
  #============================================================================
  # *> Actor Position (as well as maximum battle members)
  #----------------------------------------------------------------------------
    ActorPos = [ # <--- Do not touch
  #----------------------------------------------------------------------------
      [410,250], # <-- 1st actor index in the party
      [430,280], # <-- 2nd actor index in the party
      [470,250], # <-- 3rd actor index in the party
      [490,280], # <-- 4th actor index in the party
      # Add more~
    ] # <-- DO NOT TOUCH
  #----------------------------------------------------------------------------
  # Put the actor position here. 
  #
  # MAXIMUM ACTOR IN BATTLE IS ALSO DEPENDS ON HOW MANY YOU PUT ACTOR 
  # COORDINATE IN THIS SETTING.
  #
  # For example, you only put 3 positions, then the maximum number of actor
  # in battle is only 3.
  #============================================================================
  
  #============================================================================
    Enemy_Default_Flip = false
  # Flip the enemy sprite?
  
    Critical_Rate = 0.25
  # When the HP rate is 0.25 (or any value you want), the idle is switched to
  # pinch idle sequence
  
    UseShadow = true
  # Show sprite shadow?
  
    KeepCountingDamage = true
  # Counting damage after K.O in mid sequence
  
    Looping_Background = false
  # Use looping battle background?
  
    UseDamageCounter = false
  # Use TSBS damage counter?
  
    Reflect_Guard = 121
  # Animation to be displayed when reflecting a magic attack
  
    AnimationCache = true
  # Fasten animation playing in a cost of consuming more RAM
  #============================================================================
  # *> Damage counter configuration
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # TOTAL HIT
  #============================================================================
    TotalHit_Vocab = "Hits:"                # Hit text vocab
    TotalHit_Color = Color.new(230,230,50)  # Hit text color
    TotalHit_Pos   = [[10,90],[110,104]]    # Hit text position
    TotalHit_Size  = 24                     # Hit text size
  #----------------------------------------------------------------------------
  #============================================================================
  # TOTAL DAMAGE
  #============================================================================
    TotalDamage_Vocab = "Damage:"              # Damage text vocab
    TotalDamage_Color = Color.new(255,150,150) # Damage text color
    TotalDamage_Pos   = [[10,70],[110,85]]     # Damage text position
    TotalDamage_Size  = 24                     # Damage text size
  #----------------------------------------------------------------------------
  #============================================================================
end
#==============================================================================
#
#                           END OF SYSTEM PARAMETER
#
#==============================================================================
