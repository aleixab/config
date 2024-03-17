_gita_completions() {
    local -a commands
    local -a repos
    local curcontext="$curcontext" state line

    # Gather commands
    commands=($(gita -h | sed '2q;d' | tr -d '{}' | tr ',' ' '))

    # Gather repos
    repos=($(gita ls))

    _arguments -C \
        '1: :->cmds' \
        '*:: :->args'

    case $state in
        cmds)
            _describe "command" commands && ret=0
            ;;
        args)
            case $line[1] in
                add)
                    _files && ret=0
                    ;;
                *)
                    _describe "repository" repos && ret=0
                    ;;
            esac
            ;;
    esac

    return $ret
}

# Associate the function with gita command
compdef _gita_completions gita
