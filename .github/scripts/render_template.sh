#/bin/bash

awk '{
    while(match($0, /{{[^{}]+}}/)) {
        mustasch = substr($0, RSTART, RLENGTH)
        variable = mustasch

        gsub(/[ \t{}]+/, "", variable)
        value = ENVIRON[variable]

        gsub(mustasch, value, $0)
    }

    print $0
}' $1
