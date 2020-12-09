ansi_red="\e[1;31m"
ansi_green="\e[1;32m"
ansi_white="\e[1;37m"
ansi_gray="\e[0;37m"
ansi_purp="\e[1;35m"
ansi_reset="\e[0m"
if [ "$USER" = root ]; then
    suffix="${ansi_red}#${ansi_reset}"
else
    suffix="${ansi_green}>${ansi_reset}"
fi
time="${ansi_white}\t${ansi_reset}"
prefix="${ansi_purp}builder${ansi_reset}"
dir="${ansi_gray}\w${ansi_reset}"
export PS1="${prefix} ${time} ${dir} ${suffix} "
