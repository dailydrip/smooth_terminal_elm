module Types.User exposing (User, new)


type alias User =
    { username : String
    , avatarUrl : String
    }


new : User
new =
    { username = "Bobby"
    , avatarUrl = "https://secure.gravatar.com/avatar/6bed913a657e07e88a2f6a30de677efa?d=https%3A%2F%2Fapi.adorable.io%2Favatars%2F256%2Fveetase%40adorable.png&s=256"
    }
