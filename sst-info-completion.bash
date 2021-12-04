_sst-info_completions()
{
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi

    local elements=$(sst-info 2>/dev/null | grep ELEMENT | tail -n +2 | cut -d' ' -f 4)
    local suggestions=($(compgen -W "$elements" "${COMP_WORDS[1]}"))
    
    if [ "${#suggestions[@]}" == "1" ]; then
        # if there's only one match, we remove the command literal
        # to proceed with the automatic completion of the number
        local ele=$(echo ${suggestions[0]})
        COMPREPLY=("$ele")
    else
        # more than one suggestions resolved,
        # respond with the suggestions intact
        COMPREPLY=("${suggestions[@]}")
    fi
}
complete -F _sst-info_completions sst-info
