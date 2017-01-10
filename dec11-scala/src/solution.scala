import scala.io.Source

object Solution {
  val bannedChars: List[Int] = List('i', 'o', 'l').map(_.toInt)
  val ca: Int = 'a'.toInt
  val cz: Int = 'z'.toInt

  def increment(chars: Array[Int], pos: Int = 0): Unit = {
    val len = chars.length
    val idx = len - pos - 1
    if (idx >= 0) {
      val c = chars(idx)
      if (c < cz) {
        chars(idx) = c + 1
      } else {
        chars(idx) = ca
        increment(chars, pos + 1)
      }
    }
  }

  def hasBannedChars(chars: Array[Int]): Boolean = {
    chars.exists(bannedChars.contains(_))
  }

  def hasXYZ(chars: Array[Int]): Boolean = {
    chars.sliding(3, 1).exists {
      case Array(a, b, c) =>
        b == a + 1 && c == b + 1
    }
  }

  def hasXX(chars: Array[Int], from: Int = 0, num: Int = 2): Boolean = {
    if (num == 0) true
    else if (from >= chars.length - 1) false
    else if (chars(from) == chars(from + 1)) {
      hasXX(chars, from + 2, num - 1)
    } else {
      hasXX(chars, from + 1, num)
    }
  }

  def isValidPass(chars: Array[Int]): Boolean = {
    !hasBannedChars(chars) && hasXYZ(chars) && hasXX(chars)
  }

  def nextPass(pass: String): String = {
    var chars = pass.toArray.map(_.toInt)
    do {
      increment(chars)
    } while (!isValidPass(chars))
    chars.map(_.toChar).mkString("")
  }

  def main(args: Array[String]): Unit = {
    val file = if (args.length > 0) args(0) else "input.txt"
    val lines = Source.fromFile(file).getLines.toList

    lines.foreach { line => {
      val pass1 = nextPass(line)
      val pass2 = nextPass(pass1)
      println(s"For password $line the two next passwords are: $pass1, $pass2")
    }}
  }
}
