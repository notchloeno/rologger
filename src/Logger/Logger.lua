local LoggerConfig = require(script.Parent.LoggerConfig)

local _TRACEBACK_LEVEL = 4
local _DEBUG_INFO_STRING = "sln"


local function generateOptionsTable(options)
    if not options then
        options = {}
    end
    local defaultOptions = table.clone(LoggerConfig.DefaultOptions)
    for key, value in options do
        if not defaultOptions[key] then
            error("No Logger option exists for " .. tostring(key))
        end
        defaultOptions[key] = value
    end
    return defaultOptions
end


local Logger = {}
Logger.__index = Logger


function Logger.new(source, options)
    options = generateOptionsTable(options)
    local name = `[{source.Name}]`
    return setmetatable({
        source = source,
        name = name,
        options = options,
        log = {}
    }, Logger)
end


function Logger:_GenerateLogMessage(message, level)
    local timestamp = DateTime.now():ToIsoDate()
    local levelTag = LoggerConfig.LevelText[level]

    local generatedMessage
    if self.options.IncludeTimestamp then
        generatedMessage = `{timestamp} {self.name} {levelTag} {message}`
    else
        generatedMessage = `{self.name} {levelTag} {message}`
    end

    if level >= self.options.TracebackLevel then
        generatedMessage = `{generatedMessage}\n{self:_GetDebugInfo()}`
    end
    return generatedMessage
end


function Logger:_SaveMessageToLog(message)
    local depth = self.options.Depth
    if #self.log > depth then
        table.remove(self.log, 1)
    end
    self.log[#self.log+1] = message
end


function Logger:_GetDebugInfo()
    local debugInfoString = debug.info(_TRACEBACK_LEVEL, _DEBUG_INFO_STRING)
    local debugInfo = string.split(debugInfoString, " ")
    local source = debugInfo[1]
    local lineNumber = debugInfo[2]
    local functionName = debugInfo[3]
    return source, lineNumber, functionName
end


function Logger:_GetTraceback()
    local traceback = debug.traceback(_TRACEBACK_LEVEL)
    return traceback
end


function Logger:_LogMessage(level, message)
    if message == nil then
        error("Message cannot be nil")
    elseif level == nil then
        error("Level cannot be nil")
    elseif type(message) ~= "string" then
        error("Message must be a string")
    elseif type(level) ~= "number" then
        error("Level must be an integer")
    elseif not (1 <= level and level <= 5) then
        error("Level must be between 1 and 5")
    end

    -- For example, if the logger is set to level 3 (warning)
    -- and the message level is level 1 (info) it is ignored
    local loggerLevel = self.options.Level
    if level < loggerLevel then
        return
    end

    message = self:_GenerateLogMessage(message, level)
    print(message)
    self:_SaveMessageToLog(message)
    return message
end


function Logger:_GenerateStringDump()
    local dump = ""
    for _, msg in self.log do
        dump = dump .. msg .. "\n"
    end
    return dump
end


function Logger:DumpLogToConsole()
    for _, msg in self.log do
        print(msg)
    end
end


function Logger:Debug(...)
    return self:_LogMessage(LoggerConfig.Levels.Debug, ...)
end


function Logger:Info(...)
    return self:_LogMessage(LoggerConfig.Levels.Info, ...)
end


function Logger:Warn(...)
    return self:_LogMessage(LoggerConfig.Levels.Warning, ...)
end


function Logger:Error(...)
    return self:_LogMessage(LoggerConfig.Levels.Error, ...)
end


function Logger:Critical(...)
    return self:_LogMessage(LoggerConfig.Levels.Critical, ...)
end

return Logger