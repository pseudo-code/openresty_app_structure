local dkjson = require("resty.dkjson")
local util = require("service.util")
local auth_code_service = require("service.auth_code_service")

local get_ssdb_connection 		= util.get_ssdb_connection
local close_ssdb_connection		= util.close_ssdb_connection

if 'POST' ~= ngx.req.get_method() then
	ngx.exit(ngx.HTTP_NOT_FOUND)
	return
end

local result_wrong_params = '{ "err"="1000", "msg"="参数错误" }'
local result_error_internal = '{ "err"="1003", "msg"="服务器内部错误"}'

-- get post string
ngx.req.read_body(); -- read post data into mem first
local post_content = ngx.req.get_body_data()
if not post_content or post_content == ngx.null then
	ngx.say(result_wrong_params)
	return
end
-- convert post string into json
local post_obj, pos, err = dkjson.decode(post_content, 1, nil)
if not post_obj or post_obj == ngx.null
	or not post_obj.params or post_obj.params == ngx.null then
	ngx.say(result_wrong_params)
	return
end
-- check params
local userId = post_obj.params.userId
local comCode = post_obj.params.comCode
local codeType = post_obj.params.codeType
local a = type(userId) ~= 'number' or type(comCode) ~= 'string' or type(codeType) ~= 'number'
if a then
	ngx.say(result_wrong_params)	
	return
end

-- get data from ssdb
local key = comCode..":"..userId..":"..codeType
local ssdb = get_ssdb_connection()
if ssdb then
	local res, err = ssdb:get(key)
	if res and res ~= null and res[1] ~= "not_found" then
		ngx.say("from ssdb")
		ngx.say(res)
		return
	end
end

-- fallback to get data from mysql
local row = auth_code_service.get_auth_code(comCode, userId, codeType)
local result = {
	err = "0", -- success
	obj = {}
}
if row then
	for n, v in pairs(row) do
		result.obj[n] = v;
	end
end

local res_json = dkjson.encode(result)
if ssdb then
	ssdb:set(key, res_json)
	close_ssdb_connection(ssdb)
end
ngx.say("from mysql")
ngx.say(res_json)