#!/usr/bin/env bash

# sst-info-completions.bash
# This file provides bash autocompletion functionality for sst-info.
# Author: Patrick Lavin

# Use sst-info to find all installed elements
elements=$(sst-info 2>/dev/null | grep ELEMENT | tail -n +2 | cut -d' ' -f 4)

# Find every component and subcomponent, form strings like "element.subcomponent", and append them to the component list.
components=""
for ele in $elements
do
    components="$components"$(sst-info "$ele" | grep "SubComponent [[:digit:]]\+" | tr -d "[:blank:]" | sed -r 's/SubComponent[[:digit:]]+://' | sed "s/^/$ele./")
    components="$components "
    components="$components"$(sst-info "$ele" | grep " Component [[:digit:]]\+:" | tr -d "[:blank:]" | sed -r 's/Component[[:digit:]]+://' | sed "s/^/$ele./")
    components="$components "
done

# Create a regex string with | between each component.
ele_bar="${elements//$'\n'/|}"

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
        # If you're here, you've typed something that isn't a complete element name and don't have
        # a period, so try to complete with element names
        mapfile -t COMPREPLY < <(compgen -W "$elements" "$argument")
    fi
}

# Use nospace so we can do the trick with adding a period
complete -o nospace -F _sst-info_completions sst-info

