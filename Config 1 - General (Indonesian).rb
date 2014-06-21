# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.3
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# (This script documentation is written in informal indonesian language)
# -----------------------------------------------------------------------------
# Requires : Theo - Basic Modules v1.5
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
# -----------------------------------------------------------------------------
# Known Incompatibility :
# >> YEA - Lunatic Object
# >> Maybe, most of battle related scripts (ATB, or such...)
# >> MOG Breathing script
# =============================================================================
# Terms of Use :
# -----------------------------------------------------------------------------
# Credit gw, TheoAllen. Kalo semisal u bisa ngedit2 script gw trus jadi lebih
# keren, terserah. Ane bebasin. Asal ngga ngeklaim aja. Kalo semisal mau
# dipake buat komersil, jangan lupa, gw dibagi gratisannya.
# =============================================================================
($imported ||= {})[:TSBS] = true  # <-- jangan sentuh line ini ~
# =============================================================================
module TSBS 
  # ===========================================================================
    MaxRow = 4
    MaxCol = 3
  # ---------------------------------------------------------------------------
  # Setting ukuran rasio spriteset.
  # MaxRow untuk baris kebawah
  # MaxCol untuk kolom ke samping.
  #
  # Jika kamu memasukkkan MaxRow = 4 dan MaxCol = 3, maka rasio gambar untuk
  # spriteset harus 3 x 4
  # ===========================================================================
    
  # ===========================================================================
    Enemy_Default_Flip = false
  # ---------------------------------------------------------------------------
  # Terkadang dalam spriteset gambar enemy menghadap ke kiri. Namun disaat
  # battle, diharuskan hadap ke kanan. Untuk mencegah glitch, kamu bisa set
  # settingan ini ke true
  # ===========================================================================
  
  # ===========================================================================
    ActorPos = [ # <--- jangan disentuh
  # ---------------------------------------------------------------------------
      [430,240],
      [450,260],
      [470,280],
      
    # Tambahin disini
    ] # <-- jangan disentuh
  # ---------------------------------------------------------------------------
  # Posisi actor dalam koordinat [x,y]. Jumlah maksimal battle member juga
  # bergantung sebanyak berapa kamu memasukkan settingan koordinat.
  # ===========================================================================
  
  # ===========================================================================
    TotalHit_Vocab = "Total Hit"            # Info 1
    TotalHit_Color = Color.new(230,230,50)  # Info 2
    TotalHit_Pos   = [[51,10],[110,66]]     # Info 3
    TotalHit_Size  = 24                     # Info 4
  # ---------------------------------------------------------------------------
  # Setting untuk penampilan hit counter. Untuk keterangan bisa dilihat
  # dibawah sini :
  #
  # Info 1 :
  # Untuk menampilkan teks total hit
  # 
  # Info 2 :
  # Untuk warna tulisan teks tersebut. Harus diisi dengan format 
  # Color.new(red, green, blue). Masing-masing nilai maksimalnya adalah 255
  #
  # Info 3 : 
  # Untuk koordinat penempatan teks total hit. Formatnya sebagai berikut ini :
  # Data koordinat disimpan dalam 'nested array' dimana [x,y] pertama adalah
  # untuk koordinat teks. Dan [x,y] kedua untuk koordinat angka
  # ===========================================================================
  
  # ===========================================================================
    TotalDamage_Vocab = "Damage"                # Info 1
    TotalDamage_Color = Color.new(255,150,150)  # Info 2
    TotalDamage_Pos   = [[75,10],[110,90]]      # Info 3
    TotalDamage_Size  = 24                      # Info 4
  # ---------------------------------------------------------------------------
  # Setting untuk penampilan damage counter. Untuk keterangan bisa dilihat
  # dibawah sini :
  #
  # Info 1 :
  # Untuk menampilkan teks total damage
  # 
  # Info 2 :
  # Untuk warna tulisan teks tersebut. Harus diisi dengan format 
  # Color.new(red, green, blue). Masing-masing nilai maksimalnya adalah 255
  #
  # Info 3 : 
  # Untuk koordinat penempatan teks total damage. Format sebagai berikut ini :
  # Data koordinat disimpan dalam 'nested array' dimana [x,y] pertama adalah
  # untuk koordinat teks. Dan [x,y] kedua untuk koordinat angka.
  #
  # Well, intinya sama kek atasnya :v
  # ===========================================================================
  
  # ===========================================================================
    Critical_Rate = 0.25
  # ---------------------------------------------------------------------------
  # Rate untuk menentukan actor dalam kritikal. Jika kamu tulis 0.25 maka
  # artinya jika HP dibawah 25% maka actor akan dianggap dalam keadaan kritis
  # ===========================================================================
  
  # ===========================================================================
    Focus_BGColor = Color.new(0,0,0,170)
  # ---------------------------------------------------------------------------
  # Default color untuk mode :focus pada action sequence. Isikan dengan format
  # --> Color.new(red, green, blue, alpha)
  # Dimana masing-masing nilai maksimalnya adalah 255
  # ===========================================================================
  
  # ===========================================================================
    UseShadow = true
  # ---------------------------------------------------------------------------
  # Gunain shadow buat battler?
  # ===========================================================================
  
  # ---------------------------------------------------------------------------
  #                           Setting Lain-lain
  # ---------------------------------------------------------------------------
  
  # ===========================================================================
    CounterAttack = "Counterattacked!"
  # ---------------------------------------------------------------------------
  # Teks yang ditampilkan pada battler jika melakukan counter attack
  # ===========================================================================
  
  # ===========================================================================
    Magic_Reflect = "Magic Reflected!"
  # ---------------------------------------------------------------------------
  # Teks yang ditampilkan pada battler jika melakukan magic reflection
  # ===========================================================================
  
  # ===========================================================================
    Reflect_Guard = 121
  # ---------------------------------------------------------------------------
  # Animasi default yang akan dijalankan pada target jika target ngereflek 
  # magic
  # ===========================================================================
  
  # ===========================================================================
    TimedHit_Anim = 206
  # ---------------------------------------------------------------------------
  # Animation ID untuk timed-hit
  # ===========================================================================
end
# =============================================================================
#
#                             END OF GENERAL CONFIG
#
# =============================================================================
