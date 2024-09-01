import os
import std/strutils

let n = parseInt(paramStr(1))
let k = parseInt(paramStr(2))

var adultPairs = 0
var newbornPairs = 1

for i in 1 ..< n:
    var adultPrevPairs = adultPairs
    adultPairs = adultPairs + newbornPairs
    newbornPairs = k*adultPrevPairs

let pairs = adultPairs + newbornPairs
echo $pairs