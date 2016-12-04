open System

let argv = Environment.GetCommandLineArgs()
let fname = if argv.Length > 2 then argv.[2] else "input.txt"
let input = IO.File.ReadLines(fname)

printfn "%A" input
