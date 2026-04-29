wtf() {
    # 1. Get the last command
    local last_cmd=$(fc -ln -1 | sed "s/^[ \t]*//")

    if [[ -z "$last_cmd" || "$last_cmd" == "wtf" ]]; then
        echo -e "\033[31mNo previous command found to correct.\033[0m"
        return 1
    fi

    echo -e "\033[90mwtf happend with: $last_cmd\033[0m"

    # 2. Capture the output of the failed command (stdout and stderr)
    # Note: We re-run it. Use with caution for commands with side effects!
    local cmd_output=$(eval "$last_cmd" 2>&1)

    # 3. Send both the command AND the error to the AI
    local prompt="The user ran this command: '$last_cmd'
It failed with this output:
'$cmd_output'

Output ONLY the raw, corrected shell command to fix this. No markdown, no backticks, no filler."

    local raw_output=$(echo "$prompt" | ai)
    local suggestion=$(echo "$raw_output" | grep -v '```' | awk 'NF')

    if [[ -z "$suggestion" ]]; then
        echo -e "\033[31mCould not generate a correction.\033[0m"
        return 1
    fi

    echo -e "\033[94mSuggested:\033[0m $suggestion"
    
    printf "Run this? [Y/n]: "
    read -r choice
    
    if [[ -z "$choice" || "$choice" == [Yy]* ]]; then
        # Add the fix to history so you can up-arrow to it later
        print -s "$suggestion" 2>/dev/null || history -s "$suggestion" 2>/dev/null
        eval "$suggestion"
    else
        echo "Cancelled."
    fi
}