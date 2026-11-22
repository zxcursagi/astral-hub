--!nocheck
-- ASTRAL HUB | Direct GitHub Launcher (zxcursagi/astral-hub)

local URL = "https://raw.githubusercontent.com/zxcursagi/astral-hub/main/AstralHub.lua"

if getgenv then
	getgenv().ASTRAL_HUB_LOADED = false
end

local function fetchModule(url)
	local methods = {
		function()
			return type(game.HttpGet) == "function" and game:HttpGet(url, true)
		end,
		function()
			return type(game.HttpGet) == "function" and game:HttpGet(url)
		end,
		function()
			return type(http_get) == "function" and http_get(url)
		end,
		function()
			if syn and type(syn.request) == "function" then
				local res = syn.request({ Url = url, Method = "GET" })
				return res and res.Body
			end
		end,
		function()
			local req = (type(request) == "function" and request)
				or (type(http) == "table" and type(http.request) == "function" and http.request)
			if req then
				local res = req({ Url = url, Method = "GET" })
				return res and (res.Body or res.body)
			end
		end
	}

	for _, fn in ipairs(methods) do
		local ok, data = pcall(fn)
		if ok and type(data) == "string" and #data > 0 then
			return data
		end
	end

	return nil
end

local source = fetchModule(URL)
if not source then
	warn("[ASTRAL HUB] Failed to fetch module from GitHub.")
	return
end

local exec, loadErr = loadstring(source)
if type(exec) ~= "function" then
	warn("[ASTRAL HUB] Loadstring error: " .. tostring(loadErr))
	return
end

if getgenv then
	getgenv().ASTRAL_HUB_LOADED = true
end

local ran, runErr = pcall(exec)
if not ran then
	if getgenv then
		getgenv().ASTRAL_HUB_LOADED = false
	end
	warn("[ASTRAL HUB] Execution error: " .. tostring(runErr))
end
