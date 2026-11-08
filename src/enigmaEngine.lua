local enigmaEngine = {}
local tools = require("tools.tools")
local json = require("tools.dkjson")

local defaultConfigs = {
    using = {
        plugboard = "plugBoardA",
        reflector = "reflectorA",
        rotorsPosition = {         
            rotorB = 1,
            rotorA = 1
        },
        rotors = {
            "rotorA",
            "rotorB"
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
            A = "J",
            B = "P",
            C = "G",
            D = "V",
            E = "O",
            F = "U",
            G = "M",
            H = "F",
            I = "Y",
            J = "Q",
            K = "B",
            L = "E",
            M = "N",
            N = "H",
            O = "Z",
            P = "R",
            Q = "D",
            R = "K",
            S = "A",
            T = "S",
            U = "X",
            V = "L",
            W = "I",
            X = "C",
            Y = "T",
            Z = "W"
        },
        rotorB = {
            A = "N",
            B = "Z",
            C = "J",
            D = "H",
            E = "G",
            F = "R",
            G = "C",
            H = "X",
            I = "M",
            J = "Y",
            K = "S",
            L = "W",
            M = "B",
            N = "O",
            O = "U",
            P = "F",
            Q = "A",
            R = "I",
            S = "V",
            T = "L",
            U = "P",
            V = "E",
            W = "K",
            X = "Q",
            Y = "D",
            Z = "T"
        },
        rotorC = {
            A = "F",
            B = "K",
            C = "Q",
            D = "H",
            E = "T",
            F = "L",
            G = "X",
            H = "O",
            I = "C",
            J = "B",
            K = "J",
            L = "S",
            M = "P",
            N = "D",
            O = "Z",
            P = "R",
            Q = "A",
            R = "M",
            S = "E",
            T = "W",
            U = "N",
            V = "I",
            W = "U",
            X = "Y",
            Y = "G",
            Z = "V"
        }
    },
    reflectors = {
        reflectorA = {
            A = "N",
            B = "O",
            C = "P",
            D = "Q",
            E = "R",
            F = "S",
            G = "T",
            H = "U",
            I = "V",
            J = "W",
            K = "X",
            L = "Y",
            M = "Z"
        },
        reflectorB = {
            A = "T",
            B = "U",
            C = "V",
            D = "W",
            E = "X",
            F = "R",
            G = "Z",
            H = "N",
            I = "O",
            J = "P",
            K = "Q",
            L = "Y",
            M = "S"
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
    if tools:array_key_exists(configs.plugboards[configs.using.plugboard], entryChar) then
        return configs.plugboards[configs.using.plugboard][entryChar]
    else
        return entryChar
    end
end

function enigmaEngine:rotors(entryChar)
    if entryChar == " " then
        return " "
    end
    for key, rotorName in ipairs(configs.using.rotors) do
        configs.using.rotorsPosition[rotorName] = configs.using.rotorsPosition[rotorName] + 1

        --[[if not array_key_exists(configs.rotors, rotorName) then
            return "Rotors name invalid"
        end

        if not array_key_exists(configs.rotors[rotorName], entryChar) then
            return "Rotors configs invalid"
        end]]

        entryChar = configs.rotors[rotorName][entryChar]
    end
    print(table.concat(configs.using.rotorsPosition, " | "))
    return entryChar
end

function enigmaEngine:use(module, names)
    local returnMsg = "Is not a valid "..module.." name"

    if names[1] == nil then 
        return "at least one "..module.." to work"
    end

    if not isValidModule(module) then
        return "Invaid module type"
    end

    if module == "reflector" or module == "plugboard" then 

        if not isValidModuleName(module.."s", names[1]) then
            return "\""..names[1].. "\" "..returnMsg
        end

        configs.using[module] = names
        returnMsg = "Now using: \""..names[1].."\" as "..module

    else -- else if module == "rotors"

        configs.using.rotors = {}
        configs.using.rotorsPosition = {}
        for key, value in ipairs(names) do
            if not isValidModuleName(module, value) then
                return "\""..value.."\" "..returnMsg
            end
            configs.using.rotorsPosition[value] = 1
            configs.using.rotors[key] = value
        end

        returnMsg = "Now using: \""..table.concat(names, ", ").."\" as "..module
    end
    configsFile = io.open("enigaconfigs.json", "w")
    configsFile:write(json.encode(configs, {indent = true}))
    configsFile:close()
    return returnMsg
end

function isValidModule(module)
    if module == "rotors" or module == "reflector" or module == "plugboard" then 
        return true
    else
        return false
    end
end

function isValidModuleName(module, moduleName)
    if tools:array_key_exists(configs[module], moduleName) then 
        return true
    else
        return false
    end
end

return enigmaEngine
