module Update exposing (init, update)

import Http
import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Model, Page(..), PageState(..), getPage, initialModel)
import Navigation exposing (Location)
import Page.Error as Error
import Page.Page as Page exposing (ActivePage)
import Ports
import Route exposing (Route)
import Session.Login as Login
import Session.Register as Register
import Session.Request exposing (logout)
import Util exposing ((=>))


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    updateRoute (Route.fromLocation location) (initialModel val)


pageError : Model -> ActivePage -> String -> ( Model, Cmd msg )
pageError model activePage errorMessage =
    let
        error =
            Error.pageError activePage errorMessage
    in
    { model | pageState = Loaded (Error error) } => Cmd.none


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
updateRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            { model | pageState = Loaded NotFound } => Cmd.none

        Just Route.Home ->
            { model | pageState = Loaded Home } => Cmd.none

        Just Route.Root ->
            model => Route.modifyUrl Route.Home

        Just Route.Login ->
            { model | pageState = Loaded (Login Login.initialModel) } => Cmd.none

        Just Route.Logout ->
            model => (Http.send LogoutCompleted <| logout model.session)

        Just Route.Register ->
            { model | pageState = Loaded (Register Register.initialModel) } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            updateRoute route model

        ( LoginMsg subMsg, Login subModel ) ->
            let
                ( ( pageModel, cmd ), msgFromPage ) =
                    Login.update subMsg subModel

                newModel =
                    case msgFromPage of
                        Login.NoOp ->
                            model

                        Login.SetSession session ->
                            { model | session = Just session }
            in
            { newModel | pageState = Loaded (Login pageModel) }
                => Cmd.map LoginMsg cmd

        ( LogoutCompleted (Ok ()), _ ) ->
            { model | session = Nothing }
                => Cmd.batch
                    [ Ports.storeSession Nothing
                    , Route.modifyUrl Route.Home
                    ]

        ( LogoutCompleted (Err error), _ ) ->
            pageError model Page.Other "There was a problem while trying to logout"

        ( RegisterMsg subMsg, Register subModel ) ->
            let
                ( ( pageModel, cmd ), msgFromPage ) =
                    Register.update subMsg subModel

                newModel =
                    case msgFromPage of
                        Register.NoOp ->
                            model

                        Register.SetSession session ->
                            { model | session = Just session }
            in
            { newModel | pageState = Loaded (Register pageModel) } => Cmd.map RegisterMsg cmd

        ( SetSession newSession, _ ) ->
            let
                cmd =
                    if model.session /= Nothing && newSession == Nothing then
                        Route.modifyUrl Route.Home
                    else
                        Cmd.none
            in
            { model | session = newSession }
                => cmd

        ( _, NotFound ) ->
            model => Cmd.none

        ( _, _ ) ->
            model => Cmd.none
