module Types.GraphqlData exposing (GraphqlData)

import Graphqelm.Http
import RemoteData exposing (RemoteData)


type alias GraphqlData a =
    RemoteData (Graphqelm.Http.Error a) a
