local tools = {}

function tools:array_key_exists(table, key)
    return table[key] ~= nil
end

function tools:concat(arrayToConcat, list, divider) 
    returnMsg = ""
    for i=#list, 1, -1 do
        returnMsg = returnMsg .. arrayToConcat[list[i]] .. divider
    end
    return string.sub(returnMsg, 1, #returnMsg-#divider)
end

return tools