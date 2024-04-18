local radioDisabled = GetResourceKvpInt("DisableRadio") == 1

-- Function to handle radio disabling
function DisableRadio()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        SetUserRadioControlEnabled(false)
        local playerVehicle = GetVehiclePedIsIn(ped, false)
        if GetPlayerRadioStationName() ~= nil then
            SetVehRadioStation(playerVehicle, "OFF")
        end
    end
end

function EnableRadio()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        SetUserRadioControlEnabled(true)  -- Enable radio controls
        -- Optionally set a default radio station:
        local playerVehicle = GetVehiclePedIsIn(ped, false)
        SetVehRadioStation(playerVehicle, Config.DefaultStation) 
    end
end

-- Update cache and toggle setting
function toggleRadio()
    radioDisabled = not radioDisabled
    print(radioDisabled)

    SetResourceKvpInt("DisableRadio", radioDisabled and 1 or 0)

    if Config.ShowStatus then
        local message = radioDisabled and "Radio will be turned off in vehicles." or "Radio will now play in vehicles."

        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            multiline = true,
            args = {"SYSTEM", message}
        })
    end

    -- Call the appropriate function based on radio state
    if radioDisabled then
        DisableRadio()
    else 
        EnableRadio()
    end 
end

if Config.Mode == 'player' then
-- Registering the command
    RegisterCommand("toggleRadioBehavior", function()
        toggleRadio()  -- Direct function call   
    end, false)
end

-- Main thread for periodic checks
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Manage performance with increased wait time
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            if Config.Mode == "global" then
                DisableRadio()
            elseif Config.Mode == "player" and radioDisabled then
                DisableRadio()
            end
        end
    end
end)
