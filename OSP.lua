--[[

 $$$$$$\   $$$$$$\           
$$  __$$\ $$  __$$\   $$\    
$$ /  $$ |$$ /  \__|  $$ |   
$$ |  $$ |\$$$$$$\ $$$$$$$$\ 
$$ |  $$ | \____$$\\__$$  __|
$$ |  $$ |$$\   $$ |  $$ |   
 $$$$$$  |\$$$$$$  |  \__|   
 \______/  \______/          
                             
Copyright (c) 2026 HD_Nyx

Permission is granted to copy, modify and distribute this software only if:

1. You use it for non-commercial purposes only.
2. You give proper credit to the original author.


]]

-- Currently only tested on windows windows

local OperatingSystem = nil
local Check = package.config:sub(1,1)

if Check == "\\" then
    OperatingSystem = "Windows"
elseif Check == "/" then
    OperatingSystem = "Unix-Based"
else 
    OperatingSystem = "TempleOS-or-some-shit"
    os.exit(1)
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

function OSP.FileExists(FilePath) -- Do you have schizophrenia or does file explorer have it?
    
    local FileHandle = io.open(FilePath, "rb")

    if FileHandle then
        FileHandle:close()
        return true
    else
        return false
    end
end


function OSP.GetFileName(FilePath) -- Do I event need to explain?
    
    local FileName = FilePath:match("^.+[\\/](.+)$")

    if FileName then
        return FileName
    else
        return nil, "Failed to retrive file name"
    end
end

function OSP.GetFileSize(FilePath) -- Gets file size of path in bytes

    local FileHandle = io.open(FilePath, "rb")

    if not FileHandle then
        return nil, "Couldn't find file"
    end

    local FileSize = FileHandle:seek("end")
    FileHandle:close()

    return FileSize
end

function OSP.GetOS()

    if package.config:sub(1,1) == "\\" then
        return "Windows"
    end

    local Result = Handle:read("*l")
    Handle:close()
    
    if Result == "Darwin" then 
        return "macOS" 
    end

    if Result == "Linux" then 
        return "Linux" 
    end
    
end

function OSP.ReadFile(FilePath) -- Get everything inside the file as a string and return that string

    local FileHandle, ErrorMessage = io.open(FilePath, "rb")

    if not FileHandle then
        return nil, "Could not open file: " .. (ErrorMessage or "Unknown error")
    end

    local Contents = FileHandle:read("*a")
    FileHandle:close()

    return Contents
    
end

return OSP