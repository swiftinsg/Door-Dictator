//
//  BulgeDemoView.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/24/25.
//

import SwiftUI

struct BulgeDemoView: View {
    
    @State private var point = CGPoint(x: 0.5, y: 0.5)
    
    var body: some View {
        GeometryReader { proxy in
            BulgeEffectView(points: [
                point
            ])
            .onContinuousHover(coordinateSpace: .local, perform: { phase in
                switch phase {
                case .active(let cgPoint):
                    let newX = cgPoint.x / proxy.size.width
                    let newY = cgPoint.y / proxy.size.height
                    
                    var feedback: NSHapticFeedbackManager.FeedbackPattern?
                    
                    if Int(point.x * 55) != Int(newX * 55) {
                        feedback = .levelChange
                        
                        if Int(newX * 55) % 5 == 0 {
                            feedback = .alignment
                        }
                    } else if Int(point.y * 31) != Int(newY * 31) {
                        feedback = .levelChange
                        
                        if Int(newY * 31) % 5 == 0 {
                            feedback = .alignment
                        }
                    }
                    
                    point = CGPoint(x: newX, y: newY)
                    
                    if let feedback {
                        NSHapticFeedbackManager.defaultPerformer.perform(feedback, performanceTime: .now)
                    }
                case .ended: break
                }
            })
        }
    }
}

#Preview {
    BulgeDemoView()
}
