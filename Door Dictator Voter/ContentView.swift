//
//  ContentView.swift
//  Door Dictator Voter
//
//  Created by Jia Chen Yee on 4/25/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var client = Client()
    
    var body: some View {
        VStack {
            Text("Door Dictator Voter")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack {
                Button {
                    client.unlock += 1
                } label: {
                    VStack {
                        Image(systemName: "lock.open.fill")
                        Text("Open Door")
                    }
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .tint(.green)
                
                Button {
                    client.lock += 1
                } label: {
                    VStack {
                        Image(systemName: "lock.fill")
                        Text("Leave Door Closed")
                    }
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .tint(.red)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 16))
        }
        .padding()
        .task {
            await client.startTimerLoop()
        }
    }
}

#Preview {
    ContentView()
}
