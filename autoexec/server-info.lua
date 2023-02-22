--[[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SecretSupply/Roblox-Scripts/main/autoexec/Server.lua"))()
]]

local server do
    local serverString = game:GetService('NetworkClient').ConnectionAccepted:Wait();
    local ip, port = string.match(serverString, '(%S+)|(%S+)');
    server = {
        IP = ip,
        Port = port
    };
end

local json do
    local httpService = game:GetService('HttpService');
    json = {
        decode = function(...)
            return httpService:JSONDecode(...);
        end,

        encode = function(...)
            return httpService:JSONEncode(...);
        end
    }
end

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request do
    local response = httpRequest({
        Url = string.format('http://ip-api.com/json/%s', server.IP),
        Method = 'GET',
    });

    server.Location = {
        Country = 'Unknown',
        CountryCode = '?',
        Region = 'Unknown',
        RegionCode = '?',
        City = 'Unknown'
    };
    
    if response then
        local info = json.decode(response.Body);
        if info then
            for a, b in pairs({
                Country = 'country',
                CountryCode = 'countryCode',
                Region = 'regionName',
                RegionCode = 'region',
                City = 'city'
            }) do
                server.Location[a] = info[b];
            end
        end
    end
end

getgenv().Server = server

local bindable = Instance.new('BindableFunction')
bindable.OnInvoke = function(text)
    bindable:Destroy()
    bindable = nil

    if text == 'Copy Info' then
        setclipboard(string.format(
            '%s\nIP: %s, Port: %s\nCountry: %s (%s)\nRegion: %s (%s)\nCity: %s',
            string.rep('-', 16) .. ' SERVER INFO ' .. string.rep('-', 16),
            server.IP,
            server.Port,
            server.Location.Country,
            server.Location.CountryCode,
            server.Location.Region,
            server.Location.RegionCode,
            server.Location.City
        ))
    end
end

local starterGui = game:GetService('StarterGui');
local notificationConfig = {
    Title = 'SERVER INFO',
    Text = string.format(
        'IP: %s, Port: %s\nCountry: %s (%s)\nRegion: %s (%s)\nCity: %s\n',
        server.IP,
        server.Port,
        server.Location.Country,
        server.Location.CountryCode,
        server.Location.Region,
        server.Location.RegionCode,
        server.Location.City
    ),
    Duration = 15,
    Button1 = 'Copy Info',
    Button2 = 'Close',
    Callback = bindable
};

while not pcall(starterGui.SetCore, starterGui, 'SendNotification', notificationConfig) do
    task.wait();
end

-- print(string.format(
--     '\n%s\nIP: %s, Port: %s\nCountry: %s (%s)\nRegion: %s (%s)\nCity: %s',
--     string.rep('-', 16) .. ' SERVER INFO ' .. string.rep('-', 16),
--     server.IP,
--     server.Port,
--     server.Location.Country,
--     server.Location.CountryCode,
--     server.Location.Region,
--     server.Location.RegionCode,
--     server.Location.City
-- ));