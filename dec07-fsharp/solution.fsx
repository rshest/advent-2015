open System
open System.Collections.Generic

type Arg =
  | Const of uint16
  | Var of string

type Op = 
  | Assign of Arg 
  | And of Arg * Arg 
  | Or of Arg * Arg 
  | LShift of Arg * Arg 
  | RShift of Arg * Arg 
  | Not of Arg
  | Error

type OpDict = IDictionary<string, Op>
type ValDict = Dictionary<string, uint16 option>

let toArg (str: string): Arg = 
  let mutable n:uint16 = 0us
  if System.UInt16.TryParse(str, &n) then Const(n)
  else Var(str)

let parseCommand (cmd: string): string * Op = 
  let parts = cmd.Split([|' '|])
  if parts.[0] = "NOT" then ( parts.[3], Not(toArg parts.[1]))
  elif parts.[1] = "->" then (parts.[2], Assign(toArg parts.[0]))
  else
    let xy = toArg parts.[0], toArg parts.[2]
    let op = 
      match parts.[1] with
        | "AND"     -> And xy
        | "OR"      -> Or xy
        | "LSHIFT"  -> LShift xy
        | "RSHIFT"  -> RShift xy
        | _         -> Error
    (parts.[4], op)

// read input data
let argv = Environment.GetCommandLineArgs()

let fname = if argv.Length > 3 then argv.[3] else "input.txt"
let input = IO.File.ReadLines(fname)

//  create operations dictionary (keyed by wire name)
let ops = input |> Seq.map parseCommand |> dict

//  value dictionary/cache
let vals = new ValDict()
for key in ops.Keys do
  vals.Add(key, None)

let rec getValue varName  =
  let op = ops.[varName]
  match op with
    | Assign arg    -> getArg arg
    | And (x, y)    -> (getArg x) &&& (getArg y)
    | Or (x, y)     -> (getArg x) ||| (getArg y)
    | LShift (x, y) -> (getArg x) <<< int32(getArg y)
    | RShift (x, y) -> (getArg x) >>> int32(getArg y)
    | Not x         -> ~~~(getArg x)
    | _             -> 0us
and getArg arg = 
  match arg with
  | Const n -> n
  | Var x -> 
    match vals.[x] with
      | Some n -> n
      | None -> 
        let n = getValue x
        vals.[x] <- Some n
        n

let sigA1 = getValue "a" 
printfn "First value of 'a': %d" sigA1

//  reset value dictionary, except of "b" signal
for key in ops.Keys do
  vals.[key] <- if key = "b" then Some sigA1 else None

let sigA2 = getValue "a" 
printfn "Second value of 'a': %d" sigA2