local enigmaEngine = {}
local tools = require("tools.tools")
local json = require("tools.dkjson")

local defaultConfigs = {
    using = {
        plugboard = "plugBoardA",
        reflector = "reflectorA",
        rotors = {
            "rotorA",
            "rotorB",
            "rotorC"
        }
    },
    plugboards = {
        plugBoardA = {
            a = "v"
        },
        plugBoardB = {
            g = "j"
        },
        plugBoardC = {
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

local configsFile = io.open("enigaconfigs.json", "r")
local configs = {}

if configsFile then
    configs = configsFile:read("*a")
    configs = json.decode(configs)
else
    configsFile = io.open("enigaconfigs.json", "w")
    configsFile:write(json.encode(defaultConfigs, { indent = true }))
    configs = defaultConfigs
end

configsFile:close()

function enigmaEngine:plugBoard(entryChar)
    if tools:array_key_exists(configs.plugBoards[configs.using.plugBoard], entryChar) then
        return configs.plugBoards[configs.using.plugBoard][entryChar]
    else
        return entryChar
    end
end

function enigmaEngine:rotors(...)

end

function enigmaEngine:use(module, names)
    assert(module == "rotors" or module == "reflector" or module == "plugboard", "Invalid mode")

    if module == "reflector" or module == "plugboard" then 
        configs.using[module] = names
    else
        configs.using.rotors = {}
        assert(names[1] ~= nil, "at least one rotor to work")
        for key, value in ipairs(names) do
            configs.using.rotors[key] = value
        end
    end
    configsFile = io.open("enigaconfigs.json", "w")
    configsFile:write(json.encode(configs, {indent = true}))
    configsFile:close()
end

return enigmaEngine
