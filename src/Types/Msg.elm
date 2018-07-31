module Types.Msg exposing (Msg(..))

import Form
import Types.RemoteStory exposing (RemoteStory)


type Msg
    = GotResponse RemoteStory
    | AddComment
    | AddedComment (Maybe String)
    | FormMsg Form.Msg
