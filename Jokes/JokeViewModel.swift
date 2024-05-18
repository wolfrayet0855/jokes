//
//  JokeViewModel.swift
//  Jokes
//
//  Created by user on 5/15/24.
//

import Foundation

@MainActor
class JokeViewModel: ObservableObject {
    @Published var joke = Joke()
    var urlString = "https://joke.deno.dev"
    
    func getData() async {
        print ("🕸️ We are accessing the url \((urlString))")
        
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not convert \(urlString) to a URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
               let  jokes = try JSONDecoder().decode([Joke].self, from: data)
                joke = jokes.first ?? Joke ()
                print("Setup: \(joke.setup)")
                print("Punchline: \(joke.punchline)")
            } catch {
            print("😡 JSON ERROR: Could not decode JSON data.\(error.localizedDescription)")
            }
        } catch {
        print ("😡 ERROR: Could not get data from URL: \(urlString). \(error.localizedDescription)")
        }
    }
}
