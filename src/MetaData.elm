module MetaData exposing (Account, accounts, iconUrl, myName, profiles)

import Html exposing (Html)
import Svg exposing (g, svg)
import Svg.Attributes exposing (class, d, fill, opacity, viewBox)


type alias Account =
    ( String, String, String )


myName : String
myName =
    "@hmsk"


iconUrl : String
iconUrl =
    "https://www.gravatar.com/avatar/8358fe546d1b082b163f18a02eec145d?s=320"


accounts : List Account
accounts =
    [ ( "GitHub", "github-brands", "https://github.com/hmsk" )
    , ( "LinkedIn", "linkedin-brands", "https://www.linkedin.com/in/hmsk" )
    , ( "Give a coffee", "coffee-togo-duotone", "https://www.buymeacoffee.com/hmsk" )
    , ( "Blog", "medium-m-brands", "https://medium.com/haiiro-io/tagged/code" )
    , ( "Essay (ja)", "pen-nib-duotone", "https://text.hmsk.me" )
    , ( "Instagram", "instagram-brands", "https://instagram.com/hmsk" )
    , ( "Podcast (ja)", "podcast-duotone", "https://anchor.fm/hmsk" )
    , ( "Twitter", "twitter-brands", "https://twitter.com/hmsk" )
    , ( "Facebook", "facebook-messenger-brands", "https://m.me/hamachang" )
    , ( "Flickr", "images-duotone", "https://flickr.com/hmsk" )
    , ( "Send a gift", "gifts-duotone", "https://www.amazon.com/hz/wishlist/ls/273IUDAQJR4QQ" )
    ]



-- Brand icon data comes from FontAwesome 5
-- Convert SVG data to elm/svg code with https://levelteams.com/svg-to-elm


profiles : List ( String, Html msg, String )
profiles =
    [ ( "key"
      , svg [ class "svg-inline--fa fa-fingerprint fa-w-16", viewBox "0 0 512 512" ] [ g [ class "fa-group" ] [ Svg.path [ class "fa-secondary", fill "currentColor", d "M506.1 203.57a24 24 0 1 0-46.87 10.34c4.71 21.41 4.91 37.41 4.7 61.6a24 24 0 0 0 23.8 24.2h.2a24 24 0 0 0 24-23.8c.18-22.18.4-44.11-5.83-72.34zM256.11 246a24 24 0 0 0-24 24 731.23 731.23 0 0 1-27.7 211.55c-2.73 9.72 2.15 30.49 23.12 30.49a24 24 0 0 0 23.09-17.52A774 774 0 0 0 280.1 270a24 24 0 0 0-23.99-24zM144.56 144.45a24 24 0 0 0-33.76 3.48 173.44 173.44 0 0 0-38.75 112A580.75 580.75 0 0 1 62.94 372a24 24 0 0 0 19.36 27.87c20.11 3.5 27.07-14.81 27.89-19.36a629 629 0 0 0 9.86-121.33 123.59 123.59 0 0 1 28-81 24 24 0 0 0-3.49-33.73z", opacity "0.4" ] [], Svg.path [ class "fa-primary", fill "currentColor", d "M466 112.85A266 266 0 0 0 252.8 0C183-.82 118.46 24.91 70.45 72.94A238.49 238.49 0 0 0 .13 246.65L0 268.12a24 24 0 0 0 23.28 24.69H24a24 24 0 0 0 24-23.3l.16-23.64a190.77 190.77 0 0 1 56.28-139C143.18 68.09 195.76 47.22 252.1 48a217.86 217.86 0 0 1 174.62 92.39A24 24 0 1 0 466 112.85zM254 82.12a178.75 178.75 0 0 0-45.78 5 24 24 0 1 0 11.06 46.72 143.52 143.52 0 0 1 34-3.69c75.43 1.13 137.73 61.5 138.88 134.58a881.07 881.07 0 0 1-5.58 113.63 24 24 0 0 0 21.11 26.58c16.72 1.95 25.51-11.88 26.58-21.11A929.94 929.94 0 0 0 440.19 264C438.63 165.2 355.12 83.62 254 82.12zm1.22 82.11c-61.26-.07-104 47.07-103.16 101.09a656.09 656.09 0 0 1-13.37 142.55 24 24 0 1 0 47 9.72 704 704 0 0 0 14.37-153c-.41-25.95 19.92-52.49 54.45-52.34 31.31.47 57.15 25.34 57.62 55.47a804 804 0 0 1-10.61 143.55 24 24 0 0 0 19.76 27.58c20 3.33 26.81-15.1 27.58-19.77A853 853 0 0 0 360.16 267c-.88-55.85-47.94-101.93-104.91-102.77z" ] [] ] ]
      , "https://keybase.io/hmsk/key.asc"
      )
    , ( "partner"
      , svg [ class "svg-inline--fa fa-rings-wedding fa-w-16", viewBox "0 0 512 512" ] [ g [ class "fa-group" ] [ Svg.path [ class "fa-secondary", fill "currentColor", d "M130.92 101.84L96 32l32-32h96l32 32-34.92 69.84a176.91 176.91 0 0 0-90.16 0zM350 160.56a207.16 207.16 0 0 1 29.06 72 111.89 111.89 0 1 1-96.46 4.95q-1.5-4.65-3.4-9.14l-.08-.2c-.39-.9-.78-1.8-1.19-2.69a3.54 3.54 0 0 0-.16-.34c-.41-.9-.84-1.79-1.27-2.68l-.09-.18q-1.44-2.91-3.06-5.73v-.07c-.5-.87-1-1.72-1.52-2.57-.11-.18-.22-.36-.34-.54-.43-.71-.87-1.41-1.33-2.11-.13-.21-.27-.42-.41-.63-.46-.7-.92-1.39-1.4-2.07L268 208q-1.8-2.58-3.74-5l-.48-.59c-.48-.61-1-1.21-1.47-1.81l-.67-.8c-.45-.53-.91-1.06-1.37-1.58l-.72-.83c-.49-.53-1-1.06-1.47-1.59l-.66-.72c-.71-.75-1.44-1.5-2.17-2.24a114.18 114.18 0 0 0-9.1-8.13 176.23 176.23 0 0 0-79.63 198.89A175.18 175.18 0 0 0 184 424.69q1.11 1.91 2.26 3.77c.76 1.24 1.54 2.46 2.34 3.68a.21.21 0 0 0 0 .06q1.18 1.82 2.42 3.6l.05.07q1.23 1.79 2.51 3.54c.85 1.18 1.73 2.35 2.61 3.5q1.33 1.75 2.72 3.46A176 176 0 1 0 350 160.56z", opacity "0.4" ] [], Svg.path [ class "fa-primary", fill "currentColor", d "M199 446.5a176 176 0 1 1 94-43 80.87 80.87 0 0 1-13.56-10.91 79.37 79.37 0 0 1-22.32-43.33 112 112 0 1 0-90.59 34.36A175.41 175.41 0 0 0 199 446.5z" ] [] ] ]
      , "https://namika.hmsk.co"
      )
    ]
