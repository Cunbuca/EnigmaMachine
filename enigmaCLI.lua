local args = {...}
local enigmaEngine = require("enigmaEngine")
local tools = require("tools")

if (args[1] == "decode") then
    if tools:array_key_exists(args, 2) then
        for i=1, #args[2], 1 do
            local char = string.sub(args[2], i, i)
            char = enigmaEngine:plugboard(char)
            io.write(char)
        end
    else
        print("Example: enigmaCLI decode <messagen>")
    end
else if (args[1] == select)
end
--[[
    -- select --
    Usage: enigmaCLI select rotors <rotor1_name> <rotor2_name> ...
    or
    Usage: enigmaCLI select reflector <reflector_name>
    or
    Usage: enigmaCLI select plugboard <plugboard_name>
    
    if select two rotors only will use two, non return, error can use any number of rotors as wanted. For default use the three firts rotors.
]]