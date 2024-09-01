import os
import std/strutils
import sequtils

let n = parseInt(paramStr(1))
let m = parseInt(paramStr(2))

# pairsByAge is a `seq` which contains the number of pairs
# by their age.
# So, element 0 is newborns, element 1 is 1-month-old pairs, etc.
var pairsByAge = newSeq[int](m)
pairsByAge[0] = 1

for i in 1 ..< n:
    # Calculates the new pairs at generation i.
    # This is the sum of all adult pairs at previous generations,
    # i.e., all elements of the `pairsByAge` array from 1 to m.
    # This assumes k = 1.
    var newPairs = pairsByAge[1..^1].foldl(a+b)

    # Calculates the number of pairs for each age at this generation.
    for j in countDown(m-1, 1):
        pairsByAge[j] = pairsByAge[j-1]
    
    pairsByAge[0] = newPairs

let total = pairsByAge.foldl(a+b)
echo $total