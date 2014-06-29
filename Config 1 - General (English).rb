# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.3
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# English Translation by : Skourpy
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5b
# >> Basic Functions 
# >> Movement    
# >> Core Result
# >> Core Fade
# >> Clone Image
# >> Rotate Image
# >> Smooth Movement
# =============================================================================
# Script info :
# -----------------------------------------------------------------------------
# Known Compatibility :
# >> YEA - Core Engine
# >> YEA - Battle Engine (RECOMMENDED!)
# >> MOG Battle HUD
# >> Sabakan - Ao no Kiseki
# >> Fomar ATB
# >> EST - Ring System
# >> AEA - Charge Turn Battle
# -----------------------------------------------------------------------------
# Known Incompatibility :
# >> YEA - Lunatic Object
# >> Maybe, most of battle related scripts (ATB, or such...)
# >> MOG Breathing script
# =============================================================================
# Terms of Use :
# -----------------------------------------------------------------------------
# Credit me, TheoAllen. You are free to edit this script by your own. As long
# as you don't claim it yours. For commercial purpose, don't forget to give me
# a free copy of the game.
# =============================================================================
($imported ||= {})[:TSBS] = true  # <-- don't edit this line ~
# =============================================================================
module TSBS 
  # ===========================================================================
    MaxRow = 4
    MaxCol = 3
  # ---------------------------------------------------------------------------
  # Setting the ratio size of the sprite
  # MaxRow for row to down
  # MaxCol for side column /*note: like a frames */
  #
  # so if you input MaxRow = 4 and MaxCol = 3 then the ratio size of your 
  # spriteset must be 3 x 4
  # ===========================================================================
    
  # ===========================================================================
    Enemy_Default_Flip = false
  # ---------------------------------------------------------------------------
  # basically enemy sprite is facing left. but when battle scene it must facing 
  # right. to avoid some glitch, you can set the value to true /*mirror*/
  # ===========================================================================
    
  # ===========================================================================
    ActorPos = [ # <--- don't edit this
  # ---------------------------------------------------------------------------
      [430,230],
      [450,250],
      [470,270],
      
    # add more actor positions here
    ] # <-- don't edit this
  # ---------------------------------------------------------------------------
  # actor position in [x,y] coordinate. maximum battle members is depends at
  # how much you input the actor positions.  
  # ===========================================================================
  
  # ===========================================================================
    TotalHit_Vocab = "Total Hit"            # Info 1
    TotalHit_Color = Color.new(230,230,50)  # Info 2
    TotalHit_Pos   = [[51,10],[110,66]]     # Info 3
    TotalHit_Size  = 24                     # Info 4
  # ---------------------------------------------------------------------------
  # this setting for showing the hit counter. for more information see the
  # description below :
  #
  # Info 1 :
  # showing the total hit text
  # 
  # Info 2 :
  # for the text color, fill it with this format :
  # Color.new(red, green, blue). maximum value is 255
  #
  # Info 3 : 
  # position of total hit text, to set the position, follow the format below :
  # the coordinate is saved in 'nested array' where the first [x,y] is for the
  # text coordinate, and the second [x,y] is for numeric coordinate.
  # ===========================================================================
  
  # ===========================================================================
    TotalDamage_Vocab = "Damage"                # Info 1
    TotalDamage_Color = Color.new(255,150,150)  # Info 2
    TotalDamage_Pos   = [[75,10],[110,90]]      # Info 3
    TotalDamage_Size  = 24                      # Info 4
  # ---------------------------------------------------------------------------
  # this setting for showing the damage counter. for more information see the
  # description below :
  #
  # Info 1 :
  # showing the total damage text
  # 
  # Info 2 :
  # for the text color, fill it with this format :
  # Color.new(red, green, blue). maximum value is 255
  #
  # Info 3 : 
  # position of total hit text, to set the position, follow the format below :
  # the coordinate is saved in 'nested array' where the first [x,y] is for the
  # text coordinate, and the second [x,y] is for numeric coordinate.
  #
  # Well, same as Total Hit setting :v
  # ===========================================================================
  
  # ===========================================================================
    Critical_Rate = 0.25
  # ---------------------------------------------------------------------------
  # this rate is to specify an actor in critical state, 0.25 which means
  # if HP below 25% the actor is on critical state.
  # ===========================================================================
  
  # ===========================================================================
    Focus_BGColor = Color.new(0,0,0,128)
  # ---------------------------------------------------------------------------
  # Default color for :focus mode at action sequence. fill it with format below
  # --> Color.new(red, green, blue, alpha)
  # maximum value is 255
  # ===========================================================================
  
  # ===========================================================================
    UseShadow = true
  # ---------------------------------------------------------------------------
  # Will battler use shadow? Set it to true / false. Default is true
  # ===========================================================================
  
  # ---------------------------------------------------------------------------
  #                           Others Setting
  # ---------------------------------------------------------------------------
  
  # ===========================================================================
    CounterAttack = "Counterattacked!"
  # ---------------------------------------------------------------------------
  # showing text "Counterattacked!" if counter attacked.
  # ===========================================================================
  
  # ===========================================================================
    Magic_Reflect = "Magic Reflected!"
  # ---------------------------------------------------------------------------
  # showing text "Magic Reflected!" if some spell is reflected
  # ===========================================================================
  
  # ===========================================================================
    Reflect_Guard = 121
  # ---------------------------------------------------------------------------
  # Default Animation for target if target reflecting magic
  # ===========================================================================
  
  # ===========================================================================
    TimedHit_Anim = 206
  # ---------------------------------------------------------------------------
  # Animation ID for timed-hit. Note that this timed hit feature is still on
  # Beta. 
  # ===========================================================================
end
# =============================================================================
#
#                             END OF GENERAL CONFIG
#
# =============================================================================
