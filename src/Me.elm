module Me exposing (..)

import Platform
import Html exposing (Html, div, text, strong, program, p, a, ul, li, i, img)
import Html.Attributes exposing (attribute, style)
import MetaData exposing (..)

-- MODEL
type alias Model =
    { accounts: List(Account)
    }

init : ( Model, Cmd Msg )
init =
    (Model MetaData.accounts, Cmd.none)

-- MESSAGES
type Msg
    = NoOp

-- VIEW
view : Model -> Html Msg
view model =
    div [ attribute "class" "container" ]
    [ img [ attribute "src" MetaData.iconUrl ] []
    , p [ attribute "class" "name" ] [ text MetaData.myName ]
    , p [] (profilesLinksHtml MetaData.profiles)
    , ul [] (circleAccountList model.accounts)
    ]

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

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

circleAccountList : List(Account) -> List(Html msg)
circleAccountList (accounts) =
    List.indexedMap (\i account -> circleAccountHtml account (List.length accounts) i) accounts

circleAccountHtml : Account -> Int -> Int -> Html msg
circleAccountHtml (name, icon, url) len num =
    li [circularStyle len num] [
        a [ attribute "class" "button"
        , attribute "href" url
        , attribute "target" "_blank"
        ]
        [ i [attribute "class" icon] [] ]
    ]

circularStyle : Int -> Int -> Html.Attribute msg
circularStyle len num =
    let
        deg = 360 / toFloat(len) * toFloat(num)
    in
        style
            [ ("transform", "rotate(" ++ toString deg ++ "deg) translateY(-160px) rotate(" ++ toString (deg * -1) ++ "deg)")
            ]
