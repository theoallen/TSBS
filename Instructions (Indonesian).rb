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
# >> Maybe, most of battle related scripts
# >> MOG Breathing script & HUD
# =============================================================================
# Terms of Use :
# -----------------------------------------------------------------------------
# Credit gw, TheoAllen. Kalo semisal u bisa ngedit2 script gw trus jadi lebih
# keren, terserah. Ane bebasin. Asal ngga ngeklaim aja. Kalo semisal mau
# dipake buat komersil, jangan lupa, gw dibagi gratisannya.
# =============================================================================
=begin  
  --------------------------------------------------------------------------
  * ) Pembukaan :
  --------------------------------------------------------------------------
  Oke, script ini sebenernya cuman script personal yang aslinya mo gw pake
  sendiri. Sebagai bentuk salah satu protes gw kenapa gw sering ngga sreg
  ama kebanyakan battle engine. Entah itu ribet, susah, atawa yang lainnya.
  
  Harapan gw, dengan gw bikin script ini, gw bisa bikin Sideview Battle tanpa
  harus belajar script orang lain. Dimana gw hafal semua fungsinya dan segala
  potensinya.
  
  Lalu, bagaimana dengan ente sebagai pengguna script? Well, gw terima kalau
  ada kritik saran atau laporan bug. Tapi ane ngga jamin juga bakal full
  support. Apalagi soal kompatibilitas ama script yang gw sendiri ngga minat
  atau ngga ada rencana make (kecuali script wa sendiri).
  
  Sorry, gw akuin TSBS emang sepertinya ribet banget untuk dipake. Dan disamping
  wa juga ga bisa nerangin semuanya secara jelas m(_ _)m
  
  --------------------------------------------------------------------------
  * ) Cara menginstall :
  --------------------------------------------------------------------------
  Pastikan kamu mengambil list script ini kedalam scriptmu :
  >> Config 1 - General
  >> Config 2 - Sequence
  >> Implementation
  
  Letakkan script Theo - Basic Modules v1.5 (disarankan versi 1.5)
  paling atas. Jika kamu make YEA - Core atawa Battle Engine, taruh diatas
  script ini. Dan ingat, script ini juga harus diletakkan diatas "Main".
  
  --------------------------------------------------------------------------
  * ) Aturan spriteset :
  --------------------------------------------------------------------------
  File untuk spriteset harus berada pada Graphics/Battler. Nama file harus
  dimulai dari nama battler (actor / enemy) diakhir dengan angka. Misalnya
  - Eric_1.png
  - Eric_2.png
  - Slime_1.png
  - Slime_2.png
  
  Kegunaan angkanya ntar kamu bisa baca di keterangan action sequences
  
  ==========================================================================
                                NOTETAGGING!
  ==========================================================================
  * ) ACTOR NOTETAGS :
  --------------------------------------------------------------------------
  Gunakan tag seperti ini dalam actor notetag :
  
  <sideview>
  idle : key
  critical : key
  hurt : key
  dead : key
  intro : key
  victory : key
  escape : key
  return : key
  counter : key
  <sideview>
  
  Replace 'key' dengan hash key yang ada di settingan Action Sequences. Dimana
  masing-masing keterangannya adalah sebagai berikut
  
  idle      >> Sequence untuk gerakan idle / standby
  critical  >> Sequence jika HP dibawah 25 persen
  hurt      >> Sequence jika terkena serangan
  dead      >> Sequence jika K.O
  intro     >> Sequence untuk masuk arena battle
  victory   >> Sequence untuk pose menang
  escape    >> Sequence untuk gerakan kabur
  return    >> Sequence untuk gerakan kembali ke posisi semula
  counter   >> Sequence untuk counter attack
  
  Misalnya :
  
  <sideview>
  idle : Eric_IDLE
  critical : Eric_CRI
  </sideview>
  
  --------------------------------------------------------------------------
  NOTETAG UNTUK NORMAL ATTACK DAN GUARD
  <attack: id>
  <guard: id>
  
  Secara default, id skill untuk attack dan guard secara beturut-turut adalah
  1 dan 2. Namun kamu bisa spesifikasikan default normal attack untuk tiap
  actor berbeda-beda dengan cara menggunakan tag diatas. Contoh :
  
  <attack: 3>
  <guard: 4>
  
  --------------------------------------------------------------------------
  NOTETAG UNTUK COUNTER SKILL
  <counter skill: id>
  
  Secara default, counter skill pada actor adalah 1. Kamu bisa menggantinya
  dengan menulikan notetag misalnya
  
  <counter skill: 4>
  
  --------------------------------------------------------------------------
  NOTETAG UNTUK ANIMASI MAGIC REFLECTION
  <reflect anim: id>
  
  Animasi yang akan diplay kepada korban serangan magic saat korban melakukan
  magic reflection
  
  ==========================================================================
  * ) ENEMY NOTETAGS :
  --------------------------------------------------------------------------
  Gunakan tag seperti ini pada enemy jika kamu ingin enemy juga menggunakan
  spriteset seperti actor
  
  <sideview: nama battler>
  idle : key
  critical : key
  hurt : key
  evade : key
  return : key
  counter : key
  collapse : key
  </sideview>
  
  Keterangan sama seperti actor notetag. Hanya saja, kamu harus replace 
  'nama battler' dengan nama file yang akan kamu gunakan sebagai battler enemy
  tersebut. 
  
  Khusus untuk collapse, adalah sequence yang dijalankan untuk menggantikan
  collaspe effect default
  
  Semisal kamu menuliskannya :
  <sideview: slime>

  Maka, enemy tersebut akan menggunakan file gambar yang bernama slime_1,
  slime_2, slime_3 dst ...
  
  --------------------------------------------------------------------------
  NOTETAG UNTUK COUNTER SKILL
  <counter skill: id>
  
  Secara default, counter skill pada actor adalah 1. Kamu bisa menggantinya
  dengan menulikan notetag misalnya
  
  --------------------------------------------------------------------------
  NOTETAG UNTUK ANIMASI MAGIC REFLECTION
  <reflect anim: id>
  
  Animasi yang akan diplay kepada korban serangan magic saat korban melakukan
  magic reflection.
  
  --------------------------------------------------------------------------
  NOTETAG UNTUK BATTLER FLIP
  
  Untuk beberapa enemy yang gambar aslinya menghadap kiri contohnya adalah
  untuk sprite kaduki, dan kamu ingin ngebuatnya hadap kanan, gunakan tag 
  <flip>
  
  ==========================================================================
  * ) WEAPON AND CLASS NOTETAGS :
  --------------------------------------------------------------------------
  NOTETAG UNTUK NORMAL ATTACK DAN GUARD
  <attack: id>
  <guard: id>
  
  Secara default, id skill untuk attack dan guard secara beturut-turut adalah
  1 dan 2. Namun kamu bisa spesifikasikan default normal attack untuk tiap
  actor jika actor tersebut membawa senjata berbeda-beda atau berganti class
  satu ke class yang lain
  
  <attack: 3>
  <guard: 4>
  
  Catatan :
  1. Prioritas attack ID class lebih tinggi dari actor.
  2. Prioritas attack ID weapon lebih tinggi dari class. Dengan kata lain,
     attack ID yang diutamakan adalah yang berasal dari weapon jika keduanya
     sama-sama memiliki notetag
  3. Jika karater dual wield, attack ID yang diutamakan adalah yang berasal
     dari senjata pertama (jika ada usul yang lebih baik, silahkan)
  
  ==========================================================================
  * ) SKILL / ITEM NOTETAGS :
  --------------------------------------------------------------------------
  Gunakan tag seperti ini untuk mendefinisikan gerakan sebelum sequence
  dieksekusi
  \preparation : key_sequence
  
  Gunakan tag seperti ini untuk mendefinisikan key action sequencenya
  \sequence : key_sequence
  
  Gunakan tag seperti ini untuk mendefinisikan gerakan kembalinya
  \return : key_sequence
  
  Jika kamu menggunakan \sequence sebanyak tiga kali dengan key yang berbeda,
  maka skill tersebut akan memilih secara acak key yang kamu masukkan. Dengan
  kata lain, skill tersebut akan mempunyai tiga variasi sequence
  
  --------------------------------------------------------------------------
  AREA DAMAGE :
  
  Jika kamu menggunakan multitarget seperti 3 random enemies atau semacamnya,
  maka sequence akan dilakukan sebanyak target tersebut. Jika kamu tidak mau
  hal seperti itu, cukup tambahkan tag 
  <area>
  
  --------------------------------------------------------------------------
  NO RETURN SEQUENCE :
  
  Setiap skill / item setelah selesai dipakai, actor otomatis akan kembali
  ke tempat semula. Namun pada beberapa kasus, actor tidak perlu ada gerakan
  kembali (seperti jika skill dilakukan ditempat). Maka kamu bisa masukkan tag 
  <no return>
  
  --------------------------------------------------------------------------
  ABSOLUTE TARGETING :
  
  Terkadang, random target bisa menyerang musuh yang sama. Jika kamu ingin
  semisal 2 random target bener-bener random (dalam artian tidak ada dua target
  yang sama), maka kamu bisa menggunakan tag
  <abs-target>
  
  --------------------------------------------------------------------------
  MAGIC REFLECT ANIMATION :
  
  Secara default, animasi yang akan diplay pada caster magic adalah sama 
  seperti animasi skill itu sendiri. Jika kamu ingin mengubahnya, kamu bisa
  menggunakan tag
  <reflect anim: id>
  
  id adalah id animasi dari database
  
  --------------------------------------------------------------------------
  PARALLEL ANIMATION :
  
  Secara default, animasi yang akan diplay pada target saat target punya 
  animation guard, maka animasi regular akan diganti dengan anim guard. Agar
  keduanya bisa diplay bersamaan, gunakan tag
  <parallel anim>
  
  --------------------------------------------------------------------------
  RANDOM TARGET REFLECTION :
  
  Secara default, target magic reflection itu adalah penyerang dari magic
  tersebut. Jika kamu ingin target magic reflection itu diacak, gunakan tag
  seperti ini
  <random reflect>
  
  ----------------------------------------------------------------------------
  Dan beberapa notetag spesial untuk skill :
  <always hit>    || Untuk skill yang selalu kena
  <anti counter>  || Untuk skill yang anti counter attack
  <anti reflect>  || Untuk skill yang anti magic reflection
  
  <ignore skill guard>  || Aplikasi skill mengabaikan skill guard dari state
  <ignore anim guard>   || Play animasi skill mengabaikan anim guard dari state
  
  ==========================================================================
  * ) STATE NOTETAGS :
  --------------------------------------------------------------------------
  State Tone & Color :
  -------------------------
  Kamu bisa menyetting perubahan warna pada gambar sprite battler jika battler
  terkena state tertentu. Caranya dengan menggunakan notetag seperti ini.
  
  <tone: red,green,blue,gray>
  <color: red,green,blue,alpha>
  Ganti RGB dengan angka yang kamu mau. Kamu bisa menggunakan operand minus
  untuk mengurangi kadar warna tertentu. Komposisi tone sama seperti tint
  screen pada event.
  
  Note :
  Tone seperti tint screen pada event. Namun hanya berlaku untuk warna sprite
  
  Contoh :
  <tone: -30,80,-60,0>
  <color: 0,0,0,150>
  
  -----------------------------------------------------------------------------
  Animation Guard :
  -------------------------
  Kamu bisa spesifikasi animasi yang akan diplay jika battler mempunyai state
  tertentu. Semisal battler sedang dalam perlindungan barrier, maka saat
  battler terkena serangan, akan ngeplay animasi barrier atau semacemnya. 
  
  Kamu bisa menggunakan tag :
  <anim guard: n>
  Dimana n adalah ID animasi yang akan menggantikan animasi serangan musuh
  
  -----------------------------------------------------------------------------
  Skill Guard :
  -------------------------
  Skill guard adalah skill balasan yang akan diaplikasikan ke musuh yang
  menyerang target. Semisal, jika musuh menyerang actor yang mempunyai state
  "poison skin", maka penyerang akan terkena state racun atau semacemnya.
  
  Kamu bisa menggunakan tag :
  <skill guard: n>
  Dimana n adalah ID skill di skill database
  
  -----------------------------------------------------------------------------
  State Opacity :
  -------------------------
  Dengan adanya state tertentu battler bisa saja menjadi transparan. Sebagai
  contoh, state hide membuat opacity sprite battler menjadi 128.
  
  Kamu bisa menggunakan tag :
  <opacity: n>
  Dimana n adalah angka opacitynya. Maksimal 255
  
  -----------------------------------------------------------------------------
  State Sequence :
  -------------------------
  Jika battler terkena state tertentu, kamu bisa menentukan sequence apaan
  yang akan dijalankan pada battler. Semisal terkena stun, battler akan berpose
  pusing atau sebagainya. Kamu bisa menggunakan tag
  
  \sequence : key_sequence
  
  keterangannya sama kek yang udah wa tulis di Skill
  
  -----------------------------------------------------------------------------
  State Animation :
  -------------------------
  Jika battler terkena state tertentu dan kamu ingin play animas secara looping
  pada battler tersebut, kamu bisa menuliskan tag
  <animation: id>
  
  id adalah id animasi yang ada di database > animation
  
  -----------------------------------------------------------------------------
  State Transformation :
  -------------------------
  Request dari seseorang, dan sekaligus emang ide gwa buat nambahin fitur ini.
  Jika battler terkena state tertentu, maka grafisnya akan diubah sesuai dengan
  statenya. Misalnya transformasi jadi bentuk lain. Gunakan notetag seperti ini.
  <transform: name>
  
  Dimana "name" adalam nama tambahan untuk nama battler. Semisal 
  - Nama battler kamu adalah Eric_1,
  - Kamu memberikan notetag pada state <transform: -dragon>
  - Maka, nama file gambar baru yang harus ada adalah Eric-dragon_1
  
  Catatan :
  Jika ada state transformasi lebih dari satu, nama yang akan digunakan adalah
  dari state yang memiliki prioritas lebih tinggi di database
  
  -----------------------------------------------------------------------------
  State basic actions modification :
  -------------------------
  Sama seperti notetag normal attack dan guard. State juga bisa mengubah basic
  action dari actor. Prioritas state adalah lebih tinggi dibanding class
  ataupun weapon. 
  
  Gunakan tag seperti berikut :
  <attack: id>
  <guard: id>
  
=end
