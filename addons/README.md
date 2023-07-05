# Addons Function.

This project adds some LUA Functions to make it easier to edit files.

## Functions

#### ReplaceLine(file, line, replacement)
This function will replace the first occurrence of the given line with the given text.  
Arguments:  
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.  
        2. line = The line to search for. NOTE: You currently need to have exactly the same spaces.  
        3. text = The text to replace the give line with.

#### AddAfterLine(file, line, text)
This function will add the given text to the first occurrence of the given line.  
Arguments:
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.  
        2. line = The line to search for. NOTE: You currently need to have exactly the same spaces.  
        3. text = The text to add after the given line.  

#### AddAboveLastLine(file, line, text)
This function will insert the given text above the last occurrence of the given line.  
Arguments:  
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.  
        2. line = The line to search for. NOTE: You currently need to have exactly the same spaces.  
        3. text = The text to add after the given line.

#### AddAboveLine(file, line, text)
This function will insert the given text above the first occurrence of the given line.  
Arguments:  
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.  
        2. line = The line to search for. NOTE: You currently need to have exactly the same spaces.  
        3. text = The text to add after the given line.

#### AppendFile(file, text)
This function will append the given text to the end of the file.    
    Arguments:  
        1. path = The path to the file like "routes/admin.php". All paths are relative to the panel folder.  
        2. text = The text to append to the end of the file.

#### CopyFolder(folder)
This function will copy all files and folder from the given path into the panel folder  
Arguments:   
        1. folder = The folder containing all files/folders that should be copied into the panel folder.   
        2. additional = DO NOT ADD THIS ARGUMENT MANUALLY! If you add this argument, it will most likely break the whole function.

#### AddCommand(command)
This function will add a command that should be executed before the panel is compiled.  
Arguments:  
        1. command = The command to execute before compiling the panel.

#### include(addon)
This function will load the given addon.  
Arguments:  
        1. path = The path to the addon to load. All paths are relative to the addons folder.  
**NOTE: This function should only be used in the addons.lua file!**

### Internal Functions
These are some functions that are used internally.

#### os.name()
Returns the name of the operating system.  
Can be "Windows", "Linux" or "MacOS".

#### string.Replace(string, replace, replacement)
This function searches in the given string (first argument) for the given string (second argument) and if it's found it replace it with the given replacement (third argument.)