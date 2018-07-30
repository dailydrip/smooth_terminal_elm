module Types.RemoteThread exposing (RemoteThread)

import Graphqelm.Http
import RemoteData exposing (RemoteData)
import Types.GetStoryResponse exposing (GetStoryResponse)


type alias RemoteThread =
    RemoteData (Graphqelm.Http.Error GetStoryResponse) GetStoryResponse
