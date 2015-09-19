local null 			= ngx.null
local log 			= ngx.log
local STDERR 		= ngx.STDERR
local quote_sql_str = ngx.quote_sql_str
local say 			= ngx.say
local error 		= error
local type			= type
local pairs			= pairs

local util = require("service.util")
local get_mysql_connenction 	= util.get_mysql_connenction
local close_mysql_connection 	= util.close_mysql_connection
local get_ssdb_connection 		= util.get_ssdb_connection
local close_ssdb_connection		= util.close_ssdb_connection

module(...)

function get_auth_code( com_code, user_id, code_type )

	if not com_code or not user_id or not code_type then
		return nil
	end

	local mysql_db = get_mysql_connenction()
	if not mysql_db then
		return nil
	end

	-- select string, 使用quote_sql_str防止sql注入
	local query_sql =
		"SELECT id, com_code, beaconUUID, user_id, auth_code, code_type"..
		" FROM acs_auth_code"..
		" WHERE com_code="..quote_sql_str(com_code)..
		" AND user_id="..quote_sql_str(user_id)..
		" AND code_type="..quote_sql_str(code_type)

	local res, err, errno, sqlstate = mysql_db:query(query_sql)
	if mysql_db then close_mysql_connection(mysql_db) end
	
	if err then
		log(STDERR, "query error: ", err, ", errno: ", errno, ", sqlstate: ", sqlstate)
		return nil
	end

	if not res or not res[1] then
		return nil
	end
	
	return res[1]
end
