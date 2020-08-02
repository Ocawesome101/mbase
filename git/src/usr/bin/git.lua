-- Basic Git client --

local shell = require("shell")
local json = require("json")
local internet = require("internet")
local log = require("logger").new()

local function query_refs(url)
  local rq = url .. "/info/refs"
  log:info("Querying refs: " .. rq)
end
