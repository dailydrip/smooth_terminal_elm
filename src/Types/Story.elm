module Types.Story exposing (Story)

import Types.Thread exposing (Thread)


type alias Story =
    { id : Int
    , commentsThread : Maybe Thread
    , uid : Maybe String
    }
