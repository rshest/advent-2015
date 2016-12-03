
My solutions to [Advent of Code 2015](http://adventofcode.com/2015) problems.

The goal is to use a different programming language for every problem:

1. Python
	$ python solution.py < input.txt
	
2. C++
	$ g++ -std=c++11 solution.cpp -o solution && solution < input.txt

3. Factor
	In the listener:
	IN: scratchpad "<path>/<to>/<checkout>" add-vocab-root
	IN: scratchpad USE: dec03-factor
	IN: scratchpad main
	
4. Nim
    $ nim c --opt:speed solution.nim && ./solution < input.txt