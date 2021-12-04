# sst-info-completions.bash
# This file provides bash autocompletion functionality for sst-info.
# Author: Patrick Lavin

# Use sst-info to find all installed elements
elements=$(sst-info 2>/dev/null | grep ELEMENT | tail -n +2 | cut -d' ' -f 4)

# Find every element in every component.
for ele in $elements
do
    comp="$comp"$(sst-info $ele | grep "SubComponent " | tr -d [:blank:] | sed -r 's/SubComponent[[:digit:]]+://' | sed "s/^/$ele./")
done

# Create a regex string with | between each component.
ele_bar=$(echo $elements | sed 's/ /|/g')


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
       local suggestions=($(compgen -W "$ele_dot" "${COMP_WORDS[1]}"))
       COMPREPLY="${COMP_WORDS[1]}""."
    elif [[ "$argument" == *"."* ]];
    then
       # Asking for the completion of a word containing a dot will show completions from
       # the components list. Diable nospace for these completions.
       local suggestions=($(compgen -W "$comp" "${COMP_WORDS[1]}"))
       COMPREPLY=("${suggestions[@]}")
       compopt +o nospace
    else
       # If you're here, you've typed something that isn't a complete element name and don't have
       # a period, so try to complete with element names
       local suggestions=($(compgen -W "$elements" "${COMP_WORDS[1]}"))
       COMPREPLY=("${suggestions[@]}")
    fi
}

# Use nospace so we can do the trick with adding a period
complete -o nospace -F _sst-info_completions sst-info

