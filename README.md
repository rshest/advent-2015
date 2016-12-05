
My solutions to [Advent of Code 2015](http://adventofcode.com/2015) problems.

The goal is to use a different programming language for every problem:

1. Python
    ```bash
    $ python solution.py < input.txt
    ```

2. C++
    ```bash
    $ g++ -std=c++11 solution.cpp -o solution
    $ ./solution < input.txt
    ```

3. Factor

    In the listener:
    ```bash
    IN: scratchpad "<path>/<to>/<parent>/<folder>" add-vocab-root
    IN: scratchpad USE: dec03-factor
    IN: scratchpad main
    ```

4. Nim
    ```bash
    $ nim c --opt:speed solution.nim && ./solution < input.txt
    ```
    
5. TypeScript
    ```bash
    $ npm install @types/node
    $ tsc solution.ts && node solution.js < input.txt
    ```

6. Julia
    ```bash
    $ julia solution.jl input.txt
    ```

7. F#
    ```bash
    $ fsi solution.fsx input.txt
    ```
