module Types.RemoteStory exposing (RemoteStory)

import Types.GetStoryResponse exposing (GetStoryResponse)
import Types.GraphqlData exposing (GraphqlData)


type alias RemoteStory =
    GraphqlData GetStoryResponse
