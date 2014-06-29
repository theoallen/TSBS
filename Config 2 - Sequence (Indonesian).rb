# =============================================================================
# Theolized Sideview Battle System (TSBS)
# Version : 1.3
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# (This script documentation is written in informal indonesian language)
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
# Credit gw, TheoAllen. Kalo semisal u bisa ngedit2 script gw trus jadi lebih
# keren, terserah. Ane bebasin. Asal ngga ngeklaim aja. Kalo semisal mau
# dipake buat komersil, jangan lupa, gw dibagi gratisannya.
# =============================================================================
module TSBS
# =============================================================================
#                             SHOW ACTOR ICON
# =============================================================================
=begin

  Bagian pertama : Show icon
  
  Disini adalah tempat mendefinisikan icon-icon yang akan ditampilkan pada saat
  dilakukan action sequence saat battle. Seperti saat actor mengayunkan senjata
  atau semacamnya. Kamu bisa menambahkan sebanyak-banyaknya. Dengan syarat
  kamu harus mengikuti format seperti ini
  
  "key" => [origin, x, y, z, start, end, dur, index, flip?]
  
  Penjelasan :
  - "key"  >> Text yang nantinya akan dipakai buat pemanggilan. Setiap sequence
              icon harus mempunyai key yang berbeda
  - origin >> Letak titik pusat dari icon. Terdapat 5 macam titik pusat. Yaitu
              [0: ditengah] [1: Kiri-atas] [2: Kanan-atas] [3: Kiri-bawah]
              [4: Kanan-bawah]
  - x      >> Jarak koordinat X dari pusat battler
  - y      >> Jarak koordinat Y dari pusat battler
  - z      >> Apakah icon akan berada pada atas battler? (true/false)
  - start  >> Sudut permulaan icon sebelum dirotasi
  - end    >> Sudut target untuk berakhirnya rotasi
  - dur    >> Durasi lamanya berputar dalam satuan frame (60 frame = 1 detik)
  - index  >> Icon index. Tulis -1 jika kamu ingin menampilkan weapon icon
              dari actor. -2 jika kamu ingin menampilkan weapon kedua. 
              
              Kamu juga bisa mengisinya dengan text/string yang nantinya bisa
              itu akan dievaluasi sebagai script. Contoh:
              "actor.weapons[0].icon_index"
  - flip?  >> Apakah iconnya akan diflip? Isi kan true / false (atau kosongin)
  
  Note :
  Untuk kegunaan icon sendiri akan terlihat pada action sequence pada bagian
  ketiga settingan ini
  
=end
# -----------------------------------------------------------------------------
# Disini kalan akan menyetting sequence icon yang akan ditampilkan
# -----------------------------------------------------------------------------
  Icons = {
  # "Key"   => [origin, x,    y,      z, start, end, dur, index],
    "Swing" => [4,     -9,  -12,   true,   -60,  70,   6,    -1],
    "Clear" => [4,      0,    0,  false,     0,   0,   0,     0],
    
  # Tambahin sendiri kalo perlu
  
  } # <-- Jangan disentuh!
# =============================================================================
#                             DEFAULT SEQUENCES
# =============================================================================
=begin

   Bagian kedua : Default sequence
  
  Disini kalian bisa mendefinisikan sequence default untuk setiap gerakan dari
  battler. Sangat berguna untuk kalian yang malas dan tidak mau memenuhi note
  di database dengan tag <sideview> beserta isi di dalamnya (kayak gw).
  
  Contoh :
  Jika kamu sudah mendefinisikan Default_Idle = "IDLE"
  Maka kamu tidak perlu menggunakan tag
  
  <sideview>
  idle : IDLE
  </sideview>
  
  Karena setiap battler yang ada akan menggunakan sequence yang sama. Dengan
  catatan, kalian harus mempunyai format gambar battler yang sama. Seperti
  battler_1 baris pertama adalah untuk idle agar tidak terjadi kejanggalan
  
  Sequence key bisa dilihat dan dibikin di bagian setelah ini

=end
# -----------------------------------------------------------------------------
# Disini kalian akan menyetting default sequence untuk setiap gerakan
# -----------------------------------------------------------------------------
  Default_Idle      = "K-idle"    # Untuk gerakan idle / standby
  Default_Critical  = "K-pinch"   # Untuk gerakan saat kritis
  Default_Evade     = "K-evade"   # Untuk gerakan saat menghindar serangan
  Default_Hurt      = "K-hurt"    # Untuk gerakan saat terkena serangan
  Default_Return    = "RESET"     # Untuk gerakan kembali ke tempat semula
  Default_Dead      = "K-dead"    # Untuk gerakan saat K.O
  Default_Victory   = "K-victory" # Untuk gerakan saat menang
  Default_Escape    = "ESCAPE"    # Untuk gerakan saat kabur
  Default_Intro     = ""          # Untuk gerakan saat masuk battle
  Default_ACounter  = "Sol_Counter" # Counter attack untuk actor
  Default_ECounter  = "ECounter"    # Counter attack untuk enemy
    
  Default_SkillSequence = ["ATTACK"] # Gerakan default untuk skill
  Default_ItemSequence  = ["K-Item"] # Gerakan default untuk menggunakan item
# =============================================================================
#                             ACTION SEQUENCES
# =============================================================================
=begin

  Bagian ketiga : Action Sequences
  
  Disini kalian bisa mendefinisikan gerakan-gerakan battler aktor maupun enemy.
  Bersiap saja karena instruksinya bakal bejibun. Sejauh ini ada 59 mode yang
  dapat kalian gunakan dalam mengatur sequence. Listnya sebagai berikut :
  
  Initial release v1.0
  
  1)  :pose             >> Untuk berganti pose
  2)  :move             >> Untuk bergerak ke koordinat tertentu
  3)  :slide            >> Untuk bergeser dari koordinat saat ini
  4)  :goto_oripost     >> Untuk kembali ke pos awal
  5)  :move_to_target   >> Untuk bergerak ke target
  6)  :script           >> Untuk menjalankan script
  7)  :wait             >> Untuk menunggu sebelum ke sequence berikutnya
  8)  :target_damage    >> Untuk deal damage pada target
  9)  :show_anim        >> Untuk show animation pada target
  10) :cast             >> Untuk show aninmation pada user 
  11) :visible          >> Untuk menentukan visibility 
  12) :afterimage       >> Untuk menghidupkan / mematikan afterimage
  13) :flip             >> Untuk membalik battler
  14) :action           >> Untuk memanggil pre-defined action sequence
  15) :projectile       >> Untuk melempar projectile
  16) :proj_setup       >> Untuk menyetting projectile
  17) :user_damage      >> Untuk damage pada user
  18) :lock_z           >> Untuk mengunci koordinat Z
  19) :icon             >> Untuk menampilkan icon
  20) :sound            >> Untuk membunyikan SE
  21) :if               >> Untuk kondisi bercabang
  22) :timed_hit        >> Untuk fungsi timed hit <not-tested>
  23) :screen           >> Untuk memodifikasi screen
  24) :add_state        >> Untuk add state pada target
  25) :rem_state        >> Untuk remove state pada target
  26) :change_target    >> Untuk mengganti target
  27) :show_pic         >> Untuk menampilkan picture <not-tested>
  28) :target_move      >> Untuk menggerakkan target ke koordinat tertentu
  29) :target_slide     >> Untuk menggeser target dari koordinatnya
  30) :target_reset     >> Untuk mereset target balik ke tempat asalnya
  31) :blend            >> Untuk mengganti tipe blending pada user
  32) :focus            >> Untuk menghilangkan battler yang bukan target
  33) :unfocus          >> Untuk menampilkan kembali semua battler
  34) :target_lock_z    >> Untuk lock koordinat z dari target
  
  Update v1.1
  35) :anim_top         >> Untuk play animasi selalu didepan layar
  36) :freeze           >> Untuk ngefreeze semua gerakan selain yg aktif
  37) :cutin_start      >> Untuk nampilin gambar cutin
  38) :cutin_fade       >> Untuk memberi efek fadein/fadeout pada cutin
  39) :cuitn_slide      >> Untuk menggeser gambar cutin
  40) :target_flip      >> Untuk ngeflip target
  41) :plane_add        >> Untuk nambahin gambar looping
  42) :plane_del        >> Untuk ngehapus gambar looping
  43) :boomerang        >> Untuk memberi efek boomerang pada proyektil
  44) :proj_afimage     >> Untuk memberi efek afterimage pada proyektil
  45) :balloon          >> Untuk menampilkan balloon icon pada battler
  
  Update v1.2
  46) :log              >> Untuk menampilkan text di battle log
  47) :log_clear        >> Untuk menghapus semua isi log window
  48) :aft_info         >> Untuk mengganti settingan afterimage
  49) :sm_move          >> Untuk bergerak ke koordinat dengan halus
  50) :sm_slide         >> Untuk bergeser beberapa pixel dengan halus
  51) :sm_target        >> Untuk bergerak ke target dengan halus
  52) :sm_return        >> Untuk kembali ke posisi dengan halus 
  
  Update v1.3
  53) :loop             >> Untuk looping sebanyak n kali
  54) :while            >> Untuk looping selama kondisi benar
  55) :collapse         >> Untuk manggil fungsi collapse
  56) :forced           >> Untuk maksa target buat ganti action key
  57) :anim_bottom      >> Untuk play animasi di bawah
  58) :case             >> Untuk kondisi bercabang lebih dari dua
  59) :instant_reset    >> Untuk mereset posisi battler secara instant
  60) :anim_follow      >> Untuk membuat animasi mengikuti battler
  61) :change_skill     >> Untuk mengganti skill agar lebih mudah digunakan
  
  ===========================================================================
  *) Membuat action sequence
  ---------------------------------------------------------------------------
  Untuk menambahkan sequence, lakukan dengan format seperti ini :
  
  "Action Key" => [
  [loop?, Afterimage?, Flip?], <-- replace dengan true / false (wajib)
  [:mode, param1, param2], <-- jangan lupa komma!
  [:mode, param1, param2],
  [:mode, param1, param2],
  ....
  
  ], <-- komma juga!
  
  Keterangan :
  > loop?
    Apakah sequence tersebut akan looping? Gunakan true untuk idle, dead, atau 
    victory pose. Tidak akan bereffect untuk yang lain seperti skill.
    
  > Afterimage?
    Apakah kamu akan menggunakan effect afterimage pada sequence tersebut?
    Jika true maka action sequence tersebut akan menggunakan afterimage.
    
  > Flip?
    Apakah battler akan diflip / dibalik ? Jika true, maka battler akan 
    dibalik. Jika false, maka battler akan menghadap sesuai gambar aslinya. 
    
    Jika nil / kosong, maka battler akan menyesuaikan nilai flip pada action 
    sequence sebelumnya. Namun hanya berlaku untuk saat menggunakan skill. 
    
    Jika nil / kosong untuk action sequence non-skill, battler akan menyesuaikan
    posisi flip seperti aslinya (untuk actor, tidak diflip. Untuk enemy,
    tergantung gimana kamu settingnya. Apa kamu pake tag <flip> ato ngga)
    
  > :mode
    Adalah mode dari list yang udah wa tulis diatas
    
  > param1, param2
    Adalah parameter dari masing-masing mode. Setiap mode mempunyai parameter
    berbeda. Jadi pastikan kamu baca dengan bener.
    
  ===========================================================================
  1)  :pose   | Mengganti pose battler
  ---------------------------------------------------------------------------
  Format --> [:pose, number, cell, wait, (icon)],
  
  Keterangan :
  Mode ini adalah untuk mengganti pose battler dari satu cell ke cell lainnya
  
  Parameter :
  number  >> Adalah untuk angka dari nama gambar. Seperti Ralph_1, Ralph_2 
  cell    >> Adalah cell frame dari spriteset. Semisal kamu menggunakan
             spriteset 3 x 4, maka dari ujung kiri atas adalah 0 - 11 sampai
             pada ujung kanan bawah. Jika kamu menggunakan spriteset yang
             sangat panjang, kamu bisa isi dengan "cell(baris, kolom)"
             (tanpa kutip)
  wait    >> Untuk menunggu sebelum menuju pose berikutnya dalam hitungan
             frame
  icon    >> Icon key yang ditulis diantara kutip ("example"). Icon disini
             adalah untuk memanggil icon sequence yang ada pada bagian pertama.
             Jika kamu tidak ingin menampilkan icon, kamu bisa mengkosongkan
             parameter ini.
             
  Contoh :
  [:pose, 1, 1, 25],
  [:pose, 1, cell(1,2), 25],
  [:pose, 1, 1, 25, "Swing"],
  
  ===========================================================================
  2)  :move   | Bergerak ke koordinat tertentu
  ---------------------------------------------------------------------------
  Format --> [:move, x, y, dur, jump],
  
  Keterangan :
  Mode ini adalah untuk menggerakkan battler dari asalnya menuju koordinat
  tertentu
  
  Parameter :
  x     >> Posisi x yang akan dituju
  y     >> Posisi y yang akan dituju
  dur   >> Durasi perjalanan dalam frame. Makin kecil makin cepet
  jump  >> Lompatan. Semakin besar semakin tinggi
  
  Contoh :
  [:move, 150, 235, 60, 20],
  
  ===========================================================================
  3)  :slide   | Bergeser beberapa pixel
  ---------------------------------------------------------------------------
  Format --> [:slide, x, y, dur, jump],
  
  Keterangan :
  Mode ini adalah untuk menggeser battler dari asalnya beberapa pixel sesuai
  dengan parameter yang akan kamu masukkan
  
  Parameter :
  x     >> Perpindahan posisi x dari koordinat asal
  y     >> Perpindahan posisi y dari koordinat asal
  dur   >> Durasi perjalanan dalam frame. Makin kecil makin cepet
  jump  >> Lompatan. Semakin besar semakin tinggi
  
  Contoh :
  [:slide, -100, 0, 25, 0],
  
  Catatan :
  Jika battler diflip, maka koordinat X juga akan ikut diflip. Dalam artian
  jika x minus yang pada arti awalnya adalah geser ke kiri, maka akan berubah
  jadi geser ke kanan
  
  ===========================================================================
  4)  :goto_oripost  | Kembali ke posisi semula
  ---------------------------------------------------------------------------
  Format --> [:goto_oripost, dur, jump],
  
  Keterangan :
  Mode ini adalah untuk mengembalikan battler kepada posisi semula
  
  Parameter
  dur   >> Durasi perjalanan dalam frame. Makin kecil makin cepet
  jump  >> Lompatan. Semakin besar semakin tinggi.
  
  Contoh :
  [:goto_oripost, 10, 20],
  
  ===========================================================================
  5)  :move_to_target  | Bergerak relatif menuju target
  ---------------------------------------------------------------------------
  Format --> [:move_to_target, x, y, dur, jump],
  
  Keterangan :
  Mode ini adalah untuk menggerakkan battler kepada target yang akan dituju
  
  Parameter
  x     >> Perbedaan posisi x dari target
  y     >> Perbedaan posisi y dari target
  dur   >> Durasi perjalanan dalam frame. Makin kecil makin cepet
  jump  >> Lompatan. Semakin besar semakin tinggi
  
  Contoh :
  [:move_to_target, 130, 0, 25, 0],
  
  Catatan 1:
  Jika battler diflip, maka koordinat X juga akan ikut diflip. Dalam artian
  jika x minus yang pada arti awalnya adalah geser ke kiri, maka akan berubah
  jadi geser ke kanan
  
  Catatan 2:
  Jika target yang dituju adalah area (target area), maka battler akan bergerak
  kearah tengah-tengah dari kumpulan target tersebut.
  
  ===========================================================================
  6)  :script   | Menjalankan script call
  ---------------------------------------------------------------------------
  Format --> [:script, "script call"]
  
  Keterangan :
  "script call" adalah Konten untuk script call. Harus dibungkus dalam kutip
  
  Contoh :
  [:script, "$game_switches[1] = true"],
  
  ===========================================================================
  7)  :wait   | Timing menunggu dalam frame
  ---------------------------------------------------------------------------
  Format --> [:wait, frame],
  
  Keterangan :
  frame adalah angka yang akan digunakan untuk lama penungguan dalam hitungan 
  frame
  
  Contoh :
  [:wait, 60],
  
  ===========================================================================
  8)  :target_damage   | Applikasi skill / item pada target
  ---------------------------------------------------------------------------
  Format --> [:target_damage, (option)],
  
  Keterangan :
  Option adalah opsi untuk memodifikasi skill / item yang akan digunakan.
  Terdapat 3 mode opsi yang bisa kamu gunakan. Kamu juga bisa mengabaikannya
  jika dirasa tidak perlu.
  
  - Formula
  Isi skill dengan formula baru. Formula harus dibungkus dalam kutip ("")
  
  - Skill ID
  Kamu bisa mengganti skill dengan cara memberikan angka bulat pada option.
  
  - Damage Rate
  Kamu bisa mengganti damage rate pada skill yang digunakan. Seperti bertambah
  dua kali lipat, atau menjadi setengahnya dengan cara menambahkan bilangan
  pecahan / float pada option
  
  Contoh :
  [:target_damage],                            << Default / apa adanya
  [:target_damage, "a.atk * 10 - b.def * 5"],  << Custom formula
  [:target_damage, 10],                        << Aplikasi skill lain
  [:target_damage, 1.5],                       << Skala damage
  
  ===========================================================================
  9)  :show_anim   | Menjalankan animasi pada target
  ---------------------------------------------------------------------------
  Format --> [:show_anim, (anim_id), (flip?), (ignore anim guard?)],
  
  Keterangan :
  - Anim_id adalah parameter opsional. Kamu bisa spesifikasi sequence tertentu
  bakal ngeplay animasi apa. Jika opsi tersebut diabaikan, maka sequence
  akan menjalankan animasi default pada skill / weapon
  
  - Flip adalah apakah animasi tersebut akan dijalankan dengan terbalik secara
  horizontal? Kamu bisa mengabaikan parameter ini jika tidak perlu
  
  - Ignore anim guard adalah untuk mengabaikan animasi anim guard pada state
  yang dimiliki oleh target
  
  Contoh :
  [:show_anim],
  [:show_anim, 25],  << menjalankan animasi ID 25
  [:show_anim,116,false,true],
  
  ===========================================================================
  10) :cast   | Menjalankan animasi pada user
  ---------------------------------------------------------------------------
  Format --> [:cast, (anim_id), (flip)],
  
  Keterangan :
  Sama seperti show anim. Namun yang menjadi target adalah user. Jika anim_id
  diabaikan (nil), animasi yang akan dijalankan adalah animasi dari skill
  yang digunakan.
  
  Flip adalah untuk membalik animasi. Jika true, maka animasi akan dibalik.
  Nilai defaultnya adalah sama dengan nilai flip pada battler
  
  Contoh :
  [:cast], << menjalankan animasi sesuai dengan
  [:cast, 25],  << menjalankan animasi ID 25
  [:cast, 25, true],  << menjalankan animasi ID 25 dengan dibalik
  
  ===========================================================================
  11) :visible   | Mengatur visibility battler
  ---------------------------------------------------------------------------
  Format --> [:visible, true/false],
  
  Keterangan :
  Parameter mode visible hanya ada satu. Dan itu cukup ditulis dengan true
  atau false. Jika true, maka battler akan terlihat. False, battler akan
  hilang
  
  Contoh :
  [:visible, true],
  [:visible, false],
  
  ===========================================================================
  12) :afterimage   | Menghidupkan effect afterimage
  ---------------------------------------------------------------------------
  Format --> [:afterimage, true/false],
  
  Keterangan :
  Parameter mode afterimage seperti halnya visible. Hanya berlaku true dan
  false
  
  Contoh :
  [:afterimage, true],
  [:afterimage, false],
  
  ===========================================================================
  13) :flip   | Membalik battler sprite secara horizontal
  ---------------------------------------------------------------------------
  Format --> [:flip, option],
  
  Keterangan :
  Ada tiga opsi untuk membalik battler sprite. Antara lain
  >> True     - Untuk dibalik
  >> False    - Untuk tidak dibalik / mengembalikan ke semula
  >> :toggle  - Untuk membalik tergantung pada keadaan sprite terakhir
  >> :ori     - Untuk mereset sesuai nilai value default flip
  
  Contoh :
  [:flip, true],
  [:flip, false],
  [:flip, :toggle],
  [:flip, :ori],
  
  ===========================================================================
  14) :action   | Memanggil pre-defined action
  ---------------------------------------------------------------------------
  Format --> [:action, "key"],
  
  Keterangan :
  Mode action adalah untuk menggabung-gabungkan action sequence. Jadi kamu
  bisa saja membuat sebuah template dan kamu hanya tinggal menggabung antara
  satu dengan yang lain.
  
  Key adalah sequence key dari action sequence yang akan digabungkan
  Contoh :
  [:action, "Magic Cast"],
  [:action, "Firebolt"],
  
  ===========================================================================
  15) :projectile   | Melempar proyektil
  ---------------------------------------------------------------------------
  Format --> [:projectile, anim_id, dur, jump, (icon), (angle_speed)],
  
  Keterangan :
  Sama seperti mode target damage. Namun dalam bentuk proyektil. Saat
  proyektil sampai ke pada target, maka target akan terkena damage.
  
  Parameternya antara lain :
  anim_id     >>  ID animasi yang akan diplay pada proyektil.
  dur         >>  Durasi perjalanan dalam frame.
  jump        >>  Lompatan.
  icon        >>  Icon ID, atau string/text yang nanti akan dievauasi sebagai
                  script
  angle_speed >>  Kecepatan berputar icon
  
  Contoh :
  [:projectile, 110, 10, 0, 0, 0],
  [:projectile, 0, 10, 20, 188, 0],
  [:projectile, 0, 10, 0, 147, 90],
  [:projectile, 0, 20, 10, "item_in_use.icon_index", 90],
  
  ===========================================================================
  16) :proj_setup   | Menyetting projectile
  ---------------------------------------------------------------------------
  Format --> [:proj_setup, start, end],
  
  Keterangan :
  Mode ini untuk menyetting proyektil. Disarankan dipanggil sebelum :projectile
  untuk menyetting proyektil yang akan dilempar
  
  Start >> asal proyektil dari user
  End   >> tujuan proyektil (target)
  
  Isi Start dan End dengan parameter berikut
  :head   >> Target pada bagian atas
  :middle >> Target pada bagian tengah
  :feet   >> Target pada bagian kaki
  
  Contoh :
  [:proj_setup, :middle, :feet],
  
  ===========================================================================
  17) :user_damage   | Damage pada user
  ---------------------------------------------------------------------------
  Format --> [:user_damage, (option)],
  
  Keterangan :
  Sama seperti target damage. Hanya saja targetnya adalah diri sendiri
  Terdapat 3 mode opsi yang bisa kamu gunakan. Kamu juga bisa mengabaikannya
  jika dirasa tidak perlu.
  
  - Formula
  Isi skill dengan formula baru. Formula harus dibungkus dalam kutip ("")
  
  - Skill ID
  Kamu bisa mengganti skill dengan cara memberikan angka bulat pada option.
  
  - Damage Rate
  Kamu bisa mengganti damage rate pada skill yang digunakan. Seperti bertambah
  dua kali lipat, atau menjadi setengahnya dengan cara menambahkan bilangan
  pecahan / float pada option
  
  Contoh :
  [:user_damage],                            << Default / apa adanya
  [:user_damage, "a.atk * 10 - b.def * 5"],  << Custom formula
  [:user_damage, 10],                        << Aplikasi skill lain
  [:user_damage, 1.5],                       << Skala damage
  
  ===========================================================================
  18) :lock_z   | Untuk mengunci koordinat Z
  ---------------------------------------------------------------------------
  Format --> [:lock_z, true/false],
  
  Keterangan :
  Koordinat Z adalah koordinat imajiner untuk menentukan sprite mana yang akan
  ditampilkan pada player lebih dekat. Di dalam TSBS, koordinat Z adalah
  dinamis. Sprite yang mempunyai koordinat Y paling besar (paling bawah)
  juga mempunyai Z paling besar. 
  
  Jika sebuah sprite bergerak keatas, maka
  koordinat Z bisa turun. Untuk mencegah hal ini, kamu bisa mengunci koordinat
  Z untuk beberapa alasan tertentu
  
  Koordinat Z juga berpengaruh pada peletakan bayangan battler. Jika kamu lock
  koordinat Z, maka bayangan battler juga tidak akan bergerak
  
  Contoh :
  [:lock_z, true],
  [:lock_z, false],
  
  ===========================================================================
  19) :icon   | Menampilkan icon
  ---------------------------------------------------------------------------
  Format --> [:icon, "key"],
  
  Keterangan :
  Sama seperti show icon pada mode :pose. Hanya saja ini independen tidak
  tergantung pada mode :pose
  
  Contoh :
  [:icon, "Swing"],
  
  ===========================================================================
  20) :sound  | Membunyikan Sound Effect
  ---------------------------------------------------------------------------
  Format --> [:sound, name, vol, pitch],
  
  Keterangan :
  Mode ini adalah untuk membunyikan sound effect
  
  Parameter :
  name  >> Nama SE yang ada pada folder Audio/SE
  vol   >> Volume SE yang akan diplay
  pitch >> Pitch SE yang akan diplay
  
  Contoh :
  [:sound, "absorb", 100, 100],
  
  ===========================================================================
  21) :if | Kondisi Bercabang
  ---------------------------------------------------------------------------
  Format --> [:if, script, act_true, (act_false)],
  
  Keterangan :
  Untuk membuat percabangan pada action sequence. Kesalahan menuliskan script
  call bakal muncul error. Jadi hati-hati ye.
  
  ---------------------
  Parameter :
  script    >> Adalah String / Text yang akan dibaca sebagai script. Kesalahan
               menulis kondisi akan berakibat script error
  Act_true  >> Adalah action key yang akan dijalankan jika true
  Act_false >> Adalah action key yang akan dijalankan jika false. Bisa 
               diabaikan jika tidak perlu
  
  Contoh :
  [:if, "$game_switches[1]", "Suppa-Attack"],
  [:if, "$game_switches[1]", "Suppa-Attack", "Normal-Attack"],
  
  --------------------
  Alternatif :
  --------------------
  Jika kamu terlalu malas untuk membikin action sequence baru hanya untuk satu
  baris sequence, kamu bisa langsung menambahkan array [] di dalam percabangan. 
  
  Contoh :
  [:if, "$game_switches[1]", [:target_damage]],
  [:if, "$game_switches[1]", [:target_damage], [:user_damage]],
  
  --------------------
  Alternatif lain :
  --------------------
  Jika kamu terlalu malas untuk membikin action sequence baru, kamu bisa
  memasukkan sequence baru ke dalam cabang tanpa harus membuat action key
  yang baru lagi.
  
  Contoh dari gerakan normal attack Soleil (sample game):
  [:if,"target.result.hit?",
    [ 
    [:target_slide, -5, 0, 3, 0],
    [:slide,-5, 0, 3, 0],
    ],
  ], 
  
  ===========================================================================
  22) :timed_hit  | Fungsi timed hit (BETA)
  ---------------------------------------------------------------------------
  Format --> [:timed_hit, count],
  
  Keterangan :
  Terinspirasi dari Eremidia Dungeon. Timed hit adalah fungsi dimana jika
  player menekan tombol pada waktu tertentu, maka player akan mendapat hadiah.
  Seperti damage skill akan meningkat dua kali.
  
  Mode ini harus diikuti dengan [:if] dimana parameternya adalah
  [:if, "@timed_hit"]
  
  Parameter :
  Count adalah timing kesempatan yang diberikan pada player untuk menekan
  tombol confirm / C dalam hitungan frame.
  
  Contoh :
  [:timed_hit, 60],
  [:wait, 60],  <-- Kamu bisa ganti ini dengan :pose
  [:if, "@timed_hit", "Suppa-Attack"],
  
  Next update :
  Mungkin bakal gw tambahin ngga cuman confirm, tapi tombol2 lain seperti
  A, B, X, Y, atau :SHIFT
  
  Catatan :
  Ini fiturnya masih BETA. Jadi jangan harap macem-macem
  
  ===========================================================================
  23) :screen | Modifikasi screen
  ---------------------------------------------------------------------------
  Format --> [:screen, submode, param1, param1],
  
  Keterangan :
  Mode ini adalah untuk memodifikasi screen. Terdapat submode pada mode screen
  ini. Yaitu antara lain :
  
  :tone       >> Seperti tint screen pada event
  :shake      >> Seperti shake screen pada event
  :flash      >> Seperti flash screen pada event
  :normalize  >> Mengembalikan tint ke semula
  
  --------------------------------------------------
  Parameter (:tone)
  Format --> [:screen, :tone, tone, dur],
  - Tone  >> Tone.new(red, green, blue, gray)
  - dur   >> Durasi pergantian tone dalam frame
  
  Contoh :
  [:screen, :tone, Tone.new(120, 90, 0, 0), 60]
  
  --------------------------------------------------
  Parameter (:shake)
  Format --> [:screen, :shake, power, speed, dur],
  - power >> Kekuatan shake atau gesernya
  - shake >> Kecepatan bergesernya
  - dur   >> Durasi berapa lama screen bakal dishake
  
  Contoh :
  [:screen, :shake, 5, 10, 60],
  
  --------------------------------------------------
  Parameter (:flash)
  Format --> [:screen, :flash, color, dur],
  - color >> Color.new(red, green, blue, alpha)
  - dur   >> Durasi berapa lama screen ngeflash
  
  Contoh :
  [:screen, :flash, Color.new(255,255,255,128), 60],
  
  --------------------------------------------------
  Parameter (:normalize)
  Format --> [:screen, :normalize, dur],
  - dur   >> Durasi untuk kembali ke tint screen semula
  
  Contoh :
  [:screen, :normalize, 60],
  
  ===========================================================================
  24) :add_state  | Untuk add state pada target
  ---------------------------------------------------------------------------
  Format --> [:add_state, state_id, (chance), (ignore_rate?)],
  
  Keterangan :
  Seperti namanya. Mode ini adalah untuk aplikasi state berdasar chance pada
  target.
  
  Parameter :
  state_id  >> ID state dalam database
  chance    >> Chance / kesempatan. Tulis antara 1-100 atau 0.0 - 1.0. Jika 
               kamu kosongkan, maka nilai defaultnya adalah 100
  ignore_rate >> Untuk mengabaikan state rate pada features. Tulis antara true
                 atau false. Jika kamu kosongkan, maka defaultnya adalah false
  
  Contoh :
  [:add_state, 10],
  [:add_state, 10, 50],
  [:add_state, 10, 50, true],
  
  ===========================================================================
  25) :rem_state  | Untuk remove state pada target
  ---------------------------------------------------------------------------
  Format --> [:rem_state, state_id, (chance)],
  
  Keterangan :
  Seperti namanya. Mode ini adalah untuk menghapus state berdasar chance pada
  target.
  
  Parameter :
  state_id  >> ID state dalam database
  chance    >> Chance / kesempatan. Tulis antara 1-100 atau 0.0 - 1.0. Jika 
               kamu kosongkan, maka nilai defaultnya adalah 100
  
  Contoh :
  [:rem_state, 10],
  [:rem_state, 10, 50],
  
  ===========================================================================
  26) :change_target  | Untuk mengganti target
  ---------------------------------------------------------------------------
  Format --> [:change_target, option],
  
  Keterangan :
  Mode ini adalah untuk mengganti target di tengah-tengah dijalankannya
  action sequence. Terdapat sembilan mode target. Antara lain :
  
  0   >> Kembali ke target semula (target dari database)
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
  11  >> Diri sendiri
  
  Contoh :
  [:change_target, 0],
  [:change_target, 1],
  [:change_target, 2],
  [:change_target, 3],
  [:change_target, 4],
  [:change_target, 5],
  [:change_target, 6],
  [:change_target, 7],
  [:change_target, 8],
  [:change_target, 9,  3],  <-- Tiga absolut random target untuk enemies
  [:change_target, 10, 3],  <-- Tiga absolut random target untuk allies
  [:change_target, 11],
  
  Catatan :
  Absolut target adalah target yang sudah pasti. Target tidak akan terkena
  damage dua kali seperti random target pada default database 
  
  ===========================================================================
  27) :show_pic
  ---------------------------------------------------------------------------
  
  Belom wa coba yang satu ini
  
  ===========================================================================
  28) :target_move  | Untuk menggerakkan target ke koordinat tertentu
  ---------------------------------------------------------------------------
  Format --> [:target_move, x, y, dur, jump],
  
  Keterangan :
  Mode ini adalah untuk menggerakkan target ke koordinat tertentu. Sama
  seperti mode move hanya saja yang jadi subject adalah target saat itu
  
  Parameter :
  x     >> Koordinat x tujuan
  y     >> Koordinat y tujuan
  dur   >> Durasi perjalanan dalam frame
  jump  >> Loncatan
  
  Contoh :
  [:target_move, 200,50,25,0],
  
  ===========================================================================
  29) :target_slide | Untuk menggeser target dari koordinatnya
  ---------------------------------------------------------------------------
  Format --> [:target_side, x, y, dur, jump],
  
  Keterangan :
  Mode ini adalah untuk menggeser target dari pusatnya. Sama seperti mode 
  slide hanya saja yang jadi subject adalah target saat itu
  
  Parameter :
  x     >> Pergeseran x dari asal
  y     >> Pergeseran y dari asal
  dur   >> Durasi perjalanan dalam frame
  jump  >> Loncatan
  
  Contoh :
  [:target_slide, 200,50,25,0],
  
  ===========================================================================
  30) :target_reset  | Untuk mengembalikan target ke posisi semula
  ---------------------------------------------------------------------------
  Format --> [:target_reset, dur, jump]
  
  Keterangan :
  Seperti goto_oripost. Hanya saja untuk target
  
  Parameter :
  dur   >> Durasi perjalanan
  jump  >> Loncatan
  
  Contoh :
  [:target_reset, 5, 0],
  
  ===========================================================================
  31) :blend  | Untuk mengganti tipe blending pada user
  ---------------------------------------------------------------------------
  Format --> [:blend, type]
  
  Keterangan :
  Untuk mengganti blending type pada battler
  
  Isi type dengan pilihan berikut
  0 >> Normal
  1 >> Addition (cerah)
  2 >> Substract (gelap)
  
  Contoh :
  [:blend, 0],
  [:blend, 1],
  [:blend, 2],
  
  ===========================================================================
  32) :focus  | Untuk menghilangkan battler yang bukan target
  ---------------------------------------------------------------------------
  Format --> [:focus, dur, (color)],
  
  Keterangan :
  Mode ini adalah untuk menghilangkan battle yang bukan target dan user. Jadi
  action terfokus pada subject dan targetnya saja.
  
  Parameter :
  dur   >> Durasi fadeout karakter dalam frame 
  color >> Color.new(red, green, blue, alpha)
  
  Contoh :
  [:focus, 30],
  [:focus, 30, Color.new(0,0,0,128)],
  
  ===========================================================================
  33) :unfocus  | Untuk menampilkan kembali semua battler
  ---------------------------------------------------------------------------
  Format --> [:unfocus, dur],
  
  Keterangan :
  Sama seperti focus. Namun mode ini adalah untuk menampilkan kembali battler
  yang disembunyikan oleh focus. Wajib untuk dipanggil setelah focus dipanggil
  
  Parameter :
  dur >> Durasi fadein dalam frame
  
  Contoh :
  [:unfocus, 30],
  
  ===========================================================================
  34) :target_lock_z  | Untuk mengunci koordinat Z target sementara
  ---------------------------------------------------------------------------
  Format --> [:target_lock_z, true/false]
  
  Keterangan :
  Seperti :lock_z namun berlaku untuk target
  
  Contoh :
  [:target_lock_z, true],
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.1
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================
  35) :anim_top   | Untuk play animasi selalu didepan layar
  ---------------------------------------------------------------------------
  Format --> [:anim_top]
  
  Keterangan :
  Flag untuk ngebuat animasi dijalankan di depan layar. Taruh tepat sebelum
  sequence :cast atau :show_anim
  
  Contoh :
  [:anim_top],
  [:cast],
  
  [:anim_top],
  [:show_anim],

  ===========================================================================
  36) :freeze | Untuk ngefreeze semua gerakan selain yg aktif
  ---------------------------------------------------------------------------
  Format --> [:freeze, true/false]
  
  Keterangan :
  Untuk menghentikan semua apdet selain gerakan battler yang sedang melakukan
  aksi. Jangan lupa untuk selalu set false sebelum sequence skill battler
  selesai dilakukan
  
  Contoh :
  [:freeze, true],
  [:freeze, false],
  
  Catatan :
  Belom gw coba diaplikasiin ke game. Kemungkinan masi ada glitchnya.
  
  ===========================================================================
  37) :cutin_start | Untuk nampilin gambar cutin
  ---------------------------------------------------------------------------
  Format --> [:cutin_start, file, x, y, opacity]
  
  Keterangan :
  Untuk menampilkan gambar cutin actor. Namun bisa jadi digunakan untuk
  menampilkan gambar. Karena awalnya ini gw bikin buat nampilin cutin, maka
  gw namain aja :cutin_start
  
  Parameter :
  file    >> Nama file gambar yang harus ada di Graphics/picture
  x       >> Posisi awal X
  y       >> Posisi awal Y
  opacity >> Opacity awal (isi antara 0 - 255)
  
  Contoh :
  [:cutin_start,"sol-cutin-nobg",100,0,0],
  
  Catatan :
  Gambar yang dapat ditampilkan hanya satu
  
  ===========================================================================
  38) :cutin_fade | Untuk memberi efek fadein/fadeout pada cutin
  ---------------------------------------------------------------------------
  Format --> [:cutin_fade, opacity, durasi]
  
  Keterangan :
  Untuk merubah opacity gambar cutin ke nilai tertentu dengan durasi tertentu
  
  Parameter :
  opacity >> Opacity target / tujuan
  durasi  >> Durasi perubahan dalam hitungan frame (60 = 1 detik)
  
  Contoh :
  [:cutin_fade, 255, 15],
  
  ===========================================================================
  39) :cutin_slide | Untuk menggeser gambar cutin
  ---------------------------------------------------------------------------
  Format --> [:cutin_slide, x, y, durasi]
  
  Keterangan :
  Untuk menggeser gambar cutin ke koordinat tertentu dengan durasi tertentu
  
  Parameter
  x       >> Nilai pergeseran X
  y       >> Nilai pergeseran Y
  durasi  >> Durasi perjalanan dalam hitungan frame (60 = 1 detik)
  
  Contoh :
  [:cutin_slide, -100, 0, 30]
  
  ===========================================================================
  40) :target_flip | Untuk ngeflip target
  ---------------------------------------------------------------------------
  Format --> [:target_flip, true/false]
  
  Keterangan :
  Untuk membalik target
  
  Contoh :
  [:target_flip, true]
  [:target_flip, false]
  
  ===========================================================================
  41) :plane_add | Untuk nambahin gambar looping
  ---------------------------------------------------------------------------
  Format --> [:plane_add, file, speed_x, speed_y, (above), (dur)]
  
  Keterangan :
  Mode ini untuk menambahkan gambar looping seperti efek kabut, parallax
  atau semacamnya.
  
  Parameter :
  file    >> Nama gambar yang harus ada di Graphics/picture
  speed_x >> Kecepatan scrolling ke arah horizontal
  speed_y >> Kecepatan scrolling ke arah vertikal
  above   >> Diatas battler? Tulis dengan true/false
  dur     >> Durasi munculnya gambar dari opacity 0 sampai 255 dalam hitungan
             frame. Bisa diabaikan, dan defaultnya adalah 2
  
  Contoh :
  [:plane_add,"cutin-bg",35,0,false,15],
  
  Catatan :
  Gambar looping yang bisa dipasang cuman satu
  
  ===========================================================================
  42) :plane_del | Untuk ngehapus gambar looping
  ---------------------------------------------------------------------------
  Format --> [:plane_del, durasi]
  
  Keterangan :
  Mode ini untuk menghapus gambar looping yang telah dipanggil oleh mode 
  :plane_add dengan durasi yang dihitung dalam hitungan frame.
  
  Contoh :
  [:plane_del, 30],
  
  ===========================================================================
  43) :boomerang | Untuk memberi efek boomerang pada proyektil
  ---------------------------------------------------------------------------
  Format --> [:boomerang]
  
  Keterangan :
  Flag untuk menandai proyektil yang akan dilempar akan kembali lagi kepada
  user / caster. Gunakan tepat sebelum mode sequence :projectile
  
  Contoh :
  [:boomerang],
  [:projectile,0,8,15,154,20],
  
  ===========================================================================
  44) :proj_afimage | Untuk memberi efek afterimage pada proyektil
  ---------------------------------------------------------------------------
  Format --> [:proj_afimage]
  
  Keterangan :
  Flag untuk menandai proyektil yang akan dilempar ditambahi efek afterimage.
  Gunakan tepat sebelum sequence mode :proyektil
  
  Contoh :
  [:proj_afimage],
  [:projectile,0,8,15,154,20],
  
  Kalau dipakai bersamaan dengan :boomerang
  [:boomerang],
  [:proj_afimage],
  [:projectile,0,8,15,154,20],
  
  ===========================================================================
  45) :balloon | Untuk menampilkan balloon icon pada battler
  ---------------------------------------------------------------------------
  Format --> [:balloon, id]
  
  Keterangan :
  Untuk menampilkan balloon pada battler
  
  Contoh :
  [:balloon, 1],
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.2
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================
  46) :log | Untuk menampilkan text di battle log
  ---------------------------------------------------------------------------
  Format --> [:log, "Text"]
  
  Keterangan :
  Untuk menampilkan teks para battle log. Gunakan "<name>" untuk menampilkan
  nama subject battler.
  
  Contoh :
  [:log, "<name> disappears!"],
  
  ===========================================================================
  47) :log_clear | Untuk menghapus semua isi log window
  ---------------------------------------------------------------------------
  Format --> [:log_clear]
  
  Keterangan :
  Untuk menghapus semua isi battle log.
  
  Contoh :
  [:log_clear],
  
  ===========================================================================
  48) :aft_info | Untuk mengganti settingan afterimage
  ---------------------------------------------------------------------------
  Format --> [:aft_info, rate, fade_speed]
  
  Keterangan :
  Untuk mengubah settingan afterimage. Seperti nambahin makin pekat atau 
  mengurangi kecepatan fade.
  
  Parameter :
  - rate  >> Kepekatan afterimage. Makin kecil makin pekat. Minimal 1. Nilai
             defaultnya adalah 3
  - fade  >> Kecepatan fadeout afterimage. Makin kecil makin lama menghilang.
             Nilai defaultnya adalah 20
  
  Contoh :
  [:aft_info, 1,10],
  
  ===========================================================================
  49) :sm_move | Untuk bergerak ke koordinat dengan halus
  ---------------------------------------------------------------------------
  Format --> [:sm_move, x, y, dur, (rev)]
  
  Keterangan :
  Sama seperti mode :move. Namun yang ini disertai dengan percepatan. Jadi
  terlihat lebih smooth.
  
  Parameter :
  x   >> Target koordinat X
  y   >> Target koordinat Y
  dur >> Durasi perjalanan
  rev >> Reverse. Jika kamu tulis true, maka sprite akan berjalan dari
         kecepatan maksimum. Jika false, kecepatan dimulai dari 0. Defaultnya
         adalah true
         
  Contoh :
  [:sm_move, 100,50,45],
  [:sm_move, 100,50,45,true],
  
  ===========================================================================
  50) :sm_slide | Untuk bergeser beberapa pixel dengan halus
  ---------------------------------------------------------------------------
  Format --> [:sm_slide, x, y, dur, (rev)]
  
  Keterangan :
  Sama seperti mode :slide. Namun yang ini disertai dengan percepatan. Jadi
  terlihat lebih smooth.
  
  Parameter :
  x   >> Jarak perpindahan X dari koordinat asli
  y   >> Jarak perpindahan Y dari koordinat asli
  dur >> Durasi perjalanan
  rev >> Reverse. Jika kamu tulis true, maka sprite akan berjalan dari
         kecepatan maksimum. Jika false, kecepatan dimulai dari 0. Defaultnya
         adalah true
         
  Contoh :
  [:sm_slide, 100,50,45],
  [:sm_slide, 100,50,45,true],
  
  ===========================================================================
  51) :sm_target | Untuk bergerak ke target dengan halus
  ---------------------------------------------------------------------------
  Format --> [:sm_target, x, y, dur, (rev)]
  
  Keterangan :
  Sama seperti mode :move_to_target. Namun yang ini disertai dengan percepatan. 
  Jadi terlihat lebih smooth.
  
  Parameter :
  x   >> Jarak X dari koordinat target
  y   >> Jarak Y dari koordinat target
  dur >> Durasi perjalanan
  rev >> Reverse. Jika kamu tulis true, maka sprite akan berjalan dari
         kecepatan maksimum. Jika false, kecepatan dimulai dari 0. Defaultnya
         adalah true
  
  Contoh :
  [:sm_target, 100,0,45],
  [:sm_target, 100,0,45,true],
  
  Catatan 1:
  Jika battler diflip, maka koordinat X juga akan ikut diflip. Dalam artian
  jika x minus yang pada arti awalnya adalah geser ke kiri, maka akan berubah
  jadi geser ke kanan
  
  Catatan 2:
  Jika target yang dituju adalah area (target area), maka battler akan bergerak
  kearah tengah-tengah dari kumpulan target tersebut.
  
  ===========================================================================
  52) :sm_return | Untuk kembali ke posisi dengan halus 
  ---------------------------------------------------------------------------
  Format --> [:sm_return, dur, (rev)]
  
  Keterangan :
  Sama seperti mode :goto_oripost. Namun yang ini disertai dengan percepatan. 
  Jadi terlihat lebih smooth.
  
  Parameter :
  dur >> Durasi perjalanan
  rev >> Reverse. Jika kamu tulis true, maka sprite akan berjalan dari
         kecepatan maksimum. Jika false, kecepatan dimulai dari 0. Defaultnya
         adalah true
  
  Contoh :
  [:sm_return,30],
  [:sm_return,30,true],       

  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              UPDATE VERSION 1.3
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ===========================================================================  
  53) :loop | Untuk looping sebanyak n kali
  ---------------------------------------------------------------------------
  Format --> [:loop, times, "Key"]
  
  Keterangan :
  Sama seperti [:action,]. Hanya saja, daripada kamu kopi beberapa kali, kamu
  bisa menyederhanakannya hanya dengan satu baris
  
  Parameter :
  times >> Berapa kali action key akan dipanggil
  Key   >> Action Key yang akan dipanggil
  
  Contoh :
  [:loop, 3, "CastPose"],
  
  ===========================================================================  
  54) :while | Untuk looping selama kondisi benar
  ---------------------------------------------------------------------------
  Format --> [:while, cond, "key"]
  
  Keterangan :
  Mirip seperti looping. Hanya saja, action key ini akan diulang terus selama
  kondisi yang kamu inputkan itu benar.
  
  Parameter :
  cond >> Kondisi salah benar dalam script
  key  >> Action key yang akan dipanggil
  
  Contoh :
  [:while, "$game_variables[1] < 10", "Sol_Strike"]
  
  ===========================================================================  
  55) :collapse | Untuk manggil fungsi collapse
  ---------------------------------------------------------------------------
  Format --> [:collapse]
  
  Keterangan :
  Untuk manggil fungsi play collapse secara manual jika kamu mau gunain custom
  collapse effect. Dan gunakan HANYA untuk custom collapse effect
  
  Contoh :
  [:collapse],
  
  ===========================================================================  
  56) :forced | Untuk maksa target buat ganti action key
  ---------------------------------------------------------------------------
  Format --> [:forced, "key"]
  
  Keterangan :
  Maksa target untuk mengganti action key yang sedang dipakai. Jika digunakan
  dalam counterattack, bisa untuk dijadikan efek knockback yang mematahkan
  serangan kombo hit lebih dari 1 kali
  
  Parameter :
  key >> Action Key yang akan dipaksa pakai oleh target
  
  Contoh :
  [:forced, "KnockBack"],
  
  ===========================================================================  
  57) :anim_bottom | Untuk play animasi di bawah
  ---------------------------------------------------------------------------
  Format --> [:anim_bottom]
  
  Keterangan :
  Seperti [:anim_top]. Hanya saja ini membuat animasi berikutnya akan diplay
  di belakang battler. Panggil tepat sebelum [:cast] ato [:show_anim]
  
  Contoh :
  [:anim_bottom],
  [:cast, 69],
  
  [:anim_bottom],
  [:show_anim],
  
  ===========================================================================  
  58) :case | Untuk kondisi bercabang lebih dari dua
  ---------------------------------------------------------------------------
  Format --> [:case, hash]
  
  Keterangan :
  Digunakan untuk membuat kondisi bercabang yang lebih dari dua kondisi. Lebih
  mudah dilakukan daripada harus menggunakan nested if ([:if] di dalam [:if])
  
  --------------------------
  Parameter :
  Hash >> List kondisi percabangan dengan format yang harus ditulis seperti
          berikut ini :
          {
            "Kondisi 1" => "ActionKey1",
            "Kondisi 2" => "ActionKey2",
            "Kondisi 3" => "ActionKey3",
          }
          
  Contoh :
  [:case, {
    "$game_variables[1] == 1" => "Action1",
    "$game_variables[1] == 2" => "Action2",
    "$game_variables[1] == 3" => "Action3",
    "$game_variables[1] == 4" => "Action4",
    "$game_variables[1] == 5" => "Action5",
  }],
  
  --------------------------
  Alternatif :
  --------------------------
  Jika kamu terlalu malas untuk membikin action sequence baru hanya untuk satu
  baris sequence, kamu bisa langsung menambahkan array [] di dalamnya. 
  
  Contoh : 
  [:case,{
    "state?(44)" => [:add_state,45],
    "state?(43)" => [:add_state,44],
    "state?(42)" => [:add_state,43],
    "true" => [:add_state,42],
  }],
  
  --------------------------
  Alternatif lain :
  --------------------------
  Jika kamu terlalu malas untuk membikin action sequence baru, kamu bisa
  memasukkan sequence baru ke dalam cabang tanpa harus membuat action key
  yang baru lagi.
  
  Contoh : 
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
  
  Catatan :
  - Jika ada lebih kondisi yang benar, maka kondisi yang letaknya paling atas
    sendiri yang akan digunakan.
  
  ===========================================================================  
  59) :instant_reset | Untuk mereset posisi battler secara instant
  ---------------------------------------------------------------------------
  Format --> [:instant_reset]
  
  Keterangan :
  Untuk mereset posisi battler secara instant / langsung.
  
  Contoh :
  [:instant_reset],
  
  ===========================================================================  
  60) :anim_follow | Untuk membuat animasi mengikuti battler
  ---------------------------------------------------------------------------
  Format --> [:anim_follow]
  
  Keterangan :
  Seperti [:anim_top]. Hanya saja ini membuat animasi berikutnya akan diplay
  mengikuti gerak battler. Panggil tepat sebelum [:cast] ato [:show_anim]
  
  Contoh :
  [:anim_follow],
  [:cast, 69],
  
  [:anim_follow],
  [:show_anim],
  
  Tidak bekerja pada animasi yang posisinya pada screen

  ===========================================================================  
  61) :change_skill | Untuk mengganti skill agar lebih mudah digunakan
  ---------------------------------------------------------------------------
  Format --> [:change_skill, id]
  
  Keterangan :
  Sama seperti [:target_damage, id]. Hanya saja, ini mengganti skill yang
  "dibawa" oleh battler sepenuhnya. Dalam artian kamu bisa menskala atau
  mengganti formula pada skill lain.
  
  Contoh :
  [:change_skill, 13],
  [:target_damage, 0.5],
  [:wait, 15],
  [:target_damage, 1.5],
  [:wait, 15],
  [:target_damage, 0.5],
  [:wait, 15],
  
  Kamu bisa menskala damage output yang dikeluarkan dari skill id 13 yang tidak
  bisa dilakukan oleh [:target_damage] biasa.
  
=end
# =============================================================================
  AnimLoop = { # <-- Jangan disentuh!
# -----------------------------------------------------------------------------
# Disini kalian dapat mendefinisikan sendiri action sequence kamu
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
