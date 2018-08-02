module Views.Thread exposing (view)

import Components.PostList as PostList
import Form exposing (Form)
import Form.Input as Input
import Html exposing (Html, button, div, h2, label, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick)
import Markdown
import Types.Msg exposing (Msg(..))
import Types.PostForm exposing (PostForm)
import Types.Thread exposing (Thread)


view : Form () PostForm -> Maybe String -> Thread -> Html Msg
view form error thread =
    div [ class "thread-view" ]
        [ errorView error
        , posts thread
        , commentForm form
        ]


errorView : Maybe String -> Html msg
errorView maybeError =
    case maybeError of
        Just error ->
            div [ class "notification-box -error" ] [ text error ]

        Nothing ->
            text ""


commentForm : Form () PostForm -> Html Msg
commentForm form =
    Html.map FormMsg (formView form)


formView : Form () PostForm -> Html Form.Msg
formView form =
    let
        -- error presenter
        errorFor field =
            case field.liveError of
                Just error ->
                    -- replace toString with your own translations
                    div [ class "error" ] [ text (toString error) ]

                Nothing ->
                    text ""

        -- fields states
        body =
            Form.getFieldAsString "body" form
    in
    div [ class "comment-form" ]
        [ label [] [ text "Body" ]
        , Input.textArea
            body
            [ value (Maybe.withDefault "" body.value)
            , placeholder "Be excellent to each other.\n**Markdown supported.**"
            ]
        , errorFor body
        , button
            [ onClick Form.Submit ]
            [ text "Submit" ]
        ]


posts : Thread -> Html Msg
posts thread =
    PostList.view thread.posts
