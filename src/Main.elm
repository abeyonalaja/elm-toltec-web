module Main exposing (..)

import Json.Decode as Decode exposing (Value)
import Navigation
import Model exposing (Model)
import Messages exposing (Msg(..))
import Route exposing (Route)
import Subscriptions exposing (subscriptions)
import Update exposing (update, init)
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
