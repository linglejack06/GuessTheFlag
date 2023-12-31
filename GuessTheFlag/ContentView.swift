//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jack Lingle on 11/22/23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var showingFinished = false;
    @State private var scoreTitle = ""
    @State private var score = 0;
    @State private var roundsPlayed = 0;
    @State private var flagTappedIndex = -1;
    var finishedString: String {
        "You finished with \(score) out of 8 possible points)"
    }
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.75, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                                .rotation3DEffect(
                                    .degrees(flagTappedIndex == number ? 360 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity((flagTappedIndex != -1 && flagTappedIndex != number) ? 0.25 : 1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(finishedString, isPresented: $showingFinished) {
            Button("Play Again", action: resetGame)
        }
    }
    func resetGame() {
        score = 0;
        roundsPlayed = 0;
        askQuestion()
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, you chose the flag of \(countries[number])"
            score -= 1
        }
        roundsPlayed += 1
        withAnimation {
            flagTappedIndex = number
        } completion: {
            if(roundsPlayed >= 8) {
                showingFinished = true
            } else {
                showingScore = true
            }
        }
    }
    func askQuestion() {
        countries.shuffle()
        flagTappedIndex = -1
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
