import os
import std/strutils

let k = parseInt(paramStr(1))
let m = parseInt(paramStr(2))
let n = parseInt(paramStr(3))

let T = k+m+n

# Let "AA" be the case when we choose an individual with 2 dominant alleles,
# "Aa" be the case when we choose an individual with 1 dominant and 1 recessive allele,
# "aa" be the case when we choose an individual with 2 recessive alleles.
#
# Event probabilities:
# p(AA) = k/T
# p(Aa) = m/T
# p(aa) = n/T
# p(AA|AA) = (k-1)/(T-1)
# p(Aa|AA) = m/(T-1)
# and so on and so on.
#
# Choosing 2 individuals for mating is the combination of the probability events of choosing 2 individuals.
# E.g., the probability of choosing two AA individuals is p(AA)*p(AA|AA) = (k/T)*((k-1)/(T-1))
# Furthermore, for certain combinations, the probability that an offspring will display
# the dominant phenotype is < 1. For example, when two Aa individuals mate, the probability of a dominant
# phenotype is 0.75.

let solution =
    (k/T) * ((k-1)/(T-1)) +
    (k/T) * (m/(T-1)) +
    (k/T) * (n/(T-1)) +
    (m/T) * (k/(T-1)) +
    (m/T) * ((m-1)/(T-1)) * 0.75 +
    (m/T) * (n/(T-1)) * 0.5 +
    (n/T) * (k/(T-1)) +
    (n/T) * (m/(T-1)) * 0.5

echo $solution