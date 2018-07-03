module Page.NotFound exposing (view)

import Html exposing (Html, div, h1, text)


view : Html msg
view =
    div []
        [ h1 [] [ text "the page you requested was not found!" ] ]
