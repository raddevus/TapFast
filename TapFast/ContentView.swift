//
//  ContentView.swift
//  TapFast
//
//  Created by roger deutsch on 7/17/25.
//

import SwiftUI
import AVFoundation
import UIKit


struct ContentView: View {
    let rows = 18
    let columns = 10
    @State var audioPlayer:AVAudioPlayer?

     @State var isPlaying : Bool = false
    // Store tapped positions
        @State private var tappedSquares: Set<[Int]> = []

    var body: some View {
        GeometryReader { geometry in
            let squareSize = geometry.size.width / CGFloat(columns)

            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<columns, id: \.self) { column in
                            let isTapped = tappedSquares.contains([row, column])
                            Rectangle()
                                .fill(isTapped ? Color.white : randomColor())
                                .frame(width: squareSize, height: squareSize)
                                .border(Color.white, width: 1)
                                .onTapGesture {
                                    tappedSquares.insert([row, column])
                                    playPopSound()
                                    triggerHaptic()
                                    print("Tapped square at row \(row), column \(column)")
                                }
                        }
                    }
                   
                }
                Button("Reset", action: {
                    tappedSquares.removeAll()               }).padding(.top)
                
            }
            .frame(maxHeight: geometry.size.height)
            
        }
        //.edgesIgnoringSafeArea(.all)
    }

    // Generate a random color
    func randomColor() -> Color {
        Color(
            red: .random(in: 0.4...1),
            green: .random(in: 0.4...1),
            blue: .random(in: 0.4...1)
        )
    }
    
     func playPopSound() {
         if let path = Bundle.main.path(forResource: "pop2025", ofType: ".mp3") {

              self.audioPlayer = AVAudioPlayer()

              self.isPlaying.toggle()

              let url = URL(fileURLWithPath: path)

              do {
                  self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                  self.audioPlayer?.prepareToPlay()
                  self.audioPlayer?.play()
              }catch {
                  print("Error")
              }
          }
    }
    
    func triggerHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare() // Optional but helps responsiveness
        impact.impactOccurred()
    }

}
#Preview {
    ContentView()
}
