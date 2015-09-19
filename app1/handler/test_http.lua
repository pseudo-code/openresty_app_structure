-- 如果访问的路径使用的是域名，如：www.baidu.com，则需要在nginx.conf中配置resolver

local http = require "resty.http"
local hc = http:new()

local ok, code, headers, status, body  = hc:request {
    url = "http://www.baidu.com/",
    --- proxy = "http://127.0.0.1:8888",
    --- timeout = 3000,
    --- scheme = 'https',
    method = "GET", -- POST or GET
    -- add post content-type and cookie
    -- headers = { Cookie = {"ABCDEFG"}, ["Content-Type"] = "application/x-www-form-urlencoded" },
    -- body = "uid=1234567890",
}

ngx.say(ok)
ngx.say(code)
ngx.say(body)