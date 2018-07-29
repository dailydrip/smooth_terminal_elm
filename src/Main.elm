module Main exposing (..)

import Html exposing (Html, div, h1, img, text)
import Types.Thread as Thread exposing (Thread)
import Views.Thread


---- MODEL ----


type alias Model =
    { thread : Thread
    }


init : ( Model, Cmd Msg )
init =
    ( { thread = Thread.new }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view { thread } =
    Views.Thread.view thread



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
