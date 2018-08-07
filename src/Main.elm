module Main exposing (..)

import Date exposing (Date)
import Form exposing (Form)
import Form.Field
import Form.Validate as Validate exposing (..)
import Graphqelm.Field as Field
import Graphqelm.Http
import Graphqelm.Operation exposing (RootMutation, RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, hardcoded, with)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (Value)
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (RemoteData(..))
import SmoothTerminal.Mutation as Mutation
import SmoothTerminal.Object
import SmoothTerminal.Object.FirestormPost as FirestormPost
import SmoothTerminal.Object.FirestormThread as FirestormThread
import SmoothTerminal.Object.FirestormUser as FirestormUser
import SmoothTerminal.Query as Query
import SmoothTerminal.Scalar
import Types.AddPostResponse exposing (AddPostResponse)
import Types.GetThreadResponse exposing (GetThreadResponse)
import Types.GraphqlData exposing (GraphqlData)
import Types.Msg exposing (Msg(..))
import Types.Post exposing (Post)
import Types.PostForm exposing (PostForm)
import Types.RemoteThread exposing (RemoteThread)
import Types.Thread exposing (Thread)
import Types.User exposing (User)
import Views.Thread


---- MODEL ----


query : String -> SelectionSet GetThreadResponse RootQuery
query threadId =
    Query.selection GetThreadResponse
        |> with (Query.firestormThread { id = threadId } thread)


thread : SelectionSet Thread SmoothTerminal.Object.FirestormThread
thread =
    FirestormThread.selection Thread
        |> with FirestormThread.id
        |> with FirestormThread.title
        |> with (FirestormThread.posts post)


post : SelectionSet Post SmoothTerminal.Object.FirestormPost
post =
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
        |> with FirestormUser.avatarUrl


type alias Flags =
    { threadId : String
    , token : String
    , graphqlEndpoint : String
    }


type alias Model =
    { thread : RemoteThread
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
            { thread = RemoteData.NotAsked
            , form = Form.initial [] validation
            , flags = flags
            , error = Nothing
            }

        newCmd =
            getThreadFromModel newModel
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
        |> required "threadId" Decode.string
        |> required "token" Decode.string
        |> required "graphqlEndpoint" Decode.string


getThreadFromModel : Model -> Cmd Msg
getThreadFromModel { flags } =
    case flags of
        Nothing ->
            Cmd.none

        Just flags ->
            getThread flags.threadId flags.token flags.graphqlEndpoint



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse thread ->
            ( { model | thread = thread }, Cmd.none )

        AddComment ->
            ( model, addComment model )

        AddedComment maybeString ->
            ( { model
                | form = Form.initial [] validation
              }
            , getThreadFromModel model
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
view { thread, form, error } =
    div [ class "firestorm-thread-comments" ]
        [ case thread of
            NotAsked ->
                text "Initializing..."

            Loading ->
                text "Loading."

            Failure err ->
                text ("Error: " ++ toString err)

            Success response ->
                case response.thread of
                    Just thread ->
                        Views.Thread.view form error thread

                    Nothing ->
                        text "no thread"
        ]



---- PROGRAM ----


main : Program Value Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


getThread : String -> String -> String -> Cmd Msg
getThread threadId token graphqlEndpoint =
    threadId
        |> query
        |> Graphqelm.Http.queryRequest graphqlEndpoint
        |> withAuthorization token
        |> Graphqelm.Http.send (RemoteData.fromResult >> GotResponse)


addCommentMutation : SmoothTerminal.Scalar.Id -> String -> SelectionSet AddPostResponse RootMutation
addCommentMutation (SmoothTerminal.Scalar.Id threadId) body =
    Mutation.selection AddPostResponse
        |> with
            (Mutation.addComment { body = body, firestormThreadId = threadId } post)


addComment : Model -> Cmd Msg
addComment { thread, form, flags } =
    case flags of
        Nothing ->
            Cmd.none

        Just flags ->
            case Form.getOutput form of
                Nothing ->
                    Cmd.none

                Just commentForm ->
                    case thread of
                        Success response ->
                            case response.thread of
                                Nothing ->
                                    Cmd.none

                                Just thread ->
                                    addCommentMutation thread.id commentForm.body
                                        |> Graphqelm.Http.mutationRequest flags.graphqlEndpoint
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
