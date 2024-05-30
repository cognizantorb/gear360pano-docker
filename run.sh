in=$1
shift
out=$1
shift
mode=$1
shift
args=("$@")

docker run --rm -v "$in:/in" -v "$out:/out" gear360 $mode "${args[@]}"