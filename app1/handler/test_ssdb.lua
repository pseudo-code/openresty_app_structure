local ssdb = require "resty.ssdb"
local db = ssdb:new()
db:set_timeout(1000) -- 1 sec

local ssdb_conf = globe_config.ssdb;
local ok, err = db:connect(ssdb_conf.host, ssdb_conf.port)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

ok, err = db:set("dog", "an animal")
if not ok then
    ngx.say("failed to set dog: ", err)
    return
end

ngx.say("set result: ", ok)

local res, err = db:get("dog")
if not res then
    ngx.say("failed to get dog: ", err)
    return
end

if res == ngx.null then
    ngx.say("dog not found.")
    return
end

ngx.say("dog: ", res)

-- db:init_pipeline()
-- db:set("cat", "Marry")
-- db:set("horse", "Bob")
-- db:get("cat")
-- db:get("horse")
-- local results, err = db:commit_pipeline()
-- if not results then
--     ngx.say("failed to commit the pipelined requests: ", err)
--     return
-- end

-- for i, res in ipairs(results) do
--     if type(res) == "table" then
--         if not res[1] then
--             ngx.say("failed to run command ", i, ": ", res[2])
--         else
--             -- process the table value
--         end
--     else
--         -- process the scalar value
--     end
-- end

-- put it into the connection pool of size 100,
-- with 10s idle time
local ok, err = db:set_keepalive(10000, 100)
if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end

-- or just close the connection right away:
-- local ok, err = db:close()
-- if not ok then
--     ngx.say("failed to close: ", err)
--     return
-- end