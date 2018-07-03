module Session.Request exposing (login)

import Session.AuthToken as AuthToken exposing (AuthToken)
import User.Model as User exposing (User)
import Session.Model as Session exposing (Session)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Helpers.Request exposing (apiUrl)
import Util exposing (( => ))


login : {r | email : String, password : String } -> Http.Request Session
login { email , password} =
    let
        user =
            Encode.object
                [ "email" => Encode.string email
                , "password" => Encode.string password
                ]
        body =
            user
                |> Http.jsonBody
    in
        decodeSessionResponse
            |> Http.post (apiUrl "/sessions") body

decodeSessionResponse : Decoder Session
decodeSessionResponse =
    Decode.map2 Session
        (Decode.field "data" User.decoder)
            (Decode.at ["meta", "token"] AuthToken.decoder)

