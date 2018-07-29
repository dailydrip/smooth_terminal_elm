module Views.Thread exposing (view)

import Components.PostList as PostList
import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (class)
import Types.Thread exposing (Thread)


view : Thread -> Html msg
view thread =
    div [ class "thread-view" ]
        [ header thread
        , posts thread
        ]


header : Thread -> Html msg
header { title } =
    div [ class "thread-header" ]
        [ div [ class "split" ]
            [ h2 [] [ text title ]
            ]
        ]


posts : Thread -> Html msg
posts { posts } =
    PostList.view posts
