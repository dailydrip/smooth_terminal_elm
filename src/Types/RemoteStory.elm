module Types.RemoteStory exposing (RemoteStory)

import Graphqelm.Http
import RemoteData exposing (RemoteData)
import Types.GetStoryResponse exposing (GetStoryResponse)


type alias RemoteStory =
    RemoteData (Graphqelm.Http.Error GetStoryResponse) GetStoryResponse
