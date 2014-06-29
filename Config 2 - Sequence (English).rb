# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.3
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# Some translation by : CielScarlet
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
module TSBS  # <-- don't touch
# =============================================================================
#                             SHOW ACTOR ICON
# =============================================================================
=begin

  First Part : Showing Icon
  
  This is where you define icon-icon that will be displayed when performed
  action sequence during battle. Such as an actor swing his/her weapon. You
  may add it as many as you want as long as you follow this format
  
  "key" => [origin, x, y, z, start, end, dur, index]
  
  Explanation :
  - "key"  >> Text key that will be used to call. Every icon sequence must have
              unique text key.
  - origin >> Center point of icon. There're 5 kind of center point. There're
              [0: Center] [1:Top-Left] [2: Top-Right] [3:Bottom-Left]
              [4: Bottom-Right]
  - x      >> Distance X from battler
  - y      >> Distance Y from battler
  - z      >> Is icon above battler? (true/false)
  - start  >> Starting angle of icon
  - end    >> Target angle of icon rotation
  - dur    >> The rotate duration in frame (60 frame = 1 second)
  - index  >> Icon index. Write -1 if you want to display actor weapon icon.
              and -2 if you want to display the second weapon. 
              
              You can also fill it up by text/string that will be evaluated as
              script. The return must be integer though. For example
              "actor.weapons[0].icon_index"
  - flip?  >> Will be icon flipped? Fill with true / false. You can ommit 
              though. The default value is false
  
  Note :
  The usage of icon itself will be revealed in action sequence on the third
  part of these settings
  
=end
# -----------------------------------------------------------------------------
# Here, where you define icon sequence that will be displayed
# -----------------------------------------------------------------------------
  Icons = {
  # "Key"   => [origin, x,    y,      z, start, end, dur, index],
    "Swing" => [4,     -5,  -12,   true,   -60,  70,   6,    -1],
    "Clear" => [4,      0,    0,  false,     0,   0,   0,     0],
    
  # Add more by yourself
  
  } # <-- don't touch !
# =============================================================================
#                             DEFAULT SEQUENCES
# =============================================================================
=begin

  Second Part : Default sequence
  
  Here where you define the default sequence for each battler movement. It's
  very useful if you're too lazy to put <sideview> tag in actor notebox and
  its attributes (like I did)
  
  Example :
  If you already define the Default_Idle = "IDLE"
  Then you're not require to put this tag in actor notebox
  
  <sideview>
  idle : IDLE
  </sideview>
  
  It because every battler will be using same sequence. To be noted that you
  have to have a same battler format. I mean, if battler_1 and the first row
  is used for idle, then the rest of your battler should do the same
  
  Those sequence keys can be looked after this part

=end
# -----------------------------------------------------------------------------
# Here, where you set the default setting of sequence for each action
# -----------------------------------------------------------------------------
  Default_Idle      = "K-idle"    # Idle sequence key
  Default_Critical  = "K-pinch"   # Critical sequence key
  Default_Evade     = "K-evade"   # Evade sequence key 
  Default_Hurt      = "K-hurt"    # Hit sequence key
  Default_Return    = "RESET"     # Return sequence key
  Default_Dead      = "K-dead"    # Dead sequence key
  Default_Victory   = "K-victory" # Victory sequence key
  Default_Escape    = "ESCAPE"    # Escape sequence key
  Default_Intro     = ""            # Intro sequence key
  Default_ACounter  = "Sol_Counter" # Counter attack for actor
  Default_ECounter  = "ECounter"    # Counter attack for enemy
    
  Default_SkillSequence = ["ATTACK"] # Default sequence for skill
  Default_ItemSequence  = ["K-Item"] # Default sequence for item
# =============================================================================
#                             ACTION SEQUENCES
# =============================================================================
=begin

  Third part : Action Sequences
 
  Here u can define battler movement for actor and enemy.
  Get ready because there will be a mass instructions from here. so far there 
  are 34 modes you can use for sequence. Here is the list :
  
  Initial release v1.0
  
  1)  :pose             >> To change pose
  2)  :move             >> To move into defined coordinates
  3)  :slide            >> To slide from current coordinates
  4)  :goto_oripost     >> To back into origin position
  5)  :move_to_target   >> To move into target
  6)  :script           >> To run a script
  7)  :wait             >> Wait before next sequence
  8)  :target_damage    >> Deal damage on target
  9)  :show_anim        >> show animation on target
  10) :cast             >> show aninmation on user
  11) :visible          >> set up visibility
  12) :afterimage       >> to turn afterimage on/off
  13) :flip             >> flip battler
  14) :action           >> call pre-defined action sequence
  15) :projectile       >> throw a projectile
  16) :proj_setup       >> set up projectile
  17) :user_damage      >> damage on user
  18) :lock_z           >> lock z coordinates. Lock shadow as well
  19) :icon             >> show an icon
  20) :sound            >> play a SE
  21) :if               >> for branch condition
  22) :timed_hit        >> timed hit function <beta>
  23) :screen           >> modify screen
  24) :add_state        >> add state on target
  25) :rem_state        >> remove state on target
  26) :change_target    >> change target
  27) :show_pic         >> show a picture <not-tested>
  28) :target_move      >> move target into defined coordinates
  29) :target_slide     >> slide target from their position
  30) :target_reset     >> reset target to origin position
  31) :blend            >> change blend type of user
  32) :focus            >> hid any non target battlers
  33) :unfocus          >> show all hidden battler 
  34) :target_lock_z    >> to lock z coordinate of target. Also lock its shadow
  
  Update v1.1
  35) :anim_top         >> to play animation always in front of screen
  36) :freeze           >> to freeze all non active movement <not-tested>
  37) :cutin_start      >> to show cutin picture
  38) :cutin_fade       >> to give fadein/fadeout effect on cutin
  39) :cuitn_slide      >> to slide cutin picture
  40) :target_flip      >> to flip target
  41) :plane_add        >> to add looping picture
  42) :plane_del        >> to remove looping picture
  43) :boomerang        >> to add boomerang effect on projectile
  44) :proj_afimage     >> to give an afterimage effect on projectile
  45) :balloon          >> to show an balloon icon on battler
  
  Update v1.2
  46) :log              >> To give a text on battle log
  47) :log_clear        >> To clear battle log message
  48) :aft_info         >> To set up afterimage effect
  49) :sm_move          >> Smooth move to specific coordinate
  50) :sm_slide         >> Smooth slide from current position
  51) :sm_target        >> Smooth move to target
  52) :sm_return        >> Smooth move back to original position
  
  Update v1.3
  53) :loop             >> Call action sequence in n times
  54) :while            >> Call action sequence while the condition is true
  55) :collapse         >> Call default collapse effect
  56) :forced           >> Force target to change action key
  57) :anim_bottom      >> Play animation behind battler
  58) :case             >> Branched action condition more than 2
  59) :instant_reset    >> Instantly reset battler position
  60) :anim_follow      >> Make animation follow battler
  61) :change_skill     >> Change carried skill for easier use
  
  ===========================================================================
  *) create an action sequence
  ---------------------------------------------------------------------------
  to add new action sequence, do it by this format :
 
  "Action Key" => [
  [loop?, Afterimage?, Flip?], <-- replace with true / false (needed)
  [:mode, param1, param2], <-- don't forget comma!
  [:mode, param1, param2],
  [:mode, param1, param2],
  ....
 
  ], <-- comma too!
 
  Note :
  > loop?
    will the sequence looping? use true for idle, dead, or
    victory pose. Not effect on skill or else.
   
  > Afterimage?
    use afterimage on the sequence?
    when true the skill will use afterimage.
   
  > Flip?
    Will the battler flipped ? when true battler will be flipped. when false, 
    battler won't be flipped.
    
    When nil / empty, battler will adjust itself to flip value from previous 
    action sequence. Only apply for skill sequence though
    
    When nil / empty for non-skill action sequence, battler will adjust itself
    to original value (actor won't be flipped. Enemy is depends on how do you
    set them up. Do you put <flip> tag or not)
   
  > :mode
    Sequence mode which I already wrote above
   
  > param1, param2
    parameter of each mode. each mode has different parameters
    make sure you read it carefully.
    
  ===========================================================================
  1)  :pose   | Change battler pose
  ---------------------------------------------------------------------------
  Format --> [:pose, number, cell, wait, (icon)],
 
  Note :
  This mode to change pose of battler from first cell into other cell
 
  Parameters :
  number  >> Is a number from the picture name. Like Ralph_1, Ralph_2
  cell    >> is a cell frame from spriteset. Example if you use
             3 x 4  spriteset, then from top left is 0 until 11 in bottom right. 
             If you use a very long spriteset, 
             you can input with "cell(row, column)"
             (without quotation of kors)
  wait    >> Wait before next sequence in frames
  icon    >> Icon key write between quotes ("example"). Icon here
             is used to call icon sequence from first part.
             if you dont want to show any, you can leave it empty
             
  Example :
  [:pose, 1, 1, 25],
  [:pose, 1, cell(1,2), 25],
  [:pose, 1, 1, 25, "Swing"],
  
  ===========================================================================
  2)  :move   | Move to a specified coordinates
  ---------------------------------------------------------------------------
  Format --> [:move, x, y, dur, jump],
 
  Note :
  This mode to move battler into a specified coordinates
 
  Parameters :
  x     >> x coordinate destination
  y     >> y coordinate destination
  dur   >> duration in frames smaller number, faster movement
  jump  >> Jump. Higher number higher jump
 
  Example :
  [:move, 150, 235, 60, 20],
  
  ===========================================================================
  3)  :slide   | Slide few pixel aside
  ---------------------------------------------------------------------------
  Format --> [:slide, x, y, dur, jump],
 
  Note :
  This mode to slide battler few pixel from origin coordinates based on what
  have you input into.
 
  Parameters :
  x     >> x coordinate displacement
  y     >> y coordinate displacement
  dur   >> duration in frames smaller number, faster movement
  jump  >> Jump. Higher number higher jump
 
  Example :
  [:slide, -100, 0, 25, 0],
  
  Note :
  If battler is flipped, then X coordinate will be flipped as well. In other
  word, regulary minus value of x means to be left. If battler flipped, then
  it means to be right (uh, I hope u understand what I'm trying to say)
  
  ===========================================================================
  4)  :goto_oripost  | Back to origin position
  ---------------------------------------------------------------------------
  Format --> [:goto_oripost, dur, jump],
 
  Note :
  This mode to revert battler to origin position
 
  Parameter
  dur   >> duration in frames smaller number, faster movement
  jump  >> Jump. Higher number higher jump
 
  Example :
  [:goto_oripost, 10, 20],
  
  ===========================================================================
  5)  :move_to_target  | Relative move to target
  ---------------------------------------------------------------------------
  Format --> [:move_to_target, x, y, dur, jump],
 
  Note :
  This mode to move battler to their target
 
  Parameters :
  x     >> x coordinate relative to target
  y     >> y coordinate relative to target
  dur   >> duration in frames smaller number, faster movement
  jump  >> Jump. Higher number higher jump
 
  Example :
  [:move_to_target, 130, 0, 25, 0],
  
  Note 1:
  If battler is flipped, then X coordinate will be flipped as well. In other
  word, minus value of x means to be left. If battler flipped, then it means to 
  be right (uh, I hope u understand what I'm trying to say)
  
  Note 2:
  If the target is area attack, then the action battler will move to the center
  of the targets
  
  ===========================================================================
  6)  :script   | Run a script call
  ---------------------------------------------------------------------------
  Format --> [:script, "script call"]
 
  Note :
  "script call" Is a content for a script call. Write it between quotes
 
  example :
  [:script, "$game_switches[1] = true"],
  
  ===========================================================================
  7)  :wait   | Waiting time in frames
  ---------------------------------------------------------------------------
  Format --> [:wait, frame],
 
  Note :
  Frame is a number used for waiting time in Frames. To be note that 60 
  frames is equal as 1 second
 
  Example :
  [:wait, 60],
  
  ===========================================================================
  8)  :target_damage   | Apply skill/item on target
  ---------------------------------------------------------------------------
  Format --> [:target_damage, (option)],
 
  Note :
  Option is a command to modify skill/item which will be used.
  There is 3 option you can use. You can leave it empty if you don't need
  it.
 
  - Formula
  Define skill with new formula. Formula must be write between quotes ("")
 
  - Skill ID
  You can change skill by using option.
 
  - Damage Rate
  You can change damage rate of the skill. Which will be double, 
  or half by inputing fraction number / float on option
 
  Example :
  [:target_damage],                            << Default
  [:target_damage, "a.atk * 10 - b.def * 5"],  << Custom formula
  [:target_damage, 10],                        << Apply other skill
  [:target_damage, 1.5],                       << Damage scale
  
  ===========================================================================
  9)  :show_anim   | Run animation on target
  ---------------------------------------------------------------------------
  Format --> [:show_anim, (anim_id), (flip?), (ignore anim guard?)],
 
  Note :
  - Anim_id is an optional option. You can define certain sequence will play
  which animation. Ignore this, then sequence will play default
  animation on skill / weapon you have set in database
 
  - Flip. Will the animation gonna be flipped? Ignore this if not needed
 
  - Ignore anim guard is to ignore animation guard animation from target 
 
  Example :
  [:show_anim],
  [:show_anim, 25],  << menjalankan animasi ID 25
  [:show_anim,116,false,true],
  
  ===========================================================================
  10) :cast   | Run animation on user
  ---------------------------------------------------------------------------
  Format --> [:cast, (anim_id), (flip)]
 
  Note :
  Like show anim. But the target is user. if anim_id is commited or nil, it
  is same as skill animation in database
  
  Flip is to flip animation which gonna be played. Default is same as battler
  flip value
 
  example :
  [:cast],  << Run animation from used skill / item
  [:cast, 25],  << Run animation ID 25 from database
  [:cast, 25, true],  << Run animation ID 25 from database and flip the anim
  
  ===========================================================================
  11) :visible   | Set up battler visibility
  ---------------------------------------------------------------------------
  Format --> [:visible, true/false],
 
  Note :
  Parameter of visibility mode is only 1. And it is enough by inputing true
  or false. When true, battler will be shown. False, battler will be hiden
 
  Example :
  [:visible, true],
  [:visible, false],
  
  ===========================================================================
  12) :afterimage   | Turn on afterimage effect
  ---------------------------------------------------------------------------
  Format --> [:afterimage, true/false],
 
  Note :
  Parameter mode of afterimage like on visible mode. Only applied by true or
  false
 
  Example :
  [:afterimage, true],
  [:afterimage, false],
  
  ===========================================================================
  13) :flip   | Flip battler sprite horizontaly
  ---------------------------------------------------------------------------
  Format --> [:flip, (option)],
 
  Note :
  There are 3 options to flip battler sprite. Those are:
  >> true     - to Flip
  >> false    - to not Flip or return it to original
  >> :toggle  - To flip sprite based on last condition
 
  Note :
  [:flip, true],
  [:flip, false],
  [:flip, :toggle],
  
  ===========================================================================
  14) :action   | Call a pre-defined action
  ---------------------------------------------------------------------------
  Format --> [:action, "key"],
 
  Note :
  Action mode is to combine action sequence. So you can just make a template
  and you can combine it with others just by calling it.
 
  Key is a sequence key of the sequence which will be combined
  
  example :
  [:action, "Magic Cast"],
  [:action, "Firebolt"],
  
  ===========================================================================
  15) :projectile   | Throw a projectile
  ---------------------------------------------------------------------------
  Format --> [:projectile, anim_id, dur, jump, (icon), (angle_speed)],
 
  Note :
  Like a target damage mode. But in projectile form. when projectile reach the
  target, then target will be damaged.
 
  The parameters are :
  anim_id     >> Animation id which will be display on projectile.
  dur         >> Duration in frames.
  jump        >> Jump.
  icon        >> Icon ID, or string/text which will be defined as a script
  angle_speed >> Rotation speed of an icon
 
  Note :
  [:projectile, 110, 10, 0, 0, 0],
  [:projectile, 0, 10, 20, 188, 0],
  [:projectile, 0, 10, 0, 147, 90],
  [:projectile, 0, 20, 10, "item_in_use.icon_index", 90],
  
  ===========================================================================
  16) :proj_setup   | set up projectile
  ---------------------------------------------------------------------------
  Format --> [:proj_setup, start, end],
 
  Note :
  This mode to set up projectile. Recommended to call this before :projectile
  to set up a projectile whch will be thrown
 
  Start >> Projectile origin location from user
  End   >> projectile destination (target)
 
  Input start and end with these formula
  :head   >> Target on upper part (head)
  :middle >> Target on mid part (body)
  :feet   >> Target on feet part (feet)
 
  example :
  [:proj_setup, :middle, :feet],
  
  ===========================================================================
  17) :user_damage   | Damage on user
  ---------------------------------------------------------------------------
  Format --> [:user_damage, (option)],
 
  Note :
  Like target damage. But the target is user
  There are 3 options you can use. You can leave it empty if you dont want it.
 
  - Formula
  Input skill with new formula. Formula must be write between quotes ("")
 
  - Skill ID
  You can change skill by inputing an id of skill you wanted to use from 
  database.
 
  - Damage Rate
  You can change damage rate of the skill. Which will be double, 
  or half by inputing fraction number / float on option
 
  Example :
  [:user_damage],                            << Default / as it is
  [:user_damage, "a.atk * 10 - b.def * 5"],  << Custom formula
  [:user_damage, 10],                        << Apply other skill
  [:user_damage, 1.5],                       << Damage scale
  
  ===========================================================================
  18) :lock_z   | Lock Z coordinates. Lock shadow as well
  ---------------------------------------------------------------------------
  Format --> [:lock_z, true/false],
 
  Note :
  Z coordinates is a coordinates to define which sprite is nearest to player's
  screen. In TSBS Z coordinates are dynamic. Sprite with most y coordinates 
  (most bottom) also got the highest Z coordinates value.
 
  If a sprite move to upper part in screen, Then z coordinates can be dropped. 
  To prevent it, you can lock z coordinates with certain conditions
 
  Z coordinates affecting battler shadow. If you lock it, then battler's shadow 
  also won't move
 
  Example :
  [:lock_z, true],
  [:lock_z, false],
  
  ===========================================================================
  19) :icon   | Show an icon
  ---------------------------------------------------------------------------
  Format --> [:icon, "key"],
 
  Note :
  like a :pose mode. just this one independent not affected by :pose mode
 
  Example :
  [:icon, "Swing"],
  
  ===========================================================================
  20) :sound  | Play a Sound effect
  ---------------------------------------------------------------------------
  Format --> [:sound, name, vol, pitch],
 
  Note :
  This mode to play a sound effect
 
  Parameters :
  name  >> Neme of SE which present on folder Audio/SE
  vol   >> Volume SE which will be played
  pitch >> Pitch SE which will be played
 
  Example :
  [:sound, "absorb", 100, 100],
  
  ===========================================================================
  21) :if | Branched condition
  ---------------------------------------------------------------------------
  Format --> [:if, script, act_true, (act_false)],
  
  Note :
  To make a branched sequence. Wrong script call will throw an error. So be
  careful, kay?
  
  Parameters :
  script    >> Is a String / Text will be evaluated as script. 
  Act_true  >> Action key will be called if the condition is true
  Act_false >> Action key will be called if the condition is false. Can be
               ommited if not necessary
  
  Example :
  [:if, "$game_switches[1]", "Suppa-Attack"],
  [:if, "$game_switches[1]", "Suppa-Attack","Normal-Attack"],
  
  --------------------
  Alternative :
  --------------------
  If you don't want to make a new action sequence only for single sequence, you
  could directly put a new array inside branched condition
  
  
  Example :
  [:if, "$game_switches[1]", [:target_damage]],
  [:if, "$game_switches[1]", [:target_damage], [:user_damage]],
  
  --------------------
  Another alternative :
  --------------------
  If you don't want to make a new action sequence only for branched sequence,
  you could put new sequence directly on the branch without making new action
  key sequence.
  
  
  Example, taken from Soleil normal attack (sample game):
  [:if,"target.result.hit?",
    [ 
    [:target_slide, -5, 0, 3, 0],
    [:slide,-5, 0, 3, 0],
    ],
  ], 
  
  ===========================================================================
  22) :timed_hit  | Built-in timed hit function
  ---------------------------------------------------------------------------
  Format --> [:timed_hit, count],
 
  Note :
  Inspired from Eremidia: Dungeon!. Timed hit is a function when player hit a
  certain button in a correct timing, then player will get a reward.
  Like a skill damage become double.
 
  This mode must be followed by [:if] where parameter is
  [:if, "@timed_hit", "Suppa-Attack"],
 
  Parameters :
  Count is a timing chance for player to hit confirm / C in frames.
  (And only confirm button)
 
  Example :
  [:timed_hit, 60],
  [:wait, 60],  <-- You could change it to :pose
  [:if, "@timed_hit", "Suppa-Attack"],
 
  Next update :
  I might add other button beside C/Confirm like
  A, B, X, Y, atau :SHIFT
 
  Note :
  This feature is beta. You could use it anyway. But do not expect many things
  since I already said, it's BETA
  
  ===========================================================================
  23) :screen | modify screen
  ---------------------------------------------------------------------------
  Format --> [:screen, submode, param1, param1],
 
  Note :
  This mode to modify screen. there are submode in :screen mode. those are :
 
  :tone       >> like a tint screen on event
  :shake      >> like a shake screen on event
  :flash      >> like a flash screen on event
  :normalize  >> Revert tint to original
 
  --------------------------------------------------
  Parameter (:tone)
  Format --> [:screen, :tone, tone, dur],
  - Tone  >> Tone.new(red, green, blue, gray)
  - dur   >> Duration of tone changes in frames
 
  Example :
  [:screen, :tone, Tone.new(120, 90, 0, 0), 60]
 
  --------------------------------------------------
  Parameter (:shake)
  Format --> [:screen, :shake, power, speed, dur],
  - power >> Shake strength
  - shake >> Shake speed
  - dur   >> Duration of shake in frames
 
  Example :
  [:screen, :shake, 5, 10, 60],
 
  --------------------------------------------------
  Parameter (:flash)
  Format --> [:screen, :flash, color, dur],
  - color >> Color.new(red, green, blue, alpha)
  - dur   >> Duration of flash in frames
 
  Example :
  [:screen, :flash, Color.new(255,255,255,128), 60],
 
  --------------------------------------------------
  Parameter (:normalize)
  Format --> [:screen, :normalize, dur],
  - dur   >> to revert screen into original
 
  example :
  [:screen, :normalize, 60],
  
  ===========================================================================
  24) :add_state  | Add state on target
  ---------------------------------------------------------------------------
  Format --> [:add_state, state_id, (chance), (ignore_rate?)],
  
  Note :
  Like the name. This mode to apply state based on chance on target.
  
  Parameters :
  state_id  >> State id from database
  chance    >> Chance / opportunity. write between 1 ~ 100 or 0.0 ~ 1.0. The
               default value is 100 if ommited
  ignore_rate >> To ignore state rate features from database. Pick between true
                 or false. The default is false if ommited
  Example :
  [:add_state, 10],
  [:add_state, 10, 50],
  [:add_state, 10, 50, true],
  
  ===========================================================================
  25) :rem_state  | Remove state on target
  ---------------------------------------------------------------------------
  Format --> [:rem_state, state_id, (chance)],
  
  Note :
  Like the name. This mode to remove state based on chance on target.
 
  Parameter :
  state_id  >> State id from database
  chance    >> Chance / opportunity. write between 1-100. or 0.0 ~ 1.0. The
               default value is 100 if ommited
 
  Example :
  [:rem_state, 10],
  [:rem_state, 10, 50],
  
  ===========================================================================
  26) :change_target  | Change target *u don't say*
  ---------------------------------------------------------------------------
  Format --> [:change_target, option],
 
  Note :
  This mode to change target in the mid of action sequence. 
  there are 11 mode here. there are :
 
  0   >> Revert to original target (target from database)
  1   >> Target all (allies + enemies)
  2   >> Target all (allies + enemies) except user
  3   >> All enemies
  4   >> All enemies except current target
  5   >> All allies
  6   >> All allies except user
  7   >> Next random enemy
  8   >> Next random ally
  9   >> Absolute random target for enemies
  10  >> Absolute random target for allies
  11  >> Self
 
  Example :
  [:change_target, 0],
  [:change_target, 1],
  [:change_target, 2],
  [:change_target, 3],
  [:change_target, 4],
  [:change_target, 5],
  [:change_target, 6],
  [:change_target, 7],
  [:change_target, 8],
  [:change_target, 9,  3],  <-- 3 absolute random target for enemies
  [:change_target, 10, 3],  <-- 3 absolute random target for allies
  [:change_target, 11],
 
  Note :
  Absolute target is a fixed target. Target won't get hit twice like default
  random target in database does. However, absolute target doesn't affected
  by TGR. So all battlers are threated equally
  
  ===========================================================================
  27) :show_pic
  ---------------------------------------------------------------------------
  
  I made the function. But I haven't tested yet. I'm just too lazy
  
  ===========================================================================
  28) :target_move  | Move target in certain coordinates
  ---------------------------------------------------------------------------
  Format --> [:target_move, x, y, dur, jump],
 
  Note  :
  This mode to move target into certain coordinates. Like a move mode but the
  subject is the current target
 
  Parameter :
  x     >> X coordinates destination
  y     >> Y coordinates destination
  dur   >> Duration in frames. Smaller number, faster movement
  jump  >> Jump. Higher number, higher height as well
 
  Example :
  [:target_move, 200,50,25,0],
  
  ===========================================================================
  29) :target_slide | slide targets from their coordinates
  ---------------------------------------------------------------------------
  Format --> [:target_side, x, y, dur, jump],
 
  Note :
  This mode is to slide target. Like slide mode but the subject is the current
  target
 
  Parameter :
  x     >> X coordinates displacement
  y     >> Y coordinates displacement
  dur   >> Duration in frames
  jump  >> Jump
 
  example :
  [:target_slide, 200,50,25,0],
  
  ===========================================================================
  30) :target_reset  | Return target to their origin location
  ---------------------------------------------------------------------------
  Format --> [:target_reset, dur, jump]
 
  Note :
  Like goto_oripost. But for a target
 
  Parameter :
  dur   >> Duration in frames
  jump  >> Jump
 
  Example :
  [:target_reset, 5, 0],
  
  ===========================================================================
  31) :blend  | To change blend type of battler
  ---------------------------------------------------------------------------
  Format --> [:blend, type]
 
  Note :
  To change blend type of battler
 
  Type with these option
  0 >> Normal
  1 >> Addition (bright)
  2 >> Substract (dark)
 
  Example :
  [:blend, 0],
  [:blend, 1],
  [:blend, 2],
  
  ===========================================================================
  32) :focus  | To hid battlers which are not target
  ---------------------------------------------------------------------------
  Format --> [:focus, dur, (color)],
 
  Note :
  this mode is to hide target which are not target and user. So the action only 
  focus on subject and their target

  Parameter :
  dur   >> fadeout duration in frames
  color >> Color.new(red, green, blue, alpha)
 
  Example :
  [:focus, 30],
  [:focus, 30, Color.new(0,0,0,128)],
  
  ===========================================================================
  33) :unfocus  | To show all battler
  ---------------------------------------------------------------------------
  Format --> [:unfocus, dur],
  
  Note :
  Like focus. But this mode to cancel focus effect. 
  Must be called after using focus effect
 
  Parameter :
  dur >> Fadein duration in frames
 
  Example :
  [:unfocus, 30],
  
  ===========================================================================
  34) :target_lock_z  | Temporary lock Z coordinates of target
  ---------------------------------------------------------------------------
  Format --> [:target_lock_z, true/false]
 
  Note :
  Like :lock_z but only applied on target
 
  Example :
  [:target_lock_z, true],
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.1
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================
  35) :anim_top   | To play animation always in front of screen
  ---------------------------------------------------------------------------
  Format --> [:anim_top]
 
  Note :
  Flag to make animation played in front of screen. Put it before :cast or 
  :show_anim
 
  Example :
  [:anim_top],
  [:cast],
 
  [:anim_top],
  [:show_anim],

  ===========================================================================
  36) :freeze | To freeze all movement but the active ones <not-tested>
  ---------------------------------------------------------------------------
  Format --> [:freeze, true/false]
  
  Note :
  To stop all update movement but the battler in action. 
  Don't forget to set it to false after the skill is over
 
  Example :
  [:freeze, true],
  [:freeze, false],
 
  Note :
  Note yet tried, there might be a glitch or such
  
  ===========================================================================
  37) :cutin_start | To show a cutin picture
  ---------------------------------------------------------------------------
  Format --> [:cutin_start, file, x, y, opacity]
  
  Note :
  To show actor's cutin picture. But can be used to show a pic. 
  Because I make it to show cutin pic to start with, then i name it 
  :cutin_start
 
  Parameters :
  file    >> File picture name, must be in Graphics/picture
  x       >> X start position
  y       >> Y start position
  opacity >> start opacity (input between 0 - 255)
 
  Example :
  [:cutin_start,"sol-cutin-nobg",100,0,0],
 
  Note :
  Only 1 picture can be shown
  
  ===========================================================================
  38) :cutin_fade | To give a fadein/fadeout effect on cutin
  ---------------------------------------------------------------------------
  Format --> [:cutin_fade, opacity, durasi]
 
  Note :
  To change opacity of cutin image to a certain value in given time duration
 
  Parameters :
  opacity >> Opacity target
  durasi  >> Change duration in frames (60 = 1 detik)
 
  Example :
  [:cutin_fade, 255, 15],
  
  ===========================================================================
  39) :cutin_slide | To slide cutin image
  ---------------------------------------------------------------------------
  Format --> [:cutin_slide, x, y, durasi]
  
  Note :
  To slide cutin image to specific coordinate displacement in given time
  duration
  
  Parameters :
  x       >> X slide value
  y       >> Y slide value
  durasi  >> Duration in frames (60 = 1 second)
  
  Example :
  [:cutin_slide, -100, 0, 30]
  
  ===========================================================================
  40) :target_flip | Flip target
  ---------------------------------------------------------------------------
  Format --> [:target_flip, true/false]
 
  Note :
  Simply to flip target
 
  Example :
  [:target_flip, true]
  [:target_flip, false]
  
  ===========================================================================
  41) :plane_add | Add looping image
  ---------------------------------------------------------------------------
  Format --> [:plane_add, file, speed_x, speed_y, (above), (dur)]
  
  Note :
  This mode to add looping effect like Fog, parallax or any similiar things.
 
  Parameter :
  file    >> Picture name must be put in Graphics/picture
  speed_x >> Scrolling speed to horizontal direction
  speed_y >> Scrolling speed to vertical direction
  above   >> Above battler? Define with true/false
  dur     >> Duration of poping picture opacity from 0 until 255 in frames. 
             Can be ignored, 2 by default
 
  Example :
  [:plane_add,"cutin-bg",35,0,false,15],
 
  Note :
  Only 1 looping picture
  
  ===========================================================================
  42) :plane_del | Delete / remove looping image
  ---------------------------------------------------------------------------
  Format --> [:plane_del, durasi]
 
  Note :
  This mode to delete a looping image which called by :plane_add with a 
  duration in frames.
 
  example :
  [:plane_del, 30],
  
  ===========================================================================
  43) :boomerang | Give boomerang effect on projectile
  ---------------------------------------------------------------------------
  Format --> [:boomerang]
 
  Note :
  Flag to define projectile which will be back to user / caster after used. 
  Use before :projectile 
 
  Example :
  [:boomerang],
  [:projectile,0,8,15,154,20],
  
  ===========================================================================
  44) :proj_afimage | Give afterimage effects on projectile
  ---------------------------------------------------------------------------
  Format --> [:proj_afimage]
 
  Note :
  Flag to set the next projectile will be thrown with afterimage effects.
  use it before :projectile
  
  Example :
  [:proj_afimage],
  [:projectile,0,8,15,154,20],
 
  If used together with :boomerang
  [:boomerang],
  [:proj_afimage],
  [:projectile,0,8,15,154,20],
  
  ===========================================================================
  45) :balloon | To show ballon icon on battler
  ---------------------------------------------------------------------------
  Format --> [:balloon, id]
 
  Note :
  Show balloon on battler
 
  Example :
  [:balloon, 1]
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.2
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================
  46) :log | To display text in battle log
  ---------------------------------------------------------------------------
  Format --> [:log, "Text"]
  
  Note :
  This sequence mode is to display text in battle log. Use "<name>" to display
  subject/battler's name
  
  Example :
  [:log, "<name> disappears!"],
  
  ===========================================================================
  47) :log_clear | To clear battle log message
  ---------------------------------------------------------------------------
  Format --> [:log_clear]
  
  Note :
  To clear battle log message. Doesn't need parameter
  
  Example :
  [:log_clear],
  
  ===========================================================================
  48) :aft_info | To set up afterimage effects
  ---------------------------------------------------------------------------
  Format --> [:aft_info, rate, fade_speed]
  
  Note  :
  It's to change afterimage effect. Such as getting thicker or change
  afterimage fading speed
  
  Parameters :
  - rate  >> Afterimage thinkness. Lower value means thicker. The minimum value
             is 1. Default value is 3.
  - fade  >> Fadeout speed of afterimage. Lower value, lower fadeout as well.
             The default value is 20.
  
  Example :
  [:aft_info, 1,10],
  
  ===========================================================================
  49) :sm_move | Smoot slide to specific coordinate
  ---------------------------------------------------------------------------
  Format --> [:sm_move, x, y, dur, (rev)]
  
  Note  :
  Same as :move. But it supports acceleration to make it seems smooth. Doesn't
  support jumping though
  
  Parameters :
  x   >> X coordinate destination
  y   >> Y coordinate destination
  dur >> Travel duration in frames
  rev >> Reverse. If you set it true, sprite will be move at maximum speed. 
         While false, sprite will be move start from 0 velocity. Default value
         is true
         
  Example :
  [:sm_move, 100,50,45],
  [:sm_move, 100,50,45,true],
  
  ===========================================================================
  50) :sm_slide | Smooth slide from current position
  ---------------------------------------------------------------------------
  Format --> [:sm_slide, x, y, dur, (rev)]
  
  Note  :
  Same as :slide. But it supports acceleration to make it seems smooth. Doesn't
  support jumping though
  
  Parameters :
  x   >> X displacement from origin coordinate
  y   >> Y displacement from origin coordinate
  dur >> Travel duration in frames
  rev >> Reverse. If you set it true, sprite will be move at maximum speed. 
         While false, sprite will be move start from 0 velocity. Default value
         is true
         
  Example :
  [:sm_slide, 100,50,45],
  [:sm_slide, 100,50,45,true],
  
  ===========================================================================
  51) :sm_target | Smooth move to target
  ---------------------------------------------------------------------------
  Format --> [:sm_target, x, y, dur, (rev)]
  
  Note  :
  Same as :move_to_target. But it supports acceleration to make it seems 
  smooth. Doesn't support jumping though
  
  Parameters :
  x   >> X displacement from target
  y   >> Y displacement from target
  dur >> Travel duration in frames
  rev >> Reverse. If you set it true, sprite will be move at maximum speed. 
         While false, sprite will be move start from 0 velocity. Default value
         is true
  
  Example :
  [:sm_target, 100,0,45],
  [:sm_target, 100,0,45,true],
  
  Note 1:
  If battler is flipped, then X coordinate will be flipped as well. In other
  word, minus value of x means to be left. If battler flipped, then it means to 
  be right (uh, I hope u understand what I'm trying to say)
  
  Note 2:
  If the target is area attack, then the action battler will move to the center
  of the targets
  
  ===========================================================================
  52) :sm_return | Smooth move back to original position
  ---------------------------------------------------------------------------
  Format --> [:sm_return, dur, (rev)]
  
  Note  :
  Same as :goto_oripost. But it supports acceleration to make it seems smooth. 
  Doesn't support jumping though
  
  Parameter :
  dur >> Travel duration in frames
  rev >> Reverse. If you set it true, sprite will be move at maximum speed. 
         While false, sprite will be move start from 0 velocity. Default value
         is true
  
  Example :
  [:sm_return,30],
  [:sm_return,30,true],       

  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.3
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================  
  53) :loop | Call action key in n times
  ---------------------------------------------------------------------------
  Format --> [:loop, times, "Key"]
  
  Note  :
  Same as [:action,]. But instead of copying, you can do it in singe line.
  
  Parameters :
  times >> How many times action key will be called
  Key   >> Action Key will be called
  
  Example :
  [:loop, 3, "CastPose"],
  
  ===========================================================================  
  54) :while | Call action sequence while the condition is true
  ---------------------------------------------------------------------------
  Format --> [:while, cond, "key"]
  
  Note  :
  Similar as looping. But the action key will be repeated while the condition
  is return true
  
  Parameter :
  cond >> Kondisi salah benar dalam script
  key  >> Action key yang akan dipanggil
  
  Example :
  [:while, "$game_variables[1] < 10", "Sol_Strike"]
  
  ===========================================================================  
  55) :collapse | Call default collapse effect
  ---------------------------------------------------------------------------
  Format --> [:collapse]
  
  Note  :
  It's to display collapse effect manually if you plan to use custom collapse
  sequence. And please use ONLY for custom collapse effect
  
  Example :
  [:collapse],
  
  ===========================================================================  
  56) :forced | Force target to switch action key
  ---------------------------------------------------------------------------
  Format --> [:forced, "key"]
  
  Note  :
  Force target to switch action key. If it used within counterattack, you
  could make it as knockback effect and combo breaker if the attacker use
  multiple hit attack
  
  Parameters :
  key >> Action Key will be used to target
  
  Example :
  [:forced, "KnockBack"],
  
  ===========================================================================  
  57) :anim_bottom | Play animation behind battler
  ---------------------------------------------------------------------------
  Format --> [:anim_bottom]
  
  Note  :
  Same as [:anim_top]. But it will make the next animation will be played
  behind the battler. Call right before [:cast] or [:show_anim]
  
  Examples :
  [:anim_bottom],
  [:cast, 69],
  
  [:anim_bottom],
  [:show_anim],
  
  ===========================================================================  
  58) :case | Branched action conditions more than 2
  ---------------------------------------------------------------------------
  Format --> [:case, hash]
  
  Note  :
  Used to make branched condition more than 2. It comes in handy rather than 
  use nested if ([:if] inside [:if])
  
  Parameter :
  Hash >> Make a list of branched condition within this format
          {
            "Condition 1" => "ActionKey1",
            "Condition 2" => "ActionKey2",
            "Condition 3" => "ActionKey3",
          }
          
  Example :
  [:case, {
    "$game_variables[1] == 1" => "Action1",
    "$game_variables[1] == 2" => "Action2",
    "$game_variables[1] == 3" => "Action3",
    "$game_variables[1] == 4" => "Action4",
    "$game_variables[1] == 5" => "Action5",
  }],
  
  --------------------
  Alternative :
  --------------------
  If you don't want to make a new action sequence only for single sequence, you
  could directly put a new array inside branched condition.
  
  Example :
    [:case,{
    "state?(44)" => [:add_state,45],
    "state?(43)" => [:add_state,44],
    "state?(42)" => [:add_state,43],
    "true" => [:add_state,42],
  }],
  
  --------------------
  Another alternative :
  --------------------
  If you don't want to make a new action sequence only for branched sequence,
  you could put new sequence directly on the branch without making new action
  key sequence.
  
  Example :
  [:case,{
    "state?(44)" => [
      [:show_anim, 1],
      [:target_damage, 1],
    ],
    
    "state?(43)" => [
      [:show_anim, 1],
      [:target_damage, 1],
    ],
    
    "state?(42)" => [
      [:show_anim, 1],
      [:target_damage, 1],
    ],
    
    "true" => [
      [:show_anim, 1],
      [:target_damage, 1],
    ],
  }],
  
  Another note :
  If there are more than one condition which are true, then the top condition
  will be used.
  
  ===========================================================================  
  59) :instant_reset | Instantly reset battler position
  ---------------------------------------------------------------------------
  Format --> [:instant_reset]
  
  Note  :
  Just to instantly reset battler position (doesn't require wait to perform)
  
  Example :
  [:instant_reset],

  ===========================================================================  
  60) :anim_follow | Make animation follow battler
  ---------------------------------------------------------------------------
  Format --> [:anim_follow]
  
  Note :
  Like [:anim_top]. But it will make the next animation to follow the battler
  where it goes. Call right before [:cast] or [:show_anim]
  
  
  Example :
  [:anim_follow],
  [:cast, 69],
  
  [:anim_follow],
  [:show_anim],
  
  Won't works for screen animation

  ===========================================================================  
  61) :change_skill | Change carried skill for easier use
  ---------------------------------------------------------------------------
  Format --> [:change_skill, id]
  
  Note :
  More like [:target_damage, id]. But it doesn't deal damage. Instead, it will
  change carried skill from battler. i.e, you could rescale it the damage
  output or even change the attack formula.
  
  Example :
  [:change_skill, 13],
  [:target_damage, 0.5],
  [:wait, 15],
  [:target_damage, 1.5],
  [:wait, 15],
  [:target_damage, 0.5],
  [:wait, 15],
  
  Damage output rescale from different skill id couldn't be done by regular 
  [:target_damage]. By calling this skill, now you could

=end
# =============================================================================
  AnimLoop = { # <-- Do not touch at all cost!
# -----------------------------------------------------------------------------
# Define you own custom sequences here.
# -----------------------------------------------------------------------------
  "IDLE" => [
  #[Loop, afterimage, flip]
  [true, false, false],
  [:pose,     1,   0,   10],
  [:pose,     1,   1,   10],
  [:pose,     1,   2,   10],
  [:pose,     1,   1,   10],
  ],
  # ---------------------------------------------------------------------------
  # Enemy idle sequence
  # ---------------------------------------------------------------------------
  "Enemy_IDLE" => [
  [true, false, true],
  [:pose,     1,   0,   10],
  [:pose,     1,   1,   10],
  [:pose,     1,   2,   10],
  [:pose,     1,   3,   60],
  ],
  # ---------------------------------------------------------------------------
  # Basic attack sequence
  # ---------------------------------------------------------------------------
  "ATTACK" => [
  [false, false, nil],
  [:move_to_target, 0, 0, 10, 10],
  [:wait, 10],
  [:show_anim],
  [:target_damage],
  [:wait, 25],
  ],
  # ---------------------------------------------------------------------------
  # Move to target
  # ---------------------------------------------------------------------------
  "MOVE_TO_TARGET_FAR" => [
  [:move_to_target, 130, 0, 15, 10],
  [:pose, 1, 9, 7],
  [:pose, 1, 11, 8],
  [:pose, 1, 0, 20],
  ],
  # ---------------------------------------------------------------------------
  # Move to target
  # ---------------------------------------------------------------------------
  "MOVE_TO_TARGET" => [
  [:move_to_target, 50, 0, 15, 10],
  [:pose, 1, 9, 7],
  [:pose, 1, 11, 8],
  [:pose, 1, 0, 20],
  ],
  # ---------------------------------------------------------------------------
  # Skill cast
  # ---------------------------------------------------------------------------      
  "SKILL_CAST" => [
  [:cast, 81],
  [:wait, 60],
  ],
  # ---------------------------------------------------------------------------
  # Target damage
  # ---------------------------------------------------------------------------
  "Target Damage" => [
  [:show_anim],
  [:target_damage],
  ],
  # ---------------------------------------------------------------------------
  # Use item sequence
  # ---------------------------------------------------------------------------
  "ITEM_USE" => [
  [false,false,nil],
  [:slide, -50, 0, 10, 10],
  [:wait, 30],
  [:show_anim],
  [:target_damage],
  [:wait, 60],
  ],
  # ---------------------------------------------------------------------------
  # Default reset sequence
  # ---------------------------------------------------------------------------
  "RESET" => [
  [false,false,false],
  [:visible, true],
  [:unfocus, 30],
  [:icon, "Clear"],
  [:goto_oripost, 17,10],
  [:pose,1,11,17],
  ],
  # ---------------------------------------------------------------------------
  # Default escape sequence
  # ---------------------------------------------------------------------------
  "ESCAPE" => [
  [false,false,false],
  [:slide, 150, 0, 10, 25],
  [:wait, 30],
  ],
  # ---------------------------------------------------------------------------
  # Default guard sequence
  # ---------------------------------------------------------------------------
  "GUARD" => [
  [false,false],
  [:action, "Target Damage"],
  [:wait, 45],
  ],
  
#~   "Collapse" => [
#~   [],
#~   [:cast,213],
#~   [:wait,35],
#~   [:cast,213],
#~   [:wait,25],
#~   [:cast,213],
#~   [:wait,75],
#~   [:change_target, 3],
#~   [:cast, 207],
#~   [:target_damage, 97],
#~   [:log, "<name> is self destruct"],
#~   [:script, "tsbs_perform_collapse_effect"],
#~   [:wait, 70]
#~   ],
  
  }
  
end
