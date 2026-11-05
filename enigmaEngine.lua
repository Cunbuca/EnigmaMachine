local enigmaEngine = {}
local tools = require("tools")
local json  = require("dkjson")

local defaltConfigs = {
    plugboards = {
        plugboardA = {
            a = "v"  
        },
        plugboardB = {
            g = "j"  
        },
        plugboardC = {
            e = "n"  
        }
    },
    rotors = {
        rotorA = {
            v = "b"
        },
        rotorB = {
            b = "g"
        },
        rotorC = {
            g = "j"
        }
    },
    reflectors = {
        reflectorA = {
            j = "u"
        },
        reflectorB = {
            a = "i"
        }
    }
}

-- local encoded = json.encode(defaltConfigs, {indent = true})

local configfile = io.open("enigaconfig.json", "r")
local config = configfile:read("*a")
configfile:close()

config = json.decode(config)

function enigmaEngine:plugboard(entryChar)
    if tools:array_key_exists(config.plugboards[usePlugboard], entryChar) then 
        return config.plugboard[entryChar]
    else
        return entryChar
    end
end

return enigmaEngine