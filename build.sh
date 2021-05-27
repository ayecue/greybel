#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

config_file=$DIR/compile.conf
compile_file=$DIR/compile.src
boilerplate_header=$DIR/boilerplates/header.src
boilerplate_module=$DIR/boilerplates/module.src
boilerplate_main=$DIR/boilerplates/main.src

rm $DIR/installer.src
touch $DIR/installer.src

file=$DIR/installer.src

function realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

function print_debug() {
  echo "print(\"$1\")" >> $file
}

function create_folder() {
  echo "c.create_folder($1, $2)" >> $file
}

function create_file() {
  echo "c.touch($1, $2)" >> $file
}

function open_file() {
  echo "file = c.File($1)" >> $file
}

function write_file() {
  echo "Importing file $(realpath $1)..."
  echo "lines = []" >> $file
  n=1
  while read -r line || [ -n "$line" ]; do
    line=$(tr -d '\r\n' <<< "$line")
    line=$(sed 's/\"/\"\"/g' <<< "$line")

    echo "lines.push(\"$line\")" >> $file
    n=$((n+1))
  done < $1
  echo "file.set_content(lines.join(\"\n\"))" >> $file
}

echo "Building installer $(realpath $file)..."

echo "s = get_shell" >> $file
echo "c = s.host_computer" >> $file
echo "h = home_dir" >> $file

print_debug "Create compiler folder..."
create_folder "h" "\"compiler\""
create_folder "h" "\"tmp\""
create_file "h + \"/compiler\"" "\"compile.src\""
create_folder "h + \"/compiler\"" "\"boilerplates\""
create_file "h + \"/compiler/boilerplates\"" "\"header.src\""
create_file "h + \"/compiler/boilerplates\"" "\"main.src\""
create_file "h + \"/compiler/boilerplates\"" "\"module.src\""

print_debug "Create config file..."
create_file "h + \"/Config\"" "\"compile.conf\""

print_debug "Write config file..."
open_file "h + \"/Config/compile.conf\""
write_file $config_file

print_debug "Write compiler file..."
open_file "h + \"/compiler/compile.src\""
write_file $compile_file

print_debug "Write boilerplates header file..."
open_file "h + \"/compiler/boilerplates/header.src\""
write_file $boilerplate_header

print_debug "Write boilerplates module file..."
open_file "h + \"/compiler/boilerplates/module.src\""
write_file $boilerplate_module

print_debug "Write boilerplates main file..."
open_file "h + \"/compiler/boilerplates/main.src\""
write_file $boilerplate_main

echo "Execute installer in Grey Hack now:"
echo "build installer.src /usr/bin"
echo "installer"
