//
//  VoteTallyView.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/23/25.
//

import SwiftUI

struct VoteTallyView: View {
    
    var unlock: Int
    var lock: Int
    
    private let width = 1920.0 - 200
    
    var body: some View {
        HStack(spacing: 0) {
            let effectiveLock = Double(max(lock, 1))
            let effectiveUnlock = Double(max(unlock, 1))
            
            let effectiveTotalVotes = effectiveLock + effectiveUnlock
            
            Rectangle()
                .foregroundStyle(.green)
                .frame(width: width * effectiveUnlock / effectiveTotalVotes)
                .overlay(alignment: .leading) {
                    HStack {
                        Image(systemName: "lock.open.fill")
                        
                        Text("\(unlock)")
                            .monospacedDigit()
                            .contentTransition(.numericText(value: Double(unlock)))
                    }
                    .padding()
                    .font(.system(size: 48))
                    .foregroundStyle(.black)
                }
            
            Rectangle()
                .foregroundStyle(.red)
                .frame(width: width * effectiveLock / effectiveTotalVotes)
                .overlay(alignment: .trailing) {
                    HStack {
                        Text("\(lock)")
                            .monospacedDigit()
                            .contentTransition(.numericText(value: Double(lock)))
                        
                        Image(systemName: "lock.fill")
                    }
                    .padding()
                    .font(.system(size: 48))
                    .foregroundStyle(.white)
                }
        }
        .frame(height: 100)
        .padding(.bottom, 100)
        .animation(.easeInOut(duration: 0.5), value: unlock)
        .animation(.easeInOut(duration: 0.5), value: lock)
    }
}

#Preview {
    VoteTallyView(unlock: 0, lock: 0)
}
