module Types.GetStoryResponse exposing (GetStoryResponse)

import Types.Story exposing (Story)


type alias GetStoryResponse =
    { story : Maybe Story
    }
