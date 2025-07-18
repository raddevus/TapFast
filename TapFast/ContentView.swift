//
//  ContentView.swift
//  TapFast
//
//  Created by roger deutsch on 7/17/25.
//

import SwiftUI


struct ContentView: View {
    let rows = 18
    let columns = 10
    
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
                                .fill(isTapped ? Color.black : randomColor())
                                .frame(width: squareSize, height: squareSize)
                                .border(Color.white, width: 1)
                                .onTapGesture {
                                    tappedSquares.insert([row, column])
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
}
#Preview {
    ContentView()
}
