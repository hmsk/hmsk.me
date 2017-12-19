module Me exposing (..)

import Platform
import Html exposing (Html, div, text, strong, program, p, a, ul, li, i, img)
import Html.Attributes exposing (attribute)

type alias Account = (String, String, String)

accounts : List(Account)
accounts = 
    [ ("blog", "fas fa-edit", "http://hmsk.hatenablog.com")
    , ("photo", "fas fa-camera-retro", "http://pic.hmsk.me")
    , ("diary", "far fa-sticky-note", "http://hmsk.hatenablog.jp")
    , ("github", "fab fa-github", "https://github.com/hmsk")
    , ("instagram", "fab fa-instagram", "http://instagram.com/hmsk")
    , ("flickr", "fab fa-flickr", "http://flickr.com/photos/hmsk/")
    , ("500px", "fab fa-500px", "https://500px.com/hmsk")
    , ("twitter", "fab fa-twitter", "https://twitter.com/hmsk")
    , ("facebook", "fab fa-facebook", "https://facebook.com/hamachang")
    , ("tumblr", "fab fa-tumblr-square", "http://hmsk.tumblr.com/")
    , ("fitbit", "fas fa-heartbeat", "https://www.fitbit.com/user/243MYQ")
    , ("angellist", "fab fa-angellist", "https://angel.co/hmsk")
    , ("linkedin", "fab fa-linkedin", "http://www.linkedin.com/in/khmsk")
    , ("wishlist", "fas fa-gift", "http://www.amazon.co.jp/registry/wishlist/1U1J17EZM8CP1")
    ]

-- MODEL
type alias Model =
    { accounts: List(Account)
    }

init : ( Model, Cmd Msg )
init =
    (Model accounts, Cmd.none)

-- MESSAGES
type Msg
    = NoOp

-- VIEW
view : Model -> Html Msg
view model =
    div [ attribute "class" "container" ]
    [ img [ attribute "src" "https://www.gravatar.com/avatar/8358fe546d1b082b163f18a02eec145d?s=320" ] []
    , p [ attribute "class" "name" ]
        [ strong [] [text "@hmsk / Kengo Hamasaki"]
        , a [ attribute "href" "https://keybase.io/hmsk/key.asc", attribute "target" "_blank"]
            [ i [ attribute "class" "fas fa-key" ] [] ]
        , a [ attribute "href" "http://haiji.co", attribute "target" "_blank"]
            [ i [ attribute "class" "fas fa-heart" ] [] ]
        ]
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
