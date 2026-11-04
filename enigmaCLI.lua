local args = {...}
local enigma = require("enigma")
local tools = require("tools")

if (args[1] == "decode") then
    if tools:array_key_exists(args, 2) then
        for i=1, #args[2], 1 do
            local char = string.sub(args[2], i, i)
            char = enigma:plugboard(char)
            io.write(char)
        end
    else
        print("Example: enigmaCLI decode <messagen>")
    end
end