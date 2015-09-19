-- ljson可以对lua对象进行json序列化，但是无法发序列化，是一个轻量的工具
-- cjson可以同时序列化和反序列化
local ljson = require("resty.ljson");
local encode_json = ljson.encode

local result = {
	code = 0,
	msg = "request handle successed"
}

ngx.say(encode_json(result))