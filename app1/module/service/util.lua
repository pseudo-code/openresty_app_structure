local null 			= ngx.null
local log 			= ngx.log
local STDERR 		= ngx.STDERR
local quote_sql_str = ngx.quote_sql_str
local say 			= ngx.say
local error 		= error

local globe_config 	= globe_config
local mysql 		= require("resty.mysql")
local ssdb			= require("resty.ssdb")

module(...)

function get_mysql_connenction( config )
	local mysql_config = config or globe_config.mysql

	local db = mysql:new()
	db:set_timeout(1000)

	local res, err, errno, sqlstate = db:connect(mysql_config)
	if not res then  
		log(STDERR, "connect to mysql error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
		db:close()
		return nil
	end
	return db
end

function close_mysql_connection( db )
	if not db then
		error("mysql_connection can not be null")
	end
	-- put it into the connection pool of size 100,
	-- with 10s idle time
	local ok, err = db:set_keepalive(10000, 100)
	if not ok then
	    log(STDERR, "cache mysql connection error: ", err)
	    db:close()
	end
end

function get_ssdb_connection( config )
	local ssdb_config = config or globe_config.ssdb

	local db = ssdb:new()
	db:set_timeout(1000) -- 1 sec

	local ok, err = db:connect(ssdb_config.host, ssdb_config.port)
	if not ok then
	    log(STDERR, "connect to ssdb error: ", err)
	    return nil
	end
	return db
end

function close_ssdb_connection( db )
	if not db then
		error("mysql_connection can not be null")
	end
	-- put it into the connection pool of size 100,
	-- with 10s idle time
	local ok, err = db:set_keepalive(10000, 100)
	if not ok then
	    log(STDERR, "cache ssdb connection error: ", err)
	    db:close()
	end
end