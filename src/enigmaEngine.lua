local enigmaEngine = {}
local tools = require("tools.tools")
local json = require("tools.dkjson")

local defaultConfigs = {
    using = {
        plugboard = "plugBoardA",
        reflector = "reflectorA",
        rotorsPosition = {         
            rotorA = 1
        },
        rotors = {
            "rotorA",
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
            {"J", 6},
            {"P", 8},
            {"G", 16},
            {"V", 23},
            {"O", 7},
            {"U", 2},
            {"M", 9},
            {"F", 24},
            {"Y", 12},
            {"Q", 18},
            {"B", 26},
            {"E", 4},
            {"N", 14},
            {"H", 15},
            {"Z", 17},
            {"R", 20},
            {"D", 5},
            {"K", 3},
            {"A", 22},
            {"S", 1},
            {"X", 11},
            {"L", 10},
            {"I", 13},
            {"C", 19},
            {"T", 21},
            {"W", 25}
        },
        rotorB = {
            {"N", 8},
            {"Z", 6},
            {"J", 5},
            {"H", 20},
            {"G", 18},
            {"R", 21},
            {"C", 4},
            {"X", 17},
            {"M", 26},
            {"Y", 2},
            {"S", 11},
            {"W", 15},
            {"B", 1},
            {"O", 14},
            {"U", 16},
            {"F", 13},
            {"A", 12},
            {"I", 10},
            {"V", 19},
            {"L", 3},
            {"P", 25},
            {"E", 24},
            {"K", 9},
            {"Q", 23},
            {"D", 7},
            {"T", 22}
        },
        rotorC = {
            {"C", 2},
            {"D", 3},
            {"A", 4},
            {"B", 1}
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

function enigmaEngine:plugBoard(entryChar)
    if tools:array_key_exists(configs.plugboards[configs.using.plugboard], entryChar) then
        return configs.plugboards[configs.using.plugboard][entryChar]
    else
        return entryChar
    end
end

function enigmaEngine:rotors(entryChar)
    local previusRotorReachMax = false
    local previusRotorPosition = 0
    local previusLetterPosition = 0
    local rotorLength = 26
    if entryChar == " " then
        return " "
    end
    entryCharToNum = charToNum(entryChar)
    for key, rotorName in ipairs(configs.using.rotors) do
        if not tools:array_key_exists(configs.rotors, rotorName) then
            return "Rotors name invalid"
        end

        if not tools:array_key_exists(configs.rotors[rotorName], entryCharToNum) then
            return "Rotors configs invalid"
        end

        if key == 1 or previusRotorReachMax then 
            configs.using.rotorsPosition[rotorName] = configs.using.rotorsPosition[rotorName] + 1
            previusRotorReachMax = false
        end

        if configs.using.rotorsPosition[rotorName] >= rotorLength + 1 then
            configs.using.rotorsPosition[rotorName] = 1    
            previusRotorReachMax = true
        end

        if key == 1 then 
            entryChar = configs.rotors[rotorName][configs.using.rotorsPosition[rotorName]][1]
        else
            local letterPosition = configs.rotors[rotorName][configs.using.rotorsPosition[rotorName]][2]
            local nextLetterPosition = previusLetterPosition + configs.using.rotorsPosition[rotorName] + previusRotorPosition
            --print(previusLetterPosition .. " + " .. configs.using.rotorsPosition[rotorName] .. " + " ..previusRotorPosition .." = " .. nextLetterPosition)
            if nextLetterPosition > rotorLength then
                nextLetterPosition = nextLetterPosition - rotorLength
            end
            entryChar = configs.rotors[rotorName][nextLetterPosition][1]
        end
        
        --print("i now you: "..entryChar)
        previusLetterPosition = configs.rotors[rotorName][configs.using.rotorsPosition[rotorName]][2]
        previusRotorPosition = configs.using.rotorsPosition[rotorName]
        --print("rotor: ".. rotorName .. " position: "..previusRotorPosition)
    end

    entryChar = reflector(entryChar)

    --for i=#configs.using.rotors, #configs.using.rotors, -1 do
    --end 

    configsFile = io.open("enigaconfigs.json", "w")
    configsFile:write(json.encode(configs, {indent = true}))
    configsFile:close()
    return entryChar
end

function reflector(entryChar)
    if tools:array_key_exists(configs.reflectors[configs.using.reflector], entryChar) then 
        return configs.reflectors[configs.using.reflector][entryChar]
    else
        --add a hashMap to do not need iterate too many times
        for key, value in pairs(configs.reflectors[configs.using.reflector]) do
            if value == entryChar then
                return key
            end
        end
    end
end

function enigmaEngine:getRotorsPosition()
    return tools:concat(configs.using.rotorsPosition, configs.using.rotors, " | ")
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

function charToNum(entryChar)
    if entryChar == "A" then return 1
    elseif entryChar == "B" then return 2
    elseif entryChar == "C" then return 3
    elseif entryChar == "D" then return 4
    elseif entryChar == "E" then return 5
    elseif entryChar == "F" then return 6
    elseif entryChar == "G" then return 7
    elseif entryChar == "H" then return 8         
    elseif entryChar == "I" then return 9         
    elseif entryChar == "J" then return 10         
    elseif entryChar == "K" then return 11         
    elseif entryChar == "L" then return 12         
    elseif entryChar == "M" then return 13         
    elseif entryChar == "N" then return 14         
    elseif entryChar == "O" then return 15         
    elseif entryChar == "P" then return 16         
    elseif entryChar == "Q" then return 17         
    elseif entryChar == "R" then return 18         
    elseif entryChar == "S" then return 19         
    elseif entryChar == "T" then return 20         
    elseif entryChar == "U" then return 21         
    elseif entryChar == "V" then return 22         
    elseif entryChar == "W" then return 23         
    elseif entryChar == "X" then return 24         
    elseif entryChar == "Y" then return 25         
    elseif entryChar == "Z" then return 26
    else return entryChar .. " Is not a valid caracter."
    end
end

function numToChar(entryNum)
    if entryNum == 1 then return "A"
    elseif entryNum == 2  then return "B"
    elseif entryNum == 3  then return "C"
    elseif entryNum == 4  then return "D"
    elseif entryNum == 5  then return "E"
    elseif entryNum == 6  then return "F"
    elseif entryNum == 7  then return "G"
    elseif entryNum == 8  then return "H"        
    elseif entryNum == 9  then return "I"        
    elseif entryNum == 10 then return "J"         
    elseif entryNum == 11 then return "K"         
    elseif entryNum == 12 then return "L"         
    elseif entryNum == 13 then return "M"         
    elseif entryNum == 14 then return "N"         
    elseif entryNum == 15 then return "O"         
    elseif entryNum == 16 then return "P"         
    elseif entryNum == 17 then return "Q"         
    elseif entryNum == 18 then return "R"         
    elseif entryNum == 19 then return "S"         
    elseif entryNum == 20 then return "T"         
    elseif entryNum == 21 then return "U"         
    elseif entryNum == 22 then return "V"         
    elseif entryNum == 23 then return "W"         
    elseif entryNum == 24 then return "X"         
    elseif entryNum == 25 then return "Y"         
    elseif entryNum == 26 then return "Z"
    else return entryNum.." Is not a valid Number."
    end
end

return enigmaEngine
