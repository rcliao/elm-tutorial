import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Char
import String


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { name : String
  , age : Int
  , password : String
  , passwordAgain : String
  , validationState :
    {  color: String
      ,message: String
    }
  }


model : Model
model =
  Model "" 0 "" "" { color="", message="" }


-- UPDATE

type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Submit


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Age age ->
      { model | age = Result.withDefault 0 (String.toInt age) }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Submit ->
      let
        (color, message) =
        if 0 == model.age then
            ("red", "Age must be a valid integer")
        else if String.length model.password < 8 then
            ("red", "Password must be more than 8 characters long")
        else if not (String.any Char.isDigit model.password && String.any Char.isUpper model.password && String.any Char.isLower model.password) then
            ("red", "Password must contain at least one lower case, one upper case letter and one digit")
        else if model.password /= model.passwordAgain then
            ("red", "Passwords do not match!")
        else
            ("green", "OK")  
      in
        { model | validationState = { color = color, message = message } }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Name", onInput Name ] []
    , input [ type_ "age", placeholder "Age", onInput Age ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , button [ onClick Submit ] [text "Submit"]
    , div [ style [("color", model.validationState.color)] ] [ text model.validationState.message ]
    ]
