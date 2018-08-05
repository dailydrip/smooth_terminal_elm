module Types.GetThreadResponse exposing (GetThreadResponse)

import Types.Thread exposing (Thread)


type alias GetThreadResponse =
    { thread : Maybe Thread
    }
