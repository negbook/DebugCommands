RegisterServerEvent("writelog:"..GetCurrentResourceName())
AddEventHandler("writelog:"..GetCurrentResourceName(), function (strings)
    local source = source
	local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/log/lastprint.log','w+')
	if f then 
		f:write(strings.."\n")
		f:close()
    else 
        print(err)
    end 
    local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/log/prints.log','a+')
	if f then 
		f:write(strings.."\n")
		f:close()
    else 
        print(err)
    end 
end)
