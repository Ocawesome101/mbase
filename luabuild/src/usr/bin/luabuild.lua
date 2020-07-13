#!/usr/bin/env lua5.3
-- lua-based build system. attempts to be compatible with standard lua. --

local _PROC_VERSION = "0.2.0"

local cmdline = {...}

local args, opts = {}, {}

local hasarg = {
  target = true,
  T = true
}

for i=1, #cmdline, 1 do
  local cl = cmdline[i]
  if cl:sub(1,2) == "--" then
    if hasarg[cl:sub(3)] then
      opts[cl:sub(3)] = cl[i+1]
      i = i + 2 -- will this work? i have no clue
    end
    opts[cl:sub(3)] = true
  elseif cl:sub(1,1) == "-" then
    if hasarg[cl:sub(2,2)] then
      opts[cl:sub(2,2)] = cl:sub(3)
    else
      for char in cl:sub(2):gmatch(".") do
        opts[char] = true
      end
    end
  else
    args[#args + 1] = cl
  end
end

local tgt = args[1] or opts.T or "default"
local show = opts.X or opts.showexec

local status = {
  ok = "\27[92m OK \27[39m",
  info = "\27[94mINFO\27[39m",
  fail = "\27[91mFAIL\27[39m"
}

local function log(s, ...)
  print(table.concat({string.format("[ %s ]", status[s] or s), ...}, " "))
end

local preproc = os.getenv("LB_PROC") or "preproc"

log("info", "Running LuaBuild", _PROC_VERSION)

local bf = io.open("build.lbf", "r")

if not bf then
  log("fail", "build.lbf not found!")
  os.exit(-1)
end

log("info", "Loading build.lbf")

local data = bf:read("a")
bf:close()

local function ls(d)
  d=d or "."
  local c = io.popen("ls --color=no " .. d)
  local files = {}
  local data = c:read("*a")
  c:close()
  for file in data:gmatch("[^%s\r\n]+") do
    files[#files + 1] = file
  end
  table.sort(files)
  return setmetatable(files, {
    __call = function()
      local k, v = next(files)
      if k and v then
        files[k] = nil
        return v
      end
    end
  })
end

if _OSVERSION then -- override ls() for OpenComputers, since Monolith's io.popen is broken :/
  ls = function(d)
    return require("filesystem").list(d)
  end
end

local env = setmetatable({}, {__index = _G})
env._PROC_VERSION = _PROC_VERSION
env._LB_PROC = preproc
env.log = log
env.ls = ls

local ok, err = load("return " .. data, "=build.lbf", "t", env)

if not ok then
  log("fail", "Failed loading build.lbf:", err)
  os.exit(-1)
end

local stat, targets = pcall(ok)

if not stat and targets then
  log("fail", "Failed loading build.lbf:", targets)
  os.exit(-1)
end

log("ok", "Loaded build.lbf")

local function exec(t)
  log("info", "Execute target: '" .. t .. "'")

  if not targets[t] then
    log("fail", "Specified target '" .. t .. "' not present!")
    os.exit(-1)
  end

  local deps = targets[t].deps or targets[t].dependencies or {}
  log("info", "Execute dependency targets for '" .. t .. "'")
  for i=1, #deps, 1 do
    exec(deps[i])
  end
  log("ok", "Executed", #deps, " dependency targets")

  local status, returned = pcall(targets[t].exec)
  
  if not status and returned then
    log("fail", "Failed executing target '" .. t .. "':", returned)
    os.exit(-1)
  end
  
  log("ok", "Executed target '" .. t .. "'")
end

exec(tgt)

os.exit()
