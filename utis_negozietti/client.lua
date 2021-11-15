ESX = nil
Citizen.CreateThread(function()
     while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
     end
end)

-----------------

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(6)
	SetTextScale(0.40,0.40)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end

if Config.Text3D then
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
 
        local player = PlayerPedId()
        local coordinateplayer  = GetEntityCoords(player)
        if GetDistanceBetweenCoords(coordinateplayer, Config.Posizione.x, Config.Posizione.y, Config.Posizione.z, true) < 2.0 then
            if Config.HelpNotification then
                ESX.ShowHelpNotification(Config.TestoHelpNotifica)
            end
            DrawText3Ds(Config.Posizione.x, Config.Posizione.y, Config.Posizione.z, Config.Text3Dscritta)
           if IsControlJustReleased(1, 51) then
                ApriNegozietto()
           end
        end
    end
end)
end

if Config.Marker then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(4)
     
            local player = PlayerPedId()
            local coordinateplayer  = GetEntityCoords(player)
            if GetDistanceBetweenCoords(coordinateplayer, Config.Posizione.x, Config.Posizione.y, Config.Posizione.z, true) < 2.0 then
                if Config.HelpNotification then
                ESX.ShowHelpNotification(Config.TestoHelpNotifica)
                end
                DrawMarker(Config.MarkerTipe, Config.Posizione.x, Config.Posizione.y, Config.Posizione.z, 0, 0, 0, 0.0, 0, 0, 0.65, 0.65, 0.65, Config.ColoreMarker.r, Config.ColoreMarker.g, Config.ColoreMarker.b, 150, 1, 0, 0, 1)
              if IsControlJustReleased(1, 51) then
                    ApriNegozietto()
               end
            end
        end
    end)
end
function ApriNegozietto()
	ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dio_boss', {
			title    = Config.TitleMenu,
			align    = Config.AlingMenu,
			elements = {
    {label = "Compra Radio: "..Config.PrezzoRadio.."$", value = Config.ItemRadio},
	{label = "Compra Telefono: "..Config.PrezzoTelefono.."$", value = Config.ItemTelefono},
    {label = "Compra Gopro: "..Config.PrezzoGopro.."$", value = Config.ItemGopro},
    {label = "Compra Sim: "..Config.PrezzoSim.."$", value = Config.ItemSim}
	}}, function(data, menu)

    if data.current.value == Config.ItemRadio then
        print("utis compra la radio")
        paga(Config.PrezzoRadio, Config.ItemRadio)

    elseif data.current.value == Config.ItemTelefono then
        print("utis compra telefono")
        paga(Config.PrezzoTelefono, Config.ItemTelefono)

    elseif data.current.value == Config.ItemGopro then
        print("utis compra gopro")
        paga(Config.PrezzoGopro, Config.ItemGopro)

    elseif data.current.value == Config.ItemSim then
        print("utis compra sim")
        paga(Config.PrezzoSim, Config.ItemSim)
    
    end 

	end, function(data, menu)
		menu.close()
	   end)
end

function paga(prezzo, item)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dio_boss', {
        title    = Config.TitleMenu,
        align    = Config.AlingMenu,
        elements = {
{label = "Paga in contanti: "..prezzo.."$", value = 'contanti'},
{label = "Paga con la carta di credito: "..prezzo.."$", value = 'banca'}
}}, function(data, menu)

if data.current.value == 'contanti' then
    print("utis compra contanti")
    TriggerServerEvent('utis:compracontanti', prezzo, item)
    TriggerEvent('utis:animazione')

elseif data.current.value == 'banca' then
    print("utis compra banca")
    TriggerServerEvent('utis:comprabanca', prezzo, item)
    TriggerEvent('utis:animazione')

end 

end, function(data, menu)
    ApriNegozietto()
    end)
end

RegisterNetEvent('utis:animazione')
AddEventHandler('utis:animazione', function()
  local dict = 'anim@heists@keycard@'
  local anim = 'exit'
  local ped = GetPlayerPed(-1)
  local time = 1500
  RequestAnimDict(dict)
  
  while not HasAnimDictLoaded(dict) do
      Citizen.Wait(7)
  end

  TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
  exports['progressBars']:startUI(time, Config.Progressbars)
  Citizen.Wait(time)
  ClearPedTasks(ped)
end)

if Config.BlipAttivo then
local blips = {
    {x = Config.Posizione.x, y = Config.Posizione.y, z = Config.Posizione.z}
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do 
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, Config.BlipSprite)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, Config.BlipScale)
        SetBlipColour(info.blip, Config.BlipColour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.BlipName)
        EndTextCommandSetBlipName(info.blip)
    end
end)
end


local pedlist= {
    { ['x'] = -1482.4139 + 1.0, ['y'] = -1335.81, ['z'] = 2.55, ['h'] =100.76 , ['hash'] = Config.PedHash, ['hash2'] = Config.PedName }
  }
  
  Citizen.CreateThread(function()
    for k,v in pairs(pedlist) do
        RequestModel(GetHashKey(v.hash2))
  
        while not HasModelLoaded(GetHashKey(v.hash2)) do 
            Citizen.Wait(100)
        end
  
  
        local ped = CreatePed(4, v.hash,v.x,v.y,v.z-1,v.h,false,true)

    end
end)
