//
//  BulgeEffectView.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/23/25.
//

import SwiftUI

struct BulgeEffectView: View {
    
    var points: [CGPoint] = []
    
    let maxPoints = 12
    
    init(points: [CGPoint] = []) {
        let paddedPoints = points + Array(repeating: CGPoint(x: 2, y: 2), count: maxPoints - points.count)
        
        self.points = paddedPoints
    }
    
    var body: some View {
        Image(.grid)
            .resizable()
            .scaledToFit()
            .visualEffect({ content, proxy in
                content
                    .layerEffect(ShaderLibrary.bulgeEffect(
                        .float2(proxy.size),
                        .float2(points[0]),
                        .float2(points[1]),
                        .float2(points[2]),
                        .float2(points[3]),
                        .float2(points[4]),
                        .float2(points[5]),
                        .float2(points[6]),
                        .float2(points[7]),
                        .float2(points[8]),
                        .float2(points[9]),
                        .float2(points[10]),
                        .float2(points[11])
                    ), maxSampleOffset: CGSize(width: 20, height: 20))
            })
    }
}

#Preview {
    BulgeEffectView()
}
