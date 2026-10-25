local channel, url, agent, pattern = ...

local loaded, https = pcall(require, "https")
if not loaded then return end

local ok, code, body = pcall(https.request, url, { headers = { ["User-Agent"] = agent } })
channel:push(ok and code == 200 and body:match(pattern) or false)
