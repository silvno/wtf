# wtf.sh

wtf() {
    local last_cmd=$(fc -ln -1 | sed "s/^[ \t]*//")

    if [[ -z "$last_cmd" || "$last_cmd" == "wtf" ]]; then
        echo -e "\033[31mNo previous command found to correct.\033[0m"
        return 1
    fi

    echo -e "\033[90mThinking about: $last_cmd\033[0m"

    local raw_output=$(echo "$last_cmd" | ai "This shell command failed or has a typo. Output ONLY the raw, corrected shell command. No markdown formatting, no backticks, no conversational filler. I need to execute your output directly.")
    local suggestion=$(echo "$raw_output" | grep -v '```' | awk 'NF')

    if [[ -z "$suggestion" ]]; then
        echo -e "\033[31mCould not generate a correction.\033[0m"
        return 1
    fi

    echo -e "\033[94mSuggested:\033[0m $suggestion"
    
    printf "Run this? [Y/n]: "
    read -r choice
    
    if [[ -z "$choice" || "$choice" == [Yy]* ]]; then
        print -s "$suggestion" 2>/dev/null || history -s "$suggestion" 2>/dev/null
        eval "$suggestion"
    else
        echo "Cancelled."
    fi
}
