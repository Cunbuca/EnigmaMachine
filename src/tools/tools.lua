local tools = {}

function tools:array_key_exists(table, key)
    return table[key] ~= nil
end

return tools