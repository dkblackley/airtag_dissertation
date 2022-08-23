#!/bin/sh
i=0


# for line in $(frida-ps)
# do
#     echo gtimeout 20 python3 frida_inject.py ${line}
#     echo "Done ${line}"
# done

frida-ps | while read -r line ; do


    #echo $line
    #new_line=$(echo $line | sed "s/^[^ ]* //")
    new_line=$(echo $line | sed 's/ .*//')
    #new_line=("${line[@]:2}")
    gtimeout 20 python3 frida_inject.py ${new_line}
    echo "Done ${line}"
done
