module Messages exposing (Msg(..))

import Route exposing (Route)
import Session.Login as Login


type Msg
    = SetRoute (Maybe Route)
    | LoginMsg Login.Msg
