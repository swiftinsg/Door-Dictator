//
//  ContentView.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/23/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var server = Server()
    
    var body: some View {
        VStack {
            Text("Votes")
                .font(.largeTitle)
            
            HStack {
                VStack {
                    Text("Lock Votes")
                        .font(.title)
                    Text("\(server.lockVotes)")
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Divider()
                
                VStack {
                    Text("Unlock Votes")
                        .font(.title)
                    Text("\(server.unlockVotes)")
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .padding()
        .task {
            server.start()
        }
    }
}

#Preview {
    ContentView()
}
