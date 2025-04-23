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
            Text("4 people stuck outside")
                .font(.system(size: 48))
                .padding(100)
            
            Spacer()
            
            VoteTallyView(unlock: server.unlockVotes, lock: server.lockVotes, isVotingOverruled: server.isVotingOverruled)
        }
        .padding()
        .task {
            server.start()
        }
        .frame(width: 1920, height: 1080)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
