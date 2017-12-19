module Me exposing (..)

import Platform
import Html exposing (Html, div, text, strong, program, p, a, ul, li, i, img)
import Html.Attributes exposing (attribute)
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
    , p [ attribute "class" "name" ]
        ([ strong [] [ text MetaData.myName ] ] ++ profilesLinksHtml MetaData.profiles)
    , ul [] (listedAccountHtml model.accounts)
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

listedAccountHtml : List(Account) -> List(Html msg)
listedAccountHtml (accounts) =
    List.map accountHtml accounts

accountHtml : Account -> Html msg
accountHtml (name, icon, url) =
    li [] [
        a [ attribute "class" "button"
          , attribute "href" url
          , attribute "target" "_blank"
          ]
          [ i [attribute "class" icon] [] ]
    ]
