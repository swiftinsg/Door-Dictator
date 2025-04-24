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
        ZStack {
            BulgeEffectView(points: [
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.2, y: 0.2),
                CGPoint(x: 0.3, y: 0.3),
                CGPoint(x: 0.8, y: 0.2),
            ])
            
            VStack {
                Text("4 people stuck outside")
                    .font(.system(size: 48))
                    .padding(100)
                
                Spacer()
                
                VoteTallyView(unlock: server.unlockVotes, lock: server.lockVotes, isVotingOverruled: server.isVotingOverruled)
            }
        }
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
