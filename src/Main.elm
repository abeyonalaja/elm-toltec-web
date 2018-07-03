module Main exposing (..)

import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Navigation
import Route exposing (Route)
import Subscriptions exposing (subscriptions)
import Update exposing (init, update)
import View exposing (view)


---- PROGRAM ----


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
