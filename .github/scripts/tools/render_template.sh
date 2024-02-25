#/bin/bash

# Replaces any occurrences of '{{ VARIABLE }}' in a text file with environmental variable 'VARIABLE'

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
