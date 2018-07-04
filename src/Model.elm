module Model exposing (Model, Page(..), PageState(..), getPage, initialModel)

import Json.Decode as Decode exposing (Value)
import Session.Login as Login exposing (..)
import Session.Model as Session exposing (Session)
import Session.Register as Register


type Page
    = Blank
    | NotFound
    | Home
    | Login Login.Model
    | Register Register.Model


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { pageState : PageState
    , session : Maybe Session
    }


initialModel : Value -> Model
initialModel val =
    { session = decodeSessionFromJson val
    , pageState = Loaded Blank
    }


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


decodeSessionFromJson : Value -> Maybe Session
decodeSessionFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString Session.decoder >> Result.toMaybe)
