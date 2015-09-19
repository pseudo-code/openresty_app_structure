package.path = package.path .. ";D:\\workspace\\luaapp1\\lib\\?.lua"
a = {}
a.a = 123
a.b = '123'
a.c = "adfjl"
for k, v in pairs(a) do
	print("k: "..k..", v: "..v)
end