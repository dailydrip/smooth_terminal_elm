module Components.PostList exposing (view)

import Date exposing (Date)
import Date.Format
import Html exposing (Html, a, abbr, div, img, li, ol, text)
import Html.Attributes exposing (class, href, src, title)
import Types.Post exposing (Post)


view : List Post -> Html msg
view posts =
    ol [ class "post-list" ] (viewPosts posts)


viewPosts : List Post -> List (Html msg)
viewPosts posts =
    posts
        |> List.map
            (\post ->
                li [] [ viewPost post ]
            )


viewPost : Post -> Html msg
viewPost post =
    div [ class "post-item" ]
        [ itemMetadata post
        , body post
        ]


itemMetadata : Post -> Html msg
itemMetadata post =
    div
        [ class "item-metadata" ]
        [ avatar post
        , a [ class "username", href "#" ] [ text ("@" ++ post.author.username) ]
        , timeAbbr post.insertedAt
        ]


timeAbbr : Date -> Html msg
timeAbbr date =
    let
        timeString =
            Date.Format.formatISO8601 date
    in
    abbr
        [ class "time"
        , title timeString
        ]
        [ text timeString ]


avatar : Post -> Html msg
avatar post =
    div
        [ class "avatar" ]
        [ img [ src post.author.avatarUrl, class "user-avatar -borderless" ] []
        ]


body : Post -> Html msg
body post =
    div [ class "body" ]
        [ text post.body ]
