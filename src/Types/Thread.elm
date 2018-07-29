module Types.Thread exposing (Thread, new)

import Types.Post as Post exposing (Post)


type alias Thread =
    { title : String
    , posts : List Post
    }


new : Thread
new =
    { title = "Some thread"
    , posts =
        [ Post.new
        , Post.new
        , Post.new
        ]
    }
