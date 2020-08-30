#!/usr/bin/env sh

# Basic tool to convert `wa.user.css` to `darkmode.css` to
# be then used with Ferdi/Franz/etc.

[ $# -eq 0 ] && {
    echo "Invalid arguments. Usage: $0 -h" >&2
    exit 1
}

help() {
    echo "\
Dark-WhatsApp helper script.

Usage:
    sh whatsapp.sh [-cfh]

Options:
    -c      Compile custom ~wa.user.styl~ userstyle.
    -f      Convert ~wa.user.css~ to ~darkmode.css~.
    -h      Print help and exit.

Project repository:
    https://github.com/vednoc/dark-whatsapp
"
}

compile() {
    echo "Compiling..."

    temp="meta.styl"
    input="wa.user.styl"
    output="wa.custom.css"

    sed -n '/@-/,$p; 1i @import("metadata.styl");' $input > $temp

    stylus $temp -o $output
}

convert() {
    echo "Converting..."

    input="wa.user.css"
    output="darkmode.css"

    sed -n '/:root/,$p' $input | sed 's/^\ \ //; $d' > $output

    [ -e $output ] && echo "Done! $output is ready." \
                   || echo 'File not found!' >&2
}

while getopts "cfh" option; do
    case $option in
        "c") COMPILE=1 ;;

        "f") CONVERT=1 ;;

        "h") HELP=1 ;;
    esac
done

[ -n "${HELP+x}" ] && help
[ -n "${COMPILE+x}" ] && compile
[ -n "${CONVERT+x}" ] && convert
