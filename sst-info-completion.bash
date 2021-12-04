# Read variables from file. Generating strings for ele_bar is too slow to do on every tab.
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
#elements=$(<$SCRIPT_DIR/elements.txt)
#comp=$(<$SCRIPT_DIR/components.txt)
ele_bar=$(cat $SCRIPT_DIR/elements.txt | sed 's/ /|/g')

#vvvvvvvvvvvvvvvv
elements=$(sst-info 2>/dev/null | grep ELEMENT | tail -n +2 | cut -d' ' -f 4)

for ele in $elements
do
   comp="$comp"$(sst-info $ele | grep "SubComponent " | tr -d [:blank:] | sed -r 's/SubComponent[[:digit:]]+://' | sed "s/^/$ele./")
done
#vvvvvvvvvvvvvvvv

ele_bar=$(echo $elements | sed 's/ /|/g')

## Get all components
#for ele in $elements
#do
#    comp="$comp"$(sst-info $ele | grep "SubComponent " | tr -d [:blank:] | sed 's/SubComponent.://' | sed "s/^/$ele./")
#done

_sst-info_completions ()
{
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
      return
    fi

    local argument=${COMP_WORDS[1]}

   if [[ "$argument" =~ ^($ele_bar)$ ]];
   then
      # Asking for the completion of an element will appened a dot
      local suggestions=($(compgen -W "$ele_dot" "${COMP_WORDS[1]}"))
      COMPREPLY="${COMP_WORDS[1]}""."
   elif [[ "$argument" == *"."* ]];
   then
      # Asking for the completion of a word containing a dot will show completions from
      # the components list
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

complete -o nospace -F _sst-info_completions sst-info

