
//
//  Joke.swift
//  Jokes
//
//  Created by user on 5/15/24.
//

import Foundation

struct Joke: Codable, Equatable {
    var type = ""
    var setup = ""
    var punchline = ""
    
    // Equatable helps us check for duplicates in favorites, if needed
    static func == (lhs: Joke, rhs: Joke) -> Bool {
        return lhs.setup == rhs.setup && lhs.punchline == rhs.punchline
    }
}
