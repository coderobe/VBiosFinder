require "./src/cli"

$0=ARGV.first
$PROGRAM_NAME=$0
ARGV.shift

VBiosFinder::CLI.start
