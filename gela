#!/usr/bin/env bash

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
DEFAULT_FG="$(printf '\033[39m')"  DEFAULT_BG="$(printf '\033[49m')"

## Directories
ALACRITTY_DIR="$HOME/.config/alacritty"
LIGHT_DIR='/usr/local/share/gelacritty/colors/light'
DARK_DIR='/usr/local/share/gelacritty/colors/dark'
FONTS_DIR='/usr/local/share/fonts/gelacritty'

## Banner
banner () {
    clear
    echo "
    
    ${ORANGE}╭━━━┳━━━┳╮╱╱╭━━━╮
    ${ORANGE}┃╭━╮┃╭━━┫┃╱╱┃╭━╮┃
    ${ORANGE}┃┃╱╰┫╰━━┫┃╱╱┃┃╱┃┃
    ${ORANGE}┃┃╭━┫╭━━┫┃╱╭┫╰━╯┃
    ${ORANGE}┃╰┻━┃╰━━┫╰━╯┃╭━╮┃
    ${ORANGE}╰━━━┻━━━┻━━━┻╯╱╰╯
    ${ORANGE}☴ ${CYAN}T̼I̼L̼L̼ ̼I̼T̼'̼S̼ ̼G̼O̼N̼E̼ ${ORANGE}☴
    ${ORANGE}☴☴☴☴☴☴☴☴☴☴☴☴☴☴☴☴☴☴ 
    "
}

exit_on_signal_SIGINT () {
    { printf "\n\n%s\n" "    ${BLUE}[${RED}*${BLUE}] ${RED}Script interrupted." 2>&1; echo; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM () {
    { printf "\n\n%s\n" "    ${BLUE}[${RED}*${BLUE}] ${RED}Script terminated." 2>&1; echo; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}
 
## Available color-schemes & fonts
check_files () {
    if [[ "$1" = light ]]; then
        light=($(ls $LIGHT_DIR | egrep '\.yml$'))
        echo ${#light[@]}
    elif [[ "$1" = dark ]]; then
        dark=($(ls $DARK_DIR | egrep '\.yml$'))
        echo ${#dark[@]}
    elif [[ "$1" = fonts ]]; then
        fonts=($(ls $FONTS_DIR))
        echo ${#fonts[@]}
    fi
    return
}

total_light=$(check_files light)
total_dark=$(check_files dark)
total_fonts=$(check_files fonts)

## Reload Settings
reload_settings () {
    echo "    ${BLUE}[${RED}*${BLUE}] ${MAGENTA}Reloading Settings..."
    alacritty @ set-colors --all $ALACRITTY_DIR/gelacritty.yml > /dev/null
    { echo "    ${BLUE}[${RED}*${BLUE}] ${GREEN}Applied Successfully."; echo; }
    return
}

## Apply color-schemes
apply_select () {
    { read -n 1 -p ${BLUE}"    [D]${RED}Dark ${CYAN}or ${BLUE}[L]${RED}Light${BLUE}? ${GREEN}"; echo; }

    if [[ "$REPLY" =~ ^[l/L/d/D/q/Q]$ ]]; then      #validate input
        if [[ "$REPLY" =~ ^[l/L]$ ]]; then
            select_light
            { reset_color; exit; }   #TODO reload_settings; 
        elif [[ "$REPLY" =~ ^[d/D]$ ]]; then
            select_dark
            { reset_color; exit; } #TODO reload_settings; 
        fi 
    else
        echo -n "    ${BLUE}[${RED}!${BLUE}] ${RED}Invalid Option, Try Again."
        { sleep 1; banner; echo; apply_select; }
    fi
}
 
select_light () {
    local count=1

    # List the color-schemes
    # ls $LIGHT_DIR --color=yes | nl | less -R
    color_schemes=($(ls $LIGHT_DIR | egrep '\.yml$'))
    for colors in "${color_schemes[@]}"; do
        colors_name=$(echo $colors)
        echo ${ORANGE}"    [$count] ${colors_name%.*}"
        count=$(($count+1))
    done

    # Read user selection
    { echo; read -p ${BLUE}"    [${RED}Select Color Scheme (1 to $total_dark)${BLUE}]: ${GREEN}" answer; echo; }

    # Apply color-scheme
    if [[ (-n "$answer") && ("$answer" -le $total_dark) ]]; then
        { banner; echo;}
        scheme=${color_schemes[(( answer - 1 ))]}
        echo "    ${BLUE}[${RED}*${BLUE}] ${ORANGE}Theme Set To: ${scheme##*/}"
        if ! cp --force "${LIGHT_DIR}/${scheme}" "${ALACRITTY_DIR}/gelacritty.yml" &>/dev/null; then
            printf '%s\n' "Failed to apply theme!" >&2
            return 1
        fi
    else
        echo -n "    ${BLUE}[${RED}!${BLUE}] ${RED}Invalid Option, Try Again."
        { sleep 1; banner; echo; select_light; }
    fi
    return
}
 
select_dark () {
    local count=1

    # List the color-schemes
    color_schemes=($(ls $DARK_DIR | egrep '\.yml$'))
    # ls $DARK_DIR --color=yes | nl | less -R
    for colors in "${color_schemes[@]}"; do
        colors_name=$(echo $colors)
        echo ${ORANGE}"    [$count] ${colors_name%.*}"
        count=$(($count+1))
    done

    # Read user selection
    { echo; read -p ${BLUE}"    [${RED}Select Color Scheme (1 to $total_dark)${BLUE}]: ${GREEN}" answer; echo; }

    # Apply color-scheme
    if [[ (-n "$answer") && ("$answer" -le $total_dark) ]]; then
        { banner; echo;}
        scheme=${color_schemes[(( answer - 1 ))]}
        echo "    ${BLUE}[${RED}*${BLUE}] ${ORANGE}Theme Set To: ${scheme##*/}"
        if ! cp --force "${DARK_DIR}/${scheme}" "${ALACRITTY_DIR}/gelacritty.yml" &>/dev/null; then
            printf '%s\n' "Failed to apply theme!" >&2
            return 1
        fi
    else
        echo -n "    ${BLUE}[${RED}!${BLUE}] ${RED}Invalid Option, Try Again."
        { sleep 1; banner; echo; select_dark; }
    fi
    return
}
 
random_light () {
    # Read user selection
    random_scheme=$(find $LIGHT_DIR -type f -name "*.yml" | shuf -n 1)
    echo "    ${BLUE}[${RED}*${BLUE}] ${ORANGE}Theme Set To: ${random_scheme##*/}"
	if ! cp --force "${random_scheme}" "${ALACRITTY_DIR}/gelacritty.yml" &>/dev/null; then
		printf '%s\n' "Failed to apply theme!" >&2
		return 1
	fi
    { reset_color; exit; }
}
 
random_dark () {
    # Read user selection
    random_scheme=$(find $DARK_DIR -type f -name "*.yml" | shuf -n 1)
    echo "    ${BLUE}[${RED}*${BLUE}] ${ORANGE}Theme Set To: ${random_scheme##*/}"
	if ! cp --force "${random_scheme}" "${ALACRITTY_DIR}/gelacritty.yml" &>/dev/null; then
		printf '%s\n' "Failed to apply theme!" >&2
		return 1
	fi
    { reset_color; exit; }
}

## Apply fonts
apply_fonts () {
    local count=1

    # List fonts
    fonts_list=($(ls $FONTS_DIR))
    for fonts in "${fonts_list[@]}"; do
        fonts_name=$(echo $fonts)
        echo ${ORANGE}"    [$count] ${fonts_name%.*}"
        count=$(($count+1))
    done

    # Read user selection
    { echo; read -p ${BLUE}"    [${RED}Select font (1 to $total_fonts)${BLUE}]: ${GREEN}" answer; echo; }

    # Apply fonts
    if [[ (-n "$answer") && ("$answer" -le $total_fonts) ]]; then
        font_ttf=${fonts_list[(( answer - 1 ))]}
        actual_font_name=$(fc-list | grep -i $font_ttf | head -n 1 | cut -d':' -f2)
        { read -p ${BLUE}"    [${RED}Enter Font Size (Default is 10)${BLUE}]: ${GREEN}" font_size; echo; }
        echo "    ${BLUE}[${RED}*${BLUE}] ${ORANGE}Applying Fonts..."
        sed -i -e "s/family: .*/family:      $actual_font_name/g" $ALACRITTY_DIR/alacritty.yml
        sed -i -e "s/size: .*/size:  ${font_size:-10}/g" $ALACRITTY_DIR/alacritty.yml
        { echo "    ${BLUE}[${RED}!${BLUE}] ${ORANGE}Applied a new font"; echo; }
        { reset_color; exit; }
    else
        echo -n "    ${BLUE}[${RED}!${BLUE}] ${RED}Invalid Option, Try Again."
        { sleep 2; banner; echo; apply_fonts; }
    fi
    return
}

# TODO 
## Import files
update_gela () {
    banner; 
    echo "    ${BLUE}[${RED}!${BLUE}] ${RED}UPDATING..."
    echo "    ${BLUE}"
	if [[ ! -d $HOME/gelacritty ]]; then
        git clone https://github.com/zim0369/gelacritty $HOME/gelacritty 
        cd $HOME/gelacritty 
    else
        echo; 
        echo -n "    ${BLUE}[${RED}!${BLUE}] ${RED}Directory Exists..."
        cd $HOME/gelacritty
        git pull
	fi
    chmod +x * 
    sh install 
	{ reset_color; exit; }
}
 
# fzf_apply(){} 
# fzf_apply_light(){} 
# fzf_apply_dark(){} 

## Main menu
interface() {
until [[ "$REPLY" =~ ^[q/Q]$ ]]; do
    banner
    echo "
    ${BLUE}[${RED}S${BLUE}] ${GREEN}Select
    ${BLUE}[${RED}D${BLUE}] ${GREEN}Random Dark ($total_dark)
    ${BLUE}[${RED}L${BLUE}] ${GREEN}Random Light ($total_light)
    ${BLUE}[${RED}F${BLUE}] ${GREEN}Fonts ($total_fonts)
    ${BLUE}[${RED}U${BLUE}] ${GREEN}Update
    ${BLUE}[${RED}Q${BLUE}] ${GREEN}Quit
    "

    { read -n 1 -p ${BLUE}"    [${RED}Select Option${BLUE}]: ${GREEN}"; echo; }
    { banner; echo;}

    if [[ "$REPLY" =~ ^[s/S/f/F/l/L/d/D/u/U/q/Q]$ ]]; then      #validate input
        if [[ "$REPLY" =~ ^[s/S]$ ]]; then
            apply_select
        elif [[ "$REPLY" =~ ^[f/F]$ ]]; then
            apply_fonts
        elif [[ "$REPLY" =~ ^[l/L]$ ]]; then
            random_light
        elif [[ "$REPLY" =~ ^[d/D]$ ]]; then
            random_dark
        elif [[ "$REPLY" =~ ^[u/U]$ ]]; then
            update_gela
        fi
    else
        echo -n "    ${BLUE}[${RED}!${BLUE}] ${RED}Invalid Option, Try Again."
        sleep 2
    fi
done
{ echo "    ${BLUE}[${RED}*${BLUE}] ${RED}Bye Bye, Have A Nice Day!"; echo; reset_color; exit 0; }
} 

show_help() {
	cat << EOF
Randomly select & apply an alacritty color theme

USAGE: ${0##*/} [OPTIONS]

OPTIONS:
	-h, --help 		Show this help message
	-d, --dark 		Only select dark themes
	-l, --light 	Only select light themes
EOF
}

main() {
	local opts type theme
	opts="$(getopt --options hdl --longoptions help,dark,light --name "${0##*/}" -- "${@}")"
	
	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help ) 	show_help; exit 0;;
			-d | --dark ) 	type="dark";;
			-l | --light ) 	type="light";;
			-- ) 			shift; break;;
			* ) 			break;;
		esac
		shift
	done
     
	if ! [ -s "${ALACRITTY_DIR}/alacritty.yml" ]; then
		echo "    ${BLUE}[${RED}*${BLUE}] ${RED}Cannot find alacritty configuration: '${ALACRITTY_DIR}/alacritty.yml'"${BLUE}
		printf '%s\n' "    ${BLUE}[${RED}*${BLUE}] ${RED}Creating one for you..."${BLUE}
        # sudo sed -i -e 's|program: .*|program: '$SHELL'|g' /usr/local/share/gelacritty/alacritty.yml
	    cp -r /usr/local/share/gelacritty/alacritty.yml $ALACRITTY_DIR
        { reset_color; exit; }
	fi
     
	if ! grep --quiet 'gelacritty\.yml' "${ALACRITTY_DIR}/alacritty.yml"; then
		printf '%s\n' "    ${BLUE}[${RED}*${BLUE}] ${RED}Adding gelacritty import to alacritty config..."
		printf 'import:\n- %s' "${ALACRITTY_DIR}/gelacritty.yml" >> "${ALACRITTY_DIR}/alacritty.yml"
        { reset_color; exit; }
	fi
	
    if [ $type = "light" ]; then
        banner 
        random_scheme=$(find $LIGHT_DIR -type f -name "*.yml" | shuf -n 1)
        echo "    ${BLUE}[${RED}*${BLUE}] ${ORANGE}Theme Set To: ${random_scheme##*/}"
        if ! cp --force "${random_scheme}" "${ALACRITTY_DIR}/gelacritty.yml" &>/dev/null; then
            printf '%s\n' "Failed to apply theme!" >&2
            return 1
        fi
    elif [ $type = "dark" ]; then
        banner 
        random_scheme=$(find $DARK_DIR -type f -name "*.yml" | shuf -n 1)
        echo "    ${BLUE}[${RED}*${BLUE}] ${ORANGE}Theme Set To: ${random_scheme##*/}"
        if ! cp --force "${random_scheme}" "${ALACRITTY_DIR}/gelacritty.yml" &>/dev/null; then
            printf '%s\n' "Failed to apply theme!" >&2
            return 1
        fi
    else
        interface
    fi 
	
	return 0
}

main "${@}"
