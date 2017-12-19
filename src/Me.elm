module Me exposing (..)

import Platform
import Html exposing (Html, div, text, strong, program, p, a, ul, li, i)
import Html.Attributes exposing (attribute)

type alias Account = (String, String, String)

accounts : List(Account)
accounts = 
    [ ("blog", "file-text", "http://hmsk.hatenablog.com")
    , ("photo", "camera-retro", "http://pic.hmsk.me")
    , ("diary", "paper-plane-o", "http://hmsk.hatenablog.jp")
    , ("github", "github", "https://github.com/hmsk")
    , ("instagram", "instagram", "http://instagram.com/hmsk")
    , ("flickr", "flickr", "http://flickr.com/photos/hmsk/")
    , ("500px", "500px", "https://500px.com/hmsk")
    , ("twitter", "twitter-square", "https://twitter.com/hmsk")
    , ("facebook", "facebook-official", "https://facebook.com/hamachang")
    , ("tumblr", "tumblr-square", "http://hmsk.tumblr.com/")
    , ("fitbit", "heartbeat", "https://www.fitbit.com/user/243MYQ")
    , ("angellist", "angellist", "https://angel.co/hmsk")
    , ("linkedin", "linkedin-square", "http://www.linkedin.com/in/khmsk")
    , ("wishlist", "gift", "http://www.amazon.co.jp/registry/wishlist/1U1J17EZM8CP1")
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
    div [ attribute "class" "container"]
    [ p []
        [ strong [] [text "hmsk / Kengo Hamasaki"]
        , a [ attribute "href" "https://keybase.io/hmsk/key.asc", attribute "target" "_blank"] [text "key"]
        , a [ attribute "href" "http://haiji.co", attribute "target" "_blank"] [text "partner"]
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
          [ i [attribute "class" ("fa fa-" ++ icon)] [] ]
    ]
