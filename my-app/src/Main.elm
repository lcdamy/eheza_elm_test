module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData)
import Http exposing (expectJson)


---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
     ( { news = Loading }
    , getNews
    )

getNews : Cmd Msg
getNews =
    Http.get
        { url = "https://hacker-news.firebaseio.com/v0/topstories.json"
        , expect = expectJson (RemoteData.fromResult >> NewsResponse) decodeNews
        }


---- UPDATE ----


type Msg
    = NoOp
    | NewsResponse (WebData News)

type alias News =
    { name : String
    , title : String
    , id : String
    }

type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
     case msg of
        NewsResponse response ->
            ( { model | news = response }
            , Cmd.none
            )



---- VIEW ----


view : Model -> Html Msg
view model =
    case model.news of
    NotAsked -> text "Initialising."

    Loading -> text "Loading."

    -- Failure err -> text ("Error: " ++ toString err)

    Success news -> viewNews news


viewNews : News -> Html msg
viewNews news =
    div []
        [h1 [] [text "Here is the news."]
        ]


---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
