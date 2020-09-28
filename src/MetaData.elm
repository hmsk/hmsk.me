module MetaData exposing (Account, myName, iconUrl, accounts, profiles)


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


profiles : List Account
profiles =
    [ ( "key", "fingerprint-duotone", "https://keybase.io/hmsk/key.asc" )
    , ( "partner", "rings-wedding-duotone", "https://namika.hmsk.co" )
    ]
