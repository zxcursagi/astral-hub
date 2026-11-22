--!nocheck
local ok, source = pcall(function()
	return game:HttpGet("https://raw.githubusercontent.com/zxcursagi/astral-hub/main/AstralHub.lua")
end)

if ok and type(source) == "string" and #source > 0 then
	local fn = loadstring(source)
	if type(fn) == "function" then
		pcall(fn)
	end
end
