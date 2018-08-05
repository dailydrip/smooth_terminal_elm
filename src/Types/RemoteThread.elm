module Types.RemoteThread exposing (RemoteThread)

import Types.GetThreadResponse exposing (GetThreadResponse)
import Types.GraphqlData exposing (GraphqlData)


type alias RemoteThread =
    GraphqlData GetThreadResponse
