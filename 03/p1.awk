#!/usr/bin/awk -f

BEGIN {}

{
  string = $0
  while (string) {

    # this regexp doesn't work correctly in mawk
    # since quantifiers are not supported it seems
    #mul_start = match(string, /mul\([0-9]{1,3},[0-9]{1,3}\)/)

    # RLENGTH is set to -1 if no match
    mul_start = match(string, /mul\([0-9][0-9]?[0-9]?,[0-9][0-9]?[0-9]?\)/)
    if (RLENGTH == -1) {break}

    mul = substr(string, mul_start+4, RLENGTH-5)

    # remove anything up to and including mul from string
    string = substr(string, mul_start+RLENGTH-1)

    split(mul, mul_val, ",")
    result += mul_val[1] * mul_val[2]
  }
}

END {print result}
