module Session.Request exposing (login, logout, register)

import Helpers.Request exposing (apiUrl, withAuthorization)
import Http
import HttpBuilder exposing (RequestBuilder, withExpect, withQueryParams)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Session.AuthToken as AuthToken exposing (AuthToken)
import Session.Model as Session exposing (Session)
import User.Model as User exposing (User)
import Util exposing ((=>))


logout : Maybe Session -> Http.Request ()
logout session =
    let
        expectNothing =
            Http.expectStringResponse (\_ -> Ok ())
    in
    apiUrl "/sessions"
        |> HttpBuilder.delete
        |> HttpBuilder.withExpect expectNothing
        |> withAuthorization session
        |> HttpBuilder.toRequest


login : { r | email : String, password : String } -> Http.Request Session
login { email, password } =
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


register : { r | name : String, email : String, password : String } -> Http.Request Session
register { name, email, password } =
    let
        user =
            Encode.object
                [ "name" => Encode.string name
                , "email" => Encode.string email
                , "password" => Encode.string password
                ]

        body =
            user
                |> Http.jsonBody
    in
    decodeSessionResponse
        |> Http.post (apiUrl "/users") body


decodeSessionResponse : Decoder Session
decodeSessionResponse =
    Decode.map2 Session
        (Decode.field "data" User.decoder)
        (Decode.at [ "meta", "token" ] AuthToken.decoder)
