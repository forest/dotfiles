# https://gist.github.com/ttscoff/bcbba84438257e1d182480d3d929047a
function fallback -d 'allow a fallback value for variable'
    if test (count $argv) = 1
        echo $argv
    else
        echo $argv[1..-2]
    end
end
