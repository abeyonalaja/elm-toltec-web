module Model exposing (Model, Page(..), PageState(..), getPage, initialModel)

import Json.Decode as Decode exposing (Value)
import Session.Login as Login exposing (..)
import Session.Model as Session exposing (Session)


type Page
    = Blank
    | NotFound
    | Home
    | Login Login.Model
    | Register


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { pageState : PageState
    , session : Maybe Session
    }


initialModel : Value -> Model
initialModel val =
    { pageState = Loaded Blank
    , session = Nothing
    }


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page
