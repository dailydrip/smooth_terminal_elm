-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module SmoothTerminal.Object.FirestormThread exposing (..)

import Graphqelm.Field as Field exposing (Field)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import SmoothTerminal.InputObject
import SmoothTerminal.Interface
import SmoothTerminal.Object
import SmoothTerminal.Scalar
import SmoothTerminal.Union


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) SmoothTerminal.Object.FirestormThread
selection constructor =
    Object.selection constructor


id : Field SmoothTerminal.Scalar.Id SmoothTerminal.Object.FirestormThread
id =
    Object.fieldDecoder "id" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map SmoothTerminal.Scalar.Id)


posts : SelectionSet decodesTo SmoothTerminal.Object.FirestormPost -> Field (List decodesTo) SmoothTerminal.Object.FirestormThread
posts object =
    Object.selectionField "posts" [] object (identity >> Decode.list)


slug : Field String SmoothTerminal.Object.FirestormThread
slug =
    Object.fieldDecoder "slug" [] Decode.string


title : Field String SmoothTerminal.Object.FirestormThread
title =
    Object.fieldDecoder "title" [] Decode.string


user : SelectionSet decodesTo SmoothTerminal.Object.FirestormUser -> Field decodesTo SmoothTerminal.Object.FirestormThread
user object =
    Object.selectionField "user" [] object identity