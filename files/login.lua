module("luci.controller.wifidog-auth.login", package.seeall)

function index()
	entry({"auth","login"}, call("logging")).dependent=false
end

function logging()
	--http://192.168.1.163/cgi-bin/luci/auth/login/?gw_address=192.168.1.163&gw_port=2060&gw_id=080027F9A44E&mac=50:e5:49:5e:8d:2d&url=http%3A//www.baidu.com/
	local gw_address = luci.http.formvalue("gw_address")
	local gw_port = luci.http.formvalue("gw_port")
	local url = luci.http.formvalue("url")
	if gw_address and gw_port then
		local token = ""
		local strlist = {"a","b","c","d","e","f","1","2","3","4","5","6","7","8","9","0"}
		local strlens=table.getn(strlist)
		math.randomseed(os.time())
		for i=1,32,1 do
			token = token..strlist[math.random(strlens)]
		end
		local dir = io.open("/tmp/wifidog-auth")
		if not dir then
			os.execute("mkdir -p /tmp/wifidog-auth")
		end
		local ft = io.open("/tmp/wifidog-auth/"..token, "w+")
		ft:write(os.time())
		ft:close()
		--luci.http.write("http://"..gw_address..":"..gw_port.."/wifidog/auth?token="..token)
		--luci.http.write("time:"..os.time());
		luci.http.redirect("http://"..gw_address..":"..gw_port.."/wifidog/auth?token="..token)
	end
end
