# Joke Assembly

A SwiftUI application that fetches random jokes from a remote API, displays them to the user, and allows saving favorites. This project demonstrates basic data fetching, SwiftUI layout, audio playback, and local data persistence using `UserDefaults`.

## Overview

The **Joke Assembly** allows users to:
- Fetch a random joke from [joke.deno.dev](https://joke.deno.dev) based on a selected **Joke Type** (e.g., *general*, *dad*, *knock-knock*).  
- Toggle whether or not the punchline is shown.  
- Play a short audio clip (if enabled) when revealing the punchline.  
- Save jokes to a **Favorites** list using `UserDefaults`.  
- View and delete saved jokes from the **Favorites** list.

The UI is built in **SwiftUI**, with a simple `TabView` to switch between **Home** and **Favorites** screens.

---

## Code Structure

### JokeViewModel.swift

- **Purpose**:  
  - Fetches jokes from the remote API using `URLSession` and `async/await`.  
  - Decodes the JSON into a `Joke` model.  
  - Maintains a list of **favorite jokes**, which are stored in `UserDefaults`.

- **Key Methods**:  
  1. `getData()`: Makes a network call to fetch jokes.  
  2. `addToFavorites(_ joke: Joke)`: Saves a selected joke to the `favoriteJokes` array.  
  3. `loadFavorites()` & `saveFavorites()`: Handle persistence of favorites in `UserDefaults`.  

### ContentView.swift

- **Purpose**:  
  - Acts as the main screen (and root of the `TabView`).  
  - Contains **Home** UI elements:
    - **Get Joke** button: Fetch a new joke on demand.  
    - **Punchline** button: Reveals the punchline, optionally playing a sound effect.  
    - **Star Icon** (blue): Adds the current joke to **Favorites**.
  - Showcases an **enum** of joke types (e.g. `.dad`, `.food`, `.anime`) which can be selected from a **Picker** to filter jokes.

- **Additional UI Details**:  
  - A `Toggle` to enable or disable sound effects.  
  - A `Spacer()` to organize layout.  
  - Animations and transitions for showing/hiding the punchline.

### FavoritesView.swift

- **Purpose**:  
  - Displays the user’s **favorite jokes** in a `List`.  
  - Uses SwiftUI’s `.onDelete` to allow swipe-to-delete functionality.  
  - Provides a **scrollable** list to handle multiple favorite jokes.  
  - Shows the **setup** in black and the **punchline** in cyan.  

---

## Setup & Requirements

1. **Platform**: iOS (SwiftUI-based).  
2. **Xcode**: Version 14 or later is recommended.  
3. **Swift version**: 5.6 or later.  
4. **iOS Deployment Target**: iOS 15+ (adjust as needed in your Xcode project settings).

### Steps to Run Locally

1. **Clone** or download the repository.  
2. **Open** the `.xcodeproj` or `.xcworkspace` file in Xcode.  
3. **Select** an iOS simulator (e.g., iPhone 14).  
4. **Press** the *Run* button (\▶) to build and launch the app.

You should see two tabs at the bottom: **Home** and **Favorites**. Fetch jokes on demand using the **Get Joke** button, toggle punchlines, and save jokes to favorites.

---

## How to Contribute

We welcome contributions from the community. Here are the steps to contribute:

1. **Fork** this repository.  
   - Click the “Fork” button in the top-right corner of the GitHub page.  

2. **Create a New Branch** for your feature or bug fix.  
   - ```bash
     git checkout -b feature/amazing_feature
     ```  

3. **Make Changes & Commit**  
   - Implement your feature or fix the bug.  
   - Test thoroughly.  
   - Commit changes with clear, concise messages:
     ```bash
     git commit -m "Add amazing feature"
     ```  

4. **Push** to Your Fork  
   - ```bash
     git push origin feature/amazing_feature
     ```  

5. **Open a Pull Request**  
   - In your fork on GitHub, click the *Compare & pull request* button.  
   - Provide a detailed description of your changes, including any relevant issue references.

6. **Code Review & Merging**  
   - The maintainers will review your pull request.  
   - Discuss any suggested changes.  
   - Once approved, your contribution will be merged.

Please follow the code style, naming conventions, and best practices established in the project to keep the codebase consistent.

