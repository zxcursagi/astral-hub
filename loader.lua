--!nocheck
-- ASTRAL HUB | Direct GitHub Launcher (zxcursagi/astral-hub)

local URL = "https://raw.githubusercontent.com/zxcursagi/astral-hub/main/AstralHub.lua"

if getgenv then
	getgenv().ASTRAL_HUB_LOADED = false
end

local function fetchModule(url)
	local ok1, res1 = pcall(function()
		return game:HttpGet(url)
	end)
	if ok1 and type(res1) == "string" and #res1 > 0 then
		return res1
	end

	local req = (type(request) == "function" and request)
		or (syn and type(syn.request) == "function" and syn.request)
		or (type(http) == "table" and type(http.request) == "function" and http.request)

	if req then
		local ok2, res2 = pcall(function()
			return req({ Url = url, Method = "GET" })
		end)
		if ok2 and type(res2) == "table" then
			local body = res2.Body or res2.body
			if type(body) == "string" and #body > 0 then
				return body
			end
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
