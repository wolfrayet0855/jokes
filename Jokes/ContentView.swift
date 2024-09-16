//
//  ContentView.swift
//  Jokes
//
//  Created by user on 5/15/24.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    enum JokeType: String, CaseIterable {
        case general, knock_knock, programming, anime, food, dad
    }
    
    
    @StateObject var jokeVM = JokeViewModel()
    @State private var showPunchline = false
    @State private var selectedJoke = JokeType.general
    @State private var audioPlayer: AVAudioPlayer!
    @State private var soundNumber = 0
    let totalSounds = 25
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Jokes! 😜")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                .background(.red)
            
            Group {
                Text("Setup:")
                    .foregroundColor(.red)
                    .bold()
                
                Text(jokeVM.joke.setup)
                    .animation(.default, value: jokeVM.joke.setup)
                    .frame(maxWidth: .infinity)
                    .lineLimit(nil)
                Spacer()
                
                if showPunchline {
                    Text("Punchline:")
                        .foregroundColor(.red)
                        .bold()
                    
                    Text(jokeVM.joke.punchline)
                            .frame(maxWidth: .infinity)
                            .lineLimit(nil)
                    
                }
                
                Spacer()
            }
            .font(.largeTitle)
            .padding(.horizontal)
            
            if showPunchline {
                Button("Get Joke") {
                    showPunchline.toggle()
                    jokeVM.urlString = "https://joke.deno.dev/type/\(formatJokeType(jokeType: selectedJoke))/1"
                    Task {
                        await jokeVM.getData()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity)
            } else {
                Button("Show Punchline") {
                    playSound(soundName: "\(soundNumber)")
                    soundNumber += 1
                    if soundNumber > totalSounds {
                        soundNumber = 0
                    }
                    showPunchline.toggle()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity)
            }
            HStack{
                Text("Joke Type:")
                    .bold()
                    .foregroundColor(.red)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Picker("", selection: $selectedJoke) {
                    ForEach(JokeType.allCases, id: \.self) { jokeType in
                        Text(formatJokeType(jokeType: jokeType))
                    }
                    
                    
                }
            }
            .padding()
        }
        .task {
            jokeVM.urlString =
            "https://joke.deno.dev/type/\(formatJokeType(jokeType: selectedJoke))/1"
            await jokeVM.getData()
        }
    }
    func formatJokeType(jokeType: JokeType) -> String {
        if jokeType == .knock_knock {
            return "knock-knock"
        } else {
            return jokeType.rawValue
        }
    }
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡Could not read file \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}
    #Preview {
        ContentView()
    }
