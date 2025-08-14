module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes as HA
import Http
import Json.Decode as Decode exposing (Decoder)


-- MODEL

type alias Photo =
    { title : String
    , date : String
    , tags : List String
    , description : String
    , image : String
    }

type alias Model =
    { photos : List Photo
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { photos = [] }
    , Http.get
        { url = "/photos.json"
        , expect = Http.expectJson GotPhotos photosDecoder
        }
    )


-- UPDATE

type Msg
    = GotPhotos (Result Http.Error (List Photo))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPhotos (Ok ps) ->
            ( { model | photos = ps }, Cmd.none )

        GotPhotos (Err _) ->
            ( model, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
    Html.main_
        []
        [ Html.h2
            []
            [ Html.text "Portfolio"
            ]
        , Html.div []
            (List.map viewPhoto model.photos)
        ]

viewPhoto : Photo -> Html Msg
viewPhoto p =
    Html.div []
        [ Html.img [ HA.src p.image, HA.alt p.title ] []
        , Html.div [] [ Html.text p.title ]
        , Html.div [] [ Html.text p.description ]
        ]


-- DECODER

photosDecoder : Decoder (List Photo)
photosDecoder =
    Decode.list photoDecoder

photoDecoder : Decoder Photo
photoDecoder =
    Decode.map5 Photo
        (Decode.field "title" Decode.string)
        (Decode.field "date" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.field "description" Decode.string)
        (Decode.field "image" Decode.string)


-- MAIN

main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }

