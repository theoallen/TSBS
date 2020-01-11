#==============================================================================
# Theolized Sideview Battle System (TSBS)
# Versions - 2.0
#==============================================================================
# Contact :
#------------------------------------------------------------------------------
# *> Discord @ Theo#3034
#==============================================================================
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
  
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  About:
  Theolized Sideview Battle System (or Theo SBS / TSBS, in short-hand) is a
  versatile animation system to create animated battler. The user are able to
  freely animate their battler sprite or even create a dynamic skills by 
  changing the damage properties and "if, else" flow controls. However, Due to 
  its versatility, the user of the script has to do themselves a favor to 
  customize everything in every detail of the system.
  
  THIS SCRIPT IS NOT PLUG AND PLAY. DO NOT EXPECT SOMETHING TO WORK JUST BY 
  PLUGGING IT IN TO YOUR PROJECT. 
  
  If you, instead, looking for more simpler animation engine that just work 
  with minimal effort, I would suggest you to search these system instead
  
  > Galv Animated Battlers
  > Jet's Viewed Battle 
  > Yanfly's Visual Battler
  > Reedo's Simple Side Battle System
  
  If you're looking an animation engine that do the same because for whatever
  reason, you don't like the direction of this script, you can also try
  
  > Victor Sideview Battle System
  > Yami's Battle Symphony
  > Tankentai Sideview Battle System
  
  DISCLAIMER:
  I'm not responsible for providing the sprite materials. The sprite material
  is fully user's responsibility to provide it for themselves. DO NOT ASK ME 
  HOW TO GET THE MATERIAL OR HOW TO MAKE THEM!
  
  The user of the script may need to know how to code ruby at some point. If 
  you're just get into RM and do not know how to code, it is advised to stay
  away from this script.
  
  The script also do not interact with the menu or turn order. It is only 
  handle the animation sequence when the user uses item/skill, and that's all
  about it. In which is technically should be compatible with most of turn 
  system such as ATB, FTB, etc, and should be compatible with any menu script. 
  With a few exception:
  
  - Luna engine is incompatible without patch because we both shared the same
    method name, and the method name is too common that it ended up overwrite
    each other
    
  - Mog's battler motion, because it is NOT a menu, it's motion to battler
    sprite effect to create breathing effect. Due to technical reason, we both
    shared the same sprite function. Mine to handle rotation and Mog's handle
    the breathing. Both do not interact well. How would you handle rotating
    sprites while also keep the breathing effect anyway?
  
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  How to make this script work at bare minimum:
  
  Longer explanation goes here:
  http://wiki.crescentsun.space/tsbs:getting_started
  
  First step:
  In order to make the script work without a crash, you need to put these 
  script list in this order:
  
  - Theo Basic Module
  - Sprite Extension
  - (Optional) <yanfly's scripts>
  - (Optional) <your other scripts>
  - TSBSv2 - Getting Started
  - TSBSv2 - System Parameters
  - TSBSv2 - Default Options
  - > Essential Commands
  - > Sprite Commands
  - > Missile Commands
  - > Target Commands
  - > Dynamic Commands
  - > Screen Commands
  - > Picture Commands
  - > Miscellaneous Commands
  - TSBSv2 - Notetags
  - TSBSv2 - Core Script
  - (Optional) Compatibility Patches
  - (Optional) <TSBS addons>
  
  Second step:
  In folder Graphics/Battlers, it must exist a graphic that correspond to your
  actor database. For example, your actor in the database is named "Eric", then
  in the said folder, you must have a graphic that is named as "Eric_1", 
  "Eric_2", etc. And by that, yes, it needs to have a number prefix like "_1".
  And it must start with number 1.
  
  Third step:
  Test the battle, and you will see your battler in motions.
  
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  > But this isn't what I want!
  
  First you need to explain "what you want". Is the sprite displayed 
  incorrectly? If yes, you probably should take a look at "System Parameter", on
  the sprite dimension. Are you using a correct dimension? Is the system define
  the dimension as 4x6 while you wish to use 3x4? If yes, then change it.
  
  > I do not want to use the first row as idle. 
    I want to use other rows for it. How do I fix this?
  
  Then you may want to take a look at "Default Action". You have to define the
  sequence manually there. If you have no idea how to write action sequence,
  you can try to read "Essential Commands" to get started on what to write
  
  > I want to know more about this.
  
  Then you may want to start to read the entire documents I write in this 
  script. Except the "Core Script" section, all of the instruction are 
  scattered. If you prefer a wiki format, you can access the link below
  
  http://wiki.crescentsun.space/tsbs
  
}
#==============================================================================
#
#                           End of Getting Started
#
#==============================================================================

# Do not touch these little code, okay?
module TSBS 
  @@versions = {}
  def self.versions
    @@versions
  end
end
