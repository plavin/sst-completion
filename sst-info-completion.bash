#!/usr/bin/env bash

# sst-info-completions.bash
# This file provides bash autocompletion functionality for sst-info.
# Author: Patrick Lavin

# Use sst-info to find all installed elements
elements=$(sst-info 2>/dev/null | sed -n "s/ELEMENT [[:digit:]]\+ = //p" | cut -d' ' -f1)
# Create a list of elements but replace spaces with '|'
ele_bar="${elements//$'\n'/|}"

# Regex used in generating component names.
# Example matches: "SubComponent1:", "Component13:"
regex='\(Sub\)\{0,1\}Component[[:digit:]]\+:'

# Find every component and subcomponent, form strings like "element.subcomponent",
# and append them to the component list.
components=""
for ele in $elements
do
    # [Pipes] Get element info | remove whitespace | find lines with (sub)component names, remove the word (Sub)Component
    # | prepend the element name.
    components="$components"$(sst-info "$ele" | tr -d "[:blank:]" | sed -n "s/$regex//p" | sed "s/^/$ele./")
    components="$components "
done

_sst-info_completions ()
{
    # Only suggest on the first argument
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
      return
    fi

    # Grab the word we're trying to complete. The basename is everything before the first period.
    local argument=${COMP_WORDS[1]}
    local basename=${argument%%.*}

    if [[ "$basename" =~ ^($ele_bar)$ ]];
    then
        # If the argument begins with an element name, then we switch to the component list.
        mapfile -t COMPREPLY < <(compgen -W "$components" "$argument")
        compopt +o nospace
    else
        # If you're here, you've typed something that isn't a complete element name
        # so try to complete with element names
        mapfile -t COMPREPLY < <(compgen -W "$elements" "$argument")
    fi
}

# Use nospace so we can do the trick with adding a period
complete -o nospace -F _sst-info_completions sst-info

