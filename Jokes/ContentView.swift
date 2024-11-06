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
        GeometryReader { geometry in
            // Calculate scaling factor based on screen width
            let scaleFactor = min(geometry.size.width / 375, geometry.size.height / 667) // Base iPhone SE 2022 size
            
            VStack(alignment: .leading, spacing: scaledValue(16, scale: scaleFactor)) {
                // Header
                Text("Jokes! 😜")
                    .font(.system(size: scaledValue(32, scale: scaleFactor), weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(scaledValue(16, scale: scaleFactor))
                    .background(Color.red)
                    .cornerRadius(scaledValue(8, scale: scaleFactor))
                
                // Joke Content
                VStack(alignment: .leading, spacing: scaledValue(8, scale: scaleFactor)) {
                    // Setup Label
                    Text("Setup:")
                        .foregroundColor(.red)
                        .bold()
                        .font(.system(size: scaledValue(20, scale: scaleFactor)))
                    
                    // Setup Text
                    Text(jokeVM.joke.setup)
                        .font(.system(size: scaledValue(18, scale: scaleFactor)))
                        .minimumScaleFactor(0.5)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Reserve space for Punchline to prevent layout shifts
                    Group {
                        Text("Punchline:")
                            .foregroundColor(.red)
                            .bold()
                            .font(.system(size: scaledValue(20, scale: scaleFactor)))
                            .opacity(showPunchline ? 1 : 0)
                        
                        Text(jokeVM.joke.punchline)
                            .font(.system(size: scaledValue(18, scale: scaleFactor)))
                            .minimumScaleFactor(0.5)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .opacity(showPunchline ? 1 : 0)
                    }
                    .animation(.easeInOut(duration: 0.3), value: showPunchline)
                }
                .padding(.horizontal, scaledValue(16, scale: scaleFactor))
                
                Spacer()
                
                // Action Buttons
                Button(showPunchline ? "Get Joke" : "Show Punchline") {
                    if showPunchline {
                        // Fetch a new joke
                        jokeVM.urlString = "https://joke.deno.dev/type/\(formatJokeType(jokeType: selectedJoke))/1"
                        Task {
                            await jokeVM.getData()
                        }
                    } else {
                        // Show punchline
                        playSound(soundName: "\(soundNumber)")
                        soundNumber = (soundNumber + 1) % totalSounds
                    }
                    withAnimation {
                        showPunchline.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .font(.system(size: scaledValue(20, scale: scaleFactor), weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, scaledValue(16, scale: scaleFactor))
                .padding(.bottom, scaledValue(16, scale: scaleFactor))
                
                // Joke Type Picker
                HStack {
                    Text("Joke Type:")
                        .bold()
                        .foregroundColor(.red)
                        .font(.system(size: scaledValue(18, scale: scaleFactor)))
                    
                    Spacer()
                    
                    Picker("", selection: $selectedJoke) {
                        ForEach(JokeType.allCases, id: \.self) { jokeType in
                            Text(formatJokeType(jokeType: jokeType))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: scaledValue(150, scale: scaleFactor))
                }
                .padding(.horizontal, scaledValue(16, scale: scaleFactor))
                .padding(.bottom, scaledValue(16, scale: scaleFactor))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(UIColor.systemBackground))
            .onAppear {
                // Initial data fetch
                jokeVM.urlString = "https://joke.deno.dev/type/\(formatJokeType(jokeType: selectedJoke))/1"
                Task {
                    await jokeVM.getData()
                }
            }
            .scaleEffect(scaleFactor)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
    
    // Helper function to scale values based on screen size
    func scaledValue(_ value: CGFloat, scale: CGFloat) -> CGFloat {
        return value * scale
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
            print("😡 Could not read file \(soundName)")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

