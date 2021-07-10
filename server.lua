
local resname,RegisterServerCallback = GetCurrentResourceName()
RegisterServerCallback = function(name,fn)
    local hash = GetHashKey(name)
    local eventName,a = resname..":"..hash..":".."RequestCallback"
    RegisterNetEvent(eventName)
    a = AddEventHandler(eventName, function (ticketClient,...)
        local source_ = source 
        local ticketServer =  tostring(GetGameTimer())..tostring(math.random(0,65535))
        local eventWithTicket,b = eventName .. ticketClient .. ticketServer
        if source_ then eventWithTicket = eventWithTicket .. tostring(source_)..tostring(GetHashKey(GetPlayerName(source_))) 
            RegisterNetEvent(eventWithTicket)
            b = AddEventHandler(eventWithTicket, function (ticketCl,...)
                TriggerClientEvent(resname..":"..hash..":".."ResultCallback"..ticketCl,source_,fn(...),...)
                RemoveEventHandler(b)
                CreateThread(function()
                    if RegisterServerCallback then RegisterServerCallback(name,fn) end 
                end)
            end) 
            TriggerEvent(eventWithTicket,ticketClient,...)
        end 
        RemoveEventHandler(a)
    end)
end 


RegisterServerCallback("servertime",function(...)
    return os.date("%Y %m %d %H %M %S")
end )

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
    local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/log/historyprints.log','a+')
	if f then 
		f:write(strings.."\n")
		f:close()
    else 
        print(err)
    end 
    local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/log/gameplayingprints.log','a+')
	if f then 
		f:write(strings.."\n")
		f:close()
    else 
        print(err)
    end 
end)
AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/log/gameplayingprints.log','w+')
	if f then 
		f:write("\n")
		f:close()
    else 
        print(err)
    end 
end)
AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  local f,err = io.open(GetResourcePath(GetCurrentResourceName())..'/log/gameplayingprints.log','w+')
	if f then 
		f:write("\n")
		f:close()
    else 
        print(err)
    end 
end)

