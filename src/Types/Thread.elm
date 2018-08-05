module Types.Thread exposing (Thread, new)

import SmoothTerminal.Scalar exposing (Id(..))
import Types.Post as Post exposing (Post)


type alias Thread =
    { id : Id
    , title : String
    , posts : List Post
    }


new : Thread
new =
    { id = Id "adsfasdf"
    , title = "Some thread"
    , posts =
        [ Post.new
        , Post.new
        , Post.new
        ]
    }
