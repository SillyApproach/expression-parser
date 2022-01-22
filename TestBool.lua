dofile("./BooleanModel/Scanner.lua")
dofile("./BooleanModel/Parser.lua")

local args = {...}
local str = args[1] or ""
local s = Scanner.new(str)
local p = Parser.new(str, s:scan())
local expression = p:parse()

print(expression:interprete())
