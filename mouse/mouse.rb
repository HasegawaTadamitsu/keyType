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
@@font_small = SDL::TTF.open(TRUE_TYPE_FONT, 250, 0)
@@font_big = SDL::TTF.open(TRUE_TYPE_FONT, 450, 0)
SDL::Mouse.hide
@buffer = Array.new

SAMPLE=["ぞうさん","しまじろう","お父さん","お母さん",
     "げんこつやま",
     "一","二","三","四","五","六","七","八","九","十",
     "０","１","２","３","４","５",
     "６","７","８","９","１０"]

NUMBER=[ "0","1","2","3","4","5",
         "6","7","8","9","10"]
MSG=NUMBER
#MSG=SAMPLE

class String 
  def draw screen
  w, h = @@font_big.textSize(self)
  if w < WIDTH 
    set_x = WIDTH/2 - w/2
    set_y = HEIGHT/2 - h/2
    @@font_big.draw_solid_utf8(screen,self,set_x, set_y ,255,255,255)
    return
  end
  msg1 = self[0..self.length/2]
  msg2 = self[self.length/2..-1]
  w, h = @@font_small.textSize(msg1)
  set_x = WIDTH/2 - w/2
  set_y = HEIGHT/10*3 - h/2
  @@font_small.draw_solid_utf8(screen,msg1,set_x, set_y ,255,255,255)
  w, h = @@font_small.textSize(msg2)
  set_x = WIDTH/2 - w/2
  set_y = HEIGHT/10*6 - h/2
  @@font_small.draw_solid_utf8(screen,msg2,set_x, set_y ,255,255,255)
  end
end

class Array
  def mypush val
#  binding.pry
    if 10 < self.size
      self.shift
    end
    self.push val
  end
end


def random_msg
 return MSG[rand(MSG.length)] 
end

def mouse_button
  dm, dm, lbutton, mbutton,rbutton = SDL::Mouse.state
  if lbutton == @last_lbutton and 
     rbutton == @last_rbutton then
     return @last_message 
  end
  @last_lbutton = lbutton
  @last_rbutton = rbutton
  if (lbutton == false  and  rbutton == false) or
     (lbutton == true   and  rbutton == true ) 
    @last_message = ""
    return @last_message
  end
  if  rbutton == true
    @last_message = random_msg
    @buffer.mypush @last_message
    return @last_message
  end
  if  lbutton == true
    msg =  @buffer.pop
    if msg.nil?
      msg=""
    end
    @last_message = msg
     return @last_message
  end
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
    print_msg.draw screen
  end

  timer.wait_frame do
    screen.updateRect( 0, 0, 0, 0 )
  end

end
