local enigma = {}
local tools = require("tools")
local json  = require("dkjson")

local defaltConfigs = {
    plugboard = {
    },
    rotors = {
        {
            v = "b"
        },
        {
            b = "g"
        },
        {
            g = "j"
        }
    },
    reflector = {
        j = "u"
    }
}

-- local encoded = json.encode(defaltConfigs, {indent = true})

local configfile = io.open("enigaconfig.json", "r")
local config = configfile:read("*a")
configfile:close()

config = json.decode(config)

function enigma:plugboard(entryChar)
    if tools:array_key_exists(config.plugboard, entryChar) then 
        return config.plugboard[entryChar]
    else
        return entryChar
    end
end

return enigma