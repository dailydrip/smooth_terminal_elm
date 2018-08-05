module Types.Msg exposing (Msg(..))

import Form
import Types.RemoteThread exposing (RemoteThread)


type Msg
    = GotResponse RemoteThread
    | AddComment
    | AddedComment (Maybe String)
    | FormMsg Form.Msg
