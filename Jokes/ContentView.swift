//  ContentView.swift
//  Jokes

import SwiftUI
import AVFAudio

struct ContentView: View {
    enum JokeType: String, CaseIterable {
        case general, knock_knock, programming, anime, food, dad
    }
    
    @StateObject private var jokeVM = JokeViewModel()
    @State private var showPunchline = false
    @State private var selectedJoke = JokeType.general
    @State private var audioPlayer: AVAudioPlayer?
    @State private var soundNumber = 0
    @State private var isSoundEnabled = true
    @State private var showError = false
    let totalSounds = 25
    
    var body: some View {
        GeometryReader { geometry in
            let scaleFactor = min(geometry.size.width / 375, geometry.size.height / 667) // Scaling for smaller screens
            
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
                    Text("Setup:")
                        .foregroundColor(.red)
                        .bold()
                        .font(.system(size: scaledValue(20, scale: scaleFactor)))
                    
                    Text(jokeVM.joke.setup)
                        .font(.system(size: scaledValue(18, scale: scaleFactor)))
                        .minimumScaleFactor(0.5)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Group {
                        Text("Punchline:")
                            .foregroundColor(.red)
                            .bold()
                            .font(.system(size: scaledValue(20, scale: scaleFactor)))
                            .opacity(showPunchline ? 1 : 0)
                        
                        Text(jokeVM.joke.punchline)
                            .font(.system(size: scaledValue(18, scale: scaleFactor)))
                            .minimumScaleFactor(0.5)
                            .fixedSize(horizontal: false, vertical: true)
                            .opacity(showPunchline ? 1 : 0)
                    }
                    .animation(.easeInOut(duration: 0.3), value: showPunchline)
                }
                .padding(.horizontal, scaledValue(16, scale: scaleFactor))
                
                Spacer()
                
                // Sound Toggle
                Toggle("Enable Sound", isOn: $isSoundEnabled)
                    .padding(.horizontal, scaledValue(16, scale: scaleFactor))
                
                // Action Button
                Button(showPunchline ? "Get Joke" : "Show Punchline") {
                    if showPunchline {
                        fetchNewJoke()
                    } else if isSoundEnabled {
                        playSound(soundName: "\(soundNumber)")
                        soundNumber = (soundNumber + 1) % totalSounds
                    }
                    withAnimation(UIAccessibility.isReduceMotionEnabled ? nil : .easeInOut(duration: 0.3)) {
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
                fetchNewJoke()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Failed to fetch a new joke. Please check your internet connection.")
            }
        }
    }
    
    private func scaledValue(_ value: CGFloat, scale: CGFloat) -> CGFloat {
        return value * scale
    }
    
    private func formatJokeType(jokeType: JokeType) -> String {
        jokeType == .knock_knock ? "knock-knock" : jokeType.rawValue
    }
    
    private func fetchNewJoke() {
        jokeVM.urlString = "https://joke.deno.dev/type/\(formatJokeType(jokeType: selectedJoke))/1"
        Task {
            await jokeVM.getData()
            
            // Check if joke data was successfully fetched (assuming jokeVM provides an error state)
            if jokeVM.joke.setup.isEmpty {
                showError = true
            }
        }
    }
    
    private func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName), isSoundEnabled else { return }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer?.play()
        } catch {
            print("Error creating audioPlayer: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

