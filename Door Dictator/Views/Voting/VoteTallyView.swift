//
//  VoteTallyView.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/23/25.
//

import SwiftUI

struct VoteTallyView: View {
    
    @Namespace var namespace
    
    var unlock: Int
    var lock: Int
    
    var isVotingOverruled: Bool
    
    private let width = 1920.0 - 200
    
    var body: some View {
        HStack(spacing: 0) {
            let effectiveLock = Double(max(lock, 1))
            let effectiveUnlock = Double(max(unlock, 1))
            
            let effectiveTotalVotes = effectiveLock + effectiveUnlock
            
            Rectangle()
                .foregroundStyle(.green)
                .frame(width: isVotingOverruled ? width : width * effectiveUnlock / effectiveTotalVotes)
                .overlay(alignment: .leading) {
                    if !isVotingOverruled {
                        HStack {
                            Image(systemName: "lock.open.fill")
                                .matchedGeometryEffect(id: "unlock", in: namespace)
                            
                            Text("\(unlock)")
                                .monospacedDigit()
                                .contentTransition(.numericText(value: Double(unlock)))
                                .matchedGeometryEffect(id: "unlock.count", in: namespace)
                        }
                        .padding()
                        .font(.system(size: 48))
                        .foregroundStyle(.black)
                    }
                }
                .overlay {
                    if isVotingOverruled {
                        HStack {
                            Image(systemName: "lock.open.fill")
                                .matchedGeometryEffect(id: "unlock", in: namespace)
                            
                            Text("Door Unlocked")
                                .matchedGeometryEffect(id: "unlock.count", in: namespace)
                        }
                        .padding()
                        .font(.system(size: 48))
                        .foregroundStyle(.black)
                    }
                }
            
            Rectangle()
                .foregroundStyle(.red)
                .frame(width: isVotingOverruled ? .leastNormalMagnitude : width * effectiveLock / effectiveTotalVotes)
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
        .clipShape(.rect(cornerRadius: 16))
        .padding(.bottom, 100)
        .animation(.easeInOut(duration: 0.5), value: unlock)
        .animation(.easeInOut(duration: 0.5), value: lock)
        .animation(.easeInOut(duration: 0.5), value: isVotingOverruled)
    }
}

#Preview {
    VoteTallyView(unlock: 0, lock: 0, isVotingOverruled: false)
}
