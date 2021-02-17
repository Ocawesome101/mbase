-- simple 2048 clone --

local readline = require("readline")

print("2048 by Ocawesome101. Copyright (c) 2020 Ocawesome101 under the GNU GPLv3.")

local board = {
  {0,0,0,0},
  {0,0,0,0},
  {0,0,0,0},
  {0,0,0,0}
}

local function pad(n)
  if n == 0 then
    return "       "
  end
  local l = (7 - #(tostring(n))) // 2
  local ret = (" "):rep(l) .. n .. (" "):rep(l)
  if #ret < 7 then ret = ret .. " " end
  return ret
end

local colors = {
  [2]   = 47,
  [4]   = 46,
  [8]   = 45,
  [16]  = 44,
  [32]  = 43,
  [64]  = 42,
  [128] = 41,
  [256] = 106,
  [512] = 105,
  [1024]= 104,
  [2048]= 103,
  [4096]= 102,
  [8192]= 101
}
local function drawTile(x, y)
  local num = board[y][x]
  local sx, sy = x * 7 - 1, y * 4 - 1
  for Y=sy, sy+3, 1 do
    io.write(string.format("\27[%d;%dH\27[30;%dm", Y, sx, colors[num] or 100))
    io.write(Y == sy+1 and pad(num) or "       ")
    io.write("\n")
  end
  io.write("\27[0m")
end

local function drawBoard()
  io.write("\27[9m")
  for y=1, 4, 1 do
    for x=1, 4, 1 do
      drawTile(x, y)
    end
  end
  io.write("\27[29m")
end

local function random2()
  local checked = {{},{},{},{}}
  while not (#checked[1]==4 and #checked[2]==4 and #checked[3]==4 and #checked[4]==4) do
    local x, y
    while true do
      x, y = math.random(1,4), math.random(1,4)
      if not checked[y][x] then checked[y][x] = true break end
    end
    if board[y][x] == 0 then
      board[y][x] = 2
      return
    end
  end
end

local function mergeUp(X)
  for row=2, 4, 1 do
    local above = board[row - 1]
    local cur = board[row]
    for i=1, 4, 1 do
      if above[i] == 0 or above[i] == cur[i] then
        if X then return true end
        above[i] = above[i] + cur[i]
        cur[i] = 0
      end
    end
  end
end

local function mergeDown(X)
  for row=3, 1, -1 do
    local below = board[row + 1]
    local cur = board[row]
    for i=1, 4, 1 do
      if below[i] == 0 or below[i] == cur[i] then
        if X then return true end
        below[i] = below[i] + cur[i]
        cur[i] = 0
      end
    end
  end
end

local function mergeLeft(X)
  for col=2, 4, 1 do
    for row=1, 4, 1 do
      local brow = board[row]
      if brow[col-1] == 0 or brow[col-1] == brow[col] then
        if X then return true end
        brow[col - 1] = brow[col - 1] + brow[col]
        brow[col] = 0
      end
    end
  end
end

local function mergeRight(X)
  for col=3, 1, -1 do
    for row=1, 4, 1 do
      local brow = board[row]
      if brow[col+1] == 0 or brow[col+1] == brow[col] then
        if X then return true end
        brow[col + 1] = brow[col + 1] + brow[col]
        brow[col] = 0
      end
    end
  end
end

local function checkMerges()
  if not (mergeUp(true) or mergeDown(true) or mergeLeft(true) or mergeRight(true)) then
    return
  end
  return true
end

io.write("\27[9m\27[2J\27[29m")
while true do
  random2()
  drawBoard()
  local esc = readline(1)
  if esc == "\27" then esc = esc .. readline(2) end
  if esc == "\27[A" then     -- up
    mergeUp()
  elseif esc == "\27[B" then -- down
    mergeDown()
  elseif esc == "\27[C" then -- right
    mergeRight()
  elseif esc == "\27[D" then -- left
    mergeLeft()
  end
  if not checkMerges() then
    error("You lose!\n", 0)
  end
end
