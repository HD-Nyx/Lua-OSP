-- Currently only tested no windows windows

local OperatingSystem = nil
local Check = package.config:sub(1,1)

if Check == "\\" then
    OperatingSystem = "Windows"
elseif Check == "/" then
    OperatingSystem = "Unix"
end
    
print("os being used: " .. OperatingSystem)

local OSP = {}

function OSP.CreateFile(FileName, Path, InitialContent) -- Create a file, your choice of what it is

    if Path:sub(-1) ~= "/" and Path:sub(-1) ~= "//" then
        Path = Path .. "/"
    end

    local CompleteFilePath = Path .. FileName

    local FileHandle, ErrorMessage = io.open(CompleteFilePath, "w")

    if not FileHandle then
        return nil, "Failed to create file " .. (ErrorMessage or "Unknown error")
    end

    if InitialContent then
        FileHandle:write(InitialContent)
    end

    FileHandle:close()
    return CompleteFilePath

end

function OSP.GetFileName(FilePath)
    
    local FileName = FilePath:match("^.+[\\/](.+)$")

    if FileName then
        return FileName
    else
        return nil, "Failed to retrive file name"
    end
end

function OSP.GetFileSize(FilePath) -- Gets fize size of path in bytes

    local FileHandle = io.open(FilePath, "rb")

    if not FileHandle then
        return nil, "Couldn't find file"
    end

    FileHandle:seek("end")

    local FileSize = FileHandle:seek()
    FileHandle:close()

    return FileSize
end

function OSP.FileExists(FilePath) -- Do you have schizophrenia or does file explorer have it?
    
    local FileHandle = io.open(FilePath, "rb")

    if FileHandle then
        return true
    else
        return false
    end
end

return OSP