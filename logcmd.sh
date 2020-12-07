#!/bin/sh

nicedate() { date +%Y%m%d-%H%M%S; }

logdir="$HOME/logs"

usage() {
    cat <<ENDUSAGE
Usage: $0 <log-basename> <cmd...>
Log a command and run it
    log-basename:
        The base name for the logfile
        Saves logs in $logdir as '$logdir/$(nicedate)-BASENAME
    cmd:
        A command to run
Logs the command to the start of the logfile.
At the end, prints the start and end time of the command.
Also writes all output to stdout.
ENDUSAGE
}

if test $# -lt 2; then
    echo "Only $# arguments passed..."
    usage
    exit 1
fi
case "$1" in
    -h | --help) usage; exit 0;;
esac
logbasename=$1
shift

mkdir -p "$logdir"
start=$(nicedate)
logfile="$logdir/$start-$logbasename"

runcmd() {
    echo "COMMAND: $@"
    echo "CWD: $(pwd)"
    echo ""
    $@ 2>&1
    lastexit=$?
    echo "Exit code: $lastexit"
    echo "START: $start"
    echo "END:   $(nicedate)"
}

runcmd "$@" | tee "$logfile"

# echo "$@" | tee "$logfile"
# $@ 2>&1 | tee "$logfile"
# echo "START: $start" | tee "$logfile"
# echo "END:   $(nicedate)" | tee "$logfile"
echo "Log saved to $logfile"
