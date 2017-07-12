import Html exposing (..)
import Html.Events exposing (onInput)

import Markdown

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = {
    text: String
}


init : (Model, Cmd Msg)
init =
  (Model "", Cmd.none)


-- UPDATE

type Msg
  = Editor String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Editor src ->
        ( { model | text = src }, Cmd.none )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW

view : Model -> Html Msg
view model =
    div [] [
        textarea [onInput Editor] [],
        Markdown.toHtml [] model.text
    ]
