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
    [ ( "LinkedIn", "linkedin-brands", "https://www.linkedin.com/in/hmsk" )
    , ( "Give a coffee", "coffee-togo-duotone", "https://www.buymeacoffee.com/hmsk" )
    , ( "Blog (en)", "medium-m-brands", "https://medium.com/haiiro-io/tagged/code" )
    , ( "Essay (ja)", "pen-nib-duotone", "https://text.hmsk.me" )
    , ( "GitHub", "github-brands", "https://github.com/hmsk" )
    , ( "Instagram", "instagram-brands", "https://instagram.com/hmsk" )
    , ( "Twitter", "twitter-brands", "https://twitter.com/hmsk" )
    , ( "Facebook", "facebook-messenger-brands", "https://m.me/hamachang" )
    , ( "Fitbit", "weight-duotone", "https://www.fitbit.com/user/243MYQ" )
    , ( "Photos (Flickr)", "images-duotone", "https://flickr.com/hmsk" )
    , ( "AngelList", "angellist-brands", "https://angel.co/hmsk" )
    , ( "Send a gift", "gifts-duotone", "https://www.amazon.com/hz/wishlist/ls/273IUDAQJR4QQ" )
    ]


profiles : List Account
profiles =
    [ ( "key", "fingerprint-duotone", "https://keybase.io/hmsk/key.asc" )
    , ( "partner", "rings-wedding-duotone", "https://namika.hmsk.co" )
    ]
