# -*- coding:utf-8 -*-
require 'sdl'
require '../fpstime'
require 'pry'

TRUE_TYPE_FONT="/usr/share/fonts/truetype/takao-mincho/TakaoExMincho.ttf"

SDL.init( SDL::INIT_VIDEO )

WIDTH=1024
HEIGHT=800

screen =SDL::Screen.open( WIDTH, HEIGHT, 16, SDL::NOFRAME )

SDL::TTF.init
@font_small = SDL::TTF.open(TRUE_TYPE_FONT, 250, 0)
@font_big = SDL::TTF.open(TRUE_TYPE_FONT, 450, 0)
SDL::Mouse.hide

SAMPLE=["ぞうさん","しまじろう","お父さん","お母さん",
     "げんこつやま",
     "一","二","三","四","五","六","七","八","九","十",
     "０","１","２","３","４","５",
     "６","７","８","９","１０"]

NUMBER=[ "０","１","２","３","４","５",
         "６","７","８","９","１０"]

PLUS=1.upto 9 do |x|
      1.upto 9 do |y|
    "#{x} + #{y}"
    end
end

MSG=NUMBER

def random_msg
 return MSG[rand(MSG.length)] 
end

def mouse_button
  dm, dm, lbutton, mbutton,rbutton = SDL::Mouse.state
#  binding.pry
  if lbutton == @last_lbutton and 
     mbutton == @last_mbutton and 
     rbutton == @last_rbutton then
     return @last_message 
  end
  @last_lbutton = lbutton
  @last_mbutton = mbutton
  @last_rbutton = rbutton
  if lbutton == false  and  mbutton == false and rbutton == false
    @last_message = ""
  else
    @last_message = random_msg
  end
  return @last_message
end

def draw_textbox screen,msg
  w, h = @font_big.textSize(msg)
  if w < WIDTH 
    set_x = WIDTH/2 - w/2
    set_y = HEIGHT/2 - h/2
    @font_big.draw_solid_utf8(screen,msg,set_x, set_y ,255,255,255)
    return
  end
  msg1 = msg[0..msg.length/2]
  msg2 = msg[msg.length/2..-1]
  w, h = @font_small.textSize(msg1)
  set_x = WIDTH/2 - w/2
  set_y = HEIGHT/10*3 - h/2
  @font_small.draw_solid_utf8(screen,msg1,set_x, set_y ,255,255,255)
  w, h = @font_small.textSize(msg2)
  set_x = WIDTH/2 - w/2
  set_y = HEIGHT/10*6 - h/2
  @font_small.draw_solid_utf8(screen,msg2,set_x, set_y ,255,255,255)
end

@last_lbutton=false
@last_mbutton=false
@last_rbutton=false
@last_message="" 

timer = FPSTimerSample.new
timer.reset

loop do
 while event = SDL::Event2.poll 
    case event 
    when SDL::Event2::Quit 
      exit 
    end
  end

  SDL::Key.scan
  break if  SDL::Key.press?(SDL::Key::ESCAPE)

  print_msg = mouse_button

  screen.fillRect( 0, 0, WIDTH, HEIGHT, [ 0, 0, 0 ] )

  if print_msg !=""
    draw_textbox(screen,print_msg)
  end

  timer.wait_frame do
    screen.updateRect( 0, 0, 0, 0 )
  end

end
