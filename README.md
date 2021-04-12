# Greybel 0.2.0.0

GreyScript preprocessor ([GreyHack](https://store.steampowered.com/app/605230/Grey_Hack/). Which adds new features to GreyScript.

For examples lookup [this repository](https://github.com/ayecue/greyscript-library).

Features:
- import files, used to load other files into script
- building creates temporary file for better debugging
- wraps imported files in function block to prevent variable shadowing
- include which unlike import just copy paste its content
- envar which puts values from an env file into the script

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
Version: 0.2.0.0
Example: compile myscriptfile

-h --help - Print help
-d --debug - Activate debug mode
-cs --command-start - Command starting operator
-ce --command-end - Command ending operator
-t --temp-folder - Temporary folder
-c --compiler-folder - Compiler folder
-b --bin-folder - Bin folder
-se --script-extension - Script extension
-no --no-output - No output
-sx --suffix - Suffix
-ev --env-file - Environment varibales file
```

**OUTDATED**: Keep in mind that the script file has to be in the script folder which is defined in the configuration file. By default it should be `/home/user-folder/scripts`. The compile is not using an absolute path but the relative path from the script folder. (**Since version 0.2.0.0 myscriptfile just uses the given filepath**)

## Examples:
### Most common build command:
```
//Build file will be available in TEMP_FOLDER/BUILD_ID/file.src
//Binary will be available in BIN_FOLDER/file
compile /my/code/file.src
```

### Build with environment variables:
```
//Build file will be available in TEMP_FOLDER/BUILD_ID/file.src
//Binary will be available in BIN_FOLDER/file
compile /my/code/file.src --env-file /path/envs.conf
```

### Build with environment variables, suffix and no-output:
```
//No build file because of --no-output
//Binary will be available in BIN_FOLDER/filestaging
compile /my/code/file.src --env-file /path/envs.conf --suffix staging --no-output
```

# Syntax

## Importing
Import will use the relative path from the file it imports to. Also keep in mind to not use the `.src` extension. It will automatically add the extension. (going to add a detection in the future for the extension to prevent any misuse)
**Note**: There was an issue in all versions bellow 0.2.0.0 which was caused by not using `@` when exporting. This is fixed now.
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

## Including
Include will use the relative path from the file it imports to. Also keep in mind to not use the `.src` extension. Unlike `import` this will not wrap the module. This will just purely put the content of a file into your script.
```
//File path: library/hello-world.src
hello = function()
	print("Hello world!")
end function

//File path: example.src
#include library/hello-world;

hello() //prints "Hello world!"
```

## Envar
Envar will put environment variables into your script. Just keep in mind to use the `--env-file /path/env.conf` parameter. This might be useful if you want to use different variables for different environments. Keep in mind that there's also a `--suffix local` parameter which might be helpful for this as well.
```
//File path: env.conf
random=SOME_VALUE

//File path: example.src
somevar = #envar random;

print(somevar) //prints "SOME_VALUE"
```

# Configuration

You can either use the configuration file in `/home/user-folder/Config/compile.conf` to setup the compiler. Or you can use the CLI arguments.

## Example config file:
```
COMMAND_START=#
COMMAND_END=;
TEMP_FOLDER=/home/$0/tmp
COMPILER_FOLDER=/home/$0/compiler
BOILERPLATE_FOLDER=boilerplates/$0.src
BIN_FOLDER=/usr/bin
SCRIPT_EXTENSION=src
DEBUG=false
VERSION=0.2.0.0
```

# Planned features

## Conditional blocks for on build
```
Lib = {}

#if (envar:ADD_FEATURE eq TRUE);
	Lib.myFeatureFunction = function()
		print("Feature implemented")
	end function
#endif;

if not Lib.hasIndex("myFeatureFunction") then
	print("Sorry feature is not implemented...")
end if
```

# Known issues

- files that use newline (\n) anywhere in a string of a file that should be compiled will lead to issues, you can use NEW_LINE_OPERATOR constant variable instead which is included into every header
```
line = "Hello\nWorld!".split(NEW_LINE_OPERATOR)
line[0] //Hello
line[1] //World!
```
