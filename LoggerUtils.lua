local LoggerUtils = {}

function LoggerUtils.DeepCopyTable(tab)
    local newTable = {}
    for key, value in pairs(tab) do
        newTable[key] = value
    end
    return newTable
end

return LoggerUtils