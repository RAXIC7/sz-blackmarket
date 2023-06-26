Config = {}

Config.Debug = false

Config.OpenHour = 1
Config.CloseHour = 5 

Config.PoliceJob = 'police' -- Name of police job

Config.DoorLocations = {
    ['1'] = {name = 'PaletoDoor', location = vector3(347.83, -1255.43, 32.7)}
    -- ['2'] = {name = 'Rancho', location = vector3(420.41, -2064.29, 22.14)} -- Add more locations if you want to
}

Config.Items = {
    ['1'] = {item = 'advancedlockpick', header = 'Advanced Lockpick', price = 100, description = '?', icon = 'fas fa-screwdriver-wrench'}, -- icons can be found on fontawesome.com/icons (free section)
    ['2'] = {item = 'weapon_appistol', header = 'AP Pistol', price = 20000, description = 'This could come in handy...', icon = 'fas fa-gun'},
    ['3'] = {item = 'radio', header = 'Radio', price = 20 , description = 'Just a normal radio', icon = 'fas fa-walkie-talkie'}
}
