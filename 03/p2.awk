#!/usr/bin/awk -f

BEGIN {mul_enabled = 1}

{
  string = $0
  while (string) {

    # match do() and don't() instructions
    # do it here because subsequent match() resets RLENGTH
    do_start = match(string, /do(n't)?\(\)/)
    do_str = substr(string, do_start, RLENGTH)

    # RLENGTH is set to -1 if no match
    mul_start = match(string, /mul\([0-9][0-9]?[0-9]?,[0-9][0-9]?[0-9]?\)/)
    if (RLENGTH == -1) {break}

    mul = substr(string, mul_start+4, RLENGTH-5)

    # only change mul_enabled if do() or don't() is found before next mul
    if (do_start < mul_start) {
      if (length(do_str) == 4) {mul_enabled = 1}
      else if (length(do_str) == 7) {mul_enabled = 0}
    }

    if (mul_enabled) {
      split(mul, mul_val, ",")
      result += mul_val[1] * mul_val[2]
    }

    # remove anything up to and including mul from string
    string = substr(string, mul_start+RLENGTH-1)
  }
}

END {print result}
