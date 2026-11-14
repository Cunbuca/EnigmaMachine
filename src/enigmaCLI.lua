local args = {...}
local enigmaEngine = require("enigmaEngine")
local tools = require("tools.tools")

if args[1] == "decode" then
    if tools:array_key_exists(args, 2) then
        local phase = ""
        print("Rotors Initial Position: "..enigmaEngine:getRotorsPosition())
        args[2] = string.upper(args[2])
        for i=1, #args[2], 1 do
            local char = string.sub(args[2], i, i)
            char = enigmaEngine:plugBoard(char)
            char = enigmaEngine:rotors(char)
            char = enigmaEngine:plugBoard(char)
            if char == " " then
                phase = phase .. " "
            else
                phase = phase .. char
            end
        end
        print("")
        print(phase)
    else
        print("Usage: enigmaCLI decode \"messagen\" ")
    end
elseif args[1] == "use" then
    --[[ use --
    Usage: enigmaCLI use rotors <rotor1_name> <rotor2_name> ...
    or
    Usage: enigmaCLI use reflector <reflector_name>
    or
    Usage: enigmaCLI use plugBoard <plugboard_name>
    
    if selected two rotors only will use two, non return error, can use any number of rotors as wanted. For default use the three firts rotors and the first plugboard and reflector.]]
    local module = args[2]
    module = string.lower(module)
    local names = {}
    if module == "rotors" then
        table.remove(args, 1)
        table.remove(args, 1)
        names = args
    else
        names[1] = args[3]
    end
    local resp = enigmaEngine:use(module, names)
    io.write(resp)
end