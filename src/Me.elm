module Me exposing (..)

import Html exposing (Html, div, text, strong, program, p, a, ul, li, i, img, footer, header, br)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (onClick, on)
import Char exposing (fromCode)
import Keyboard exposing (presses)
import Time exposing (millisecond)
import Process exposing (sleep)
import Task exposing (perform)
import Json.Decode as Json
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
    { accounts : List Account
    , ringOpened : RingAppearance
    , rotation : Int
    , wheelLocked : Bool
    , lastTouch : ( Float, Float )
    }


init : ( Model, Cmd Msg )
init =
    ( { accounts = MetaData.accounts
      , ringOpened = Closed
      , rotation = 0
      , wheelLocked = False
      , lastTouch = ( 0, 0 )
      }
    , Cmd.none
    )


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
    | RotateRingTo Int



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.ringOpened ) of
        ( Presses 'j', Opened ) ->
            ( { model | rotation = rotate model.rotation Clockwise }, Cmd.none )

        ( Presses 'k', Opened ) ->
            ( { model | rotation = rotate model.rotation CounterClockwise }, Cmd.none )

        ( RotateRingTo index, Opened ) ->
            let
                len =
                    List.length (model.accounts)

                currentIndex =
                    normalizedRotation model.rotation len

                diff =
                    index - currentIndex

                next =
                    if toFloat (abs diff) < toFloat (len) / 2 then
                        diff
                    else if toFloat (currentIndex) < toFloat (len) / 2 then
                        diff - len
                    else
                        diff + len
            in
                -- Should express based on RotateDirection
                ( { model | rotation = model.rotation + next }, Cmd.none )

        ( TakeWheel delta, Opened ) ->
            if not model.wheelLocked && delta > 20 then
                ( { model | rotation = rotate model.rotation CounterClockwise, wheelLocked = True }, delayedCmd WheelUnlock 200 )
            else if not model.wheelLocked && delta < -20 then
                ( { model | rotation = rotate model.rotation Clockwise, wheelLocked = True }, delayedCmd WheelUnlock 200 )
            else
                ( model, Cmd.none )

        ( WheelUnlock, _ ) ->
            ( { model | wheelLocked = False }, Cmd.none )

        ( ToggleRing, Closed ) ->
            ( { model | ringOpened = AnimateToOpened }, delayedCmd AnimationEnd 20 )

        ( ToggleRing, Opened ) ->
            ( { model | ringOpened = AnimateToClosed }, delayedCmd AnimationEnd 200 )

        ( AnimationEnd, AnimateToOpened ) ->
            ( { model | ringOpened = Opened }, Cmd.none )

        ( AnimationEnd, AnimateToClosed ) ->
            ( { model | ringOpened = Closed }, Cmd.none )

        _ ->
            ( model, Cmd.none )


type RotateDirection
    = Clockwise
    | CounterClockwise


rotate : Int -> RotateDirection -> Int
rotate current direction =
    case direction of
        Clockwise ->
            current - 1

        CounterClockwise ->
            current + 1


normalizedRotation : Int -> Int -> Int
normalizedRotation currentRotation listLength =
    let
        remainder =
            abs currentRotation % listLength
    in
        if currentRotation == 0 || remainder == 0 then
            0
        else if currentRotation < 0 then
            listLength - remainder
        else
            remainder



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses (Presses << fromCode)



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ onWheel TakeWheel
        , attribute "id" "container"
        ]
        [ header [ style [ openedStyle model.ringOpened ], attribute "id" "selection" ] [ selectedAccountName model ]
        , div [ attribute "id" "content" ]
            [ img [ attribute "src" MetaData.iconUrl, onClick ToggleRing ] []
            , p [ attribute "class" "name" ] [ text MetaData.myName ]
            , p [] (profilesLinksHtml MetaData.profiles)
            , ul [ openedClass model.ringOpened ] (circleAccountList model)
            , div [ style [ translateFromCenterStyle, openedStyle model.ringOpened ], attribute "id" "cursor" ] []
            ]
        , footer []
            [ text "© 2018 by Kengo Hamasaki"
            , br [] []
            , text "Made with "
            , a [ attribute "href" "https://github.com/hmsk/hmsk.me", attribute "target" "_blank" ] [ text "Elm" ]
            , text " and the respect for "
            , a [ attribute "href" "https://en.wikipedia.org/wiki/Secret_of_Mana", attribute "target" "_blank" ] [ text "Secret of Mana" ]
            , text "."
            , br [] []
            , text "You can toggle *Ring Command* by clicking the avatar."
            ]
        ]


openedStyle : RingAppearance -> ( String, String )
openedStyle opened =
    ( "opacity"
    , if opened == Opened then
        "1"
      else
        "0"
    )


openedClass : RingAppearance -> Html.Attribute msg
openedClass opened =
    attribute "class"
        (if opened == Closed then
            ""
         else
            "opened"
        )


translateFromCenterStyle : ( String, String )
translateFromCenterStyle =
    ( "transform", "translateY(" ++ toString (-1 * radius) ++ "px)" )


selectedAccountName : Model -> Html Msg
selectedAccountName model =
    let
        currentIndex =
            normalizedRotation model.rotation (List.length model.accounts)

        selected =
            List.head <| List.drop currentIndex model.accounts
    in
        text <|
            case selected of
                Just ( name, _, _ ) ->
                    name

                Nothing ->
                    ""


profilesLinksHtml : List Account -> List (Html msg)
profilesLinksHtml accounts =
    List.map profileLink accounts


profileLink : Account -> Html msg
profileLink ( _, icon, url ) =
    a [ attribute "href" url, attribute "target" "_blank" ]
        [ i [ attribute "class" icon ] [] ]


circleAccountList : Model -> List (Html Msg)
circleAccountList model =
    List.indexedMap (\index account -> circleAccountHtml model account index) accounts


circleAccountHtml : Model -> Account -> Int -> Html Msg
circleAccountHtml model ( _, icon, url ) index =
    let
        attributes =
            case (index == normalizedRotation model.rotation (List.length model.accounts)) of
                True ->
                    [ attribute "href" url
                    , attribute "target" "_blank"
                    , attribute "class" "active"
                    ]

                False ->
                    [ onClick <| RotateRingTo index ]
    in
        li [ circularStyle model index ]
            [ a attributes [ i [ attribute "class" icon ] [] ] ]


circularStyle : Model -> Int -> Html.Attribute msg
circularStyle model index =
    let
        apexCount =
            List.length model.accounts

        one =
            360 / toFloat (apexCount)

        ( rotatedDegree, distanceFromCenter ) =
            case model.ringOpened of
                Opened ->
                    ( one * toFloat (index - model.rotation)
                    , "translateY(-" ++ toString radius ++ "px)"
                    )

                _ ->
                    ( one * toFloat (index - model.rotation - 2)
                    , "translateY(-" ++ toString (radius + 500 + 660) ++ "px)"
                    )
    in
        style
            [ ( "transform"
              , "rotate(" ++ toString rotatedDegree ++ "deg) " ++ distanceFromCenter ++ "rotate(" ++ toString (rotatedDegree * -1) ++ "deg)"
              )
            , ( "transition"
              , "0.50s ease-in-out"
              )
            ]


onWheel : (Int -> msg) -> Html.Attribute msg
onWheel message =
    on "wheel" (Json.map message (Json.at [ "deltaY" ] Json.int))
