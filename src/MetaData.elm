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
    [ ( "Blog", "fas fa-edit", "http://hmsk.hatenablog.com" )
    , ( "Photo", "fas fa-camera-retro", "http://pic.hmsk.me" )
    , ( "Essay", "far fa-sticky-note", "http://hmsk.hatenablog.jp" )
    , ( "GitHub", "fab fa-github", "https://github.com/hmsk" )
    , ( "Instagram", "fab fa-instagram", "http://instagram.com/hmsk" )
    , ( "Flickr", "fab fa-flickr", "http://flickr.com/photos/hmsk/" )
    , ( "500px", "fab fa-500px", "https://500px.com/hmsk" )
    , ( "Twitter", "fab fa-twitter", "https://twitter.com/hmsk" )
    , ( "Facebook", "fab fa-facebook", "https://facebook.com/hamachang" )
    , ( "Tumblr", "fab fa-tumblr-square", "http://hmsk.tumblr.com/" )
    , ( "Fitbit", "fas fa-heartbeat", "https://www.fitbit.com/user/243MYQ" )
    , ( "AngelList", "fab fa-angellist", "https://angel.co/hmsk" )
    , ( "LinkedIn", "fab fa-linkedin", "http://www.linkedin.com/in/khmsk" )
    , ( "Wishlist", "fas fa-gift", "http://www.amazon.co.jp/registry/wishlist/1U1J17EZM8CP1" )
    ]


profiles : List Account
profiles =
    [ ( "key", "fas fa-key", "https://keybase.io/hmsk/key.asc" )
    , ( "partner", "fas fa-heart", "http://haiji.co" )
    ]
