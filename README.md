# Greybel 0.4.1.0

## Deprecated in favor of [greybel-js](https://github.com/ayecue/greybel-js)

GreyScript preprocessor ([GreyHack](https://store.steampowered.com/app/605230/Grey_Hack/). Which adds new features to GreyScript.

For examples lookup [this repository](https://github.com/ayecue/greyscript-library).

Features:
- import files, used to load other files into script
- building creates temporary file for better debugging
- wraps imported files in function block to prevent variable shadowing
- include which unlike import just copy paste its content
- envar which puts values from one file, multiple env files or building params into the script
- minimizing your script, depending on the size of your project you can save up to 40%
- please note that minimizing can take some time depending on the file size if it's to slow turn it off via `--no-uglify` (speed improvements in the next updates with tokenization instead of actual string operations - unsure how much that will save though)

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
Version: 0.4.0.0
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
-nu --no-uglify - No uglify/minimizing
-so --source-only - Only output source instead of binary 
-o --obfuscate - Obfuscate code
```

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

Since `0.4.0.0` you can use multiple env files `--env-file /path/default.conf --env-file /path/env.conf`.

Another feature with `0.4.0.0` is that you can actually can put comments into the env file.

Since `0.4.1.0` you can use `--env-var MY_VAR=MY_VALUE` to set environment variables as well.
```
//File path: env.conf
# MY COMMENT
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
VERSION=0.4.1.0
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
