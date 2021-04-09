# Greybel 0.1.1.0

Grey Script preprocessor. Which adds new features to Grey Script.

For examples lookup [this repository](https://github.com/ayecue/greyscript-library).

**Note:** Currently this only implements importing files. Other features are not implemented yet. Since this is rather a POC.

Features:
- import files, used to load other files into script
- building creates temporary file for better debugging
- wraps imported files in function block to prevent variable shadowing

# Install

To make things a little bit more easy there's a installer file. First you have to build it though.
```
chmod +x build.sh
./build.sh
```
Now you copy the content of the installer file to Grey Hack and execute the installer.
```
build installer.src /usr/bin
installer
build /home/user-folder/compiler/compile.src /usr/bin
```
This should create all necessary folders and files.

# CLI Usage
```
Compiler CLI
Version: 0.1.1.0
Example: compile myscriptfile

-h --help - Print help
-d --debug - Activate debug mode
-cs --command-start - Command starting operator
-s --script-folder - Script folder
-t --temp-folder - Temporary folder
-c --compiler-folder - Compiler folder
-b --bin-folder - Bin folder
-se --script-extension - Script extension
```
Keep in mind that the script file has to be in the script folder which is defined in the configuration file. By default it should be `/home/user-folder/scripts`. The compile is not using an absolute path but the relative path from the script folder.

# Syntax

## Importing
The import will use the relative path from the file it imports to. Also keep in mind to not use the `.src` extension. It will automatically add the extension. (going to add a detection in the future for the extension to prevent any misuse)
```
//File path: library/hello-world.src
module.exports = function()
	print("Hello world!")
end function

//File path: library/hello-name.src
module.exports = function(name)
	print("Hello " + name + "!")
end function

//File path: example.src
#import HelloWord from library/hello-world;
#import HelloName from library/hello-name;

HelloWord() //prints "Hello world!"
HelloName("Joe") //prints "Hello Joe!"
```

# Configuration

You can either use the configuration file in `/home/user-folder/Config/compile.conf` to setup the compiler. Or you can use the CLI arguments.

# Known issues

- files that use newline (\n) anywhere in a string of a file that should be compiled will lead to issues, you can use NEW_LINE_OPERATOR constant variable instead which is included into every header
```
line = "Hello\nWorld!".split(NEW_LINE_OPERATOR)
line[0] //Hello
line[1] //World!
```
