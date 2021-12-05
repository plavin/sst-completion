#!/usr/bin/env bash

# sst-info-completions.bash
# This file provides bash autocompletion functionality for sst-info.
# Author: Patrick Lavin

# Use sst-info to find all installed elements
elements=$(sst-info 2>/dev/null | grep ELEMENT | tail -n +2 | cut -d' ' -f 4)

# Find every component and subcomponent, form strings like "element.subcomponent", and append them to the component list.
comp=""
for ele in $elements
do
    comp="$comp"$(sst-info "$ele" | grep "SubComponent [[:digit:]]\+" | tr -d "[:blank:]" | sed -r 's/SubComponent[[:digit:]]+://' | sed "s/^/$ele./")
    comp="$comp "
    comp="$comp"$(sst-info "$ele" | grep " Component [[:digit:]]\+:" | tr -d "[:blank:]" | sed -r 's/Component[[:digit:]]+://' | sed "s/^/$ele./")
    comp="$comp "
done

# Create a regex string with | between each component.
ele_bar="${elements//$'\n'/|}"

_sst-info_completions ()
{
    # Only suggest on the first argument
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
      return
    fi

    # Grab the word we're trying to complete
    local argument=${COMP_WORDS[1]}

    if [[ "$argument" =~ ^($ele_bar)$ ]];
    then
       # Asking for the completion of an element will appened a dot
       COMPREPLY=("$argument"".")
    elif [[ "$argument" == *"."* ]];
    then
       # Asking for the completion of a word containing a dot will show completions from
       # the components list. Diable nospace for these completions.
       mapfile -t suggestions < <(compgen -W "$comp" "$argument")
       COMPREPLY=("${suggestions[@]}")
       compopt +o nospace
    else
       # If you're here, you've typed something that isn't a complete element name and don't have
       # a period, so try to complete with element names
       mapfile -t suggestions < <(compgen -W "$elements" "$argument")
       COMPREPLY=("${suggestions[@]}")
    fi
}

# Use nospace so we can do the trick with adding a period
complete -o nospace -F _sst-info_completions sst-info

