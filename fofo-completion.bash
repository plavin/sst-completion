ele="mem nic"
ele_bar="mem|nic"
ele_dot="mem. nic."
mem_comp="mem.f1 mem.f2"
nic_comp="nic.f1 nic.f2"

_fofo_completions()
{
   if [ "${#COMP_WORDS[@]}" != "2" ]; then
      return
   fi

   if [[ "${COMP_WORDS[1]}" =~ ^($ele_bar)$ ]];
   then
      local suggestions=($(compgen -W "$ele_dot" "${COMP_WORDS[1]}"))
      COMPREPLY="${COMP_WORDS[1]}""."
   else
      local suggestions=($(compgen -W "$ele" "${COMP_WORDS[1]}"))
      COMPREPLY=("${suggestions[@]}")
   fi
   # 
   # if [ "${#suggestions[@]}" == "1" ]; then
   #     # if there's only one match, we remove the command literal
   #     # to proceed with the automatic completion of the number
   #     local ele=$(echo ${suggestions[0]})
   #     COMPREPLY=("$ele")
   # else
   #     # more than one suggestions resolved,
   #     # respond with the suggestions intact
   #     COMPREPLY=("${suggestions[@]}")
   # fi
    #COMPREPLY=("${suggestions[@]}")

}
#complete -F _fofo_completions fofo
complete -o nospace -F _fofo_completions fofo
