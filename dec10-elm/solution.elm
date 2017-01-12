import Html exposing (..)
import Http exposing (..)
import String exposing (..)
import Task exposing (..)
import Char exposing (..)

-- boilerplate, to load inputs and show data
inputFile: String
inputFile = "input.txt"

type alias Model = String
type Msg = Fetched String | Failed String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (case msg of
    Fetched str -> str
    Failed err -> err
  , Cmd.none)

line : String -> Cmd Msg
line fname =
  Http.getString fname
  |> toTask
  |> Task.attempt (\res ->
    case res of
      Ok val -> Fetched val
      Err error -> Failed (toString error))

view : Model -> Html Msg
view str = str |> String.lines |> List.map solve |> toString |> text
main: Program Never String Msg
main =
    Html.program
      { init = ("Wait...", line inputFile)
      , update = update
      , view = view
      , subscriptions = \_ -> Sub.none
      }


-- solution
parseSeed : String -> Result String (List Int)
parseSeed seed = 
  let 
    chars = seed |> toList
  in 
    if List.all isDigit chars then
      chars |> List.map toCode
        |> List.map (\c -> c - (toCode '0'))
        |> Ok
    else Err ""

parseProblem : String -> Result String (List Int, Int)
parseProblem str = 
  case String.split " " str of
    seed::steps::_ -> 
      Result.map2 (,) (parseSeed seed) (toInt steps)
    _ -> Err (String.append "ERROR STRING: " str) 
 
-- NOTE: this MUST be tail-recursive, otherwise the stack
-- will blow up in no time
lookSay : Int -> Int -> List Int -> List Int -> List Int
lookSay digit cnt res lst =
  case lst of
    h::t -> 
      if h == digit then 
        lookSay digit (cnt + 1) res t 
      else if cnt > 0 then
        lookSay h 1 (digit::cnt::res) t
      else 
        lookSay h 1 res t      
    _ -> digit::cnt::res |> List.reverse

solve : String -> String
solve str = 
  case parseProblem str of
    Ok (seed, steps) -> 
      let res = List.foldl (\a b -> lookSay 0 0 [] b) 
                           seed (List.range 1 steps)
      in (String.join "" ["For seed/steps '", str, 
        "' the final length is: ", toString (List.length res)])      
    Err msg -> msg