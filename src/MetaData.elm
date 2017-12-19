module MetaData exposing (..)

type alias Account = (String, String, String)

myName : String
myName = "@hmsk / Kengo Hamasaki"

iconUrl : String
iconUrl = "https://www.gravatar.com/avatar/8358fe546d1b082b163f18a02eec145d?s=320"

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

profiles : List(Account)
profiles =
    [ ("key", "fas fa-key", "https://keybase.io/hmsk/key.asc")
    , ("partner", "fas fa-heart", "http://haiji.co")
    ]
