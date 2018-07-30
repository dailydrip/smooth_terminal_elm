module Types.Msg exposing (Msg(..))

import Form
import Types.RemoteThread exposing (RemoteThread)


type Msg
    = GotResponse RemoteThread
    | AddComment
    | AddedComment
    | FormMsg Form.Msg
