# -*- coding:utf-8 -*-
require 'sdl'
require './fpstime'
require 'pry'

TRUE_TYPE_FONT="/usr/share/fonts/truetype/takao-mincho/TakaoExMincho.ttf"

SDL.init( SDL::INIT_VIDEO )

WIDTH=1024
HEIGHT=800

screen =SDL::Screen.open( WIDTH, HEIGHT, 16, SDL::NOFRAME )

SDL::TTF.init
font = SDL::TTF.open(TRUE_TYPE_FONT, 400, 0)

KEY2CHAR={
  SDL::Key::SPACE =>" x ",
  SDL::Key::A =>"A",
  SDL::Key::B =>"B",
  SDL::Key::C =>"C",
  SDL::Key::D =>"D",
  SDL::Key::E =>"E",
  SDL::Key::F =>"F",
  SDL::Key::G =>"G",
  SDL::Key::H =>"H",
  SDL::Key::I =>"I",
  SDL::Key::J =>"J",
  SDL::Key::K =>"K",
  SDL::Key::L =>"L",
  SDL::Key::M =>"M",
  SDL::Key::N =>"N",
  SDL::Key::O =>"O",
  SDL::Key::P =>"P",
  SDL::Key::Q =>"Q",
  SDL::Key::R =>"R",
  SDL::Key::S =>"S",
  SDL::Key::T =>"T",
  SDL::Key::U =>"U",
  SDL::Key::V =>"V",
  SDL::Key::W =>"W",
  SDL::Key::X =>"X",
  SDL::Key::Y =>"Y",
  SDL::Key::Z =>"Z",
  SDL::Key::TAB =>"TAB",
  SDL::Key::UP =>"↑",
  SDL::Key::RIGHT =>"→",
  SDL::Key::DOWN =>"↓",
  SDL::Key::LEFT =>"←",
  SDL::Key::K0 =>"0",
  SDL::Key::K1 =>"1",
  SDL::Key::K2 =>"2",
  SDL::Key::K3 =>"3",
  SDL::Key::K4 =>"4",
  SDL::Key::K5 =>"5",
  SDL::Key::K6 =>"6",
  SDL::Key::K7 =>"7",
  SDL::Key::K8 =>"8",
  SDL::Key::K9 =>"9",
  SDL::Key::RSHIFT =>"SHIFT",
  SDL::Key::LSHIFT =>"SHIFT",
  SDL::Key::RCTRL =>"CTRL",
  SDL::Key::LCTRL =>"LTRL",
  SDL::Key::RALT =>"ALT",
  SDL::Key::LALT =>"ALT",
  SDL::Key::RMETA =>"META",
  SDL::Key::LMETA =>"META",
  SDL::Key::RSUPER =>"SUP",
  SDL::Key::LSUPER =>"SUP",
  SDL::Key::RETURN =>"RET",
  SDL::Key::CAPSLOCK =>"CTRL",
  SDL::Key::DELETE =>"DEL",
  SDL::Key::BACKSPACE =>"BS",
}

timer = FPSTimerSample.new
timer.reset

loop do
 while event = SDL::Event2.poll 
    case event 
    when SDL::Event2::Quit 
      exit 
    end
  end

#  binding.pry

  SDL::Key.scan
  break if  SDL::Key.press?(SDL::Key::ESCAPE)
  press_key=""
  pushd_key = false
  KEY2CHAR.each_key do |key|
    next unless  SDL::Key.press?(key)
    if pushd_key 
      press_key =""
      break;
    end
    press_key = KEY2CHAR[key]
    pushd_key = true
  end

  dm, dm, lbutton, mbutton,rbutton = SDL::Mouse.state
  if lbutton and !(mbutton) and !(rbutton)  and (!pushd_key)
    press_key = "LEFT"
    pushd_key = true
  elsif (!lbutton) and (mbutton) and !(rbutton) and (!pushd_key)
    press_key = "Mid"
    pushd_key = true
  elsif (!lbutton) and (!mbutton) and (rbutton) and (!pushd_key)
    press_key = "RIGHT"
    pushd_key = true
  end

  screen.fillRect( 0, 0, WIDTH, HEIGHT, [ 0, 0, 0 ] )
  if press_key != ""
     w, h = font.textSize(press_key)
    set_x = WIDTH/2 - w/2
    set_y = HEIGHT/2 - h/2
    font.draw_solid_utf8(screen,press_key,set_x, set_y ,255,255,255)
  end

  timer.wait_frame do
    screen.updateRect( 0, 0, 0, 0 )
  end

end
