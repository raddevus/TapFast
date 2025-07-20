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
    @State private var catCounter = 1
    @State var imageName = String(format: "cat%03d", 1)
    
    var body: some View {
        ZStack {
            // Background image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
            
            // Grid overlay
            GeometryReader { geometry in
                let squareSize = min(geometry.size.width / CGFloat(columns),
                                     geometry.size.height / CGFloat(rows))
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        ForEach(0..<rows, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<columns, id: \.self) { column in
                                    let isTapped = tappedSquares.contains([row, column])
                                    Rectangle()
                                        .fill(isTapped ? Color.white.opacity(0.0) : randomColor())
                                        .frame(width: squareSize, height: squareSize)
                                        .border(isTapped ? Color.clear : Color.white.opacity(0.3), width: 1)
                                        .onTapGesture {
                                            tappedSquares.insert([row, column])
                                            playPopSound()
                                            triggerHaptic()
                                            print("Tapped square at row \(row), column \(column)")
                                        }
                                }
                            }
                        }
                    }
                    .frame(width: squareSize * CGFloat(columns),
                           height: squareSize * CGFloat(rows))
                    .background(Color.clear)
                    
                }
                
            }
            
        }
        // TopMost Layer in ZStack
        Button("Reset") {
            tappedSquares.removeAll()
            catCounter += 1
            if catCounter > 20{
                catCounter = 1
            }
            imageName = String(format: "cat%03d", catCounter)
        }
        .font(.headline)
        .padding(.top)
        
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
