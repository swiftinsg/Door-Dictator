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
            .gesture(DragGesture(minimumDistance: 0,
                                 coordinateSpace: .local)
                .onChanged { value in
                    let newX = value.location.x / proxy.size.width
                    let newY = value.location.y / proxy.size.height
                    
                    var playHaptics = false
                    
                    if Int(point.x * 55) != Int(newX * 55) {
                        playHaptics = true
                    } else if Int(point.y * 31) != Int(newY * 31) {
                        playHaptics = true
                    }
                    
                    point = CGPoint(x: newX, y: newY)
                    
                    if playHaptics {
                        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
                    }
                })
        }
    }
}

#Preview {
    BulgeDemoView()
}
