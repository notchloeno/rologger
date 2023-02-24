-- The Logger object
local Logger = {}
Logger.__index = Logger

-- Services

-- Constants
local TRACEBACK_LEVEL = 4  -- DO NOT CHANGE
local DEBUG_INFO_STRING = "sln"

-- Dependancies
local LoggerConfig = require(script.Parent.LoggerConfig)
local LoggerUtils = require(script.Parent.LoggerUtils)

-- Static functions --

function Logger.new(source, options)
    options = Logger._generateOptions(options)
    local name = "{" .. source.Name .. "} "
    return setmetatable({
        source = source,
        name = name,
        options = options,
        log = {}
    }, Logger)
end


-- Returns a complete options table from the specified options
function Logger._generateOptions(options)
    local defaultOptions = LoggerUtils.DeepCopyTable(
        LoggerConfig.DefaultOptions
    )
    for key, value in pairs(options) do
        if not defaultOptions[key] then
            error("No Logger option exists for " .. tostring(key))
        end
        defaultOptions[key] = value
    end
    return defaultOptions
end


-- Object functions --


function Logger:_generateLogMessage(message, level)
    local timestamp = DateTime.now():ToIsoDate()
    local levelTag = LoggerConfig.LevelText[level]
    message = timestamp .. " " .. self.name .. levelTag .. message

    if level >= self.options.TracebackLevel then
        warn("getting debuginfo")
        message = message .. self:_getDebugInfo()
    end
    return message
end


function Logger:_saveMessageToLog(message)
    local depth = self.options.Depth
    if #self.log > depth then
        table.remove(self.log, 1)
    end
    self.log[#self.log+1] = message
end


function Logger:_getDebugInfo()
    local debugInfoString = debug.info(TRACEBACK_LEVEL, DEBUG_INFO_STRING)
    local debugInfo = string.split(debugInfoString, " ")
    local source = debugInfo[1]
    local lineNumber = debugInfo[2]
    local functionName = debugInfo[3]
    return source, lineNumber, functionName
end


function Logger:_getTraceback()
    local traceback = debug.traceback(TRACEBACK_LEVEL)
    return traceback
end


function Logger:_logMessage(message, level)
    if message == nil then
        error("Message cannot be nil")
    elseif level == nil then
        error("Level cannot be nil")
    elseif not type(message) == "string" then
        error("Message must be a string")
    elseif not type(level) == "number" then
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

    message = self:_generateLogMessage(message, level)
    print(message)
    self:_saveMessageToLog(message)
end


function Logger:_generateStringDump()
    local dump = ""
    for _, msg in ipairs(self.log) do
        dump = dump .. msg .. "\n"
    end
    return dump
end


function Logger:DumpLogToConsole()
    for _, msg in ipairs(self.log) do
        print(msg)
    end
end


function Logger:Debug(message)
    self:_logMessage(message, LoggerConfig.Levels.Debug)
end


function Logger:Info(message)
    self:_logMessage(message, LoggerConfig.Levels.Info)
end


function Logger:Warn(message)
    self:_logMessage(message, LoggerConfig.Levels.Debug)
end


function Logger:Error(message)
    self:_logMessage(message, LoggerConfig.Levels.Debug)
end


function Logger:Critical(message)
    self:_logMessage(message, LoggerConfig.Levels.Debug)
end

return Logger