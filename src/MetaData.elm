module MetaData exposing (..)


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
    [ ( "LinkedIn", "fab fa-linkedin-in", "https://www.linkedin.com/in/hmsk" )
    , ( "Give a coffee", "far fa-coffee-togo", "https://www.buymeacoffee.com/hmsk" )
    , ( "Blog (en)", "fab fa-medium-m", "https://medium.com/haiiro-io/tagged/code" )
    , ( "Blog (ja)", "far fa-edit", "https://hmsk.hatenablog.com" )
    , ( "Essay (ja)", "far fa-pen-nib", "https://hmsk.hatenablog.jp" )
    , ( "GitHub", "fab fa-github-alt", "https://github.com/hmsk" )
    , ( "Instagram", "fab fa-instagram", "https://instagram.com/hmsk" )
    , ( "Twitch", "fab fa-twitch", "https://www.twitch.tv/hmsk" )
    , ( "500px", "fab fa-500px", "https://500px.com/hmsk" )
    , ( "Twitter", "fab fa-twitter", "https://twitter.com/hmsk" )
    , ( "Facebook", "fab fa-facebook", "https://facebook.com/hamachang" )
    , ( "Fitbit", "far fa-running", "https://www.fitbit.com/user/243MYQ" )
    , ( "AngelList", "fab fa-angellist", "https://angel.co/hmsk" )
    , ( "Wish List", "far fa-gifts", "https://www.amazon.com/hz/wishlist/ls/273IUDAQJR4QQ" )
    ]


profiles : List Account
profiles =
    [ ( "key", "fad fa-fingerprint", "https://keybase.io/hmsk/key.asc" )
    , ( "partner", "fad fa-rings-wedding", "https://namika.hmsk.co" )
    ]
