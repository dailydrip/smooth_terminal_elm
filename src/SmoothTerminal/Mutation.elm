-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module SmoothTerminal.Mutation exposing (..)

import Graphqelm.Field as Field exposing (Field)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import SmoothTerminal.InputObject
import SmoothTerminal.Interface
import SmoothTerminal.Object
import SmoothTerminal.Scalar
import SmoothTerminal.Union


{-| Select fields to build up a top-level mutation. The request can be sent with
functions from `Graphqelm.Http`.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) RootMutation
selection constructor =
    Object.selection constructor


type alias AddCommentRequiredArguments =
    { body : String, storyId : String }


addComment : AddCommentRequiredArguments -> SelectionSet decodesTo SmoothTerminal.Object.Story -> Field (Maybe decodesTo) RootMutation
addComment requiredArgs object =
    Object.selectionField "addComment" [ Argument.required "body" requiredArgs.body Encode.string, Argument.required "storyId" requiredArgs.storyId Encode.string ] object (identity >> Decode.nullable)