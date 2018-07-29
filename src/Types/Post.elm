module Types.Post exposing (Post, new)

import Date exposing (Date)
import Types.User as User exposing (User)


type alias Post =
    { body : String
    , author : User
    , insertedAt : Date
    }


new : Post
new =
    { body = "Some body"
    , author = User.new
    , insertedAt = Date.fromTime 1532875938
    }
