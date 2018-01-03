module Me exposing (..)

import Html exposing (Html, div, text, strong, program, p, a, ul, li, i, img)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (onClick)
import Keyboard exposing (..)
import Char exposing (fromCode)
import Array exposing (..)
import Time exposing (millisecond)
import Process exposing (sleep)
import Task exposing (perform)

import MetaData exposing (..)

type MenuTransition
    = Closed
    | AnimateToClosed
    | AnimateToOpened
    | Opened

radius : Int
radius =
    160

-- MAIN
main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL
type alias Model =
    { accounts: List(Account)
    , menuOpened: MenuTransition
    , rotation: Int
    }

init : (Model, Cmd Msg)
init =
    ({ accounts = MetaData.accounts
    ,  menuOpened = Closed
    ,  rotation = 0
    }, Cmd.none)

delayedCmd : Msg -> Int -> Cmd Msg
delayedCmd msg msec =
    Process.sleep (toFloat msec * millisecond)
        |> Task.perform (\_ -> msg)

-- MESSAGES
type Msg
    = Presses Char
    | ToggleMenu
    | AnimationEnd

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Presses code ->
            case code of
                'j' -> ({ model | rotation = model.rotation + 1 }, Cmd.none)
                'k' -> ({ model | rotation = model.rotation - 1 }, Cmd.none)
                _   -> (model, Cmd.none)
        ToggleMenu ->
            case model.menuOpened of
                Closed ->
                    ({ model | menuOpened = AnimateToOpened }, delayedCmd AnimationEnd 100)
                Opened ->
                    ({ model | menuOpened = AnimateToClosed }, delayedCmd AnimationEnd 200)
                _ ->
                    (model, Cmd.none)
        AnimationEnd ->
            case model.menuOpened of
                AnimateToOpened ->
                    ({ model | menuOpened = Opened }, Cmd.none)
                AnimateToClosed ->
                    ({ model | menuOpened = Closed }, Cmd.none)
                _ ->
                    (model, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses (\code -> Presses (fromCode code))

-- VIEW
view : Model -> Html Msg
view model =
    div [ attribute "class" "container" ]
    [ img [ attribute "src" MetaData.iconUrl, onClick ToggleMenu ] []
    , p [ attribute "class" "name" ] [ text MetaData.myName ]
    , p [] (profilesLinksHtml MetaData.profiles)
    , ul [openedClass model.menuOpened] (circleAccountList model)
    , div [ style [translateFromCenterStyle, openedStyle model.menuOpened], attribute "id" "cursor" ] []
    , p [ style [translateFromCenterStyle, openedStyle model.menuOpened], attribute "id" "selection" ] [selectedAccountName model]
    ]

openedStyle : MenuTransition -> (String, String)
openedStyle opened =
    ("display", if opened == Opened then "block" else "none")

openedClass : MenuTransition -> Html.Attribute msg
openedClass opened =
    attribute "class" (if opened == Closed then "" else "opened")

translateFromCenterStyle : (String, String)
translateFromCenterStyle =
    ("transform", "translateY(-" ++ toString(radius) ++"px)")

selectedAccountName : Model -> Html Msg
selectedAccountName model =
    let
        len = List.length(model.accounts)
        index =
            if model.rotation < 0 then
                len - (-1 * model.rotation % len)
            else
                model.rotation % len

        selected = Array.get index (Array.fromList (model.accounts))
    in
        case selected of
            Just (name, _, _) -> text name
            Nothing -> text ""

profilesLinksHtml : List(Account) -> List(Html msg)
profilesLinksHtml (accounts) =
    List.map profileLink  accounts

profileLink : Account -> Html msg
profileLink (_, icon, url) =
    a [ attribute "href" url, attribute "target" "_blank"]
      [ i [ attribute "class" icon ] [] ]

circleAccountList : Model -> List(Html Msg)
circleAccountList model =
    List.indexedMap (\index account -> circleAccountHtml model account index) accounts

circleAccountHtml : Model -> Account -> Int -> Html Msg
circleAccountHtml model (_, icon, url) index =
    li [circularStyle model index] [
        a [ attribute "class" "button"
        , attribute "href" url
        , attribute "target" "_blank"
        ]
        [ i [attribute "class" icon] [] ]
    ]

circularStyle : Model -> Int -> Html.Attribute msg
circularStyle model index =
    let
        apexCount = List.length model.accounts
        one = 360 / toFloat(apexCount)
        rotatedDegree =
            case model.menuOpened of
                Opened ->
                    one * toFloat(index - model.rotation)
                _ ->
                    one * toFloat(index - model.rotation) - one
        distanceFromCenter =
            case model.menuOpened of 
                Opened ->
                    "translateY(-" ++ toString radius ++ "px)"
                _ ->
                    "translateY(-" ++ toString (radius + 500) ++ "px)"

    in
        style
            [ ("transform"
              , "rotate(" ++ toString rotatedDegree ++ "deg) " ++ distanceFromCenter ++ "rotate(" ++ toString (rotatedDegree * -1) ++ "deg)")
            , ("transition"
              , "0.25s ease-in-out")
            ]
