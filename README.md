Overview

The Jokes app is a fun SwiftUI application that delivers jokes of various types to entertain users. It allows users to choose the type of joke, view the setup, and reveal the punchline. The app also plays sound effects to enhance the user experience.

Features

Joke Types:
Select from multiple joke types, including General, Knock-Knock, Programming, Anime, Food, and Dad jokes.

Joke Setup and Punchline:
    View the joke setup and reveal the punchline with a button press.
    
Sound Effects:
    Plays different sound effects when showing the punchline.
    
Dynamic Content:
    Fetches jokes from an external API based on the selected joke type.


Code Overview

UI Elements
Title:
Displays "Jokes! 😜" at the top of the screen.
Joke Setup:
Shows the setup of the current joke.
Punchline:
Reveals the punchline of the joke when toggled.
Buttons:
"Show Punchline": Reveals the punchline and plays a sound effect.
"Get Joke": Fetches a new joke from the API.
Picker:
Allows users to select the type of joke.
Functionality
Joke Fetching:
Uses the JokeViewModel to fetch jokes from the API based on the selected joke type.
Sound Playback:
Plays sound effects using AVAudioPlayer when revealing the punchline.
Methods
formatJokeType(jokeType: JokeType) -> String
Formats the joke type for the API request.
playSound(soundName: String)
Plays a sound effect based on the provided sound name.
Setup

Requirements:

  Ensure that all necessary sound files are included in the project assets.

Configuration:

  Customize the list of joke types and sound effects as needed.

Running the App:
  Build and run the app in Xcode to start enjoying jokes and sound effects.
