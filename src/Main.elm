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
import Json.Decode as Decode exposing (Value)
import Json.Decode.Pipeline exposing (decode, required)
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
import Types.GraphqlData exposing (GraphqlData)
import Types.Msg exposing (Msg(..))
import Types.Post exposing (Post)
import Types.PostForm exposing (PostForm)
import Types.RemoteStory exposing (RemoteStory)
import Types.Story exposing (Story)
import Types.Thread exposing (Thread)
import Types.User exposing (User)
import Views.Thread


graphqlEndpoint : String
graphqlEndpoint =
    "http://localhost:4000/graphql"



--import Views.Thread
---- MODEL ----


query : String -> SelectionSet GetStoryResponse RootQuery
query storyUid =
    Query.selection GetStoryResponse
        |> with (Query.story { uid = storyUid } story)


story : SelectionSet Story SmoothTerminal.Object.Story
story =
    Story.selection Story
        |> with Story.id
        |> with (Story.commentsThread commentsThread)
        |> with Story.uid


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


type alias Flags =
    { storyUid : String
    , token : String
    }


type alias Model =
    { story : RemoteStory
    , form : Form () PostForm
    , flags : Maybe Flags
    , error : Maybe String
    }


validation : Validation () PostForm
validation =
    map PostForm
        (field "body" string)


init : Value -> ( Model, Cmd Msg )
init flagsValue =
    let
        flags =
            decodeFlags flagsValue

        newModel =
            { story = RemoteData.Loading
            , form = Form.initial [] validation
            , flags = flags
            , error = Nothing
            }

        newCmd =
            case flags of
                Nothing ->
                    Cmd.none

                Just { storyUid, token } ->
                    getStory storyUid token
    in
    ( newModel, newCmd )


decodeFlags : Value -> Maybe Flags
decodeFlags json =
    json
        |> Decode.decodeValue flagsDecoder
        |> Result.toMaybe


flagsDecoder : Decode.Decoder Flags
flagsDecoder =
    decode Flags
        |> required "storyUid" Decode.string
        |> required "token" Decode.string


getStoryFromModel : Model -> Cmd Msg
getStoryFromModel model =
    case model.flags of
        Nothing ->
            Cmd.none

        Just flags ->
            getStory flags.storyUid flags.token



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse story ->
            ( { model | story = story }, Cmd.none )

        AddComment ->
            ( model, addComment model )

        AddedComment maybeString ->
            ( { model
                | form =
                    Form.update validation
                        (Form.Reset
                            [ ( "body", Form.Field.string "" )
                            ]
                        )
                        model.form
              }
            , getStoryFromModel model
            )

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
view { story, form, error } =
    case story of
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
                            Views.Thread.view form error thread

                        Nothing ->
                            text "no comments thread"

                Nothing ->
                    text "no story"



---- PROGRAM ----


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


getStory : String -> String -> Cmd Msg
getStory storyUid token =
    storyUid
        |> query
        |> Graphqelm.Http.queryRequest graphqlEndpoint
        |> withAuthorization token
        |> Graphqelm.Http.send (RemoteData.fromResult >> GotResponse)


addCommentMutation : Int -> String -> SelectionSet GetStoryResponse RootMutation
addCommentMutation storyId body =
    Mutation.selection GetStoryResponse
        |> with
            (Mutation.addComment { body = body, storyId = toString storyId } story)


addComment : Model -> Cmd Msg
addComment { story, form, flags } =
    case flags of
        Nothing ->
            Cmd.none

        Just flags ->
            case Form.getOutput form of
                Nothing ->
                    Cmd.none

                Just commentForm ->
                    case story of
                        Success response ->
                            case response.story of
                                Nothing ->
                                    Cmd.none

                                Just story ->
                                    addCommentMutation story.id commentForm.body
                                        |> Graphqelm.Http.mutationRequest graphqlEndpoint
                                        |> withAuthorization flags.token
                                        |> Graphqelm.Http.send
                                            (RemoteData.fromResult
                                                >> mapRemoteDataToMaybeString
                                                >> AddedComment
                                            )

                        _ ->
                            Cmd.none


mapRemoteDataToMaybeString : GraphqlData a -> Maybe String
mapRemoteDataToMaybeString _ =
    Nothing


withAuthorization token =
    Graphqelm.Http.withHeader "authorization" <| "Bearer " ++ token
