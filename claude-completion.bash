#!/usr/bin/env bash
# Bash completion script for Claude Code
# Install: source this file or place it in /etc/bash_completion.d/

_claude_completion() {
    local cur prev words cword
    _init_completion || return

    # Commands
    local commands="agents auth mcp plugin setup-token doctor update upgrade install"

    # Global options
    local global_opts="
        --debug --debug-file --verbose --print --output-format --json-schema
        --include-partial-messages --input-format --mcp-debug
        --dangerously-skip-permissions --allow-dangerously-skip-permissions
        --max-budget-usd --replay-user-messages --allowedTools --allowed-tools
        --tools --disallowedTools --disallowed-tools --mcp-config
        --system-prompt --append-system-prompt
        --permission-mode
        --continue --resume --fork-session --no-session-persistence
        --model --agent --betas --fallback-model --settings --add-dir
        --ide --strict-mcp-config --session-id --agents --setting-sources
        --plugin-dir --disable-slash-commands --chrome --no-chrome
        --from-pr --file --worktree --tmux
        --effort --version --help
        -d -p -c -r -v -w -h
    "

    # Handle subcommands
    local i cmd
    for ((i=1; i < cword; i++)); do
        if [[ ${words[i]} != -* ]]; then
            cmd=${words[i]}
            break
        fi
    done

    # If we're completing the first argument (command or option)
    if [[ $cword -eq 1 ]] || [[ -z $cmd ]]; then
        case "$cur" in
            -*)
                COMPREPLY=($(compgen -W "$global_opts" -- "$cur"))
                return 0
                ;;
            *)
                COMPREPLY=($(compgen -W "$commands" -- "$cur"))
                return 0
                ;;
        esac
    fi

    # Subcommand-specific completion
    case "$cmd" in
        auth)
            local auth_cmds="login logout status"
            local auth_subcmd
            for ((i=2; i < cword; i++)); do
                if [[ ${words[i]} != -* ]]; then
                    auth_subcmd=${words[i]}
                    break
                fi
            done
            case "$auth_subcmd" in
                login)
                    case "$prev" in
                        --email)
                            COMPREPLY=()
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--email --sso --help -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                logout)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                status)
                    COMPREPLY=($(compgen -W "--json --text --help -h" -- "$cur"))
                    ;;
                *)
                    COMPREPLY=($(compgen -W "$auth_cmds --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        mcp)
            local mcp_cmds="add add-from-claude-desktop add-json get list remove reset-project-choices serve"
            local mcp_subcmd
            for ((i=2; i < cword; i++)); do
                if [[ ${words[i]} != -* ]]; then
                    mcp_subcmd=${words[i]}
                    break
                fi
            done
            case "$mcp_subcmd" in
                add)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                            ;;
                        -t|--transport)
                            COMPREPLY=($(compgen -W "stdio sse http" -- "$cur"))
                            ;;
                        -e|--env|-H|--header|--callback-port|--client-id)
                            COMPREPLY=()
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --transport --env --header --callback-port --client-id --client-secret --help -s -t -e -H -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                add-from-claude-desktop)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                add-json)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --client-secret --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                get)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                remove)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                list)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                reset-project-choices)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                serve)
                    COMPREPLY=($(compgen -W "--debug --verbose --help -d -h" -- "$cur"))
                    ;;
                *)
                    COMPREPLY=($(compgen -W "$mcp_cmds --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        plugin)
            local plugin_cmds="disable enable install list marketplace uninstall update validate"
            local plugin_subcmd
            for ((i=2; i < cword; i++)); do
                if [[ ${words[i]} != -* ]]; then
                    plugin_subcmd=${words[i]}
                    break
                fi
            done
            case "$plugin_subcmd" in
                marketplace)
                    local mp_subcmd
                    for ((i=3; i < cword; i++)); do
                        if [[ ${words[i]} != -* ]]; then
                            mp_subcmd=${words[i]}
                            break
                        fi
                    done
                    case "$mp_subcmd" in
                        "")
                            COMPREPLY=($(compgen -W "add list remove update --help -h" -- "$cur"))
                            ;;
                        add)
                            case "$prev" in
                                --scope)
                                    COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                                    ;;
                                --sparse)
                                    COMPREPLY=()
                                    ;;
                                *)
                                    COMPREPLY=($(compgen -W "--scope --sparse --help -h" -- "$cur"))
                                    ;;
                            esac
                            ;;
                        list)
                            COMPREPLY=($(compgen -W "--json --help -h" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                install)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                list)
                    COMPREPLY=($(compgen -W "--available --json --help -h" -- "$cur"))
                    ;;
                disable)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--all --scope --help -a -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                enable)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                uninstall)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                update)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local managed" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                validate)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                *)
                    COMPREPLY=($(compgen -W "$plugin_cmds --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        setup-token)
            COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
            ;;
        doctor)
            COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
            ;;
        update|upgrade)
            COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
            ;;
        install)
            case "$prev" in
                install)
                    COMPREPLY=($(compgen -W "stable latest --force --help -h" -- "$cur"))
                    ;;
                *)
                    COMPREPLY=($(compgen -W "stable latest --force --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        agents)
            case "$prev" in
                --setting-sources)
                    COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                    ;;
                *)
                    COMPREPLY=($(compgen -W "--setting-sources --help -h" -- "$cur"))
                    ;;
            esac
            ;;
    esac

    # Option-specific value completion
    case "$prev" in
        --output-format)
            COMPREPLY=($(compgen -W "text json stream-json" -- "$cur"))
            ;;
        --input-format)
            COMPREPLY=($(compgen -W "text stream-json" -- "$cur"))
            ;;
        --permission-mode)
            COMPREPLY=($(compgen -W "acceptEdits bypassPermissions default dontAsk plan" -- "$cur"))
            ;;
        --model|--fallback-model)
            COMPREPLY=($(compgen -W "sonnet opus haiku claude-sonnet-4-6" -- "$cur"))
            ;;
        --setting-sources)
            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
            ;;
        --effort)
            COMPREPLY=($(compgen -W "low medium high" -- "$cur"))
            ;;
        --json-schema|--system-prompt|--append-system-prompt|--agents)
            # These expect custom input, don't suggest anything
            COMPREPLY=()
            ;;
        --mcp-config|--settings|--plugin-dir|--add-dir|--file|--debug-file)
            # File/directory completion
            _filedir
            ;;
        --worktree|--max-budget-usd|--session-id|--debug|--from-pr)
            # Custom values, no completion
            COMPREPLY=()
            ;;
        -r|--resume)
            # Could potentially list session IDs, but skip for now
            COMPREPLY=()
            ;;
        *)
            # Default: suggest global options if not in a subcommand
            if [[ -z $cmd ]]; then
                COMPREPLY=($(compgen -W "$global_opts" -- "$cur"))
            fi
            ;;
    esac

    return 0
}

complete -F _claude_completion claude
# Support common alias 'cc'
complete -F _claude_completion cc
