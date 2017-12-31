module Me exposing (..)

import Platform
import Html exposing (Html, div, text, strong, program, p, a, ul, li, i, img)
import Html.Attributes exposing (attribute, style)
import Keyboard exposing (..)
import Char exposing (fromCode)

import MetaData exposing (..)

-- MODEL
type alias Model =
    { accounts: List(Account)
    , rotation: Int
    }

init : ( Model, Cmd Msg )
init =
    ({ accounts = MetaData.accounts
    ,  rotation = 0
    }, Cmd.none)

-- MESSAGES
type Msg
    = Presses Char

-- VIEW
view : Model -> Html Msg
view model =
    div [ attribute "class" "container" ]
    [ img [ attribute "src" MetaData.iconUrl ] []
    , p [ attribute "class" "name" ] [ text MetaData.myName ]
    , p [] (profilesLinksHtml MetaData.profiles)
    , ul [] (circleAccountList model.accounts model.rotation)
    ]

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Presses code ->
            case code of
                'j' ->
                    ({ model | rotation = model.rotation + 1 }, Cmd.none)
                'k' ->
                    ({ model | rotation = model.rotation - 1 }, Cmd.none)
                _ ->
                    (model, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses (\code -> Presses (fromCode code))

-- MAIN
main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

profilesLinksHtml : List(Account) -> List(Html msg)
profilesLinksHtml (accounts) =
    List.map profileLink  accounts

profileLink : Account -> Html msg
profileLink (_, icon, url) =
    a [ attribute "href" url, attribute "target" "_blank"]
      [ i [ attribute "class" icon ] [] ]

circleAccountList : List(Account) -> Int -> List(Html msg)
circleAccountList accounts rotation =
    List.indexedMap (\i account -> circleAccountHtml account (List.length accounts) i rotation) accounts

circleAccountHtml : Account -> Int -> Int -> Int -> Html msg
circleAccountHtml (name, icon, url) len num rotation =
    li [circularStyle len num rotation] [
        a [ attribute "class" "button"
        , attribute "href" url
        , attribute "target" "_blank"
        ]
        [ i [attribute "class" icon] [] ]
    ]

circularStyle : Int -> Int -> Int -> Html.Attribute msg
circularStyle len num rotation =
    let
        one = 360 / toFloat(len)
        deg = one * toFloat(num) + one * toFloat(rotation)
    in
        style
            [ ("transform", "rotate(" ++ toString deg ++ "deg) translateY(-160px) rotate(" ++ toString (deg * -1) ++ "deg)")
            , ("transition", "0.8s ease-in-out")
            ]
