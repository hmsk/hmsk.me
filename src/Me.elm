module Me exposing (..)

import Html exposing (Html, div, text, strong, program, p, a, ul, li, i, img)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (onClick, on)
import Char exposing (fromCode)
import Keyboard exposing (presses)
import Time exposing (millisecond)
import Process exposing (sleep)
import Task exposing (perform)
import Json.Decode as Json
import Touch exposing (..)
import SingleTouch exposing (onMove)

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
    , wheelLocked: Bool
    , lastTouch: (Float, Float)
    }

init : (Model, Cmd Msg)
init =
    ({ accounts = MetaData.accounts
    ,  ringOpened = Closed
    ,  rotation = 0
    ,  wheelLocked = False
    ,  lastTouch = (0, 0)
    }, Cmd.none)

delayedCmd : Msg -> Int -> Cmd Msg
delayedCmd msg msec =
    toFloat msec * millisecond |> Process.sleep |> Task.perform (\_ -> msg)

-- MESSAGES
type Msg
    = Presses Char
    | ToggleRing
    | AnimationEnd
    | TakeWheel Int
    | WheelUnlock
    | TouchMoved Touch.Coordinates
    | TouchReset

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case (msg, model.ringOpened) of
        (Presses 'j', Opened) ->
            ({ model | rotation = model.rotation + 1 }, Cmd.none)
        (Presses 'k', Opened) ->
            ({ model | rotation = model.rotation - 1 }, Cmd.none)
        (TakeWheel delta, Opened) ->
            if not model.wheelLocked && delta > 20 then
                ({ model | rotation = model.rotation + 1, wheelLocked = True }, delayedCmd WheelUnlock 200)
            else if not model.wheelLocked && delta < -20 then
                ({ model | rotation = model.rotation - 1, wheelLocked = True }, delayedCmd WheelUnlock 200)
            else
                (model, Cmd.none)
        (WheelUnlock, _) ->
            ({ model | wheelLocked = False }, Cmd.none)
        (TouchMoved touch, _) ->
            if model.lastTouch == (0, 0) then
                ({ model | lastTouch = (touch.clientX, touch.clientY) }, Cmd.none)
            else
                if touch.clientY - Tuple.second model.lastTouch > 50 then
                    ({ model | rotation = model.rotation - 1, lastTouch = (touch.clientX, touch.clientY) }, delayedCmd TouchReset 50)
                else if touch.clientY - Tuple.second model.lastTouch < -50 then
                    ({ model | rotation = model.rotation + 1, lastTouch = (touch.clientX, touch.clientY) }, delayedCmd TouchReset 50)
                else
                    (model, Cmd.none)
        (TouchReset, _) ->
            ({ model | lastTouch = (0, 0) }, Cmd.none)
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
    Keyboard.presses (Presses << fromCode)

-- VIEW
view : Model -> Html Msg
view model =
    div [ onWheel TakeWheel
        , onMove TouchMoved
        , attribute "id" "container"
        ] [
        div [ attribute "id" "content" ] [
            img [ attribute "src" MetaData.iconUrl, onClick ToggleRing ] []
            , p [ attribute "class" "name" ] [ text MetaData.myName ]
            , p [] (profilesLinksHtml MetaData.profiles)
            , ul [openedClass model.ringOpened] (circleAccountList model)
            , div [ style [translateFromCenterStyle, openedStyle model.ringOpened], attribute "id" "cursor" ] []
            , p [ style [translateFromCenterStyle, openedStyle model.ringOpened], attribute "id" "selection" ] [selectedAccountName model]
        ]
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
            else if model.rotation == 0 then
                0
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

onWheel : (Int -> msg) -> Html.Attribute msg
onWheel message =
    on "wheel" (Json.map message (Json.at ["deltaY"] Json.int ))
