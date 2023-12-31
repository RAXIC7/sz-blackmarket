local QBCore = exports['qb-core']:GetCoreObject()

local function CheckMoney(itemPrice)
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.money['cash'] >= itemPrice then
        return false
    else 
        return true
    end
end

function QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel) --not sure what this is here for unless youre trying to create a global progressbar
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish then
                onFinish()
            end
        else
            if onCancel then
                onCancel()
            end
        end
    end)
end

-- Target Doors
for k, v in pairs(Config.DoorLocations) do
    exports['qb-target']:AddCircleZone(v.name, v.location, 0.4, {
        name = v.Name,
        debugPoly = Config.Debug,
    }, {
        options = {
            {
                num = 1,
                type = 'client',
                event = 'sz-blackmarket:client:DoorKnock',
                icon = 'fas fa-question',
                label = 'Unknown',
                drawDistance = 1,
                drawColor = {255, 255, 255, 255},
                successDrawColor = {30, 144, 255, 255}
            }
        },
        distance = 1
    })
end

RegisterNetEvent('sz-blackmarket:client:PurchaseItem', function(args)
    TriggerServerEvent('sz-blackmarket:server:AddItem', args.item, args.amount)
    TriggerServerEvent('sz-blackmarket:server:PurchaseItem', args.item, args.price)
end)


RegisterNetEvent('sz-blackmarket:client:DoorKnock', function()
    QBCore.Functions.Progressbar('Knocking', 'Knocking...', 3000, false, true, {
        TriggerEvent('animations:client:EmoteCommandStart', {"knock"}),
        disableMovement = true,
        disableMouse = false, 
        disableCombat = true
    }, {}, {}, {}, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent('sz-blackmarket:client:OpenShop')
    end, function ()
    end)
end)

RegisterNetEvent('sz-blackmarket:client:OpenShop', function()
    local clockTime = GetClockHours()
    if Config.Debug then
        print('Current time: ', clockTime)
    end
    if clockTime >= Config.OpenHour and clockTime <= Config.CloseHour - 1 then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                for j, job in pairs(Config.BlackListedJobs) do
                    if PlayerData.job.name == job then 
                        QBCore.Functions.Notify('\"There is nothing here for you!\"', 'error', 3000)
                        return
                    end
                end
                QBCore.Functions.Notify('\"Give me a moment\"', 'primary', 3000)
                Wait(6000)
                QBCore.Functions.Notify('\"Here\'s what I have to offer\"', 'primary', 2000)
                Wait(2000)

                if Config.UseMenu then
                    local itemsList = {}
                itemsList[#itemsList + 1] = {
                    isMenuHeader = true,
                    header = 'Unknown',
                    icon = 'fa-solid fa-question'
                }
                for k,v in pairs(Config.Items.items) do 
                    itemsList[#itemsList + 1] = { 
                        header = v.header,
                        txt = 'Price: $' .. v.price .. ' | Use: ' .. v.description,
                        icon = v.icon,
                        disabled = CheckMoney(v.price),
                        params = {
                            event = 'sz-blackmarket:client:PurchaseItem', 
                            args = {
                                item = v.name,
                                price = v.price,
                                amount = 1,
                            }
                        }
                    }
                end
                exports['qb-menu']:openMenu(itemsList) 
            else
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Black Market", Config.Items)
            end
            end)
    elseif clockTime >= Config.CloseHour and clockTime <= Config.OpenHour then
        QBCore.Functions.GetPlayerData(function(PlayerData)
            for k, job in pairs(Config.BlackListedJobs) do
                if PlayerData.job.name == job then 
                    QBCore.Functions.Notify('\"There is nothing here for you!\"', 'error', 3000)
                    return
                end
            end
            QBCore.Functions.Notify('\"I don\'t do business during the day\"')
        end)
    else
        QBCore.Functions.GetPlayerData(function(PlayerData)
            for _, job in pairs(Config.BlackListedJobs) do
                if PlayerData.job.name == job then 
                    QBCore.Functions.Notify('\"There is nothing here for you!\"', 'error', 3000)
                    return
                end
            end
            QBCore.Functions.Notify('\"I don\'t do business during the day\"')
        end)
    end
end)
