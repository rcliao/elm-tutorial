import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode

main =
    Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- model
type alias Model =
    { topic : String
    , gifUrl : String
    , errorMessage: String
    }

init : (Model, Cmd Msg)
init =
    (Model "cats" "waiting.gif" "", getRandomGif "cats")


-- update
type Msg =
    MorePlease
    | NewGif (Result Http.Error String)
    | Topic String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MorePlease ->
            (model, getRandomGif model.topic)

        NewGif (Ok newUrl) ->
            ( { model | gifUrl = newUrl } , Cmd.none )

        Topic topic ->
            ( { model | topic = topic } , getRandomGif topic )

        NewGif (Err err) ->
            case err of
                Http.BadUrl url ->
                    ( { model | errorMessage = "Error: bad url. Contact developer for the fix." }, Cmd.none)
                Http.Timeout ->
                    ( { model | errorMessage = "Error: request timeout. Try again later." }, Cmd.none)
                Http.NetworkError ->
                    ( { model | errorMessage = "Error: Network error" }, Cmd.none )
                Http.BadStatus resp ->
                    ( { model | errorMessage = "Error: BadStatus " ++ resp.body }, Cmd.none )
                Http.BadPayload body resp ->
                    ( { model | errorMessage = "Error: BadPayload " ++ body ++ " " ++ resp.body }, Cmd.none )

getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request

decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at ["data", "image_url"] Decode.string

-- view
view : Model -> Html Msg
view model =
    div []
    [ h2 [] [text model.topic]
    , select [ onInput Topic ]
        [ option [] [text "Cat"]
        , option [] [text "Dog"]
        , option [] [text "Pikachu"]
        ]
    , img [src model.gifUrl] []
    , button [onClick MorePlease] [text "More Please!"]
    , div [ style [("color", "red") ]]  [text model.errorMessage]
    ]

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
