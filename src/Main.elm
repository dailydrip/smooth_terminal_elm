module Main exposing (..)

--import Types.Thread as Thread exposing (Thread)

import Date exposing (Date)
import Form exposing (Form)
import Form.Field
import Form.Validate as Validate exposing (..)
import Graphqelm.Field as Field
import Graphqelm.Http
import Graphqelm.Operation exposing (RootMutation, RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, hardcoded, with)
import Html exposing (Html, div, h1, img, text)
import RemoteData exposing (RemoteData(..))
import SmoothTerminal.Mutation as Mutation
import SmoothTerminal.Object
import SmoothTerminal.Object.FirestormPost as FirestormPost
import SmoothTerminal.Object.FirestormThread as FirestormThread
import SmoothTerminal.Object.FirestormUser as FirestormUser
import SmoothTerminal.Object.Story as Story
import SmoothTerminal.Query as Query
import SmoothTerminal.Scalar
import Types.GetStoryResponse exposing (GetStoryResponse)
import Types.Msg exposing (Msg(..))
import Types.Post exposing (Post)
import Types.PostForm exposing (PostForm)
import Types.RemoteThread exposing (RemoteThread)
import Types.Story exposing (Story)
import Types.Thread exposing (Thread)
import Types.User exposing (User)
import Views.Thread


storyUid : String
storyUid =
    "hcq"


storyId : Int
storyId =
    60


graphqlEndpoint : String
graphqlEndpoint =
    "http://localhost:4000/graphql"



--import Views.Thread
---- MODEL ----


query : SelectionSet GetStoryResponse RootQuery
query =
    Query.selection GetStoryResponse
        |> with (Query.story { uid = storyUid } story)


story : SelectionSet Story SmoothTerminal.Object.Story
story =
    Story.selection Story
        |> with Story.id
        |> with (Story.commentsThread commentsThread)


commentsThread : SelectionSet Thread SmoothTerminal.Object.FirestormThread
commentsThread =
    FirestormThread.selection Thread
        |> with FirestormThread.title
        |> with (FirestormThread.posts posts)


posts : SelectionSet Post SmoothTerminal.Object.FirestormPost
posts =
    FirestormPost.selection Post
        |> with FirestormPost.body
        |> with (FirestormPost.user user)
        |> with (FirestormPost.insertedAt |> Field.map mapDatetime)


mapDatetime : SmoothTerminal.Scalar.DateTime -> Date
mapDatetime (SmoothTerminal.Scalar.DateTime str) =
    case Date.fromString str of
        Ok date ->
            date

        Err _ ->
            Date.fromTime 1532875938


user : SelectionSet User SmoothTerminal.Object.FirestormUser
user =
    FirestormUser.selection User
        |> with FirestormUser.username
        |> hardcoded "https://secure.gravatar.com/avatar/6bed913a657e07e88a2f6a30de677efa?d=https%3A%2F%2Fapi.adorable.io%2Favatars%2F256%2Fveetase%40adorable.png&s=256"


type alias Model =
    { thread : RemoteThread
    , form : Form () PostForm
    }


validation : Validation () PostForm
validation =
    map PostForm
        (field "body" string)


init : ( Model, Cmd Msg )
init =
    ( { thread = RemoteData.Loading
      , form = Form.initial [] validation
      }
    , getStory
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse thread ->
            ( { model | thread = thread }, Cmd.none )

        AddComment ->
            ( model, addComment model )

        AddedComment ->
            ( { model | form = Form.update validation (Form.Reset [ ( "body", Form.Field.string "" ) ]) model.form }, getStory )

        FormMsg formMsg ->
            let
                newForm =
                    Form.update validation formMsg model.form
            in
            case formMsg of
                Form.Submit ->
                    ( { model | form = newForm }, addComment model )

                _ ->
                    ( { model | form = newForm }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view { thread, form } =
    case thread of
        NotAsked ->
            text "Initializing..."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success response ->
            case response.story of
                Just story ->
                    case story.commentsThread of
                        Just thread ->
                            Views.Thread.view form thread

                        Nothing ->
                            text "no comments thread"

                Nothing ->
                    text "no story"



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


getStory : Cmd Msg
getStory =
    query
        |> Graphqelm.Http.queryRequest graphqlEndpoint
        |> withAuthorization
        |> Graphqelm.Http.send (RemoteData.fromResult >> GotResponse)


addCommentMutation : String -> SelectionSet GetStoryResponse RootMutation
addCommentMutation body =
    Mutation.selection GetStoryResponse
        |> with
            (Mutation.addComment { body = body, storyId = toString storyId } story)


addComment : Model -> Cmd Msg
addComment { form } =
    case Form.getOutput form of
        Nothing ->
            Cmd.none

        Just commentForm ->
            addCommentMutation commentForm.body
                |> Graphqelm.Http.mutationRequest graphqlEndpoint
                |> withAuthorization
                |> Graphqelm.Http.send (RemoteData.fromResult >> always AddedComment)


withAuthorization =
    let
        token =
            "SFMyNTY.eyJkYXRhIjp7ImlkIjoxfSwiZXhwIjoxNTMyOTM2NjAyfQ.YjhCkpKzF2yKOL3yJzw2C-GLuiUjgJXkEUJrhi7rlII"
    in
    Graphqelm.Http.withHeader "authorization" <| "Bearer " ++ token
