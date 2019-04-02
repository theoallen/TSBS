#==============================================================================
# TSBS Addon - Basename Changer
# Version : 1.0c
# Language : English
# Requires : Theolized SBS version 1.4
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contact: Discord @ Theo#3034
#==============================================================================
($imported ||= {})[:TSBS_BaseName] = true
#==============================================================================
# Change Logs:
# -----------------------------------------------------------------------------
# 2019.04.03 - Changed the proc variable into global to prevent save problems
# 2019.04.02 - Making sure it actually works + Eng trans. Use this instead of
#              the one that in the demo
# 2014.10.13 - Finished
#==============================================================================
%Q{

  =================
  ||Introduction ||
  -----------------
  Started from some people who bugging me, "Hey, can you make the battler image
  changes when it equipped with different weapon?". At first I refused it since
  I believe it will be troublesome. Until I found the 'best' way to overcome
  this problem
  
  Well, this script was intended to change the actor graphics when they changed
  their equip. Though, I ended up making the actor can be changed when they
  met a certain condition. That said, I named this script as 'Basename Changer'
  
  ================
  || How to use ||
  ----------------
  Simply put this script below TSBS implementation
  Edit the configuration as you fit. Instruction provided below
  
  ===================
  || Terms of use ||
  -------------------
  Credit me, TheoAllen. You are free to edit this script by your own. As long
  as you don't claim it yours. For commercial purpose, don't forget to give me
  a free copy of the game.  
  
}
#==============================================================================
# Config
#==============================================================================
module TSBS
#------------------------------------------------------------------------------
  ActorBaseName = {} # <-- Dont touch this
#------------------------------------------------------------------------------
# First you have to type the following below
#
# ActorBaseName[actor_id] = {}
# Change 'actor_id' with the actor id
# 
# Then put the condition inside the bracket {} with this format
# "Condition" => "BattlerName"
#
# E.g:
# ActorBaseName[1] = {
#   'weapon_id == 1' => 'EricSword'
# }
#
# If actor 1 is wielding a sword with the sword ID = 1, the battler name will
# be switched into "EricSword"
#
# You can also try the following:
# > shield_id
# > helmet_id
# > armor_id
# > acc_id
#------------------------------------------------------------------------------
  ActorBaseName[1] = {
    "helmet_id == 1" => "EricBuster",
  }
  
end
#==============================================================================
# End of config
#==============================================================================
#------------------------------------------------------------------------------
# Optimized eval formula ~
#------------------------------------------------------------------------------
def proc_eval(f, id)
  ($proc ||= {})[f] ||= eval("lambda { #{f} }")
  begin
    $proc[f].call
  rescue StandardError => err
    ErrorSound.play
    text = "Theolized SBS : \nBasename Changer Condition check error on Actor" +
    " ID : #{id}\n\n" + err.to_s
    msgbox text
    exit
  end
end

if $imported[:TSBS]
class Game_Actor
  
  alias tsbs_ori_base_name base_battler_name
  def base_battler_name
    return tsbs_ori_base_name unless ActorBaseName.include?(self.id)
    namecase = ActorBaseName[id]
    namecase.each do |condition, name|
      return name if proc_eval(condition, id)
    end
    return tsbs_ori_base_name
  end
  #----------------------------------------------------------------------------
  # Additional helper methods. Most likely won't works for heavily modified
  # custom equip slots
  #----------------------------------------------------------------------------
  def weapon_id(slot = 0)
    return 0 unless weapons[slot]
    return weapons[slot].id
  end
  
  def weapon_type(slot = 0)
    return 0 unless weapons[slot]
    return weapons[slot].wtype_id
  end 
  
  def shield_id
    shield = armors.find {|armor| armor && armor.etype_id == 1}
    return 0 unless shield
    return shield.id
  end
  
  def shield_type
    shield = armors.find {|armor| armor && armor.etype_id == 1}
    return 0 unless shield
    return shield.atype_id
  end
  
  def helmet_id
    helm = armors.find {|armor| armor && armor.etype_id == 2}
    return 0 unless helm
    return helm.id
  end
  
  def helmet_type
    helm = armors.find {|armor| armor && armor.etype_id == 2}
    return 0 unless helm
    return helm.atype_id
  end
  
  def armor_id
    body = armors.find {|armor| armor && armor.etype_id == 3}
    return 0 unless body
    return body.id
  end
  
  def armor_type
    body = armors.find {|armor| armor && armor.etype_id == 3}
    return 0 unless body
    return body.atype_id
  end
  
  def acc_id
    acc = armors.find {|armor| armor && armor.etype_id == 4}
    return 0 unless acc
    return acc.id
  end
  
  def acc_type
    acc = armors.find {|armor| armor && armor.etype_id == 4}
    return 0 unless acc
    return acc.atype_id
  end
  
end

end # $imported[:TSBS]
