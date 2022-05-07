ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(5000)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function menu()


    
    local polemploi = RageUI.CreateMenu("Pole Emploi","Options Disponible : ")
    local fa = RageUI.CreateSubMenu(polemploi, "Métier Libre", "Métier Libre")
    local wl = RageUI.CreateSubMenu(polemploi, "Métier WhiteList", "Métier WhiteList")

    local test = false
    local Percent_ = 0.0

    local test2 = false
    RageUI.Visible(polemploi, not RageUI.Visible(polemploi))

    while polemploi do
        
        Citizen.Wait(0)

        FreezeEntityPosition(GetPlayerPed(-1), true)

        RageUI.IsVisible(polemploi,true,true,true,function()



            RageUI.ButtonWithStyle("Metier Free Acces",nil,{},true, function(Hovered, Active, Selected)
            end, fa)

            RageUI.ButtonWithStyle("Metier WhiteList",nil,{},true, function(Hovered, Active, Selected)
            end, wl)

            RageUI.line()

            if ESX.PlayerData.job and ESX.PlayerData.job.name == "unemployed" then
                RageUI.ButtonWithStyle("                          Chomâge",nil,{RightBadge = RageUI.BadgeStyle.Lock, Color = {BackgroundColor = RageUI.ItemsColour.Red}},true, function(Hovered, Active, Selected)
                end)

            else
                RageUI.ButtonWithStyle("                          ~y~Chomâge",nil,{},true, function(Hovered, Active, Selected)
                    if Selected then
                        test = true
                    end
                end)

                if test then
                    RageUI.PercentagePanel(Percent_ or 0.0, "~r~Demision " .. math.floor(Percent_*100) .. "%)", "", "", function(Hovered, Active, Percent)
                        if Percent_ < 1.0 then
                            Percent_ = Percent_+0.001
    
                        else
                            TriggerServerEvent('trf_emploi:cho')
                            test = false
                            RageUI.CloseAll()

                        end
                    end)
                    
                end
                
            end

            



         
        end, function()
        end)


        RageUI.IsVisible(fa, true,true,true, function()

            for k,v in pairs(trf_emploi.fa) do
                RageUI.ButtonWithStyle(v.Nom, nil, {}, true, function(Hovered, Active, Selected)
                       if Selected then
                        test2 = true
                       end
                end)

                if test2 then
                    RageUI.PercentagePanel(Percent_ or 0.0, "~b~Embauchement " .. math.floor(Percent_*100) .. "%)", "", "", function(Hovered, Active, Percent)
                        if Percent_ < 1.0 then
                            Percent_ = Percent_+0.001
    
                        else
                            TriggerServerEvent('trf_emploi:setjob',v.setjob, v.Nom)
                            test2 = false
                            RageUI.CloseAll()
                        end
                    end)
                end
            end        
            

        
        end, function()
        end)

        RageUI.IsVisible(wl, true,true,true, function()

            for k,v in pairs(trf_emploi.wl) do
                RageUI.ButtonWithStyle(v.Nom, nil, {}, true, function(Hovered, Active, Selected)
                       if Selected then
                            local test = trf_menuadminKeyboardInput("Pourquoi vous", "", 1000)
                            local motiv = trf_menuadminKeyboardInput("Vos motivations", "", 1000)
                            local dispo = trf_menuadminKeyboardInput("Vos disponibilité", "", 1000)


                            if test ~= nil and test ~= "" and motiv ~= nil and motiv ~= "" and dispo ~= nil and dispo ~= ""then
                                TriggerServerEvent('trf_emploi:wl',test,motiv,dispo, v.Nom)
                            end
                       end
                   end)
                end
        
        
        
        end, function()
        end)

       

        


       
        if not RageUI.Visible(polemploi) and not RageUI.Visible(fa) and not RageUI.Visible(wl) then
            polemploi=RMenu:DeleteType("treifa", true)
        end

    end

end


Citizen.CreateThread(function()
    local poleemploimap = AddBlipForCoord(trf_emploi.pos.blips.position.x, trf_emploi.pos.blips.position.y, trf_emploi.pos.blips.position.z)
    SetBlipSprite(poleemploimap, 590)
    SetBlipColour(poleemploimap, 38)
    SetBlipAsShortRange(poleemploimap, true)
    SetBlipScale(poleemploimap, 0.65)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Pôle emploi")
    EndTextCommandSetBlipName(poleemploimap)
end)

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, trf_emploi.pos.Menu.position.x, trf_emploi.pos.Menu.position.y, trf_emploi.pos.Menu.position.z)
            if dist3 <= 1.0 then
            Timer = 0   
                RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour Acceder au Pole Emploi", time_display = 1 })
                DrawMarker(6, trf_emploi.pos.Menu.position.x, trf_emploi.pos.Menu.position.y, trf_emploi.pos.Menu.position.z-1.00, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 155, 255, 200, false, false, true, false, false, false, false, false)
                if IsControlJustPressed(1,51) then
                    Citizen.Wait(100)
                    menu()
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                end   
            end
        
    Citizen.Wait(Timer)
 end
end)





function trf_menuadminKeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end



Citizen.CreateThread(function()
    local hash = GetHashKey(trf_emploi.Peds)
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", trf_emploi.Peds, trf_emploi.pos.Peds.position.x, trf_emploi.pos.Peds.position.y, trf_emploi.pos.Peds.position.z, trf_emploi.pos.Peds.position.h, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, 1)
end)