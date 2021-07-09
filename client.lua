local case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
local switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,b)return a[b]end,__index=function(a,c)return c and c==b and setmetatable({},{__call=function(a,d)d()end})or function()end end})return a[b]end,__index=function(a,c)return setmetatable({},{__call=function(a,...)end})end})

RegisterCommand("print", function(source, args, raw)   
    local a = args[1]
    local player = PlayerId() 
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if a then 
        local text = a:gmatch("`(.-)`")()
        if string.find(a,"`") then 
            print(GetHashKey(text))
        else 
            switch(a)(
                case("coords")(function()
                        print(coords)
                end),
                case("id")(function()
                        print(player)
                end),
                case("pedid")(function()
                        print(ped)
                end),
                case("model")(function()
                        print(IsPedInAnyVehicle(ped) and GetEntityModel(GetVehiclePedIsIn(ped,false)) or GetEntityModel(ped))
                end),
                case("groundz")(function()
                        local found , z , offset = GetGroundZAndNormalFor_3dCoord(coords.x,coords.y,coords.z)
                        print(found and ("Found:"..found,"GroundZ:"..z,"Offset:"..offset) or "Not Found GroundZ")
                end)
                
            )
        end 
    end 
end)
