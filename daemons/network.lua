local naughty = require("naughty")
local gtimer = require("gears.timer")

local lgi = require("lgi")
local nm = lgi.NM

local M = {}

function M.start()
    M.client = nm.Client.new()
    M.devices = M.client:get_devices()
    for i, d in ipairs(M.devices) do
        local info = d:get_device_type()
        if (info == "ETHERNET") then
            M.eth = d
        end
        if (info == "WIFI") then
            M.wifi = d
        end
    end

    if M.eth then
        M.eth.on_state_changed = function()
            local id = nil
            local eth_state = nil
            local wifi_state = nil
            if M.client.primary_connection and M.client.primary_connection.id then
                id = M.client.primary_connection.id
            end
            if M.eth and M.eth.state then
                eth_state = M.eth.state
            end
            if M.wifi and M.wifi.state then
                wifi_state = M.wifi.state
            end
            awesome.emit_signal("network::update", id, eth_state, wifi_state)
        end
    end
    if M.wifi then
        M.wifi.on_state_changed = function()
            local id = nil
            local eth_state = nil
            local wifi_state = nil
            if M.client.primary_connection and M.client.primary_connection.id then
                id = M.client.primary_connection.id
            end
            if M.eth and M.eth.state then
                eth_state = M.eth.state
            end
            if M.wifi and M.wifi.state then
                wifi_state = M.wifi.state
            end
            awesome.emit_signal("network::update", id, eth_state, wifi_state)
        end
    end
    local id = nil
    local eth_state = nil
    local wifi_state = nil
    if M.client.primary_connection and M.client.primary_connection.id then
        id = M.client.primary_connection.id
    end
    if M.eth and M.eth.state then
        eth_state = M.eth.state
    end
    if M.wifi and M.wifi.state then
        wifi_state = M.wifi.state
    end
    gtimer.delayed_call(awesome.emit_signal, 'network::update', id, eth_state, wifi_state)
end

M.start()
