#!/bin/bash
#
# Author: Diogo Alexsander Cavilha <diogocavilha@gmail.com>
# Date:   06.08.2018

# ----------------------------------------------------------------------------------------------------------------------
# The main function to change the prompt.
# ----------------------------------------------------------------------------------------------------------------------
fancygit_theme_builder() {
    start_all=$(date +%s%3N)
    
    # THIS WAS TAKING TOO LONG SO COMMENTED IT OUT
    start=$(date +%s%3N)

    # COMMENT THIS OUT IF YOU FIND THINGS SLOW
    check_for_update
    end=$(date +%s%3N)  # Current time in milliseconds
    duration=$((end-start))
    echo "0 took ${duration} milliseconds" >> ~/timings.txt


    # !! IMPORTANT !!
    # If you're just interested on creating a new color scheme, please have a look at $HOME/.fancy-git/color_schemes.
    # Everything you need to do is creating a new file to the color scheme you wish to create.
    local color_scheme
    color_scheme=$(fancygit_config_get "color_scheme" "default_default")

    # Load the color scheme.
    # shellcheck source=/dev/null
    # start=$(date +%s%3N)
    . "${HOME}/.fancy-git/color_schemes/${color_scheme}"
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "1 took ${duration} milliseconds" >> ~/timings.txt


    # !! WARNING !!
    # From here you better now what you're doing. Have fun =D

    # Create color tags to change prompt style.
    local time_color_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_TIME_FOREGROUND}m\\]"
    local time_color_bg_tag="\\[\\e[48;5;${FANCYGIT_COLOR_SCHEME_TIME_BACKGROUND}m\\]"
    local time_symbol_color_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_TIME_BACKGROUND}m\\]"
    local user_color_font_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_USER_FOREGROUND}m\\]"
    local host_color_font_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_HOST_FOREGROUND}m\\]"
    local at_color_font_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_AT_FOREGROUND}m\\]"
    local user_symbol_color_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_USER_SYMBOL_BACKGROUND}m\\]"
    local user_symbol_color_bg_tag="\\[\\e[48;5;${FANCYGIT_COLOR_SCHEME_USER_SYMBOL_BACKGROUND}m\\]"
    local user_symbol_color_font_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_USER_SYMBOL_FOREGROUND}m\\]"
    local workdir_color_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_WORKDIR_BACKGROUND}m\\]"
    local workdir_color_bg_tag="\\[\\e[48;5;${FANCYGIT_COLOR_SCHEME_WORKDIR_BACKGROUND}m\\]"
    local workdir_color_font_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_WORKDIR_FOREGROUND}m\\]"
    local user_at_host_color_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_USER_AT_HOST_BACKGROUND}m\\]"
    local user_at_host_color_bg_tag="\\[\\e[48;5;${FANCYGIT_COLOR_SCHEME_USER_AT_HOST_BACKGROUND}m\\]"
    local branch_color_staged_files_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_BRANCH_STAGED_FILES_BACKGROUND}m\\]"
    local branch_color_staged_files_bg_tag="\\[\\e[48;5;${FANCYGIT_COLOR_SCHEME_BRANCH_STAGED_FILES_BACKGROUND}m\\]"
    local branch_color_staged_files_font_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_BRANCH_STAGED_FILES_FOREGROUND}m\\]"
    local branch_color_changed_files_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_BRANCH_CHANGED_FILES_BACKGROUND}m\\]"
    local branch_color_changed_files_bg_tag="\\[\\e[48;5;${FANCYGIT_COLOR_SCHEME_BRANCH_CHANGED_FILES_BACKGROUND}m\\]"
    local branch_color_changed_files_font_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_BRANCH_CHANGED_FILES_FOREGROUND}m\\]"
    local branch_color_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_BRANCH_BACKGROUND}m\\]"
    local branch_color_bg_tag="\\[\\e[48;5;${FANCYGIT_COLOR_SCHEME_BRANCH_BACKGROUND}m\\]"
    local branch_color_font_tag="\\[\\e[38;5;${FANCYGIT_COLOR_SCHEME_BRANCH_FOREROUND}m\\]"
    local none="\\[\\e[39m\\]"
    local bold_none="\\[\\e[0m\\]"
    local bg_none="\\[\\e[49m\\]"

    # Prompt style
    # start=$(date +%s%3N)
    local separator
    separator=$(fancygit_config_get "separator" "")
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "2 took ${duration} milliseconds" >> ~/timings.txt


    local icon_git_repo=""
    local user="${user_color_font_tag}"
    local at="${at_color_font_tag}"
    local host="${host_color_font_tag}"
    local user_at_host="${user_at_host_color_bg_tag}"
    local user_at_host_end="${bold_none}${bg_none}${user_at_host_color_tag}${user_symbol_color_bg_tag}${separator}"
    local user_symbol="${user_symbol_color_bg_tag}${user_symbol_color_font_tag}"
    local user_symbol_end="${none}${bold_none}${bg_none}${user_symbol_color_tag}${workdir_color_bg_tag}${separator}"
    local path="${workdir_color_bg_tag}${workdir_color_font_tag}"
    local path_git="${workdir_color_bg_tag}${workdir_color_font_tag} ${icon_git_repo} "
    local path_end="${none}${bold_none}"
    local branch="${workdir_color_tag}${branch_color_bg_tag}${separator}${branch_color_font_tag}"
    local branch_end="${branch_color_tag}${bg_none}${separator}${bold_none}${none}"
    local time="${time_color_bg_tag}${time_color_tag}"
    local time_end="${bold_none}${bg_none}"
    local prompt_time
    local prompt_user
    local prompt_env
    local prompt_path
    local prompt_double_line
    local notification_area
    local is_rich_notification
    local time_raw

    # start=$(date +%s%3N)
    time_raw="$(fancygit_theme_get_time)"
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "3 took ${duration} milliseconds" >> ~/timings.txt


    # When time background color and user background color are the same, we need to add a separator between time and username.
    # This prevents a weird presentation. Life is not easy :/
    if [[ "$FANCYGIT_COLOR_SCHEME_TIME_BACKGROUND" != "$FANCYGIT_COLOR_SCHEME_USER_AT_HOST_BACKGROUND" && "" != "$time_raw" ]]
    then
        time_end="${bold_none}${bg_none}${time_symbol_color_tag}${user_at_host_color_bg_tag}${separator} "
    fi

    # start=$(date +%s%3N)
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "4 took ${duration} milliseconds" >> ~/timings.txt


    # start=$(date +%s%3N)
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "5 took ${duration} milliseconds" >> ~/timings.txt


    # Get some theme config.
    prompt_time="${time}${time_raw}${time_end}"
    # start=$(date +%s%3N)
    prompt_path=$(fancygit_theme_get_path_sign)
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "6 took ${duration} milliseconds" >> ~/timings.txt

    prompt_symbol="${user_symbol} \$ ${user_symbol_end}"
    # start=$(date +%s%3N)
    prompt_double_line=$(fancygit_theme_get_double_line)
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "7 took ${duration} milliseconds" >> ~/timings.txt


    if fancygit_config_is "show_user_at_machine" "true"
    then
        local user_name
        local host_name
        user_name=$(fancygit_config_get "user_name" "\\u")
        host_name=$(fancygit_config_get "host_name" "\\h")
        prompt_user="${user_at_host}${user}${user_name}${none}${at}@${none}${host}${host_name}${none} ${user_at_host_end}"
    fi

    # start=$(date +%s%3N)
    branch_name=$(fancygit_git_get_branch)
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "8 took ${duration} milliseconds" >> ~/timings.txt

    start_middle=$(date +%s%3N)
    if [ "" = "$branch_name" ]
    then
        # No branch found, so we're not in a git repo.
        prompt_env=$(__fancygit_get_venv_icon)
        prompt_path="${path}${prompt_env} ${prompt_path} ${path_end}${workdir_color_tag}${separator}${none}"
        PS1="${prompt_time}${prompt_user}${prompt_symbol}${prompt_path}${prompt_double_line} "
        return
    fi

    if [ "HEAD" = "$branch_name" ]
    then
        # start=$(date +%s%3N)
        branch_name=$(fancygit_git_get_tag)
        # end=$(date +%s%3N)  # Current time in milliseconds
        # duration=$((end-start))
        # echo "9 took ${duration} milliseconds" >> ~/timings.txt

    fi

    # We're in a git repo =D
    # We have a branch name, it means we are in a git repo, so we need to make some more changes on PS1...

    # Get some config preferences.
    # start=$(date +%s%3N)
    is_rich_notification=$(fancygit_config_get "show_rich_notification" "true")
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "10 took ${duration} milliseconds" >> ~/timings.txt


    # NOTE: if you're having issues with speed, comment this out
    # Configure a specific background color to branch name, if it has staged files.
    if [ "" != "$(fancygit_git_get_staged_files)" ]
    then
        branch="${workdir_color_tag}${branch_color_staged_files_bg_tag}${separator}${branch_color_staged_files_font_tag}"
        branch_end="${bg_none}${bold_none}${branch_color_staged_files_tag}${separator}${none}"




    # NOTE: COMMENTED THIS OUT BECAUSE THEY"RE REALLY SLOW!

    # Configure a specific background color to branch name, if it has some change.
    # elif [ "" != "$(fancygit_git_get_changed_files)" ]
    # then
    #     branch="${workdir_color_tag}${branch_color_changed_files_bg_tag}${separator}${branch_color_changed_files_font_tag}"
    #     branch_end="${bg_none}${bold_none}${branch_color_changed_files_tag}${separator}${none}"
    fi

    # start_half=$(date +%s%3N)
    # duration_middle=$((start_half-start_middle))
    # echo "middle took ${duration_middle} milliseconds" >> ~/timings.txt

    notification_area=$(fancygit_get_notification_area "$is_rich_notification")
    # start=$(date +%s%3N)
    prompt_path="${path_git}${notification_area} ${prompt_path} ${path_end}"
    # end=$(date +%s%3N)  # Current time in milliseconds
    # duration=$((end-start))
    # echo "11 took ${duration} milliseconds" >> ~/timings.txt

    prompt_branch="${branch} $(fancygit_git_get_branch_icon "${branch_name}") ${branch_name} ${branch_end}"
    PS1="${prompt_time}${prompt_user}${prompt_symbol}${prompt_path}${prompt_branch}${prompt_double_line} "
    # end_all=$(date +%s%3N)  # Current time in milliseconds
    # duration_all=$((end_all-start_half))
    # duration_2nd_half=$((end_all-start_half))
    # echo "2nd half took ${duration_2nd_half} milliseconds" >> ~/timings.txt
    # duration_all=$((end_all-start_all))
    # echo "ALL took ${duration_all} milliseconds" >> ~/timings.txt
    
}

# Here's where the magic happens!
# It calls our main function (fancygit_theme_builder) in order to mount a beautiful PS1 prompt =D
