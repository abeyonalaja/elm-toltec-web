module Model exposing (Model, initModel, Page(..), PageState(..), getPage)

import Json.Decode as Decode exposing (Value)


type Page
    = Blank
    | NotFound
    | Home
    | Login
    | Register


type PageState
    = Locaded Page
    | TansitioningFrom Page


type alias Model =
    { pageState : PageState }


initialModel : Value -> model
initialModel val =
    { pageState = Loaded Blank }


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page
        TransitioningFrom page ->
            page
