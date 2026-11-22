--!nocheck
-- ASTRAL HUB | GitHub Loader
-- Замени OWNER и REPO на свои данные репозитория

local GITHUB_OWNER = "zxcursagi"
local GITHUB_REPO = "astral-hub"
local GITHUB_BRANCH = "main"
local SCRIPT_PATH = "AstralHub.lua"

local RAW_URL = string.format(
	"https://raw.githubusercontent.com/%s/%s/%s/%s",
	GITHUB_OWNER,
	GITHUB_REPO,
	GITHUB_BRANCH,
	SCRIPT_PATH
)

local function notifyFallback(title, text)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 4
		})
	end)
end

if getgenv and getgenv().ASTRAL_HUB_LOADED then
	notifyFallback("ASTRAL HUB", "Скрипт уже загружен в этом сеансе.")
	return
end

local function fetchSource(url, attempts)
	attempts = attempts or 3
	for i = 1, attempts do
		local ok, body = pcall(function()
			return game:HttpGet(url .. "?v=" .. tostring(os.clock()))
		end)
		if ok and type(body) == "string" and #body > 100 then
			return true, body
		end
		if i < attempts then
			task.wait(0.6)
		end
	end
	return false, "Не удалось скачать скрипт с GitHub"
end

notifyFallback("ASTRAL HUB", "Загрузка модуля с GitHub...")

local okFetch, sourceOrErr = fetchSource(RAW_URL, 3)
if not okFetch then
	notifyFallback("ASTRAL HUB • Error", tostring(sourceOrErr))
	warn("[ASTRAL HUB Loader] " .. tostring(sourceOrErr))
	return
end

local fn, compileErr = loadstring(sourceOrErr)
if type(fn) ~= "function" then
	notifyFallback("ASTRAL HUB • Syntax Error", "Ошибка компиляции модуля")
	warn("[ASTRAL HUB Loader] Compile error: " .. tostring(compileErr))
	return
end

if getgenv then
	getgenv().ASTRAL_HUB_LOADED = true
end

local okRun, runErr = pcall(fn)
if not okRun then
	if getgenv then
		getgenv().ASTRAL_HUB_LOADED = false
	end
	notifyFallback("ASTRAL HUB • Runtime Error", "Ошибка при запуске модуля")
	warn("[ASTRAL HUB Loader] Runtime error: " .. tostring(runErr))
end
