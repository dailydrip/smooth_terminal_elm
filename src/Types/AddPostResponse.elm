module Types.AddPostResponse exposing (AddPostResponse)

import Types.Post exposing (Post)


type alias AddPostResponse =
    { post : Maybe Post
    }
