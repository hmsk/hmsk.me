module Me exposing (..)

import Html exposing (Html, div, text, strong, program, p, a, ul, li, i, img)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (onClick)
import Char exposing (fromCode)
import Keyboard exposing (presses)
import Time exposing (millisecond)
import Process exposing (sleep)
import Task exposing (perform)

import MetaData exposing (..)

type RingAppearance
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
    , ringOpened: RingAppearance
    , rotation: Int
    }

init : (Model, Cmd Msg)
init =
    ({ accounts = MetaData.accounts
    ,  ringOpened = Closed
    ,  rotation = 0
    }, Cmd.none)

delayedCmd : Msg -> Int -> Cmd Msg
delayedCmd msg msec =
    Process.sleep (toFloat msec * millisecond)
        |> Task.perform (\_ -> msg)

-- MESSAGES
type Msg
    = Presses Char
    | ToggleRing
    | AnimationEnd

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case (msg, model.ringOpened) of
        (Presses 'j', Opened) ->
            ({ model | rotation = model.rotation + 1 }, Cmd.none)
        (Presses 'k', Opened) ->
            ({ model | rotation = model.rotation - 1 }, Cmd.none)
        (ToggleRing, Closed) ->
            ({ model | ringOpened = AnimateToOpened }, delayedCmd AnimationEnd 100)
        (ToggleRing, Opened) ->
            ({ model | ringOpened = AnimateToClosed }, delayedCmd AnimationEnd 200)
        (AnimationEnd, AnimateToOpened) ->
            ({ model | ringOpened = Opened }, Cmd.none)
        (AnimationEnd, AnimateToClosed) ->
            ({ model | ringOpened = Closed }, Cmd.none)
        _ -> (model, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses (\code -> Presses (fromCode code))

-- VIEW
view : Model -> Html Msg
view model =
    div [ attribute "class" "container" ]
    [ img [ attribute "src" MetaData.iconUrl, onClick ToggleRing ] []
    , p [ attribute "class" "name" ] [ text (if model.ringOpened == Opened then "<K " ++ MetaData.myName ++ " J>" else MetaData.myName) ]
    , p [] (profilesLinksHtml MetaData.profiles)
    , ul [openedClass model.ringOpened] (circleAccountList model)
    , div [ style [translateFromCenterStyle, openedStyle model.ringOpened], attribute "id" "cursor" ] []
    , p [ style [translateFromCenterStyle, openedStyle model.ringOpened], attribute "id" "selection" ] [selectedAccountName model]
    ]

openedStyle : RingAppearance -> (String, String)
openedStyle opened =
    ("display", if opened == Opened then "block" else "none")

openedClass : RingAppearance -> Html.Attribute msg
openedClass opened =
    attribute "class" (if opened == Closed then "" else "opened")

translateFromCenterStyle : (String, String)
translateFromCenterStyle =
    ("transform", "translateY(" ++ toString(-1 * radius) ++"px)")

selectedAccountName : Model -> Html Msg
selectedAccountName model =
    let
        len = List.length(model.accounts)
        index =
            if model.rotation < 0 then
                len - (-1 * model.rotation % len)
            else
                model.rotation % len
        selected = List.head <| List.drop index model.accounts
    in
        text <| case selected of
            Just (name, _, _) -> name
            Nothing           -> ""

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
        (rotatedDegree, distanceFromCenter) = case model.ringOpened of
            Opened ->
                (one * toFloat(index - model.rotation),
                "translateY(-" ++ toString radius ++ "px)")
            _      ->
                (one * toFloat(index - model.rotation - 2),
                "translateY(-" ++ toString (radius + 500) ++ "px)")
    in
        style
            [ ("transform"
              , "rotate(" ++ toString rotatedDegree ++ "deg) " ++ distanceFromCenter ++ "rotate(" ++ toString (rotatedDegree * -1) ++ "deg)")
            , ("transition"
              , "0.25s ease-in-out")
            ]
