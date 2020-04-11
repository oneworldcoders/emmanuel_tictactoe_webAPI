# emmanuel_tictactoe_webAPI
A web api that interacts with an existing tic tac toe game

[![Build Status](https://travis-ci.org/oneworldcoders/emmanuel_tictactoe_webAPI.svg?branch=master)](https://travis-ci.org/oneworldcoders/emmanuel_tictactoe_webAPI)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tictactoe_web'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tictactoe_web

## Usage

Utilise the endpoints below.

Using Postman interact with the app here: https://emmanuel-tic-tac-toe.herokuapp.com/


## API endpoints for the application
All endpoints require strictly JSON data

Request|URL|Description
---|---|---
**GET**|`/`|Get the rules
expected result
```
{
    "message": "Welcome. . ."
}
```

Request|URL|Description
---|---|---
**GET**|`/games`|Returns all the games played
Expected result. 

* The state is an array of 9.

* The turn is a single character 'X' or 'O'
```
{
    "games": {
        "<game_id>": {
            "state": <List(9)>
            "turn": <str>
        },
        "<game_id>": {
            "state": <List(9)>
            "turn": <str>
        }
        . . .
    }
}
```

Request|URL|Description
---|---|---
**GET**|`/available_moves/:game_id`|Fetches the avalable moves of a game
**Note:** The moves are from 1 to 9

Expected result:
```
{
    "available_moves": [1, 2, 3, 4, 5, 6, 7, 8, 9]
}
```
On Error:
```
{
    "error": {
        "game": "game <int> hasn't yet started"
    }
}
```

Request|URL|Description
---|---|---
**POST**|`/startgame`|To start a new game
This Endpoint takes a key of `game_id`
```
{
    "game_id" : <int>
}
```
The expected return object should look like this when succesful:
```
{
    "messgae": "game started successfully",
    "game_data": {
        "<game_id>": {
            "state": ["", "", "", "", "", "",  "", "", ""],
            "turn": "X"
        }
    }
}
```
On Error:
```
{
    "error": {
        "game": "game <game_id> already exists"
    }
}
```

Request|URL|Description
---|---|---
**POST**|`/play`|Make a move
* The data passed must contain a game_id, position and player.
* The position is from 1 to 9
* The player is either 1 or 2

Succesive moves will eventually lead to a win or draw

**Note:** The id must be that of a game that already started

```
{
	"game_id": <int>,
	"position": <int>,
	"player": <int>
}
```
A successful post should return the game state:
```
{
    "game": ["X", "", "", "", "", "", "", "", ""]
    
}
---------------------
* * A win
{
    "win": "Player 1 is Winner"
}
----------------------
* * A draw
{
    "draw": "Draw"
}
```
On Eroor:
```
{
    "error": {
        "game": "<error message>",
        . . .
    }
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/oneworldcoders/emmanuel_tic-tac-toe

