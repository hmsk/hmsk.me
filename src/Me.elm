module Me exposing (main)

import Browser exposing (element)
import Browser.Events exposing (Visibility(..), onKeyPress, onVisibilityChange)
import Html exposing (Html, a, br, div, footer, header, img, li, p, text, ul)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (on, onClick)
import Json.Decode as Decode
import MetaData exposing (accounts, iconUrl, myName, profiles)
import Process exposing (sleep)
import Svg exposing (svg, use)
import Svg.Attributes exposing (viewBox, xlinkHref)
import Task exposing (perform)


type RingAppearance
    = Closed
    | AnimateToClosed
    | AnimateToOpened
    | Opened


radius : Int
radius =
    160



-- MAIN


main : Program () Model Msg
main =
    element
        { init = \_ -> init 1
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { accounts : List ( String, Html Msg, String )
    , ringOpened : RingAppearance
    , rotation : Int
    , wheelLocked : Bool
    , lastTouch : ( Float, Float )
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { accounts = accounts
      , ringOpened = Closed
      , rotation = 0
      , wheelLocked = False
      , lastTouch = ( 0, 0 )
      }
    , delayedCmd Open 0
    )


delayedCmd : Msg -> Int -> Cmd Msg
delayedCmd msg msec =
    toFloat msec |> sleep |> perform (\_ -> msg)



-- MESSAGES


type Msg
    = Presses Char
    | ToggleRing
    | AnimationEnd
    | TakeWheel Int
    | WheelUnlock
    | RotateRingTo Int
    | Open
    | None



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
                    List.length model.accounts

                currentIndex =
                    normalizedRotation model.rotation len

                diff =
                    index - currentIndex

                next =
                    if toFloat (abs diff) < toFloat len / 2 then
                        diff

                    else if toFloat currentIndex < toFloat len / 2 then
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

        ( Open, Closed ) ->
            ( model, delayedCmd ToggleRing 500 )

        ( Open, Opened ) ->
            ( { model | ringOpened = Closed }, delayedCmd Open 10 )

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
            modBy listLength (abs currentRotation)
    in
    if currentRotation == 0 || remainder == 0 then
        0

    else if currentRotation < 0 then
        listLength - remainder

    else
        remainder



-- SUBSCRIPTIONS


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map toKey (Decode.field "key" Decode.string)


toKey : String -> Msg
toKey string =
    case String.uncons string of
        Just ( char, "" ) ->
            Presses char

        _ ->
            Presses '?'


toggleIfTabGetsVisible : Visibility -> Msg
toggleIfTabGetsVisible visibility =
    case visibility of
        Visible ->
            Open

        Hidden ->
            None


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onKeyPress keyDecoder
        , onVisibilityChange toggleIfTabGetsVisible
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ onWheel TakeWheel
        , attribute "id" "container"
        ]
        [ header [ (\( a, b ) -> style a b) (openedStyle model.ringOpened), attribute "id" "selection" ] [ selectedAccountName model ]
        , div [ attribute "id" "content" ]
            [ img [ attribute "src" iconUrl, onClick ToggleRing ] []
            , p [ attribute "class" "name" ] [ text myName ]
            , p [] (profilesLinksHtml profiles)
            , ul [ openedClass model.ringOpened ] (circleAccountList model)
            , div [ (\( a, b ) -> style a b) translateFromCenterStyle, (\( a, b ) -> style a b) (openedStyle model.ringOpened), attribute "id" "cursor" ] []
            ]
        , footer []
            [ text "© 2013 - 2021 Kengo Hamasaki"
            , br [] []
            , text "Made with "
            , a [ attribute "href" "https://github.com/hmsk/hmsk.me", attribute "target" "_blank", attribute "rel" "noopener" ] [ text "Elm" ]
            , text " and the respect for "
            , a [ attribute "href" "https://en.wikipedia.org/wiki/Secret_of_Mana", attribute "target" "_blank", attribute "rel" "noopener" ] [ text "Secret of Mana" ]
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
    ( "transform", "translateY(" ++ String.fromInt (-1 * radius) ++ "px)" )


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


profilesLinksHtml : List ( String, Html msg, String ) -> List (Html msg)
profilesLinksHtml accounts =
    List.map profileLink accounts


profileLink : ( String, Html msg, String ) -> Html msg
profileLink ( _, icon, url ) =
    a [ attribute "href" url, attribute "target" "_blank", attribute "rel" "noopener" ]
        [ icon
        ]


circleAccountList : Model -> List (Html Msg)
circleAccountList model =
    List.indexedMap (\index account -> circleAccountHtml model account index) accounts


circleAccountHtml : Model -> ( String, Html Msg, String ) -> Int -> Html Msg
circleAccountHtml model ( _, icon, url ) index =
    let
        attributes =
            if index == normalizedRotation model.rotation (List.length model.accounts) then
                [ attribute "href" url
                , attribute "target" "_blank"
                , attribute "class" "active"
                , attribute "rel" "noopener"
                ]

            else
                [ onClick <| RotateRingTo index ]
    in
    li [ circularStyle model index, transitionStyle ]
        [ a attributes
            [ icon ]
        ]


svgSpriteIcon : String -> Html msg
svgSpriteIcon iconName =
    svg [ viewBox "0 0 32 32" ]
        [ use [ xlinkHref <| "sprites.svg#" ++ iconName ] []
        ]


circularStyle : Model -> Int -> Html.Attribute msg
circularStyle model index =
    let
        apexCount =
            List.length model.accounts

        one =
            360 / toFloat apexCount

        ( rotatedDegree, distanceFromCenter ) =
            case model.ringOpened of
                Opened ->
                    ( one * toFloat (index - model.rotation)
                    , "translateY(-" ++ String.fromInt radius ++ "px)"
                    )

                _ ->
                    ( one * toFloat (index - model.rotation - 2)
                    , "translateY(-" ++ String.fromInt (radius + 500 + 660) ++ "px)"
                    )
    in
    style "transform" ("rotate(" ++ String.fromFloat rotatedDegree ++ "deg) " ++ distanceFromCenter ++ "rotate(" ++ String.fromFloat (rotatedDegree * -1) ++ "deg)")


transitionStyle : Html.Attribute msg
transitionStyle =
    style "transition" "0.50s ease-in-out"


onWheel : (Int -> msg) -> Html.Attribute msg
onWheel message =
    on "wheel" (Decode.map message (Decode.at [ "deltaY" ] Decode.int))
