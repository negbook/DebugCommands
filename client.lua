local case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
local switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,b)return a[b]end,__index=function(a,c)return c and c==b and setmetatable({},{__call=function(a,d)d()end})or function()end end})return a[b]end,__index=function(a,c)return setmetatable({},{__call=function(a,...)end})end})

RegisterCommand("print", function(source, args, raw)   
    local a = args[1]
    local player = PlayerId() 
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local pedmodel = GetEntityModel(ped)
    local vehentity = IsPedInAnyVehicle(ped) and GetVehiclePedIsIn(ped,false)
    local vehmodel = IsPedInAnyVehicle(ped) and GetEntityModel(vehentity)
    
    if a then 
        local text = a:gmatch("`(.-)`")()
        if string.find(a,"`") then 
            local hash = GetHashKey(text)
            print(hash,string.format("0x%x", hash))
        elseif string.find(a,"0x")==1 then 
            print(tonumber(a))
        elseif tostring(tonumber(a)) == tostring(a) then 
            print(a,string.format("0x%x", tonumber(a)))
        else 
            switch(a)(
                case("coords")(function()
                        print('coords',coords)
                end),
                case("zone")(function()
                        print('zone',GetNameOfZone(coords))
                end),
                case("street")(function()
                    local street1,street2 = GetStreetNameAtCoord(coords.x,coords.y,coords.z)
                        print('Street',street1,street2,'Names',GetStreetNameFromHashKey(street1),GetStreetNameFromHashKey(street2))
                end),
                case("x")(function()
                        print(coords.x)
                end),
                case("y")(function()
                        print(coords.y)
                end),
                case("z")(function()
                        print(coords.z)
                end),
                case("id")(function()
                        print('player',player)
                end),
                case("ped")(function()
                        print("Entity",ped,"Model",pedmodel)
                        local front = GetOffsetFromEntityInWorldCoords(ped,0.0,5.0,0.0)
                        local found,closestped = GetClosestPed(front.x,front.y,front.z ,10.0 ,true ,false ,true ,true ,-1 )
                        if found then 
                            print("Closest",closestped,"Model",GetEntityModel(closestped))
                        end 
                end),
                case("model")(function()  
                    if IsPedInAnyVehicle(ped) then 
                        print('Model',vehmodel)
                    else 
                        print('Model',pedmodel)
                    end
                end),
                case("health")(function()
                    if IsPedInAnyVehicle(ped) then  
                        print("Body",GetVehicleBodyHealth(vehentity),"Engine",GetVehicleEngineHealth(vehentity),"PetrolTank",GetVehiclePetrolTankHealth(vehentity),"Wheel",GetVehicleWheelHealth(vehentity))
                    else  
                        print("Health",GetEntityHealth(ped),"/","MaxHealth",GetEntityMaxHealth(ped),"MaxHealth",GetPedMaxHealth(ped),"RechargeLimit",GetPlayerHealthRechargeLimit(player))
                    end 
                end),
                case("veh")(function()  
                    if IsPedInAnyVehicle(ped) then 
                        print("Entity",vehentity,"Model",vehmodel,"Names",GetDisplayNameFromVehicleModel(vehmodel),GetStreetNameFromHashKey(vehmodel),GetLabelText(vehmodel))
                    else 
                        local front = GetOffsetFromEntityInWorldCoords(ped,0.0,5.0,0.0)
                        if IsAnyVehicleNearPoint(front,10.0) then 
                            local closestveh = GetClosestVehicle(front, 10.0, 0, 231807) --cars
                            if closestveh == 0 then closestveh = GetClosestVehicle(front, 10.0, 0, 391551)  end --airs 
                            if closestveh~=0  then 
                                local closestvehmodel = GetEntityModel(closestveh)
                                print("Closest",closestveh,"Model",closestvehmodel,"Names",GetDisplayNameFromVehicleModel(closestvehmodel),GetStreetNameFromHashKey(closestvehmodel),GetLabelText(closestvehmodel)) 
                            end
                        end 
                    end
                end),
                case("modelscale")(function()
                    if IsPedInAnyVehicle(ped) then  
                        print(GetModelDimensions(vehmodel))
                    else  
                        print(GetModelDimensions(pedmodel))
                    end 
                end),
                case("name")(function()
                    if IsPedInAnyVehicle(ped) then  
                        print("Names",GetDisplayNameFromVehicleModel(vehmodel),GetStreetNameFromHashKey(vehmodel),GetLabelText(vehmodel)) -- why GetMakeNameFromVehicleModel crashs?
                    else 
                        print("Name",GetPlayerName(player))
                    end 
                end),
                case("groundz")(function()
                        local found , z , offset = GetGroundZAndNormalFor_3dCoord(coords.x,coords.y,coords.z)
                        if found then 
                            print("Found",found,"GroundZ",z,"Offset",offset)
                        else 
                            print("Not Found GroundZ")
                        end 
                end)
                
            )
        end 
    end 
end)
