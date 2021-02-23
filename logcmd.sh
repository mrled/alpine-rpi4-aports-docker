#!/bin/sh

nicedate() { date +%Y%m%d-%H%M%S; }

logdir="$HOME/logs"

cmdname=$(basename $0)
usagedate=$(nicedate)
usage() {
    cat <<ENDUSAGE
Usage: $cmdname <log-basename> <cmd...>
Run a command and log its output to $logdir

EXAMPLE
Run 'abuild -rK', logging all output to a file like
$logdir/$usagedate-rpi4-default-config.log:
    $cmdname rpi4-default-config abuild -rK

ARGUMENTS
    log-basename:
        The base name for the logfile
        Saves logs in $logdir as '$logdir/$usagedate-BASENAME'
    cmd:
        A command to run

BEHAVIOR
Logs the command itself to the start of the logfile.
Logs STDOUT and STDERR together.
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
echo "Log saved to $logfile"
