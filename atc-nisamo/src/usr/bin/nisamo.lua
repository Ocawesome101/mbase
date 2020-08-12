-- Nisamo copyright (C) 2020 AshleighTheCutie. All rights reserved.
-- Sound effects added by Ocawesome101.
local component = require("component")
local computer = require("computer")
local event = require("event")
local patternEntry = "1234321234"
local difficulty = "4"

local function init()
  component.switch_board.setActive(1,true)
  component.switch_board.setActive(2,true)
  component.switch_board.setActive(3,true)
  component.switch_board.setActive(4,true)
  os.sleep(1)
  component.switch_board.setActive(1,false)
  component.switch_board.setActive(2,false)
  component.switch_board.setActive(3,false)
  component.switch_board.setActive(4,false)
  os.sleep(1)
  component.light_board.setColor(1,0xFF0000)
  component.light_board.setColor(2,0x00FF00)
  component.light_board.setColor(3,0x0000FF)
  component.light_board.setColor(4,0xFFFF00)
  component.light_board.setActive(1,true)
  component.light_board.setActive(2,true)
  component.light_board.setActive(3,true)
  component.light_board.setActive(4,true)
  os.sleep(1)
  component.light_board.setActive(1,false)
  component.light_board.setActive(2,false)
  component.light_board.setActive(3,false)
  component.light_board.setActive(4,false)
end

local tones = {
  330,
  377,
  440,
  164
}

local function readSwitchBoard()
  local type,address,number,value = event.pull("switch_flipped")
  os.sleep(0.5)
  computer.beep(tones[number])
  component.switch_board.setActive(number,false)
  event.pull("switch_flipped")
  return number
end

local function setLightPattern(pattern)
  for i = string.len(pattern),1,-1 do
    local number = tonumber(string.sub(pattern, i, i))
    component.light_board.setActive(number, true)
    computer.beep(tones[number])
    os.sleep(1)
    component.light_board.setActive(number, false)
    os.sleep(0.5)
  end
end

local function mkrand(n) -- contributed by Ocawesome101
  local r = ""
  for i=1,n,1 do
    r = r .. math.floor(math.random(1, 4) // 1)
  end
  return r
end

local function comparatorInputGen(pattern)
  local r = ""
  for i=tonumber(string.len(pattern)), 1, -1 do
    --print("Hello from before the math operation!")
    r = r .. math.floor(readSwitchBoard())
    --print("Hello from after the math operation!")
  end
  return r
end

local function comparator(generatedPattern,userPattern)
  if generatedPattern == userPattern then do
    difficulty = difficulty + 1
    print("Correct!")
  end
  else
    component.light_board.setColor(1,0xff0000)
    component.light_board.setColor(2,0xff0000)
    component.light_board.setColor(3,0xff0000)
    component.light_board.setColor(4,0xff0000)
    component.light_board.setActive(1,true)
    component.light_board.setActive(2,true)
    component.light_board.setActive(3,true)
    component.light_board.setActive(4,true)
    os.sleep(0.5)
    component.light_board.setActive(1,false)
    component.light_board.setActive(2,false)
    component.light_board.setActive(3,false)
    component.light_board.setActive(4,false)
    os.sleep(0.5)
    component.light_board.setActive(1,true)
    component.light_board.setActive(2,true)
    component.light_board.setActive(3,true)
    component.light_board.setActive(4,true)
    os.sleep(0.5)
    component.light_board.setActive(1,false)
    component.light_board.setActive(2,false)
    component.light_board.setActive(3,false)
    component.light_board.setActive(4,false)
    os.exit()
  end
end

init()
while true do
  local pattern1 = mkrand(tonumber(difficulty))
  --print(pattern1)
  setLightPattern(string.reverse(pattern1))
  --print(comparatorInputGen(pattern1))
  comparator(pattern1,comparatorInputGen(pattern1))
end
