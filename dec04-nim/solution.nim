import os, strutils, md5

proc findMinSuffix(keyPrefix: string, numLeadingZeros: int) : int =
  let md5Prefix = "0".repeat(numLeadingZeros)
  var num = 1
  while true:
    let key = format("$1$2", keyPrefix, num)
    let md5 = getMD5(key)
    if md5[0..numLeadingZeros-1] == md5Prefix:
      return num
    num += 1

let prefix = readLine(stdin)
echo format("Answer for 5 zeros: $1", findMinSuffix(prefix, 5))
echo format("Answer for 6 zeros: $1", findMinSuffix(prefix, 6))

